import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_19_screen/bloc/enable_re_print_qr_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_19_screen/bloc/re_print_qr_bloc.dart';

class OpmC19Screen extends StatelessWidget {
  const OpmC19Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-19-SCREEN";
  static const String routePath = "/OPM-C-19-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RePrintQrBloc(getService()),
        ),
        BlocProvider(
          create: (context) => EnableRePrintQrBloc(getService()),
        ),
      ],
      child: OpmC19ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class OpmC19ScreenBody extends StatefulWidget {
  const OpmC19ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC19ScreenBody> createState() => _OpmC19ScreenBodyState();
}

class _OpmC19ScreenBodyState extends State<OpmC19ScreenBody> {
  final TextEditingController lotNoController = TextEditingController();
  final FocusNode lotNoFocusNode = FocusNode();
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  @override
  void dispose() {
    lotNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName), //Qr Reprint
      body: MultiBlocListener(
        listeners: [
          BlocListener<RePrintQrBloc, RePrintQrState>(
            listener: (context, state) {
              if (state is RePrintQrSuccess) {
                lotNoController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: const Text(
                        "Successfully Found",
                      ),
                      backgroundColor: appTheme.primary),
                );
              }
            },
          ),
          BlocListener<EnableRePrintQrBloc, EnableRePrintQrState>(
            listener: (context, state) {
              if (state is EnableRePrintQrSuccess) {
                context.read<RePrintQrBloc>().add(Reset());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "Successfully Enabled",
                    ),
                    backgroundColor: appTheme.primary,
                  ),
                );
              }
            },
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Form(
                key: fromKey,
                child: Row(
                  children: [
                    Expanded(
                      child: CommonTextFieldWidget(
                        controller: lotNoController,
                        focusNode: lotNoFocusNode,
                        labelText: "Lot No",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Lot No";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    BlocBuilder<RePrintQrBloc, RePrintQrState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (fromKey.currentState!.validate()) {
                              context.read<RePrintQrBloc>().add(
                                    GetRePrintQrData(
                                      lotNo: lotNoController.text,
                                    ),
                                  );
                            }
                          },
                          child: Text(
                            state is RePrintQrLoading ? "Finding.." : "Find",
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
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: BlocBuilder<RePrintQrBloc, RePrintQrState>(
                  builder: (context, state) {
                    if (state is RePrintQrSuccess) {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          var data = state.rQrDataList[index].toUiMap();
                          return BlocBuilder<EnableRePrintQrBloc,
                              EnableRePrintQrState>(
                            builder: (context, state) {
                              return CommonListWidget(
                                data: data,
                                btnName: state is EnableRePrintQrLoading
                                    ? "Enabling.."
                                    : "Enable",
                                btnPress: () {
                                  context.read<EnableRePrintQrBloc>().add(
                                        EnableRePrintQrData(
                                          lotNo: data.entries
                                              .elementAt(1)
                                              .value
                                              .toString(),
                                        ),
                                      );
                                },
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: state.rQrDataList.length,
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

class CommonListWidget extends StatelessWidget {
  const CommonListWidget({
    super.key,
    required this.data,
    required this.btnName,
    this.btnPress,
  });
  final Map<String, dynamic> data;
  final String btnName;
  final Function()? btnPress;
  @override
  Widget build(BuildContext context) {
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
        children: [
          ...List.generate(
            data.length,
            (index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.entries.elementAt(index).key,
                        style: textTheme.bodyMedium!,
                      ),
                      Flexible(
                        child: Text(
                          data.entries.elementAt(index).value.toString(),
                          style: textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: btnPress,
              child: Text(
                btnName,
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
