import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  late String username;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String password;

  @HiveField(3)
  late int createdAt;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  factory User.create({
    required String username,
    required String email,
    required String password,
  }) {
    return User(
      username: username,
      email: email,
      password: password,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
