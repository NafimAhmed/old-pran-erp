import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_7_screen/bloc/Jo_list_bloc.dart';

import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/bloc/task_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/widgets/task_create_widget.dart';

class OmC9Screen extends StatelessWidget {
  const OmC9Screen({super.key, required this.fromName});
  static const String routeName = "OM-C-9-SCREEN";
  static const String routePath = "/OM-C-9-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => JoListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => TaskListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<JoInfo>(),
        ),
      ],
      child: OmC9ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

enum TaskType {
  independent("In"),
  dependent("De");

  final String value;

  const TaskType(this.value);
  @override
  String toString() {
    return name;
  }
}

class OmC9ScreenBody extends StatefulWidget {
  const OmC9ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OmC9ScreenBody> createState() => _OmC9ScreenBodyState();
}

class _OmC9ScreenBodyState extends State<OmC9ScreenBody> {
  TextEditingController orgDropDownTextController = TextEditingController();
  late UserInfoModel loggedUser;

  final Map<int, VariableStateHandlerCubit<TaskType>> taskTypeCubits = {};
  final Map<int, VariableStateHandlerCubit<Task>> taskCubits = {};
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<JoListBloc>().add(
          GetJoList(
            userId: loggedUser.userId,
          ),
        );

    super.initState();
  }

  @override
  void dispose() {
    orgDropDownTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<JoListBloc, JoListState>(
              builder: (context, state) {
                return CommonDropDownMenuWidget<JoInfo>(
                  hintText: "Job Order No",
                  enabled: state is JoListSuccess ? true : false,
                  controller: orgDropDownTextController,
                  dropdownMenuEntries:
                      state is JoListSuccess ? state.joInfoList : [],
                  onSelected: (value) {
                    if (value != null) {
                      // FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                      context
                          .read<VariableStateHandlerCubit<JoInfo>>()
                          .update(value);
                      context.read<TaskListBloc>().add(
                            GetTaskList(
                              userId: loggedUser.userId,
                            ),
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
              child: BlocBuilder<TaskListBloc, TaskListState>(
                builder: (context, state) {
                  if (state is TaskListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is TaskListSuccess) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        var data = state.taskList[index];
                        return TaskCreateWidget(
                          data: data,
                          joInfo: context
                              .read<VariableStateHandlerCubit<JoInfo>>()
                              .state!,
                          loggedUser: loggedUser,
                          taskList: state.taskList,
                          index: index,
                          taskTypeCubit: taskTypeCubits.putIfAbsent(
                            data.taskNo ?? 0,
                            () => VariableStateHandlerCubit<TaskType>()
                              ..update(TaskType.independent),
                          ),
                          taskCubit: taskCubits.putIfAbsent(
                              data.taskNo ?? 0,
                              () => VariableStateHandlerCubit<Task>()
                                ..update(Task())),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemCount: state.taskList.length,
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
