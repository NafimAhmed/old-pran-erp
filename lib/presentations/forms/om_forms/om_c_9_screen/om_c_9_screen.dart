import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_7_screen/bloc/Jo_list_bloc.dart';

class OmC9Screen extends StatelessWidget {
  const OmC9Screen({super.key, required this.fromName});
  static const String routeName = "OM-C-9-SCREEN";
  static const String routePath = "/OM-C-9-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => JoListBloc(getService()),
        ),
        BlocProvider(
          create: (context) =>
              VariableStateHandlerCubit<List<int>>()..update([]),
        ),
      ],
      child: OmC9ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class OmC9ScreenBody extends StatefulWidget {
  const OmC9ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OmC9ScreenBody> createState() => _OmC9ScreenBodyState();
}

class _OmC9ScreenBodyState extends State<OmC9ScreenBody> {
  TextEditingController orgDropDownTextController = TextEditingController();
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<JoListBloc>().add(
          GetJoList(
            userId: loggedUser.userId,
          ),
        );
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
          horizontal: 15,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<JoListBloc, JoListState>(
              builder: (context, state) {
                return CommonDropDownMenuWidget<JoInfo>(
                  hintText: "Job Order No",
                  enabled: state is JoListSuccess ? true : false,
                  controller: orgDropDownTextController,
                  dropdownMenuEntries:
                      state is JoListSuccess ? state.joInfoList : [],
                  onSelected: (value) {
                    if (value != null) {
                      // FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return TaskWidget(
                    index: index,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<DateTime>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<String>(),
        ),
      ],
      child: TaskWidgetContent(
        index: index,
      ),
    );
  }
}

class TaskWidgetContent extends StatefulWidget {
  const TaskWidgetContent({
    super.key,
    required this.index,
  });
  final int index;
  @override
  State<TaskWidgetContent> createState() => _TaskWidgetContentState();
}

class _TaskWidgetContentState extends State<TaskWidgetContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo[100],
        borderRadius: BorderRadius.circular(5),
      ),
      child: CheckboxListTile(
        visualDensity: VisualDensity.standard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          "Task Name",
          style: textTheme.bodyMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Start Date"),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                      textAlign: TextAlign.right,
                      context
                              .watch<VariableStateHandlerCubit<DateTime>>()
                              .state
                              ?.toFormatedString("dd-MMM-yyyy") ??
                          ""),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () async {
                    var selectedDate = await showDatePicker(
                      context: context,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 120)),
                      lastDate: DateTime.now().add(const Duration(days: 120)),
                      initialDate: DateTime.now(),
                    );
                    if (selectedDate != null && context.mounted) {
                      context
                          .read<VariableStateHandlerCubit<DateTime>>()
                          .update(selectedDate);
                    }
                  },
                  child: const Icon(
                    Icons.calendar_month_sharp,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Comlt Date"),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                      textAlign: TextAlign.right,
                      context
                              .watch<VariableStateHandlerCubit<String>>()
                              .state ??
                          ""),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () async {
                    var selectedDate = await showDatePicker(
                      context: context,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 120)),
                      lastDate: DateTime.now().add(const Duration(days: 120)),
                      initialDate: DateTime.now(),
                    );
                    if (selectedDate != null && context.mounted) {
                      context
                          .read<VariableStateHandlerCubit<String>>()
                          .update(selectedDate.toFormatedString("dd-MMM-yyyy"));
                    }
                  },
                  child: const Icon(
                    Icons.calendar_month_sharp,
                  ),
                ),
              ],
            ),
          ],
        ),
        value: context
                .watch<VariableStateHandlerCubit<List<int>>>()
                .state
                ?.contains(widget.index) ??
            false,
        onChanged: (value) {
          if (value != null && _validator()) {
            var selectedList = List<int>.from(
                context.read<VariableStateHandlerCubit<List<int>>>().state ??
                    []);
            if (value) {
              selectedList.add(widget.index);
            } else {
              selectedList.remove(widget.index);
            }
            context
                .read<VariableStateHandlerCubit<List<int>>>()
                .update(selectedList);
          }
        },
      ),
    );
  }

  bool _validator() {
    var selectedStartDt =
        context.read<VariableStateHandlerCubit<DateTime>>().state;
    var selectedComplDt =
        context.read<VariableStateHandlerCubit<String>>().state;
    if (selectedStartDt == null && selectedComplDt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.errorSnackber(message: "Please Assign Date"));
      return false;
    } else {
      return true;
    }
  }
}
