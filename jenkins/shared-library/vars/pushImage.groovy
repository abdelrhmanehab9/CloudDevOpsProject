def call(Map params = [:]) {
    def imageName = params.imageName
    def imageTag = params.imageTag
    
    if (!imageName || !imageTag) {
        error "pushImage: 'imageName' and 'imageTag' are required!"
    }
    
    echo "📤 Pushing Docker image to registry..."
    
    try {
        sh """
            echo "Pushing ${imageName}:${imageTag}..."
            docker push ${imageName}:${imageTag}
            
            echo "Pushing ${imageName}:latest..."
            docker push ${imageName}:latest
        """
        echo "✅ Image pushed successfully: ${imageName}:${imageTag}"
    } catch (Exception e) {
        error "❌ Failed to push image: ${e.message}"
    }
}
