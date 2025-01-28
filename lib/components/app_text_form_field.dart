import 'package:flutter/material.dart';
import 'package:hencafe/values/app_colors.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    required this.textInputAction,
    required this.labelText,
    required this.keyboardType,
    required this.controller,
    super.key,
    this.onChanged,
    this.validator,
    this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.onEditingComplete,
    this.autofocus,
    this.focusNode,
    this.maxLength,
    this.enabled,
    this.minLines,
    this.maxLines,
  });

  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Icon? prefixIcon;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String labelText;
  final bool? autofocus;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines != null ? 90 : 70.0,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onChanged: onChanged,
        autofocus: autofocus ?? false,
        validator: validator,
        obscureText: obscureText ?? false,
        obscuringCharacter: '*',
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines ?? 1,
        enabled: enabled ?? true,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: enabled! ? Colors.white : Colors.grey.shade200,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: labelText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}
