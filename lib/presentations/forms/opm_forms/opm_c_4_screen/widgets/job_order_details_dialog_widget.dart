import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/jo_loc_drill_dw_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_dtl_drill_dw_response.dart';
import 'package:pran_rfl_erp/app_data/models/jobhist_response.dart';
import 'package:pran_rfl_erp/common_widgets/common_table_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_details_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_loc_bloc.dart';

class JobOrderDetailsDialog extends StatelessWidget {
  const JobOrderDetailsDialog({
    super.key,
    required this.blocContext,
    required this.userId,
    required this.jobHistory,
  });
  final JobHistory jobHistory;
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
                jobOrderNo: jobHistory.jobOrderNo ?? "",
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: appTheme.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "FG/SFG Status",
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: appTheme.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: appTheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Icon(
                            Icons.close,
                            color: appTheme.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: appTheme.primary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jobHistory.item ?? "",
                          textAlign: TextAlign.left,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          jobHistory.jobOrderNo ?? "",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: appTheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text("FPO Qty"),
                            ),
                            Expanded(
                              child: Text(
                                jobHistory.fpoQty.toString(),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Good Qty"),
                            Expanded(
                              child: Text(
                                jobHistory.goodQty.toString(),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        LinearProgressIndicator(
                          backgroundColor: appTheme.dividerColor,
                          borderRadius: BorderRadius.circular(8),
                          color: appTheme.primary,
                          value: (jobHistory.goodQty ?? 0) /
                              (jobHistory.fpoQty ?? 1),
                          minHeight: 5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Trn Qty"),
                            Expanded(
                              child: Text(
                                jobHistory.trnQty.toString(),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        LinearProgressIndicator(
                          backgroundColor: appTheme.dividerColor,
                          borderRadius: BorderRadius.circular(8),
                          color: appTheme.primary,
                          value: (jobHistory.trnQty ?? 0) /
                              (jobHistory.fpoQty ?? 1),
                          minHeight: 5,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        blocContext.read<JobDetailsBloc>().add(
                              JobDetailsGet(
                                userId: userId,
                                jobOrderno: jobHistory.jobOrderNo ?? "",
                              ),
                            );
                      },
                      child: Text(
                        "See FG/SFG",
                        style: textTheme.bodyMedium!.copyWith(
                          color: appTheme.white,
                        ),
                      ),
                    ),
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
    tabDataSource = TabDataSource(
      tableData: tableData,
      alignment: ["Prod Qty", "Good Qty", "Bad Qty", "Due Qty", "Made(%)"],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<JobLocatorDrilBloc>(widget.blocContext),
      child: Container(
        height: 320,
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
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: appTheme.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "FG/SFG Details",
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: appTheme.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: appTheme.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: Icon(
                              Icons.close,
                              color: appTheme.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CommonTableWidget(
                      source: tabDataSource,
                      // onCellTap: (details) {
                      //   if (details.rowColumnIndex.columnIndex == 0) {
                      //     var itemCode = tabDataSource
                      //         .rows[details.rowColumnIndex.rowIndex - 1]
                      //         .getCells()[1]
                      //         .value
                      //         .toString();
                      //   }
                      // },
                      colVisibilityOff: const ["Item Code"],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: appTheme.primary.withOpacity(0.2)),
                      child: Column(
                        children: [
                          ...List.generate(
                            widget.jobDetails.length,
                            (index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.jobDetails[index].itemName ??
                                              "",
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      ElevatedButton(
                                        style:
                                            ElevatedButton.styleFrom().copyWith(
                                          padding: const WidgetStatePropertyAll(
                                            EdgeInsets.zero,
                                          ),
                                        ),
                                        onPressed: () {
                                          widget.blocContext
                                              .read<JobLocatorDrilBloc>()
                                              .add(
                                                JobLocatorDrilGet(
                                                  userid: widget.userId,
                                                  itemCode: widget
                                                          .jobDetails[index]
                                                          .itemCode ??
                                                      "",
                                                  jobOrderNo: widget.jobOrderNo,
                                                ),
                                              );
                                        },
                                        child: Text(
                                          "Locator",
                                          style: textTheme.bodyMedium!.copyWith(
                                            color: appTheme.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Prod Qty",
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        widget.jobDetails[index].prodQty
                                            .toString(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  LinearProgressIndicator(
                                    backgroundColor: appTheme.dividerColor,
                                    borderRadius: BorderRadius.circular(8),
                                    color: appTheme.primary,
                                    value: (widget.jobDetails[index].prodQty ??
                                            0) /
                                        (widget.jobDetails[index].goodQty ?? 1),
                                    minHeight: 5,
                                  ),
                                  index < widget.jobDetails.length
                                      ? const SizedBox(
                                          height: 5,
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
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
    return Container(
      height: 300,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: appTheme.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Locator Details",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: appTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: appTheme.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(
                    Icons.close,
                    color: appTheme.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: CommonTableWidget(
              source: tabDataSource,
            ),
          ),
        ],
      ),
    );
  }
}
