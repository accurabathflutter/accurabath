class SoPaymentScheduleTable {
  int id;
  double amount;
  String dueDate;

  String revdueDate;

  SoPaymentScheduleTable(this.amount, this.dueDate, this.revdueDate, {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['Amount'] = this.amount;
    data['DueDate'] = this.dueDate;
    data['RevDueDate'] = this.revdueDate;

    return data;
  }

  @override
  String toString() {
    return 'SoPaymentScheduleTable{id: $id, amount: $amount, dueDate: $dueDate, revdueDate: $revdueDate}';
  }
}
