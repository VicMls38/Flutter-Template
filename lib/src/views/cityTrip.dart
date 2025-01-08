import 'package:flutter/material.dart';

class CityTrip extends StatefulWidget {
  const CityTrip({Key? key}) : super(key: key);

  @override
  _CityTripState createState() => _CityTripState();
}

class _CityTripState extends State<CityTrip> {
  bool isFormVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final List<Todo> _todos = [];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  /// Fonction pour calculer la somme totale des prix des cartes
  double _calculateTotalPrice() {
    return _todos.fold(0, (total, todo) => total + (double.tryParse(todo.price) ?? 0.0));
  }

  void _addCard() {
    final name = _nameController.text.trim();
    final price = _priceController.text.trim();
    final date = _dateController.text.trim();

    if (name.isNotEmpty && price.isNotEmpty && date.isNotEmpty) {
      setState(() {
        _todos.add(Todo(name: name, price: price, date: date));
        _nameController.clear();
        _priceController.clear();
        _dateController.clear();
        isFormVisible = false;
      });
    }
  }

  void _editCard(Todo todo) {
    final TextEditingController nameController = TextEditingController(text: todo.name);
    final TextEditingController priceController = TextEditingController(text: todo.price);
    final TextEditingController dateController = TextEditingController(text: todo.date);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  todo.name = nameController.text.trim();
                  todo.price = priceController.text.trim();
                  todo.date = dateController.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCard(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Trip'),
      ),
      body: Column(
        children: [
          // Total Price Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Price: ${_calculateTotalPrice().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4,
                  child: ListTile(
                    title: Text(todo.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: ${todo.price}'),
                        Text('Date: ${todo.date}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editCard(todo),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCard(index),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondRoute(todo: todo),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          if (isFormVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Name',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Price',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Date',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _addCard,
                    child: const Text('Add Card'),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isFormVisible = !isFormVisible;
                  });
                },
                child: Text(isFormVisible ? 'Cancel' : '+'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  final Todo todo;

  const SecondRoute({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.name),
      ),
      body: Center(
        child: Text(
          'Name: ${todo.name}\nPrice: ${todo.price}\nDate: ${todo.date}',
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class Todo {
  String name;
  String price;
  String date;

  Todo({required this.name, required this.price, required this.date});
}
