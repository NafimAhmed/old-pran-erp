import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_7_screen.dart/bloc/Project_create_bloc.dart';

class ProjectC7Screen extends StatelessWidget {
  const ProjectC7Screen({super.key, required this.fromName});
  static const String routeName = "PROJECT-C-7-SCREEN";
  static const String routePath = "/PROJECT-C-7-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<Priority>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<Status>(),
        ),
        BlocProvider(
          create: (context) => ProjectCreateBloc(getService()),
        ),
      ],
      child: ProjectC7ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

enum Priority {
  high("High"),
  low("Low"),
  medium("Medium"),
  ;

  const Priority(this.value);

  final String value;

  @override
  String toString() {
    return value;
  }
}

enum Status {
  notStarted("Not Started"),
  inProgress("In Progress"),
  onHold("On Hold"),
  completed("Completed"),
  cancelled("Cancelled"),
  ;

  const Status(this.value);

  final String value;

  @override
  String toString() {
    return value;
  }
}

class ProjectC7ScreenBody extends StatefulWidget {
  const ProjectC7ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<ProjectC7ScreenBody> createState() => _ProjectC7ScreenBodyState();
}

class _ProjectC7ScreenBodyState extends State<ProjectC7ScreenBody> {
  late TextEditingController _projectNameController;
  late TextEditingController _projectDecsController;
  late TextEditingController _stDateController;
  late TextEditingController _enDateController;
  late TextEditingController _projectManagerController;
  late TextEditingController _clientNameController;
  late TextEditingController _budgetController;
  late TextEditingController _totalPersonController;
  late TextEditingController _manHourController;

  late FocusNode _projectNameFocusNode;
  late FocusNode _projectDecsFocusNode;

  late FocusNode _projectManagerFocusNode;
  late FocusNode _clientNameFocusNode;
  late FocusNode _budgetFocusNode;
  late FocusNode _totalPersonFocusNode;
  late FocusNode _manHourFocusNode;
  late GlobalKey<FormState> _fromkey;
  @override
  void initState() {
    _fromkey = GlobalKey<FormState>();
    _projectNameController = TextEditingController();
    _projectDecsController = TextEditingController();
    _stDateController = TextEditingController();
    _enDateController = TextEditingController();
    _projectManagerController = TextEditingController();
    _clientNameController = TextEditingController();
    _budgetController = TextEditingController();
    _totalPersonController = TextEditingController();
    _manHourController = TextEditingController();

    _projectNameFocusNode = FocusNode();
    _projectDecsFocusNode = FocusNode();

    _projectManagerFocusNode = FocusNode();
    _clientNameFocusNode = FocusNode();
    _budgetFocusNode = FocusNode();
    _totalPersonFocusNode = FocusNode();
    _manHourFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectDecsController.dispose();
    _stDateController.dispose();
    _enDateController.dispose();
    _projectManagerController.dispose();
    _clientNameController.dispose();
    _budgetController.dispose();
    _totalPersonController.dispose();
    _manHourController.dispose();

    _projectNameFocusNode.dispose();
    _projectDecsFocusNode.dispose();

    _projectManagerFocusNode.dispose();
    _clientNameFocusNode.dispose();
    _budgetFocusNode.dispose();
    _totalPersonFocusNode.dispose();
    _manHourFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Priority? selectedPriority = context.select(
      (VariableStateHandlerCubit<Priority> cubit) => cubit.state,
    );
    Status? selectedStatus = context.select(
      (VariableStateHandlerCubit<Status> cubit) => cubit.state,
    );
    return Scaffold(
      appBar: CommonAppBar(
        appBartitle: widget.fromName,
      ),
      body: BlocListener<ProjectCreateBloc, ProjectCreateState>(
        listener: (context, state) {
          if (state is ProjectCreateSuccess) {
            _projectNameController.clear();
            _projectDecsController.clear();
            _stDateController.clear();
            _enDateController.clear();
            _projectManagerController.clear();
            _clientNameController.clear();
            _budgetController.clear();
            _totalPersonController.clear();
            _manHourController.clear();
            context.read<VariableStateHandlerCubit<Priority>>().reset();
            context.read<VariableStateHandlerCubit<Status>>().reset();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _fromkey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                CommonTextFieldWidget(
                  controller: _projectNameController,
                  focusNode: _projectNameFocusNode,
                  labelText: "Project Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Project Name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CommonTextFieldWidget(
                  controller: _projectDecsController,
                  focusNode: _projectDecsFocusNode,
                  labelText: "Project Desc",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Project Desc";
                    }
                    return null;
                  },
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
                        controller: _stDateController,
                        hintText: "Start Date",
                        suffixIcon: const Icon(
                          Icons.calendar_month,
                        ),
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 120)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 120)),
                            initialDate: DateTime.now(),
                          );
                          if (selectedDate != null && context.mounted) {
                            _stDateController.text = selectedDate.toString();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CommonTextFieldWidget(
                        readOnly: true,
                        controller: _enDateController,
                        hintText: "End Date",
                        suffixIcon: const Icon(
                          Icons.calendar_month,
                        ),
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 120)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 120)),
                            initialDate: DateTime.now(),
                          );
                          if (selectedDate != null && context.mounted) {
                            _enDateController.text = selectedDate.toString();
                          }
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CommonTextFieldWidget(
                  controller: _projectManagerController,
                  focusNode: _projectManagerFocusNode,
                  labelText: "Project Manager",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Project Manager";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CommonTextFieldWidget(
                  controller: _clientNameController,
                  focusNode: _clientNameFocusNode,
                  labelText: "Client Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Client Name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CommonTextFieldWidget(
                        controller: _budgetController,
                        focusNode: _budgetFocusNode,
                        labelText: "Budget",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Budget";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CommonDropdownButton<Status>(
                        hintText: "Select Status",
                        value: selectedStatus,
                        items: Status.values,
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<VariableStateHandlerCubit<Status>>()
                                .update(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CommonDropdownButton<Priority>(
                  hintText: "Select Priority",
                  value: selectedPriority,
                  items: Priority.values,
                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<VariableStateHandlerCubit<Priority>>()
                          .update(value);
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CommonTextFieldWidget(
                        controller: _totalPersonController,
                        focusNode: _totalPersonFocusNode,
                        labelText: "Total Person",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Total Person";
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
                        controller: _manHourController,
                        focusNode: _manHourFocusNode,
                        labelText: "Man Hours",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Man Hours";
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
                BlocBuilder<ProjectCreateBloc, ProjectCreateState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (_fromkey.currentState!.validate() &&
                            selectedStatus != null &&
                            selectedPriority != null) {
                          context.read<ProjectCreateBloc>().add(
                                ProjectCreate(
                                  pname: _projectNameController.text,
                                  pDesc: _projectDecsController.text,
                                  stDate: DateTime.parse(_stDateController.text)
                                      .toFormatedString("dd-MMM-yyyy"),
                                  endate: DateTime.parse(_enDateController.text)
                                      .toFormatedString("dd-MMM-yyyy"),
                                  pManager: _projectManagerController.text,
                                  pClientName: _clientNameController.text,
                                  pBudget: _budgetController.text,
                                  pStatus: selectedStatus.value,
                                  pPriority: selectedPriority.value,
                                  pTtlPerson: _totalPersonController.text,
                                  pManHours: _manHourController.text,
                                ),
                              );
                        }
                      },
                      child: Text(
                        state is ProjectCreateLoading
                            ? "Creating Project..!"
                            : "Create Project",
                        style: textTheme.bodyMedium!.copyWith(
                          color: appTheme.white,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
