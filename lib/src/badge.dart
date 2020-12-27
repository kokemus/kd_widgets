import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key key,
    this.number,
    this.color,
    this.backgroundColor
  }) : super(key: key);

  final String number;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: number != null ? 16.0 + number.length * 8.0 - 8.0 : 12.0,
      height: number != null ? 16.0 : 12.0,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).accentColor,
        borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      child: number != null ? Center(
        child: Text(
          '$number', 
          style: TextStyle(color: color ?? Colors.white, fontSize: 12.0),
        )
      ): null
    );
  }
}

class WithBadge {
  static BottomNavigationBarItem bottomNavigationBarItem({
    @required Icon icon,
    @required String label,
    Widget activeIcon,
    Color backgroundColor,
    Badge badge,
  }) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          icon,
          Positioned(top: -8, right: -8, child: badge ?? Badge())
        ],
      ), 
      activeIcon: activeIcon ?? icon,
      label: label, 
      backgroundColor: Colors.white
    );
  }

  static Tab tab({
    Key key,
    String text,
    Widget child,
    Widget icon,
    EdgeInsetsGeometry iconMargin,
    Badge badge,
  }) {
    return Tab(
      key: key, 
      text: text, 
      child: child, 
      icon: Stack(
        children: [
          icon,
          Positioned(top: -8, right: -8, child: badge ?? Badge())
        ],
      ), iconMargin: iconMargin,);
  }
}