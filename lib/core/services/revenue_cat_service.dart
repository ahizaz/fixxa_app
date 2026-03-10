import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {

  static const String _androidApiKey = 'test_bLkRVopbxTyROcnzRijnAJAqbly';
  static const String _iosApiKey = 'test_bLkRVopbxTyROcnzRijnAJAqbly';

  /// Call once at app startup (after Firebase & Supabase init)
  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);

    final PurchasesConfiguration config = Platform.isAndroid
        ? PurchasesConfiguration(_androidApiKey)
        : PurchasesConfiguration(_iosApiKey);

    await Purchases.configure(config);
  }

  /// Fetch available subscription offerings from RevenueCat dashboard
  static Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      return null;
    }
  }

  /// Purchase monthly subscription
  static Future<CustomerInfo?> purchaseMonthly() async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current?.monthly;
      if (package == null) return null;
      final result = await Purchases.purchasePackage(package);
      return result.customerInfo;
    } on PurchasesErrorCode catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Purchase yearly / annual subscription
  static Future<CustomerInfo?> purchaseYearly() async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current?.annual;
      if (package == null) return null;
      final result = await Purchases.purchasePackage(package);
      return result.customerInfo;
    } on PurchasesErrorCode catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Purchase a specific package (monthly / annual / etc.)
  static Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
      return result.customerInfo;
    } on PurchasesErrorCode catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Restore any previous purchases (required by App Store / Play Store policies)
  static Future<CustomerInfo?> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (_) {
      return null;
    }
  }

  /// Check if user has an active "pro" entitlement
  /// [entitlementId] must match the entitlement identifier set in RevenueCat dashboard
  static Future<bool> isSubscribed({String entitlementId = 'pro'}) async {
    try {
      final CustomerInfo info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey(entitlementId);
    } catch (_) {
      return false;
    }
  }

  /// Returns 'monthly', 'yearly', or null depending on active subscription
  static Future<String?> getActiveSubscriptionType() async {
    try {
      final CustomerInfo info = await Purchases.getCustomerInfo();
      for (final entitlement in info.entitlements.active.values) {
        final productId = entitlement.productIdentifier.toLowerCase();
        if (productId.contains('annual') || productId.contains('yearly') || productId.contains('year')) {
          return 'yearly';
        }
        if (productId.contains('month')) {
          return 'monthly';
        }
      }
      return info.entitlements.active.isNotEmpty ? 'monthly' : null;
    } catch (_) {
      return null;
    }
  }

  /// Attach a user ID after login so RevenueCat can link purchases to accounts
  static Future<void> identifyUser(String userId) async {
    try {
      await Purchases.logIn(userId);
    } catch (_) {}
  }

  /// Log out and reset to anonymous on sign-out
  static Future<void> logout() async {
    try {
      await Purchases.logOut();
    } catch (_) {}
  }
}
