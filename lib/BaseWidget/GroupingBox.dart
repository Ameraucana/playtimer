import "package:flutter/material.dart";

class GroupingBox extends StatelessWidget {
  GroupingBox({
    @required this.children, 
    this.direction = Axis.vertical,
  });
  final List<Widget> children;
  final Axis direction;

  @override
  Widget build(context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[900]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          direction: direction,
          children: children
        )
      ),
    );
  }
}