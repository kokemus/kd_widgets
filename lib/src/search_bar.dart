import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {

  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onQueryChanged;
  final Function onVoiceInput;
  final Function onClose;
  final String queryHint;
  final initialState;

  const SearchBar({
    Key key,
    this.onQueryChanged,
    this.onSubmitted,
    this.onVoiceInput,
    this.queryHint = 'Search',
    this.initialState = SearchBarState.unfocus,
    this.onClose
  }) : super(key: key);

  factory SearchBar.expandable({
    Key key,
    ValueChanged<String> onQueryChanged,
    ValueChanged<String> onSubmitted,
    Function onVoiceInput,
    String queryHint,
    @required Function onClose,
  }) {
    return SearchBar(
      key: key,
      onQueryChanged: onQueryChanged,
      onSubmitted: onSubmitted,
      onVoiceInput: onVoiceInput,
      onClose: onClose,
      queryHint: queryHint,
      initialState: SearchBarState.focus,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _SearchBarState(initialState);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

enum SearchBarState {
  unfocus,
  focus,
  active
}

class _SearchBarState extends State<SearchBar> {

  var _state = SearchBarState.unfocus;
  var _textFieldFocus = FocusNode();
  var _controller = TextEditingController();

  _SearchBarState(this._state);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(_state == SearchBarState.unfocus ? Icons.search : Icons.arrow_back), 
        color: Colors.black, 
        onPressed: () { 
          setState(() {
            if (_state == SearchBarState.unfocus) {
              _state = SearchBarState.focus;
              _textFieldFocus.requestFocus();
            } else {
              _controller.clear();
              _state = SearchBarState.unfocus;
              _textFieldFocus.unfocus();
              if (widget.onClose != null) {
                widget.onClose();
              }
            }
          });
         },
      ),
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      title: TextField(
        controller: _controller,
        focusNode: _textFieldFocus,
        decoration: InputDecoration(
          hintText: widget.queryHint, 
          border: InputBorder.none
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        onTap: () {
          setState(() {
            _state = SearchBarState.focus;
          });
        },
        onChanged: (value) {
          if (value.length > 0) {
            setState(() {
              _state = SearchBarState.active;
            });
          }
          if (widget.onQueryChanged != null) {
            widget.onQueryChanged(value);
          }
        },
        onSubmitted: widget.onSubmitted,
      ),
      actions: [        
        if (_state == SearchBarState.active || _controller.text.length > 0) 
          IconButton(
            icon: Icon(Icons.clear), 
            color: Colors.black, 
            onPressed: () {
                _controller.clear();
                if (widget.onQueryChanged != null) {
                  widget.onQueryChanged('');
                }
                setState(() {
                  _state = SearchBarState.focus;
                });
            },
          ),
        if (_state == SearchBarState.unfocus && widget.onVoiceInput != null)
          IconButton(
            icon: Icon(Icons.mic),
            color: Colors.black, 
            onPressed: widget.onVoiceInput,
          ),
      ],
    );
  }
}