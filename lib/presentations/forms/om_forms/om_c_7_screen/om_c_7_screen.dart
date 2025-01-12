import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_info_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_7_screen/bloc/Jo_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_7_screen/bloc/task_Save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_7_screen/bloc/task_info_bloc.dart';

class OmC7Screen extends StatelessWidget {
  const OmC7Screen({super.key, required this.fromName});
  static const String routeName = "OM-C-7-SCREEN";
  static const String routePath = "/OM-C-7-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => JoInfoBloc(getService()),
        ),
        BlocProvider(
          create: (context) => TaskInfoBloc(getService()),
        ),
        BlocProvider(
          create: (context) => TaskSaveBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<JoInfo>(),
        ),
      ],
      child: OmC7ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class OmC7ScreenBody extends StatefulWidget {
  const OmC7ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OmC7ScreenBody> createState() => _OmC7ScreenBodyState();
}

enum TaskStatusType {
  pending("Pending"),
  completed("Completed"),
  start("Start"),
  closed("Closed");

  const TaskStatusType(this.value);

  final String value;
  @override
  String toString() {
    return value;
  }
}

class _OmC7ScreenBodyState extends State<OmC7ScreenBody> {
  TextEditingController taskTextEditingController = TextEditingController();
  TextEditingController orgDropDownTextController = TextEditingController();
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;

    context.read<JoInfoBloc>().add(
          GetJoInfo(
            userId: loggedUser.userId,
          ),
        );
    super.initState();
  }

  @override
  void dispose() {
    taskTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: BlocListener<TaskSaveBloc, TaskSaveState>(
        listener: (context, state) {
          if (state is TaskSaveSuccess) {
            // taskTextEditingController.clear();

            // context.read<VariableStateHandlerCubit<TaskStatusType>>().reset();
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: "Successfully Saved",
              ),
            );
            var selectedJob =
                context.read<VariableStateHandlerCubit<JoInfo>>().state!;
            context.read<TaskInfoBloc>().add(
                  GetTaskInfo(
                      userId: loggedUser.userId,
                      jobOrderNo: selectedJob.jobOrderNo ?? ""),
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
              BlocBuilder<JoInfoBloc, JoInfoState>(
                builder: (context, state) {
                  return CommonDropDownMenuWidget<JoInfo>(
                    hintText: "Job Order No",
                    enabled: state is JoInfoSuccess ? true : false,
                    controller: orgDropDownTextController,
                    dropdownMenuEntries:
                        state is JoInfoSuccess ? state.joInfoList : [],
                    onSelected: (value) {
                      if (value != null) {
                        // FocusScope.of(context).unfocus();
                        // FocusManager.instance.primaryFocus?.unfocus();
                        context
                            .read<VariableStateHandlerCubit<JoInfo>>()
                            .update(value);
                        context.read<TaskInfoBloc>().add(
                              GetTaskInfo(
                                  userId: loggedUser.userId,
                                  jobOrderNo: value.jobOrderNo ?? ""),
                            );
                      }
                    },
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
  });

  final TaskInfo data;
  final int index;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VariableStateHandlerCubit<TaskStatusType>(),
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
          return await showDialog<bool>(
                context: context,
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
        },
        onDismissed: (direction) {
          context.read<TaskInfoBloc>().add(RemoveTaskInfo(index: index));

          var status =
              context.read<VariableStateHandlerCubit<TaskStatusType>>().state!;
          var loggedUser = context.read<LoggedUserInfoCubit>().state!;
          context.read<TaskSaveBloc>().add(
                TaskSave(
                  userId: loggedUser.userId,
                  taskStatus: status.value,
                  taskId: data.tasksid ?? 0,
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: appTheme.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      "Department",
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
                      "Status",
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
                      "Start Date",
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
                const SizedBox(
                  height: 5,
                ),
                CommonDropdownButton<TaskStatusType>(
                  value: context
                      .watch<VariableStateHandlerCubit<TaskStatusType>>()
                      .state,
                  fillColor: appTheme.primary,
                  hintcolor: Colors.white,
                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<VariableStateHandlerCubit<TaskStatusType>>()
                          .update(value);
                    }
                  },
                  hintText: "Change Task Status",
                  items: TaskStatusType.values,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
