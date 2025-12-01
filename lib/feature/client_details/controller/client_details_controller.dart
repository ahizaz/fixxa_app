import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:get/get.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:flutter/foundation.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClientDetailsController extends GetxController {
  RxList<Map<String, dynamic>> clients = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch from API when controller initializes
    fetchClientsFromApi();
  }

  Future<void> fetchClientsFromApi() async {
    try {
      EasyLoading.show(status: 'Loading clients...');

      // Get access token (may be null). If missing, attempt fetch without Authorization header
      final accessToken = await LoginController.getAccessToken();

      final headers = {
        'Content-Type': 'application/json',
      };
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      } else {
        debugPrint('⚠️ No access token found - attempting unauthenticated fetch');
      }

      final response = await http.get(
        Uri.parse(Urls.getAllClient),
        headers: headers,
      );

      debugPrint('📥 Client list status: ${response.statusCode}');
      debugPrint('📥 Body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> items = data['data'] ?? [];

        final List<Map<String, dynamic>> mapped = items.map<Map<String, dynamic>>((item) {
          // Map server fields into the UI fields used in client_details.dart
          final double totalEarnings = (item['total_earnings'] as num?)?.toDouble() ?? 0.0;
          final int jobs = (item['total_services'] as num?)?.toInt() ?? 0;
          final String avatar = item['image'] ?? ImagePath.client1;
          final String status = totalEarnings > 0 ? 'earned' : 'Pending';

          return {
            'id': item['id'],
            'name': item['name'] ?? 'Unknown',
            'email': item['email'] ?? '',
            'jobs': jobs,
            'amount': totalEarnings,
            // Default to GBP symbol; backend may provide a currency field in future
            'currency': item['currency'] ?? '£',
            'status': status,
            'avatar': avatar,
          };
        }).toList();

        clients.value = mapped;
        // Also update the HomeDefaultController clientData so the Home view
        // immediately reflects newly added/updated clients without requiring
        // a manual refresh elsewhere in the app.
        try {
          if (Get.isRegistered<HomeDefaultController>()) {
            final homeCtrl = Get.find<HomeDefaultController>();
            final List<Map<String, dynamic>> homeMapped = items.map<Map<String, dynamic>>((item) {
              return {
                'id': item['id'],
                'name': item['name'] ?? 'Unknown',
                'email': item['email'] ?? '',
                'phone': item['phone_number'] ?? '',
                'address': item['address'],
                'image': item['image'] ?? ImagePath.client1,
                'source': item['source'] ?? 'manual',
                'jobCount': (item['total_services'] as num?)?.toInt() ?? 0,
                'earnings': (item['total_earnings'] as num?)?.toDouble() ?? 0.0,
                'latestServiceDate': item['latest_service_date'],
                'createdAt': item['created_at'],
                'acceptedQuotesCount': item['accepted_quotes_count'] ?? 0,
              };
            }).toList();

            homeCtrl.clientData.value = homeMapped;
            debugPrint('🔁 HomeDefaultController.clientData updated with ${homeMapped.length} clients');
          }
        } catch (e) {
          debugPrint('⚠️ Could not update HomeDefaultController clients: $e');
        }
        if (clients.isNotEmpty) {
          EasyLoading.showSuccess('${clients.length} client${clients.length > 1 ? 's' : ''} loaded');
        }
      } else {
        final err = jsonDecode(response.body);
        EasyLoading.showError(err['message'] ?? 'Failed to load clients');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Exception fetching clients: $e');
      EasyLoading.showError('An error occurred while fetching clients');
    }
  }
}
