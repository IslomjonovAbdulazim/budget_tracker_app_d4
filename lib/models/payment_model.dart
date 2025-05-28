class PaymentModel {
  // members
  late int payment;
  late DateTime debtId;
  late String note;
  late DateTime date;

  // constructor
  PaymentModel({
    required this.payment,
    required this.debtId,
    required this.note,
    required this.date,
  });

  // fromJson
  PaymentModel.fromJson(Map json) {
    payment = json["payment"];
    debtId = DateTime.parse(json["debtId"]);
    note = json["note"];
    date = DateTime.parse(json["debt"]);
  }

  // toJson
  Map toJson() => {
        "payment": payment,
        "debtId": debtId.toIso8601String(),
        "note": note,
        "date": date.toIso8601String(),
      };
}
