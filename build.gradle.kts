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
