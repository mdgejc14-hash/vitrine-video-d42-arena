// Convention : bibliotheque Android du monorepo (contrat V7-FINAL 3.2).
// AGP 9.x : support Kotlin integre nativement (le plugin org.jetbrains.kotlin.android est obsolete).
plugins { id("com.android.library") }
android {
    compileSdk = 37
    defaultConfig { minSdk = 24 }
    compileOptions { sourceCompatibility = JavaVersion.VERSION_17; targetCompatibility = JavaVersion.VERSION_17 }
}
