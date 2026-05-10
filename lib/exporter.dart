import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:csv/csv.dart';
import 'package:file_save_directory/file_save_directory.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vault/classes/Account.dart';
import 'package:vault/dbHandling.dart';

class Exporter {
  static Future<String> _getCSVString(List<Map<String, dynamic>> data) async {
    if (data.isNotEmpty) {
      List<String> headers = data.first.keys.toList();
      List<List<dynamic>> csvData = [];
      csvData.add(headers);
      for (var row in data) {
        var rowData = [];
        for (var header in headers) {
          rowData.add(row[header] ?? '');
        }
        csvData.add(rowData);
      }
      return csv.encode(csvData);
    }

    return "";
  }

  static Future<bool> exportToCSV(String data) async {
    try {
      Directory? dir = await getExternalStorageDirectory();
      if (dir == null) return false;
      bool? success;
      final result = await FileSaveDirectory.instance.saveFile(
        fileName: "accounts_${DateTime.now().toIso8601String()}.txt",
        fileBytes: utf8.encode(data),
        openAfterSave: false,
      );
      success = result.success;
      if (success == true) {
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> exportAccounts() async {
    List<Account> accounts = await DatabaseHelper().getAllAccounts();
    if (accounts.isEmpty) {
      log("No accounts");
      return false;
    }
    List<Map<String, dynamic>> mapList = [];
    mapList = accounts.map((item) => item.toMap()).toList();
    String csvString = await _getCSVString(mapList);
    if (csvString.isEmpty) {
      log("Empty csv String");
      return false;
    } else {
      return await exportToCSV(csvString);
    }
  }
}
