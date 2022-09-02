import 'package:amplify_flutter/amplify_flutter.dart';

import 'models/Todo.dart';

class TodoRepository {
  Future<List<Todo>> getTodos() async {
    try {
      final todos = await Amplify.DataStore.query(Todo.classType);
      return todos;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTodos(String title) async {
    final newTodo = Todo(title: title, isComplet: false);
    try {
      await Amplify.DataStore.save(newTodo);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTodoIsComplete(Todo todo, bool isComplete) async {
    final updateTodo = todo.copyWith(isComplet: isComplete);
    try {
      await Amplify.DataStore.save(updateTodo);
    } catch (e) {
      rethrow;
    }
  }
}
