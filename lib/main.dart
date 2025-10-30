import 'package:fixxa_app/app.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// void main() {
//   runApp(const FixxaApp());
// }
Future<void>main()async{
  WidgetsFlutterBinding.ensureInitialized();
   const supabaseUrl = 'https://hnvtfxhapzjvglozozds.supabase.co';
   const supabaseAnonkey =  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhudnRmeGhhcHpqdmdsb3pvemRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkxMzk1NDgsImV4cCI6MjA3NDcxNTU0OH0.GuXrupca8jBWWjpmBzEppG0hsmAv7ZbrNwysHWKthAI';
    await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonkey,
    // debug: true,
  );
  runApp(const FixxaApp());
}
