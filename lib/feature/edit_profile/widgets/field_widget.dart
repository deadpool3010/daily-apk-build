import 'package:flutter/material.dart';

class FieldWidget extends StatelessWidget {
  FieldWidget({
    super.key,
    required this.label,
    this.icon,
    this.readOnly = false,
    this.controller,
    this.onTap,
  });
  final IconData? icon;
  final String label;
  final bool readOnly;
  void Function()? onTap;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          TextFormField(
            onTap: onTap,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            enabled: true,
            readOnly: readOnly,
            decoration: InputDecoration(
              suffixIcon: icon != null ? Icon(icon) : null,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.blue),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
