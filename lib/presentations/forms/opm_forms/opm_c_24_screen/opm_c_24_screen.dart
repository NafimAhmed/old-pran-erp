import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/item_qr_cubit.dart';

class OpmC24Screen extends StatelessWidget {
  const OpmC24Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-24-SCREEN";
  static const String routePath = "/OPM-C-24-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ItemQrCubit(),
        ),
      ],
      child: OpmC24ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

enum QualityType {
  good("Good"),
  bad("Bad"),
  defected("Defected");

  const QualityType(this.value);

  final String value;
  @override
  String toString() {
    return value;
  }
}

class OpmC24ScreenBody extends StatefulWidget {
  const OpmC24ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC24ScreenBody> createState() => _OpmC24ScreenBodyState();
}

class _OpmC24ScreenBodyState extends State<OpmC24ScreenBody> {
  late UserInfoModel loggedUser;
  MobileScannerController? controller = MobileScannerController();

  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              height: 10,
            ),
            ReadQrWidget(
              qrType: "Item QR",
              onPressed: () async {
                var data = await buildScanner(context, controller);
                if (context.mounted) {
                  context.read<ItemQrCubit>().setItemData(itemQrData: data);
                }
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return QcItemWidget(
                    index: index,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QcItemWidget extends StatelessWidget {
  const QcItemWidget({
    super.key,
    required this.index,
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VariableStateHandlerCubit<QualityType>(),
      child: QcItemWidgetContent(index: index),
    );
  }
}

class QcItemWidgetContent extends StatefulWidget {
  const QcItemWidgetContent({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<QcItemWidgetContent> createState() => _QcItemWidgetContentState();
}

class _QcItemWidgetContentState extends State<QcItemWidgetContent> {
  late TextEditingController addCommentController;
  late FocusNode addCommentFocusNode;
  @override
  void initState() {
    addCommentController = TextEditingController();
    addCommentFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Dismissible(
        key: Key(widget.index.toString()),
        direction:
            context.watch<VariableStateHandlerCubit<QualityType>>().state !=
                    null
                ? DismissDirection.startToEnd
                : DismissDirection.none,
        dismissThresholds: const {DismissDirection.startToEnd: 0.8},
        confirmDismiss: (direction) async {
          return await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Are You Sure"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(
                              context, false); // Return false if cancelled
                        },
                      ),
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.pop(
                              context, true); // Return true if confirmed
                        },
                      ),
                    ],
                  );
                },
              ) ??
              false; // Default to false if dialog is dismissed without selection
        },
        onDismissed: (direction) {
          // context.read<TaskInfoBloc>().add(RemoveTaskInfo(index: index));

          // var status =
          //     context.read<VariableStateHandlerCubit<TaskStatusType>>().state!;
          // var loggedUser = context.read<LoggedUserInfoCubit>().state!;
          // context.read<TaskSaveBloc>().add(
          //       TaskSave(
          //         userId: loggedUser.userId,
          //         taskStatus: status.value,
          //         taskId: data.tasksid ?? 0,
          //       ),
          //     );
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
            color: appTheme.white,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: appTheme.primary.withOpacity(0.95),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Item Name ${widget.index}",
                    style: textTheme.bodyMedium!.copyWith(
                      color: appTheme.white,
                    ),
                  ),
                  Text(
                    "Item ${widget.index} Details ${widget.index + 1} ",
                    style: textTheme.bodyMedium!.copyWith(
                      color: appTheme.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CommonDropdownButton<QualityType>(
                    value: context
                        .watch<VariableStateHandlerCubit<QualityType>>()
                        .state,
                    // fillColor: appTheme.primary,
                    // hintcolor: Colors.white,
                    onChanged: (value) {
                      if (value != null) {
                        context
                            .read<VariableStateHandlerCubit<QualityType>>()
                            .update(value);
                      }
                    },
                    hintText: "Change Quality",
                    items: QualityType.values,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CommonTextFieldWidget(
                    controller: addCommentController,
                    focusNode: addCommentFocusNode,
                    labelText: "Add Comment",
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
