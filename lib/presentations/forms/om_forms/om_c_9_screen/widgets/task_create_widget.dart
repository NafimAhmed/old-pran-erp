import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/bloc/task_assign_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/bloc/task_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/om_c_9_screen.dart';

class TaskCreateWidget extends StatelessWidget {
  const TaskCreateWidget({
    super.key,
    required this.index,
    required this.startDateCubit,
    required this.complDateCubit,
    required this.taskTypeCubit,
    required this.data,
    required this.taskList,
    required this.pTaskCubit,
    required this.loggedUser,
    required this.joInfo,
  });
  final int index;
  final VariableStateHandlerCubit<DateTime> startDateCubit;
  final VariableStateHandlerCubit<String> complDateCubit;
  final VariableStateHandlerCubit<TaskType> taskTypeCubit;
  final VariableStateHandlerCubit<Task> pTaskCubit;
  final Task data;
  final List<Task> taskList;
  final UserInfoModel loggedUser;
  final JoInfo joInfo;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: startDateCubit,
        ),
        BlocProvider.value(
          value: complDateCubit,
        ),
        BlocProvider.value(
          value: taskTypeCubit,
        ),
        BlocProvider.value(
          value: pTaskCubit,
        ),
        BlocProvider(
          create: (context) => TaskAssignBloc(getService()),
        ),
      ],
      child: TaskWidgetContent(
        index: index,
        taskList: taskList,
        data: data,
        loggedUser: loggedUser,
        joInfo: joInfo,
      ),
    );
  }
}

class TaskWidgetContent extends StatefulWidget {
  const TaskWidgetContent({
    super.key,
    required this.index,
    required this.data,
    required this.taskList,
    required this.loggedUser,
    required this.joInfo,
  });
  final int index;
  final Task data;
  final List<Task> taskList;
  final UserInfoModel loggedUser;
  final JoInfo joInfo;
  @override
  State<TaskWidgetContent> createState() => _TaskWidgetContentState();
}

