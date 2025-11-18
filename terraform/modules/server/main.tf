# ============================================
# File: terraform/modules/server/main.tf
# Purpose: Jenkins EC2 instance with CloudWatch monitoring
# ============================================

# -------------------
# 1. Get Latest Amazon Linux 2 AMI
# -------------------
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# -------------------
# 2. Security Group for Jenkins
# -------------------
resource "aws_security_group" "jenkins" {
  name        = "${var.project_name}-${var.environment}-jenkins-sg"
  description = "Security group for Jenkins server"
  vpc_id      = var.vpc_id

  # SSH Access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins Web Interface
  ingress {
    description = "Jenkins Web"
    from_port   = var.jenkins_port
    to_port     = var.jenkins_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All Outbound Traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-sg"
  }
}

# -------------------
# 3. IAM Role for EC2 (CloudWatch permissions)
# -------------------
resource "aws_iam_role" "jenkins" {
  name = "${var.project_name}-${var.environment}-jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-role"
  }
}

# -------------------
# 4. Attach CloudWatch Policy to Role
# -------------------
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# -------------------
# 5. Instance Profile
# -------------------
resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.project_name}-${var.environment}-jenkins-profile"
  role = aws_iam_role.jenkins.name
}

# -------------------
# 6. Jenkins EC2 Instance
# -------------------
resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins.name

  monitoring = true  # Enable detailed monitoring

  user_data = <<-EOF
              #!/bin/bash
              # Update system
              yum update -y
              
              # Install CloudWatch Agent
              wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
              rpm -U ./amazon-cloudwatch-agent.rpm
              
              # Create CloudWatch configuration
              cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json <<'EOC'
              {
                "metrics": {
                  "namespace": "Jenkins/EC2",
                  "metrics_collected": {
                    "cpu": {
                      "measurement": [
                        {"name": "cpu_usage_idle", "rename": "CPU_IDLE", "unit": "Percent"},
                        {"name": "cpu_usage_iowait", "rename": "CPU_IOWAIT", "unit": "Percent"}
                      ],
                      "metrics_collection_interval": 60,
                      "totalcpu": false
                    },
                    "disk": {
                      "measurement": [
                        {"name": "used_percent", "rename": "DISK_USED", "unit": "Percent"}
                      ],
                      "metrics_collection_interval": 60,
                      "resources": ["*"]
                    },
                    "mem": {
                      "measurement": [
                        {"name": "mem_used_percent", "rename": "MEM_USED", "unit": "Percent"}
                      ],
                      "metrics_collection_interval": 60
                    }
                  }
                },
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/jenkins/jenkins.log",
                          "log_group_name": "/aws/ec2/jenkins",
                          "log_stream_name": "{instance_id}/jenkins.log"
                        }
                      ]
                    }
                  }
                }
              }
              EOC
              
              # Start CloudWatch Agent
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config \
                -m ec2 \
                -s \
                -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json
              EOF

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins"
  }
}

# -------------------
# 7. CloudWatch Log Group
# -------------------
resource "aws_cloudwatch_log_group" "jenkins" {
  name              = "/aws/ec2/jenkins"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-logs"
  }
}

# -------------------
# 8. CloudWatch Alarm - High CPU
# -------------------
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-jenkins-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors EC2 CPU utilization"

  dimensions = {
    InstanceId = aws_instance.jenkins.id
  }
}

# -------------------
# 9. CloudWatch Alarm - Status Check Failed
# -------------------
resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  alarm_name          = "${var.project_name}-${var.environment}-jenkins-status-check"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "0"
  alarm_description   = "This metric monitors EC2 status checks"

  dimensions = {
    InstanceId = aws_instance.jenkins.id
  }
}
