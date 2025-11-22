def call(Map params = [:]) {

    def imageName = params.imageName
    def imageTag = params.imageTag
    def severity = params.severity ?: "HIGH,CRITICAL"

    if (!imageName || !imageTag) {
        error "scanImage: 'imageName' and 'imageTag' are required!"
    }

    echo "Scanning image with Trivy: ${imageName}:${imageTag}"

    sh """
        trivy image --severity ${severity} --exit-code 0 --no-progress ${imageName}:${imageTag}
    """

    echo "Trivy scan completed"
}

