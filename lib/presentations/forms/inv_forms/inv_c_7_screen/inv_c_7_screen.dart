import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_7_screen/bloc/mo_req_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_7_screen/bloc/mo_req_save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_7_screen/widgets/mo_task_widget.dart';

class InvC7Screen extends StatelessWidget {
  const InvC7Screen({super.key, required this.fromName});
  static const String routeName = "INV-C-7-SCREEN";
  static const String routePath = "/INV-C-7-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MOReqListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => MOReqSaveBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<JoInfo>(),
        ),
      ],
      child: InvC7ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class InvC7ScreenBody extends StatefulWidget {
  const InvC7ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<InvC7ScreenBody> createState() => _InvC7ScreenBodyState();
}

enum TaskStatusType {
  pending("Pending"),
  completed("Completed");

  const TaskStatusType(this.value);

  final String value;
  @override
  String toString() {
    return value;
  }
}

class _InvC7ScreenBodyState extends State<InvC7ScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late UserInfoModel loggedUser;
  final Map<int, VariableStateHandlerCubit<TaskStatusType>>
      taskStatusTypeCubits = {};
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;

    context.read<MOReqListBloc>().add(
          MOReqListGet(
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
      body: BlocListener<MOReqSaveBloc, MOReqSaveState>(
        listener: (context, state) {
          if (state is MOReqSaveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: "Successfully Saved",
              ),
            );

            context.read<MOReqListBloc>().add(
                  MOReqListGet(
                    userId: loggedUser.userId,
                    searchValue: _searchController.text,
                  ),
                );
          }
          if (state is MOReqSaveError) {
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
                  context.read<MOReqListBloc>().add(
                        MOReqListFilter(
                          searchValue: value,
                        ),
                      );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: BlocBuilder<MOReqListBloc, MOReqListState>(
                  builder: (context, state) {
                    if (state is MOReqListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is MOReqListSuccess) {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          var data = state.moReqList[index];
                          return MOTaskWidget(
                            taskStatusTypeCubit:
                                taskStatusTypeCubits.putIfAbsent(
                              data.taskId ?? 0,
                              () => VariableStateHandlerCubit<TaskStatusType>(),
                            ),
                            index: index,
                            data: data,
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: state.moReqList.length,
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
