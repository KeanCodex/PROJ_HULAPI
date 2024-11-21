import 'package:hive/hive.dart';

part 'hiveAccount.g.dart'; 

@HiveType(typeId: 0)
class HiveAccount {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String avatar;

  @HiveField(2)
  int score;

  HiveAccount({required this.name, required this.avatar, required this.score});
}

