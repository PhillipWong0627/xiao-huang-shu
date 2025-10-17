// lib/features/todo/view/add_todo_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/todo/cubit/todo_cubit.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final todoTitleController = TextEditingController();

  @override
  void dispose() {
    todoTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TodoCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text('Add Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: todoTitleController,
              decoration: const InputDecoration(hintText: 'Title'),
              onSubmitted: (_) => _submit(cubit),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _submit(cubit),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(TodoCubit cubit) {
    cubit.addTodo(todoTitleController.text.trim());
    if (todoTitleController.text.trim().isNotEmpty) {
      Navigator.pop(context);
    }
  }
}
