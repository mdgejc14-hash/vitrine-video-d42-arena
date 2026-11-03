plugins {
    id("vitrine.android-library")
    alias(libs.plugins.composeCompiler)
}
android {
    namespace = "video.vitrine.feature.catalog"
    buildFeatures {
        compose = true
        buildConfig = true
    }
    defaultConfig {
        // C15 : endpoint injectable au build (-PvvApiBaseUrl=http://10.0.2.2:3200 pour QA
        // contre le mock staging local). Defaut = production, inchange, zero breaking.
        val apiBaseUrl = providers.gradleProperty("vvApiBaseUrl").orNull ?: "https://vitrine-video-api.mdgejcinfluence.workers.dev"
        buildConfigField("String", "API_BASE_URL", "\"" + apiBaseUrl + "\"")
    }
    testOptions { unitTests.isIncludeAndroidResources = true }
}
dependencies {
    implementation(project(":core-model"))
    implementation(project(":data"))
    implementation(project(":core-designsystem"))
    implementation(libs.androidx.activity)
    implementation(libs.androidx.lifecycle.runtime)
    implementation(libs.coroutines.android)
    implementation(libs.room.runtime)
    implementation(libs.room.ktx)
    implementation(platform(libs.compose.bom))
    implementation(libs.compose.material3)
    implementation(libs.compose.ui)
    implementation(libs.compose.ui.tooling.preview)
    implementation(libs.activity.compose)
    testImplementation(libs.junit)
    testImplementation(libs.robolectric)
    testImplementation(libs.compose.ui.test.junit4)
    testImplementation(libs.compose.ui.test.manifest)
}
