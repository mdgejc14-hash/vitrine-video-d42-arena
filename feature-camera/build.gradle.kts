plugins {
    id("vitrine.android-library")
    alias(libs.plugins.composeCompiler)
}
android {
    namespace = "video.vitrine.feature.camera"
    buildFeatures {
        compose = true
        buildConfig = true
    }
    defaultConfig {
        // Audit D41 (F56) : envoi des consentements R4 au serveur (route
        // POST /api/v1/consents existante, jamais appelee par le client).
        val apiBaseUrl = providers.gradleProperty("vvApiBaseUrl").orNull ?: "https://vitrine-video-api.mdgejcinfluence.workers.dev"
        buildConfigField("String", "API_BASE_URL", "\"" + apiBaseUrl + "\"")
    }
    testOptions { unitTests.isIncludeAndroidResources = true }
}
dependencies {
    implementation(libs.camerax.view)
    implementation(libs.camerax.core)
    implementation(libs.camerax.lifecycle)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.lifecycle.runtime)
    implementation(project(":core-model"))
    implementation(project(":core-designsystem"))
    implementation(project(":ins-capture"))
    implementation(project(":ins-effects"))
    implementation(platform(libs.compose.bom))
    implementation(libs.compose.material3)
    implementation(libs.compose.ui)
    implementation(libs.compose.ui.tooling.preview)
    implementation(libs.activity.compose)
    implementation(project(":data"))
    implementation(libs.room.runtime)
    implementation(libs.room.ktx)
    testImplementation(libs.junit)
    testImplementation(libs.robolectric)
    testImplementation(libs.compose.ui.test.junit4)
    testImplementation(libs.compose.ui.test.manifest)
}
