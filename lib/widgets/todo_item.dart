import 'package:flutter/material.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/themes/colors.dart';
import 'edit_price_modal.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;

  const ToDoItem({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled:
              true, // Habilita el desplazamiento cuando el teclado está activo
          builder: (BuildContext context) {
            return SingleChildScrollView(
              // Añade SingleChildScrollView alrededor del contenido del modal
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: EditPriceModal(todo: todo),
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '${todo.todoText!} ${todo.peso != null ? todo.peso.toString() : ''} ${todo.unidadMedida ?? ''}',
                      style: TextStyle(
                        //fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: tdBlack,
                        decoration:
                            todo.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    TextSpan(
                      text: ' - ( x${todo.unidadesPorCaja ?? ''} )',
                      style: TextStyle(
                        fontSize: 14,
                        //color: Colors.black54,
                        color: Colors.purple,
                        decoration:
                            todo.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    width: 60,
                    decoration: BoxDecoration(
                      color: tdRed,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${todo.price.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: 35,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${todo.divMayor.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: 35,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${todo.alPorMayor.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
