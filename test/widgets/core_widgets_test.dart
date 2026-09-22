import 'package:e_commerce/core/widgets/custom_error_widget.dart';
import 'package:e_commerce/core/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomLoading', () {
    testWidgets('renders a circular progress indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CustomLoading())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('CustomErrorWidget', () {
    testWidgets('shows the message without a retry button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CustomErrorWidget(message: 'Something went wrong')),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('shows a retry button and fires the callback when tapped',
        (tester) async {
      var retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomErrorWidget(
              message: 'Something went wrong',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);
    });
  });
}