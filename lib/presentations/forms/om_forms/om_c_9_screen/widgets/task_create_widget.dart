import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/buyer_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/department_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_dialog_header.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/buyer_list_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/dept_list_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/qr_user_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/bloc/task_assign_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/bloc/task_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/model/child_task.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/om_c_9_screen.dart';

class TaskCreateWidget extends StatelessWidget {
  const TaskCreateWidget({
    super.key,
    required this.index,
    required this.taskTypeCubit,
    required this.data,
    required this.taskList,
    required this.taskCubit,
    required this.loggedUser,
    required this.joInfo,
    required this.childTaskCubit,
  });
  final int index;

  final VariableStateHandlerCubit<TaskType> taskTypeCubit;
  final VariableStateHandlerCubit<Task> taskCubit;
  final VariableStateHandlerCubit<NewTask> childTaskCubit;
  final Task data;
  final List<Task> taskList;
  final UserInfoModel loggedUser;
  final JoInfo joInfo;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: taskTypeCubit,
        ),
        BlocProvider.value(
          value: taskCubit,
        ),
        BlocProvider.value(
          value: childTaskCubit,
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
  late TextEditingController _taskNameController;
  late TextEditingController _stDateController;
  late TextEditingController _enDateController;
  late TextEditingController _manController;
  late TextEditingController _hourController;
  late FocusNode _taskFocusNode;
  late FocusNode _manDateFocusNode;
  late FocusNode _hourDateFocusNode;
  @override
  void initState() {
    var childTask = context.read<VariableStateHandlerCubit<NewTask>>().state;
    _taskNameController =
        TextEditingController(text: childTask?.taskName ?? "");
    _stDateController = TextEditingController(text: childTask?.stDate ?? "");
    _enDateController = TextEditingController(text: childTask?.enDate ?? "");
    _taskFocusNode = FocusNode();
    _manController = TextEditingController(text: childTask?.manPower ?? "");
    _hourController = TextEditingController(text: childTask?.hour ?? "");

    _manDateFocusNode = FocusNode();
    _hourDateFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _stDateController.dispose();
    _enDateController.dispose();
    _taskFocusNode.dispose();
    _manController.dispose();
    _hourController.dispose();

    _manDateFocusNode.dispose();
    _hourDateFocusNode.dispose();
    super.dispose();
  }

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
                      jobId: widget.joInfo.jobId ?? "0",
                      tsknm: widget.data.taskName ?? "",
                      tskdesc: widget.data.taskName ?? "",
                      pId: context
                          .read<VariableStateHandlerCubit<Task>>()
                          .state
                          ?.pId,
                      startDate: context
                              .read<VariableStateHandlerCubit<Task>>()
                              .state!
                              .sdate
                              ?.stringToDateTime()
                              ?.toFormatedString("dd-MMM-yyyy") ??
                          "",
                      endDate: context
                              .read<VariableStateHandlerCubit<Task>>()
                              .state!
                              .tdate
                              ?.stringToDateTime()
                              ?.toFormatedString("dd-MMM-yyyy") ??
                          "",
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
            context.read<VariableStateHandlerCubit<Task>>().update(Task());

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
                color: Colors.indigo.shade200,
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
                                      var stateTask = context
                                          .read<
                                              VariableStateHandlerCubit<Task>>()
                                          .state!;
                                      context
                                          .read<
                                              VariableStateHandlerCubit<Task>>()
                                          .update(
                                            stateTask.copyWith(pId: 0),
                                          );
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
                                hintText: "Select Parent Task",
                                items: widget.taskList.where(
                                  (element) {
                                    return widget.data != element;
                                  },
                                ).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    var stateTask = context
                                        .read<VariableStateHandlerCubit<Task>>()
                                        .state!;
                                    context
                                        .read<VariableStateHandlerCubit<Task>>()
                                        .update(
                                          stateTask.copyWith(pId: value.taskNo),
                                        );
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
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                  textAlign: TextAlign.left,
                                  widget.data.sdate == "N/A"
                                      ? context
                                              .watch<
                                                  VariableStateHandlerCubit<
                                                      Task>>()
                                              .state
                                              ?.sdate
                                              ?.stringToDateTime()
                                              ?.toFormatedString(
                                                  "dd-MMM-yyyy") ??
                                          "Start Date"
                                      : widget.data.sdate ?? ""),
                            ),
                            widget.data.sdate == "N/A"
                                ? InkWell(
                                    onTap: () async {
                                      var selectedDate = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now().subtract(
                                            const Duration(days: 120)),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 120)),
                                        initialDate: DateTime.now(),
                                      );
                                      if (selectedDate != null &&
                                          context.mounted) {
                                        var stateTask = context
                                            .read<
                                                VariableStateHandlerCubit<
                                                    Task>>()
                                            .state!;
                                        context
                                            .read<
                                                VariableStateHandlerCubit<
                                                    Task>>()
                                            .update(
                                              stateTask.copyWith(
                                                sdate: selectedDate.toString(),
                                              ),
                                            );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.calendar_month_sharp,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      const Text(" -- "),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                  textAlign: widget.data.sdate == "N/A"
                                      ? TextAlign.left
                                      : TextAlign.right,
                                  widget.data.sdate == "N/A"
                                      ? context
                                              .watch<
                                                  VariableStateHandlerCubit<
                                                      Task>>()
                                              .state
                                              ?.tdate
                                              ?.stringToDateTime()
                                              ?.toFormatedString(
                                                  "dd-MMM-yyyy") ??
                                          "Select Cmplt"
                                      : widget.data.sdate ?? ""),
                            ),
                            BlocBuilder<VariableStateHandlerCubit<Task>, Task?>(
                              builder: (context, state) {
                                if (state != null && state.sdate != null) {
                                  return InkWell(
                                    onTap: () async {
                                      var startDate = DateTime.parse(context
                                              .read<
                                                  VariableStateHandlerCubit<
                                                      Task>>()
                                              .state!
                                              .sdate ??
                                          "");
                                      var selectedDate = await showDatePicker(
                                        context: context,
                                        firstDate: startDate,
                                        lastDate: startDate
                                            .add(const Duration(days: 120)),
                                        initialDate: startDate,
                                      );
                                      if (selectedDate != null &&
                                          context.mounted) {
                                        var stateTask = context
                                            .read<
                                                VariableStateHandlerCubit<
                                                    Task>>()
                                            .state!;
                                        context
                                            .read<
                                                VariableStateHandlerCubit<
                                                    Task>>()
                                            .update(
                                              stateTask.copyWith(
                                                tdate: selectedDate.toString(),
                                              ),
                                            );
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
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<VariableStateHandlerCubit<NewTask>, NewTask?>(
                        builder: (context, state) {
                          if (state != null &&
                              (state.stDate?.isNotEmpty ?? false) &&
                              (state.enDate?.isNotEmpty ?? false) &&
                              (state.manPower?.isNotEmpty ?? false) &&
                              (state.hour?.isNotEmpty ?? false) &&
                              (state.dept?.isNotEmpty ?? false) &&
                              (state.buyer?.isNotEmpty ?? false) &&
                              (state.userId?.isNotEmpty ?? false)) {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade100,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    textAlign: TextAlign.right,
                                    state.taskName ?? "",
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.left,
                                          state.stDate != null &&
                                                  state.stDate!.isNotEmpty
                                              ? DateTime.parse(
                                                  state.stDate ?? "",
                                                ).toFormatedString(
                                                  "dd-MMM-yyyy")
                                              : "",
                                        ),
                                      ),
                                      const Text("--"),
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.right,
                                          state.enDate != null &&
                                                  state.enDate!.isNotEmpty
                                              ? DateTime.parse(
                                                  state.enDate ?? "",
                                                ).toFormatedString(
                                                  "dd-MMM-yyyy")
                                              : "",
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.left,
                                          "${state.manPower ?? ""}-Man",
                                        ),
                                      ),
                                      const Text("--"),
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.right,
                                          "${state.hour ?? ""}-hr",
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.left,
                                          "Dept: ${state.dept ?? ""}",
                                        ),
                                      ),
                                      const Text("--"),
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.right,
                                          "Buyer: ${state.buyer ?? ""}",
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    textAlign: TextAlign.left,
                                    "Assigned To: ${state.userName ?? ""}(${state.userId})",
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.data.sdate == "N/A"
                          ? SizedBox(
                              height: 30.0,
                              width: 30.0,
                              child: IconButton.filled(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.add_sharp,
                                  color: appTheme.white,
                                ),
                                onPressed: () async {
                                  await AppModal.showCustomModal(
                                    context,
                                    content: NewTaskWidget(
                                      blocContext: context,
                                      widget: widget,
                                      taskFocusNode: _taskFocusNode,
                                      taskNameController: _taskNameController,
                                      manDateFocusNode: _manDateFocusNode,
                                      manController: _manController,
                                      hourDateFocusNode: _hourDateFocusNode,
                                      hourController: _hourController,
                                      stDateController: _stDateController,
                                      enDateController: _enDateController,
                                    ),
                                  );
                                  if (context.mounted) {
                                    var newtask = context
                                            .read<
                                                VariableStateHandlerCubit<
                                                    NewTask>>()
                                            .state ??
                                        NewTask();
                                    newtask = newtask.copyWith(
                                      taskName: _taskNameController.text,
                                      stDate: _stDateController.text,
                                      enDate: _enDateController.text,
                                      manPower: _manController.text,
                                      hour: _hourController.text,
                                    );
                                    context
                                        .read<
                                            VariableStateHandlerCubit<
                                                NewTask>>()
                                        .update(newtask);
                                  }
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
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
    if (context.watch<VariableStateHandlerCubit<Task>>().state != null &&
        context.watch<VariableStateHandlerCubit<Task>>().state!.sdate != null &&
        context.watch<VariableStateHandlerCubit<Task>>().state!.tdate != null) {
      return true;
    } else {
      return false;
    }
  }
}

class NewTaskWidget extends StatefulWidget {
  const NewTaskWidget({
    super.key,
    required this.widget,
    required FocusNode taskFocusNode,
    required TextEditingController taskNameController,
    required FocusNode manDateFocusNode,
    required TextEditingController manController,
    required FocusNode hourDateFocusNode,
    required TextEditingController hourController,
    required TextEditingController stDateController,
    required TextEditingController enDateController,
    required this.blocContext,
  })  : _taskFocusNode = taskFocusNode,
        _taskNameController = taskNameController,
        _manFocusNode = manDateFocusNode,
        _manController = manController,
        _hourFocusNode = hourDateFocusNode,
        _hourController = hourController,
        _stDateController = stDateController,
        _enDateController = enDateController;

  final TaskWidgetContent widget;
  final FocusNode _taskFocusNode;
  final TextEditingController _taskNameController;
  final FocusNode _manFocusNode;
  final TextEditingController _manController;
  final FocusNode _hourFocusNode;
  final TextEditingController _hourController;
  final TextEditingController _stDateController;
  final TextEditingController _enDateController;
  final BuildContext blocContext;
  @override
  State<NewTaskWidget> createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<DeptListBloc>(widget.blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<BuyerListBloc>(widget.blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<QrUserBloc>(widget.blocContext),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonDialogHeader(
              title: widget.widget.data.taskName ?? "",
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 65,
              child: CommonTextFieldWidget(
                focusNode: widget._taskFocusNode,
                controller: widget._taskNameController,
                labelText: "New Task",
                expands: true,
                maxLines: null,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: CommonTextFieldWidget(
                    focusNode: widget._manFocusNode,
                    controller: widget._manController,
                    labelText: "Man",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CommonTextFieldWidget(
                    focusNode: widget._hourFocusNode,
                    controller: widget._hourController,
                    labelText: "Hour",
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: CommonTextFieldWidget(
                    readOnly: true,
                    hintText: "Start Date",
                    controller: widget._stDateController,
                    suffixIcon: const Icon(
                      Icons.calendar_month,
                    ),
                    onTap: () async {
                      var selectedDate = await showDatePicker(
                        context: context,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 120)),
                        lastDate: DateTime.now().add(const Duration(days: 120)),
                        initialDate: DateTime.now(),
                      );
                      if (selectedDate != null && context.mounted) {
                        widget._stDateController.text = selectedDate.toString();
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CommonTextFieldWidget(
                    readOnly: true,
                    hintText: "End Date",
                    controller: widget._enDateController,
                    suffixIcon: const Icon(
                      Icons.calendar_month,
                    ),
                    onTap: () async {
                      var selectedDate = await showDatePicker(
                        context: context,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 120)),
                        lastDate: DateTime.now().add(const Duration(days: 120)),
                        initialDate: DateTime.now(),
                      );
                      if (selectedDate != null && context.mounted) {
                        widget._enDateController.text = selectedDate.toString();
                      }
                    },
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: BlocBuilder<DeptListBloc, DeptListState>(
                    builder: (context, state) {
                      return CommonDropdownButton<Department>(
                        hintText: "Department",
                        items: state is DeptListSuccess ? state.deptList : [],
                        onChanged: (value) {
                          var newtask = widget.blocContext
                                  .read<VariableStateHandlerCubit<NewTask>>()
                                  .state ??
                              NewTask();
                          newtask = newtask.copyWith(dept: value?.taskDept);
                          widget.blocContext
                              .read<VariableStateHandlerCubit<NewTask>>()
                              .update(newtask);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: BlocBuilder<BuyerListBloc, BuyerListState>(
                    builder: (context, state) {
                      return CommonDropdownButton<Buyer>(
                        hintText: "Buyer",
                        items: state is BuyerListSuccess ? state.buyerList : [],
                        onChanged: (value) {
                          var newtask = widget.blocContext
                                  .read<VariableStateHandlerCubit<NewTask>>()
                                  .state ??
                              NewTask();
                          newtask = newtask.copyWith(buyer: value?.buyerName);
                          widget.blocContext
                              .read<VariableStateHandlerCubit<NewTask>>()
                              .update(newtask);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<QrUserBloc, QrUserState>(
              builder: (context, state) {
                return CommonDropdownButton<QrUserData>(
                  hintText: "User",
                  items: state is QrUserSuccess ? state.qrUsers : [],
                  onChanged: (value) {
                    var newtask = widget.blocContext
                            .read<VariableStateHandlerCubit<NewTask>>()
                            .state ??
                        NewTask();
                    newtask = newtask.copyWith(
                        userId: value?.userId, userName: value?.userName);
                    widget.blocContext
                        .read<VariableStateHandlerCubit<NewTask>>()
                        .update(newtask);
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
