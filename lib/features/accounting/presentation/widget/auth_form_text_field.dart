import 'package:flutter/material.dart';

class AuthFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const AuthFormTextField({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: controller,
          validator: ((value) {
            final int treshold;
            switch (label) {
              case 'User Name':
                treshold = 8;
                break;
              case 'Password':
                treshold = 8;
                break;
              case 'Email':
                treshold = 8;
                break;
              case 'Car Model':
                treshold = 4;
                break;
              case 'License Plate':
                treshold = 5;
                break;
              default:
                treshold = 0;
                break;
            }
            if (value!.isEmpty || value.length < treshold) {
              return '$label must at least be $treshold characters';
            }
            if (label == 'Email' && !value.contains('@')) {
              return 'Email Should Have @ In It';
            }
            return null;
          }),
          obscureText: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
