class Banda {
  String id = '';
  String name = '';
  int votes = 0;
  Banda({required this.id, required this.name, required this.votes});

  factory Banda.fromMap(Map<String, dynamic> obj) => Banda(
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      name: obj.containsKey('name') ? obj['name'] : 'no-name',
      votes: obj.containsKey('votes') ? obj['votes'] : 0);
}
