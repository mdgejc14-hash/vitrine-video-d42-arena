plugins {
    id("vitrine.android-library")
    alias(libs.plugins.composeCompiler)
}
android {
    namespace = "video.vitrine.feature.onboarding"
    testOptions { unitTests.isIncludeAndroidResources = true }
    buildFeatures {
        buildConfig = true
        compose = true
    }
    defaultConfig {
        val googleClientId =
            providers.gradleProperty("vvGoogleServerClientId").orNull
                ?: "REMPLACE_PAR_CLIENT_ID_WEB.apps.googleusercontent.com"
        val firebaseApiKey =
            providers.gradleProperty("vvFirebaseApiKey").orNull ?: "REMPLACE_PAR_API_KEY"
        val firebaseAppId =
            providers.gradleProperty("vvFirebaseAppId").orNull ?: "1:0:android:0"
        buildConfigField("String", "GOOGLE_SERVER_CLIENT_ID", "\"$googleClientId\"")
        buildConfigField("String", "FIREBASE_API_KEY", "\"$firebaseApiKey\"")
        buildConfigField("String", "FIREBASE_APP_ID", "\"$firebaseAppId\"")
        // C15 : endpoint injectable au build (-PvvApiBaseUrl=http://10.0.2.2:3200 pour QA
        // contre le mock staging local). Defaut = production, inchange, zero breaking.
        val apiBaseUrl = providers.gradleProperty("vvApiBaseUrl").orNull ?: "https://vitrine-video-api.mdgejcinfluence.workers.dev"
        buildConfigField("String", "API_BASE_URL", "\"" + apiBaseUrl + "\"")
    }
}
dependencies {
    implementation(project(":data"))
    implementation(libs.androidx.activity)
    implementation(libs.coroutines.android)
    implementation(platform(libs.compose.bom))
    implementation(libs.compose.material3)
    implementation(libs.compose.ui)
    implementation(libs.compose.ui.tooling.preview)
    implementation(libs.activity.compose)
    implementation(project(":core-model"))
    implementation(project(":core-designsystem"))
    implementation(project(":core-guard"))
    implementation(libs.credentials)
    implementation(libs.credentials.play)
    implementation(libs.googleid)
    implementation(libs.firebase.auth)
    implementation(libs.coroutines.android)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.lifecycle.runtime)
    testImplementation(libs.junit)
    testImplementation(libs.robolectric)
    testImplementation(libs.compose.ui.test.junit4)
    testImplementation(libs.compose.ui.test.manifest)
}
