import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:social_app/features/counter/bloc/counter_bloc.dart';
import 'package:social_app/features/counter/cubit/counter_cubit.dart';

import 'app/app.dart';
import 'app/di.dart';
import 'core/config/app_config.dart';
import 'features/auth/bloc/auth/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.init(EnvironmentType.STAGING);

  await setupDi();
  final storedToken = await const FlutterSecureStorage().read(key: 'jwt');
  final initialAuthed = storedToken != null && storedToken.isNotEmpty;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            // Start AuthBloc in the right initial state

            create: (_) => AuthBloc(initialAuthed: initialAuthed)),
        BlocProvider(
          create: (_) => CounterBloc(),
        ),
        BlocProvider(
          create: (_) => CounterCubit(),
        ),
      ],
      child: MalaysiaSocialApp(isAuthed: initialAuthed), // 👈 pass to app
    ),
  );
}
