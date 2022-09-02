import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/loading_view.dart';
import 'package:todo_list/models/Todo.dart';
import 'package:todo_list/todos_cubit.dart';

class TodosView extends StatefulWidget {
  const TodosView({super.key});

  @override
  State<TodosView> createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  final _titlecontoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _navBar(),
        floatingActionButton: _floatingActionButton(),
        body: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) {
            if (state is ListTodosSuccess) {
              return state.todos.isEmpty
                  ? _emptyTodosView()
                  : _todoListView(state.todos);
            } else if (state is ListTodosFailure) {
              return _exceptionView(state.exception);
            } else {
              return const LoadingView();
            }
          },
        ));
  }

  Widget _exceptionView(Exception exception) {
    return Center(
      child: Text(exception.toString()),
    );
  }

  AppBar _navBar() {
    return AppBar(
      title: const Text('Todos'),
    );
  }

  Widget _newTodoView() {
    return Column(
      children: [
        TextField(
          controller: _titlecontoller,
          decoration: const InputDecoration(hintText: 'Enter todo title'),
        ),
        ElevatedButton(
            onPressed: () {
              BlocProvider.of<TodoCubit>(context)
                  .createTodos(_titlecontoller.text);
              _titlecontoller.text = '';
              Navigator.of(context).pop();
            },
            child: const Text('Save Todo'))
      ],
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context, builder: (context) => _newTodoView());
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _emptyTodosView() {
    return const Center(
      child: Text('No Todos yet'),
    );
  }

  Widget _todoListView(List<Todo> todos) {
    return ListView.builder(
        itemCount: todos.length,
        itemBuilder: ((context, index) {
          final todo = todos[index];
          return Card(
              child: CheckboxListTile(
                  title: Text(todo.title),
                  value: todo.isComplet,
                  onChanged: (newValue) {
                    BlocProvider.of<TodoCubit>(context)
                        .updateTodoIsComplete(todo, newValue!);
                  }));
        }));
  }
}
