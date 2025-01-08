import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_details_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/bloc/job_ord_info_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_4_screen/widgets/job_details_dialog.dart';

class JobOrderDetailsDialog extends StatefulWidget {
  const JobOrderDetailsDialog({
    super.key,
    required this.blocContext,
    required this.userId,
    required this.jobOrder,
    required this.itemCode,
  });

  final BuildContext blocContext;
  final String userId;
  final String jobOrder;
  final String itemCode;
  @override
  State<JobOrderDetailsDialog> createState() => _JobOrderDetailsDialogState();
}

class _JobOrderDetailsDialogState extends State<JobOrderDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<JobDetailsBloc>(widget.blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<JobOrderInfoBloc>(widget.blocContext)
            ..add(
              JobOrderInfoGet(
                  userId: widget.userId,
                  jobOrderno: widget.jobOrder,
                  itemId: widget.itemCode),
            ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<JobDetailsBloc, JobDetailsState>(
            listener: (context, state) {
              if (state is JobDetailsSuccess) {
                AppModal.showCustomModal(
                  widget.blocContext,
                  content: JobDetailsDialog(
                    jobDetails: state.jobDetailsList,
                    blocContext: widget.blocContext,
                    userId: widget.userId,
                    jobOrderNo: widget.jobOrder,
                  ),
                );
              }
            },
          ),
        ],
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
                    height: 5,
                  ),
                  BlocBuilder<JobOrderInfoBloc, JobOrderInfoState>(
                    builder: (context, state) {
                      if (state is JobOrderInfoLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is JobOrderInfoSuccess) {
                        if (state.jobOrderInfoList.isNotEmpty) {
                          var jobOrderInfo = state.jobOrderInfoList.first;
                          return Column(
                            children: [
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
                                      jobOrderInfo.item ?? "",
                                      textAlign: TextAlign.left,
                                      style: textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      jobOrderInfo.jobOrderNo ?? "",
                                      textAlign: TextAlign.center,
                                      style: textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...List.generate(
                                        jobOrderInfo.toTabMap().length,
                                        (index) {
                                      var key = jobOrderInfo
                                          .toTabMap()
                                          .entries
                                          .elementAt(index)
                                          .key;
                                      var value = jobOrderInfo
                                          .toTabMap()
                                          .entries
                                          .elementAt(index)
                                          .value;
                                      return Container(
                                        padding: const EdgeInsets.all(5),
                                        color: index % 2 == 0
                                            ? appTheme.primary.withOpacity(0.2)
                                            : appTheme.primary.withOpacity(0.1),
                                        child: Column(
                                          children: [
                                            JobOdrInfoLbl(
                                              title: key,
                                              value: ["Inspection Date"]
                                                      .contains(key)
                                                  ? DateTime.parse(value)
                                                      .toFormatedString(
                                                          "dd-MMM-yyyy")
                                                  : value.toString(),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                    JobOdrInfoLbl(
                                      title: "Made(%)",
                                      value: jobOrderInfo.madeP.toString(),
                                    ),
                                    LinearProgressIndicator(
                                      backgroundColor: appTheme.dividerColor,
                                      borderRadius: BorderRadius.circular(8),
                                      color: appTheme.primary,
                                      value: jobOrderInfo.madeP?.toDouble(),
                                      minHeight: 5,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: () {
                                    widget.blocContext
                                        .read<JobDetailsBloc>()
                                        .add(
                                          JobDetailsGet(
                                            userId: widget.userId,
                                            jobOrderno:
                                                jobOrderInfo.jobOrderNo ?? "",
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
                              ),
                            ],
                          );
                        }
                      }
                      return Container();
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

class JobOdrInfoLbl extends StatelessWidget {
  const JobOdrInfoLbl({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String? value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            value ?? "",
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
  }
}
