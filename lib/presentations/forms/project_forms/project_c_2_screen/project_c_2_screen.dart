import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/exAuto_task_save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/task_info_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/bloc/task_save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_2_screen/widgets/task_widget.dart';

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
          create: (context) => ExAutoTaskSaveBloc(getService()),
        ),
        BlocProvider(
          create: (context) => TaskSaveBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<JoInfo>(),
        ),
        BlocProvider(
          create: (context) =>
              VariableStateHandlerCubit<String>()..update("All"),
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
    var filterValue = context.read<VariableStateHandlerCubit<String>>().state!;
    context.read<TaskInfoBloc>().add(
          TaskInfoGet(
            userId: loggedUser.userId,
            searchValue: _searchController.text,
            filterValue: filterValue,
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
            var filterValue =
                context.read<VariableStateHandlerCubit<String>>().state!;
            context.read<TaskInfoBloc>().add(
                  TaskInfoGet(
                    userId: loggedUser.userId,
                    searchValue: _searchController.text,
                    filterValue: filterValue,
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonTextFieldWidget(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      hintText: "Search",
                      onChanged: (value) {
                        var filterValue = context
                            .read<VariableStateHandlerCubit<String>>()
                            .state!;
                        context.read<TaskInfoBloc>().add(
                              TaskInfoFilter(
                                  searchValue: value, filterValue: filterValue),
                            );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  BlocBuilder<TaskInfoBloc, TaskInfoState>(
                    builder: (context, state) {
                      if (state is TaskInfoSuccess) {
                        return PopupMenuButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.filter_alt_outlined,
                            color: appTheme.primary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          elevation: 8,
                          itemBuilder: (context) {
                            var groupedList = groupBy(
                              state.taskInfoList,
                              (e) => e.parentTaskName ?? "",
                            );

                            return [
                              PopupMenuItem(
                                height: 40,
                                child: const Row(
                                  children: [
                                    Icon(Icons.list_alt,
                                        color: Colors.blueGrey),
                                    SizedBox(width: 8),
                                    Text(
                                      "All",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  context
                                      .read<VariableStateHandlerCubit<String>>()
                                      .update("All");
                                  context.read<TaskInfoBloc>().add(
                                        TaskInfoFilter(
                                          searchValue: _searchController.text,
                                          filterValue: "All",
                                        ),
                                      );
                                },
                              ),
                              ...List.generate(
                                groupedList.values.length,
                                (index) {
                                  final name = groupedList.values
                                          .elementAt(index)
                                          .first
                                          .parentTaskName ??
                                      "";
                                  return PopupMenuItem(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        const Icon(
                                            Icons.label_important_outline,
                                            color: Colors.deepPurple),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      context
                                          .read<
                                              VariableStateHandlerCubit<
                                                  String>>()
                                          .update(name);
                                      context.read<TaskInfoBloc>().add(
                                            TaskInfoFilter(
                                                searchValue:
                                                    _searchController.text,
                                                filterValue: name),
                                          );
                                    },
                                  );
                                },
                              ),
                            ];
                          },
                        );
                      }
                      return PopupMenuButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.filter_alt_outlined),
                        itemBuilder: (context) {
                          return [];
                        },
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
                          var data = state.taskInfoFilterList[index];
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
                        itemCount: state.taskInfoFilterList.length,
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
