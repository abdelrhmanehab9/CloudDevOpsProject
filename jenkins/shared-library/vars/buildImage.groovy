def call(Map params = [:]) {

    def imageName = params.imageName
    def imageTag = params.imageTag
    def dockerfile = params.dockerfile ?: "Dockerfile"
    def context = params.context ?: "."

    if (!imageName || !imageTag) {
        error "buildImage: 'imageName' and 'imageTag' are required!"
    }

    echo "Building Docker image: ${imageName}:${imageTag}"

    sh """
        docker build -t ${imageName}:${imageTag} -f ${dockerfile} ${context}
        docker tag ${imageName}:${imageTag} ${imageName}:latest
    """

    echo "Docker image built successfully: ${imageName}:${imageTag}"
}

