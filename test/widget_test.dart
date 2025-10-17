// test/widget_test.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/app/app.dart'; // MalaysiaSocialApp
import 'package:social_app/features/auth/bloc/auth_bloc.dart'; // your stub AuthBloc

void main() {
  testWidgets('App builds and shows Phone Login screen', (tester) async {
    final storedToken = await const FlutterSecureStorage().read(key: 'jwt');
    final initialAuthed = storedToken != null && storedToken.isNotEmpty;

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(initialAuthed: initialAuthed)),
        ],
        child: MalaysiaSocialApp(isAuthed: initialAuthed),
      ),
    );

    await tester.pumpAndSettle();

    // Expect your initial route's title/text
    expect(find.text('Phone Login'), findsOneWidget);
  });
}
