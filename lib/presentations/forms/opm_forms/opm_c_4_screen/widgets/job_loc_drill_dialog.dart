import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/jo_loc_drill_dw_response.dart';
import 'package:pran_rfl_erp/common_widgets/common_table_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_dialog_header.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class JobLocDrillDwDialog extends StatefulWidget {
  const JobLocDrillDwDialog({
    super.key,
    required this.jobLocatorDrilList,
  });
  final List<JobLocatorInfo> jobLocatorDrilList;

  @override
  State<JobLocDrillDwDialog> createState() => _JobLocDrillDwDialogState();
}

class _JobLocDrillDwDialogState extends State<JobLocDrillDwDialog> {
  late TabDataSource tabDataSource;
  @override
  void initState() {
    List<Map<String, dynamic>> tableData = widget.jobLocatorDrilList.map(
      (e) {
        return e.toTabMap();
      },
    ).toList();
    tabDataSource = TabDataSource(tableData: tableData, alignment: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CommonDialogHeader(title: "Locator Details"),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: CommonTableWidget(
              frozenColumnsCount: 1,
              source: tabDataSource,
            ),
          ),
        ],
      ),
    );
  }
}
