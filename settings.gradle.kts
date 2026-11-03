pluginManagement {
    includeBuild("build-logic")
    repositories { google(); mavenCentral(); gradlePluginPortal() }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories { google(); mavenCentral() }
}
rootProject.name = "vitrine-video"
include(":app", ":core-model", ":core-guard", ":vvguard", ":core-designsystem", ":data", ":ins-capture", ":ins-effects",
        ":ins-thermal", ":feature-onboarding", ":feature-catalog", ":feature-brief",
        ":feature-camera", ":feature-export", ":feature-editor", ":feature-dashboard")
