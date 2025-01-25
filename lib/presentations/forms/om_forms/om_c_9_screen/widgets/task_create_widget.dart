import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
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
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/data_class/main_task.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';

import 'package:pran_rfl_erp/global_blocs/bloc/dept_list_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/task_create_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/qr_user_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/bloc/task_assign_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/bloc/task_list_bloc.dart';

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
  });
  final int index;

  final VariableStateHandlerCubit<TaskType> taskTypeCubit;
  final VariableStateHandlerCubit<Task> taskCubit;

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
          // direction: _saveValidation()
          //     ? DismissDirection.startToEnd
          //     : DismissDirection.none,
          direction: DismissDirection.startToEnd,
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
              log(widget.joInfo.jobId.toString());
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
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: "Task Assigned Successfully",
              ),
            );
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
                      SizedBox(
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
                                  .watch<VariableStateHandlerCubit<TaskType>>()
                                  .state!
                            },
                            onSelectionChanged: (Set<TaskType> newSelection) {
                              context
                                  .read<VariableStateHandlerCubit<TaskType>>()
                                  .update(newSelection.first);
                              if (newSelection.first == TaskType.independent) {
                                var stateTask = context
                                    .read<VariableStateHandlerCubit<Task>>()
                                    .state!;
                                context
                                    .read<VariableStateHandlerCubit<Task>>()
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
                      ),
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
                                value: widget.taskList.firstWhereOrNull(
                                  (element) {
                                    return element.taskNo ==
                                        context
                                            .read<
                                                VariableStateHandlerCubit<
                                                    Task>>()
                                            .state
                                            ?.pId;
                                  },
                                ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BlocBuilder<VariableStateHandlerCubit<NewTask>, NewTask?>(
                      //   builder: (context, state) {
                      //     if (state != null &&
                      //         (state.stDate?.isNotEmpty ?? false) &&
                      //         (state.enDate?.isNotEmpty ?? false) &&
                      //         (state.manPower?.isNotEmpty ?? false) &&
                      //         (state.hour?.isNotEmpty ?? false) &&
                      //         (state.dept?.isNotEmpty ?? false) &&
                      //         (state.buyer?.isNotEmpty ?? false) &&
                      //         (state.userId?.isNotEmpty ?? false)) {
                      //       return Column(
                      //         children: [
                      //           const SizedBox(
                      //             height: 10,
                      //           ),
                      //           Container(
                      //             padding: const EdgeInsets.all(5),
                      //             decoration: BoxDecoration(
                      //               color: Colors.indigo.shade100,
                      //               borderRadius: BorderRadius.circular(5),
                      //             ),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 Text(
                      //                   textAlign: TextAlign.right,
                      //                   state.taskName ?? "",
                      //                 ),
                      //                 Row(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Expanded(
                      //                       child: Text(
                      //                         textAlign: TextAlign.left,
                      //                         state.stDate != null &&
                      //                                 state.stDate!.isNotEmpty
                      //                             ? DateTime.parse(
                      //                                 state.stDate ?? "",
                      //                               ).toFormatedString(
                      //                                 "dd-MMM-yyyy")
                      //                             : "",
                      //                       ),
                      //                     ),
                      //                     const Text("--"),
                      //                     Expanded(
                      //                       child: Text(
                      //                         textAlign: TextAlign.right,
                      //                         state.enDate != null &&
                      //                                 state.enDate!.isNotEmpty
                      //                             ? DateTime.parse(
                      //                                 state.enDate ?? "",
                      //                               ).toFormatedString(
                      //                                 "dd-MMM-yyyy")
                      //                             : "",
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 Row(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Expanded(
                      //                       child: Text(
                      //                         textAlign: TextAlign.left,
                      //                         "${state.manPower ?? ""}-Man",
                      //                       ),
                      //                     ),
                      //                     const Text("--"),
                      //                     Expanded(
                      //                       child: Text(
                      //                         textAlign: TextAlign.right,
                      //                         "${state.hour ?? ""}-hr",
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 Row(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Expanded(
                      //                       child: Text(
                      //                         textAlign: TextAlign.left,
                      //                         "Dept: ${state.dept ?? ""}",
                      //                       ),
                      //                     ),
                      //                     const Text("--"),
                      //                     Expanded(
                      //                       child: Text(
                      //                         textAlign: TextAlign.right,
                      //                         "Buyer: ${state.buyer ?? ""}",
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 Text(
                      //                   textAlign: TextAlign.left,
                      //                   "Assigned To: ${state.userName ?? ""}(${state.userId})",
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       );
                      //     }
                      //     return const SizedBox.shrink();
                      //   },
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: IconButton.filled(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.add_sharp,
                            color: appTheme.white,
                          ),
                          onPressed: () async {
                            var result = await AppModal.showCustomModal<bool>(
                                  context,
                                  content: NewTaskWidget(
                                    blocContext: context,
                                    widget: widget,
                                  ),
                                ) ??
                                false;
                            if (result && context.mounted) {
                              var loggedUser =
                                  context.read<LoggedUserInfoCubit>().state!;
                              context.read<TaskListBloc>().add(
                                    GetTaskList(
                                      userId: loggedUser.userId,
                                    ),
                                  );
                            }
                          },
                        ),
                      ),
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

  // bool _saveValidation() {
  //   if (context.watch<VariableStateHandlerCubit<Task>>().state != null &&
  //       context.watch<VariableStateHandlerCubit<Task>>().state!.sdate != null &&
  //       context.watch<VariableStateHandlerCubit<Task>>().state!.tdate != null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}

class NewTaskWidget extends StatefulWidget {
  const NewTaskWidget({
    super.key,
    required this.widget,
    required this.blocContext,
  });

  final TaskWidgetContent widget;
  final BuildContext blocContext;

  @override
  State<NewTaskWidget> createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  late FocusNode _taskFocusNode;
  late TextEditingController _taskNameController;
  late FocusNode _manFocusNode;
  late TextEditingController _manController;
  late FocusNode _hourFocusNode;
  late TextEditingController _hourController;
  late TextEditingController _stDateController;
  late TextEditingController _enDateController;
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  Department? _selectedDept;
  QrUserData? _selectedassigne;
  @override
  void initState() {
    _taskFocusNode = FocusNode();
    _taskNameController = TextEditingController();
    _manFocusNode = FocusNode();
    _manController = TextEditingController();
    _hourFocusNode = FocusNode();
    _hourController = TextEditingController();
    _stDateController = TextEditingController();
    _enDateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _taskFocusNode.dispose();
    _taskNameController.dispose();
    _manFocusNode.dispose();
    _manController.dispose();
    _hourFocusNode.dispose();
    _hourController.dispose();
    _stDateController.dispose();
    _enDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<DeptListBloc>(widget.blocContext),
        ),
        // BlocProvider.value(
        //   value: BlocProvider.of<BuyerListBloc>(widget.blocContext),
        // ),
        BlocProvider(
          create: (context) => TaskCreateBloc(getService()),
        ),
        BlocProvider.value(
          value: BlocProvider.of<QrUserBloc>(widget.blocContext),
        ),
      ],
      child: BlocListener<TaskCreateBloc, TaskCreateState>(
        listener: (context, state) {
          if (state is TaskCreateSuccess) {
            _taskNameController.clear();

            _manController.clear();

            _hourController.clear();
            _stDateController.clear();
            _enDateController.clear();
            _selectedDept = null;
            _selectedassigne = null;
            context.pop(true);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Form(
            key: _fromKey,
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
                    focusNode: _taskFocusNode,
                    controller: _taskNameController,
                    labelText: "New Task",
                    expands: true,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Task Name";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CommonTextFieldWidget(
                        focusNode: _manFocusNode,
                        controller: _manController,
                        labelText: "Man",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Man";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CommonTextFieldWidget(
                        focusNode: _hourFocusNode,
                        controller: _hourController,
                        labelText: "Hour",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Hour";
                          }
                          return null;
                        },
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
                        controller: _stDateController,
                        suffixIcon: const Icon(
                          Icons.calendar_month,
                        ),
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 120)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 120)),
                            initialDate: DateTime.now(),
                          );
                          if (selectedDate != null && context.mounted) {
                            _stDateController.text = selectedDate.toString();
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Stdate";
                          }
                          return null;
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
                        controller: _enDateController,
                        suffixIcon: const Icon(
                          Icons.calendar_month,
                        ),
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 120)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 120)),
                            initialDate: DateTime.now(),
                          );
                          if (selectedDate != null && context.mounted) {
                            _enDateController.text = selectedDate.toString();
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Endate";
                          }
                          return null;
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
                            items:
                                state is DeptListSuccess ? state.deptList : [],
                            value: _selectedDept,
                            onChanged: (value) {
                              setState(() {
                                _selectedDept = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Please Enter Dept";
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: BlocBuilder<QrUserBloc, QrUserState>(
                        builder: (context, state) {
                          return CommonDropdownButton<QrUserData>(
                            hintText: "Assignee",
                            value: _selectedassigne,
                            items: state is QrUserSuccess ? state.qrUsers : [],
                            onChanged: (value) {
                              setState(() {
                                _selectedassigne = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Please Enter Assignee";
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                    // Expanded(
                    //   child: BlocBuilder<BuyerListBloc, BuyerListState>(
                    //     builder: (context, state) {
                    //       return CommonDropdownButton<Buyer>(
                    //         hintText: "Buyer",
                    //         items: state is BuyerListSuccess ? state.buyerList : [],
                    //         onChanged: (value) {
                    //           var newtask = widget.blocContext
                    //                   .read<VariableStateHandlerCubit<NewTask>>()
                    //                   .state ??
                    //               NewTask();
                    //           newtask = newtask.copyWith(buyer: value?.buyerName);
                    //           widget.blocContext
                    //               .read<VariableStateHandlerCubit<NewTask>>()
                    //               .update(newtask);
                    //         },
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: BlocBuilder<TaskCreateBloc, TaskCreateState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (_fromKey.currentState!.validate()) {
                            MainTask newChildTask = MainTask();
                            newChildTask = newChildTask.copyWith(
                              taskparentid:
                                  widget.widget.data.taskNo?.toString() ?? "0",
                              projectId: Project(
                                projectId: widget.widget.data.projectId,
                              ),
                              taskName: _taskNameController.text,
                              taskDesc: _taskNameController.text,
                              man: _manController.text,
                              hr: _hourController.text,
                              stDate: DateTime.parse(_stDateController.text)
                                  .toFormatedString("dd-MMM-yyyy"),
                              enDate: DateTime.parse(_enDateController.text)
                                  .toFormatedString("dd-MMM-yyyy"),
                              taskDept: _selectedDept,
                              assignee: _selectedassigne,
                            );

                            var loggedUser =
                                context.read<LoggedUserInfoCubit>().state!;
                            context.read<TaskCreateBloc>().add(
                                  TaskCreate(
                                    userId: loggedUser.userId,
                                    mainTask: newChildTask,
                                  ),
                                );
                          }
                        },
                        child: Text(
                          state is TaskCreateLoading ? "Creating..." : "Create",
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
