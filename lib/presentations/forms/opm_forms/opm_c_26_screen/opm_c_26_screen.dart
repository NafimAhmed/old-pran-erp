import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_dropdown_search.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_26_screen/bloc/customer_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_26_screen/bloc/smpl_save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_26_screen/model/sample_item.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_26_screen/bloc/sample_item_bloc.dart';
import 'package:pran_rfl_erp/presentations/smpl_qr_list_screen/smpl_qr_list_screen.dart';

class OpmC26Screen extends StatelessWidget {
  const OpmC26Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-26-SCREEN";
  static const String routePath = "/OPM-C-26-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserOrgBloc(getService()),
        ),
        BlocProvider(
          create: (context) => CustomerListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => SmplSaveBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserOrg>(),
        ),
        BlocProvider(
          create: (context) => SampleItemBloc(),
        ),
      ],
      child: OpmC26ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class OpmC26ScreenBody extends StatefulWidget {
  const OpmC26ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC26ScreenBody> createState() => _OpmC26ScreenBodyState();
}

class _OpmC26ScreenBodyState extends State<OpmC26ScreenBody> {
  late UserInfoModel loggedUser;
  late TextEditingController _custNameController;
  late TextEditingController _custCodeController;
  late TextEditingController _smplSenderController;
  late TextEditingController _rcvDateController;

  late TextEditingController _noteController;
  late TextEditingController _assigneeController;
  late TextEditingController _itemNameController;
  late TextEditingController _itemCodeController;

  late TextEditingController _qtyController;
  late TextEditingController _unitController;

  late FocusNode _custNameFocusNode;
  late FocusNode _smplSenderFocusNode;

  late FocusNode _noteFocusNode;
  late FocusNode _assigneeFocusNode;
  late FocusNode _itemNameFocusNode;
  late FocusNode _itemCodeFocusNode;

  late FocusNode _qtyFocusNode;
  late FocusNode _unitFocusNode;
  late GlobalKey<FormState> _fromkey;
  List<UserOrg> orgList = List.empty();
  List<SampleItem> _sampleItem = List.empty();
  late OverlayEntry _overlayEntry;
  bool _isOverlayVisible = false;

