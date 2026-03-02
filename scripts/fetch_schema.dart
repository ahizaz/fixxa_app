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
      print('❌ Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env');
      exit(1);
    }

    print('\n🔍 Connecting to Supabase Database...\n');
    print('URL: $supabaseUrl');
    print('━' * 80);

    // Make a simple test request to check connection
    final headers = {
      'apikey': supabaseAnonKey,
      'Authorization': 'Bearer $supabaseAnonKey',
    };

    // Try to fetch from a common system table to test connection
    final testUrl = '$supabaseUrl/rest/v1/';
    print('\n📊 Testing connection to Supabase...');

    final response = await http.get(Uri.parse(testUrl), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 404) {
      print('✅ Successfully connected to Supabase!\n');
    } else {
      print('⚠️  Connection status: ${response.statusCode}');
      print('Response: ${response.body}\n');
    }

    // Try to introspect the database using PostgREST's OpenAPI endpoint
    final schemaUrl = '$supabaseUrl/rest/v1/';
    final schemaResponse = await http.get(
      Uri.parse(schemaUrl),
      headers: {...headers, 'Accept': 'application/openapi+json'},
    );

    if (schemaResponse.statusCode == 200) {
      final schema = json.decode(schemaResponse.body);

      if (schema['paths'] != null && schema['paths'] is Map) {
        final paths = schema['paths'] as Map;
        final tables = <String>{};

        for (var path in paths.keys) {
          final pathStr = path.toString();
          if (pathStr.startsWith('/')) {
            final tableName = pathStr.substring(1);
            if (tableName.isNotEmpty && !tableName.contains('/')) {
              tables.add(tableName);
            }
          }
        }

        if (tables.isEmpty) {
          print('⚠️  No tables found in your Supabase database.');
          print('\nThis could mean:');
          print('  • Your database is empty (no tables created yet)');
          print('  • Row Level Security (RLS) is enabled and blocking access');
          print('  • Tables exist in a non-public schema\n');
          print('📝 To create tables, visit your Supabase dashboard:');
          print('   $supabaseUrl\n');
        } else {
          print('📊 Found ${tables.length} table(s):\n');

          for (var tableName in tables.toList()..sort()) {
            print('┌─ TABLE: $tableName');

            // Try to get schema for this table from OpenAPI definitions
            if (schema['definitions'] != null) {
              final defs = schema['definitions'] as Map;
              if (defs[tableName] != null) {
                final tableDef = defs[tableName] as Map;
                if (tableDef['properties'] != null) {
                  final props = tableDef['properties'] as Map;
                  print('│  Columns:');
                  for (var col in props.keys) {
                    final colDef = props[col] as Map;
                    final type = colDef['type'] ?? 'unknown';
                    final format = colDef['format'] ?? '';
                    print(
                      '│    • $col ($type${format.isNotEmpty ? '/$format' : ''})',
                    );
                  }
                }
              }
            }

            // Try to get row count
            try {
              final countUrl =
                  '$supabaseUrl/rest/v1/$tableName?select=*&limit=0';
              final countResponse = await http.head(
                Uri.parse(countUrl),
                headers: {...headers, 'Prefer': 'count=exact'},
              );

              final count = countResponse.headers['content-range'];
              if (count != null && count.contains('/')) {
                final total = count.split('/').last;
                print('│');
                print('│  Record count: $total');
              }
            } catch (e) {
              print('│');
              print('│  Record count: Unable to fetch');
            }

            print('└${'─' * 78}\n');
          }
        }
      }
    } else {
      print('⚠️  Could not fetch schema information');
      print('Status: ${schemaResponse.statusCode}');
      print('Response: ${schemaResponse.body}\n');

      print('📝 Your Supabase connection is configured.');
      print('   To view/manage your database, visit:');
      print('   $supabaseUrl\n');
    }

    // Fetch storage bucket information
    print('\n━' * 80);
    print('\n📦 Checking Storage Buckets...\n');

    try {
      final bucketsUrl = '$supabaseUrl/storage/v1/bucket';
      final bucketsResponse = await http.get(
        Uri.parse(bucketsUrl),
        headers: headers,
      );

      if (bucketsResponse.statusCode == 200) {
        final buckets = json.decode(bucketsResponse.body) as List;

        if (buckets.isEmpty) {
          print('⚠️  No storage buckets found\n');
        } else {
          print('Found ${buckets.length} storage bucket(s):\n');

          for (var bucket in buckets) {
            final bucketName = bucket['name'];
            final bucketId = bucket['id'];
            final isPublic = bucket['public'] ?? false;
            final createdAt = bucket['created_at'];

            print('┌─ BUCKET: $bucketName');
            print('│  ID: $bucketId');
            print('│  Public: ${isPublic ? 'Yes' : 'No'}');
            print('│  Created: $createdAt');

            // Fetch files in this bucket
            try {
              final filesUrl =
                  '$supabaseUrl/storage/v1/object/list/$bucketName';
              final filesResponse = await http.post(
                Uri.parse(filesUrl),
                headers: {...headers, 'Content-Type': 'application/json'},
                body: json.encode({
                  'limit': 100,
                  'offset': 0,
                  'sortBy': {'column': 'name', 'order': 'asc'},
                }),
              );

              if (filesResponse.statusCode == 200) {
                final files = json.decode(filesResponse.body) as List;

                if (files.isEmpty) {
                  print('│');
                  print('│  Files: 0 (empty bucket)');
                } else {
                  print('│');
                  print('│  Files: ${files.length}');
                  print('│');

                  for (var file in files) {
                    final fileName = file['name'];
                    final fileSize = file['metadata']?['size'];
                    final lastModified =
                        file['updated_at'] ?? file['created_at'];
                    final mimeType = file['metadata']?['mimetype'];

                    String sizeStr = 'unknown';
                    if (fileSize != null) {
                      final size = fileSize is int
                          ? fileSize
                          : int.tryParse(fileSize.toString()) ?? 0;
                      if (size < 1024) {
                        sizeStr = '$size B';
                      } else if (size < 1024 * 1024) {
                        sizeStr = '${(size / 1024).toStringAsFixed(2)} KB';
                      } else {
                        sizeStr =
                            '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
                      }
                    }

                    print('│    📄 $fileName');
                    print('│       Size: $sizeStr');
                    if (mimeType != null) print('│       Type: $mimeType');
                    if (lastModified != null) {
                      print('│       Modified: $lastModified');
                    }

                    // Generate public URL if bucket is public
                    if (isPublic) {
                      final publicUrl =
                          '$supabaseUrl/storage/v1/object/public/$bucketName/$fileName';
                      print('│       URL: $publicUrl');
                    }
                    print('│');
                  }
                }
              } else {
                print('│');
                print(
                  '│  Files: Unable to fetch (status: ${filesResponse.statusCode})',
                );
              }
            } catch (e) {
              print('│');
              print('│  Files: Error fetching - $e');
            }

            print('└${'─' * 78}\n');
          }
        }
      } else {
        debugPrint('⚠️  Could not fetch storage buckets');
        debugPrint('Status: ${bucketsResponse.statusCode}');
        debugPrint('Response: ${bucketsResponse.body}\n');
      }
    } catch (e) {
      print('⚠️  Error fetching storage buckets: $e\n');
    }

    print('\n✅ Connection test complete!');
    print('\n📚 Next steps:');
    print('   • Create tables in your Supabase dashboard');
    print('   • Use the SupabaseService in your app:');
    print('     final supabase = SupabaseService.instance;');
    print('     await supabase.insertData("table_name", data);\n');
  } catch (e, stackTrace) {
    print('\n❌ Error fetching schema: $e');
    print('\nStack trace:');
    print(stackTrace);
    exit(1);
  }

  exit(0);
}
