import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DebtModel {
  // members
  late int sum;
  late int left;
  late String desc;
  late String name;
  late int phoneNumber;
  late DateTime date;
  late DateTime createdAt;
  late bool isBorrowed;

  // constructor
  DebtModel({
    required this.sum,
    this.left = -1,
    required this.desc,
    required this.name,
    required this.phoneNumber,
    required this.createdAt,
    required this.date,
    required this.isBorrowed,
  }) {
    if (left == -1) {
      left = sum;
    }
  }

  // fromJson
  DebtModel.fromJson(Map json) {
    sum = json["sum"];
    left = json["left"] ?? 0;
    desc = json["desc"];
    name = json["name"];
    phoneNumber = json["phoneNumber"];
    createdAt = DateTime.parse(json["createdAt"]);
    date = DateTime.parse(json["date"]);
    isBorrowed = json["isBorrowed"];
  }

  // toJson
  Map toJson() => {
        "sum": sum,
        "left": left,
        "desc": desc,
        "name": name,
        "phoneNumber": phoneNumber,
        "createdAt": createdAt.toIso8601String(),
        "date": date.toIso8601String(),
        "isBorrowed": isBorrowed,
      };
}

Future<void> saveAllDebts(List<DebtModel> debts) async {
  final db = await SharedPreferences.getInstance();
  final listJson = debts.map((model) => model.toJson()).toList();
  final data = jsonEncode(listJson);
  await db.setString("debts", data);
}

Future<List<DebtModel>> getAllDebts() async {
  final db = await SharedPreferences.getInstance();
  final data = db.getString("debts") ?? "[]";
  final listJson = List.from(jsonDecode(data));
  final result = listJson.map((json) => DebtModel.fromJson(json)).toList();
  result.sort((a, b) => b.date.compareTo(a.date));
  return result;
}

Future<void> deleteDebt(DebtModel debt) async {
  final allDebts = await getAllDebts();
  allDebts.removeWhere((model) => model.createdAt == debt.createdAt);
  await saveAllDebts(allDebts);
}

Future<void> createDebt(DebtModel debt) async {
  final allDebts = await getAllDebts();
  allDebts.removeWhere((model) => model.createdAt == debt.createdAt);
  allDebts.add(debt);
  await saveAllDebts(allDebts);
}
