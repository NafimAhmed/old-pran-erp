import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_tab_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class OpmProdSupervisorScreen extends StatelessWidget {
  const OpmProdSupervisorScreen({super.key});
  static const String routeName = "prod-supervisor/batch-details";
  static const String routePath = "prod-supervisor/batch-details";
  @override
  Widget build(BuildContext context) {
    return const OpmProdSupervisorScreenBody();
  }
}

class OpmProdSupervisorScreenBody extends StatefulWidget {
  const OpmProdSupervisorScreenBody({super.key});

  @override
  State<OpmProdSupervisorScreenBody> createState() =>
      _OpmProdSupervisorScreenBodyState();
}

class _OpmProdSupervisorScreenBodyState
    extends State<OpmProdSupervisorScreenBody> with TickerProviderStateMixin {
  String? _selectedItem;
  List<String> items = ["1001", "1002", "1003", "1004", "1005"];
  late final TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Batch Details"),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: appTheme.primary,
                  ),
                  onPressed: null,
                  child: Text(
                    "AO1",
                    style: textTheme.bodyMedium!.copyWith(
                      color: appTheme.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CommonDropDownWidget(
                    hintText: "Select Batch Details No",
                    value: _selectedItem,
                    items: items
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                e,
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.primary,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            CommonTabBar(
              tabController: _tabController,
              tabs: const [
                Tab(
                  child: Text(
                    textAlign: TextAlign.left,
                    "Product",
                  ),
                ),
                Tab(
                  child: Text(
                    textAlign: TextAlign.left,
                    "Ingredients",
                  ),
                ),
                Tab(
                  child: Text(
                    textAlign: TextAlign.left,
                    "By-Products",
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    child: const Center(
                      child: Text("Products"),
                    ),
                  ),
                  Container(
                    child: const Center(
                      child: Text("Ingredients"),
                    ),
                  ),
                  Container(
                    child: const Center(
                      child: Text("By-Products"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
