import 'package:flutter/material.dart';
import 'package:todoapp/themes/colors.dart';

import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  const ToDoItem({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
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
                  '${todo.price.toStringAsFixed(1)}', // Redondea a 1 decimal
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8), // Agrega un espacio horizontal de 8 píxeles
// Agrega el nuevo Container para "al_por_mayor" aquí
            Container(
              height: 35,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.purple, // Color amarillo
                borderRadius: BorderRadius.circular(5),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${todo.alPorMayor.toStringAsFixed(1)}', // Redondea a 1 decimal
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white, // Texto blanco
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
