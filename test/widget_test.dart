import 'package:code4all/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyHomePage Tests', () {
    testWidgets('Deve exibir os principais elementos da UI', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Flutter Scalable OCR'), findsOneWidget);
      expect(find.text('Texto Identificado: '), findsOneWidget);
      expect(find.text('Câmera'), findsOneWidget);
      expect(find.text('Lanterna'), findsOneWidget);
      expect(find.text('Travar'), findsOneWidget);

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('Deve navegar para a tela de perfil ao tocar no ícone', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.byIcon(Icons.person_outline));

      await tester.pumpAndSettle();

      expect(find.text('Editar Perfil'), findsOneWidget);
      expect(find.text('Digite seu nome completo'), findsOneWidget);
    });
  });

  group('ProfileScreen Tests', () {
    testWidgets('Deve exibir os elementos do formulário de perfil', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('Idade'), findsOneWidget);
      expect(find.text('Cidade'), findsOneWidget);
      expect(find.text('Estado'), findsOneWidget);
      expect(find.text('Salvar Alterações'), findsOneWidget);

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('Deve permitir digitar nos campos de texto', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Nome'),
        'Adielson Medeiros',
      );

      await tester.pump();

      expect(find.text('Adielson Medeiros'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextField, 'Idade'), '30');
      await tester.pump();
      expect(find.text('30'), findsOneWidget);
    });
  });
}
