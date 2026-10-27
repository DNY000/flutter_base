/*
 * ==============================================================================
 * [AnalyticsService] - Dịch Vụ Firebase Analytics & Phễu Chuyển Đổi (Funnel)
 * ==============================================================================
 */

import 'package:firebase_analytics/firebase_analytics.dart';
import '../utils/logger.dart';

abstract class IAnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object>? parameters});
  Future<void> logScreenView(String screenName, {String? screenClass});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String? value);
  Future<void> logLogin({String? loginMethod});
  Future<void> logSignUp({String? signUpMethod});
  Future<void> logPurchase({
    required String currency,
    required double value,
    String? transactionId,
    List<AnalyticsEventItem>? items,
  });
  Future<void> logConversionStep({
    required String funnelName,
    required int stepNumber,
    required String stepName,
    Map<String, Object>? extraData,
  });
  FirebaseAnalyticsObserver get navigatorObserver;
}

class AnalyticsServiceImpl implements IAnalyticsService {
  final FirebaseAnalytics? _analytics;
  final bool isEnabled;

  AnalyticsServiceImpl({
    FirebaseAnalytics? analytics,
    this.isEnabled = true,
  }) : _analytics = analytics;

  FirebaseAnalytics get _instance => _analytics ?? FirebaseAnalytics.instance;

  @override
  FirebaseAnalyticsObserver get navigatorObserver =>
      FirebaseAnalyticsObserver(analytics: _instance);

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (!isEnabled) return;
    try {
      AppLogger.info(
          '📊 [FIREBASE ANALYTICS] Event: "$name" | Params: $parameters');
      await _instance.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      AppLogger.error('📊 [FIREBASE ANALYTICS] Lỗi ghi nhận logEvent: $e');
    }
  }

  @override
  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    if (!isEnabled) return;
    try {
      AppLogger.info('📱 [FIREBASE ANALYTICS] Screen: "$screenName"');
      await _instance.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (e) {
      AppLogger.error('📊 [FIREBASE ANALYTICS] Lỗi ghi nhận logScreenView: $e');
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    if (!isEnabled) return;
    try {
      AppLogger.info('👤 [FIREBASE ANALYTICS] Set UserId: "$userId"');
      await _instance.setUserId(id: userId);
    } catch (e) {
      AppLogger.error('📊 [FIREBASE ANALYTICS] Lỗi setUserId: $e');
    }
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    if (!isEnabled) return;
    try {
      AppLogger.info(
          '🏷️ [FIREBASE ANALYTICS] Set UserProperty: "$name" = "$value"');
      await _instance.setUserProperty(
        name: name,
        value: value,
      );
    } catch (e) {
      AppLogger.error('📊 [FIREBASE ANALYTICS] Lỗi setUserProperty: $e');
    }
  }

  @override
  Future<void> logLogin({String? loginMethod}) async {
    if (!isEnabled) return;
    try {
      AppLogger.info(
          '🔑 [FIREBASE ANALYTICS] Ghi nhận Đăng nhập (Method: $loginMethod)');
      await _instance.logLogin(loginMethod: loginMethod ?? 'email_password');
    } catch (e) {
      AppLogger.error('📊 [FIREBASE ANALYTICS] Lỗi logLogin: $e');
    }
  }

  @override
  Future<void> logSignUp({String? signUpMethod}) async {
    if (!isEnabled) return;
    try {
      AppLogger.info(
          '✨ [FIREBASE ANALYTICS] Ghi nhận Đăng ký tài khoản (Method: $signUpMethod)');
      await _instance.logSignUp(signUpMethod: signUpMethod ?? 'email_password');
    } catch (e) {
      AppLogger.error('📊 [FIREBASE ANALYTICS] Lỗi logSignUp: $e');
    }
  }

  @override
  Future<void> logPurchase({
    required String currency,
    required double value,
    String? transactionId,
    List<AnalyticsEventItem>? items,
  }) async {
    if (!isEnabled) return;
    try {
      AppLogger.info(
          '💰 [FIREBASE ANALYTICS] Ghi nhận Mua hàng: $value $currency');
      await _instance.logPurchase(
        currency: currency,
        value: value,
        transactionId: transactionId,
        items: items,
      );
    } catch (e) {
      AppLogger.error('📊 [FIREBASE ANALYTICS] Lỗi logPurchase: $e');
    }
  }

  @override
  Future<void> logConversionStep({
    required String funnelName,
    required int stepNumber,
    required String stepName,
    Map<String, Object>? extraData,
  }) async {
    if (!isEnabled) return;
    final params = <String, Object>{
      'funnel_name': funnelName,
      'step_number': stepNumber,
      'step_name': stepName,
      ...?extraData,
    };
    await logEvent('funnel_step_completed', parameters: params);
  }
}
