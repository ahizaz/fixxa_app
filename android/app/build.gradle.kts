
plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin অবশ্যই শেষেই থাকতে হবে
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.fixxa_app"
    compileSdk = 36          // সর্বোচ্চ প্রয়োজনীয় SDK
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.fixxa_app"
        minSdk = flutter.minSdkVersion          // ML Kit plugins 21+ প্রয়োজন
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            // R8 + ProGuard সক্রিয়
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
