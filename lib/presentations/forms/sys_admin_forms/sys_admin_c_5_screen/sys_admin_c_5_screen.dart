import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/qr_user_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_5_screen/bloc/org_access_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_5_screen/bloc/org_bloc.dart';

class SysAdminC5Screen extends StatelessWidget {
  const SysAdminC5Screen({super.key, required this.fromName});
  static const String routeName = "SYSTEM-ADMINISTRATOR-C-5-SCREEN";
  static const String routePath = "/SYSTEM-ADMINISTRATOR-C-5-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => QrUserBloc(getService()),
        ),
        BlocProvider(
          create: (context) => OrgBloc(getService()),
        ),
        BlocProvider(
          create: (context) => OrgAccessBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<QrUserData>(),
        ),
        BlocProvider(
          create: (context) =>
              VariableStateHandlerCubit<List<int>>()..update([]),
        ),
      ],
      child: SysAdminC5ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class SysAdminC5ScreenBody extends StatefulWidget {
  const SysAdminC5ScreenBody({super.key, required this.fromName}); //Org Access
  final String fromName;
  @override
  State<SysAdminC5ScreenBody> createState() => _SysAdminC5ScreenBodyState();
}

class _SysAdminC5ScreenBodyState extends State<SysAdminC5ScreenBody> {
  late UserInfoModel loggedUser;

  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  TextEditingController userDropDownTextController = TextEditingController();
  TextEditingController orgDropDownTextController = TextEditingController();
  @override
  void initState() {
    context.read<QrUserBloc>().add(GetQrUsers());
    context.read<OrgBloc>().add(OrgGet());
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    super.initState();
  }

  @override
  void dispose() {
    userDropDownTextController.dispose();
    orgDropDownTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName), //Org Access
      body: BlocListener<OrgAccessBloc, OrgAccessState>(
        listener: (context, state) {
          if (state is OrgAccessSuccess) {
            context.read<VariableStateHandlerCubit<QrUserData>>().reset();
            context.read<VariableStateHandlerCubit<List<int>>>().update([]);
            userDropDownTextController.clear();
            orgDropDownTextController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: "Access Given Successfully",
              ),
            );
          }
          if (state is OrgAccessError) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: state.error.toString(),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Form(
            key: fromKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    BlocBuilder<QrUserBloc, QrUserState>(
                      builder: (context, state) {
                        return Expanded(
                          child: CommonDropDownMenuWidget<QrUserData>(
                            hintText: "Select User",
                            enabled: state is QrUserSuccess
                                ? state.qrUsers.isNotEmpty
                                : false,
                            dropdownMenuEntries:
                                state is QrUserSuccess ? state.qrUsers : [],
                            controller: userDropDownTextController,
                            onSelected: (value) {
                              if (value != null) {
                                context
                                    .read<
                                        VariableStateHandlerCubit<QrUserData>>()
                                    .update(value);
                              }
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CommonDropDownMenuWidget(
                        hintText: "Select OU",
                        enabled: false,
                        // enabled: state is QrUserSuccess
                        //     ? state.qrUsers.isNotEmpty
                        //     : false,
                        dropdownMenuEntries: const [],
                        controller: userDropDownTextController,
                        onSelected: (value) {
                          if (value != null) {
                            // context
                            //     .read<VariableStateHandlerCubit<QrUserData>>()
                            //     .update(value);
                          }
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: BlocBuilder<OrgBloc, OrgState>(
                    builder: (context, state) {
                      if (state is OrgLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is OrgSuccess) {
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            var data = state.userOrgList[index];
                            return CheckboxListTile(
                              title: Text(
                                data.organizationName ?? "",
                                style: textTheme.bodyMedium!.copyWith(),
                              ),
                              subtitle: Text(
                                data.organizationCode ?? "",
                              ),
                              value: context
                                      .watch<
                                          VariableStateHandlerCubit<
                                              List<int>>>()
                                      .state
                                      ?.contains(index) ??
                                  false,
                              onChanged: (value) {
                                if (value != null) {
                                  var selectedList = List<int>.from(context
                                          .read<
                                              VariableStateHandlerCubit<
                                                  List<int>>>()
                                          .state ??
                                      []);
                                  if (value) {
                                    selectedList.add(index);
                                  } else {
                                    selectedList.remove(index);
                                  }
                                  context
                                      .read<
                                          VariableStateHandlerCubit<
                                              List<int>>>()
                                      .update(selectedList);
                                }
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: 10,
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<OrgAccessBloc, OrgAccessState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (fromKey.currentState!.validate()) {
                          var newUserId = context
                              .read<VariableStateHandlerCubit<QrUserData>>()
                              .state;
                          var orgId = context
                              .read<VariableStateHandlerCubit<List<int>>>()
                              .state;

                          if (newUserId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar.errorSnackber(
                                message: "Please Select User",
                              ),
                            );
                            return;
                          }
                          if (orgId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar.errorSnackber(
                                message: "Please Select Org",
                              ),
                            );
                            return;
                          }
                          // context.read<OrgAccessBloc>().add(
                          //       GiveOrgAccess(
                          //         newUserId: newUserId.userId ?? "",
                          //         userId: loggedUser.userId,
                          //         orgId: orgId.organizationId.toString(),
                          //       ),
                          //     );
                        }
                      },
                      child: Text(
                        state is OrgAccessLoading
                            ? "Processing..."
                            : "Give Access",
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
      bottomNavigationBar: const UserDetailsWidget(),
    );
  }
}
// BlocBuilder<OrgBloc, OrgState>(
//                   builder: (context, state) {
//                     return CommonDropDownMenuWidget<UserOrg>(
//                       hintText: "Select Org",
//                       dropdownMenuEntries:
//                           state is OrgSuccess ? state.userOrgList : [],
//                       enabled: state is OrgSuccess
//                           ? state.userOrgList.isNotEmpty
//                           : false,
//                       controller: orgDropDownTextController,
//                       onSelected: (value) {
//                         if (value != null) {
//                           context
//                               .read<VariableStateHandlerCubit<List<int>>()
//                               .update(value);
//                         }
//                       },
//                     );
//                   },
//                 ),