import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class QuoteDetailsController extends GetxController {
  RxList<Map<String, dynamic>> quotes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    quotes.addAll([
      {
        'name': 'John Smith',
        'statuses': [
          {'amount': '£850', 'type': 'won'},
          {'amount': '\$200', 'type': 'lost'},
        ],
        'quotes': 3,
        'extra': '70 Hug + 22 Hug',
        'tag': '24+',
      },
      {
        'name': 'John Carter',
        'statuses': [
          {'amount': '£237', 'type': 'won'},
          {'amount': '\$60', 'type': 'lost'},
        ],
        'quotes': 3,
      },
      {
        'name': 'Mark Henry',
        'statuses': [
          {'amount': '£1,935', 'type': 'won'},
        ],
        'remind': 'Remind tomorrow',
        'quotes': 3,
      },
      {
        'name': 'James Williams',
        'statuses': [
          {'amount': '\$420', 'type': 'lost'},
        ],
        'quotes': 2,
      },
    ]);
  }
}
