import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fixxa_app/app.dart';
import 'package:fixxa_app/core/services/revenue_cat_service.dart';
import 'package:fixxa_app/firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_storage/get_storage.dart';


Future<void>main()async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize GetStorage first for persistent data
  await GetStorage.init();
  
   const supabaseUrl = 'https://hnvtfxhapzjvglozozds.supabase.co';
   const supabaseAnonkey =  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhudnRmeGhhcHpqdmdsb3pvemRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkxMzk1NDgsImV4cCI6MjA3NDcxNTU0OH0.GuXrupca8jBWWjpmBzEppG0hsmAv7ZbrNwysHWKthAI';
    await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonkey,
    // debug: true,
  );

  // Initialize RevenueCat
  try {
    await RevenueCatService.init();
  } catch (e) {
    debugPrint('RevenueCat init failed: $e');
  }

  runApp(DevicePreview( 
    enabled : !kReleaseMode,
    builder: (context)=>const FixxaApp(),
    
  ));
}
