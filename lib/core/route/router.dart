import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/presentations/express_qr_screen/express_qr_screen.dart';
import 'package:pran_rfl_erp/presentations/inventory_management_screen/inventory_management_screen.dart';
import 'package:pran_rfl_erp/presentations/modules_dashboard_screen/modules_dashboard_screen.dart';
import 'package:pran_rfl_erp/presentations/login_screeen/login_screen.dart';
import 'package:pran_rfl_erp/presentations/opm_prod_supervisor_screen/opm_prod_supervisor_screen.dart';
import 'package:pran_rfl_erp/presentations/opm_screen/opm_screen.dart';

import 'package:pran_rfl_erp/presentations/splash_screen/splash_screen.dart';

class AppNavigation {
  AppNavigation._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: ModulesDashboardScreen.routePath,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: SplashScreen.routePath,
        name: SplashScreen.routeName,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: LoginScreen.routePath,
        name: LoginScreen.routeName,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: ModulesDashboardScreen.routePath,
        name: ModulesDashboardScreen.routeName,
        builder: (context, state) {
          return const ModulesDashboardScreen();
        },
        routes: [
          GoRoute(
            path: OpmScreen.routePath,
            name: OpmScreen.routeName,
            builder: (context, state) {
              return const OpmScreen();
            },
            routes: [
              GoRoute(
                path: OpmProdSupervisorScreen.routePath,
                name: OpmProdSupervisorScreen.routeName,
                builder: (context, state) {
                  return const OpmProdSupervisorScreen();
                },
              ),
              GoRoute(
                path: ExpressQrScreen.routePath,
                name: ExpressQrScreen.routeName,
                builder: (context, state) {
                  return const ExpressQrScreen();
                },
              ),
            ],
          ),
          GoRoute(
            path: InventoryManagementScreen.routePath,
            name: InventoryManagementScreen.routeName,
            builder: (context, state) {
              return const InventoryManagementScreen();
            },
          )
        ],
      ),
    ],
  );
}
