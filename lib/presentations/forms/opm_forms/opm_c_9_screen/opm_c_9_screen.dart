import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/bloc/batch_comp_data_bloc.dart';

class OpmC9Screen extends StatelessWidget {
  const OpmC9Screen({super.key});
  static const String routeName = "OPM-C-9-SCREEN";
  static const String routePath = "/opm_c_9_screen";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BatchCompDataBloc(getService()),
      child: const OpmC9ScreenBody(),
    );
  }
}

class OpmC9ScreenBody extends StatefulWidget {
  const OpmC9ScreenBody({super.key});

  @override
  State<OpmC9ScreenBody> createState() => _OpmC9ScreenBodyState();
}

class _OpmC9ScreenBodyState extends State<OpmC9ScreenBody> {
  late UserInfoModel loggedUser;

  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<BatchCompDataBloc>().add(
          GetBatchCompData(
            userId: loggedUser.userId,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Batch Completion"),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: BlocBuilder<BatchCompDataBloc, BatchCompDataState>(
                builder: (context, state) {
                  if (state is BatchCompDataLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is BatchCompDataSuccess) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        var data = state.batchCompDataList[index];
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
                                    "Close",
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
                      itemCount: state.batchCompDataList.length,
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
