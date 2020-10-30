import 'package:flutter/material.dart';

class SimpleTextFormField extends StatefulWidget {
  final String hintText;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  final FocusNode node;
  final FocusNode nextNode;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final bool obscureText;

  SimpleTextFormField({
    Key key,
    this.hintText, 
    this.validator, 
    this.onChanged, 
    this.node, 
    this.nextNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.obscureText = false
  }) : super(key: key);

  factory SimpleTextFormField.email({
    Key key,
    String hintText,
    ValueChanged<String> onChanged,
    FocusNode node,
    FocusNode nextNode,
  }) {
    return SimpleTextFormField(
      key: key,
      hintText: hintText, 
      validator: (value) => RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value) ? null : '', 
      onChanged: onChanged, 
      node: node, 
      nextNode: nextNode, 
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      obscureText: false,
    );
  }

  factory SimpleTextFormField.password({
    Key key,
    String hintText,
    FormFieldValidator<String> validator,
    ValueChanged<String> onChanged,
    FocusNode node,
    FocusNode nextNode,
  }) {
    return SimpleTextFormField(
      key: key,
      hintText: hintText, 
      validator: validator, 
      onChanged: onChanged, 
      node: node, 
      nextNode: nextNode, 
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.none,
      obscureText: true,
    );
  }

  @override
  State<SimpleTextFormField> createState() {
    return _SimpleTextFormFieldState();
  }
}

class _SimpleTextFormFieldState extends State<SimpleTextFormField> {

  String _value = '';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(), 
        labelText: widget.hintText,
        helperText: '',
        suffixIcon: widget.validator(_value) == null ? Icon(Icons.check, color: Colors.green) : null
      ),
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      onChanged: _onChanged,
      validator: widget.validator,
      focusNode: widget.node,
      onFieldSubmitted: (value) {
        widget.node?.unfocus();
        widget.nextNode?.requestFocus();
      },
    );
  }

  _onChanged(String value) {
    setState(() {
      _value = value;
    });
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }
}