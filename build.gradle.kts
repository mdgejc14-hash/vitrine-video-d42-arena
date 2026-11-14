// Racine monorepo Android Vitrine Video (Phase B0/P2). Le backend Phase A (src/, db/) n'est pas concerne.
plugins {
    alias(libs.plugins.ktlint) apply false
    alias(libs.plugins.detekt) apply false
}

subprojects {
    apply(plugin = "org.jlleitschuh.gradle.ktlint")
    apply(plugin = "io.gitlab.arturbosch.detekt")
    configure<io.gitlab.arturbosch.detekt.extensions.DetektExtension> {
        config.setFrom(rootProject.file("detekt.yml"))
        ignoreFailures = false
    }
}

tasks.register("checkModuleGraph") {
    description = "Regle de graphe : aucun module :feature-* ne depend d'un autre :feature-* (contrat V7-FINAL 3.2)"
    doLast {
        val root = layout.projectDirectory.asFile
        val features = root.listFiles()?.filter { it.isDirectory && it.name.startsWith("feature-") } ?: emptyList()
        val violations = mutableListOf<String>()
        for (f in features) {
            val txt = f.resolve("build.gradle.kts").takeIf { it.exists() }?.readText() ?: continue
            Regex("project\\(\":(feature-[^\"]+)\"\\)").findAll(txt).forEach { violations += "${f.name} -> ${it.groupValues[1]}" }
        }
        if (violations.isNotEmpty())
            throw GradleException("Graphe viole (feature->feature) : " + violations.joinToString(", "))
        println("checkModuleGraph OK : ${features.size} modules feature, 0 dependance feature->feature")
    }
}

// D42.33 — Robolectric DÉTERMINISTE (échec run 43600512583 : AssertionError
// MavenArtifactFetcher.java:130 ← FileNotFoundException HttpURLConnection =
// 404 transient de Maven Central PENDANT l'exécution des tests JVM).
// Robolectric téléchargeait android-all-instrumented en dehors de la
// résolution Gradle (aucun cache setup-gradle, aucun retry) : un échec
// réseau faisait échouer toutes les classes Robolectric en classMethod,
// avant toute logique de test.
// Fix : Gradle résout les jars (cache + retries), et chaque tâche Test
// démarre Robolectric en mode offline documenté (LegacyDependencyResolver
// lit robolectric.offline + robolectric.dependency.dir, répertoire plat de
// jars nommés <artifactId>-<version>.jar).
// Coordonnées lues dans DefaultSdkProvider du Robolectric 4.17 du catalogue
// (sdk 34 = toutes les classes du dépôt ; sdk 28 = ExportForegroundInfoTest
// @Config méthode). Un bump de Robolectric impose de mettre à jour cette
// liste — sinon l'échec est immédiat et explicite (« Path is not a file »).
val robolectricAndroidAll = listOf(
    "14-robolectric-10818077-i7", // SDK 34
    "9-robolectric-4913185-2-i7", // SDK 28
)
val robolectricAndroidAllDir = layout.buildDirectory.dir("robolectric-android-all")
tasks.register("syncRobolectricAndroidAll") {
    group = "verification"
    description = "Résout via Gradle les android-all de Robolectric (cache + retry) pour des tests JVM offline."
    outputs.dir(robolectricAndroidAllDir)
    doLast {
        val sortie = robolectricAndroidAllDir.get().asFile
        sortie.mkdirs()
        robolectricAndroidAll.forEach { version ->
            val conf = configurations.detachedConfiguration(
                dependencies.create("org.robolectric:android-all-instrumented:$version")
            )
            conf.resolve().forEach { jar ->
                val cible = java.io.File(sortie, jar.name)
                if (!cible.exists() || cible.length() != jar.length()) {
                    jar.copyTo(cible, overwrite = true)
                }
                println("robolectric offline prêt : " + jar.name)
            }
        }
    }
}
subprojects {
    tasks.withType<Test>().configureEach {
        dependsOn(rootProject.tasks.named("syncRobolectricAndroidAll"))
        systemProperty("robolectric.offline", "true")
        systemProperty("robolectric.dependency.dir", robolectricAndroidAllDir.get().asFile.absolutePath)
    }
}
