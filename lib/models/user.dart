import 'dart:convert';

class UserSettings {
  int cycleLength;
  int periodLength;
  Map<String, dynamic> notificationPrefs;

  UserSettings({
    required this.cycleLength,
    required this.periodLength,
    Map<String, dynamic>? notificationPrefs,
  }) : notificationPrefs = notificationPrefs ?? {};

  Map<String, dynamic> toJson() => {
    'cycleLength': cycleLength,
    'periodLength': periodLength,
    'notificationPrefs': notificationPrefs,
  };

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
    cycleLength: json['cycleLength'] ?? 28,
    periodLength: json['periodLength'] ?? 5,
    notificationPrefs: Map<String, dynamic>.from(
      json['notificationPrefs'] ?? {},
    ),
  );
}

class User {
  String id;
  String? name;
  String? email;
  String? phone;
  String locale;
  DateTime createdAt;
  UserSettings settings;

  User({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.locale = 'ar',
    DateTime? createdAt,
    UserSettings? settings,
  }) : createdAt = createdAt ?? DateTime.now(),
       settings = settings ?? UserSettings(cycleLength: 28, periodLength: 5);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'locale': locale,
    'createdAt': createdAt.toIso8601String(),
    'settings': settings.toJson(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    locale: json['locale'] ?? 'ar',
    createdAt: DateTime.parse(
      json['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
    settings: UserSettings.fromJson(
      Map<String, dynamic>.from(json['settings'] ?? {}),
    ),
  );

  String toRawJson() => json.encode(toJson());

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
}
