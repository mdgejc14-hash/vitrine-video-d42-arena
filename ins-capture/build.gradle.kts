plugins { id("vitrine.android-library") }
android { namespace = "video.vitrine.ins.capture" }
dependencies {
    implementation(libs.camerax.core)
    implementation(libs.camerax.camera2)
    implementation(libs.camerax.lifecycle)
    implementation(libs.camerax.video)
    implementation(libs.coroutines.android)
    implementation(libs.mlkit.face.detection)
    implementation(libs.androidx.lifecycle.runtime)
    testImplementation(libs.junit)
    implementation(project(":ins-effects"))
    implementation(project(":ins-thermal"))
    implementation(project(":core-model"))
}
