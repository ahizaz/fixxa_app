import 'dart:convert';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeDefaultController extends GetxController {
  final RxDouble sent = 12.0.obs;
  final RxDouble won = 8.0.obs;
  final RxDouble lost = 4.0.obs;

  final RxInt selectedTab = 0.obs;
  
  // Loading state
  final RxBool isLoadingClients = false.obs;

  final RxList<Map<String, dynamic>> clientData = <Map<String, dynamic>>[
    {
      "name": "Richardo Mathew",
      "email": "richardomathew@gmail.com",
      "jobCount": 1,
      "earnings": 120,
      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },
    {
      "name": "Sarah Johnson",
      "email": "sarahjohnson@gmail.com",
      "jobCount": 3,
      "earnings": 350,
      "image": ImagePath.client2,
      "phone": "+44 1234 567896",
    },
    {
      "name": "Michael Brown",
      "email": "michaelbrown@gmail.com",
      "jobCount": 2,
      "earnings": 200,
      "image": ImagePath.client3,
      "phone": "+44 1234 567896",
    },
  ].obs;

  // Quote data
  final RxList<Map<String, dynamic>> quoteData = [
    {
      "name": "John Smith",
      "won": 850,
      "lost": 200,
      "email": "jamessmith@gmail.com",
      "quotes": 3,

      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },
    {
      "jobCount": 3,
      "name": "John Carter",
      "email": "jamessmith@gmail.com",
      "won": 237,
      "lost": 60,
      "quotes": 3,
      "image": ImagePath.client2,
      "phone": "+44 1234 567896",
    },
    {
      "name": "James Williams",
      "email": "jamessmith@gmail.com",
      "won": 0, // Default to 0 if not provided
      "lost": 420,
      "quotes": 2,
      "image": ImagePath.client3,
      "phone": "+44 1234 567896",
    },
    {
      "name": "Emma Brown",
      "email": "jamessmith@gmail.com",
      "won": 0, // Default to 0 if not provided
      "sent": 850, // Note: 'sent' is present but not used in current UI
      "quotes": 1,
      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },
  ].obs;

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
    // Fetch clients when controller initializes
    getAllClients();
  }

  // Fetch all clients from API
  Future<void> getAllClients() async {
    try {
      // Show loading
      isLoadingClients.value = true;
      EasyLoading.show(status: 'Loading clients...');
      
      debugPrint('🔄 Fetching all clients from API...');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        isLoadingClients.value = false;
        EasyLoading.showError('Please login first');
        debugPrint('❌ No access token found');
        return;
      }

      debugPrint('🔑 Access Token: ${accessToken.substring(0, 20)}...');

      // Make GET request to getAllClient API
      final response = await http.get(
        Uri.parse(Urls.getAllClient),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint('📥 Response Status Code: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();
      isLoadingClients.value = false;

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
        
        // Clear and assign new data
        clientData.clear();
        clientData.addAll(mappedClients);
        
        debugPrint('✅ Client data updated successfully with ${clientData.length} clients');
        EasyLoading.showSuccess('${clientData.length} clients loaded');
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint('❌ Error: ${errorData}');
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to fetch clients. Please try again.',
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoadingClients.value = false;
      debugPrint('❌ Exception fetching clients: $e');
      EasyLoading.showError('An error occurred: $e');
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
}
