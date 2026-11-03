plugins { id("vitrine.android-library") }
android { namespace = "video.vitrine.ins.thermal" }
dependencies {
    implementation(libs.coroutines.android)
    testImplementation(libs.junit)
}
