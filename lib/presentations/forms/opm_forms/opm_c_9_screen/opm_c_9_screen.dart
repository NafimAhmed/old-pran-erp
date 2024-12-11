import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_dtl_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/bloc/batch_comp_data_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/bloc/batch_comp_dtl_data_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/bloc/batch_comp_dtl_data_ln_up_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_9_screen/bloc/comp_batch_bloc.dart';

class OpmC9Screen extends StatelessWidget {
  const OpmC9Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-9-SCREEN";
  static const String routePath = "/opm_c_9_screen";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BatchCompDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => BatchCompDtlDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => BatchCompDtlLnUpdtBloc(getService()),
        ),
        BlocProvider(
          create: (context) => CompBatchBloc(getService()),
        ),
      ],
      child: OpmC9ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class OpmC9ScreenBody extends StatefulWidget {
  const OpmC9ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC9ScreenBody> createState() => _OpmC9ScreenBodyState();
}

class _OpmC9ScreenBodyState extends State<OpmC9ScreenBody>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late UserInfoModel loggedUser;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 2, length: 3, vsync: this);
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 30,
              child: TabBar(
                onTap: (value) {
                  if ([0, 1].contains(value)) {
                    _tabController.index = 2;
                  }
                },
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: appTheme.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: appTheme.primary,
                  ),
                ),
                tabs: const [
                  Tab(
                    text: "Release",
                  ),
                  Tab(
                    text: "Receive",
                  ),
                  Tab(
                    text: "Complete",
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    color: appTheme.green,
                  ),
                  Container(
                    color: appTheme.primary,
                  ),
                  const CompleteTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CompleteTab extends StatefulWidget {
  const CompleteTab({super.key});

  @override
  State<CompleteTab> createState() => _CompleteTabState();
}

class _CompleteTabState extends State<CompleteTab> {
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
    return BlocListener<BatchCompDtlDataBloc, BatchCompDtlDataState>(
      listener: (context, state) {
        if (state is BatchCompDtlDataSuccess) {
          AppModal.showCustomModal(
            context,
            content: BatchCompSkuDtlWidget(
              blocContext: context,
              tabData: state.skuDtlDataList,
            ),
          );
        }
      },
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
                            BlocBuilder<BatchCompDtlDataBloc,
                                BatchCompDtlDataState>(
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
                                      context.read<BatchCompDtlDataBloc>().add(
                                            GetBatchCompDtlData(
                                              userId: loggedUser.userId,
                                              batchId: data.batchId.toString(),
                                              listIndex: index,
                                            ),
                                          );
                                    },
                                    child: Text(
                                      state is BatchCompDtlDataLoading
                                          ? state.listIndex == index
                                              ? "Getting Data.."
                                              : "Complete"
                                          : "Complete",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Org",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                                Text(
                                  data.organizationCode ?? "",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Batch Qty",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                                Text(
                                  data.batchQty.toString(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}

class BatchCompSkuDtlWidget extends StatefulWidget {
  const BatchCompSkuDtlWidget(
      {super.key, required this.blocContext, required this.tabData});
  final BuildContext blocContext;
  final List<SkuDtlData> tabData;
  @override
  State<BatchCompSkuDtlWidget> createState() => _BatchCompSkuDtlWidgetState();
}

class _BatchCompSkuDtlWidgetState extends State<BatchCompSkuDtlWidget> {
  late List<SkuDtlData> tabData;
  late List<int> stopEditList;
  @override
  void initState() {
    tabData = widget.tabData;
    stopEditList = List.filled(tabData.length, -1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<BatchCompDtlLnUpdtBloc>(widget.blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<CompBatchBloc>(widget.blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<BatchCompDataBloc>(widget.blocContext),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<bool>()..update(false),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<int>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<String>(),
        ),
      ],
      child: BlocListener<BatchCompDtlLnUpdtBloc, BatchCompDtlLnUpdtState>(
        listener: (context, state) {
          if (state is BatchCompDtlLnUpdtSuccess) {
            context.read<VariableStateHandlerCubit<bool>>().update(false);
            context.read<VariableStateHandlerCubit<int>>().reset();
            context.read<VariableStateHandlerCubit<String>>().reset();
            tabData[state.selectedIndex] =
                tabData[state.selectedIndex].copyWith(madeQty: state.madeQty);
            stopEditList[state.selectedIndex] = state.selectedIndex;
          }
        },
        child: Container(
          padding: const EdgeInsets.all(
            10,
          ),
          height: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: appTheme.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: appTheme.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    var data = tabData[index];
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  data.itemName ?? "",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                              ),
                              data.editEnable != 1 &&
                                      !stopEditList.contains(index)
                                  ? Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: appTheme.primary,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          var isEdit = context
                                              .read<
                                                  VariableStateHandlerCubit<
                                                      bool>>()
                                              .state!;
                                          context
                                              .read<
                                                  VariableStateHandlerCubit<
                                                      bool>>()
                                              .update(!isEdit);
                                          context
                                              .read<
                                                  VariableStateHandlerCubit<
                                                      int>>()
                                              .update(index);
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: appTheme.white,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(
                                width: 5,
                              ),
                              data.editEnable != 1 &&
                                      !stopEditList.contains(index)
                                  ? Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: appTheme.primary,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          var loggedUser = context
                                              .read<LoggedUserInfoCubit>()
                                              .state!;
                                          var eMadeQty = context
                                              .read<
                                                  VariableStateHandlerCubit<
                                                      String>>()
                                              .state!;
                                          widget.blocContext
                                              .read<BatchCompDtlLnUpdtBloc>()
                                              .add(
                                                GetBatchCompDtlLnUpdt(
                                                  userId: loggedUser.userId,
                                                  mtldtlid: data
                                                      .materialDetailId
                                                      .toString(),
                                                  madeqty: eMadeQty,
                                                  selectedIndex: index,
                                                ),
                                              );
                                        },
                                        child: Icon(
                                          Icons.save_alt_rounded,
                                          color: appTheme.white,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
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
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: Row(
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
                                      data.batchQty.toString(),
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Made Qty",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.primary,
                                ),
                              ),
                              if (context
                                          .watch<
                                              VariableStateHandlerCubit<bool>>()
                                          .state ==
                                      true &&
                                  context
                                          .read<
                                              VariableStateHandlerCubit<int>>()
                                          .state ==
                                      index)
                                Flexible(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: CommonTextFieldWidget(
                                      style: textTheme.bodySmall!,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        context
                                            .read<
                                                VariableStateHandlerCubit<
                                                    String>>()
                                            .update(value);
                                      },
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  data.madeQty.toString(),
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.primary,
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Cost Alloc",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.primary,
                                ),
                              ),
                              Text(
                                data.costAlloc.toString(),
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
                  itemCount: tabData.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
