import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // Flutter Gradle Plugin should be applied last
    id("dev.flutter.flutter-gradle-plugin")
}


val keystoreProperties = Properties()

val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {

    keystoreProperties.load(FileInputStream(keystorePropertiesFile))

}
 

android {
    namespace = "com.leevincent.fixxa"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.leevincent.fixxa"
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

   signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = if (keystoreProperties.getProperty("storeFile") != null) {
                file(keystoreProperties.getProperty("storeFile"))
            } else {
                null
            }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
           // signingConfig = signingConfigs.getByName("debug")
           signingConfig = signingConfigs.getByName("release")
        }
    }

    // Java compiler warnings 
    tasks.withType<JavaCompile> {
        options.compilerArgs.add("-Xlint:-options")
    }
}

// Flutter configuration
flutter {
    source = "../.."
}

    // NOTE: `com.google.firebase:firebase-iid` is required by some ML Kit
    // integration code. Do not exclude it globally; include an explicit
    // dependency below so R8 can resolve referenced classes.

// ML Kit language-specific text recognition dependencies
dependencies {
    implementation("com.google.mlkit:text-recognition-chinese:16.0.0")
    implementation("com.google.mlkit:text-recognition-devanagari:16.0.0")
    implementation("com.google.mlkit:text-recognition-japanese:16.0.0")
    implementation("com.google.mlkit:text-recognition-korean:16.0.0")
    // Required for core library desugaring used by some plugins (eg. flutter_local_notifications)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // Explicitly add Firebase Messaging and the IID library required by
    // some ML Kit Firebase link modules so classes are available at compile time.
    implementation("com.google.firebase:firebase-messaging:25.0.1")
    implementation("com.google.firebase:firebase-iid:21.1.0")
}

