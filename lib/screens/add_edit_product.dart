import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/themes/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddEditScreens extends StatefulWidget {
  AddEditScreens({Key? key}) : super(key: key);

  @override
  _AddEditScreensState createState() => _AddEditScreensState();
}

class _AddEditScreensState extends State<AddEditScreens> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Lista de unidades de medida
  final List<String> unidadesMedida = ['kg', 'l', 'ml', 'gr'];
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController unidadesPorCajaController =
      TextEditingController();
  final TextEditingController precioCompraController = TextEditingController();
  final TextEditingController unidadesController = TextEditingController();
  final TextEditingController alDetalController = TextEditingController();
  final TextEditingController alPorMayorController = TextEditingController();

  // Variable para almacenar la unidad de medida seleccionada
  String selectedUnidadMedida = 'kg';
  String itemSelected = 'Categoria';

  List<String> countriesList = [
    'Mavesa',
    'Detergentes',
    'Plasticos',
    'Chucherias',
    'Farmacias',
  ];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Aquí puedes realizar la lógica para enviar los datos al servidor
    final url = 'https://api-toprecio.onrender.com/api/v1/inventory/';
    final response = await http.post(Uri.parse(url), body: {
      'products': nombreController.text,
      'category': itemSelected,
      'peso': pesoController.text,
      'unidad_medida': selectedUnidadMedida,
      'unidades_por_caja': unidadesPorCajaController.text,
      'precio_compra': precioCompraController.text,
      'unidades': unidadesController.text,
      'al_detal': alDetalController.text,
      'al_por_mayor': alPorMayorController.text,
    });

    if (response.statusCode == 200) {
      // Éxito en la solicitud
      // Aquí puedes manejar la respuesta del servidor si es necesario
    } else {
      // Error en la solicitud
      // Manejo del error, como mostrar un mensaje al usuario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: tdBGColor,
        elevation: 0,
        title: const Text(
          'Agregar Producto',
          style: TextStyle(
            color: Colors.black, // Cambia este color según tus preferencias
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.inventory_2_outlined),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese el nombre del producto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.category_outlined),
                  Padding(padding: EdgeInsets.all(9)),
                  Expanded(
                    child: DropdownSearch<String>(
                      items: countriesList,
                      popupProps: PopupProps.menu(showSearchBox: true),
                      dropdownButtonProps:
                          DropdownButtonProps(color: Colors.purple),
                      dropdownBuilder: (_, String? item) => SizedBox(
                        width: 200,
                        child: ListTile(
                          title: Text(item ?? ''),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          itemSelected = value!;
                        });
                      },
                      selectedItem: itemSelected,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: pesoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Peso',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.scale_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese el peso';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  DropdownButton<String>(
                    value: selectedUnidadMedida,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedUnidadMedida = newValue;
                        });
                      }
                    },
                    items: unidadesMedida.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: unidadesPorCajaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Uds. por Caja',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese la cantidad de unidades por caja';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: TextFormField(
                      controller: precioCompraController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Precio Compra',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.local_shipping_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese el precio de compra';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: unidadesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Unidades',
                        border: OutlineInputBorder(),
                        //prefixIcon:Icon(Icons.production_quantity_limits_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese la cantidad de unidades';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: alDetalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Al Detal',
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.monetization_on_outlined)),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese el precio al detal';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: alPorMayorController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Al Por Mayor',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.widgets_outlined)),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese el precio al por mayor';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: _submitForm,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
