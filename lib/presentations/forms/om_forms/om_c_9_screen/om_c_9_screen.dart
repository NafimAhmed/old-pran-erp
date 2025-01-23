import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/buyer_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/department_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_dialog_header.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/buyer_list_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/dept_list_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/qr_user_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_7_screen/bloc/Jo_list_bloc.dart';

import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/bloc/task_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/model/child_task.dart';
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
          create: (context) => DeptListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => BuyerListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => QrUserBloc(getService()),
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
  final Map<int, VariableStateHandlerCubit<NewTask>> childTaskCubits = {};
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<JoListBloc>().add(
          GetJoList(
            userId: loggedUser.userId,
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
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<JoListBloc, JoListState>(
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
                ),
                const SizedBox(
                  width: 10,
                ),
                BlocBuilder<VariableStateHandlerCubit<JoInfo>, JoInfo?>(
                  builder: (context, state) {
                    if (state != null) {
                      return IconButton.filled(
                        onPressed: () {
                          AppModal.showCustomModal(
                            context,
                            content: ParentTaskDialog(
                              blocContext: context,
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.task_rounded,
                          color: appTheme.white,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
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
                              ..update(
                                Task(),
                              ),
                          ),
                          childTaskCubit: childTaskCubits.putIfAbsent(
                            data.taskNo ?? 0,
                            () => VariableStateHandlerCubit<NewTask>(),
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

class ParentTaskDialog extends StatelessWidget {
  const ParentTaskDialog({
    super.key,
    required this.blocContext,
  });
  final BuildContext blocContext;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<DeptListBloc>(blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<BuyerListBloc>(blocContext),
        ),
      ],
      child: ParentTaskContent(
        blocContext: blocContext,
      ),
    );
  }
}

class ParentTaskContent extends StatefulWidget {
  const ParentTaskContent({
    super.key,
    required this.blocContext,
  });
  final BuildContext blocContext;
  @override
  State<ParentTaskContent> createState() => _ParentTaskContentState();
}

class _ParentTaskContentState extends State<ParentTaskContent> {
  late TextEditingController _prntTaskController;
  late FocusNode _prntTaskfocusNode;
  Department? _selectedDept;
  Buyer? _selectedBuyert;
  @override
  void initState() {
    _prntTaskController = TextEditingController();
    _prntTaskfocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _prntTaskController.dispose();
    _prntTaskfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CommonDialogHeader(title: "Add New Task"),
          const SizedBox(
            height: 10,
          ),
          CommonTextFieldWidget(
            controller: _prntTaskController,
            focusNode: _prntTaskfocusNode,
            labelText: "Task Name",
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
                      value: _selectedDept,
                      items: state is DeptListSuccess ? state.deptList : [],
                      onChanged: (value) {
                        setState(() {
                          _selectedDept = value;
                        });
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
                      value: _selectedBuyert,
                      items: state is BuyerListSuccess ? state.buyerList : [],
                      onChanged: (value) {
                        setState(() {
                          _selectedBuyert = value;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
