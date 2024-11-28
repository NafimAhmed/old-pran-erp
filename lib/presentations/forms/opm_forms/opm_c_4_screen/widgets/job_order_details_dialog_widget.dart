import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/jo_loc_drill_dw_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_dtl_drill_dw_response.dart';
import 'package:pran_rfl_erp/common_widgets/common_table_widget.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';

import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_details_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_loc_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class JobOrderDetailsDialog extends StatelessWidget {
  const JobOrderDetailsDialog({
    super.key,
    required this.jobOrderNo,
    required this.cells,
    required this.itemName,
    required this.blocContext,
    required this.userId,
  });
  final String jobOrderNo;
  final String itemName;
  final List<DataGridCell<dynamic>> cells;
  final BuildContext blocContext;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<JobDetailsBloc>(blocContext),
      child: BlocListener<JobDetailsBloc, JobDetailsState>(
        listener: (context, state) {
          if (state is JobDetailsSuccess) {
            AppModal.showCustomModal(
              blocContext,
              content: JobDetailsDialog(
                jobDetails: state.jobDetailsList,
                blocContext: blocContext,
                userId: userId,
                jobOrderNo: jobOrderNo,
              ),
            );
          }
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: BlocBuilder<JobDetailsBloc, JobDetailsState>(
            builder: (context, state) {
              if (state is JobDetailsLoading) {
                return const SizedBox(
                  height: 210,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.close,
                        color: appTheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        color: appTheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              blocContext.read<JobDetailsBloc>().add(
                                    JobDetailsGet(
                                      userId: userId,
                                      jobOrderno: jobOrderNo,
                                    ),
                                  );
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return Dialog(
                              //       alignment: Alignment.center,
                              //       backgroundColor:
                              //           Theme.of(context).colorScheme.surface,
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(10.0),
                              //       ),
                              //       insetPadding: const EdgeInsets.symmetric(
                              //         horizontal: 20,
                              //       ),
                              //       child: const TestDialog(),
                              //     );
                              //   },
                              // );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: appTheme.primary,
                              ),
                              child: Center(
                                child: Text(
                                  "Job Order No",
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: appTheme.white,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            jobOrderNo,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                        color: appTheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            itemName,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(
                    cells.length,
                    (index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              cells[index].columnName,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ["Plan Start Date", "Plan Cmplt Date"]
                                      .contains(cells[index].columnName)
                                  ? DateTime.parse(cells[index].value)
                                      .toFormatedString("dd-MM-yyy")
                                  : cells[index].value.toString(),
                              textAlign: TextAlign.end,
                            ),
                          )
                        ],
                      );
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class JobDetailsDialog extends StatefulWidget {
  const JobDetailsDialog({
    super.key,
    required this.jobDetails,
    required this.blocContext,
    required this.userId,
    required this.jobOrderNo,
  });
  final List<JobDetail> jobDetails;
  final BuildContext blocContext;
  final String userId;
  final String jobOrderNo;
  @override
  State<JobDetailsDialog> createState() => _JobDetailsDialogState();
}

class _JobDetailsDialogState extends State<JobDetailsDialog> {
  late TabDataSource tabDataSource;
  @override
  void initState() {
    List<Map<String, dynamic>> tableData = widget.jobDetails.map(
      (e) {
        return e.toTabMap();
      },
    ).toList();
    tabDataSource = TabDataSource(tableData: tableData, alignment: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<JobLocatorDrilBloc>(widget.blocContext),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocListener<JobLocatorDrilBloc, JobLocatorDrilState>(
          listener: (context, state) {
            if (state is JobLocatorDrilSuccess) {
              AppModal.showCustomModal(
                context,
                content: JobLocDrillDwDialog(
                  jobLocatorDrilList: state.jobLocatorDrilList,
                ),
              );
            }
          },
          child: BlocBuilder<JobLocatorDrilBloc, JobLocatorDrilState>(
            builder: (context, state) {
              if (state is JobLocatorDrilLoading) {
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    child: CommonTableWidget(
                      source: tabDataSource,
                      onCellTap: (details) {
                        if (details.rowColumnIndex.columnIndex == 0) {
                          var itemCode = tabDataSource
                              .rows[details.rowColumnIndex.rowIndex - 1]
                              .getCells()[1]
                              .value
                              .toString();
                          widget.blocContext.read<JobLocatorDrilBloc>().add(
                                JobLocatorDrilGet(
                                  userid: widget.userId,
                                  itemCode: itemCode,
                                  jobOrderNo: widget.jobOrderNo,
                                ),
                              );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: CommonTableWidget(
              source: tabDataSource,
            ),
          ),
        ],
      ),
    );
  }
}
