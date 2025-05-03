import 'package:image_picker/image_picker.dart';

class SampleItem {
  final String itemCode;
  final String itemName;
  final num qty;
  final String unit;
  final XFile? imageFile;

  SampleItem({
    required this.itemCode,
    required this.itemName,
    required this.qty,
    required this.unit,
    this.imageFile,
  });

  SampleItem copyWith({
    String? itemCode,
    String? itemName,
    num? qty,
    String? unit,
    XFile? imageFile,
  }) {
    return SampleItem(
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}
