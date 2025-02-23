import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_info_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_dialog_header.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/add_task_note_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/exAuto_task_save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/task_info_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/task_note_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/task_save_bloc.dart';

class ProjectC2Screen extends StatelessWidget {
  const ProjectC2Screen({super.key, required this.fromName});
  static const String routeName = "PROJECT-C-2-SCREEN";
  static const String routePath = "/PROJECT-C-2-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskInfoBloc(getService()),
        ),
        BlocProvider(
          create: (context) => TaskSaveBloc(getService()),
        ),
        BlocProvider(
          create: (context) => ExAutoTaskSaveBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<JoInfo>(),
        ),
      ],
      child: ProjectC2ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class ProjectC2ScreenBody extends StatefulWidget {
  const ProjectC2ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<ProjectC2ScreenBody> createState() => _ProjectC2ScreenBodyState();
}

enum TaskStatusType {
  pending("Pending"),
  start("Start"),
  completed("Completed");

  const TaskStatusType(this.value);

  final String value;
  @override
  String toString() {
    return value;
  }
}

class _ProjectC2ScreenBodyState extends State<ProjectC2ScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late UserInfoModel loggedUser;
  final Map<int, VariableStateHandlerCubit<TaskStatusType>>
      taskStatusTypeCubits = {};
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;

    context.read<TaskInfoBloc>().add(
          TaskInfoGet(
            userId: loggedUser.userId,
            searchValue: _searchController.text,
          ),
        );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: BlocListener<TaskSaveBloc, TaskSaveState>(
        listener: (context, state) {
          if (state is TaskSaveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: "Successfully Saved",
              ),
            );

            context.read<TaskInfoBloc>().add(
                  TaskInfoGet(
                    userId: loggedUser.userId,
                    searchValue: _searchController.text,
                  ),
                );
          }
          if (state is TaskSaveError) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.errorSnackber(
                message: state.error.toString(),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              CommonTextFieldWidget(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hintText: "Search",
                onChanged: (value) {
                  context.read<TaskInfoBloc>().add(
                        TaskInfoFilter(
                          searchValue: value,
                        ),
                      );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: BlocBuilder<TaskInfoBloc, TaskInfoState>(
                  builder: (context, state) {
                    if (state is TaskInfoLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is TaskInfoSuccess) {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          var data = state.taskInfoList[index];
                          return TaskWidget(
                            taskStatusTypeCubit:
                                taskStatusTypeCubits.putIfAbsent(
                              data.tasksid ?? 0,
                              () => VariableStateHandlerCubit<TaskStatusType>(),
                            ),
                            index: index,
                            data: data,
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: state.taskInfoList.length,
                      );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
            context.read<ExAutoTaskSaveBloc>().add(
                  ExAutoTaskSave(
                    taskId: data.refNo ?? 0,
                    vUser: loggedUser.userId,
                    vCustomerPo: data.projectName ?? "",
                    vJobOrderNo: data.jobOrderNo ?? "",
                    vStatus: status.value,
                    vAdate: data.taskCreactionDate ?? "",
                    vFdate: data.taskCompletionDate ?? "",
                    vTdate: data.taskStartDate ?? "",
                    vNote: "",
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
                Text(
                  data.jobOrderNo ?? "",
                  style: textTheme.bodyMedium!.copyWith(
                    color: appTheme.primary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Task:",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.primary,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        data.taskName ?? "",
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
                      "Status:",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.primary,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        data.taskStatus ?? "",
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
                      "Creatn Date:",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.primary,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        DateTime.parse(data.taskCreactionDate ?? "")
                            .toFormatedString("dd-MMM-yyyy"),
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
                      "Start Date:",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.primary,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        DateTime.parse(data.taskStartDate ?? "")
                            .toFormatedString("dd-MMM-yyyy"),
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
                      "StCm Date:",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.primary,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        DateTime.parse(data.taskCompletionDate ?? "")
                            .toFormatedString("dd-MMM-yyyy"),
                        style: textTheme.bodyMedium!.copyWith(
                          color: appTheme.primary,
                        ),
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
}

class NoteDialogWidget extends StatelessWidget {
  const NoteDialogWidget({
    super.key,
    required this.taskInfo,
    required this.userId,
  });
  final TaskInfo taskInfo;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddTaskNoteBloc(getService()),
        ),
        BlocProvider(
          create: (context) => TaskNoteListBloc(getService())
            ..add(
                TaskNoteListGet(userId: userId, taskId: taskInfo.tasksid ?? 0)),
        ),
      ],
      child: NoteDialogContent(taskInfo: taskInfo, userId: userId),
    );
  }
}

class NoteDialogContent extends StatefulWidget {
  const NoteDialogContent({
    super.key,
    required this.taskInfo,
    required this.userId,
  });
  final TaskInfo taskInfo;
  final String userId;
  @override
  State<NoteDialogContent> createState() => _NoteDialogContentState();
}

class _NoteDialogContentState extends State<NoteDialogContent> {
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  late TextEditingController _noteController;
  late FocusNode _noteFocusNode;
  @override
  void initState() {
    _noteController = TextEditingController();
    _noteFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTaskNoteBloc, AddTaskNoteState>(
      listener: (context, state) {
        if (state is AddTaskNoteSuccess) {
          _noteController.clear();
          context.read<TaskNoteListBloc>().add(
                TaskNoteListGet(
                  userId: widget.userId,
                  taskId: widget.taskInfo.tasksid ?? 0,
                ),
              );
        }
      },
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 400,
        ),
        padding: const EdgeInsets.all(5),
        child: Form(
          key: _fromKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonDialogHeader(
                title: widget.taskInfo.taskName ?? "",
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 65,
                child: CommonTextFieldWidget(
                  focusNode: _noteFocusNode,
                  controller: _noteController,
                  labelText: "New Note",
                  expands: true,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Note can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<AddTaskNoteBloc, AddTaskNoteState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_fromKey.currentState!.validate()) {
                        context.read<AddTaskNoteBloc>().add(
                              AddTaskNote(
                                userId: widget.userId,
                                taskNote: _noteController.text,
                                taskId: widget.taskInfo.tasksid ?? 0,
                              ),
                            );
                      }
                    },
                    child: Text(
                      state is AddTaskNoteLoading ? "Adding..." : "Add Note",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                color: appTheme.dividerColor,
                height: 2,
                indent: 5,
                endIndent: 5,
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: BlocBuilder<TaskNoteListBloc, TaskNoteListState>(
                  builder: (context, state) {
                    if (state is TaskNoteListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is TaskNoteListSuccess) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: appTheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            var data = state.taskNoteList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1}. ${data.noteContent}",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                          itemCount: state.taskNoteList.length,
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
