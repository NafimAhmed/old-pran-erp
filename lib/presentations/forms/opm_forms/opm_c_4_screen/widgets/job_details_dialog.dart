import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/job_dtl_drill_dw_response.dart';
import 'package:pran_rfl_erp/common_widgets/common_table_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_loc_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/widgets/job_loc_drill_dialog.dart';

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
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: appTheme.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
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
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: appTheme.primary.withOpacity(0.2)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.jobDetails[index].itemName ?? "",
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom().copyWith(
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
                                              itemCode: widget.jobDetails[index]
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
                                    widget.jobDetails[index].prodQty.toString(),
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
                                color: [
                                  "100%"
                                ].contains(widget.jobDetails[index].madeP)
                                    ? appTheme.green
                                    : appTheme.primary,
                                value: double.parse(widget
                                            .jobDetails[index].madeP
                                            ?.replaceAll('%', '') ??
                                        "0") /
                                    100,
                                minHeight: 5,
                              ),
                              index < widget.jobDetails.length
                                  ? const SizedBox(
                                      height: 5,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 5,
                      ),
                      itemCount: widget.jobDetails.length,
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
