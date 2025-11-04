import 'package:flutter/material.dart';

class AddMealDialog extends StatefulWidget {
  final Function(String mealType, bool isEaten) onAdd;
  final String Function(String) capitalizeFirst;

  const AddMealDialog({
    Key? key,
    required this.onAdd,
    required this.capitalizeFirst,
  }) : super(key: key);

  @override
  State<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  String selectedMealType = 'breakfast';
  bool isEaten = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Meal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedMealType,
            decoration: InputDecoration(
              labelText: 'Meal Type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: ['breakfast', 'lunch', 'dinner', 'snack']
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(widget.capitalizeFirst(type)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedMealType = value!;
              });
            },
          ),
          SizedBox(height: 16),
          SwitchListTile(
            title: Text('Eaten'),
            subtitle: Text(isEaten ? 'Mark as eaten' : 'Mark as skipped'),
            value: isEaten,
            onChanged: (value) {
              setState(() {
                isEaten = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onAdd(selectedMealType, isEaten);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
