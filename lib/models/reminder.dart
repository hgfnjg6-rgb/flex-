import 'dart:convert';

class Reminder {
  String id;
  String userId;
  String type; // period/ovulation/med
  String time; // HH:mm
  bool enabled;
  String repeat; // daily/once

  Reminder({
    required this.id,
    required this.userId,
    required this.type,
    required this.time,
    this.enabled = true,
    this.repeat = 'once',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'type': type,
    'time': time,
    'enabled': enabled,
    'repeat': repeat,
  };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
    id: json['id'],
    userId: json['userId'],
    type: json['type'],
    time: json['time'],
    enabled: json['enabled'] ?? true,
    repeat: json['repeat'] ?? 'once',
  );

  String toRawJson() => json.encode(toJson());

  factory Reminder.fromRawJson(String str) =>
      Reminder.fromJson(json.decode(str));
}
