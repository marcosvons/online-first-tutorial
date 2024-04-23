import 'package:flutter/material.dart';

class ToDoDialog extends StatefulWidget {
  const ToDoDialog({
    required this.onPressed,
    this.initialValue,
    super.key,
  });

  final String? initialValue;
  final void Function(String title) onPressed;

  @override
  State<ToDoDialog> createState() => _ToDoDialogState();
}

class _ToDoDialogState extends State<ToDoDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialValue != null ? 'Edit ToDo' : 'Add ToDo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(hintText: 'ToDo'),
            controller: TextEditingController(text: widget.initialValue),
            onChanged: (value) => controller.text = value,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => widget.onPressed(controller.text),
            child: Text(widget.initialValue != null ? 'Edit' : 'Add'),
          ),
        ],
      ),
    );
  }
}
