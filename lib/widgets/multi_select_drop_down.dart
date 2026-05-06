import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MultiSelectDropDown extends StatefulWidget {
  final List<String> items;
  final Function(List<String>) onSelectedChanged;
  const MultiSelectDropDown({
    super.key,
    required this.onSelectedChanged,
    required this.items,
  });

  @override
  State<MultiSelectDropDown> createState() => _MultiSelectDropDownState();
}

class _MultiSelectDropDownState extends State<MultiSelectDropDown> {
  final Set<String> _selectedItems = <String>{};
  final ValueNotifier<String?> _valueListenable = ValueNotifier<String?>(null);

  void _toggleItem(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
    widget.onSelectedChanged(_selectedItems.toList());
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _selectedItems.isEmpty
        ? 'Select Item'
        : _selectedItems.join(', ');

    return Card(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            displayText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: _selectedItems.isEmpty
                  ? Theme.of(context).hintColor
                  : Colors.black,
            ),
          ),
          items: widget.items.map((item) {
            return DropdownItem<String>(
              value: item,
              enabled: false,
              closeOnTap: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = _selectedItems.contains(item);
                  return InkWell(
                    onTap: () {
                      _toggleItem(item);
                      menuSetState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (_) {
                              _toggleItem(item);
                              menuSetState(() {});
                            },
                          ),
                          Expanded(
                            child: Text(
                              item,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          valueListenable: _valueListenable,
          onChanged: (_) {},
          selectedItemBuilder: (context) {
            return widget.items.map((_) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: _selectedItems.isEmpty
                        ? Theme.of(context).hintColor
                        : Colors.black,
                  ),
                ),
              );
            }).toList();
          },
          buttonStyleData: const ButtonStyleData(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.zero,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
