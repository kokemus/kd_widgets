import 'package:flutter/material.dart';

import 'submit_button.dart';
import 'simple_text_form_field.dart';

class SimpleForm extends StatefulWidget {
  final String label;
  final List<Widget> fields;
  final Future Function() onSubmit;

  SimpleForm({
    Key key,
    @required this.label, 
    @required this.fields, 
    @required this.onSubmit
  }) : super(key: key);

  factory SimpleForm.signIn({
    Key key,
    String label = 'sign in', 
    String emailHint = 'Email', 
    String passwordlHint = 'Password', 
    @required Function(String) onEmailChanged,
    @required Function(String) onPasswordChanged,
    @required Future Function() onSubmit,
    @required FocusNode emailFocus,
    @required FocusNode passwordFocus,
  }) {
    return SimpleForm(key: key, label: label, onSubmit: onSubmit, fields: [
      SimpleTextFormField.email(
        hintText: emailHint, 
        onChanged: onEmailChanged, 
        node: emailFocus, 
        nextNode: passwordFocus
      ),
      SimpleTextFormField.password(
        hintText: passwordlHint, 
        validator: (value) => value.length > 2 ? null : '', 
        onChanged: onPasswordChanged, 
        node: passwordFocus, 
        nextNode: null
      ),
    ]);
  }

  @override
  State<StatefulWidget> createState() {
    return _SimpleFormState();
  }
}

class _SimpleFormState extends State<SimpleForm> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, 
      autovalidateMode: _autovalidateMode,
      child: Column(
        children: [
          Column(
            children: widget.fields
          ),
          SubmitButton(
            state: SubmitButtonState.initial, 
            labels: {SubmitButtonState.initial : widget.label}, 
            onValidate: _validate, 
            onSubmit: widget.onSubmit, 
            onPressed: () {}
          )
        ],
      )
    );
  }
  
  bool _validate() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    return _formKey.currentState.validate();
  }
}