class _TaskWidgetContentState extends State<TaskWidgetContent> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskAssignBloc, TaskAssignState>(
      listener: (context, state) {
        if (state is TaskAssignError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(CustomSnackBar.errorSnackber(
            message: "Task Assigned Failed",
          ));
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Dismissible(
          key: Key(widget.data.taskNo?.toString() ?? ""),
          dismissThresholds: const {DismissDirection.startToEnd: 0.8},
          direction: _saveValidation()
              ? DismissDirection.startToEnd
              : DismissDirection.none,
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
                false;

            if (result && context.mounted) {
              // Dispatch the TaskAssign event
              context.read<TaskAssignBloc>().add(
                    TaskAssign(
                      tskasgne: widget.loggedUser.userId,
                      jobId: widget.joInfo.jobId ?? 0,
                      tsknm: widget.data.taskName ?? "",
                      tskdesc: widget.data.taskName ?? "",
                      pId: context
                          .read<VariableStateHandlerCubit<Task>>()
                          .state
                          ?.taskNo,
                      startDate: context
                          .read<VariableStateHandlerCubit<DateTime>>()
                          .state!
                          .toFormatedString("dd-MMM-yyyy"),
                      endDate: context
                          .read<VariableStateHandlerCubit<String>>()
                          .state!,
                    ),
                  );

              // Listen to the stream of TaskAssignBloc
              final completer = Completer<bool>();
              final subscription =
                  context.read<TaskAssignBloc>().stream.listen((state) {
                if (state is TaskAssignSuccess) {
                  completer.complete(true); // Complete with true on success
                } else if (state is TaskAssignError) {
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
            context
                .read<VariableStateHandlerCubit<TaskType>>()
                .update(TaskType.independent);
            context.read<VariableStateHandlerCubit<Task>>().reset();
            context.read<VariableStateHandlerCubit<DateTime>>().reset();
            context.read<VariableStateHandlerCubit<String>>().reset();
            context.read<TaskListBloc>().add(removeTask(index: widget.index));
            ScaffoldMessenger.of(context)
                .showSnackBar(CustomSnackBar.successSnackber(
              message: "Task Assigned Successfully",
            ));
            context.read<TaskListBloc>().add(
                  GetTaskList(
                    userId: widget.loggedUser.userId,
                  ),
                );
          },
          background: Container(
            decoration: BoxDecoration(
              color: Colors.pink.shade800,
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.pink.shade800,
                  Colors.pink.shade800,
                ],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo[100],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.taskName ?? "",
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      widget.data.sdate == "N/A"
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: SegmentedButton<TaskType>(
                                  style: SegmentedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  showSelectedIcon: false,
                                  selected: <TaskType>{
                                    context
                                        .watch<
                                            VariableStateHandlerCubit<
                                                TaskType>>()
                                        .state!
                                  },
                                  onSelectionChanged:
                                      (Set<TaskType> newSelection) {
                                    context
                                        .read<
                                            VariableStateHandlerCubit<
                                                TaskType>>()
                                        .update(newSelection.first);
                                    if (newSelection.first ==
                                        TaskType.independent) {
                                      context
                                          .read<
                                              VariableStateHandlerCubit<Task>>()
                                          .reset();
                                    }
                                  },
                                  segments: <ButtonSegment<TaskType>>[
                                    ...TaskType.values.map((e) {
                                      return ButtonSegment<TaskType>(
                                        label: Text(e.value),
                                        value: e,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        width: 20,
                      ),
                      BlocBuilder<VariableStateHandlerCubit<TaskType>,
                          TaskType?>(
                        builder: (context, state) {
                          if (state == TaskType.dependent) {
                            return Expanded(
                              child: CommonDropdownButton<Task>(
                                value: context
                                    .watch<VariableStateHandlerCubit<Task>>()
                                    .state,
                                hintText: "Select Parent Task",
                                items: widget.taskList.where(
                                  (element) {
                                    return widget.data != element;
                                  },
                                ).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                        .read<VariableStateHandlerCubit<Task>>()
                                        .update(value);
                                  }
                                },
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Start Date"),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                                textAlign: TextAlign.right,
                                widget.data.sdate == "N/A"
                                    ? context
                                            .watch<
                                                VariableStateHandlerCubit<
                                                    DateTime>>()
                                            .state
                                            ?.toFormatedString("dd-MMM-yyyy") ??
                                        ""
                                    : widget.data.sdate ?? ""),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          widget.data.sdate == "N/A"
                              ? InkWell(
                                  onTap: () async {
                                    var selectedDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 120)),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 120)),
                                      initialDate: DateTime.now(),
                                    );
                                    if (selectedDate != null &&
                                        context.mounted) {
                                      context
                                          .read<
                                              VariableStateHandlerCubit<
                                                  DateTime>>()
                                          .update(selectedDate);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.calendar_month_sharp,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Comlt Date"),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                                textAlign: TextAlign.right,
                                widget.data.sdate == "N/A"
                                    ? context
                                            .watch<
                                                VariableStateHandlerCubit<
                                                    String>>()
                                            .state ??
                                        ""
                                    : widget.data.sdate ?? ""),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          BlocBuilder<VariableStateHandlerCubit<DateTime>,
                              DateTime?>(
                            builder: (context, state) {
                              if (state != null) {
                                return InkWell(
                                  onTap: () async {
                                    var startDate = context
                                        .read<
                                            VariableStateHandlerCubit<
                                                DateTime>>()
                                        .state!;
                                    var selectedDate = await showDatePicker(
                                      context: context,
                                      firstDate: startDate,
                                      lastDate: startDate
                                          .add(const Duration(days: 120)),
                                      initialDate: startDate,
                                    );
                                    if (selectedDate != null &&
                                        context.mounted) {
                                      context
                                          .read<
                                              VariableStateHandlerCubit<
                                                  String>>()
                                          .update(selectedDate
                                              .toFormatedString("dd-MMM-yyyy"));
                                    }
                                  },
                                  child: const Icon(
                                    Icons.calendar_month_sharp,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _saveValidation() {
    if (context.watch<VariableStateHandlerCubit<DateTime>>().state != null &&
        context.watch<VariableStateHandlerCubit<String>>().state != null) {
      return true;
    } else {
      return false;
    }
  }

  // bool _validator() {
  //   var selectedStartDt =
  //       context.read<VariableStateHandlerCubit<DateTime>>().state;
  //   var selectedComplDt =
  //       context.read<VariableStateHandlerCubit<String>>().state;
  //   if (selectedStartDt != null && selectedComplDt != null) {
  //     return true;
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         CustomSnackBar.errorSnackber(message: "Please Assign Date"));
  //     return false;
  //   }
  // }
}
