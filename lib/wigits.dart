import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  final String hintText;
  final GlobalKey formKey;
  final TextEditingController controller;

  const CustomForm({Key key, this.hintText, this.formKey, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: Colors.white,
        ),
        keyboardType: TextInputType.text,
        validator: (input) {
          if (input.isEmpty) {
            return "Enter some Text";
          }
          if (input.contains(RegExp(r"^([A-Za-z0-9]){4,20}$"))) {
            return null;
          }
          return "Can't contain special character or space";
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.white70),
          ),
          labelText: hintText,
          labelStyle: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const CustomButton({Key key, this.onTap, this.text}) : super(key: key);

  /// Construct a color from a hex code string, of the format #RRGGBB.
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexToColor("#7991ad"),
              hexToColor("#6b839f"),
            ]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
