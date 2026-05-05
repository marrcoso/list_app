class Task {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  bool isImportant;
  bool isDone;
  String category;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isImportant,
    required this.isDone,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': title,
      'descricao': description,
      'dataVencimento': dueDate.toIso8601String(),
      'isImportante': isImportant ? 1 : 0,
      'isConcluido': isDone ? 1 : 0,
      'categoria': category,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['titulo'],
      description: map['descricao'],
      dueDate: DateTime.parse(map['dataVencimento']),
      isImportant: map['isImportante'] == 1,
      isDone: map['isConcluido'] == 1,
      category: map['categoria'],
    );
  }
}
