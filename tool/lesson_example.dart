import 'dart:io';

import 'package:interest_calculator/domain/calculation.dart';
import 'package:interest_calculator/domain/input.dart';

void main() {
  final slip = Slip(
    principal: parseDecimal('1.000,00'),
    fee: parseDecimal('2,00'),
    interest: parseDecimal('1,00'),
    feeUnit: ChargeUnit.percent,
    interestUnit: ChargeUnit.percent,
    period: Period.day,
    due: parseDate('28/02/2024'),
    paid: parseDate('01/03/2024'),
  );
  final result = calculate(slip);
  stdout.writeln('Original: ${formatMoney(result.principal)}');
  stdout.writeln('Multa: ${formatMoney(result.fee)}');
  stdout.writeln('Juros: ${formatMoney(result.interest)}');
  stdout.writeln('Total: ${formatMoney(result.total)}');
}
