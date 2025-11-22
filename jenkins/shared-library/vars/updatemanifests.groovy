def call(Map params = [:]) {
    def manifestDir = params.manifestDir
    def imageName = params.imageName
    def imageTag = params.imageTag
    
    if (!manifestDir || !imageName || !imageTag) {
        error "updateManifests: 'manifestDir', 'imageName', and 'imageTag' are required!"
    }
    
    echo "📝 Updating manifests in: ${manifestDir}"
    
    // تحقق من وجود المجلد
    def dirExists = sh(script: "test -d ${manifestDir} && echo 'exists' || echo 'not found'", returnStdout: true).trim()
    
    if (dirExists == 'not found') {
        echo "⚠️ Warning: Directory ${manifestDir} not found. Skipping manifest update."
        return
    }
    
    sh """
        find ${manifestDir} -type f -name "*.yaml" -o -name "*.yml" | while read file; do
            echo "Updating file: \$file"
            sed -i "s|image:.*${imageName}:.*|image: ${imageName}:${imageTag}|g" "\$file"
        done
    """
    echo "✅ Manifests updated to: ${imageName}:${imageTag}"
}
