// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/models/ModelProvider.dart';
import 'package:todo_list/todos_repo.dart';

abstract class TodoState {}

class LoadingTodos extends TodoState {}

class ListTodosSuccess extends TodoState {
  final List<Todo> todos;
  ListTodosSuccess({required this.todos});
}

class ListTodosFailure extends TodoState {
  final dynamic exception;
  ListTodosFailure({required this.exception});
}

class TodoCubit extends Cubit<TodoState> {
  final _todoRepo = TodoRepository();
  TodoCubit() : super(LoadingTodos());
  void getTodos() async {
    if (state is ListTodosSuccess == false) {
      emit(LoadingTodos());
    }

    try {
      final todos = await _todoRepo.getTodos();
      emit(ListTodosSuccess(todos: todos));
    } catch (e) {
      emit(ListTodosFailure(exception: e));
    }
  }

  void createTodos(String title) async {
    await _todoRepo.createTodos(title);
    getTodos();
  }

  void updateTodoIsComplete(Todo todo, bool isComplete) async {
    await _todoRepo.updateTodoIsComplete(todo, isComplete);
    getTodos();
  }
}
