plugins { id("vitrine.android-library") }
android { namespace = "video.vitrine.feature.editor" }
dependencies {
    implementation(project(":core-model"))
    implementation(project(":core-designsystem"))
    implementation(project(":ins-effects"))
    implementation(project(":data"))
}
