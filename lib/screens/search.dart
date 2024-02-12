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
  bool _isLoading = false;
  bool _isMounted = false; // Add this line

  @override
  void initState() {
    _isMounted = true; // Add this line
    _fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _isMounted = false; // Add this line
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (!_isMounted) return; // Add this check
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      if (prefs.containsKey('todos')) {
        String jsonString = prefs.getString('todos')!;
        List<dynamic> data = json.decode(jsonString);
        List<ToDo> todos = data.map((item) {
          return ToDo(
            id: item['id'].toString(),
            todoText: item['products'],
            price: item['detal_division'] != null
                ? item['detal_division'].toDouble()
                : 0.0,
            divMayor: item['mayor_division'] != null
                ? item['mayor_division'].toDouble()
                : 0.0,
            alPorMayor: item['al_por_mayor'] != null
                ? item['al_por_mayor'].toDouble()
                : 0.0,
            peso: item['peso'] != null ? item['peso'] as int : null,
            unidadesPorCaja: item['unidades_por_caja'] != null
                ? item['unidades_por_caja'] as int
                : null,
            unidadMedida: item['unidad_medida'].toString(),
          );
        }).toList();

        setState(() {
          _foundToDo = todos;
          _allToDo = todos;
          _isLoading = false;
        });
      }

      final response = await http.get(
          //Uri.parse('https://api-toprecio.onrender.com/api/v1/inventory/'));
          Uri.parse('https://api-dev-toprecio.onrender.com/api/v1/inventory/'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ToDo> todos = data.map((item) {
          return ToDo(
            id: item['id'].toString(),
            todoText: item['products'],
            price: item['detal_division'] != null
                ? item['detal_division'].toDouble()
                : 0.0,
            divMayor: item['mayor_division'] != null
                ? item['mayor_division'].toDouble()
                : 0.0,
            alPorMayor: item['al_por_mayor'] != null
                ? item['al_por_mayor'].toDouble()
                : 0.0,
            peso: item['peso'] != null ? item['peso'] as int : null,
            unidadesPorCaja: item['unidades_por_caja'] != null
                ? item['unidades_por_caja'] as int
                : null,
            unidadMedida: item['unidad_medida'].toString(),
          );
        }).toList();

        setState(() {
          _foundToDo = todos;
          _allToDo = todos;
          _isLoading = false;
        });

        prefs.setString('todos', json.encode(data));
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      if (!_isMounted) return; // Add this check
      // Handle the exception
      // Manejar la excepción
      print('Error fetching data: $e');
      // Puedes mostrar un mensaje de error al usuario o tomar otra acción apropiada aquí
      setState(() {
        _isLoading = false;
      });
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
          hintText: 'Buscar....',
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
