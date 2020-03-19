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
    this.money,
    this.dueDate,
    this.payDate,
    this.feeValue,
    this.feeType,
    this.interestValue,
    this.interestPeriod,
    this.interestType,
  });
}
