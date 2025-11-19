/// 應用程式路由設定
///
/// 使用 Go Router 管理路由和認證守衛
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 路由路徑常數
class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String home = '/home';
}

/// 路由配置 Provider
final routerProvider = Provider<GoRouter>((ref) {
  // 監聽認證狀態 (稍後在 Phase 3 實作)
  // final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('登入頁面 - Phase 3 實作'),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: ColoredBox(
              color: Color(0xFF86EFCC),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Money Manager',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Center(
            child: Text('主頁 - Phase 4-6 實作'),
          ),
        ),
      ),
    ],
    // 認證守衛 (稍後實作)
    redirect: (context, state) {
      // TODO: Phase 2 完成後實作認證守衛邏輯
      // final isAuthenticated = authState is Authenticated;
      // final isLoginRoute = state.matchedLocation == AppRoutes.login;

      // if (!isAuthenticated && !isLoginRoute) {
      //   return AppRoutes.login;
      // }
      // if (isAuthenticated && isLoginRoute) {
      //   return AppRoutes.home;
      // }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('找不到頁面: ${state.matchedLocation}'),
          ],
        ),
      ),
    ),
  );
});
