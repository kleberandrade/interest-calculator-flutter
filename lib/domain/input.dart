/// Strict pt-BR input. Never interpret a binary floating point money value.
int parseDecimal(String text) {
  final input = text.trim();
  if (input.length > 20 ||
      !RegExp(r'^(?:\d+|\d{1,3}(?:\.\d{3})+)(?:,\d{1,2})?$').hasMatch(input)) {
    throw const FormatException('Use um valor positivo, como 1.234,56.');
  }
  final parts = input.replaceAll('.', '').split(',');
  final cents =
      BigInt.parse(parts[0]) * BigInt.from(100) +
      BigInt.parse(parts.length == 1 ? '0' : parts[1].padRight(2, '0'));
  if (cents > BigInt.from(1000000000000)) {
    throw const FormatException('Limite de entrada: 10 bilhões.');
  }
  return cents.toInt();
}

DateTime parseDate(String text) {
  final match = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(text.trim());
  if (match == null) throw const FormatException('Use dd/mm/aaaa.');
  final day = int.parse(match[1]!);
  final month = int.parse(match[2]!);
  final year = int.parse(match[3]!);
  final date = DateTime.utc(year, month, day);
  if (date.day != day || date.month != month || year < 1900 || year > 2100) {
    throw const FormatException('Informe uma data válida de 1900 a 2100.');
  }
  return date;
}

String formatMoney(int cents) {
  final whole = (cents ~/ 100).toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]}.',
  );
  return 'R\$ $whole,${(cents % 100).toString().padLeft(2, '0')}';
}

String formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
