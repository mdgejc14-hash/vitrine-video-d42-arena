import java.io.FileInputStream
import java.util.Properties
import java.io.File as JFile

plugins { id("vitrine.android-app") }

// ═══ DURCISSEMENT P0/P1 (audit sécurité 31/10/2026, feu vert CTO) ═══
// Signature release RÉELLE + R8 full. signing.properties est cherché dans :
//   1. <repo>/vv-signing/signing.properties   (CI : décodé des GitHub Secrets,
//      répertoire gitignoré — le keystore n'entre JAMAIS dans le dépôt)
//   2. ~/.cache/vv-toolchain/signing.properties (poste opérateur, historique)
fun signingPropsFile(root: JFile): JFile? =
    listOf(
        // rootDir = chemin ABSOLU : indispensable, le CWD du daemon Gradle n'est PAS le repo.
        JFile(rootDir, "vv-signing/signing.properties"),
        JFile(System.getProperty("user.home") + "/.cache/vv-toolchain/signing.properties"),
    ).firstOrNull { it.exists() }

android {
    namespace = "video.vitrine.app"

    defaultConfig {
        val ssoWebClientId = "\"" + (providers.gradleProperty("vvWebClientId").orNull ?: "") + "\""
        val adminEmails = "\"" + (providers.gradleProperty("vvAdminEmails").orNull ?: "") + "\""
        buildConfigField("String", "SSO_WEB_CLIENT_ID", ssoWebClientId)
        buildConfigField("String", "ADMIN_EMAILS", adminEmails)
        // D42 (finding D42-F01) : le module n'avait AUCUN runner d'instrumentation
        // declare alors que 6 tests androidTest existaient -> jamais compiles ni
        // executes. Rendus exécutables sur émulateur.
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildFeatures {
        buildConfig = true
    }

    testOptions {
        animationsDisabled = true
    }

    signingConfigs {
        create("interne") {
            val propsFile = signingPropsFile(rootDir)
            if (propsFile != null) {
                val props = Properties().apply { FileInputStream(propsFile).use { load(it) } }
                val raw = JFile(props.getProperty("storeFile"))
                storeFile = if (raw.isAbsolute) raw else JFile(propsFile.parentFile, raw.path)
                storePassword = props.getProperty("storePassword")
                keyAlias = props.getProperty("keyAlias")
                keyPassword = props.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // P0 — signature : keystore officiel si props présentes (CI = secrets
            // décodés ; poste opérateur = ~/.cache). Sinon clé debug pour recette
            // LOCALE uniquement : en CI, l'étape « Contrôle de la signature » fait
            // échouer le pipeline si l'artifact n'est pas signé clé officielle.
            signingConfig =
                if (signingPropsFile(rootDir) != null) {
                    signingConfigs.getByName("interne")
                } else {
                    signingConfigs.getByName("debug")
                }
            // P1 — R8 full : obfuscation intégrale du moteur de composition
            // (ins-capture/ins-effects/ins-thermal), des features et du design
            // system ; réduction des ressources. mapping.txt publié en artifact
            // CI (dé-obfuscation des stacktraces de crash). Les règles et les
            // keeps techniques (JNI vvguard, Room, modèles) : proguard-rules.pro.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

kotlin {
    // D42 : toolchain explicite (les sources androidTest ne doivent pas changer
    // la cible JVM du module).
    jvmToolchain(17)
}

dependencies {
    implementation(libs.core.splashscreen)
    implementation(project(":core-model"))
    implementation(project(":core-designsystem"))
    implementation(project(":data"))
    implementation(project(":ins-capture"))
    implementation(project(":ins-effects"))
    implementation(project(":ins-thermal"))
    implementation(project(":feature-onboarding"))
    implementation(project(":feature-catalog"))
    implementation(project(":feature-brief"))
    implementation(project(":feature-camera"))
    implementation(project(":feature-export"))
    implementation(project(":feature-editor"))
    implementation(project(":feature-dashboard"))

    // D42 — tests instrumentes (emulateur) : rendus de production reels.
    androidTestImplementation(project(":feature-export"))
    androidTestImplementation(project(":data"))
    androidTestImplementation(project(":core-model"))
    androidTestImplementation(libs.androidx.test.core)
    androidTestImplementation(libs.androidx.test.runner)
    androidTestImplementation(libs.androidx.test.rules)
    androidTestImplementation(libs.androidx.test.ext.junit)
    androidTestImplementation(libs.espresso.core)
    // D42 : robot UI — inspection de la hierarchie reelle des ecrans et clic
    // sur chaque element cliquable (detection de boutons sans effet).
    androidTestImplementation(libs.uiautomator)
    androidTestImplementation(libs.work.runtime.ktx)
    androidTestImplementation(libs.coroutines.android)
    // Supertypes des classes ainsi testées : Room (VitrineLocalDatabase),
    // Activity/ComponentActivity (ExportActivity via VitrineActivity).
    // `implementation` dans :data / :feature-export n'est PAS transitif.
    androidTestImplementation(libs.room.runtime)
    androidTestImplementation(libs.androidx.core.ktx)
    androidTestImplementation(libs.androidx.activity)
    androidTestImplementation(libs.androidx.lifecycle.runtime)
}
