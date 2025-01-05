import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';

import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_8_screen/bloc/compl_jo_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_8_screen/bloc/jo_compl_list_bloc.dart';

class OmC8Screen extends StatelessWidget {
  const OmC8Screen({super.key, required this.fromName});
  static const String routeName = "OM-C-8-SCREEN";
  static const String routePath = "/OM-C-8-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => JoComplListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => ComplJoBloc(getService()),
        ),
      ],
      child: OmC8ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class OmC8ScreenBody extends StatefulWidget {
  const OmC8ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OmC8ScreenBody> createState() => _OmC8ScreenBodyState();
}

class _OmC8ScreenBodyState extends State<OmC8ScreenBody> {
  TextEditingController taskTextEditingController = TextEditingController();
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context
        .read<JoComplListBloc>()
        .add(GetJoComplList(userId: loggedUser.userId));
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
      body: BlocListener<ComplJoBloc, ComplJoState>(
        listener: (context, state) {
          if (state is ComplJoSuccess) {
            context
                .read<JoComplListBloc>()
                .add(GetJoComplList(userId: loggedUser.userId));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: BlocBuilder<JoComplListBloc, JoComplListState>(
                  builder: (context, state) {
                    if (state is JoComplListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is JoComplListSuccess) {
                      return ListView.separated(
                        clipBehavior: Clip.antiAlias,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        itemBuilder: (context, index) {
                          var data = state.jobOrderCompletionList[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Dismissible(
                              key: Key(data.jobOrderNo ?? ""),
                              dismissThresholds: const {
                                DismissDirection.startToEnd: 0.8
                              },
                              onDismissed: (direction) {
                                context
                                    .read<JoComplListBloc>()
                                    .add(RemoveJo(index: index));
                                context.read<ComplJoBloc>().add(
                                      CompleteJo(
                                          userId: loggedUser.userId,
                                          jobOrderNo: data.jobOrderNo ?? ""),
                                    );
                              },
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade800,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.save,
                                      color: appTheme.white,
                                    )
                                  ],
                                ),
                              ),
                              direction: DismissDirection.startToEnd,
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
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade600,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: appTheme.primary,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.jobOrderNo ?? "",
                                        style: textTheme.bodyMedium!.copyWith(
                                          color: appTheme.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: state.jobOrderCompletionList.length,
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
