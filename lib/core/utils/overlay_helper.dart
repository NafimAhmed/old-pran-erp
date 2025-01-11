import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

void showOverlay(BuildContext context) {
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: 15,
      right: 15,
      child: Material(
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          // padding: const EdgeInsets.all(5),

          decoration: BoxDecoration(
            color: appTheme.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                        color: appTheme.tertiary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'This is a pop-up dialog',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  // Remove overlay entry after a delay
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
