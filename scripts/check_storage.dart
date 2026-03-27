import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  try {
    // Read .env file
    final envFile = File('.env');
    if (!await envFile.exists()) {
      print('❌ .env file not found!');
      exit(1);
    }

    final envContent = await envFile.readAsString();
    final envLines = envContent.split('\n');
    String? supabaseUrl;
    String? supabaseAnonKey;

    for (var line in envLines) {
      if (line.startsWith('SUPABASE_URL=')) {
        supabaseUrl = line.substring('SUPABASE_URL='.length).trim();
      } else if (line.startsWith('SUPABASE_ANON_KEY=')) {
        supabaseAnonKey = line.substring('SUPABASE_ANON_KEY='.length).trim();
      }
    }

    if (supabaseUrl == null || supabaseAnonKey == null) {
      debugPrint('❌ Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env');
      exit(1);
    }

    final headers = {
      'apikey': supabaseAnonKey,
      'Authorization': 'Bearer $supabaseAnonKey',
      'Content-Type': 'application/json',
    };

    debugPrint('\n📦 Checking Storage Bucket: audio_storage\n');
    debugPrint('━' * 80);

    final bucketName = 'audio_storage';
    final folderPath = 'quote_audio';

    // Try to list files directly from the bucket
    debugPrint('\n🔍 Attempting to list files in "$bucketName/$folderPath"...\n');

    final filesUrl = '$supabaseUrl/storage/v1/object/list/$bucketName';

    try {
      final filesResponse = await http.post(
        Uri.parse(filesUrl),
        headers: headers,
        body: json.encode({
          'limit': 1000,
          'offset': 0,
          'sortBy': {'column': 'name', 'order': 'asc'},
          'prefix': folderPath,
        }),
      );

      print('Status Code: ${filesResponse.statusCode}');

      if (filesResponse.statusCode == 200) {
        final files = json.decode(filesResponse.body) as List;

        print('✅ Successfully connected to bucket!\n');

        if (files.isEmpty) {
          debugPrint('┌─ BUCKET: $bucketName/$folderPath');
          debugPrint('│  Status: Empty (0 files)');
          debugPrint('└${'─' * 78}');
        } else {
          debugPrint('┌─ BUCKET: $bucketName');
          debugPrint('│  Folder: $folderPath');
          debugPrint('│  Total Files: ${files.length}');
          debugPrint('│');

          int totalSize = 0;

          for (var i = 0; i < files.length; i++) {
            final file = files[i];
            final fileName = file['name'];
            final id = file['id'];
            final createdAt = file['created_at'];
            final updatedAt = file['updated_at'];
            final lastAccessedAt = file['last_accessed_at'];

            // Get file metadata
            final metadata = file['metadata'];
            final fileSize = metadata?['size'];
            final mimeType = metadata?['mimetype'];
            final cacheControl = metadata?['cacheControl'];

            String sizeStr = 'unknown';
            if (fileSize != null) {
              final size = fileSize is int
                  ? fileSize
                  : int.tryParse(fileSize.toString()) ?? 0;
              totalSize += size;

              if (size < 1024) {
                sizeStr = '$size B';
              } else if (size < 1024 * 1024) {
                sizeStr = '${(size / 1024).toStringAsFixed(2)} KB';
              } else {
                sizeStr = '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
              }
            }

            print('│  ${i + 1}. 📄 $fileName');
            print('│     ID: $id');
            print('│     Size: $sizeStr');
            if (mimeType != null) print('│     Type: $mimeType');
            if (createdAt != null) print('│     Created: $createdAt');
            if (updatedAt != null) print('│     Updated: $updatedAt');

            // Generate public URL
            final publicUrl =
                '$supabaseUrl/storage/v1/object/public/$bucketName/$fileName';
            debugPrint('│     Public URL: $publicUrl');
            debugPrint('│');
          }

          // Calculate total size
          String totalSizeStr = 'unknown';
          if (totalSize > 0) {
            if (totalSize < 1024) {
              totalSizeStr = '$totalSize B';
            } else if (totalSize < 1024 * 1024) {
              totalSizeStr = '${(totalSize / 1024).toStringAsFixed(2)} KB';
            } else if (totalSize < 1024 * 1024 * 1024) {
              totalSizeStr =
                  '${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB';
            } else {
              totalSizeStr =
                  '${(totalSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
            }
          }

          print('│  Total Storage Used: $totalSizeStr');
          print('└${'─' * 78}');
        }
      } else if (filesResponse.statusCode == 400) {
        debugPrint('❌ Bucket not found or invalid request');
        debugPrint('Response: ${filesResponse.body}');
        debugPrint(
          '\n💡 The bucket "$bucketName" or folder "$folderPath" might not exist yet.',
        );
        debugPrint('   Create it in your Supabase dashboard under Storage.');
      } else if (filesResponse.statusCode == 401 ||
          filesResponse.statusCode == 403) {
        debugPrint('❌ Access denied');
        debugPrint('Response: ${filesResponse.body}');
        debugPrint('\n💡 This might be due to:');
        debugPrint('   • Row Level Security (RLS) policies on the bucket');
        debugPrint('   • Insufficient permissions for the anon key');
      } else {
        debugPrint('⚠️  Unexpected status code');
        debugPrint('Response: ${filesResponse.body}');
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
    }

    debugPrint('\n\n📚 Usage Example in your app:');
    debugPrint('');
    print('// Upload a file to the quote_audio folder');
    print('final supabase = SupabaseService.instance;');
    print('final url = await supabase.uploadFile(');
    print('  bucketName: "audio_storage",');
    print('  fileName: "quote_audio/recording.wav",');
    print('  fileBytes: audioBytes,');
    print(');');
    print('');
    print('// Get public URL');
    print(
      'final url = supabase.getPublicUrl("audio_storage", "quote_audio/recording.wav");',
    );
    print('');
  } catch (e, stackTrace) {
    print('\n❌ Error: $e');
    print('\nStack trace:');
    print(stackTrace);
    exit(1);
  }

  exit(0);
}
