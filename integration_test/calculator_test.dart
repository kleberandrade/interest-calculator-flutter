import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:interest_calculator/main.dart' as app;
import 'package:material_ui/material_ui.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('native calculator example, validation, reset and theme', (
    tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usar exemplo'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Calcular total'));
    await tester.tap(find.text('Calcular total'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('R\$ 1.040,10'));
    expect(find.text('2 dias de atraso · 2 períodos'), findsOneWidget);
    expect(find.text('R\$ 20,10'), findsOneWidget);

    final amount = find.widgetWithText(TextFormField, 'Valor do boleto');
    await tester.ensureVisible(amount);
    await tester.enterText(amount, '-1');
    await tester.pumpAndSettle();
    expect(find.text('R\$ 1.040,10'), findsNothing);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Calcular total'));
    await tester.tap(find.text('Calcular total'));
    await tester.pumpAndSettle();
    expect(find.text('Use um valor positivo, como 1.234,56.'), findsOneWidget);

    await tester.ensureVisible(find.text('Limpar'));
    await tester.tap(find.text('Limpar'));
    await tester.pumpAndSettle();
    expect(find.text('Seu resumo aparece aqui'), findsOneWidget);
    expect(find.text('1.000,00'), findsNothing);
    final themeButton = find.byTooltip('Alternar tema');
    await tester.ensureVisible(themeButton);
    final before = Theme.of(tester.element(themeButton)).brightness;
    await tester.tap(themeButton);
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(themeButton)).brightness, isNot(before));
    expect(tester.takeException(), isNull);
  });
}
