plugins { id("vitrine.android-library") }
android { namespace = "video.vitrine.ins.effects" }
dependencies {
    implementation(project(":core-model"))
    implementation(libs.media3.transformer)
    implementation(libs.media3.effect)
    implementation(libs.media3.common)
    testImplementation(libs.junit)
    testImplementation("org.json:json:20240303")
}
