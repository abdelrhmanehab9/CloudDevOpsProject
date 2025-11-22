def call(Map params = [:]) {

    def imageName = params.imageName
    def imageTag = params.imageTag

    if (!imageName || !imageTag) {
        error "pushImage: 'imageName' and 'imageTag' are required!"
    }

    echo "Pushing Docker image to registry..."

    sh """
        docker push ${imageName}:${imageTag}
        docker push ${imageName}:latest
    """

    echo "Image pushed: ${imageName}:${imageTag}"
}

