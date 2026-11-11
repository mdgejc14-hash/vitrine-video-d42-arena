// Convention : application Android du monorepo (minSdk 24 / targetSdk 36, contrat V7-FINAL 3.2).
// AGP 9.x : support Kotlin integre nativement.
plugins { id("com.android.application") }
android {
    compileSdk = 37
    defaultConfig {
        minSdk = 24
        targetSdk = 36
        versionCode = 2
        versionName = "0.9.0-rc15"
    }
    compileOptions { sourceCompatibility = JavaVersion.VERSION_17; targetCompatibility = JavaVersion.VERSION_17 }
}
