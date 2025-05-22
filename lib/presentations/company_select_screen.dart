import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/company_model.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

import 'package:pran_rfl_erp/presentations/login_screeen/login_screen.dart';

class CompanySelectScreen extends StatelessWidget {
  const CompanySelectScreen({super.key});
  static const String routePath = "/company-select-screen";
  static const String routeName = "company-select-screen";
  @override
  Widget build(BuildContext context) {
    return const CompanySelectBody();
  }
}

class CompanySelectBody extends StatefulWidget {
  const CompanySelectBody({super.key});

  @override
  State<CompanySelectBody> createState() => _CompanySelectBodyState();
}

class _CompanySelectBodyState extends State<CompanySelectBody> {
  String? selectedCompany;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: MediaQuery.of(context).viewPadding.top),
            Text(
              "Welcome To",
              style: textTheme.bodyLarge!.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: appTheme.tertiary,
              ),
            ),
            Text(
              "ExpressERP",
              style: textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.tertiary,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Please Select Your Company",
              style: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.tertiary,
              ),
            ),
            const SizedBox(
              height: 15,
            ),

            CommonDropdownButton<String>(
              hintText: "Select",
              items: const ["PRAN", "RFL"],
              onChanged: (value) {
                setState(() {
                  selectedCompany = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedCompany?.isNotEmpty ?? false) {
                  await DIContainer.configureRemoteServices(
                      env: selectedCompany ?? "");
                  await getIt<LocalDataRepository>().saveCompanyToLocal(
                      comModel: CompanyModel(
                          baseUrl: "", comName: selectedCompany ?? ""));
                  if (context.mounted) {
                    context.pushReplacementNamed(LoginScreen.routeName);
                  }
                }
              },
              child: Text(
                "Enter",
                style: textTheme.bodySmall!.copyWith(color: appTheme.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
