import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:playtimer/classes/UnsavedChangeModel.dart';

class Numeral extends StatefulWidget {
  Numeral({
    Key key,
    this.style,
    @required this.time,
    @required this.secondsInUnit,
    @required this.onChanged
  }) : super(key: key);
  final TextStyle style;
  final int time,
            secondsInUnit;
  final void Function(int) onChanged;

  @override
  _NumeralState createState() => _NumeralState();
}

class _NumeralState extends State<Numeral> {
  bool _amEditing = false;
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() { 
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _amEditing = false);
      }
    });
  }

  void setTime(UnsavedChangeModel model) {
    if (_controller.text.isEmpty) {
      _controller.text = widget.time.toString();
    }
    if (widget.time != int.parse(_controller.text)) {
      model.madeChange();
    }
    int diff = int.parse(_controller.text) * widget.secondsInUnit
      - widget.time * widget.secondsInUnit;
    widget.onChanged(diff);
    setState(() {
      _amEditing = false;
      _controller.text = "";
    });
  }
  
  @override
  Widget build(BuildContext context) {
    UnsavedChangeModel unsavedChangeModel = context.watch<UnsavedChangeModel>();
    if (_amEditing) {
      _controller = TextEditingController(text: widget.time.toString().padLeft(2, "0"));
      _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      _focusNode.requestFocus();
      return SizedBox(
        height: 100,
        width: 150,
        child: TextField(
          autofocus: true,
          focusNode: _focusNode,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: _controller,
          onEditingComplete: () => setTime(unsavedChangeModel),
          style: widget.style,
        ),
      );
    } else {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => setState(() => _amEditing = true),
          child: Text(widget.time.toString().padLeft(2, "0"), style: widget.style),
        ),
      );
    }
  }
  @override
  void dispose() { 
    _focusNode?.dispose();
    _controller?.dispose();
    super.dispose();
  }
}