import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/department_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/project_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/dept_list_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/qr_user_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_8_screen/bloc/main_task_create_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_8_screen/bloc/project_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_8_screen/data_class/main_task.dart';

class ProjectC8Screen extends StatelessWidget {
  const ProjectC8Screen({super.key, required this.fromName});
  static const String routeName = "PROJECT-C-8-SCREEN";
  static const String routePath = "/PROJECT-C-8-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DeptListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => QrUserBloc(getService()),
        ),
        BlocProvider(
          create: (context) => ProjectListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => MainTaskCreateBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<MainTask>(),
        ),
      ],
      child: ProjectC8ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class ProjectC8ScreenBody extends StatefulWidget {
  const ProjectC8ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<ProjectC8ScreenBody> createState() => _ProjectC8ScreenBodyState();
}

class _ProjectC8ScreenBodyState extends State<ProjectC8ScreenBody> {
  late TextEditingController _prntTaskController;
  late TextEditingController _projectDropDownTextController;
  late TextEditingController _stDateController;
  late TextEditingController _enDateController;
  late FocusNode _prntTaskfocusNode;
  late FocusNode _manFocusNode;
  late TextEditingController _manController;
  late FocusNode _hourFocusNode;
  late TextEditingController _hourController;
  late UserInfoModel loggedUser;

  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    _prntTaskController = TextEditingController();
    _stDateController = TextEditingController();
    _enDateController = TextEditingController();
    _prntTaskfocusNode = FocusNode();
    _manController = TextEditingController();
    _manFocusNode = FocusNode();
    _hourController = TextEditingController();
    _hourFocusNode = FocusNode();
    _projectDropDownTextController = TextEditingController();
    loggedUser = context.read<LoggedUserInfoCubit>().state!;

    context.read<DeptListBloc>().add(
          DeptListGet(
            userId: loggedUser.userId,
          ),
        );
    context.read<ProjectListBloc>().add(
          ProjectListGet(
            userId: loggedUser.userId,
          ),
        );
    context.read<QrUserBloc>().add(GetQrUsers());
    super.initState();
  }

  @override
  void dispose() {
    _prntTaskController.dispose();
    _prntTaskfocusNode.dispose();
    _stDateController.dispose();
    _enDateController.dispose();
    _projectDropDownTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainTask? mainTask = context.select(
      (VariableStateHandlerCubit<MainTask> cubit) => cubit.state,
    );

    return Scaffold(
      appBar: CommonAppBar(
        appBartitle: widget.fromName,
      ),
      body: BlocListener<MainTaskCreateBloc, MainTaskCreateState>(
        listener: (context, state) {
          if (state is MainTaskCreateSuccess) {
            _prntTaskController.clear();
            _stDateController.clear();
            _enDateController.clear();
            _manController.clear();
            _hourController.clear();

            context.read<VariableStateHandlerCubit<MainTask>>().reset();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _fromKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<ProjectListBloc, ProjectListState>(
                  builder: (context, state) {
                    return CommonDropDownMenuWidget<Project>(
                      hintText: "Select Project",
                      enabled: state is ProjectListSuccess ? true : false,
                      controller: _projectDropDownTextController,
                      dropdownMenuEntries:
                          state is ProjectListSuccess ? state.projectList : [],
                      onSelected: (value) {
                        if (value != null) {
                          // FocusScope.of(context).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                          var newMainTask = context
                                  .read<VariableStateHandlerCubit<MainTask>>()
                                  .state ??
                              MainTask();
                          newMainTask = newMainTask.copyWith(projectId: value);
                          context
                              .read<VariableStateHandlerCubit<MainTask>>()
                              .update(newMainTask);
                          // context.read<TaskListBloc>().add(
                          //       GetTaskList(
                          //         userId: loggedUser.userId,
                          //       ),
                          //     );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CommonTextFieldWidget(
                  controller: _prntTaskController,
                  focusNode: _prntTaskfocusNode,
                  labelText: "Task Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Task Name";
                    }
                    return null;
                  },
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
                            return "Enter Man";
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
                            return "Enter hour";
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
                            return "Enter St Date";
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
                            return "Enter En Date";
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
                  children: [
                    Expanded(
                      child: BlocBuilder<DeptListBloc, DeptListState>(
                        builder: (context, state) {
                          return CommonDropdownButton<Department>(
                            hintText: "Department",
                            value: mainTask?.taskDept,
                            items:
                                state is DeptListSuccess ? state.deptList : [],
                            onChanged: (value) {
                              if (value != null) {
                                var newMainTask = context
                                        .read<
                                            VariableStateHandlerCubit<
                                                MainTask>>()
                                        .state ??
                                    MainTask();
                                newMainTask =
                                    newMainTask.copyWith(taskDept: value);
                                context
                                    .read<VariableStateHandlerCubit<MainTask>>()
                                    .update(newMainTask);
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Select Dept";
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
                            items: state is QrUserSuccess ? state.qrUsers : [],
                            value: mainTask?.assignee,
                            onChanged: (value) {
                              if (value != null) {
                                var newMainTask = context
                                        .read<
                                            VariableStateHandlerCubit<
                                                MainTask>>()
                                        .state ??
                                    MainTask();
                                newMainTask =
                                    newMainTask.copyWith(assignee: value);
                                context
                                    .read<VariableStateHandlerCubit<MainTask>>()
                                    .update(newMainTask);
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Select Assignee";
                              }
                              return null;
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
                BlocBuilder<MainTaskCreateBloc, MainTaskCreateState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (_fromKey.currentState!.validate()) {
                          var newMainTask = context
                                  .read<VariableStateHandlerCubit<MainTask>>()
                                  .state ??
                              MainTask();
                          newMainTask = newMainTask.copyWith(
                            taskName: _prntTaskController.text,
                            taskDesc: _prntTaskController.text,
                            man: _manController.text,
                            hr: _hourController.text,
                            stDate: DateTime.parse(_stDateController.text)
                                .toFormatedString("dd-MMM-yyyy"),
                            enDate: DateTime.parse(_enDateController.text)
                                .toFormatedString("dd-MMM-yyyy"),
                          );
                          context
                              .read<VariableStateHandlerCubit<MainTask>>()
                              .update(newMainTask);
                          context.read<MainTaskCreateBloc>().add(
                                MainTaskCreate(
                                  userId: loggedUser.userId,
                                  mainTask: newMainTask,
                                ),
                              );
                        }
                      },
                      child: Text(
                        state is MainTaskCreateLoading ? "Adding..." : "Add",
                        style: textTheme.bodyMedium!.copyWith(
                          color: appTheme.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
