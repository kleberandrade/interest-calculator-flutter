import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interest_calculator/main.dart';

void main() {
  testWidgets('example, calculate, invalidate stale result and clear', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    expect(find.text('Seu resumo aparece aqui'), findsOneWidget);
    await tester.tap(find.text('Usar exemplo'));
    await tester.pump();
    await tester.tap(find.text('Calcular total'));
    await tester.pumpAndSettle();
    expect(find.text('R\$ 1.040,10'), findsOneWidget);
    expect(find.text('2 dias de atraso · 2 períodos'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Valor do boleto'),
      '-1',
    );
    await tester.pump();
    expect(find.text('R\$ 1.040,10'), findsNothing);
    await tester.tap(find.text('Calcular total'));
    await tester.pumpAndSettle();
    expect(find.text('Use um valor positivo, como 1.234,56.'), findsOneWidget);
    await tester.tap(find.text('Limpar'));
    await tester.pump();
    expect(find.text('Seu resumo aparece aqui'), findsOneWidget);
    expect(find.text('1.000,00'), findsNothing);
    await tester.tap(find.byTooltip('Alternar tema'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  testWidgets('narrow screen and large text remain usable', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Usar exemplo'));
    await tester.pump();
    await tester.ensureVisible(find.text('Calcular total'));
    await tester.tap(find.text('Calcular total'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('R\$ 1.040,10'));
    expect(tester.takeException(), isNull);
  });
}
