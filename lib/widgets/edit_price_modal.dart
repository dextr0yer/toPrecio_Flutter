import 'package:flutter/material.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/themes/colors.dart';

class EditPriceModal extends StatefulWidget {
  final ToDo todo;

  const EditPriceModal({Key? key, required this.todo}) : super(key: key);

  @override
  _EditPriceModalState createState() => _EditPriceModalState();
}

class _EditPriceModalState extends State<EditPriceModal> {
  late TextEditingController priceController;
  late TextEditingController divMayorController;
  late TextEditingController alPorMayorController;

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController(text: widget.todo.price.toString());
    divMayorController =
        TextEditingController(text: widget.todo.divMayor.toString());
    alPorMayorController =
        TextEditingController(text: widget.todo.alPorMayor.toString());
  }

  @override
  void dispose() {
    priceController.dispose();
    divMayorController.dispose();
    alPorMayorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: RichText(
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
                  TextSpan(
                    text: ' - ( x${widget.todo.unidadesPorCaja ?? ''} )',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      decoration: widget.todo.isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Precio',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: divMayorController,
            decoration: InputDecoration(
              labelText: 'División Mayor',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: alPorMayorController,
            decoration: InputDecoration(
              labelText: 'Al Por Mayor',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el modal
            },
            child: Text('Guardar Cambios'),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
