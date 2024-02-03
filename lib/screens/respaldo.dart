import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/themes/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddEditScreens extends StatefulWidget {
  AddEditScreens({Key? key}) : super(key: key);

  @override
  State<AddEditScreens> createState() => _AddEditScreensState();
}

class _AddEditScreensState extends State<AddEditScreens> {
  final List<String> unidadesMedida = ['kg', 'l', 'ml', 'gr'];
  final TextEditingController unidadesController =
      TextEditingController(text: 'x ');
  late String selectedUnidadMedida = 'kg';
  List<String> countriesList = [
    'Mavesa',
    'Detergentes',
    'Plasticos',
    'Chucherias',
    'Farmacias'
  ];
  String itemSelected = 'Categoria';
  TextEditingController nombreController = TextEditingController();
  TextEditingController precioCompraController = TextEditingController();

  Future<void> _guardarProducto() async {
    String nombre = nombreController.text;
    String precioCompra = precioCompraController.text;

    // Aquí construyes el objeto JSON con los datos que quieres enviar
    var data = {
      'products': nombre,
      'value': int.parse(
          precioCompra), // Asegúrate de convertir el precio a entero si es necesario
    };

    var url = Uri.parse('https://api-toprecio.onrender.com/api/v1/inventory/');

    // Enviar la solicitud POST
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    // Comprobar el estado de la respuesta
    if (response.statusCode == 201) {
      // Si la solicitud es exitosa, puedes procesar la respuesta aquí
      print('Producto guardado exitosamente');
    } else {
      // Si la solicitud falla, muestra el código de estado
      print(
          'Fallo al guardar el producto. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tdRed,
        elevation: 0,
        title: const Text(
          'Agregar Producto',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                icon: Icon(Icons.inventory_2_outlined),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: precioCompraController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Precio Compra',
                border: OutlineInputBorder(),
                icon: Icon(Icons.local_shipping_outlined),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: _guardarProducto,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Text("Agregar"),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
