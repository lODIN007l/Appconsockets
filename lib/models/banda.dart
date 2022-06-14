class Banda {
  String id = '';
  String name = '';
  int votes = 0;
  Banda({required this.id, required this.name, required this.votes});

  factory Banda.fromMap(Map<String, dynamic> obj) =>
      Banda(id: obj['id'], name: obj['name'], votes: obj['votes']);
}
