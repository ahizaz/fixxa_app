import 'package:fixxa_app/core/services/revenue_cat_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionController extends GetxController {
  // 0 = monthly, 1 = annual
  final RxInt selectedBillingIndex = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool isSubscribed = false.obs;
  final Rx<Offerings?> offerings = Rx<Offerings?>(null);
  final Rx<Package?> selectedPackage = Rx<Package?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    await Future.wait([_loadOfferings(), _checkSubscription()]);
    isLoading.value = false;
  }

  Future<void> _loadOfferings() async {
    final result = await RevenueCatService.getOfferings();
    offerings.value = result;
    if (result?.current != null) {
      _syncSelectedPackage(result!.current!);
    }
  }

  Future<void> _checkSubscription() async {
    isSubscribed.value = await RevenueCatService.isSubscribed();
  }

  void selectBilling(int index) {
    selectedBillingIndex.value = index;
    final current = offerings.value?.current;
    if (current != null) _syncSelectedPackage(current);
  }

  void _syncSelectedPackage(Offering offering) {
    if (selectedBillingIndex.value == 0) {
      selectedPackage.value = offering.monthly ?? offering.availablePackages.firstOrNull;
    } else {
      selectedPackage.value = offering.annual ?? offering.availablePackages.firstOrNull;
    }
  }

  /// Display price string for the selected billing period
  String get selectedPriceString {
    final pkg = selectedPackage.value;
    if (pkg == null) {
      return selectedBillingIndex.value == 0 ? '£3.99/month' : '£39/year';
    }
    return pkg.storeProduct.priceString;
  }

  Future<void> purchaseSelected() async {
    final pkg = selectedPackage.value;
    if (pkg == null) {
      EasyLoading.showError('No package available. Please try again.');
      return;
    }

    EasyLoading.show(status: 'Processing...');
    final info = await RevenueCatService.purchasePackage(pkg);
    EasyLoading.dismiss();

    if (info != null && info.entitlements.active.isNotEmpty) {
      isSubscribed.value = true;
      EasyLoading.showSuccess('You are now a Fixxa Pro member!');
      Get.back();
    } else {
      EasyLoading.showError('Purchase could not be completed. Please try again.');
    }
  }

  Future<void> restorePurchases() async {
    EasyLoading.show(status: 'Restoring purchases...');
    final info = await RevenueCatService.restorePurchases();
    EasyLoading.dismiss();

    if (info != null && info.entitlements.active.isNotEmpty) {
      isSubscribed.value = true;
      EasyLoading.showSuccess('Purchases restored!');
    } else {
      EasyLoading.showInfo('No previous purchases found.');
    }
  }
}

