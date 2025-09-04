
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:get/get.dart';

class ClientDetailsController extends GetxController {
  RxList<Map<String, dynamic>> clients = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    clients.addAll([
      {
        'name': 'Richardo Mathew',
        'email': 'richardomathew@gmail.com',
        'jobs': 3,
        'amount': 120,
        'currency': '£',
        'status': 'earned',
        'avatar':ImagePath.client3
      },
      {
        'name': 'John Smith',
        'email': 'smithjohn@gmail.com',
        'jobs': 3,
        'amount': 120,
        'currency': '£',
        'status': 'earned',
        'avatar':ImagePath.client2
      },
      {
        'name': 'Dyne Orwell',
        'email': 'dyneorwell@hotmail.com',///
        'jobs': 1,
        'amount': 120,
        'currency': '€',
        'status': 'Pending',
        'avatar':ImagePath.client1///
      },
      {
        'name': 'Lana Yolorell',
        'email': 'lanayolorell@hotmail.com',
        'jobs': 2,
        'amount': 120,
        'currency': '€',
        'status': 'earned',
        'avatar':ImagePath.client3
      },
      {
        'name': 'Mitchel Johnson',
        'email': 'dyneorwell@hotmail.com',
        'jobs': 2,
        'amount': 120,
        'currency': '€',
        'status': 'earned',
        'avatar':ImagePath.client2
      },
    ]);
  }
}