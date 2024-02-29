// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/themes/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddEditScreens extends StatefulWidget {
  AddEditScreens({Key? key}) : super(key: key);

  @override
  _AddEditScreensState createState() => _AddEditScreensState();
}

class DollarAmountController extends TextEditingController {
  DollarAmountController({String? text}) : super(text: text);

  @override
  set text(String? newText) {
    // Solo permitir números y el símbolo $
    var filteredText = newText?.replaceAll(RegExp(r'\D'), '');
    super.text = filteredText!;
  }
}

class _AddEditScreensState extends State<AddEditScreens> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> unidadesMedida = ['kg', 'l', 'ml', 'gr'];
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController unidadesPorCajaController =
      TextEditingController();
  // final TextEditingController precioCompraController = TextEditingController();
  final TextEditingController unidadesController = TextEditingController();
  final TextEditingController detalDivisionController = TextEditingController();
  final TextEditingController precioCompraController = TextEditingController();
  final TextEditingController mayorDivisionController = TextEditingController();
  final TextEditingController sumaMayorController = TextEditingController();
  final TextEditingController alDetalController = TextEditingController();
  final TextEditingController alPorMayorController = TextEditingController();

  final TextEditingController codigoDeBarraController = TextEditingController();

  String selectedUnidadMedida = 'kg';
  String itemSelected = 'Categoria';
  List<String> countriesList = [
    'Viveres',
    'Detergentes',
    'Chucherias',
    'Plasticos',
    'Farmacias',
  ];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Llamar a la función para sumar los valores
    sumarCompra();

    //final url = 'http://localhost:8000/api/v1/inventory/';
    //final url = 'https://api-toprecio.onrender.com/api/v1/inventory/';
    //final url = 'https://api-dev-toprecio.onrender.com/api/v1/inventory/';
    final url = 'http://192.168.0.100:8000/api/v1/inventory/';
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
      'detal_division': detalDivisionController.text,
      'mayor_division': mayorDivisionController.text,
      'codigo_de_barra': codigoDeBarraController
          .text, // Enviar el código de barras como una cadena de caracteres
    });
    print(response.body);
    if (response.statusCode == 201) {
      // Éxito en la solicitud
      final snackBar = SnackBar(
        content: Row(
          children: [
            Icon(Icons.check, color: Colors.white), // Ícono de check
            SizedBox(width: 8), // Espacio entre el ícono y el texto
            Text('Producto agregado'),
          ],
        ),
        duration: Duration(seconds: 4),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Limpiar los campos del formulario excepto "nombre" y "categoría"
      pesoController.clear();
      unidadesPorCajaController.clear();
      precioCompraController.clear();
      unidadesController.clear();
      detalDivisionController.clear();

      codigoDeBarraController.clear();

      // // Actualizar el estado para reflejar los cambios en los campos del formulario
      setState(() {});
    } else if (response.statusCode == 400) {
      // El código de barras ya está en uso
      final snackBar = SnackBar(
        content: Text('El código de barras ya está en uso'),
        backgroundColor:
            Colors.amber.withOpacity(0.8), // Color amarillo transparente
        duration: Duration(seconds: 4),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // Error en la solicitud
      final snackBar = SnackBar(
        content: Text('Error al agregar el producto',
            style: TextStyle(color: Colors.white)),
        backgroundColor:
            Colors.red[700]?.withOpacity(0.8), // Color rojo transparente
        duration: Duration(seconds: 4),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _scanQR() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancelar', true, ScanMode.DEFAULT);

    if (!mounted) return;

    setState(() {
      codigoDeBarraController.text = barcodeScanRes;
    });
    // Restablece el color de la barra de navegación después de que la cámara se cierre
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Colors.white, // Color de fondo de la barra de navegación
      systemNavigationBarIconBrightness:
          Brightness.dark, // Color de los iconos de la barra de navegación
    ));
  }

  void updateUdsPorcentajeMayor() {
    if (unidadesPorCajaController.text.isNotEmpty &&
        precioCompraController.text.isNotEmpty) {
      final double? unidadesPorCaja =
          double.tryParse(unidadesPorCajaController.text);
      final double? alPorMayor = double.tryParse(precioCompraController.text);
      if (unidadesPorCaja != null &&
          alPorMayor != null &&
          unidadesPorCaja != 0) {
        double resultadoFinal = alPorMayor;
        try {
          String expresion = sumaMayorController.text.replaceAll(' ', '');
          resultadoFinal += double.parse(expresion);
        } catch (e) {
          // Error al analizar la expresión matemática
          // Puedes manejar el error de alguna manera si lo deseas
        }
        resultadoFinal /= unidadesPorCaja; // Dividir por unidadesPorCaja
        mayorDivisionController.text = resultadoFinal.toStringAsFixed(2);
      }
    }
  }

  void updateExpresionMatematica() {
    // Obtener los valores de Al Detal y Uds. por Caja
    double alDetal = double.tryParse(detalDivisionController.text) ?? 0;
    double unidadesPorCaja =
        double.tryParse(unidadesPorCajaController.text) ?? 1;

    // Realizar la operación de multiplicación
    double resultado = alDetal * unidadesPorCaja;

    // Actualizar el valor del controlador expresionMatematicaController
    alDetalController.text = resultado.toString();
  }

  void sumarCompra() {
    double precioCompra = double.tryParse(precioCompraController.text) ?? 0;
    double sumaMayor = double.tryParse(sumaMayorController.text) ?? 0;

    double resultadoSuma = precioCompra + sumaMayor;
    alPorMayorController.text = resultadoSuma.toString();
    // Actualiza el estado para reflejar los cambios en el campo de texto de resultadoSumaController
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    unidadesPorCajaController.addListener(updateUdsPorcentajeMayor);
    precioCompraController.addListener(updateUdsPorcentajeMayor);
    sumaMayorController.addListener(updateUdsPorcentajeMayor);
    //
    //  Llama a la función sumarValores() cuando se cambia el valor de los controladores relacionados
    precioCompraController.addListener(sumarCompra);
    sumaMayorController.addListener(sumarCompra);
    // Agregar un listener al controlador alDetalController
    detalDivisionController.addListener(updateExpresionMatematica);
  }

  @override
  void dispose() {
    unidadesPorCajaController.removeListener(updateUdsPorcentajeMayor);
    precioCompraController.removeListener(updateUdsPorcentajeMayor);
    sumaMayorController.removeListener(updateUdsPorcentajeMayor);
    // Eliminar el listener cuando el widget se dispose
    detalDivisionController.removeListener(updateExpresionMatematica);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        backgroundColor: tdBGColor,
        elevation: 0,
        title: const Text(
          'Agregar Producto',
          style: TextStyle(
            color: Colors.black,
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'^[A-Z ]+$')), // Solo permite letras mayúsculas y espacios
                ],
                textCapitalization: TextCapitalization
                    .characters, // Bloquea la tecla de mayúscula
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
                    flex: 2,
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
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: unidadesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Pedido',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese la cantidad de pedido';
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
                        labelText: 'Uds. por Caja / Bulto',
                        border: OutlineInputBorder(),
                        // Establecemos el prefixIcon como null para eliminar el ícono de prefijo
                        prefixIcon: null,
                        // Establecemos el prefixText como null para eliminar el prefijo de texto
                        prefixText: null,
                        // Agregamos el carácter "x" como prefijo de texto
                        prefix: Text('x ', style: TextStyle(color: tdBlack)),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'PoColor.fromARGB(255, 122, 105, 105)rese la cantidad de unidades por caja / bulto';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 6,
              //       child: TextFormField(
              //         // controller: precioCompraController,
              //         controller: alPorMayorController,
              //         keyboardType: TextInputType.number,
              //         decoration: InputDecoration(
              //           labelText: 'Resultado Suma',
              //           border: OutlineInputBorder(),
              //           icon: Icon(Icons.local_shipping_outlined),
              //           prefixText:
              //               '\$ ', // Agrega el símbolo $ antes del texto
              //         ),
              //         // enabled: false, // Para evitar que el usuario edite este campo
              //         textInputAction: TextInputAction.next,
              //         validator: (value) {
              //           if (value!.isEmpty) {
              //             return 'Por favor, ingrese Resultado Suma';
              //           }
              //           return null;
              //         },
              //       ),
              //     ),
              //     const SizedBox(width: 16.0),
              //   ],
              // ),
              //const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: precioCompraController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Precio Compra',
                        border: OutlineInputBorder(),
                        // icon: Icon(Icons.monetization_on_outlined),
                        icon: Icon(Icons.local_shipping_outlined),
                        prefixText: '\$ ',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese el precio al por mayor';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: sumaMayorController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Suma',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.add),
                        prefixIcon: Icon(Icons.call_missed_outgoing_outlined),
                        prefixText: '\$ ',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese la suma';
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
                    flex: 4,
                    child: TextFormField(
                      controller: mayorDivisionController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Uds. % Mayor',
                        border: OutlineInputBorder(),
                        //icon: Icon(Icons.add_to_photos_outlined),
                        icon: Icon(Icons.monetization_on_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, Uds. Mayor';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 6,
                    child: TextFormField(
                      // controller: precioCompraController,
                      controller: alPorMayorController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Caja Mayor',
                        icon: Icon(Icons.short_text_sharp),
                        border: OutlineInputBorder(),
                        // icon: Icon(Icons.local_shipping_outlined),
                        prefixText:
                            '\$ ', // Agrega el símbolo $ antes del texto
                      ),
                      // enabled: false, // Para evitar que el usuario edite este campo
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese Resultado Suma';
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
                      controller: detalDivisionController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Al Detal',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.calculate_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese precio al Detal';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: alDetalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Caja Detal',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.short_text_sharp),
                        prefixIcon: Icon(Icons.call_missed_outgoing_outlined),
                        prefixText: '\$ ',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese la suma al detal';
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
                      controller: codigoDeBarraController,
                      keyboardType: TextInputType
                          .number, // Cambiado a TextInputType.number
                      decoration: InputDecoration(
                        labelText: 'Codigo de Barra',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.document_scanner_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, escanee o ingrese el código de barras';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _scanQR,
                    child: Icon(Icons.qr_code_scanner),
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
