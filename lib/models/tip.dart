import 'dart:convert';

class Tip {
  String id;
  String titleAr;
  String bodyAr;
  String titleEn;
  String bodyEn;
  String category;
  DateTime createdAt;

  Tip({
    required this.id,
    required this.titleAr,
    required this.bodyAr,
    required this.titleEn,
    required this.bodyEn,
    this.category = 'general',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title_ar': titleAr,
    'body_ar': bodyAr,
    'title_en': titleEn,
    'body_en': bodyEn,
    'category': category,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Tip.fromJson(Map<String, dynamic> json) => Tip(
    id: json['id'],
    titleAr: json['title_ar'] ?? '',
    bodyAr: json['body_ar'] ?? '',
    titleEn: json['title_en'] ?? '',
    bodyEn: json['body_en'] ?? '',
    category: json['category'] ?? 'general',
    createdAt: DateTime.parse(
      json['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
  );

  String toRawJson() => json.encode(toJson());

  factory Tip.fromRawJson(String str) => Tip.fromJson(json.decode(str));
}
