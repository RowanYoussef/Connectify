import 'package:Connectify/core/user.dart';
import 'package:Connectify/db/dbSingleton.dart';
import 'package:Connectify/db/userProvider.dart';
import 'package:Connectify/requests/authentication_api.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class UserAuthentication {
  static Future<void> startup(VoidCallback go_signup, VoidCallback go_home,
      VoidCallback go_login) async {
    Dbsingleton dbsingleton = Dbsingleton();
    Database? db = await dbsingleton.db;
    User? loggedUser = await UserProvider.getLoggedUser(db!);
    if (loggedUser != null) {
      AuthAPI api = AuthAPI();
      print(loggedUser.token);
      bool success = await api.opensession(loggedUser.token!);
      if (success) {
        go_home();
      } else {
        loggedUser.logged = 0;
        UserProvider.update(loggedUser, db);
        go_login();
      }
    } else {
      go_signup();
    }
  }

  static Future<void> sign_up(
      BuildContext ctx, String email, String phone) async {
    AuthAPI api = AuthAPI();

    bool success = await api.signup(email, phone);
    if (success) {
      User user = User(email, phone);
      Navigator.of(ctx).pushNamed('/Auth',
          arguments: [user, resend_code, sign_up_check_code]);
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('User already exists. Please try logging in.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  static Future<void> resend_code(User user) async {
    String? email = user.email;
    AuthAPI api = AuthAPI();
    await api.resend(email!);
  }

  static Future<bool> sign_up_check_code(
      BuildContext ctx, User user, String code) async {
    AuthAPI api = AuthAPI();
    Map data = await api.signupauth(user.email!, user.phone!, code);
    if (data['token'] != null) {
      Dbsingleton dbsingleton = Dbsingleton();
      Database? db = await dbsingleton.db;
      String token = data['token'];
      user.token = token;
      user.logged = 1;
      UserProvider.insert(user, db!);
      return true;
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }
  }

  static Future<void> log_in(
      BuildContext ctx, String email, String phone) async {
    AuthAPI api = AuthAPI();

    bool success = await api.login(email, phone);
    if (success) {
      User user = User(email, phone);
      Navigator.of(ctx).pushNamed('/Auth',
          arguments: [user, resend_code, log_in_check_code]);
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('User doesnot exist. Please try logging in.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  static Future<bool> log_in_check_code(
      BuildContext ctx, User user, String code) async {
    AuthAPI api = AuthAPI();
    Map data = await api.loginauth(user.email!, user.phone!, code);
    if (data['token'] != null) {
      Dbsingleton dbsingleton = Dbsingleton();
      Database? db = await dbsingleton.db;
      String token = data['token'];
      user.token = token;
      user.logged = 1;
      User? existedUser = await UserProvider.getUser(user.phone!, db!);
      if (existedUser == null) {
        UserProvider.insert(user, db);
      } else {
        UserProvider.update(user, db);
      }
      return true;
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }
  }
}