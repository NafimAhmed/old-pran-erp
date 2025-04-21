import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/task_info_response.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/task_info_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/task_save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/project_c_2_screen.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/widgets/note_dialog_widget.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.data,
    required this.index,
    required this.taskStatusTypeCubit,
  });

  final TaskInfo data;
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

  final TaskInfo data;
  final int index;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Dismissible(
        key: Key(data.tasksid.toString()),
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
            context.read<TaskSaveBloc>().add(
                  TaskSave(
                    userId: loggedUser.userId,
                    taskStatus: status.value,
                    taskId: data.tasksid ?? 0,
                  ),
                );

            // Listen to the stream of TaskAssignBloc
            final completer = Completer<bool>();
            final subscription =
                context.read<TaskSaveBloc>().stream.listen((state) {
              if (state is TaskSaveSuccess) {
                completer.complete(true); // Complete with true on success
              } else if (state is TaskSaveError) {
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
          context.read<TaskInfoBloc>().add(RemoveTaskInfo(index: index));

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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 201, 208, 247),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: appTheme.tertiary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          data.parentTaskName ?? "",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: appTheme.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        data.jobOrderNo ?? "",
                        style: textTheme.bodyMedium!.copyWith(
                          color: appTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _getColorsStatus(data.taskStatus ?? "")),
                        child: Text(
                          data.taskStatus ?? "",
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  data.taskName ?? "",
                  style: textTheme.bodyMedium!.copyWith(
                    color: appTheme.primary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Department:",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.primary,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        data.taskDept ?? "",
                        style: textTheme.bodyMedium!.copyWith(
                          color: appTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Assigned To:",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.primary,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        data.assignedTo ?? "",
                        style: textTheme.bodyMedium!.copyWith(
                          color: appTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Table(
                  textDirection: TextDirection.ltr,
                  defaultVerticalAlignment: TableCellVerticalAlignment
                      .middle, // Adjusted for better alignment
                  border: TableBorder.all(width: 1, color: Colors.black),
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 217, 224, 243),
                      ),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(5.0), // Adding padding
                          child: Text("Creatn Date"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            DateTime.parse(data.taskCreactionDate ?? "")
                                .toFormatedString("dd-MMM-yyyy"),
                            style: textTheme.bodyMedium!.copyWith(
                                // color: appTheme.primary,
                                ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 163, 176, 214),
                      ),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("Start Date"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            DateTime.parse(data.taskCreactionDate ?? "")
                                .toFormatedString("dd-MMM-yyyy"),
                            style: textTheme.bodyMedium!.copyWith(
                                // color: appTheme.primary,
                                ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 120, 139, 207),
                      ),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("StCm Date"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            DateTime.parse(data.taskCompletionDate ?? "")
                                .toFormatedString("dd-MMM-yyyy"),
                            style: textTheme.bodyMedium!.copyWith(
                                // color: appTheme.primary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
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
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton.filledTonal(
                      onPressed: () {
                        var loggedUser =
                            context.read<LoggedUserInfoCubit>().state!;
                        AppModal.showCustomModal(
                          context,
                          content: NoteDialogWidget(
                            taskInfo: data,
                            userId: loggedUser.userId,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.note_add,
                        color: appTheme.white,
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
      return Colors.pink.shade500;
    } else {
      return Colors.pink.shade500;
    }
  }
}
