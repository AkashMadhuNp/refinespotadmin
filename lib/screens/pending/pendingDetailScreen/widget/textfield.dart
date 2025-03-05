import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildFormField extends StatelessWidget {
  final String label;
  final String value;
  final Widget? suffix;  // Add this line

  const BuildFormField({
    Key? key,
    required this.label,
    required this.value,
    this.suffix,  // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(  // Wrap in Row
            children: [
              Expanded(  // Expand the text
                child: Text(
                  value,
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
              ),
              if (suffix != null) suffix!,  // Add suffix if provided
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}