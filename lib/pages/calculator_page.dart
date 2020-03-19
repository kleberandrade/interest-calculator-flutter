import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:interest_calculator/controllers/controller.dart';
import 'package:interest_calculator/helpers/constantes.dart';
import 'package:interest_calculator/models/result_payment_slip.dart';
import 'package:intl/intl.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _inputFieldHeight = 60.0;
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _moneyFormat = NumberFormat("#,##0.00", "pt_BR");

  // Lógica de negócio do aplicativo
  Controller _controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTitle('Informações do boleto'),
              _buildMoneyInputField(
                'Valor do boleto',
                controller: _controller.moneyController,
                onSaved: (value) {
                  _controller.paymentSlip.money =
                      _controller.moneyController.numberValue;
                },
              ),
              _buildDateInputField(
                'Data de vencimento',
                onSaved: (date) {
                  _controller.paymentSlip.dueDate = date;
                },
              ),
              _buildDateInputField(
                'Data de pagamento',
                onSaved: (date) {
                  _controller.paymentSlip.payDate = date;
                },
              ),
              _buildTitle('Multa'),
              _buildMoneyInputField(
                'Valor da multa',
                controller: _controller.feeController,
                onSaved: (value) {
                  _controller.paymentSlip.feeValue =
                      _controller.feeController.numberValue;
                },
              ),
              _buildRateRadioButton(
                context,
                onChanged: (label) {
                  print(label);
                  _controller.paymentSlip.feeType = label;
                },
              ),
              _buildTitle('Juros'),
              _buildMoneyInputField(
                'Valor do juros',
                controller: _controller.interestController,
                onSaved: (value) {
                  _controller.paymentSlip.interestValue =
                      _controller.interestController.numberValue;
                },
              ),
              _buildRateRadioButton(
                context,
                onChanged: (label) {
                  print(label);
                  _controller.paymentSlip.interestType = label;
                },
              ),
              _buildPeriodRadioButton(
                context,
                onChanged: (label) {
                  print(label);
                  _controller.paymentSlip.interestPeriod = label;
                },
              ),
              _buildRoundedButton(
                context,
                label: 'CALCULAR',
                padding: EdgeInsets.only(top: 32.0),
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    var result = _controller.calculate();
                    _showResultDialog(result);
                  }
                },
              ),
              _buildRoundedButton(
                context,
                label: 'LIMPAR',
                padding: EdgeInsets.symmetric(vertical: 8.0),
                onTap: () {
                  setState(() {
                    _controller.clear();
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text('Calculadora de Juros'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.lightbulb_outline),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {},
        ),
      ],
    );
  }

  _roundedInputDecoration() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_inputFieldHeight * 0.5),
    );
  }

  _buildTitle(String title, {double top = 16.0, double bottom = 8.0}) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, top, 0.0, bottom),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _buildMoneyInputField(String label,
      {MoneyMaskedTextController controller, Function(String) onSaved}) {
    return Container(
      height: _inputFieldHeight,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        onSaved: onSaved,
        decoration: InputDecoration(
          labelText: label,
          border: _roundedInputDecoration(),
        ),
      ),
    );
  }

  _buildRateRadioButton(BuildContext context, {Function(dynamic) onChanged}) {
    return CustomRadioButton(
      enableShape: true,
      elevation: 0,
      buttonColor: Theme.of(context).canvasColor,
      buttonLables: Constantes.rateLabels,
      buttonValues: Constantes.rateLabels,
      radioButtonValue: onChanged,
      selectedColor: Theme.of(context).accentColor,
    );
  }

  _buildPeriodRadioButton(BuildContext context, {Function(dynamic) onChanged}) {
    return CustomRadioButton(
      enableShape: true,
      elevation: 0,
      buttonColor: Theme.of(context).canvasColor,
      buttonLables: Constantes.periodLabels,
      buttonValues: Constantes.periodLabels,
      radioButtonValue: onChanged,
      selectedColor: Theme.of(context).accentColor,
    );
  }

  _buildDateInputField(String label, {Function(DateTime) onSaved}) {
    return Container(
      height: _inputFieldHeight,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: DateTimeField(
        decoration: InputDecoration(
          labelText: label,
          border: _roundedInputDecoration(),
        ),
        format: _dateFormat,
        initialValue: DateTime.now(),
        onSaved: onSaved,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          );
        },
      ),
    );
  }

  _buildRoundedButton(BuildContext context,
      {String label = '', Function onTap, EdgeInsets padding}) {
    return Padding(
      padding: padding,
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_inputFieldHeight * 0.5),
            color: Theme.of(context).primaryColor,
          ),
          height: _inputFieldHeight * 0.8,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).canvasColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showResultDialog(ResultPaymentSlip result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Resultado"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildResultDialogRow('Atraso', '${result.days} ${_controller.paymentSlip.interestPeriod.toLowerCase()}(s)'),
              _buildResultDialogRow('Juros', 'R\$ ${_moneyFormat.format(result.interest)}'),
              _buildResultDialogRow('Multa', 'R\$ ${_moneyFormat.format(result.fee)}'),
              SizedBox(height: 16),
              Divider(height: 0.1),
              SizedBox(height: 16),
              _buildResultDialogRow('Total', 'R\$ ${_moneyFormat.format(result.value)}'),
            ],
          ),
        );
      },
    );
  }

  _buildResultDialogRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, textAlign: TextAlign.left),
        Text(value, textAlign: TextAlign.right),
      ],
    );
  }
}
