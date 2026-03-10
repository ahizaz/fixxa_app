import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fixxa_app/app.dart';
import 'package:fixxa_app/core/services/revenue_cat_service.dart';
import 'package:fixxa_app/firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart'; // ← add this

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  const supabaseUrl = 'https://hnvtfxhapzjvglozozds.supabase.co';
  const supabaseAnonkey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhudnRmeGhhcHpqdmdsb3pvemRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkxMzk1NDgsImV4cCI6MjA3NDcxNTU0OH0.GuXrupca8jBWWjpmBzEppG0hsmAv7ZbrNwysHWKthAI';
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonkey,
  );

  try {
    await RevenueCatService.init();
  } catch (e) {
    debugPrint('RevenueCat init failed: $e');
  }

  // OneSignal Initialization ← add these lines
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose); // testing শেষে remove করো
  OneSignal.initialize("03e150be-4f1c-4e5d-bc6c-89fd70623356");   // ← তোমার App ID দাও
  OneSignal.Notifications.requestPermission(true); // true = hard prompt দেখাবে

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const FixxaApp(),
  ));
}