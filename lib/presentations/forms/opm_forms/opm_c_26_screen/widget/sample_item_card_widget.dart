import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pran_rfl_erp/common_widgets/color_picker_dialog.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/core/utils/image_picker_helper.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_26_screen/bloc/sample_item_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_26_screen/model/sample_item.dart';

class SampleItemCard extends StatefulWidget {
  const SampleItemCard({
    super.key,
    required this.item,
  });

  final SampleItem item;

  @override
  State<SampleItemCard> createState() => _SampleItemCardState();
}

class _SampleItemCardState extends State<SampleItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Item",
                      style: textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: appTheme.tertiary,
                      ),
                    ),
                    Text(
                      "${widget.item.itemCode}-${widget.item.itemName}(${widget.item.unit})",
                      style: textTheme.bodySmall!.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Quantity",
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: appTheme.tertiary,
                        )),
                    Text(
                      widget.item.qty.toString(),
                      style: textTheme.bodySmall!.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.item.imageFile != null
                    ? Row(
                        children: [
                          Text(
                            "Image file Attached",
                            style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.attach_file_sharp,
                            size: 15,
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  width: 15,
                ),
                widget.item.color != null
                    ? Row(
                        children: [
                          Text(
                            "Color",
                            style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 20,
                            width: 40,
                            decoration: BoxDecoration(
                                color: widget.item.color,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: IconButton.filled(
                    iconSize: 15,
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      var imagefile = await selectImage(
                        ImageSource.camera,
                      );
                      if (imagefile != null) {
                        var updateItem =
                            widget.item.copyWith(imageFile: imagefile);

                        if (context.mounted) {
                          context.read<SampleItemBloc>().add(
                                SampleItemUpdate(sampleItem: updateItem),
                              );
                        }

                        setState(() {});
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  height: 25,
                  width: 25,
                  child: IconButton.filled(
                    iconSize: 15,
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      final Color? pickedColor =
                          await AppModal.showCustomModal<Color>(
                        context,
                        content: const ColorPickerDialog(),
                      );

                      if (pickedColor != null) {
                        setState(() {
                          var updateItem =
                              widget.item.copyWith(color: pickedColor);
                          if (context.mounted) {
                            context.read<SampleItemBloc>().add(
                                  SampleItemUpdate(sampleItem: updateItem),
                                );
                          }
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.colorize,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  height: 25,
                  width: 25,
                  child: IconButton.filled(
                    iconSize: 15,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      context.read<SampleItemBloc>().add(
                            SampleItemRemove(
                              sampleItem: widget.item,
                            ),
                          );
                    },
                    icon: const Icon(
                      Icons.remove,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
