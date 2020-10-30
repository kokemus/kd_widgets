import 'package:flutter/material.dart';

class Filter {
  final String label;
  final String key;
  bool value;

  Filter(this.label, this.key, this.value);

  @override
  String toString() {
    return "Filter(${key.toString()}: ${value.toString()})";
  }
}

class FilterRow extends StatefulWidget {
  final List<Filter> filters;
  final ValueChanged<List<Filter>> onChanged;
  final bool multipleChoice;
  final bool wrap;
  final Axis direction;
  final WrapAlignment alignment;

  const FilterRow({
    Key key,
    @required this.filters,
    @required this.onChanged,
    this.multipleChoice = true,
    this.wrap = true,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
  }) : super(key: key);

  factory FilterRow.horizontalWrap({
    Key key,
    @required List<Filter> filters,
    @required ValueChanged<List<Filter>> onChanged,
    bool multipleChoice = false}) {
    return FilterRow(
      key: key,
      filters: filters, 
      onChanged: onChanged,
      multipleChoice: multipleChoice,
      direction: Axis.horizontal,
      wrap: true,
    );
  }

  factory FilterRow.horizontalScroll({
    @required List<Filter> filters,
    @required ValueChanged<List<Filter>> onChanged,
    bool multipleChoice = false}) {
    return FilterRow(
      filters: filters, 
      onChanged: onChanged,
      multipleChoice: multipleChoice,
      direction: Axis.horizontal,
      wrap: false,
    );
  }

  @override
  State<StatefulWidget> createState() {    
    return _FilterRowState(filters);
  }
}

class _FilterRowState extends State<FilterRow> {

  _FilterRowState(this._filters);

  List<Filter> _filters;

  @override
  Widget build(BuildContext context) {
    final filtersWidgets = _filters.map((e) => FilterChip(
      label: Text(e.label),
      selected: e.value,
      onSelected: (bool value) {        
        setState(() {
          if (!widget.multipleChoice) {
            _filters.forEach((element) { element.value = false; });
          }          
          _filters.firstWhere((element) => element.key == e.key).value = value;
        });
        widget.onChanged(_filters);
      },
    )).toList();
    if (widget.wrap) { 
      return Wrap(
        spacing: 8,
        runSpacing: 12,
        direction: widget.direction,
        alignment: widget.alignment,
        children: filtersWidgets
      );
    } else {      
      return SingleChildScrollView(
        scrollDirection: widget.direction,
        child: Row(
          children: filtersWidgets.map((e) => Container(margin: EdgeInsets.only(right: 8), child: e)).toList(),
        )
      );
    }
  }
}
