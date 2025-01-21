import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/bloc/loading_test_bloc.dart';

class PoC2Screen extends StatelessWidget {
  const PoC2Screen({super.key, required this.fromName});
  static const String routeName = "PO-C-2-SCREEN";
  static const String routePath = "/PO-C-2-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadingTestBloc(),
      child: POC2ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class POC2ScreenBody extends StatefulWidget {
  const POC2ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<POC2ScreenBody> createState() => _POC2ScreenBodyState();
}

class _POC2ScreenBodyState extends State<POC2ScreenBody> {
  TextEditingController orgDropDownTextController = TextEditingController();
  @override
  void initState() {
    context.read<LoadingTestBloc>().add(LoadingTest());
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
          horizontal: 10,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: CommonDropDownMenuWidget(
                    hintText: "Select Org",
                    enabled: false,
                    controller: orgDropDownTextController,
                    dropdownMenuEntries: const [],
                    onSelected: (value) {
                      if (value != null) {
                        // FocusScope.of(context).unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CommonDropDownMenuWidget(
                    hintText: "Select JO/PO",
                    enabled: false,
                    controller: orgDropDownTextController,
                    dropdownMenuEntries: const [],
                    onSelected: (value) {
                      if (value != null) {
                        // FocusScope.of(context).unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
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
                  return GestureDetector(
                    onTap: () {
                      // AppModal.showCustomModal(
                      //   context,
                      //   content: Container(
                      //     padding: const EdgeInsets.all(10),
                      //     child: const Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         CommonDialogHeader(title: "PO Item Details"),
                      //         SizedBox(
                      //           height: 50,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // );
                      context.read<LoadingTestBloc>().add(LoadingTest());
                      AppModal.showCustomModal(
                        context,
                        content: BlocProvider.value(
                          value: BlocProvider.of<LoadingTestBloc>(context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: BlocConsumer<LoadingTestBloc,
                                        LoadingTestState>(
                                      listener: (context, state) {
                                        if (state.isSuccess == true) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        }
                                      },
                                      builder: (context, state) {
                                        return Text(
                                          state.loadingMessage,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? const Color.fromARGB(255, 115, 134, 240)
                            : const Color.fromARGB(255, 136, 152, 247),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Item Name"),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Oty"),
                                    Text("100"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Rate"),
                                    Text("10000"),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
