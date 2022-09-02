import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/loading_view.dart';
import 'package:todo_list/todos_cubit.dart';
import 'package:todo_list/todos_view.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => TodoCubit()..getTodos(),
      child: _amplifyConfigured ? const TodosView() : const LoadingView(),
    ));
  }

  void _configureAmplify() async {
    await Amplify.addPlugin(
        AmplifyDataStore(modelProvider: ModelProvider.instance));

    try {
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print(e);
    }
    setState(() {
      _amplifyConfigured = true;
    });
  }
}
