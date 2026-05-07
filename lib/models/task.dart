class Task {
  int? id;
  String titulo;
  String descricao;
  DateTime dataVencimento;
  bool isImportante;
  bool isConcluido;
  String categoria;

  Task({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    required this.isImportante,
    required this.isConcluido,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'dataVencimento': dataVencimento.toIso8601String(),
      'isImportante': isImportante ? 1 : 0,
      'isConcluido': isConcluido ? 1 : 0,
      'categoria': categoria,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      dataVencimento: DateTime.parse(map['dataVencimento']),
      isImportante: map['isImportante'] == 1,
      isConcluido: map['isConcluido'] == 1,
      categoria: map['categoria'],
    );
  }

  Task copyWith({
    int? id,
    String? titulo,
    String? descricao,
    DateTime? dataVencimento,
    bool? isImportante,
    bool? isConcluido,
    String? categoria,
  }) {
    return Task(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      dataVencimento: dataVencimento ?? this.dataVencimento,
      isImportante: isImportante ?? this.isImportante,
      isConcluido: isConcluido ?? this.isConcluido,
      categoria: categoria ?? this.categoria,
    );
  }
}
