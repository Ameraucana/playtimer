import 'package:flutter/material.dart';
import 'package:playtimer/BaseWidget/Selector/DeleteDialog.dart';
import 'package:provider/provider.dart';
import 'package:playtimer/classes/TimedItem.dart';
import 'package:playtimer/classes/UnsavedChangeModel.dart';

class Selector extends StatefulWidget {
  Selector(
      {Key key,
      @required this.items,
      @required this.onSelect,
      @required this.onRemove,
      @required this.disabled})
      : super(key: key);
  final List<TimedItem> items;
  final Function(TimedItem) onSelect;
  final Function(TimedItem) onRemove;
  final bool disabled;

  @override
  _SelectorState createState() => _SelectorState(items);
}

class _SelectorState extends State<Selector> {
  _SelectorState(items)
      : dropdownValue = items[0] ?? TimedItem.yetUnchanged("None", 0);
  TimedItem dropdownValue;

  void pressedRemove(UnsavedChangeModel model) {
    if (widget.items.isNotEmpty) {
      model.madeChange();
      int currentIndex = widget.items.indexOf(dropdownValue);
      if (currentIndex > 0) {
        setState(() => dropdownValue = widget.items[currentIndex - 1]);
        print("selected $dropdownValue");
      } else {
        if (widget.items.length > 1) {
          setState(() => dropdownValue = widget.items[currentIndex + 1]);
        } else {
          return;
        }
      }
      //you must move to another element before deleting
      widget.onRemove(widget.items[currentIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    UnsavedChangeModel unsavedChangeModel = context.watch<UnsavedChangeModel>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<TimedItem>(
            onChanged: !widget.disabled
                ? (TimedItem newValue) {
                    setState(() => dropdownValue = newValue);
                    widget.onSelect(newValue);
                  }
                : null,
            value: dropdownValue,
            items: widget.items
                .where((item) => !item.isMarkedForOmission)
                .map((item) => DropdownMenuItem(
                    child:
                        Text(item.name, style: TextStyle(fontFamily: "Roboto")),
                    value: item))
                .toList()),
        IconButton(
            icon: Icon(Icons.delete_forever_outlined),
            onPressed: !widget.disabled
                ? () => showDialog(
                    context: context,
                    builder: (context) => DeleteDialog(
                          onConfirm: pressedRemove,
                          item: dropdownValue,
                          changeModel: unsavedChangeModel,
                        ))
                : null)
      ],
    );
  }
}
