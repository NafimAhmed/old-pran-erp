import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class SampleSuccessWidget extends StatelessWidget {
  const SampleSuccessWidget({
    super.key,
    required this.headerId,
  });
  final String headerId;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle,
            size: 60, color: Color.fromRGBO(0, 74, 173, 1)),
        const SizedBox(height: 16),
        Text(
          "Success!",
          style: textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color.fromRGBO(29, 64, 110, 1),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Your request has been submitted.",
          textAlign: TextAlign.center,
          style: textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color.fromRGBO(29, 64, 110, 1),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Request No: $headerId",
          style: textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color.fromRGBO(29, 64, 110, 1),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
            child: Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
