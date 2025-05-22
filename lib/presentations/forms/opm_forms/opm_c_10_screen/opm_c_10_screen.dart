import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_10_screen/bloc/batch_close_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_10_screen/bloc/batch_close_data_bloc.dart';

class OpmC10Screen extends StatelessWidget {
  const OpmC10Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-10-SCREEN";
  static const String routePath = "/OPM-C-10-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BatchCloseDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => BatchCloseBloc(getService()),
        ),
      ],
      child: OpmC10ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class OpmC10ScreenBody extends StatefulWidget {
  const OpmC10ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC10ScreenBody> createState() => _OpmC10ScreenBodyState();
}

class _OpmC10ScreenBodyState extends State<OpmC10ScreenBody> {
  late UserInfoModel loggedUser;

  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    context.read<BatchCloseDataBloc>().add(
          GetBatchCloseData(
            userId: loggedUser.userId,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: BlocListener<BatchCloseBloc, BatchCloseState>(
        listener: (context, state) {
          if (state is BatchCloseSuccess) {
            context.read<BatchCloseDataBloc>().add(
                  GetBatchCloseData(
                    userId: loggedUser.userId,
                  ),
                );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: BlocBuilder<BatchCloseDataBloc, BatchCloseDataState>(
                  builder: (context, state) {
                    if (state is BatchCloseDataLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is BatchCloseDataSuccess) {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          var data = state.batchCloseDataList[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              border: Border(
                                bottom: BorderSide(
                                  color: appTheme.primary,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocSelector<BatchCloseBloc, BatchCloseState,
                                    String>(
                                  selector: (state) {
                                    if (state is BatchCloseLoading) {
                                      if (state.batchId == data.batchId) {
                                        return "Closing...";
                                      } else {
                                        return "Close";
                                      }
                                    }
                                    return "Close";
                                  },
                                  builder: (context, state) {
                                    return Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                        ),
                                        onPressed: () {
                                          context.read<BatchCloseBloc>().add(
                                                CloseBatch(
                                                  userId: loggedUser.userId,
                                                  batchId: data.batchId ?? 0,
                                                ),
                                              );
                                        },
                                        child: Text(
                                          state,
                                          style: textTheme.bodyMedium!.copyWith(
                                            color: appTheme.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  data.itemName ?? "",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Org",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.primary,
                                      ),
                                    ),
                                    Text(
                                      data.orgCode ?? "",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Batch No",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.primary,
                                      ),
                                    ),
                                    Text(
                                      data.batchNo ?? "",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Batch Qty",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.primary,
                                      ),
                                    ),
                                    Text(
                                      data.madeQty.toString(),
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Made Qty",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.primary,
                                      ),
                                    ),
                                    Text(
                                      data.madeQty.toString(),
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Batch Status",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.primary,
                                      ),
                                    ),
                                    Text(
                                      data.batchStatus ?? "",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: state.batchCloseDataList.length,
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
