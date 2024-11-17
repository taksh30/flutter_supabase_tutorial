import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_tutorial/models/users_model.dart';
import 'package:supabase_tutorial/utils.dart';

class UserDatabase {
  final db = Supabase.instance.client.from(Tables.users.name);

  // add user email to users database
  Future addUserEmail(UsersModel user) async {
    await db.insert(user.toMap());
  }

  // getting user id from users database by current user email
  Future<int> getCurrentUserId(String email) async {
    final response = await db.select('id').eq('email', email).single();

    return response['id'];
  }
}
