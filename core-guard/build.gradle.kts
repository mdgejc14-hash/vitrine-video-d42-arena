plugins {
    id("vitrine.android-library")
}
android {
    namespace = "video.vitrine.core.guard"
    testOptions { unitTests.isIncludeAndroidResources = true }
}
dependencies {
    testImplementation(libs.junit)
}
