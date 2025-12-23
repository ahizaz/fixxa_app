import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Service for centralized database access
class SupabaseService {
  // Singleton pattern
  static SupabaseService? _instance;

  SupabaseService._();

  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  /// Get the Supabase client instance
  SupabaseClient get client => Supabase.instance.client;

  /// Get the current user
  User? get currentUser => client.auth.currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  /// Auth operations
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  /// Database operations
  /// Example: Get data from a table
  Future<List<Map<String, dynamic>>> getData(String table) async {
    final response = await client.from(table).select();
    return List<Map<String, dynamic>>.from(response);
  }

  /// Example: Insert data into a table
  Future<void> insertData(String table, Map<String, dynamic> data) async {
    await client.from(table).insert(data);
  }

  /// Example: Update data in a table
  Future<void> updateData(
    String table,
    Map<String, dynamic> data,
    String column,
    dynamic value,
  ) async {
    await client.from(table).update(data).eq(column, value);
  }

  /// Example: Delete data from a table
  Future<void> deleteData(String table, String column, dynamic value) async {
    await client.from(table).delete().eq(column, value);
  }

  /// Storage operations
  /// Upload a file to storage
  Future<String> uploadFile({
    required String bucketName,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    await client.storage.from(bucketName).uploadBinary(fileName, fileBytes);
    return client.storage.from(bucketName).getPublicUrl(fileName);
  }

  /// Get public URL for a file
  String getPublicUrl(String bucketName, String fileName) {
    return client.storage.from(bucketName).getPublicUrl(fileName);
  }

  /// Delete a file from storage
  Future<void> deleteFile({
    required String bucketName,
    required String fileName,
  }) async {
    await client.storage.from(bucketName).remove([fileName]);
  }

  /// Realtime subscriptions
  /// Subscribe to table changes
  RealtimeChannel subscribeToTable(
    String table,
    void Function(PostgresChangePayload payload) callback,
  ) {
    return client
        .channel('public:$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          callback: callback,
        )
        .subscribe();
  }
}
