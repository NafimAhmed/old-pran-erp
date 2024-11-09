import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/bloc/transfer_batch_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/bloc/transfered_batch_data_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/cubit/rack_qr_cubit.dart';

class SplitQtyDialog extends StatelessWidget {
  SplitQtyDialog({
    super.key,
    required this.blocContext,
    required this.pTrnid,
    required this.userid,
    required this.rackId,
  });
  final BuildContext blocContext;
  final String pTrnid;
  final String userid;
  final String rackId;
  final TextEditingController splitQtyTextController = TextEditingController();
  final FocusNode splitQtyFocusNode = FocusNode();
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<TransferBatchBloc>(blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<ItemQrCubit>(blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<RackQrCubit>(blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<TransferedBatchDataBloc>(blocContext),
        ),
      ],
      child: BlocListener<TransferBatchBloc, TransferBatchState>(
        listener: (context, state) {
          if (state is TransferBatchSuccess) {
            splitQtyTextController.clear();
            context.pop();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enter Split Quantity",
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: fromKey,
                child: Row(
                  children: [
                    Expanded(
                      child: CommonTextFieldWidget(
                        focusNode: splitQtyFocusNode,
                        textAlign: TextAlign.center,
                        controller: splitQtyTextController,
                        keyboardType: TextInputType.phone,
                        style: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: appTheme.primary,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        labelText: "",
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Split Quantity";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              BlocSelector<TransferBatchBloc, TransferBatchState, String>(
                selector: (state) {
                  return state is TransferBatchLoading
                      ? state.splitFlag == "1"
                          ? "Saving.."
                          : "Save"
                      : "Save";
                },
                builder: (context, selectedState) {
                  return ElevatedButton(
                    onPressed: () {
                      if (fromKey.currentState!.validate()) {
                        blocContext.read<TransferBatchBloc>().add(
                              TransferBatch(
                                pTrnid: pTrnid,
                                userid: userid,
                                rackId: rackId,
                                rqty: splitQtyTextController.text,
                                split: "1",
                              ),
                            );
                      }
                    },
                    child: Text(
                      selectedState,
                      style: textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
