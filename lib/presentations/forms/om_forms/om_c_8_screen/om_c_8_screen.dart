import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    context.read<JoComplListBloc>().add(
          GetJoComplList(
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<ComplJoBloc, ComplJoState>(
            listener: (context, state) {
              if (state is ComplJoSuccess) {}
            },
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              CommonTextFieldWidget(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hintText: "Search Job Order No",
                onChanged: (value) {
                  context.read<JoComplListBloc>().add(
                        JoComplListFilter(
                          searchValue: _searchController.text,
                        ),
                      );
                },
              ),
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemBuilder: (context, index) {
                          var data = state.jobOrderCompletionList[index];
                          return ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(10),
                            child: Dismissible(
                              key: Key(data.jobOrderNo ?? ""),
                              dismissThresholds: const {
                                DismissDirection.startToEnd: 0.8
                              },
                              confirmDismiss: (direction) async {
                                var result = await showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Are You Sure"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text("Cancel"),
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text("OK"),
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ) ??
                                    false;
                                if (result && context.mounted) {
                                  context.read<ComplJoBloc>().add(
                                        CompleteJo(
                                            userId: loggedUser.userId,
                                            jobOrderNo: data.jobOrderNo ?? ""),
                                      );
                                  final completer = Completer<bool>();
                                  final subscription = context
                                      .read<ComplJoBloc>()
                                      .stream
                                      .listen((state) {
                                    if (state is ComplJoSuccess) {
                                      completer.complete(
                                          true); // Complete with true on success
                                    } else if (state is ComplJoError) {
                                      completer.complete(
                                          false); // Complete with false on failure
                                    }
                                  });

                                  // Wait for the result and clean up the subscription
                                  final isSuccess = await completer.future;
                                  subscription.cancel();
                                  return isSuccess;
                                }
                                return result;
                              },
                              onDismissed: (direction) {
                                context
                                    .read<JoComplListBloc>()
                                    .add(RemoveJo(index: index));
                                context.read<JoComplListBloc>().add(
                                      GetJoComplList(
                                        userId: loggedUser.userId,
                                        searchValue: _searchController.text,
                                      ),
                                    );
                              },
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade800,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
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
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: appTheme.white,
                                    border: Border.all(
                                      width: 5,
                                      color: const Color.fromARGB(
                                          255, 200, 238, 169),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.jobOrderNo ?? "",
                                        style: textTheme.bodyMedium!.copyWith(
                                          color: appTheme.primary,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Delivery Date",
                                            style:
                                                textTheme.bodyMedium!.copyWith(
                                              color: appTheme.primary,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              DateTime.parse(
                                                      data.deliveryDate ?? '')
                                                  .toFormatedString(
                                                      "dd-MMM-yyyy"),
                                              style: textTheme.bodyMedium!
                                                  .copyWith(
                                                color: appTheme.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Status",
                                            style:
                                                textTheme.bodyMedium!.copyWith(
                                              color: appTheme.primary,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              data.jobStatus ?? "",
                                              style: textTheme.bodyMedium!
                                                  .copyWith(
                                                color: appTheme.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 6,
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
