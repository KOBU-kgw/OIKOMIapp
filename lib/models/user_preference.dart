import 'package:isar_community/isar.dart';

part 'user_preference.g.dart';

@collection
class UserPreference {
  Id id = 0; // シングルトン（常に id=0）

  bool isPremiumActive = false;
  DateTime? subscriptionExpiryDate;
  String? lastPurchaseId;
  DateTime? lastPremiumCheckAt;

  // カスタム閾値（Premium専用、v0.3で使用）
  double? thresholdPeaceful;
  double? thresholdSomeday;
  double? thresholdReality;
  double? thresholdNoEscape;
}
