import 'package:flutter/material.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/themes/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/api_urls.dart';

class EditPriceModal extends StatefulWidget {
  final ToDo todo;

  const EditPriceModal({Key? key, required this.todo}) : super(key: key);

  @override
  _EditPriceModalState createState() => _EditPriceModalState();
}

class _EditPriceModalState extends State<EditPriceModal> {
  late TextEditingController precioCompraController;
  late TextEditingController mayorDivisionController;
  late TextEditingController alPorMayorController;
  late TextEditingController
      unidadesPorCajaController; // Añadido para el ejemplo
  late TextEditingController sumaMayorController = TextEditingController();
  late TextEditingController detalDivisionController = TextEditingController();
  late TextEditingController alDetalController = TextEditingController();
  late TextEditingController nameController = TextEditingController(
      text: widget.todo.todoText); // Nuevo controlador para el nombre
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.todo.todoText);
    precioCompraController =
        TextEditingController(text: widget.todo.precioCompra.toString());
    mayorDivisionController =
        TextEditingController(text: widget.todo.divMayor.toString());
    alPorMayorController =
        TextEditingController(text: widget.todo.alPorMayor.toString());
    unidadesPorCajaController = // Añadido para el ejemplo
        TextEditingController(text: widget.todo.unidadesPorCaja.toString());
    detalDivisionController =
        TextEditingController(text: widget.todo.detalDivision.toString());
    alDetalController =
        TextEditingController(text: widget.todo.alDetal.toString());
    nameController = TextEditingController(text: widget.todo.todoText);

    // Añadir listeners para realizar operaciones aritméticas en tiempo real
    precioCompraController.addListener(updateUdsPorcentajeMayor);
    mayorDivisionController.addListener(updateUdsPorcentajeMayor);
    alPorMayorController.addListener(updateUdsPorcentajeMayor);
    unidadesPorCajaController.addListener(updateUdsPorcentajeMayor);
    sumaMayorController.addListener(sumarCompra);
    detalDivisionController.addListener(updateExpresionMatematica);
    sumaMayorController.addListener(sumarCompra);
  }

  @override
  void dispose() {
    nameController.dispose();
    precioCompraController.dispose();
    mayorDivisionController.dispose();
    alPorMayorController.dispose();
    unidadesPorCajaController.dispose();
    detalDivisionController.dispose();
    alDetalController.dispose();
    sumaMayorController.dispose();
    super.dispose();
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

  Future<void> updatePrice(
      ToDo todo,
      int newUnidadesPorCaja,
      double newPrecioCompra,
      double newDivMayor,
      double newAlPorMayor,
      double newAlDetal,
      double newDetalDivision,
      String newName) async {
    // Asegúrate de que la URL coincida con la ruta que has definido en tu servidor
    //final url = 'http://192.168.0.100:8000/api/v1/update-prices/${todo.id}/';
    final url = '${ApiUrls.baseUrl}/update-prices/${todo.id}/';

    final Map<String, dynamic> data = {
      'products': newName,
      'unidades_por_caja': newUnidadesPorCaja,
      'precio_compra': newPrecioCompra,
      'al_por_mayor': newAlPorMayor, // Cambiado de 'al_detal' a 'al_por_mayor'
      'mayor_division': newDivMayor,
      'al_detal': newAlDetal,
      'detal_division': newDetalDivision,
    };

    // Imprime la solicitud en la consola
    print('URL: $url');
    print('Data: $data');

    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    // Imprime la respuesta en la consola
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      setState(() {
        todo.todoText = newName; // Actualiza el nombre en el objeto ToDo
        todo.unidadesPorCaja = newUnidadesPorCaja;
        todo.price = newPrecioCompra;
        todo.divMayor = newDivMayor;
        todo.alPorMayor = newAlPorMayor;
        todo.alDetal = newAlDetal;
        todo.detalDivision = newDetalDivision;
      });
      // Muestra un SnackBar con el mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Precio Y Nombre actualizado'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Muestra un SnackBar con el mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar precio y nombre'),
          backgroundColor: Colors.red,
        ),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update price');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final String url = '${ApiUrls.baseUrl}/product-delete/$productId/';
    // final String url = 'http://192.168.0.100:8000/api/v1/product-delete/$productId/';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 204) {
      // El producto se eliminó exitosamente
      // Aquí puedes cerrar el modal y actualizar la UI para reflejar que el producto ha sido eliminado
      Navigator.of(context).pop(); // Cierra el modal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Producto eliminado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Hubo un error al eliminar el producto
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el producto'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error deleting product: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Asegura que los elementos estén en los extremos
            children: [
              Expanded(
                child: ListTile(
                  title: RichText(
                    text: TextSpan(
                      text: 'Editar Precio',
                      style: TextStyle(
                        fontSize: 24,
                        color: tdBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment:
                      Alignment.centerRight, // Alinea el botón a la derecha
                  child: Tooltip(
                    message: 'Eliminar',
                    child: IconButton(
                      icon: Icon(Icons.delete,
                          color: Colors.red), // Icono de eliminar
                      onPressed: () async {
                        await deleteProduct(widget.todo.id!);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: GestureDetector(
                    onTap: () {
                      setState(() {
                        // Cambiar a un campo de texto editable al presionar el título
                        _isEditing = true;
                      });
                    },
                    child: _isEditing
                        ? TextFormField(
                            controller: nameController,
                            autofocus: true,
                            onFieldSubmitted: (newValue) {
                              setState(() {
                                // Actualizar el valor del título al enviar el formulario

                                _isEditing = false;
                              });
                            },
                          )
                        : RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.todo.todoText!} ${widget.todo.peso != null ? widget.todo.peso.toString() : ''} ${widget.todo.unidadMedida ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: tdBlack,
                                    decoration: widget.todo.isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                // TextSpan(
                                //   text: ' - ( x${widget.todo.unidadesPorCaja ?? ''} )',
                                //   style: TextStyle(
                                //     fontSize: 14,
                                //     color: Colors.black54,
                                //     decoration: widget.todo.isDone
                                //         ? TextDecoration.lineThrough
                                //         : null,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              // const SizedBox(width: 16.0),
              SizedBox(
                width: 100, // ajusta el ancho según tus necesidades
                child: TextFormField(
                  controller: unidadesPorCajaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
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
                  onChanged: (value) {
                    updateExpresionMatematica();
                    updateUdsPorcentajeMayor();
                    sumarCompra();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese la cantidad de unidades por caja / bulto';
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
                  onChanged: (value) {
                    updateUdsPorcentajeMayor();
                  },
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
                  //keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Suma',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.add),
                    prefixIcon: Icon(Icons.call_missed_outgoing_outlined),
                    prefixText: '\$ ',
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    sumarCompra();
                  },
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
                  //controller: alPorMayorController,
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
                    prefixText: '\$ ', // Agrega el símbolo $ antes del texto
                  ),
                  // enabled: false, // Para evitar que el usuario edite este campo
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    sumarCompra();
                  },
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
                  onChanged: (value) {
                    updateExpresionMatematica();
                  },
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
                  onChanged: (value) {
                    updateExpresionMatematica();
                  },
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
          // const SizedBox(height: 20),
          // TextFormField(
          //   controller: divMayorController,
          //   decoration: InputDecoration(
          //     labelText: 'División Mayor',
          //     border: OutlineInputBorder(),
          //   ),
          //   keyboardType: TextInputType.numberWithOptions(decimal: true),
          // ),
          // SizedBox(height: 10),
          // TextFormField(
          //   controller: alPorMayorController,
          //   decoration: InputDecoration(
          //     labelText: 'Al Por Mayor',
          //     border: OutlineInputBorder(),
          //   ),
          //   keyboardType: TextInputType.numberWithOptions(decimal: true),
          // ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              int newUnidadesPorCaja =
                  int.tryParse(unidadesPorCajaController.text) ?? 0;
              double newPrice =
                  double.tryParse(precioCompraController.text) ?? 0;
              double newDivMayor =
                  double.tryParse(mayorDivisionController.text) ?? 0;
              double newAlPorMayor =
                  double.tryParse(alPorMayorController.text) ?? 0;
              double newAlDetal = double.tryParse(alDetalController.text) ?? 0;
              double newDetalDivision =
                  double.tryParse(detalDivisionController.text) ?? 0;
              String newName = nameController
                  .text; // Asegúrate de obtener el nuevo nombre correctamente
              try {
                await updatePrice(
                    widget.todo,
                    newUnidadesPorCaja,
                    newPrice,
                    newDivMayor,
                    newAlPorMayor,
                    newAlDetal,
                    newDetalDivision,
                    newName);
                Navigator.of(context).pop(); // Cierra el modal
              } catch (e) {
                // Maneja el error, por ejemplo, mostrando un mensaje de error al usuario
                print('Error updating price: $e');
              }
            },
            child: Text('Guardar Cambios'),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
