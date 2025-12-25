import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Service for centralized database access
class SupabaseService {
  // Storage constants
  static const String audioBucket = 'audio_storage';
  static const String quoteAudioFolder = 'quote_audio';
  static const String invoiceAudioFolder = 'quote_recordings';

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

  /// User Information Table operations
  /// Create user in user_information table (using user_id column)
  Future<Map<String, dynamic>> createUserInformation({
    required String userId,
    required String email,
    String? password,
  }) async {
    final response = await client
        .from('user_information')
        .insert({
          'user_id': userId,
          'user_email': email,
          'user_password': password,
          // Other fields (user_name, user_business_name, etc.) are null initially
        })
        .select()
        .single();
    return response;
  }

  /// Sign up user and create database entry
  Future<AuthResponse> signUpAndCreateUser({
    required String email,
    required String password,
  }) async {
    // First, sign up the user in Supabase Auth
    final authResponse = await signUp(email: email, password: password);

    if (authResponse.user != null) {
      // Then create entry in user_information table
      await createUserInformation(
        userId: authResponse.user!.id,
        email: email,
        password: password,
      );
    }

    return authResponse;
  }

  /// Get user information by user_id
  Future<Map<String, dynamic>?> getUserInformation(String userId) async {
    final response = await client
        .from('user_information')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return response;
  }

  /// Update user information
  Future<Map<String, dynamic>> updateUserInformation({
    required String userId,
    Map<String, dynamic>? data,
  }) async {
    final response = await client
        .from('user_information')
        .update(data ?? {})
        .eq('user_id', userId)
        .select()
        .single();
    return response;
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

  /// Upload quote recording
  Future<String> uploadQuoteRecording({
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    final filePath = '$quoteAudioFolder/$fileName';
    await client.storage.from(audioBucket).uploadBinary(filePath, fileBytes);
    return client.storage.from(audioBucket).getPublicUrl(filePath);
  }

  /// Upload invoice recording
  Future<String> uploadInvoiceRecording({
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    final filePath = '$invoiceAudioFolder/$fileName';
    await client.storage.from(audioBucket).uploadBinary(filePath, fileBytes);
    return client.storage.from(audioBucket).getPublicUrl(filePath);
  }

  /// Delete quote recording
  Future<void> deleteQuoteRecording(String fileName) async {
    final filePath = '$quoteAudioFolder/$fileName';
    await client.storage.from(audioBucket).remove([filePath]);
  }

  /// Delete invoice recording
  Future<void> deleteInvoiceRecording(String fileName) async {
    final filePath = '$invoiceAudioFolder/$fileName';
    await client.storage.from(audioBucket).remove([filePath]);
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
