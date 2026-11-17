/// Percent values use hundredths of a percent; monetary values use cents.
enum ChargeUnit { money, percent }

enum Period { day, month }

class Slip {
  Slip({
    required this.principal,
    required this.fee,
    required this.interest,
    required this.feeUnit,
    required this.interestUnit,
    required this.period,
    required DateTime due,
    required DateTime paid,
  }) : due = DateTime.utc(due.year, due.month, due.day),
       paid = DateTime.utc(paid.year, paid.month, paid.day) {
    _range(principal, 1000000000000, 'Valor do boleto');
    _range(fee, feeUnit == ChargeUnit.percent ? 10000 : 1000000000000, 'Multa');
    _range(
      interest,
      interestUnit == ChargeUnit.percent ? 10000 : 1000000000000,
      'Juros',
    );
    if (due.year < 1900 ||
        due.year > 2100 ||
        paid.year < 1900 ||
        paid.year > 2100) {
      throw ArgumentError('Use datas entre 1900 e 2100.');
    }
    if (principal == 0 && interestUnit == ChargeUnit.money && interest > 0) {
      throw ArgumentError('Juros em reais exigem um boleto maior que zero.');
    }
  }
  final int principal, fee, interest;
  final ChargeUnit feeUnit, interestUnit;
  final Period period;
  final DateTime due, paid;
}

void _range(int value, int max, String label) {
  if (value < 0 || value > max) {
    throw ArgumentError('$label fora do limite: 0 a $max centésimos.');
  }
}

class Calculation {
  const Calculation({
    required this.principal,
    required this.fee,
    required this.interest,
    required this.days,
    required this.periods,
  });
  final int principal, fee, interest, days, periods;
  int get total => principal + fee + interest;
}

/// Exact rational compound growth; each charge is rounded once, half up.
Calculation calculate(Slip slip) {
  final elapsed = slip.paid.difference(slip.due).inDays;
  final days = elapsed < 0 ? 0 : elapsed;
  _range(days, 3660, 'Atraso em dias');
  final periods = slip.period == Period.month ? days ~/ 30 : days;
  final fee = days == 0 ? 0 : _fee(slip);
  final interest = _interest(slip, periods);
  _range(slip.principal + fee + interest, 1000000000000000, 'Total');
  return Calculation(
    principal: slip.principal,
    fee: fee,
    interest: interest,
    days: days,
    periods: periods,
  );
}

int _fee(Slip slip) => slip.feeUnit == ChargeUnit.money
    ? slip.fee
    : _round(
        BigInt.from(slip.principal) * BigInt.from(slip.fee),
        BigInt.from(10000),
      );

int _interest(Slip slip, int periods) {
  if (slip.principal == 0 || slip.interest == 0 || periods == 0) return 0;
  final denominator = BigInt.from(
    slip.interestUnit == ChargeUnit.percent ? 10000 : slip.principal,
  );
  final numerator = denominator + BigInt.from(slip.interest);
  final bottom = denominator.pow(periods);
  final growth = numerator.pow(periods) - bottom;
  final value = BigInt.from(slip.principal) * growth;
  if (value > BigInt.from(1000000000000000) * bottom) {
    throw ArgumentError('Resultado acima do limite de R\$ 10 trilhões.');
  }
  return _round(value, bottom);
}

int _round(BigInt numerator, BigInt denominator) =>
    ((numerator * BigInt.two + denominator) ~/ (denominator * BigInt.two))
        .toInt();
