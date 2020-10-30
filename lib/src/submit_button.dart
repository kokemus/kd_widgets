import 'package:flutter/material.dart';

class CapsText extends Text {
  CapsText(String data, {TextStyle style}) : super(data.toUpperCase(), style: style);
}

enum SubmitButtonState {
  initial,
  submitting,
  error,
  success
}

class SubmitButton extends StatefulWidget {
  final SubmitButtonState state;
  final VoidCallback onPressed;
  final Function(SubmitButtonState) onStateChanged;
  final bool Function() onValidate;
  final Future Function() onSubmit;
  final Map<SubmitButtonState, String> labels;
  final Color color;
  final Color textColor;

  SubmitButton({
    Key key,
    @required this.labels,  
    this.onPressed, 
    this.state = SubmitButtonState.initial,
    this.onStateChanged, 
    this.onValidate, 
    this.onSubmit, 
    this.color, 
    this.textColor
  }) : super(key: key);

  @override
  State<SubmitButton> createState() {
    return _SubmitButtonState();
  }
}

class _SubmitButtonState extends State<SubmitButton> {
  SubmitButtonState _state = SubmitButtonState.initial;

  @override
  void initState() {
    _state = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case SubmitButtonState.success:
        return _SubmitButton(label: widget.labels[_state] ?? 'success', onPressed: _onSuccess, state: SubmitButtonState.success,);
        break;
      case SubmitButtonState.error:
        return _SubmitButton(label: widget.labels[_state] ?? 'try again', onPressed: _onError, state: SubmitButtonState.error,);
        break;
      case SubmitButtonState.submitting:
        return _SubmitButton(label: widget.labels[_state] ?? '', onPressed: null, state: SubmitButtonState.submitting,);
        break; 
      case SubmitButtonState.initial:     
      default:
        return _SubmitButton(label: widget.labels[_state] ?? '', onPressed: _onInitial, state: SubmitButtonState.initial,);
    }
  }

  void _onInitial() async {
    if (widget.onValidate != null && !widget.onValidate()) {
      return;
    }

    setState(() {
      _state = SubmitButtonState.submitting;
    });
    if (widget.onStateChanged != null) {
      widget.onStateChanged(_state);
    }
    if (widget.onPressed != null) {
      widget.onPressed();
    }

    try {
      await widget.onSubmit();
      setState(() {
        _state = SubmitButtonState.success;
      });
      if (widget.onStateChanged != null) {
        widget.onStateChanged(_state);
      }
    } catch (e) {
      setState(() {
        _state = SubmitButtonState.error;
      });
      if (widget.onStateChanged != null) {
        widget.onStateChanged(_state);
      }
    }
  }

  void _onSuccess() {
    setState(() {
      _state = SubmitButtonState.initial;
    });
    if (widget.onStateChanged != null) {
      widget.onStateChanged(_state);
    }
    if (widget.onPressed != null) {
      widget.onPressed();
    }
  }

  void _onError() {
    _onInitial();
  }
}

class _SubmitButton extends StatelessWidget {
  final SubmitButtonState state;
  final VoidCallback onPressed;
  final String label;
  final Color color;
  final Color textColor;

  _SubmitButton({
    @required this.state, 
    @required this.label,  
    @required this.onPressed, 
    this.color, 
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    var child;
    switch (state) {
      case SubmitButtonState.success:
        child = _success(context);
        break;
      case SubmitButtonState.error:
        child = _error(context);
        break;
      case SubmitButtonState.submitting:
        child = _submitting(context);
        break; 
      case SubmitButtonState.initial:     
      default:
        child = _initial(context);
    }
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
          child: child, 
          axis: Axis.horizontal, 
          sizeFactor: animation,
        );
      },
      child: SizedBox(
        key: ValueKey<int>(state.index),
        width: double.infinity,        
        height: 56,
        child: child,
      ),
    );
  }

  RaisedButton _initial(BuildContext context) {
    return RaisedButton(
      color: color != null ? color : Theme.of(context).accentColor,
      textColor: textColor != null ? textColor : Theme.of(context).accentTextTheme.button.color,
      child: CapsText(label), 
      onPressed: onPressed
    );
  }

  RaisedButton _submitting(BuildContext context) {
    return RaisedButton(
      disabledColor: color != null ? color : Colors.grey,
      child: Container(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          backgroundColor: textColor != null ? textColor : Colors.white, 
          valueColor: AlwaysStoppedAnimation<Color>(color != null ? color : Colors.grey),
          strokeWidth: 2,
        ),
      ), 
      onPressed: null
    );
  }

  RaisedButton _success(BuildContext context) {
    return RaisedButton.icon(
      color: color != null ? color : Colors.green,
      textColor: textColor != null ? textColor : Colors.white,
      label: CapsText(label), 
      icon: Icon(Icons.check_circle_outline),
      onPressed: onPressed,
    );
  }

  RaisedButton _error(BuildContext context) {
    return RaisedButton.icon(
      color: color != null ? color : Colors.red,
      textColor: textColor != null ? textColor : Colors.white,
      label: CapsText(label), 
      icon: Icon(Icons.error_outline),
      onPressed: onPressed,
    );
  }
}