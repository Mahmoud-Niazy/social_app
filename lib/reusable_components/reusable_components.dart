import 'package:flutter/material.dart';

BuildTextFormField({
  required TextEditingController controller,
  required double radius,
  required String label,
  required IconData pIcon,
  IconData? sIcon,
  void Function()? onPressedOnSIcon,
  void Function()? onPressedOnPIcon,
  void Function(String value)? onChanged,
   String? Function(String? value)? validator,
  bool isPassword = false,
  TextInputType? type ,
  Color? colorOfSIcon,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      label: Text(label),
      prefixIcon: InkWell(
        onTap: onPressedOnPIcon,
        child: Icon(
          pIcon,
        ),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          sIcon,
          color: colorOfSIcon,
        ),
        onPressed: onPressedOnSIcon,
      ),
    ),
    onChanged: onChanged,
    validator: validator,
    obscureText: isPassword,
  );
}

BuildMaterialButton({
  double width = double.infinity,
  double height = 50,
  required void Function()? onPressed,
  required String label,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(15),
    ),
    child: MaterialButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

NavigateWithName({
  required BuildContext context,
  required String route,
  Object? data,
}) {
  Navigator.pushNamed(
    context,
    route,
    arguments: data,
  );
}

NavigateAndRemove({
  required  context,
  required String route,
  Object? data,
}) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    route,
    (route) => false,
    arguments: data,
  );
}
