import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/todo.dart';
import '../themes/colors.dart';
import '../widgets/todo_item.dart';
import '../screens/add_edit_product.dart';

import '../services/api_urls.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
            id: item['id'] != null ? int.parse(item['id'].toString()) : null,
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
            alDetal:
                item['al_detal'] != null ? item['al_detal'].toDouble() : 0.0,
            detalDivision: item['detal_division'] != null
                ? item['detal_division'].toDouble()
                : 0.0,
            peso: item['peso'] != null ? item['peso'].toDouble() : null,
            unidadesPorCaja: item['unidades_por_caja'] != null
                ? item['unidades_por_caja'] as int
                : null,
            unidadMedida: item['unidad_medida'].toString(),
            precioCompra: item['precio_compra'] != null
                ? item['precio_compra'].toDouble()
                : 0.0,
            codigoDeBarra: item['codigo_de_barra'].toString(),
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
          //Uri.parse('https://api-dev-toprecio.onrender.com/api/v1/inventory/'));
          Uri.parse('${ApiUrls.baseUrl}/inventory/'));

      if (response.statusCode == 200) {
        // Asegúrate de decodificar los datos como UTF-8
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<ToDo> todos = data.map((item) {
          return ToDo(
            id: item['id'] != null ? int.parse(item['id'].toString()) : null,
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
            alDetal:
                item['al_detal'] != null ? item['al_detal'].toDouble() : 0.0,
            detalDivision: item['detal_division'] != null
                ? item['detal_division'].toDouble()
                : 0.0,
            peso: item['peso'] != null ? item['peso'].toDouble() : null,
            unidadesPorCaja: item['unidades_por_caja'] != null
                ? item['unidades_por_caja'] as int
                : null,
            unidadMedida: item['unidad_medida'].toString(),
            precioCompra: item['precio_compra'] != null
                ? item['precio_compra'].toDouble()
                : 0.0,
            codigoDeBarra: item['codigo_de_barra'].toString(),
          );
        }).toList();

        setState(() {
          _foundToDo = todos;
          _allToDo = todos;
          _isLoading = false;
        });

        prefs.setString('todos', json.encode(data));
      } else {
        // Imprime el cuerpo de la respuesta para obtener más detalles sobre el error
        print('Error fetching data: ${response.statusCode} ${response.body}');
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

  void _runFilter(String value) {
    setState(() {
      _foundToDo = _allToDo
          .where((item) =>
              item.codigoDeBarra!.toLowerCase().contains(value.toLowerCase()) ||
              item.todoText!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> _scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancelar', true, ScanMode.DEFAULT);

    if (!mounted) return;

    // Aquí puedes buscar el producto por el código de barras escaneado
    // Por ejemplo, filtrando la lista de productos
    setState(() {
      _foundToDo = _allToDo
          .where((item) => item.codigoDeBarra == barcodeScanRes)
          .toList();
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: tdBlack,
                  size: 20,
                ),
                border: InputBorder.none,
                hintText: 'Buscar....',
                hintStyle: TextStyle(color: tdGrey),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          ),
        ],
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
                      child: RefreshIndicator(
                    onRefresh:
                        _fetchData, // Función que se llamará al pulsar el RefreshIndicator
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
                  ))
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
            Icons.menu_outlined,
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
