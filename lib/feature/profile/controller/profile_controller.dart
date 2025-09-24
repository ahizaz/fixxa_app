import 'package:fixxa_app/feature/profile/widget/subscription_progress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();

  // --- State Management for API Data ---
  var isLoading = true.obs;
  var subscriptionProgress = Rx<SubscriptionProgress?>(null);

  @override
  void onInit() {
    super.onInit();
    // Fetch data when the controller is first created
    fetchSubscriptionData();
  }

  /// This method will eventually contain your real API call.
  Future<void> fetchSubscriptionData() async {
    try {
      isLoading(true);

      // Simulate a network delay, just like a real API call would have.
      await Future.delayed(const Duration(seconds: 2));

      // --- This is your static data, structured like JSON from an API ---
      final mockApiData = {
        'earnedAmountDisplay': '£8,360',
        'amountLeftDisplay': '£1,640',
        'progressValue': 0.836, // This is 8360 / 10000
      };

      // We use the model to parse the data.
      subscriptionProgress.value = SubscriptionProgress.fromMap(mockApiData);
    } catch (e) {
      // Handle potential errors here in the future.
    } finally {
      // Make sure loading is set to false after the operation.
      isLoading(false);
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
    }
  }
}
