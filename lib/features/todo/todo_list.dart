import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/features/todo/cubit/todo_cubit.dart';
import 'package:social_app/models/todo_model.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            tooltip: 'Clear completed',
            icon: const Icon(Icons.cleaning_services_outlined),
            onPressed: () => context.read<TodoCubit>().clearCompleted(),
          ),
        ],
      ),
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          if (todos.isEmpty) {
            return const Center(child: Text('No todos yet'));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, i) {
              final todo = todos[i];

              return Dismissible(
                key: ValueKey(todo.id),
                background: Container(
                  color: Colors.red.withValues(alpha: 0.85),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red.withValues(alpha: 0.85),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  // keep a copy for undo
                  final removed = todo;
                  context.read<TodoCubit>().remove(todo.id);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deleted "${removed.name}"'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          context.read<TodoCubit>().restore(removed);
                        },
                      ),
                    ),
                  );
                },
                child: CheckboxListTile(
                  value: todo.done,
                  onChanged: (_) =>
                      context.read<TodoCubit>().toggleDone(todo.id),
                  title: Text(
                    todo.name,
                    style: TextStyle(
                      decoration: todo.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  secondary: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () async {
                      final newTitle = await showDialog<String>(
                        context: context,
                        builder: (_) => _EditTodoDialog(initial: todo.name),
                      );
                      if (newTitle != null && newTitle.trim().isNotEmpty) {
                        context
                            .read<TodoCubit>()
                            .editTitle(todo.id, newTitle.trim());
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-todo');
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EditTodoDialog extends StatefulWidget {
  final String initial;
  const _EditTodoDialog({required this.initial});

  @override
  State<_EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<_EditTodoDialog> {
  late final TextEditingController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Todo'),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'New title'),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.pop(context, ctrl.text),
            child: const Text('Save')),
      ],
    );
  }
}
