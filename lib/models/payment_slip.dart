class PaymentSlip {
  double money;
  DateTime dueDate;
  DateTime payDate;
  double feeValue;
  String feeType;
  double interestValue;
  String interestPeriod;
  String interestType;

  PaymentSlip({
    this.money = 0.0,
    this.dueDate,
    this.payDate,
    this.feeValue = 0.0,
    this.feeType,
    this.interestValue = 0.0,
    this.interestPeriod,
    this.interestType,
  });
}