
plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // Flutter Gradle Plugin should be applied last
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.fixxa_app"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.fixxa_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Java compiler warnings কমানোর জন্য (ঐচ্ছিক)
    tasks.withType<JavaCompile> {
        options.compilerArgs.add("-Xlint:-options")
    }
}

// Flutter configuration
flutter {
    source = "../.."
}

// Exclude the standalone Firebase IID artifact globally to prevent
// duplicate class conflicts between `firebase-iid` and `firebase-messaging`.
configurations.all {
    exclude(group = "com.google.firebase", module = "firebase-iid")
}

// ML Kit language-specific text recognition dependencies
dependencies {
    implementation("com.google.mlkit:text-recognition-chinese:16.0.0")
    implementation("com.google.mlkit:text-recognition-devanagari:16.0.0")
    implementation("com.google.mlkit:text-recognition-japanese:16.0.0")
    implementation("com.google.mlkit:text-recognition-korean:16.0.0")
    // Required for core library desugaring used by some plugins (eg. flutter_local_notifications)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // Explicitly add Firebase Messaging and exclude the standalone IID artifact
    // to avoid duplicate class errors between `firebase-iid` and `firebase-messaging`.
    implementation("com.google.firebase:firebase-messaging:25.0.1") {
        exclude(group = "com.google.firebase", module = "firebase-iid")
    }
}

