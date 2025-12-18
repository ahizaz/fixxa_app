import 'dart:convert';
import 'dart:io';

import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/account create&authentication/controller/create_account_controller.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

class ScanService {
  /// Uploads an image file to the scan endpoint.
  ///
  /// - [imagePath]: local file path of the image to upload.
  /// - [userId]: optional user id; if not provided the method will try to
  ///   read it from `CreateAccountController` or `SharedPreferences`.
  ///
  /// Returns the http.Response if the request completed, or null on error.
  static Future<http.Response?> uploadScan({
    required String imagePath,
    String? userId,
      String fieldName = 'image',
  }) async {
    try {
      EasyLoading.show(status: 'Uploading image...');
      debugPrint('📤 Starting scan upload for file: $imagePath');

      final token = await LoginController.getAccessToken();
      String? uid = userId;

      // Try to get userId from CreateAccountController if not passed
      if (uid == null || uid.isEmpty) {
        try {
          final CreateAccountController acct = Get.find<CreateAccountController>();
          uid = acct.userId.value;
          debugPrint('🔎 Found userId from CreateAccountController: $uid');
        } catch (e) {
          debugPrint('ℹ️ CreateAccountController not found: $e');
        }
      }

      // Fallback to SharedPreferences
      if (uid == null || uid.isEmpty) {
        try {
          final prefs = await SharedPreferences.getInstance();
          uid = prefs.getString('user_id') ?? prefs.getString('userId') ?? '';
          debugPrint('🔎 Found userId from SharedPreferences: $uid');
        } catch (e) {
          debugPrint('❌ Error reading SharedPreferences for userId: $e');
        }
      }

      final uri = Uri.parse(Urls.scan);
      var request = http.MultipartRequest('POST', uri);

      // Attach authorization header if token exists
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
        debugPrint('🔐 Using Bearer token (length ${token.length})');
      } else {
        debugPrint('⚠️ No access token found; request will be sent without Authorization header');
      }

      // Attach user id if available
      if (uid != null && uid.isNotEmpty) {
        request.fields['user_id'] = uid;
        debugPrint('🆔 Attaching user_id: $uid');
      } else {
        debugPrint('⚠️ user_id not provided or found; leaving user_id empty');
      }

      // Attach image file
      final file = File(imagePath);
      if (!await file.exists()) {
        debugPrint('❌ Image file does not exist at path: $imagePath');
        EasyLoading.dismiss();
        return null;
      }

      // Determine filename and content type to send accurate MIME metadata
        final filename = p.basename(imagePath);
        String ext = p.extension(filename).toLowerCase();
        MediaType? mediaType;
        if (ext == '.jpg' || ext == '.jpeg') {
          mediaType = MediaType('image', 'jpeg');
        } else if (ext == '.png') {
          mediaType = MediaType('image', 'png');
        } else if (ext == '.heic') {
          mediaType = MediaType('image', 'heic');
        } else {
          mediaType = MediaType('application', 'octet-stream');
        }

        final multipartFile = await http.MultipartFile.fromPath(
          fieldName,
          imagePath,
          filename: filename,
          contentType: mediaType,
        );
        request.files.add(multipartFile);
      debugPrint('📎 Attached file: ${file.path}');

      debugPrint('📨 Sending request to ${uri.toString()}');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📥 Scan upload response status: ${response.statusCode}');
      debugPrint('📥 Scan upload response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Upload successful');
      } else {
        // Try to decode message from body
        String msg = response.body;
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded['message'] != null) msg = decoded['message'].toString();
        } catch (_) {}
        EasyLoading.showError('Upload failed: $msg');
      }

      return response;
    } catch (e) {
      debugPrint('❌ Error uploading scan: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Error uploading image');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Picks an image (camera by default) and uploads it using [uploadScan].
  /// Shows `EasyLoading` status and logs progress via `debugPrint`.
  static Future<http.Response?> pickAndUpload({
    ImageSource source = ImageSource.camera,
    String? userId,
  }) async {
    try {
      debugPrint('📸 Launching image picker (source: $source)');
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (picked == null) {
        debugPrint('⚪ Image picking cancelled by user');
        return null;
      }

      debugPrint('✅ Image picked: ${picked.path}');
      EasyLoading.show(status: 'Preparing image...');

      final resp = await uploadScan(imagePath: picked.path, userId: userId);

      if (resp != null) {
        debugPrint('🔁 Upload completed with status: ${resp.statusCode}');
      } else {
        debugPrint('❌ Upload returned null response');
      }

      return resp;
    } catch (e) {
      debugPrint('❌ Error in pickAndUpload: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Failed to pick or upload image');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
