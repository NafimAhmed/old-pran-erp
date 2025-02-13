import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_1_screen/inv_c_1_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_2_screen/inv_c_2_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_3_screen/inv_c_3_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_6_screen/inv_c_6_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_1_screen/om_c_1_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_2_screen/om_c_2_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_3_screen/om_c_3_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/project_c_2_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_8_screen/om_c_8_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_9_screen/project_c_9_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_10_screen/opm_c_10_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_15_screen/opm_c_15_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_17_screen/opm_c_17_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_19_screen/opm_c_19_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_1_screen/opm_c_1_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_21_screen/opm_c_21_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_22_screen/opm_c_22_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_24_screen/opm_c_24_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/opm_c_2_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/opm_c_4_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/opm_c_3_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_8_screen/opm_c_8_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/opm_c_9_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/po_c_2_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_7_screen/project_c_7_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_8_screen/project_c_8_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_1_screen/sys_admin_c_1_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_2_screen/sys_admin_c_2_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_3_screen/sys_admin_c_3_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_5_screen/sys_admin_c_5_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_6_screen/sys_admin_c_6_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_7_screen/sys_admin_c_7_screen.dart';
import 'package:pran_rfl_erp/presentations/inventory_management_screen/inventory_management_screen.dart';
import 'package:pran_rfl_erp/presentations/modules_dashboard_screen/modules_dashboard_screen.dart';
import 'package:pran_rfl_erp/presentations/login_screeen/login_screen.dart';
import 'package:pran_rfl_erp/presentations/opm_dash_details_screen.dart/opm_dash_details_screen.dart';
import 'package:pran_rfl_erp/presentations/opm_prod_supervisor_screen/opm_prod_supervisor_screen.dart';
import 'package:pran_rfl_erp/presentations/module_screen/module_screen.dart';
import 'package:pran_rfl_erp/presentations/print_qr_screen/print_qr_screen.dart';

import 'package:pran_rfl_erp/presentations/splash_screen/splash_screen.dart';
import 'package:pran_rfl_erp/presentations/user_profile/user_profile_screen/user_profile_screen.dart';
import 'package:pran_rfl_erp/presentations/user_profile/user_profile_update_screen/user_profile_update_screen.dart';

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
        routes: [
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: UserProfileScreen.routePath,
            name: UserProfileScreen.routeName,
            builder: (context, state) {
              return const UserProfileScreen();
            },
            routes: [
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: UserProfileUpdateScreen.routePath,
                name: UserProfileUpdateScreen.routeName,
                builder: (context, state) {
                  return const UserProfileUpdateScreen();
                },
              ),
            ],
          ),
        ],
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
        path: PrintQrScreen.routePath,
        name: PrintQrScreen.routeName,
        builder: (context, state) {
          var map = state.extra as Map<String, dynamic>;

          return PrintQrScreen(
            userBatchQrData: map["userBatchQrData"] as UserBatchQrData,
            userQrPrintBlocCtx: map["userQrPrintBlocCtx"] as BuildContext,
            userOrg: map["userOrg"] as UserOrg,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmDashDetailsScreen.routePath,
        name: OpmDashDetailsScreen.routeName,
        builder: (context, state) {
          return const OpmDashDetailsScreen();
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
        path: OpmC1Screen.routePath,
        name: OpmC1Screen.routeName,
        builder: (context, state) {
          return OpmC1Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC2Screen.routePath,
        name: OpmC2Screen.routeName,
        builder: (context, state) {
          return OpmC2Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC3Screen.routePath,
        name: OpmC3Screen.routeName,
        builder: (context, state) {
          return OpmC3Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC4Screen.routePath,
        name: OpmC4Screen.routeName,
        builder: (context, state) {
          return OpmC4Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC8Screen.routePath,
        name: OpmC8Screen.routeName,
        builder: (context, state) {
          return OpmC8Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC9Screen.routePath,
        name: OpmC9Screen.routeName,
        builder: (context, state) {
          return OpmC9Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC10Screen.routePath,
        name: OpmC10Screen.routeName,
        builder: (context, state) {
          return OpmC10Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC15Screen.routePath,
        name: OpmC15Screen.routeName,
        builder: (context, state) {
          return OpmC15Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC17Screen.routePath,
        name: OpmC17Screen.routeName,
        builder: (context, state) {
          return OpmC17Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC19Screen.routePath,
        name: OpmC19Screen.routeName,
        builder: (context, state) {
          return OpmC19Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC21Screen.routePath,
        name: OpmC21Screen.routeName,
        builder: (context, state) {
          return OpmC21Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC22Screen.routePath,
        name: OpmC22Screen.routeName,
        builder: (context, state) {
          return OpmC22Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OpmC24Screen.routePath,
        name: OpmC24Screen.routeName,
        builder: (context, state) {
          return OpmC24Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OmC1Screen.routePath,
        name: OmC1Screen.routeName,
        builder: (context, state) {
          return OmC1Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OmC2Screen.routePath,
        name: OmC2Screen.routeName,
        builder: (context, state) {
          return OmC2Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OmC3Screen.routePath,
        name: OmC3Screen.routeName,
        builder: (context, state) {
          return OmC3Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: OmC8Screen.routePath,
        name: OmC8Screen.routeName,
        builder: (context, state) {
          return OmC8Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: InvC1Screen.routePath,
        name: InvC1Screen.routeName,
        builder: (context, state) {
          return InvC1Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: InvC2Screen.routePath,
        name: InvC2Screen.routeName,
        builder: (context, state) {
          return InvC2Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: InvC3Screen.routePath,
        name: InvC3Screen.routeName,
        builder: (context, state) {
          return InvC3Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: InvC6Screen.routePath,
        name: InvC6Screen.routeName,
        builder: (context, state) {
          return InvC6Screen(
            fromName: state.extra as String,
          );
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
        path: SysAdminC1Screen.routePath,
        name: SysAdminC1Screen.routeName,
        builder: (context, state) {
          return SysAdminC1Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: SysAdminC2Screen.routePath,
        name: SysAdminC2Screen.routeName,
        builder: (context, state) {
          return SysAdminC2Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: SysAdminC3Screen.routePath,
        name: SysAdminC3Screen.routeName,
        builder: (context, state) {
          return SysAdminC3Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: SysAdminC5Screen.routePath,
        name: SysAdminC5Screen.routeName,
        builder: (context, state) {
          return SysAdminC5Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: SysAdminC6Screen.routePath,
        name: SysAdminC6Screen.routeName,
        builder: (context, state) {
          return SysAdminC6Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: SysAdminC7Screen.routePath,
        name: SysAdminC7Screen.routeName,
        builder: (context, state) {
          return SysAdminC7Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: PoC2Screen.routePath,
        name: PoC2Screen.routeName,
        builder: (context, state) {
          return PoC2Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: ProjectC7Screen.routePath,
        name: ProjectC7Screen.routeName,
        builder: (context, state) {
          return ProjectC7Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: ProjectC8Screen.routePath,
        name: ProjectC8Screen.routeName,
        builder: (context, state) {
          return ProjectC8Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: ProjectC9Screen.routePath,
        name: ProjectC9Screen.routeName,
        builder: (context, state) {
          return ProjectC9Screen(
            fromName: state.extra as String,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: ProjectC2Screen.routePath,
        name: ProjectC2Screen.routeName,
        builder: (context, state) {
          return ProjectC2Screen(
            fromName: state.extra as String,
          );
        },
      ),
    ],
  );
}
