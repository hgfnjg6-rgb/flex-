import 'dart:convert';

class CycleEntry {
  String id;
  String userId;
  DateTime date;
  int dayOfCycle;
  String flow; // none/light/medium/heavy
  List<String> symptoms;
  String? mood;
  String? notes;
  DateTime createdAt;

  CycleEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.dayOfCycle,
    this.flow = 'none',
    List<String>? symptoms,
    this.mood,
    this.notes,
    DateTime? createdAt,
  }) : symptoms = symptoms ?? [],
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date.toIso8601String(),
    'dayOfCycle': dayOfCycle,
    'flow': flow,
    'symptoms': symptoms,
    'mood': mood,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CycleEntry.fromJson(Map<String, dynamic> json) => CycleEntry(
    id: json['id'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
    dayOfCycle: json['dayOfCycle'],
    flow: json['flow'] ?? 'none',
    symptoms: List<String>.from(json['symptoms'] ?? []),
    mood: json['mood'],
    notes: json['notes'],
    createdAt: DateTime.parse(
      json['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
  );

  String toRawJson() => json.encode(toJson());

  factory CycleEntry.fromRawJson(String str) =>
      CycleEntry.fromJson(json.decode(str));
}
