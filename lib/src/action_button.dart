import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({
    Key key,
    @required this.iconData,
    @required this.onAction,
    @required this.error,
  }) : super(key: key);

  final IconData iconData;
  final Future<bool> Function() onAction;
  final String error;

  @override
  State<StatefulWidget> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {

  bool _progress = false;

  @override
  Widget build(BuildContext context) {
    return _progress
      ? SizedBox(
          width: 40.0, height: 20.0,
          child: Center(
            child: SizedBox(
              width: 20.0, height: 20.0,
              child: CircularProgressIndicator()
            )
          )
        )
      : IconButton(
        icon: Icon(widget.iconData,),
        onPressed: () async {
          setState(() {
            _progress = true;
          });
          if (!await widget.onAction()) {
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
          });
        },
      );
  }
}