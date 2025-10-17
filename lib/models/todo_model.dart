// lib/models/todo_model.dart
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Todo extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;
  final bool done;

  const Todo({
    required this.id,
    required this.name,
    required this.createdAt,
    this.done = false,
  });

  /// convenience: create with generated id
  factory Todo.create(String title) => Todo(
        id: const Uuid().v4(),
        name: title,
        createdAt: DateTime.now(),
        done: false,
      );

  Todo copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    bool? done,
  }) {
    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      done: done ?? this.done,
    );
  }

  @override
  List<Object?> get props => [id, name, createdAt, done];
}
