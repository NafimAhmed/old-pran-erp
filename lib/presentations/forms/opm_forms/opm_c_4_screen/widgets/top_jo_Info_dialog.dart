import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_dialog_header.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_history_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/widgets/job_order_details_dialog_widget.dart';

class TopJoInfoDialog extends StatefulWidget {
  const TopJoInfoDialog(
      {super.key,
      required this.blocContext,
      required this.userId,
      required this.jobOrder});
  final BuildContext blocContext;
  final String userId;
  final String jobOrder;

  @override
  State<TopJoInfoDialog> createState() => _TopJoInfoDialogState();
}

class _TopJoInfoDialogState extends State<TopJoInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobHistoryBloc(getService())
        ..add(JobHistoryGet(userId: widget.userId, jobNo: widget.jobOrder)),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CommonDialogHeader(title: "JO Wise Items"),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: BlocBuilder<JobHistoryBloc, JobHistoryState>(
                builder: (context, state) {
                  if (state is JobHistoryLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is JobHistorySuccess) {
                    return ListView.separated(
                      itemCount: state.jobHistoryList.length,
                      itemBuilder: (context, index) {
                        var data = state.jobHistoryList[index];
                        return GestureDetector(
                          onTap: () {
                            var itemCode =
                                data.item?.split("-").first.trim() ?? "";

                            AppModal.showCustomModal(
                              widget.blocContext,
                              content: JobOrderDetailsDialog(
                                jobOrder: widget.jobOrder,
                                itemCode: itemCode,
                                blocContext: widget.blocContext,
                                userId: widget.userId,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? appTheme.primary.withOpacity(0.4)
                                  : appTheme.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.item ?? "",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 5,
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
