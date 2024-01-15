class ToDo{
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return  [
      ToDo(id: '01', todoText: "Harina Pan"),
      ToDo(id: '02', todoText: "Jabon Polvo"), //isDone: true
      ToDo(id: '03', todoText: "Azucar"),
      ToDo(id: '04', todoText: "Arroz"),
      ToDo(id: '05', todoText: "Sal"),
      ToDo(id: '06', todoText: "Lentejas"),
      ToDo(id: '07', todoText: "Salsa De Tomate"),
      ToDo(id: '08', todoText: "Pasta Tornillo"),
      ToDo(id: '09', todoText: "Leche Campesina"),
      ToDo(id: '10', todoText: "Galletas"),
      ToDo(id: '11', todoText: "Pañales"),
      ToDo(id: '12', todoText: "Listerine"),
      ToDo(id: '13', todoText: "Crema Dientes"),
      ToDo(id: '14', todoText: "Aceite"),
      ToDo(id: '15', todoText: "Induleche 360"),
      ToDo(id: '16', todoText: "Mayonesa Mavesa"),
      ToDo(id: '17', todoText: "Mayonesa Ideal"),
      ToDo(id: '18', todoText: "Mayonesa Natucampo"),
    ];
  }
}