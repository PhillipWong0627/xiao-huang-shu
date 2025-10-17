import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/features/todo/cubit/todo_cubit.dart';
import 'package:social_app/models/todo_model.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final Set<String> _selected = <String>{};

  bool get _isSelecting => _selected.isNotEmpty;

  void _toggleSelect(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() => _selected.clear());
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSelecting
            ? Text('${_selected.length} selected')
            : const Text('Todo List'),
        leading: _isSelecting
            ? IconButton(
                tooltip: 'Cancel selection',
                icon: const Icon(Icons.close),
                onPressed: _clearSelection,
              )
            : null,
        actions: [
          if (_isSelecting)
            IconButton(
              tooltip: 'Delete selected',
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                final removedIds = Set<String>.from(_selected);
                todoCubit.removeMany(removedIds);
                _clearSelection();
                messenger.clearSnackBars();
                messenger.showSnackBar(
                  SnackBar(content: Text('Deleted ${removedIds.length} items')),
                );
              },
            )
          else
            IconButton(
              tooltip: 'Clear all',
              icon: const Icon(Icons.cleaning_services_outlined),
              onPressed: () => todoCubit.clearCompleted(),
            ),
        ],
      ),
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          if (todos.isEmpty) {
            return const Center(child: Text('No todos yet'));
          }

          return SlidableAutoCloseBehavior(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (rowCtx, i) {
                final todo = todos[i];
                final isSelected = _selected.contains(todo.id);

                // Disable slidable while selecting
                final slidableEnabled = !_isSelecting;

                final tile = ListTile(
                  title: Text(todo.name),
                  subtitle: Text(
                    'Created: ${todo.createdAt.toLocal()}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onLongPress: () => _toggleSelect(todo.id),
                  onTap: () {
                    if (_isSelecting) {
                      _toggleSelect(todo.id);
                    } else {
                      // optional: open details page here
                    }
                  },
                  leading: _isSelecting
                      ? Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        )
                      : null,
                  tileColor: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                );

                if (!slidableEnabled) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: tile,
                  );
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Slidable(
                    key: ValueKey(todo.id),
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) async {
                            final newTitle = await showDialog<String>(
                              context: context,
                              builder: (_) =>
                                  _EditTodoDialog(initial: todo.name),
                            );
                            if (newTitle != null &&
                                newTitle.trim().isNotEmpty) {
                              todoCubit.editTitle(todo.id, newTitle.trim());
                            }
                          },
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      dismissible: null,
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            final removed = todo;
                            todoCubit.remove(todo.id);
                            messenger.clearSnackBars();
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text('Deleted "${removed.name}"'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    todoCubit.restore(removed);
                                  },
                                ),
                              ),
                            );
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: tile,
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: _isSelecting
          ? null
          : FloatingActionButton(
              onPressed: () => context.push('/add-todo'),
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
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, ctrl.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
