import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class OpmDashDetailsScreen extends StatelessWidget {
  const OpmDashDetailsScreen({super.key});
  static const String routeName = "OPM-Dash-Dtl-SCREEN";
  static const String routePath = "/OPM-Dash-Dtl-SCREEN";
  @override
  Widget build(BuildContext context) {
    return const OpmDashDetailsBody();
  }
}

class OpmDashDetailsBody extends StatefulWidget {
  const OpmDashDetailsBody({super.key});

  @override
  State<OpmDashDetailsBody> createState() => _OpmDashDetailsBodyState();
}

class _OpmDashDetailsBodyState extends State<OpmDashDetailsBody>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Dash Details"),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: appTheme.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: appTheme.primary,
                  ),
                ),
                tabs: const [
                  Tab(
                    text: "Due",
                  ),
                  Tab(
                    text: "Complete",
                  ),
                  Tab(
                    text: "Pending",
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    color: appTheme.green,
                  ),
                  Container(
                    color: appTheme.primary,
                  ),
                  Container(
                    color: appTheme.secondary,
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
