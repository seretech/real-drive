import 'package:flutter/material.dart';

import '../classes/app_color.dart';
import '../classes/main_class.dart';

class EdtPass extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final Function()? onPress;
  final FocusNode focusNode;
  final TextEditingController textController;
  final TextInputType? textInputType;
  final String? hint;
  final int? max;
  final bool chk;
  final bool? auto;

  const EdtPass(
      {super.key,
        this.onChanged,
        required this.onPress,
        required this.focusNode,
        required this.textController,
        required this.chk,
        this.textInputType,
        this.hint,
        this.max,
        this.auto
      });

  @override
  State<EdtPass> createState() => _State();
}

class _State extends State<EdtPass> {


  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      controller: widget.textController,
      focusNode: widget.focusNode,
      keyboardType: widget.textInputType ?? TextInputType.text,
      maxLength: widget.max ?? 256,
      style: MainClass.txtStyle(),
      cursorColor: Colors.black,
      maxLines: 1,
      autocorrect: false,
      autofocus: widget.auto ?? false,
      enableSuggestions: false,
      obscureText: widget.chk,
      obscuringCharacter: '*',
      onTapOutside: (v){
        widget.focusNode.unfocus();
      },
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hint ?? '',
        hintStyle: MainClass.hintStyle(),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: widget.hint,
        labelStyle: TextStyle(
         fontSize: 12
       ),
        isDense: true,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.colorAppLight),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: AppColor.colorAppGray)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: AppColor.colorApp)),
        suffixIcon: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            icon: widget.chk
                ? Icon(Icons.visibility_off_outlined,
                color: AppColor.colorAppGray)
                : Icon(Icons.visibility_outlined,
                color: AppColor.colorAppGray),
            onPressed: widget.onPress
        ),
      ),
    );
  }
}