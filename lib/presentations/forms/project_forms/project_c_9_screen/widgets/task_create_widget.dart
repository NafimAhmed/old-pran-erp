import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/department_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/project_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_dialog_header.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_dropdown_search.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/data_class/main_task.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/dept_list_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/task_create_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/qr_user_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_9_screen/bloc/task_assign_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_9_screen/bloc/task_list_bloc.dart';

class TaskCreateWidget extends StatelessWidget {
  const TaskCreateWidget({
    super.key,
    required this.index,
    required this.data,
    required this.taskList,
    required this.taskCubit,
    required this.loggedUser,
    required this.assigneeCubit,
    required this.departmentCubit,
    required this.searchValue,
  });
  final int index;

  final VariableStateHandlerCubit<Task> taskCubit;
  final VariableStateHandlerCubit<QrUserData> assigneeCubit;
  final VariableStateHandlerCubit<Department> departmentCubit;
  final Task data;
  final List<Task> taskList;
  final UserInfoModel loggedUser;
  final String searchValue;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: assigneeCubit,
        ),
        BlocProvider.value(
          value: departmentCubit,
        ),
        BlocProvider.value(
          value: taskCubit,
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
        searchValue: searchValue,
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
    required this.searchValue,
  });
  final int index;
  final Task data;
  final List<Task> taskList;
  final UserInfoModel loggedUser;
  final String searchValue;

  @override
  State<TaskWidgetContent> createState() => _TaskWidgetContentState();
}

class _TaskWidgetContentState extends State<TaskWidgetContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var selectedAssignee =
        context.watch<VariableStateHandlerCubit<QrUserData>>().state;
    var selectedDepartment =
        context.watch<VariableStateHandlerCubit<Department>>().state;
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
          direction: selectedAssignee != null || selectedDepartment != null
              ? DismissDirection.startToEnd
              : DismissDirection.none,
          // direction: DismissDirection.startToEnd,
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
              context.read<TaskAssignBloc>().add(
                    TaskAssign(
                        assigneeId: selectedAssignee?.userId ?? "",
                        department: selectedDepartment?.taskDept ?? "",
                        userId: widget.loggedUser.userId,
                        taskId: widget.data.taskNo?.toString() ?? ""),
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
            context.read<VariableStateHandlerCubit<Task>>().update(Task());

            context.read<TaskListBloc>().add(RemoveTask(index: widget.index));
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: "Task Assigned Successfully",
              ),
            );
            context.read<VariableStateHandlerCubit<QrUserData>>().reset();
            context.read<VariableStateHandlerCubit<Department>>().reset();
            context.read<TaskListBloc>().add(
                  TaskListGet(
                    userId: widget.loggedUser.userId,
                    searchValue: widget.searchValue,
                  ),
                );
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.jobOrderNo ?? "",
                    style: textTheme.bodyMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Task Name:",
                        style: textTheme.bodyMedium,
                      ),
                      Flexible(
                        child: Text(
                          widget.data.taskName ?? "",
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                  textAlign: TextAlign.left,
                                  widget.data.sdate ?? ""),
                            ),
                          ],
                        ),
                      ),
                      const Text(" -- "),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                  textAlign: TextAlign.right,
                                  widget.data.sdate ?? ""),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<QrUserBloc, QrUserState>(
                          builder: (context, state) {
                            return CustomDropdownSearch<QrUserData>(
                              hintText: "Assignee",
                              value: selectedAssignee,
                              items:
                                  state is QrUserSuccess ? state.qrUsers : [],
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<
                                          VariableStateHandlerCubit<
                                              QrUserData>>()
                                      .update(value);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: BlocBuilder<DeptListBloc, DeptListState>(
                          builder: (context, state) {
                            return CommonDropdownButton<Department>(
                              hintText: "Department",
                              items: state is DeptListSuccess
                                  ? state.deptList
                                  : [],
                              value: selectedDepartment,
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<
                                          VariableStateHandlerCubit<
                                              Department>>()
                                      .update(value);
                                }
                              },
                            );
                          },
                        ),
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
}
