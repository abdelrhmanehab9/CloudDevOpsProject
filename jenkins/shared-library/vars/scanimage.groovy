def call(Map params = [:]) {
    def imageName = params.imageName
    def imageTag = params.imageTag
    def severity = params.severity ?: "HIGH,CRITICAL"
    
    if (!imageName || !imageTag) {
        error "scanImage: 'imageName' and 'imageTag' are required!"
    }
    
    echo "🔍 Scanning image with Trivy: ${imageName}:${imageTag}"
    
    // تحقق من وجود Trivy
    def trivyInstalled = sh(script: "command -v trivy", returnStatus: true)
    
    if (trivyInstalled != 0) {
        echo "⚠️ Warning: Trivy is not installed. Skipping image scan."
        echo "ℹ️ To install Trivy on Ubuntu/Debian:"
        echo "   sudo apt-get update"
        echo "   sudo apt-get install wget apt-transport-https gnupg lsb-release -y"
        echo "   wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -"
        echo "   echo \"deb https://aquasecurity.github.io/trivy-repo/deb \$(lsb_release -sc) main\" | sudo tee -a /etc/apt/sources.list.d/trivy.list"
        echo "   sudo apt-get update"
        echo "   sudo apt-get install trivy -y"
        return
    }
    
    try {
        sh """
            echo "Running Trivy scan with severity: ${severity}"
            trivy image --severity ${severity} --exit-code 0 --no-progress --format table ${imageName}:${imageTag}
        """
        echo "✅ Trivy scan completed successfully"
    } catch (Exception e) {
        echo "⚠️ Warning: Trivy scan failed but continuing pipeline: ${e.message}"
    }
}
