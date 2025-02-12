import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/department_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/buyer_list_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/dept_list_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/qr_user_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_9_screen/bloc/task_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_9_screen/widgets/task_create_widget.dart';

class ProjectC9Screen extends StatelessWidget {
  const ProjectC9Screen({super.key, required this.fromName});
  static const String routeName = "PROJECT-C-9-SCREEN";
  static const String routePath = "/PROJECT-C-9-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => DeptListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => BuyerListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => QrUserBloc(getService()),
        ),
      ],
      child: ProjectC9ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class ProjectC9ScreenBody extends StatefulWidget {
  const ProjectC9ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<ProjectC9ScreenBody> createState() => _ProjectC9ScreenBodyState();
}

class _ProjectC9ScreenBodyState extends State<ProjectC9ScreenBody> {
  late UserInfoModel loggedUser;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final Map<int, VariableStateHandlerCubit<Task>> taskCubits = {};
  final Map<int, VariableStateHandlerCubit<QrUserData>> assigneeCubits = {};
  final Map<int, VariableStateHandlerCubit<Department>> departmentCubits = {};
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<TaskListBloc>().add(
          TaskListGet(
            userId: loggedUser.userId,
            searchValue: _searchController.text,
          ),
        );
    context.read<DeptListBloc>().add(
          DeptListGet(
            userId: loggedUser.userId,
          ),
        );
    context.read<BuyerListBloc>().add(
          BuyerListGet(
            userId: loggedUser.userId,
          ),
        );
    context.read<QrUserBloc>().add(GetQrUsers());

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
      body: Container(
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
                context.read<TaskListBloc>().add(
                      TaskListFilter(
                        searchValue: _searchController.text,
                      ),
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
                          searchValue: _searchController.text,
                          loggedUser: loggedUser,
                          taskList: state.taskList,
                          index: index,
                          taskCubit: taskCubits.putIfAbsent(
                            data.taskNo ?? 0,
                            () => VariableStateHandlerCubit<Task>()
                              ..update(
                                Task(),
                              ),
                          ),
                          assigneeCubit: assigneeCubits.putIfAbsent(
                            data.taskNo ?? 0,
                            () => VariableStateHandlerCubit<QrUserData>(),
                          ),
                          departmentCubit: departmentCubits.putIfAbsent(
                            data.taskNo ?? 0,
                            () => VariableStateHandlerCubit<Department>(),
                          ),
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
