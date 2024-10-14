import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/inventory_management_screen/bloc/employee_bloc.dart';

class InventoryManagementScreen extends StatelessWidget {
  const InventoryManagementScreen({super.key});
  static const String routePath = "inventory-management-screen";
  static const String routeName = "inventory-management-screen";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc(getService())..add(EmployeeGet()),
      child: const InventoryManagementScreenBody(),
    );
  }
}

class InventoryManagementScreenBody extends StatefulWidget {
  const InventoryManagementScreenBody({super.key});

  @override
  State<InventoryManagementScreenBody> createState() =>
      _InventoryManagementScreenBodyState();
}

class _InventoryManagementScreenBodyState
    extends State<InventoryManagementScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Test Data"),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, state) {
                  if (state is EmployeeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is EmployeeSuccess) {
                    return ListView.separated(
                      itemCount: state.empList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: appTheme.primary.withOpacity(0.2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(state.empList[index].ename),
                              Text(state.empList[index].job),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
