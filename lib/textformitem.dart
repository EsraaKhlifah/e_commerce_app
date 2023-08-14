import 'package:flutter/material.dart';

Widget textFormItem({required String hintTitle,required TextEditingController controller}){
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
        hintText: hintTitle,
        border: const OutlineInputBorder()
    ),
    validator: (input){
      if( controller.text.isNotEmpty )
      {
        return null;
      }
      else
      {
        return "$hintTitle must not be empty!";
      }
    },
  );
}
