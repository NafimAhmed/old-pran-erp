import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/generate_qr_screen/cubit/qr_generate_cubit.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GenerateQrScreen extends StatefulWidget {
  const GenerateQrScreen({super.key});
  static const String routePath = "/generateQr-screen";
  static const String routeName = "generateQr-screen";
  @override
  State<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrGenerateCubit(),
      child: const GenerateQrScreenBody(),
    );
  }
}

class GenerateQrScreenBody extends StatefulWidget {
  const GenerateQrScreenBody({super.key});

  @override
  State<GenerateQrScreenBody> createState() => _GenerateQrScreenBodyState();
}

class _GenerateQrScreenBodyState extends State<GenerateQrScreenBody> {
  late EmployeeDataSource _employeeDataSource;

  List<QrData> _employees = <QrData>[];
  List<QrData> getEmployeeData() {
    return [
      QrData(
        'Org',
        'PBO-RIP-Plas Export',
      ),
      QrData(
        'Item',
        '620256 Storage Container Square Lid367 ml Purple',
      ),
      QrData(
        'Order Info',
        'Developer',
      ),
      QrData(
        'Prod Qty',
        '12000',
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _employees = getEmployeeData();
    _employeeDataSource = EmployeeDataSource(employees: _employees);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "GenerateQr"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: appTheme.primary,
                    ),
                    child: const Column(
                      children: [
                        QrDataWidget(
                          lable: "ORG",
                          value: "PBO-RIP-Plas Export",
                        ),
                        QrDataWidget(
                          lable: "Item",
                          value:
                              "620256 Storage Container Square Lid367 ml Purple",
                        ),
                        QrDataWidget(
                          lable: "Order Info",
                          value: "",
                        ),
                        QrDataWidget(
                          lable: "Prod Qty",
                          value: "12000000",
                        ),
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //   flex: 1,
                //   child: QrImageView(
                //     data:
                //         "dsagdsadgsadgsadsagdsagduusadsadasdsaodsasjkadhsa[odhisa[doisdhsaodsa]]",
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class QrDataWidget extends StatelessWidget {
  const QrDataWidget({
    super.key,
    required this.lable,
    required this.value,
  });
  final String lable;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            lable,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: appTheme.white,
                ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Flexible(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: appTheme.white,
                ),
          ),
        )
      ],
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<QrData> employees}) {
    dataGridRows = employees
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(
                  columnName: 'designation', value: dataGridRow.description),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: (dataGridCell.columnName == 'id' ||
                  dataGridCell.columnName == 'salary')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
          ));
    }).toList());
  }
}

class QrData {
  QrData(
    this.name,
    this.description,
  );

  final String name;
  final String description;
}
// Container(
            //   margin: const EdgeInsets.all(20),
            //   child: TextField(
            //     controller: controller,
            //     decoration: const InputDecoration(
            //         border: OutlineInputBorder(), labelText: 'Enter your URL'),
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     context
            //         .read<QrGenerateCubit>()
            //         .setNewData(qrData: controller.text);
            //   },
            //   child: Text(
            //     'GENERATE QR CODE',
            //     style: textTheme.bodySmall!.copyWith(
            //       color: appTheme.white,
            //     ),
            //   ),
            // ),
            // BlocBuilder<QrGenerateCubit, String>(
            //   builder: (context, state) {
            //     return Center(
            //       child: QrImageView(
            //         data: state,
            //         size: 280,
            //         // // You can include embeddedImageStyle Property if you
            //         // //wanna embed an image from your Asset folder
            //         // embeddedImage: AssetImage(ImageConstant.adminSettings),
            //         // embeddedImageStyle: const QrEmbeddedImageStyle(
            //         //   color: Colors.black,
            //         //   size: Size(
            //         //     100,
            //         //     100,
            //         //   ),
            //         // ),
            //       ),
            //     );
            //   },
            // ),