import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      title: Text('meals_add_meal'.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedMealType,
            decoration: InputDecoration(
              labelText: 'meals_meal_type'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: ['breakfast', 'lunch', 'dinner', 'snack']
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text('meals_$type'.tr),
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
            title: Text('meals_eaten'.tr),
            subtitle: Text(
              isEaten ? 'meals_mark_eaten'.tr : 'meals_mark_skipped'.tr,
            ),
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
          child: Text('cancel'.tr),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onAdd(selectedMealType, isEaten);
          },
          child: Text('add'.tr),
        ),
      ],
    );
  }
}
