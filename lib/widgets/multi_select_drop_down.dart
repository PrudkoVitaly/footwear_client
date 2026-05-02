import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

List<String> selectedItems = [];

class MultiSelectDropDown extends StatelessWidget {
  final List<String> items = ['Item1', 'Item2', 'Item3', 'Item4'];
  final Function(List<String>) onSelectedChanged;
  final valueListenable = ValueNotifier<String?>(null);
  MultiSelectDropDown({super.key, required this.onSelectedChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'Select Item',
            style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
          ),
          items: items
              .map(
                (String item) => DropdownItem<String>(
                  value: item,
                  height: 40,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          valueListenable: valueListenable,
          onChanged: (String? value) {
            valueListenable.value = value;
            onSelectedChanged(selectedItems);
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 40,
          ),
        ),
      ),
    );
  }
}
