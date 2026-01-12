import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic material test', (WidgetTester tester) async {
    // اختبار أساسي بدون dependencies معقدة
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Test App')),
          body: const Center(child: Text('Welcome')),
        ),
      ),
    );

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}