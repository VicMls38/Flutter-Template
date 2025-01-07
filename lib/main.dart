import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Todo {
  final String title;
  const Todo(this.title);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirstRoute(), // Définit la première route comme point d'entrée
    );
  }
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: const Text('Open route tata'),
            onPressed: () {
              // Naviguer vers la deuxième route
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondRoute(todo: Todo("tata"))),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Open route titi'),
            onPressed: () {
              // Naviguer vers la deuxième route
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondRoute(todo: Todo("titi"))),
              );
            },
          ),
        ],
      )
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Revenir à la première route
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
