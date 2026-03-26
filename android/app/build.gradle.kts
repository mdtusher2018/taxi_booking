import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
  
}

android {

    useLibrary("org.apache.http.legacy")


    namespace = "com.taxitile.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
          isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        multiDexEnabled = true
    }

    flavorDimensions += "role"

    productFlavors {
        create("driver") {
            dimension = "role"
            applicationId = "com.taxitile.driver"
            versionCode = 1
            versionName = "1.0.0"
            resValue("string", "app_name", "TaxiTile Driver")
        }
        create("user") {
            dimension = "role"
            applicationId = "com.taxitile.passenger"
            versionCode = 1
            versionName = "1.0.0"
            resValue("string", "app_name", "TaxiTile Passenger")
        }
    }
signingConfigs {
     create("release") {
            if(keystorePropertiesFile.exists()){
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = keystoreProperties["storeFile"]?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
}

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }

    
}


dependencies {
 coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

  implementation(platform("com.google.firebase:firebase-bom:34.7.0"))
  implementation("com.google.firebase:firebase-analytics")
  implementation ("com.google.firebase:firebase-messaging:22.0.0")
  implementation ("com.google.firebase:firebase-iid:21.1.0")
}

flutter {
    source = "../.."
}
