import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/mo_req_list_response.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_7_screen/bloc/mo_req_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_7_screen/bloc/mo_req_save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_7_screen/inv_c_7_screen.dart';

class MOTaskWidget extends StatelessWidget {
  const MOTaskWidget({
    super.key,
    required this.data,
    required this.index,
    required this.taskStatusTypeCubit,
  });

  final MOReqTask data;
  final int index;
  final VariableStateHandlerCubit<TaskStatusType> taskStatusTypeCubit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: taskStatusTypeCubit,
      child: TaskWidgetContent(
        data: data,
        index: index,
      ),
    );
  }
}

class TaskWidgetContent extends StatelessWidget {
  const TaskWidgetContent({super.key, required this.data, required this.index});

  final MOReqTask data;
  final int index;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Dismissible(
        key: Key(data.taskId.toString()),
        direction:
            context.watch<VariableStateHandlerCubit<TaskStatusType>>().state !=
                    null
                ? DismissDirection.startToEnd
                : DismissDirection.none,
        dismissThresholds: const {DismissDirection.startToEnd: 0.8},
        confirmDismiss: (direction) async {
          var result = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Are You Sure"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(
                              context, false); // Return false if cancelled
                        },
                      ),
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.pop(
                              context, true); // Return true if confirmed
                        },
                      ),
                    ],
                  );
                },
              ) ??
              false; // Default to false if dialog is dismissed without selection
          if (result && context.mounted) {
            var status = context
                .read<VariableStateHandlerCubit<TaskStatusType>>()
                .state!;
            var loggedUser = context.read<LoggedUserInfoCubit>().state!;
            context.read<MOReqSaveBloc>().add(
                  MOReqSave(
                    userId: loggedUser.userId,
                    taskStatus: status.value,
                    taskId: data.taskId ?? 0,
                  ),
                );

            // Listen to the stream of TaskAssignBloc
            final completer = Completer<bool>();
            final subscription =
                context.read<MOReqSaveBloc>().stream.listen((state) {
              if (state is MOReqSaveSuccess) {
                completer.complete(true); // Complete with true on success
              } else if (state is MOReqSaveError) {
                completer.complete(false); // Complete with false on failure
              }
            });

            // Wait for the result and clean up the subscription
            final isSuccess = await completer.future;
            subscription.cancel();
            return isSuccess;
          }

          return false;
        },
        onDismissed: (direction) {
          context.read<MOReqListBloc>().add(RemoveMOReqList(index: index));

          context.read<VariableStateHandlerCubit<TaskStatusType>>().reset();
        },
        background: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 106, 165, 66),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.save,
                color: appTheme.white,
              )
            ],
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 106, 165, 66),
                Color.fromARGB(255, 106, 165, 66),
              ],
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: appTheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Purchase Requisition",
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                        Text(
                          data.purchaseRequisition ?? "",
                          style: textTheme.bodySmall!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      data.status ?? "",
                      style: textTheme.bodyMedium!.copyWith(
                        color: _getColorsStatus(data.status ?? ""),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Assigned to",
                            style: textTheme.bodySmall!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                          Text(
                            data.assignee ?? "",
                            style: textTheme.bodySmall!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Requested by",
                            style: textTheme.bodySmall!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                          Text(
                            data.requester ?? "",
                            style: textTheme.bodySmall!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Requested Org",
                            style: textTheme.bodySmall!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                          Text(
                            data.requestOrganization ?? "",
                            style: textTheme.bodySmall!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Given Org",
                            style: textTheme.bodySmall!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                          Text(
                            data.givenOrganization ?? "",
                            style: textTheme.bodySmall!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CommonDropdownButton<TaskStatusType>(
                        value: context
                            .watch<VariableStateHandlerCubit<TaskStatusType>>()
                            .state,
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<
                                    VariableStateHandlerCubit<TaskStatusType>>()
                                .update(value);
                          }
                        },
                        hintText: "Change Status",
                        items: TaskStatusType.values,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color? _getColorsStatus(String taskStatus) {
    if (taskStatus == "Start") {
      return Colors.green;
    } else if (taskStatus == "Pending") {
      return const Color.fromARGB(255, 252, 3, 86);
    } else {
      return Colors.pink.shade500;
    }
  }
}
