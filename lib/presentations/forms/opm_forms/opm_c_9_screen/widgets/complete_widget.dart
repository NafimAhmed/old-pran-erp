import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/batch_complete_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/bloc/batch_comp_bloc.dart';

class CompleteWidget extends StatelessWidget {
  final BatchCompData data;
  const CompleteWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BatchCompBloc(getService()),
      child: CompleteWidgetContent(data: data),
    );
  }
}

class CompleteWidgetContent extends StatefulWidget {
  const CompleteWidgetContent({super.key, required this.data});

  final BatchCompData data;

  @override
  State<CompleteWidgetContent> createState() => _CompleteWidgetContentState();
}

class _CompleteWidgetContentState extends State<CompleteWidgetContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border(bottom: BorderSide(color: appTheme.primary, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Item: ${widget.data.itemCode} - ${widget.data.itemName}"),
          Text("Batch No: ${widget.data.batchNo}"),
          Text("Batch Qty: ${widget.data.batchQty}"),
          Text("Made Qty: ${widget.data.madeQty}"),
          Text("Batch Status: ${widget.data.batchStatus}"),
          const SizedBox(height: 5),
          BlocBuilder<BatchCompBloc, BatchCompState>(
            builder: (context, state) {
              return Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                  ),
                  onPressed: () {
                    var loggedUser = context
                        .read<LoggedUserInfoCubit>()
                        .state
                        .userInfoModel!;
                    context.read<BatchCompBloc>().add(
                      CompleteBatch(
                        userId: loggedUser.userId,
                        batchId: widget.data.batchId!,
                      ),
                    );
                  },
                  child: Text(
                    state.saveStatus == RequestStatus.loading
                        ? "Completing..."
                        : "Complete",
                    style: textTheme.bodyMedium!.copyWith(
                      color: appTheme.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
