import 'package:flutter/material.dart';

class Todo {
  Todo({required this.name, required this.checked});
  final String name;      //Task
  bool checked;           //Completed or not
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,       //To do list
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  // ignore: prefer_typing_uninitialized_variables
  final onTodoChanged;    //Keep changing depends on if task completed or not

  TextStyle? _getTextStyle(bool checked) {
    if(!checked) return null;

    return const TextStyle(
      color: Colors.black,      //to strike checked items
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      leading: CircleAvatar(
        child: Text(todo.name[0]),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State <TodoList> createState() =>  _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];   //stateful, keep adding tasks to it


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo list'),   //headline of app
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(),   //Add items
          tooltip: 'Add item',
          child: const Icon(Icons.add)),
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });
    _textFieldController.clear();
  }

  Future<void> _displayDialog() async { //Future and asynchronous in flutter
    return showDialog <void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your new todo'),
          ),
          actions: <Widget>[
            TextButton(child: const Text('Add'), onPressed: () {
              Navigator.of(context).pop();
              _addTodoItem(_textFieldController.text);
            },
            ),
          ],
        );
      },
    );
  }
}

class TodoApp extends StatelessWidget{
  const TodoApp({super.key});
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'To do list',
          home:  TodoList(),
        );
      }
  }

void main() => runApp(TodoApp());

