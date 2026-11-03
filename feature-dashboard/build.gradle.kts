plugins {
    id("vitrine.android-library")
    alias(libs.plugins.composeCompiler)
}
android { namespace = "video.vitrine.feature.dashboard" }
android {
    buildFeatures {
        compose = true
        buildConfig = true
    }
    defaultConfig {
        // C16 : cle PUBLIQUE CinetPay (site_id) injectable au build :
        //   ./gradlew -PvvCinetPaySiteId=XXXX  (ou gradle.properties hors depot).
        // Vide = checkout non configure : l'app le dit honnetement, jamais de faux succes.
        val cinetPaySiteId = providers.gradleProperty("vvCinetPaySiteId").orNull ?: ""
        buildConfigField("String", "CINETPAY_SITE_ID", "\"" + cinetPaySiteId + "\"")
        // Audit D40 (A9) : BackendSync (flush telemetrie/quota + droits) cote dashboard.
        val apiBaseUrl = providers.gradleProperty("vvApiBaseUrl").orNull ?: "https://vitrine-video-api.mdgejcinfluence.workers.dev"
        buildConfigField("String", "API_BASE_URL", "\"" + apiBaseUrl + "\"")
    }
}
android {
    testOptions { unitTests.isIncludeAndroidResources = true }
}

dependencies {
    implementation(project(":data"))
    implementation(libs.room.runtime)
    implementation(libs.room.ktx)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.lifecycle.runtime)
    implementation(libs.coroutines.android)
    implementation(platform(libs.compose.bom))
    implementation(libs.compose.material3)
    implementation(libs.compose.ui)
    implementation(libs.activity.compose)
    implementation(project(":core-model"))
    implementation(project(":core-designsystem"))
    implementation(libs.firebase.auth)
}

dependencies {
    testImplementation(libs.junit)
    testImplementation(libs.robolectric)
    testImplementation(libs.compose.ui.test.junit4)
    testImplementation(libs.compose.ui.test.manifest)
}
