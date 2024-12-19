import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_7_screen/bloc/job_task_info_bloc.dart';
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
          create: (context) => JobTaskInfoBloc(getService()),
        ),
        BlocProvider(
          create: (context) => TaskInfoBloc(getService()),
        ),
        BlocProvider(
          create: (context) => TaskSaveBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<TaskInfo>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<TaskStatusType>(),
        )
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
  start("START"),
  closed("CLOSED"),
  completed("COMPLETED"),
  pending("PENDING");

  const TaskStatusType(this.value);

  final String value;
  @override
  String toString() {
    return name;
  }
}

class _OmC7ScreenBodyState extends State<OmC7ScreenBody> {
  TextEditingController taskTextEditingController = TextEditingController();
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<JobTaskInfoBloc>().add(
          GetJobTaskInfo(
            userId: loggedUser.userId,
          ),
        );
    context.read<TaskInfoBloc>().add(
          GetTaskInfo(
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
            taskTextEditingController.clear();
            context.read<VariableStateHandlerCubit<TaskInfo>>().reset();
            context.read<VariableStateHandlerCubit<TaskStatusType>>().reset();
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: "Successfully Saved",
              ),
            );
            context.read<TaskInfoBloc>().add(
                  GetTaskInfo(
                    userId: loggedUser.userId,
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
              BlocBuilder<JobTaskInfoBloc, JobTaskInfoState>(
                builder: (context, state) {
                  return CommonDropDownMenuWidget<TaskInfo>(
                    controller: taskTextEditingController,
                    enabled: state is JobTaskInfoSuccess
                        ? state.jobTaskInfoList.isNotEmpty
                        : false,
                    hintText: "Select Task",
                    dropdownMenuEntries: state is JobTaskInfoSuccess
                        ? state.jobTaskInfoList
                        : [],
                    onSelected: (value) {
                      if (value != null) {
                        context
                            .read<VariableStateHandlerCubit<TaskInfo>>()
                            .update(value);
                      }
                    },
                  );
                },
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
                              .read<VariableStateHandlerCubit<TaskStatusType>>()
                              .update(value);
                        }
                      },
                      hintText: "Task Status",
                      items: TaskStatusType.values,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  BlocBuilder<TaskSaveBloc, TaskSaveState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          var selectedTask = context
                              .read<VariableStateHandlerCubit<TaskInfo>>()
                              .state!;
                          var selectedStatus = context
                              .read<VariableStateHandlerCubit<TaskStatusType>>()
                              .state!;
                          context.read<TaskSaveBloc>().add(
                                TaskSave(
                                  userId: loggedUser.userId,
                                  taskStatus: selectedStatus.value,
                                  taskId: selectedTask.tasksid ?? 0,
                                ),
                              );
                        },
                        child: Text(
                          state is TaskSaveLoading ? "Saving.." : "Save",
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                      );
                    },
                  ),
                ],
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
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: appTheme.white,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                )
                              ],
                            ),
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
