import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:social_app/app_bloc_observer.dart';
import 'package:social_app/features/counter/bloc/counter_bloc.dart';
import 'package:social_app/features/counter/cubit/counter_cubit.dart';
import 'package:social_app/features/todo/cubit/todo_cubit.dart';

import 'app/app.dart';
import 'app/di.dart';
import 'core/config/app_config.dart';
import 'features/auth/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.init(EnvironmentType.PRODUCTION);

  await setupDi();
  final storedToken = await const FlutterSecureStorage().read(key: 'jwt');
  final initialAuthed = storedToken != null && storedToken.isNotEmpty;

  Bloc.observer = AppBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(initialAuthed: initialAuthed),
        ),
        BlocProvider(
          create: (_) => CounterBloc(),
        ),
        BlocProvider(
          create: (_) => CounterCubit(),
        ),
        BlocProvider(
          create: (_) => TodoCubit(),
        ),
      ],
      child: MalaysiaSocialApp(isAuthed: initialAuthed), // 👈 pass to app
    ),
  );
}
