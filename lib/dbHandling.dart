import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vault/classes/Account.dart';
import 'package:vault/classes/User.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), "accounts.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
        CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        icon TEXT NOT NULL,
        category TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL)

        
      """);

    await db.execute('''
CREATE INDEX idx_accounts_category ON accounts(category)''');

    await db.execute('''
        CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pin TEXT
        )
      ''');
  }

  Future<void> addUser(User user) async {
    try {
      Database db = await database;
      await db.insert('user', user.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateUserPin(String pin) async {
    User newUser = User(pin: pin);
    try {
      Database db = await database;
      await db.update('user', newUser.toMap(), where: 'id=0');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> getUserPin() async {
    try {
      Database db = await database;
      var maps = await db.query("user", where: "id=0");
      User user = maps.map((e) => User.fromMap(e)).toList().first;
      return user.pin;
    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  Future<void> addAccount(Account account) async {
    try {
      Database db = await database;
      await db.insert('accounts', account.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateAccount(Account newAccount) async {
    try {
      Database db = await database;
      await db.update(
        'accounts',
        newAccount.toMap(),
        where: 'id=?',
        whereArgs: [newAccount.id],
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> removeAccount(int id) async {
    try {
      Database db = await database;
      await db.delete('accounts', where: "id=?", whereArgs: [id]);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Account>> getAllAccounts() async {
    try {
      Database db = await database;
      List<Map<String, Object?>> map = await db.query('accounts');
      List<Account> accounts = [];
      accounts = map.map((e) => Account.fromMap(e)).toList();
      return accounts;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<void> removeDB() async {
    try {
      Database db = await database;
      db.close();
      await deleteDatabase(db.path);
      _database = null;
    } catch (e) {
      log(e.toString());
    }
  }
}
