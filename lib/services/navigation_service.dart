import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;
  static final NavigationService instance = NavigationService._();
  NavigationService._();
  void pop() {
    return _navigationKey.currentState?.pop();
  }

  Future<dynamic>? navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? pushNamedAndRemoveUntil(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState?.pushNamedAndRemoveUntil(routeName, (r) => false);
  }


}