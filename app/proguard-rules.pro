# ═══ Vitrine Vidéo — R8 full (P1, audit sécurité 31/10/2026) ═══
# Objectif : obfuscation INTÉGRALE du moteur de composition vidéo
# (ins-capture, ins-effects, ins-thermal), des features et du design system.
# Aucun keep sur ces modules : tout est renommé/repackagé.
# Les keeps ci-dessous = strict minimum technique (JNI, Room, modèles inter-process).

# ── Stacktraces lisibles via mapping.txt (artifact CI « vitrine-video-r8-mapping »)
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod,Exceptions

# ── JNI : gardien natif vvguard (SHA-256 C pur + vérification VVSH1, spec V2.0 §22).
#    Les méthodes `external` doivent conserver leur nom exact pour le lien dynamique C.
-keep class video.vitrine.vvguard.NativeGuard { *; }
-keepclasseswithmembernames class * {
    native <methods>;
}

# ── Room : miroir hors-ligne (entités, DAO, Converters — code généré + réflexion).
-keep class video.vitrine.data.local.** { *; }

# ── Modèles métier : transitent par Bundles/Intents (Serializable/Parcelable)
#    et par les DAO Room — les noms de champs doivent survivre.
-keep class video.vitrine.core.model.** { *; }

# ── Composables @Preview référencés par l'outillage (ci-visual-check Robolectric).
-keep @interface androidx.compose.runtime.Composable
-keepclassmembers class * {
    @androidx.compose.runtime.Composable <methods>;
}

# NOTE : les règles consumer de Media3, WorkManager, MLKit, Room et Compose sont
# fournies par leurs AAR et fusionnées automatiquement par AGP — pas de doublon ici.

# ── Agressivité R8 (moteur + logique de garde renommés, hiérarchie aplatie)
-repackageclasses 'vv'
-allowaccessmodification

# ── D42.9 : diagnostic lisible dans logcat sans dependre de mapping.txt.
#    L'incident « dq1 » vient de l'affichage d'un nom de classe renomme par R8.
#    Garder le NOM des exceptions ne coute quasi rien et rend les journaux
#    exploitables sur le terrain (l'utilisateur lit « ApiException » et non
#    « dq1 »). Les corps de methodes restent obfusques : l'obfuscation integrale
#    (D36) n'est pas remise en cause.
-keepnames class * extends java.lang.Throwable

# ── D42.17 : media3 + R8 full sur API 30 (Android 11) ─────────────────────────
# Run 42371123494 (APK officiel signé, release R8) : ExportWorker lève
# java.lang.NoClassDefFoundError: android.media.metrics.LogSessionId (API 31+)
# dans le Transformer media3 — la fusion de classes R8 (-repackageclasses 'vv',
# -allowaccessmodification) hisse la référence hors de sa garde de version.
# Les 120 rendus J3 tournaient en DEBUG sur API 34 : le défaut était invisible.
# Correctif : conserver les classes media3 intactes (garde de version
# préservée). L'obfuscation intégrale du reste (D36) est inchangée ; media3
# est du code open source, le coût est un léger surcroît de taille.
-keep class androidx.media3.** { *; }
