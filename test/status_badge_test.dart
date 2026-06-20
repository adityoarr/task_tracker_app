import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_tracker_app/core/widgets/status_badge.dart';

void main() {
  testWidgets('StatusBadge menampilkan teks dan warna yang benar sesuai status', (WidgetTester tester) async {
    // Arrange & Act (Done Status)
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StatusBadge(isDone: true))),
    );

    // Assert
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Pending'), findsNothing);

    // Arrange & Act (Pending Status)
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StatusBadge(isDone: false))),
    );

    // Assert
    expect(find.text('Pending'), findsOneWidget);
  });
}