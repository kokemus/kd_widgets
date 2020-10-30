import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kd_widgets/kd_widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KD Widgets Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Widgets Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _filters = [
    Filter('Filter 1', 'filter1', false), Filter('Filter 2', 'filter2', false), 
    Filter('Filter 3', 'filter3', false), Filter('Filter 4', 'filter4', true), 
    Filter('Filter 5', 'filter5', false), Filter('Filter 6', 'filter6', false), 
    Filter('Filter 7', 'filter7', false), Filter('Filter 8', 'filter8', false)
  ];
  var _searchExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeading('SearchBar persistent'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                onQueryChanged: print,
                onSubmitted: print,
                onVoiceInput: () {},
              ),
            ),
            _buildHeading('SearchBar expandable'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _searchExpanded ? SearchBar.expandable(
                onQueryChanged: print,
                onSubmitted: print,
                onVoiceInput: () {}, 
                queryHint: 'Search by sender',
                onClose: () {
                  setState(() {
                    _searchExpanded = false; 
                  });
                },
              ) : AppBar(
                leading: IconButton(icon: Icon(Icons.menu), onPressed: () {},),
                title: Text('Inbox'),
                centerTitle: false,
                actions: [
                  IconButton(icon: Icon(Icons.search), onPressed: () { 
                    setState(() {
                      _searchExpanded = true; 
                    });
                  },)
                ]
              ),
            ),            
            _buildHeading('FilterRow'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FilterRow(
                filters: _filters,
                onChanged: (filters) => print(filters),
                multipleChoice: false,
              ),
            ),
            _buildHeading('FilterRow without wrapping'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FilterRow.horizontalScroll(
                filters: _filters,
                onChanged: (filters) => print(filters),
              ),
            ),            
            _buildHeading('FilterRow with multiple choice'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FilterRow(
                filters: _filters,
                onChanged: (filters) => print(filters),
                multipleChoice: true,
              ),
            ),            
            _buildHeading('SubmitButton with success'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: 
                SubmitButton(
                  state: SubmitButtonState.initial, 
                  labels: {SubmitButtonState.initial : 'button'}, 
                  onSubmit: _submit, onPressed: () {}
                )
              ),
            ),
            _buildHeading('SubmitButton with error'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: 
                SubmitButton(
                  state: SubmitButtonState.initial, 
                  labels: {SubmitButtonState.initial : 'button'}, 
                  onSubmit: _submitError, onPressed: () {}
                )
              ),
            ),
            _buildHeading('SimpleTextFormField and SubmitButton'),        
            Container(child: Form(
              key: _formKey, 
              autovalidateMode: _autovalidateMode,
              child: Column(
                children: [
                  SimpleTextFormField.email(
                    hintText: 'Email*', 
                    onChanged: (value) => print(value), 
                    node: _emailFocus, 
                    nextNode: _passwordFocus
                  ),
                  SimpleTextFormField.password(
                    hintText: 'Password*', 
                    validator: (value) => value.length > 2 ? null : '', 
                    onChanged: (value) => 
                    print(value), node: _passwordFocus, 
                    nextNode: null
                  ),
                  SubmitButton(state: SubmitButtonState.initial, labels: {SubmitButtonState.initial : 'Login'}, onValidate: _validate, onSubmit: _submit, onPressed: () {}),
                ],
              ),
            ), padding: EdgeInsets.all(16),),
            _buildHeading('SimpleForm.signIn'),
            Container(
              child: 
                SimpleForm.signIn(
                  onSubmit: _submit, 
                  onEmailChanged: (value) => print(value), 
                  onPasswordChanged: (value) => print(value), 
                  emailFocus: _emailFocus, 
                  passwordFocus: _passwordFocus,
                ), 
              padding: EdgeInsets.all(16),),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading(String label) {
     return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Divider(thickness: 1,),
        ],
      ),
    );
  }

  bool _validate() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    return _formKey.currentState.validate();
  }

  Future _submit() async {
    return Future.delayed(Duration(seconds: 3), () {
      return null;
    });
  }

  Future _submitError() async {
    return Future.delayed(Duration(seconds: 3), () {
      throw HttpException('Server error');
    });
  }
}