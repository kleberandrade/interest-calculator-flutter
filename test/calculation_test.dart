import 'package:flutter_test/flutter_test.dart';
import 'package:interest_calculator/domain/calculation.dart';
import 'package:interest_calculator/domain/input.dart';

Slip slip({
  int principal = 100000,
  int fee = 200,
  int interest = 100,
  ChargeUnit feeUnit = ChargeUnit.percent,
  ChargeUnit interestUnit = ChargeUnit.percent,
  Period period = Period.day,
  DateTime? due,
  DateTime? paid,
}) => Slip(
  principal: principal,
  fee: fee,
  interest: interest,
  feeUnit: feeUnit,
  interestUnit: interestUnit,
  period: period,
  due: due ?? DateTime(2024, 2, 28),
  paid: paid ?? DateTime(2024, 3, 1),
);

void main() {
  test('independent compound example: 1000 × 1.01² + 20 = 1040.10', () {
    final result = calculate(slip());
    expect(result.days, 2);
    expect(result.periods, 2);
    expect(result.fee, 2000);
    expect(result.interest, 2010);
    expect(result.total, 104010);
  });
  test('same day and early payment have no charges', () {
    for (final paid in [DateTime(2024, 2, 28, 23), DateTime(2024, 1, 1)]) {
      final result = calculate(slip(paid: paid));
      expect(result.total, 100000);
      expect(result.days, 0);
    }
  });
  test('calendar days ignore time and daylight saving offsets', () {
    expect(
      calculate(
        slip(due: DateTime(2024, 2, 28, 23), paid: DateTime(2024, 2, 29, 1)),
      ).days,
      1,
    );
  });
  test('monthly periods truncate, fee still applies before day 30', () {
    final due = DateTime(2024, 1, 1);
    for (final days in [1, 29, 30, 59, 60]) {
      final result = calculate(
        slip(
          period: Period.month,
          due: due,
          paid: due.add(Duration(days: days)),
        ),
      );
      expect(result.periods, days ~/ 30);
      expect(result.fee, 2000);
      expect(result.interest, [0, 1000, 2010][days ~/ 30]);
    }
  });
  test('fixed charge becomes a compound rate on original principal', () {
    final result = calculate(
      slip(
        fee: 500,
        feeUnit: ChargeUnit.money,
        interest: 1000,
        interestUnit: ChargeUnit.money,
      ),
    );
    expect(result.fee, 500);
    expect(result.interest, 2010);
  });
  test('half cents round half up independently for each charge', () {
    final result = calculate(
      slip(
        principal: 1,
        fee: 5000,
        interest: 5000,
        paid: DateTime(2024, 2, 29),
      ),
    );
    expect(result.fee, 1);
    expect(result.interest, 1);
    expect(result.total, 3);
  });
  test('zero principal and zero rates are safe', () {
    expect(calculate(slip(principal: 0, fee: 0)).total, 0);
    expect(calculate(slip(fee: 0, interest: 0)).total, 100000);
    expect(
      () => slip(principal: 0, interestUnit: ChargeUnit.money),
      throwsArgumentError,
    );
  });
  test('negative inputs and explicit limits are rejected', () {
    for (final invalid in [-1, 1000000000001]) {
      expect(() => slip(principal: invalid), throwsArgumentError);
    }
    expect(() => slip(fee: -1), throwsArgumentError);
    expect(() => slip(interest: -1), throwsArgumentError);
    expect(() => slip(interest: 10001), throwsArgumentError);
    expect(() => slip(due: DateTime(1899)), throwsArgumentError);
    expect(() => slip(paid: DateTime(2101)), throwsArgumentError);
    expect(() => calculate(slip(paid: DateTime(2040))), throwsArgumentError);
    expect(
      () => calculate(slip(interest: 10000, paid: DateTime(2024, 6, 1))),
      throwsArgumentError,
    );
    expect(
      calculate(slip(principal: 1000000000000, fee: 0, interest: 0)).total,
      1000000000000,
    );
  });
  test('strict Brazilian decimal parsing, no binary floating point', () {
    expect(parseDecimal('1.234,56'), 123456);
    expect(parseDecimal(' 0,01 '), 1);
    expect(parseDecimal('1000'), 100000);
    for (final input in [
      '',
      '-1',
      '1.23',
      '1,234',
      'NaN',
      '1e3',
      '1.23,45',
      '99999999999999',
    ]) {
      expect(() => parseDecimal(input), throwsFormatException, reason: input);
    }
    expect(formatMoney(123456), 'R\$ 1.234,56');
  });
  test('strict dates reject normalization and handle leap years', () {
    expect(parseDate('29/02/2024'), DateTime.utc(2024, 2, 29));
    for (final input in [
      '29/02/2023',
      '31/04/2024',
      '',
      '2024-01-01',
      '01/01/2101',
    ]) {
      expect(() => parseDate(input), throwsFormatException);
    }
  });
}
