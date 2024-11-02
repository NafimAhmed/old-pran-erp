import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';

class UserDetailsWidget extends StatefulWidget {
  const UserDetailsWidget({
    super.key,
  });

  @override
  State<UserDetailsWidget> createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: appTheme.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Flexible(
              child: Row(
                children: [
                  const Icon(
                    Icons.person_2,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                        context.read<LoggedUserInfoCubit>().state?.userName ??
                            ""),
                  )
                ],
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  DateTime.now().toFormatedString("dd-MMM-yyy"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
