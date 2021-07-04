import 'package:flutter/material.dart';



class ResourceFilterChip extends StatelessWidget {
  final Map<int, String> resourceFilter;
  ResourceFilterChip(this.resourceFilter);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: resourceFilter.entries.map((c) {
        return SingleFilterChip(c.key, c.value);
      }).toList(),
    );
  }
}

class SingleFilterChip extends StatefulWidget {

  @override
  _SingleFilterChipState createState() => _SingleFilterChipState();
}

class _SingleFilterChipState extends State<SingleFilterChip> {

  bool val = false;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
  label: Text(_choices[index]),
  selected: _choiceIndex == index,
  selectedColor: Colors.red,
  onSelected: (bool selected) {
    setState(() {
      _choiceIndex = selected ? index : 0;
    });
  },
  backgroundColor: Colors.green,
  labelStyle: TextStyle(color: Colors.white),
);
  }
}
