import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class OpmC8Screen extends StatelessWidget {
  const OpmC8Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-8-SCREEN";
  static const String routePath = "/OPM-C-8-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return OpmC8ScreenBody(
      fromName: fromName,
    );
  }
}

class OpmC8ScreenBody extends StatefulWidget {
  const OpmC8ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC8ScreenBody> createState() => _OpmC8ScreenBodyState();
}

class _OpmC8ScreenBodyState extends State<OpmC8ScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    height: 100,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              "Close",
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