  void _showOverlay(BuildContext blocContext) {
    final fieldBox =
        _custNameFocusNode.context!.findRenderObject() as RenderBox;
    final fieldOffset = fieldBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: fieldOffset.dx,
        top: fieldOffset.dy + fieldBox.size.height + 5,
        width: fieldBox.size.width,
        child: BlocProvider.value(
          value: BlocProvider.of<CustomerListBloc>(blocContext),
          child: Material(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(8, 105, 236, 0.25),
                    Color.fromRGBO(0, 74, 173, 0.25),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 300,
              child: BlocBuilder<CustomerListBloc, CustomerListState>(
                builder: (context, state) {
                  if (state is CustomerListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is CustomerListSuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _hideOverlay();
                          },
                          child: Container(
                            width: 20,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: appTheme.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(
                              Icons.close,
                              color: appTheme.white,
                              size: 15,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: state.customerList.length,
                            itemBuilder: (context, index) {
                              final data = state.customerList[index];
                              return GestureDetector(
                                onTap: () {
                                  _custNameController.text =
                                      data.customerName ?? "";
                                  _custCodeController.text =
                                      data.customerNumber ?? "";
                                  _hideOverlay();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${data.customerNumber}-${data.customerName}",
                                    style: textTheme.bodySmall!.copyWith(
                                      color: appTheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry);
    _isOverlayVisible = true;
  }

  void _hideOverlay() {
    if (_isOverlayVisible) {
      _overlayEntry.remove();
      _isOverlayVisible = false;
    }
  }

  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<UserOrgBloc>().add(UserOrgGet(userId: "", orgType: "rcving"));
    _fromkey = GlobalKey<FormState>();
    _custNameController = TextEditingController();
    _custCodeController = TextEditingController();
    _smplSenderController = TextEditingController();
    _rcvDateController = TextEditingController();
    _noteController = TextEditingController();
    _assigneeController = TextEditingController();
    _itemNameController = TextEditingController();
    _itemCodeController = TextEditingController();
    _qtyController = TextEditingController();
    _unitController = TextEditingController();
    _custNameFocusNode = FocusNode();
    _smplSenderFocusNode = FocusNode();
    _noteFocusNode = FocusNode();
    _assigneeFocusNode = FocusNode();
    _itemNameFocusNode = FocusNode();
    _itemCodeFocusNode = FocusNode();
    _qtyFocusNode = FocusNode();
    _unitFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _custNameController.dispose();
    _custCodeController.dispose();
    _smplSenderController.dispose();
    _rcvDateController.dispose();
    _noteController.dispose();
    _assigneeController.dispose();
    _itemNameController.dispose();
    _itemCodeController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    _custNameFocusNode.dispose();
    _smplSenderFocusNode.dispose();
    _noteFocusNode.dispose();
    _assigneeFocusNode.dispose();
    _itemNameFocusNode.dispose();
    _itemCodeFocusNode.dispose();
    _qtyFocusNode.dispose();
    _unitFocusNode.dispose();
    if (_isOverlayVisible) {
      _overlayEntry.remove();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(
        appBartitle: widget.fromName,
      ),
      body: BlocListener<SmplSaveBloc, SmplSaveState>(
        listener: (context, state) {
          if (state is SmplSaveSuccess) {
            _custNameController.clear();
            _smplSenderController.clear();
            _rcvDateController.clear();
            _noteController.clear();
            _assigneeController.clear();
            _itemCodeController.clear();
            _itemNameController.clear();
            _qtyController.clear();
            _unitController.clear();
            context.read<VariableStateHandlerCubit<UserOrg>>().reset();
            context.read<SampleItemBloc>().add(
                  SampleItemClearAll(),
                );

            AppModal.showCustomModal(
              context,
              content: SampleSuccessWidget(
                headerId: state.headerId,
              ),
            );

            // ScaffoldMessenger.of(context).showSnackBar(
            //   CustomSnackBar.successSnackber(
            //     message: "Created Successfully",
            //   ),
            // );
          }
          if (state is SmplSaveError) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.errorSnackber(
                message: state.error.toString(),
              ),
            );
          }
        },
        child: BlocBuilder<UserOrgBloc, UserOrgState>(
          builder: (context, state) {
            if (state is UserOrgSuccess) {
              orgList = state.userOrg;
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _fromkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: BlocBuilder<VariableStateHandlerCubit<UserOrg>,
                              UserOrg?>(
                            builder: (context, state) {
                              return CustomDropdownSearch<UserOrg>(
                                hintText: "Receiving ORG",
                                value: state,
                                items: orgList,
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                        .read<
                                            VariableStateHandlerCubit<
                                                UserOrg>>()
                                        .update(value);
                                  }
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Please Enter ORG";
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWidget(
                            controller: _custNameController,
                            focusNode: _custNameFocusNode,
                            labelText: "Cust Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Customer Name";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        BlocConsumer<CustomerListBloc, CustomerListState>(
                          listener: (context, state) {
                            if (state is CustomerListSuccess) {
                              _hideOverlay(); // Hide if already visible
                              Future.delayed(
                                Duration.zero,
                                () {
                                  if (context.mounted) {
                                    _showOverlay(context);
                                  }
                                },
                              );
                            }
                          },
                          builder: (context, state) => ElevatedButton(
                            onPressed: () {
                              context.read<CustomerListBloc>().add(
                                  CustomerListGet(
                                      searchV: _custNameController.text));
                            },
                            child: Text(
                              state is CustomerListLoading
                                  ? "Finding.."
                                  : "Find",
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: CommonTextFieldWidget(
                            readOnly: true,
                            controller: _rcvDateController,
                            hintText: "Rcv Date",
                            suffixIcon: const Icon(
                              Icons.calendar_month,
                            ),
                            onTap: () async {
                              var selectedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365)),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                                initialDate: DateTime.now(),
                              );
                              if (selectedDate != null && context.mounted) {
                                _rcvDateController.text =
                                    selectedDate.toFormatedString("dd/MM/yyyy");
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return " Please Select Date";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextFieldWidget(
                            controller: _smplSenderController,
                            focusNode: _smplSenderFocusNode,
                            labelText: "Sample Sender",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Sample Sender";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWidget(
                            controller: _noteController,
                            focusNode: _noteFocusNode,
                            labelText: "Note",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Note";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextFieldWidget(
                            controller: _assigneeController,
                            focusNode: _assigneeFocusNode,
                            labelText: "Assignee",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Assignee";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWidget(
                            controller: _itemCodeController,
                            focusNode: _itemCodeFocusNode,
                            labelText: "Item Code",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Item Code";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: CommonTextFieldWidget(
                            controller: _itemNameController,
                            focusNode: _itemNameFocusNode,
                            labelText: "Item Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Item Name";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextFieldWidget(
                            controller: _qtyController,
                            focusNode: _qtyFocusNode,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'(^\d*\.?\d{0,2})'),
                              )
                            ],
                            labelText: "Quantity",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Quantity";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextFieldWidget(
                            controller: _unitController,
                            focusNode: _unitFocusNode,
                            labelText: "Unit",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Unit";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<SampleItemBloc, SampleItemState>(
                          builder: (context, state) {
                            if (state is SampleItemSuccess &&
                                state.sampleItem.isNotEmpty) {
                              return BlocBuilder<SmplSaveBloc, SmplSaveState>(
                                builder: (context, state) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      if (_fromkey.currentState!.validate()) {
                                        var rcvOrg = context
                                                .read<
                                                    VariableStateHandlerCubit<
                                                        UserOrg>>()
                                                .state!
                                                .organizationId ??
                                            0;
                                        context.read<SmplSaveBloc>().add(
                                              SmplSave(
                                                rcvOrg: rcvOrg,
                                                customerCode:
                                                    _custCodeController.text,
                                                customerName:
                                                    _custNameController.text,
                                                rcvDate:
                                                    _rcvDateController.text,
                                                smplSender:
                                                    _smplSenderController.text,
                                                note: _noteController.text,
                                                assignee:
                                                    _assigneeController.text,
                                                userId: loggedUser.userId,
                                                items: _sampleItem,
                                              ),
                                            );
                                      }
                                    },
                                    child: Text(
                                      state is SmplSaveLoading
                                          ? "Creating.."
                                          : "Create",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.white,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_fromkey.currentState!.validate()) {
                              var sampleItem = SampleItem(
                                itemCode: _itemCodeController.text,
                                itemName: _itemNameController.text,
                                qty: num.parse(_qtyController.text),
                                unit: _unitController.text,
                              );
                              context.read<SampleItemBloc>().add(
                                    SampleItemAdd(sampleItem: sampleItem),
                                  );
                            }
                          },
                          child: Text(
                            "Item Add",
                            style: textTheme.bodyMedium!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.pushNamed(SmplQrListScreen.routeName);
                          },
                          child: Text(
                            "Print List",
                            style: textTheme.bodyMedium!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: BlocBuilder<SampleItemBloc, SampleItemState>(
                        builder: (context, state) {
                          if (state is SampleItemSuccess) {
                            _sampleItem = state.sampleItem;
                            return ListView.separated(
                              itemCount: state.sampleItem.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 10,
                              ),
                              itemBuilder: (context, index) {
                                var item = state.sampleItem[index];
                                return Card(
                                  elevation: 3,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Item Code: ${item.itemCode}",
                                              style: textTheme.bodySmall!
                                                  .copyWith(),
                                            ),
                                            Text(
                                              item.itemName,
                                              style: textTheme.bodySmall!
                                                  .copyWith(),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Quantity: ${item.qty}",
                                              style: textTheme.bodySmall!
                                                  .copyWith(),
                                            ),
                                            Text(
                                              item.unit,
                                              style: textTheme.bodySmall!
                                                  .copyWith(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: IconButton.outlined(
                                            iconSize: 15,
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              context
                                                  .read<SampleItemBloc>()
                                                  .add(
                                                    SampleItemRemove(
                                                      sampleItem: item,
                                                    ),
                                                  );
                                            },
                                            icon: const Icon(
                                              Icons.remove,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SampleSuccessWidget extends StatelessWidget {
  const SampleSuccessWidget({
    super.key,
    required this.headerId,
  });
  final String headerId;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle,
            size: 60, color: const Color.fromRGBO(0, 74, 173, 1)),
        const SizedBox(height: 16),
        Text(
          "Success!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromRGBO(29, 64, 110, 1),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Your request has been submitted.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: const Color.fromRGBO(8, 105, 236, 1),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Request No: $headerId",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(0, 74, 173, 1),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
            child: Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
