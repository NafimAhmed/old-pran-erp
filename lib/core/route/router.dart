import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/entities/authentication_response.dart';
import 'package:pran_rfl_erp/presentations/generate_qr_screen/generate_qr_screen.dart';
import 'package:pran_rfl_erp/presentations/opm_c_1_screen/prodNew/opm_c_1_screencopy.dart';
import 'package:pran_rfl_erp/presentations/opm_c_3_screen/opm_c_3_screen.dart';
import 'package:pran_rfl_erp/presentations/opm_c_2_screen/opm_c_2_screen.dart';
import 'package:pran_rfl_erp/presentations/inventory_management_screen/inventory_management_screen.dart';
import 'package:pran_rfl_erp/presentations/modules_dashboard_screen/modules_dashboard_screen.dart';
import 'package:pran_rfl_erp/presentations/login_screeen/login_screen.dart';
import 'package:pran_rfl_erp/presentations/opm_prod_supervisor_screen/opm_prod_supervisor_screen.dart';
import 'package:pran_rfl_erp/presentations/module_screen/module_screen.dart';

import 'package:pran_rfl_erp/presentations/splash_screen/splash_screen.dart';

class AppNavigation {
  AppNavigation._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    // initialLocation: ModulesDashboardScreen.routePath,
    initialLocation: SplashScreen.routePath,
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
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: ModuleScreen.routePath,
        name: ModuleScreen.routeName,
        builder: (context, state) {
          return ModuleScreen(
            moduleName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmProdSupervisorScreen.routePath,
        name: OpmProdSupervisorScreen.routeName,
        builder: (context, state) {
          return const OpmProdSupervisorScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC2Screen.routePath,
        name: OpmC2Screen.routeName,
        builder: (context, state) {
          return const OpmC2Screen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC1Screen.routePath,
        name: OpmC1Screen.routeName,
        builder: (context, state) {
          return const OpmC1Screen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC3Screen.routePath,
        name: OpmC3Screen.routeName,
        builder: (context, state) {
          return const OpmC3Screen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: InventoryManagementScreen.routePath,
        name: InventoryManagementScreen.routeName,
        builder: (context, state) {
          return const InventoryManagementScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: GenerateQrScreen.routePath,
        name: GenerateQrScreen.routeName,
        builder: (context, state) {
          return const GenerateQrScreen();
        },
      ),
    ],
  );
}
