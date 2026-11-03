plugins {
    id("vitrine.android-library")
    alias(libs.plugins.ksp)
}
android {
    namespace = "video.vitrine.data"
}
dependencies {
    implementation(project(":core-model"))
    implementation(libs.room.runtime)
    implementation(libs.room.ktx)
    ksp(libs.room.compiler)
    testImplementation(libs.junit)
    testImplementation(libs.json)
}
