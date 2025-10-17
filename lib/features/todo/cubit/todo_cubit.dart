import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/todo_model.dart';

class TodoCubit extends Cubit<List<Todo>> {
  // Should be a List fo Todo
  TodoCubit() : super([]);

  void addTodo(String title) {
    if (title.isEmpty) {
      addError('Title Cannot be empty!');
      return;
    }
    final todo = Todo.create(title.trim());

    // emit new list, which consist of prev list, + a new todo
    emit([...state, todo]);
  }

  // in TodoCubit
  void restore(Todo item, {int? at}) {
    final list = [...state];
    if (at != null && at >= 0 && at <= list.length) {
      list.insert(at, item); // restore at same position
    } else {
      list.add(item); // or append to end
    }
    emit(list);
  }

  // UPDATE — toggle by id
  void toggleDone(String id) {
    final idx = state.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    final updated = state[idx].copyWith(done: !state[idx].done);
    final next = [...state]..[idx] = updated;
    emit(next);
  } // UPDATE — edit title

  void editTitle(String id, String newTitle) {
    if (newTitle.trim().isEmpty) {
      addError('Title cannot be empty!');
      return;
    }
    final idx = state.indexWhere((t) => t.id == id);

    if (idx == -1) return;
    final updated = state[idx].copyWith(name: newTitle.trim());
    log(updated.toString(), name: 'Updated');
    final next = [...state]..[idx] = updated;
    log(next.toString(), name: 'Updated2');

    emit(next);
  }

  // DELETE — by id
  void remove(String id) {
    emit(state.where((t) => t.id != id).toList(growable: false));
  }

  void removeMany(Iterable<String> ids) {
    final idSet = ids.toSet();
    emit(state.where((t) => !idSet.contains(t.id)).toList(growable: false));
  }

  void toggleDoneMany(Iterable<String> ids, {bool? to}) {
    final idSet = ids.toSet();
    final list = state.map((t) {
      if (!idSet.contains(t.id)) return t;
      final nextDone = to ?? !t.done;
      return t.copyWith(done: nextDone);
    }).toList(growable: false);
    emit(list);
  }

  // BULK — clear completed
  void clearCompleted() {
    //“Go through every Todo (t) in the list,
    // and only keep it if t.done is not true.”

    emit(state.where((t) => !t.done).toList(growable: false));
  }

  // Optional: reorder
  void move(int oldIndex, int newIndex) {
    final list = [...state];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    emit(list);
  }

  @override
  void onChange(Change<List<Todo>> change) {
    super.onChange(change);

    log('TodoCubit change: $change');
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    log('TodoCubit - $error');
  }
}
