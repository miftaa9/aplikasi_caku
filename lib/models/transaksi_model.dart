class TransaksiModel {
  int? id, type, total;
  String? name, createdAt, updatedAt, cat;

  TransaksiModel(
      {this.id,
      this.type,
      this.total,
      this.name,
      this.createdAt,
      this.updatedAt});

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
        id: json['id'],
        type: json['type'],
        total: json['total'],
        name: json['name'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
}
