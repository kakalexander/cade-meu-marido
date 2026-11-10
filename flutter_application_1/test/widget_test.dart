import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Valida renderização do protótipo EncontreMeuParceiro',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MeuAplicativo());
    await tester.pump();

    // Verifica elementos da barra superior
    expect(find.text('EncontreMeuParceiro'), findsOneWidget);
    expect(find.text('Seu parceiro por perto'), findsOneWidget);
    expect(find.text('MVP'), findsOneWidget);

    // Verifica itens do menu de navegação
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Distância'), findsOneWidget);
    expect(find.text('Alertas'), findsOneWidget);
    expect(find.text('Sensores'), findsOneWidget);
  });
}
