import 'package:flutter/material.dart';
import 'package:todoapp/themes/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddEditScreens extends StatefulWidget {
  AddEditScreens({super.key});

  @override
  State<AddEditScreens> createState() => _AddEditScreensState();
}

class _AddEditScreensState extends State<AddEditScreens> {
  // Lista de unidades de medida
  final List<String> unidadesMedida = ['kg', 'l', 'ml', 'gr'];

  final TextEditingController unidadesController =
      TextEditingController(text: 'x ');

  // Variable para almacenar la unidad de medida seleccionada
  late String selectedUnidadMedida = 'kg';

  List<String> countriesList = [
    'Mavesa',
    'Detergentes',
    'Plasticos',
    'Chucherias',
    'Farmacias',
  ];

  String itemSelected = 'Categoria';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tdRed,
        elevation: 0,
        title: const Text(
          'Agregar Producto',
          style: TextStyle(
            color: Colors.white, // Cambia este color según tus preferencias
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                icon: Icon(Icons.inventory_2_outlined),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                ),
                Padding(padding: EdgeInsets.all(9)), // Icon on the left
                Expanded(
                  child: DropdownSearch<String>(
                    items: countriesList,
                    popupProps: PopupProps.menu(showSearchBox: true),
                    dropdownButtonProps:
                        DropdownButtonProps(color: Colors.purple),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      textAlignVertical: TextAlignVertical.center,
                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        // Adjust padding as needed to align with the icon
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        itemSelected = value.toString();
                      });
                    },
                    selectedItem: itemSelected,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Peso',
                      border: OutlineInputBorder(),
                      icon: const Icon(Icons.scale_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 16.0),
                DropdownButton<String>(
                  value: selectedUnidadMedida,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedUnidadMedida = newValue;
                    }
                  },
                  items: unidadesMedida
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Uds. por Caja',
                      border: OutlineInputBorder(),
                    ),
                    controller: unidadesController,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Expanded(
                  flex: 6, // 70% del espacio
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Precio Compra',
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.local_shipping_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(width: 16.0), // Espacio entre los dos TextFields
                Expanded(
                  flex: 4, // 30% del espacio
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Unidades',
                      border: OutlineInputBorder(),
                      //prefixIcon:Icon(Icons.production_quantity_limits_outlined),
                    ),
                    // Asegúrate de tener el controlador adecuado
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Al Detal',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.monetization_on_outlined)),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Al Por Mayor',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.widgets_outlined)),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              // height: MediaQuery.of(context).size.height * 0.5,
              child: FilledButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Text("Agregar"),
                  ],
                ),
                onPressed: () {},
              ),

              ///
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
