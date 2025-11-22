def call(Map params = [:]) {

    def manifestDir = params.manifestDir
    def imageName = params.imageName
    def imageTag = params.imageTag

    if (!manifestDir || !imageName || !imageTag) {
        error "updateManifests: 'manifestDir', 'imageName', and 'imageTag' are required!"
    }

    echo "Updating manifests in: ${manifestDir}"

    sh """
        find ${manifestDir} -type f -name "*.yaml" -print0 | \
        xargs -0 sed -i "s|image: .*|image: ${imageName}:${imageTag}|g"
    """

    echo "Manifests updated to: ${imageName}:${imageTag}"
}

