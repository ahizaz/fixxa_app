import 'dart:convert';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeDefaultController extends GetxController {
  // Start stats at 0 so UI doesn't show stale/sample values before API loads
  final RxDouble sent = 0.0.obs;
  final RxDouble won = 0.0.obs;
  final RxDouble lost = 0.0.obs;

  // Track whether statistics are being fetched so UI can hide placeholders
  final RxBool isLoadingStats = true.obs;

  final RxInt selectedTab = 0.obs;

  // Loading state
  final RxBool isLoadingClients = false.obs;

  // Start with empty client list - will be populated from API
  final RxList<Map<String, dynamic>> clientData = <Map<String, dynamic>>[].obs;

  // Quote data - will be populated from API
  final RxList<Map<String, dynamic>> quoteData = <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> wonquoteData = [
    {
      "name": "John Smith",
      "won": 850,

      "email": "jamessmith@gmail.com",
      "quotes": 3,

      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },

    {
      "jobCount": 3,
      "name": "John Carter",
      "email": "jamessmith@gmail.com",

      "won": 50,
      "quotes": 3,
      "image": ImagePath.client2,
      "phone": "+44 1234 567896",
    },
    {
      "name": "James Williams",
      "email": "jamessmith@gmail.com",
      "won": 0, // Default to 0 if not provided

      "quotes": 2,
      "image": ImagePath.client3,
      "phone": "+44 1234 567896",
    },
    {
      "name": "Emma Brown",
      "email": "jamessmith@gmail.com",
      "won": 0, // Default to 0 if not provided
      // Note: 'sent' is present but not used in current UI
      "quotes": 1,
      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },
  ].obs;

  final RxList<Map<String, dynamic>> lostquoteData = [
    {
      "name": "John Smith",
      "lost": 850,

      "email": "jamessmith@gmail.com",
      "quotes": 3,

      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },

    {
      "jobCount": 3,
      "name": "John Carter",
      "email": "jamessmith@gmail.com",

      "lost": 50,
      "quotes": 3,
      "image": ImagePath.client2,
      "phone": "+44 1234 567896",
    },
    {
      "name": "James Williams",
      "email": "jamessmith@gmail.com",
      "lost": 0, // Default to 0 if not provided

      "quotes": 2,
      "image": ImagePath.client3,
      "phone": "+44 1234 567896",
    },
    {
      "name": "Emma Brown",
      "email": "jamessmith@gmail.com",
      "lost": 0, // Default to 0 if not provided
      // Note: 'sent' is present but not used in current UI
      "quotes": 1,
      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },
  ].obs;

  void switchTab(int index) {
    selectedTab.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Load cached clients first so UI isn't empty on cold start, then fetch
    // fresh data from API.
    debugPrint(
      '🚀 HomeDefaultController initialized - loading cached clients and fetching latest...',
    );
    _loadCachedClients().then((_) => getAllClients());
    // Fetch quote statistics for the dashboard
    fetchQuoteStatistics();
    // Fetch folders from API
    getAllFolders();
  }

  static const String _cacheKey = 'cached_clients';

  // Load cached clients from SharedPreferences so the UI can show something
  // immediately on cold start while the network fetch runs.
  // Note: Cache will be validated and updated after API fetch.
  Future<void> _loadCachedClients() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached != null && cached.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(cached);
        updateClientDataFromJson(jsonList);
        debugPrint(
          '📦 Loaded ${clientData.length} clients from cache (will be validated against API)',
        );
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load cached clients: $e');
    }
  }

  Future<void> _saveCachedClients(List<Map<String, dynamic>> clients) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(clients));
      debugPrint('💾 Cached ${clients.length} clients to SharedPreferences');
    } catch (e) {
      debugPrint('⚠️ Failed to cache clients: $e');
    }
  }

  // Fetch all clients from API
  Future<void> getAllClients({int attempt = 0}) async {
    try {
      // Show loading
      isLoadingClients.value = true;
      EasyLoading.show(status: 'Loading clients...');

      debugPrint(
        '🔄 Fetching all clients from API... (attempt ${attempt + 1})',
      );
      debugPrint('🔗 API URL: ${Urls.getAllClient}');
      // Try to obtain access token, retry briefly if it's not yet available
      String? accessToken = await LoginController.getAccessToken();
      int tokenAttempts = 0;
      const int maxTokenAttempts = 5;
      while ((accessToken == null || accessToken.isEmpty) &&
          tokenAttempts < maxTokenAttempts) {
        tokenAttempts++;
        debugPrint(
          '⚠️ Access token not found yet, retrying (${tokenAttempts}/${maxTokenAttempts})...',
        );
        await Future.delayed(const Duration(seconds: 1));
        accessToken = await LoginController.getAccessToken();
      }

      if (accessToken != null && accessToken.isNotEmpty) {
        debugPrint('🔑 Access Token: ${accessToken.substring(0, 20)}...');
      } else {
        debugPrint(
          '⚠️ No access token found after retries - attempting unauthenticated fetch',
        );
      }

      // Make GET request to getAllClient API (include Authorization only if available)
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      final response = await http.get(
        Uri.parse(Urls.getAllClient),
        headers: headers,
      );

      debugPrint('📥 Response Status Code: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      // Handle response. We only dismiss the loading indicator when we have
      // successfully loaded clients or when we've exhausted retry attempts.

      if (response.statusCode == 200) {
        // Parse response
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Clients fetched successfully!');
        debugPrint('📊 Success: ${responseData['success']}');
        debugPrint('📊 Message: ${responseData['message']}');

        // Get data array (new API structure uses 'data' instead of 'results')
        final List<dynamic> clientsArray = responseData['data'] ?? [];
        debugPrint('📋 Number of clients: ${clientsArray.length}');

        // Map API response to clientData format
        final List<Map<String, dynamic>> mappedClients = [];
        for (var item in clientsArray) {
          debugPrint('🔹 Client: ${item['name']} - ${item['email']}');
          mappedClients.add(<String, dynamic>{
            "id": item['id'],
            "name": item['name'] ?? "Unknown",
            "email": item['email'] ?? "no-email@example.com",
            "phone": item['phone_number'] ?? "+44 1234 567896",
            "address": item['address'],
            "image": item['image'], // This will be a URL from server
            "source": item['source'] ?? "manual",
            "jobCount": item['total_services'] ?? 0,
            "earnings": (item['total_earnings'] as num?)?.toDouble() ?? 0.0,
            "latestServiceDate": item['latest_service_date'],
            "createdAt": item['created_at'],
            "acceptedQuotesCount": item['accepted_quotes_count'] ?? 0,
          });
        }

        // If we received clients from the API, update and finish loading.
        if (mappedClients.isNotEmpty) {
          clientData.value = mappedClients;
          // Cache clients locally so we can show them on next cold start
          await _saveCachedClients(mappedClients);
          debugPrint(
            '✅ Client data updated successfully with ${clientData.length} clients',
          );
          debugPrint(
            '🧹 Cache synchronized - any deleted clients have been removed',
          );
          EasyLoading.showSuccess(
            '${clientData.length} client${clientData.length > 1 ? 's' : ''} loaded',
          );
          isLoadingClients.value = false;
          EasyLoading.dismiss();
          return;
        } else {
          // API returned empty array - clear cache to remove deleted clients
          debugPrint('🧹 API returned empty - clearing cache');
          clientData.value = [];
          await _saveCachedClients([]);
        }

        // If API returned empty list, retry a few times before giving up.
        const int maxApiEmptyRetries = 5;
        if (attempt < maxApiEmptyRetries) {
          debugPrint(
            '⚠️ API returned zero clients; will retry (${attempt + 1}/$maxApiEmptyRetries)',
          );
          await Future.delayed(const Duration(seconds: 1));
          await getAllClients(attempt: attempt + 1);
          return;
        }

        // Exhausted retries: keep existing client list (do not overwrite),
        // inform the user and stop loading.
        debugPrint('⚠️ No clients after retries; keeping existing client list');
        EasyLoading.showInfo('No clients found');
        isLoadingClients.value = false;
        EasyLoading.dismiss();
        return;
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint('❌ Error: ${errorData}');
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to fetch clients. Please try again.',
        );
        isLoadingClients.value = false;
        EasyLoading.dismiss();
        return;
      }
    } catch (e) {
      debugPrint('❌ Exception fetching clients: $e');
      EasyLoading.showError('An error occurred: $e');
      isLoadingClients.value = false;
      EasyLoading.dismiss();
    }
  }

  void updateStatsFromJson(Map<String, dynamic> json) {
    sent.value = (json['sent'] as num?)?.toDouble() ?? 0.0;
    won.value = (json['won'] as num?)?.toDouble() ?? 0.0;
    lost.value = (json['lost'] as num?)?.toDouble() ?? 0.0;
  }

  void updateClientDataFromJson(List<dynamic> jsonList) {
    clientData.value = jsonList
        .map(
          (item) => {
            "name": item['name'] ?? "Unknown",
            "email": item['email'] ?? "no-email@example.com",
            "jobCount": (item['jobCount'] as num?)?.toInt() ?? 0,
            "earnings": (item['earnings'] as num?)?.toInt() ?? 0,
            "image": item['image'] ?? ImagePath.client1,
            "phone": item['phone'] ?? "+44 1234 567896",
          },
        )
        .toList();
  }

  // Method to update quote data from API
  void updateQuoteDataFromJson(List<dynamic> jsonList) {
    quoteData.value = jsonList
        .map(
          (item) => {
            "name": item['name'] ?? "Unknown",
            "won": (item['won'] as num?)?.toInt() ?? 0,
            "lost": (item['lost'] as num?)?.toInt() ?? 0,
            "quotes": (item['quotes'] as num?)?.toInt() ?? 0,
          },
        )
        .toList();
  }

  // Validate if a client exists in the API by checking clientData
  // Returns true if client exists, false if deleted
  bool isClientValid(int clientId) {
    return clientData.any((client) => client['id'] == clientId);
  }

  // Validate and fetch specific client from API to ensure it still exists
  Future<bool> validateClientExists(int clientId) async {
    try {
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('⚠️ Cannot validate client - no access token');
        return false;
      }

      final response = await http.get(
        Uri.parse('${Urls.getAllClient}$clientId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Client $clientId exists');
        return true;
      } else if (response.statusCode == 404) {
        debugPrint('⚠️ Client $clientId not found - may have been deleted');
        // Remove from local cache
        clientData.removeWhere((client) => client['id'] == clientId);
        await _saveCachedClients(clientData);
        return false;
      } else {
        debugPrint(
          '⚠️ Unexpected status ${response.statusCode} when validating client',
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error validating client: $e');
      return false;
    }
  }

  // Fetch all folders from API
  Future<void> getAllFolders() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Loading folders...');

      debugPrint('🔄 Fetching all folders from API...');
      debugPrint('🔗 API URL: ${Urls.getAllFolders}');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ Access token is null or empty');
        return;
      }

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse(Urls.getAllFolders),
        headers: headers,
      );

      debugPrint('📥 Response Status Code: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        // Parse response
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Folders fetched successfully!');
        debugPrint('📊 Success: ${responseData['success']}');
        debugPrint('📊 Message: ${responseData['message']}');

        // Get data array
        final List<dynamic> foldersArray = responseData['data'] ?? [];
        debugPrint('📋 Number of folders: ${foldersArray.length}');

        // Map API response to quoteData format, keeping existing data structure
        final List<Map<String, dynamic>> mappedFolders = [];
        for (var folder in foldersArray) {
          mappedFolders.add({
            "name": folder['folder_name'] ?? "Unknown",
            "won": 850, // Keep existing default values
            "lost": 200,
            "email": "jamessmith@gmail.com",
            "quotes": 3,
            "image": ImagePath.client1,
            "phone": "+44 1234 567896",
            "folder_id": folder['folder_id'],
          });
        }

        // Update quoteData
        quoteData.value = mappedFolders;
        debugPrint('✅ Quote data updated with ${mappedFolders.length} folders');
        
        // Show message if no folders found
        if (mappedFolders.isEmpty) {
          EasyLoading.showInfo('No folders found. Create quotes to see folders here.');
        } else {
          EasyLoading.showSuccess('${mappedFolders.length} folders loaded');
        }
      } else {
        try {
          final errorData = jsonDecode(response.body);
          debugPrint('❌ Error: ${errorData}');
          EasyLoading.showError(
            errorData['message'] ?? 'Failed to fetch folders. Please try again.',
          );
        } catch (e) {
          debugPrint('❌ Failed to parse error response: $e');
          EasyLoading.showError('Failed to fetch folders (${response.statusCode})');
        }
      }
    } catch (e) {
      debugPrint('❌ Exception fetching folders: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred: $e');
    }
  }

  /// Fetch quote statistics from the API and update `sent`, `won`, `lost`.
  Future<void> fetchQuoteStatistics({int attempt = 0}) async {
    // Mark stats loading and show global loader
    isLoadingStats.value = true;
    EasyLoading.show(status: 'Loading statistics...');
    try {
      debugPrint('🔄 Fetching quote statistics from API... (attempt ${attempt + 1})');
      debugPrint('🔗 Stats URL: ${Urls.allstaticquotes}');

      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('⚠️ Access token is null or empty — request will be sent without Authorization header');
      } else {
        // Print only a masked portion of token for safety
        final masked = accessToken.length > 12 ? '${accessToken.substring(0, 8)}...${accessToken.substring(accessToken.length - 4)}' : accessToken;
        debugPrint('🔑 Access token found (masked): $masked');
      }

      // Build headers
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }
      debugPrint('🧾 Request headers: $headers');

      http.Response response;
      try {
        response = await http.get(Uri.parse(Urls.allstaticquotes), headers: headers);
      } catch (httpError, stack) {
        debugPrint('❌ HTTP request threw an exception: $httpError');
        debugPrint('📎 Stacktrace: $stack');
        EasyLoading.showError('Network error while fetching statistics');
        // Retry for transient network issues
        if (attempt < 2) {
          await Future.delayed(const Duration(seconds: 1));
          await fetchQuoteStatistics(attempt: attempt + 1);
        }
        return;
      }

      debugPrint('📥 Stats Response Status Code: ${response.statusCode}');
      debugPrint('📥 Raw Stats Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          final Map<String, dynamic> data = (responseData['data'] ?? {}) as Map<String, dynamic>;
          debugPrint('🧾 Parsed stats data: $data');
          updateStatsFromJson(data);
          debugPrint('✅ Quote statistics updated: sent=${sent.value}, won=${won.value}, lost=${lost.value}');
          EasyLoading.showSuccess('Statistics fetched');
          return;
        } catch (parseError, stack) {
          debugPrint('❌ Failed to parse stats response: $parseError');
          debugPrint('📎 Stacktrace: $stack');
          EasyLoading.showError('Malformed statistics response');
          return;
        }
      } else {
        // Try to parse error for better logs
        try {
          final errorData = jsonDecode(response.body);
          debugPrint('❌ Stats API error (parsed): $errorData');
          EasyLoading.showError(errorData['message'] ?? 'Failed to fetch statistics');
        } catch (parseErr) {
          debugPrint('❌ Stats API error: status ${response.statusCode}, cannot parse body');
          EasyLoading.showError('Failed to fetch statistics (${response.statusCode})');
        }

        // Retry a few times for transient failures
        if (attempt < 2) {
          await Future.delayed(const Duration(seconds: 1));
          await fetchQuoteStatistics(attempt: attempt + 1);
        }
      }
    } catch (e) {
      debugPrint('❌ Exception fetching quote statistics: $e');
      EasyLoading.showError('Error fetching statistics');
      if (attempt < 2) {
        await Future.delayed(const Duration(seconds: 1));
        await fetchQuoteStatistics(attempt: attempt + 1);
      }
    } finally {
      // Always dismiss loader and clear loading flag so UI updates
      EasyLoading.dismiss();
      isLoadingStats.value = false;
    }
  }
}
