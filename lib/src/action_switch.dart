import 'package:flutter/material.dart';

class ActionSwitch extends StatefulWidget {
  const ActionSwitch({
    Key key,
    @required this.value,
    @required this.onAction,
    @required this.error,
  }) : super(key: key);

  final bool value;
  final Future<bool> Function(bool value) onAction;
  final String error;

  @override
  State<StatefulWidget> createState() => _ActionSwitchState();
}

class _ActionSwitchState extends State<ActionSwitch> {

  bool _progress = false;

  @override
  Widget build(BuildContext context) {
    return _progress
      ? SizedBox(
          width: 60.0, height: 20.0,
          child: Center(
            child: SizedBox(
              width: 20.0, height: 20.0,
              child: CircularProgressIndicator()
            )
          )
        )
      : Switch(
          value: widget.value,
          onChanged: (value) async {
            setState(() {
              _progress = true;
            });
            if (!await widget.onAction(value)) {
              final snackBar = SnackBar(
                content: Text(widget.error),
                duration: Duration(seconds: 10),
                action: SnackBarAction(
                  label: 'ok'.toUpperCase(),
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            setState(() {
              _progress = false;
            }
          );
        },
      );
  }
}