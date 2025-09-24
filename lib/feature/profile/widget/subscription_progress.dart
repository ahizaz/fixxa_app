class SubscriptionProgress {
  final String earnedAmountDisplay;
  final String amountLeftDisplay;
  final double progressValue; // A value between 0.0 and 1.0

  SubscriptionProgress({
    required this.earnedAmountDisplay,
    required this.amountLeftDisplay,
    required this.progressValue,
  });

  /// This factory constructor will parse the data when your API is ready.
  factory SubscriptionProgress.fromMap(Map<String, dynamic> map) {
    return SubscriptionProgress(
      earnedAmountDisplay: map['earnedAmountDisplay'] ?? '£0',
      amountLeftDisplay: map['amountLeftDisplay'] ?? '£0',
      progressValue: map['progressValue']?.toDouble() ?? 0.0,
    );
  }
}
