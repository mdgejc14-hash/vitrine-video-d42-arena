plugins {
    id("vitrine.android-library")
}
android {
    namespace = "video.vitrine.vvguard"
    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
        }
    }
    defaultConfig {
        externalNativeBuild {
            cmake {
                arguments += "-DANDROID_STL=none"
            }
        }
    }
}
dependencies {
    testImplementation(libs.junit)
}
