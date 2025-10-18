import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  testWidgets('Shows validation messages when fields are empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    await tester.tap(find.byKey(const Key('registerButton')));
    await tester.pump();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
  });

  testWidgets('Shows success message when form is valid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    await tester.enterText(find.byKey(const Key('nameField')), 'Mohand Mo');
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'mohand@gmail.com',
    );
    await tester.enterText(
      find.byKey(const Key('passwordField')),
      'mo12345678',
    );
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'mo12345678',
    );

    await tester.tap(find.byKey(const Key('registerButton')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Registration successful!'), findsOneWidget);
  });
}
