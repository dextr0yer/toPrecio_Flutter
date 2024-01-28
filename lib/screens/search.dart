import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/todo.dart';
import '../themes/colors.dart';
import '../widgets/todo_item.dart';
import '../screens/add_edit_product.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<ToDo> _foundToDo = [];
  List<ToDo> _allToDo = [];

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('todos')) {
      // Si hay datos guardados localmente, los recuperamos
      String jsonString = prefs.getString('todos')!;
      List<dynamic> data = json.decode(jsonString);
      List<ToDo> todos = data.map((item) {
        return ToDo(
          id: item['id'].toString(),
          todoText: item['products'],
          price: item['value'].toDouble(),
        );
      }).toList();

      if (mounted) {
        // Verifica si el widget está montado antes de actualizar el estado
        setState(() {
          _foundToDo = todos;
          _allToDo = todos;
        });
      }
    }

    final response = await http
        .get(Uri.parse('https://api-toprecio.onrender.com/api/v1/inventory/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<ToDo> todos = data.map((item) {
        return ToDo(
          id: item['id'].toString(),
          todoText: item['products'],
          price: item['value'].toDouble(),
        );
      }).toList();

      if (mounted) {
        // Verifica si el widget está montado antes de actualizar el estado
        setState(() {
          _foundToDo = todos;
          _allToDo = todos;
        });
      }

      // Guardamos los datos localmente
      prefs.setString('todos', json.encode(data));
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      if (enteredKeyword.isNotEmpty) {
        _foundToDo = _allToDo
            .where((item) => item.todoText!
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      } else {
        _foundToDo = List.from(_allToDo);
      }
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Buscar...',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            searchBox(),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 20),
                    child: const Text('Lista Precios',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  for (ToDo todo in _foundToDo)
                    ToDoItem(
                      todo: todo,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditScreens()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: tdBGColor,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.arrow_back,
            color: tdBlack,
            size: 30,
          ),
          const Text('Nelly Martinez',
              style: TextStyle(fontSize: 20, color: Colors.black)),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.jpg'),
            ),
          ),
        ],
      ),
      backgroundColor: tdBGColor,
      elevation: 0,
    );
  }
}
