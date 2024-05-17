import 'package:flutter/material.dart';

class CustFormField extends StatelessWidget {
  final String hintText;
  final Icon? prefix;
  final double defsize;
  final RegExp regvalidation;
  final void Function(String?)? onSaved;
  final TextEditingController? controller; // New controller parameter

  const CustFormField({
    super.key,
    required this.hintText,
    this.prefix,
    required this.defsize,
    required this.regvalidation,
    this.onSaved,
    this.controller, // Initialize the controller
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: defsize,
      child: TextFormField(
        controller: controller, // Use the controller here
        onSaved: onSaved,
        validator: (value) {
          if (value != null && regvalidation.hasMatch(value)) {
            return null;
          }
          return "Enter a valid ${hintText.toLowerCase()}";
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(153, 255, 255, 255)),
          prefixIcon: prefix,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}
