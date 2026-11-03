plugins {
    id("vitrine.android-library")
    alias(libs.plugins.composeCompiler)
}
android {
    namespace = "video.vitrine.feature.export"
    buildFeatures {
        compose = true
        buildConfig = true
    }
    defaultConfig {
        val apkSha = providers.gradleProperty("vvApkSha256").orNull ?: ""
        buildConfigField("String", "VV_APK_SHA256", "\"$apkSha\"")
        // Audit D40 : BackendSync/BgmStore cote export (quota, telemetrie, BGM).
        val apiBaseUrl = providers.gradleProperty("vvApiBaseUrl").orNull ?: "https://vitrine-video-api.mdgejcinfluence.workers.dev"
        buildConfigField("String", "API_BASE_URL", "\"" + apiBaseUrl + "\"")
    }
    testOptions { unitTests.isIncludeAndroidResources = true }
}
dependencies {
    implementation(libs.work.runtime.ktx)
    implementation(libs.room.runtime)
    implementation(libs.room.ktx)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.core.ktx)
    implementation(libs.media3.transformer)
    // D42-F17 : Presentation (cadrage d'export) vit dans media3-effect ;
    // declare explicitement plutot que de dependre de la transitivite.
    implementation(libs.media3.effect)
    implementation(project(":core-model"))
    implementation(project(":core-designsystem"))
    implementation(project(":ins-effects"))
    implementation(project(":ins-capture"))
    implementation(project(":ins-thermal"))
    implementation(libs.androidx.lifecycle.runtime)
    implementation(project(":core-guard"))
    implementation(project(":vvguard"))
    implementation(platform(libs.compose.bom))
    implementation(libs.compose.material3)
    implementation(libs.compose.ui)
    implementation(libs.compose.ui.tooling.preview)
    implementation(libs.activity.compose)
    implementation(project(":data"))
    testImplementation(libs.junit)
    testImplementation(libs.robolectric)
    testImplementation(libs.compose.ui.test.junit4)
    testImplementation(libs.compose.ui.test.manifest)
}
