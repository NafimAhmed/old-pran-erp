import 'dart:ui';

import 'package:image_picker/image_picker.dart';

class SampleItem {
  final String itemCode;
  final String itemName;
  final num qty;
  final String unit;
  final XFile? imageFile;
  final Color? color;

  SampleItem({
    required this.itemCode,
    required this.itemName,
    required this.qty,
    required this.unit,
    this.imageFile,
    this.color,
  });

  SampleItem copyWith({
    String? itemCode,
    String? itemName,
    num? qty,
    String? unit,
    XFile? imageFile,
    Color? color,
  }) {
    return SampleItem(
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      imageFile: imageFile ?? this.imageFile,
      color: color ?? this.color,
    );
  }
}
