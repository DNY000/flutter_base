/*
 * ==============================================================================
 * [AnalyticsNavigatorObserver] - Tự Động Ghi Nhận Màn Hình Khi Điều Hướng
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'analytics_service.dart';

class AnalyticsNavigatorObserver extends NavigatorObserver {
  final IAnalyticsService _analyticsService;

  AnalyticsNavigatorObserver(this._analyticsService);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logScreen(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _logScreen(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _logScreen(previousRoute);
    }
  }

  void _logScreen(Route<dynamic> route) {
    final screenName = route.settings.name ?? route.settings.toString();
    if (screenName.isNotEmpty && !screenName.startsWith('/_')) {
      _analyticsService.logScreenView(screenName);
    }
  }
}
