import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_2_screen/bloc/rcv_iot_data_bloc.dart';

class InvC2Screen extends StatelessWidget {
  const InvC2Screen({super.key});
  static const String routeName = "INV-C-2-SCREEN";
  static const String routePath = "/INV-C-2-SCREEN";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RcvIotDataBloc(getService()),
      child: const InvC2ScreenBody(),
    );
  }
}

class InvC2ScreenBody extends StatefulWidget {
  const InvC2ScreenBody({super.key});

  @override
  State<InvC2ScreenBody> createState() => _InvC2ScreenBodyState();
}

class _InvC2ScreenBodyState extends State<InvC2ScreenBody> {
  late UserInfoModel loggedUser;

  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<RcvIotDataBloc>().add(
          GetRcvIotData(
            userId: loggedUser.userId,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Receiving Transactions"),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: BlocBuilder<RcvIotDataBloc, RcvIotDataState>(
                builder: (context, state) {
                  if (state is RcvIotDataLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is RcvIotDataSuccess) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        var data = state.rcvIotDataList[index];
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
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Transfer",
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: appTheme.white,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                data.joborder ?? "",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.primary,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
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
                              Text(
                                data.racklocator ?? "",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.primary,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                data.trnqty.toString(),
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemCount: state.rcvIotDataList.length,
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
