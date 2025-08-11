import 'package:hive/hive.dart';

part 'auth_token.g.dart';

@HiveType(typeId: 0)
class AuthToken extends HiveObject {
  @HiveField(0)
  String accessToken;

  AuthToken({required this.accessToken});
}
