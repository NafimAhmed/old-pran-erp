import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key, required this.appBartitle});
  final String appBartitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 5,
      shadowColor: Colors.grey,
      surfaceTintColor: Colors.transparent,
      title: Text(
        appBartitle,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: textTheme.titleMedium!.copyWith(
          color: appTheme.tertiary,
          fontWeight: FontWeight.w700,
        ),
      ),
      leadingWidth: 100,
      toolbarHeight: 70,
      leading: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Container(
          decoration: BoxDecoration(
            color: appTheme.primary,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: appTheme.tertiary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Icon(
                    size: 15,
                    Icons.arrow_back_ios_new_rounded,
                    color: appTheme.white,
                  ),
                ),
              ),
              Transform.rotate(
                angle: -3.14159 /
                    2, // Angle in radians (e.g., -π/4 for 45 degrees counterclockwise)
                child: const Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12, // You can set the font size here
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: appTheme.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
