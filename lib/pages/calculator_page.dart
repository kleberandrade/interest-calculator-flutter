import 'package:material_ui/material_ui.dart';

import '../domain/calculation.dart';
import '../domain/input.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key, required this.onTheme});
  final VoidCallback onTheme;
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _form = GlobalKey<FormState>();
  final _money = TextEditingController();
  final _fee = TextEditingController(text: '0,00');
  final _interest = TextEditingController(text: '0,00');
  final _due = TextEditingController(text: formatDate(DateTime.now()));
  final _paid = TextEditingController(text: formatDate(DateTime.now()));
  ChargeUnit _feeUnit = ChargeUnit.percent;
  ChargeUnit _interestUnit = ChargeUnit.percent;
  Period _period = Period.day;
  Calculation? _result;
  String? _error;

  @override
  void dispose() {
    for (final controller in [_money, _fee, _interest, _due, _paid]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _changed() => setState(() {
    _result = null;
    _error = null;
  });

  void _example() {
    _form.currentState?.reset();
    _money.text = '1.000,00';
    _fee.text = '2,00';
    _interest.text = '1,00';
    _due.text = '28/02/2024';
    _paid.text = '01/03/2024';
    _resetOptions();
  }

  void _clear() {
    _form.currentState?.reset();
    _money.clear();
    _fee.text = _interest.text = '0,00';
    _due.text = _paid.text = formatDate(DateTime.now());
    _resetOptions();
  }

  void _resetOptions() => setState(() {
    _feeUnit = _interestUnit = ChargeUnit.percent;
    _period = Period.day;
    _result = null;
    _error = null;
  });

  void _calculate() {
    if (!_form.currentState!.validate()) return;
    try {
      final result = calculate(
        Slip(
          principal: parseDecimal(_money.text),
          fee: parseDecimal(_fee.text),
          interest: parseDecimal(_interest.text),
          feeUnit: _feeUnit,
          interestUnit: _interestUnit,
          period: _period,
          due: parseDate(_due.text),
          paid: parseDate(_paid.text),
        ),
      );
      setState(() {
        _result = result;
        _error = null;
      });
    } on ArgumentError catch (error) {
      setState(() {
        _result = null;
        _error = error.message.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Juros • boleto em dia'),
      actions: [
        IconButton(
          tooltip: 'Alternar tema',
          onPressed: widget.onTheme,
          icon: const Icon(Icons.contrast),
        ),
        IconButton(
          tooltip: 'Sobre o aplicativo',
          icon: const Icon(Icons.info_outline),
          onPressed: () => showAboutDialog(
            context: context,
            applicationName: 'Calculadora de Juros',
            applicationVersion: '2.0.0',
            applicationLegalese: '© 2020 Kleber de Oliveira Andrade · MIT',
            children: [
              const Text(
                'Projeto didático. Simulação com juros compostos; confira as condições do seu boleto.',
              ),
            ],
          ),
        ),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entenda cada centavo.',
                style: Theme.of(context).textTheme.headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Simule o pagamento em atraso e veja o valor original, a multa e os juros separados.',
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final form = _buildForm();
                  final summary = _buildSummary();
                  if (constraints.maxWidth < 850) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [form, const SizedBox(height: 24), summary],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: form),
                      const SizedBox(width: 24),
                      Expanded(flex: 2, child: summary),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Simulação educativa • Não consulta bancos, não emite boletos e não salva seus dados.',
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _panel(Widget child) => Card(
    margin: EdgeInsets.zero,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Padding(padding: const EdgeInsets.all(24), child: child),
  );

  Widget _heading(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleLarge
          ?.copyWith(fontWeight: FontWeight.w600),
    ),
  );

  Widget _buildForm() => _panel(
    Form(
      key: _form,
      onChanged: _changed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _example,
              icon: const Icon(Icons.auto_awesome_outlined),
              label: const Text('Usar exemplo'),
            ),
          ),
          _heading('01  Informações do boleto'),
          _number(_money, 'Valor do boleto', 'R\$'),
          const SizedBox(height: 16),
          _date(_due, 'Data de vencimento'),
          const SizedBox(height: 16),
          _date(_paid, 'Data de pagamento'),
          const SizedBox(height: 28),
          _heading('02  Encargos por atraso'),
          _number(
            _fee,
            'Multa única',
            _feeUnit == ChargeUnit.percent ? '%' : 'R\$',
          ),
          _units('Unidade da multa', _feeUnit, (unit) {
            _feeUnit = unit;
            _changed();
          }),
          const SizedBox(height: 16),
          _number(
            _interest,
            'Juros por período',
            _interestUnit == ChargeUnit.percent ? '%' : 'R\$',
          ),
          _units('Unidade dos juros', _interestUnit, (unit) {
            _interestUnit = unit;
            _changed();
          }),
          const SizedBox(height: 12),
          DropdownButtonFormField<Period>(
            isExpanded: true,
            initialValue: _period,
            key: ValueKey(_period),
            decoration: const InputDecoration(labelText: 'Período dos juros'),
            items: const [
              DropdownMenuItem(value: Period.day, child: Text('Diário')),
              DropdownMenuItem(
                value: Period.month,
                child: Text(
                  'Mensal (30 dias)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            onChanged: (value) {
              _period = value!;
              _changed();
            },
          ),
          const SizedBox(height: 12),
          const Text(
            'Juros compostos sobre o valor original. Em R\$, o encargo vira uma taxa sobre esse valor. Percentuais: 0 a 100% por período.',
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _calculate,
            icon: const Icon(Icons.calculate_outlined),
            label: const Text('Calcular total'),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            children: [
              TextButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Limpar'),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _number(TextEditingController controller, String label, String unit) =>
      TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        maxLength: 20,
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          hintText: '0,00',
          counterText: '',
        ),
        validator: (text) {
          try {
            parseDecimal(text ?? '');
            return null;
          } on FormatException catch (error) {
            return error.message;
          }
        },
      );

  Widget _date(TextEditingController controller, String label) => TextFormField(
    controller: controller,
    keyboardType: TextInputType.datetime,
    decoration: InputDecoration(
      labelText: label,
      hintText: 'dd/mm/aaaa',
      suffixIcon: IconButton(
        tooltip: 'Selecionar $label',
        icon: const Icon(Icons.calendar_today_outlined),
        onPressed: () async {
          DateTime initial;
          try {
            initial = parseDate(controller.text);
          } on FormatException {
            initial = DateTime.now();
          }
          final date = await showDatePicker(
            context: context,
            initialDate: initial,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100, 12, 31),
          );
          if (date != null && mounted) {
            controller.text = formatDate(date);
            _changed();
          }
        },
      ),
    ),
    validator: (text) {
      try {
        parseDate(text ?? '');
        return null;
      } on FormatException catch (error) {
        return error.message;
      }
    },
  );

  Widget _units(
    String label,
    ChargeUnit selected,
    ValueChanged<ChargeUnit> onChange,
  ) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Wrap(
      spacing: 8,
      children: ChargeUnit.values
          .map(
            (unit) => ChoiceChip(
              tooltip:
                  '$label: ${unit == ChargeUnit.percent ? 'porcentagem' : 'reais'}',
              label: Text(
                unit == ChargeUnit.percent ? 'Porcentagem' : 'Valor em R\$',
              ),
              selected: selected == unit,
              onSelected: (_) => onChange(unit),
            ),
          )
          .toList(),
    ),
  );

  Widget _buildSummary() => Semantics(
    liveRegion: true,
    child: _panel(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _heading('Resumo do pagamento'),
          if (_error != null) ...[
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ] else if (_result case final result?) ...[
            Text(
              'TOTAL SIMULADO',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Text(
              formatMoney(result.total),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text('${result.days} dias de atraso · ${result.periods} períodos'),
            const Divider(height: 40),
            _line('Valor original', result.principal),
            _line('Multa única', result.fee),
            _line('Juros compostos', result.interest),
            if (result.days == 0)
              const Text('Pagamento até o vencimento: sem multa e sem juros.'),
          ] else ...[
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Seu resumo aparece aqui',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Preencha o boleto ou use o exemplo e selecione Calcular total.',
            ),
          ],
          const Divider(height: 40),
          const Text(
            'Como calculamos',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Dias corridos, sem contar o vencimento.\n• Multa cobrada uma vez, só em atraso.\n• Mês = 30 dias completos, sem proporcionalidade.\n• Cada encargo é arredondado ao centavo, uma vez.\n• Máximo de 3.660 dias de atraso.',
          ),
        ],
      ),
    ),
  );

  Widget _line(String label, int cents) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 16,
      runSpacing: 4,
      children: [
        Text(label),
        Text(
          formatMoney(cents),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
