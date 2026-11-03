plugins {
    id("vitrine.android-library")
    alias(libs.plugins.composeCompiler)
}
android {
    namespace = "video.vitrine.core.designsystem"
    buildFeatures {
        compose = true
    }
}
dependencies {
    api(project(":core-model"))
    api(libs.androidx.activity)
    implementation(platform(libs.compose.bom))
    implementation(libs.compose.material3)
    implementation(libs.compose.ui)
    implementation(libs.compose.ui.tooling.preview)
}
