class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  double price;
  double divMayor;
  double alPorMayor;
  String? category;
  int? peso;
  String? unidadMedida;
  int? unidadesPorCaja;
  int? precioCompra;
  int? unidades;
  int? alDetal;
  String? codigoDeBarra;
  double? detalDivision;
  DateTime? createdAt;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    required this.price,
    required this.divMayor,
    required this.alPorMayor,
    this.category,
    this.peso,
    this.unidadMedida,
    this.unidadesPorCaja,
    this.precioCompra,
    this.unidades,
    this.alDetal,
    this.codigoDeBarra,
    this.detalDivision,
    this.createdAt,
  });

  // static List<ToDo> todoList() {
  //   return [
  //     ToDo(
  //         id: '01',
  //         todoText: "HarinaPan Harina precocida de maíz 1kg",
  //         price: 50.0),
  //     ToDo(id: '02', todoText: "Nutresa Salsa de tomate 250g", price: 15.0),
  //     ToDo(id: '03', todoText: "Colanta Queso campesino 450g", price: 32.0),
  //     ToDo(id: '04', todoText: "Café Quindío Café molido 250g", price: 15.0),
  //     ToDo(id: '05', todoText: "Manuelita Panela molida 1kg", price: 40.0),
  //     ToDo(id: '06', todoText: "Frigor Aceite de girasol 900ml", price: 29.0),
  //     ToDo(id: '07', todoText: "Arroz Roa Arroz blanco 1kg", price: 28.0),
  //     ToDo(id: '08', todoText: "La Muñeca Pasta larga 500g", price: 18.0),
  //     ToDo(id: '09', todoText: "María Atún en agua 170g", price: 12.0),
  //     ToDo(id: '10', todoText: "Doria Harina de yuca 500g", price: 22.0),
  //     ToDo(id: '11', todoText: "Zenu Mayonesa 500g", price: 15.0),
  //     ToDo(id: '12', todoText: "Tío Salsa inglesa 220ml", price: 9.0),
  //     ToDo(id: '13', todoText: "Noel Mortadela de pollo 500g", price: 32.0),
  //     ToDo(id: '14', todoText: "Zenú Jamón de pierna 500g", price: 45.0),
  //     ToDo(
  //         id: '15',
  //         todoText: "Bavaria Cerveza Club Colombia 330ml",
  //         price: 8.0),
  //     ToDo(id: '16', todoText: "Colombina Chocolate de mesa 500g", price: 28.0),
  //     ToDo(
  //         id: '17',
  //         todoText: "McCormick Pimienta negra molida 100g",
  //         price: 12.0),
  //     ToDo(
  //         id: '18',
  //         todoText: "Doña Arepa Harina de maíz precocida 500g",
  //         price: 18.0),
  //     ToDo(id: '19', todoText: "Knorr Caldo de costilla 100g", price: 15.0),
  //     ToDo(id: '20', todoText: "La Muñeca Espirales 500g", price: 16.0),
  //     ToDo(
  //         id: '21',
  //         todoText: "Postobón Gaseosa Colombiana 2000ml",
  //         price: 32.0),
  //     ToDo(id: '22', todoText: "Tampico Jugo de mango 950ml", price: 28.0),
  //     ToDo(id: '23', todoText: "Doria Copos de avena 225g", price: 14.0),
  //     ToDo(
  //         id: '24', todoText: "La Constancia Atún en aceite 170g", price: 15.0),
  //     ToDo(id: '25', todoText: "Frubon Salsa rosada 150ml", price: 8.0),
  //     ToDo(
  //         id: '26',
  //         todoText: "Cárnicos Farfan Salchicha premium 500g",
  //         price: 35.0),
  //     ToDo(
  //         id: '27', todoText: "Alimentos Polar Papas fritas 150g", price: 10.0),
  //     ToDo(id: '28', todoText: "Familia Servilletas x 100", price: 15.0),
  //     ToDo(
  //         id: '29', todoText: "Lavatodo Detergente líquido 900ml", price: 25.0),
  //     ToDo(id: '30', todoText: "Colombina Mermelada de mora 280g", price: 12.0),
  //     ToDo(
  //         id: '31',
  //         todoText: "Nevado Desodorante antitranspirante",
  //         price: 18.0),
  //     ToDo(id: '32', todoText: "Protex Jabón antibacterial 135g", price: 9.0),
  //     ToDo(id: '33', todoText: "Seda Champú 400ml", price: 22.0),
  //     ToDo(
  //         id: '34',
  //         todoText: "Nosotras Toallas higiénicas 10 unid",
  //         price: 15.0),
  //     ToDo(id: '35', todoText: "Curadent Cepillo dental suave", price: 8.0),
  //     ToDo(id: '36', todoText: "Menticol Ungüento analgésico 30g", price: 12.0),
  //     ToDo(
  //         id: '37',
  //         todoText: "Bayer Aspirina efervescente 20 unid",
  //         price: 15.0),
  //     ToDo(id: '38', todoText: "Listerine Enjuague bucal 250ml", price: 18.0),
  //     ToDo(
  //         id: '39',
  //         todoText: "Redoxon Vitamina C efervescente 20 unid",
  //         price: 22.0),
  //     ToDo(id: '40', todoText: "Tía Pan rallado 100g", price: 5.0),
  //     ToDo(id: '41', todoText: "Zenú Chorizo español 450g", price: 35.0),
  //     ToDo(id: '42', todoText: "Primor Aceite vegetal 900ml", price: 29.0),
  //     ToDo(id: '43', todoText: "Badia Comino molido 100g", price: 10.0),
  //     ToDo(id: '44', todoText: "Knorr Caldo de pollo 100g", price: 15.0),
  //     ToDo(id: '45', todoText: "Frucos Mayonesa 250g", price: 11.0),
  //     ToDo(id: '46', todoText: "Heinz Salsa de tomate 375g", price: 19.0),
  //     ToDo(id: '47', todoText: "McCormick Mostaza molida 100g", price: 9.0),
  //     ToDo(
  //         id: '48',
  //         todoText: "Doña Arepa Harina de trigo precocida 1kg",
  //         price: 36.0),
  //     ToDo(id: '49', todoText: "Zenú Salchichón de pollo 450g", price: 28.0),
  //     ToDo(id: '50', todoText: "Doria Maicena 500g", price: 12.0),
  //     ToDo(
  //         id: '51',
  //         todoText: "Frigor Aceite de oliva extra virgen 250ml",
  //         price: 32.0),
  //     ToDo(
  //         id: '52',
  //         todoText: "La Constancia Albacora en aceite vegetal 170g",
  //         price: 18.0),
  //     ToDo(id: '53', todoText: "Nutresa Sopa de cebada 100g", price: 15.0),
  //     ToDo(
  //         id: '54',
  //         todoText: "La Constancia Atún blanco al natural 170g",
  //         price: 18.0),
  //     ToDo(id: '55', todoText: "Postobón Jugo Hit 950ml", price: 26.0),
  //     ToDo(
  //         id: '56', todoText: "Ducales Galletas de vainilla 300g", price: 20.0),
  //     ToDo(id: '57', todoText: "Nutresa Salsa de tomate 250g", price: 15.0),
  //     ToDo(id: '58', todoText: "Zenú Longaniza de pollo 450g", price: 30.0),
  //     ToDo(id: '59', todoText: "La Muñeca Spagetti 500g", price: 15.0),
  //     ToDo(id: '60', todoText: "Postobón Manzana Postobón 2000ml", price: 32.0),
  //     ToDo(
  //         id: '61',
  //         todoText: "La Constancia Mermelada light 280g",
  //         price: 13.0),
  //     ToDo(id: '62', todoText: "McCormick Albahaca 12g", price: 6.0),
  //     ToDo(id: '63', todoText: "Arroz Roa Arroz integral 500g", price: 25.0),
  //     ToDo(id: '64', todoText: "Zenú Pate de pollo 450g", price: 28.0),
  //     ToDo(
  //         id: '65',
  //         todoText: "Doña Arepa Harina de maíz amarillo 500g",
  //         price: 19.0),
  //     ToDo(
  //         id: '66',
  //         todoText: "Doria Mix de frutos secos con pasas 500g",
  //         price: 30.0),
  //     ToDo(
  //         id: '67',
  //         todoText: "Margarita Yogur bebible durazno 100g",
  //         price: 7.0),
  //     ToDo(id: '68', todoText: "Colanta Queso campasino 500g", price: 8.4),
  //     ToDo(id: '69', todoText: "Azucar Montalban 1Kg", price: 4.900),
  //   ];
  //}
}
