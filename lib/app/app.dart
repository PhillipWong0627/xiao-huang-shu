import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';

class MalaysiaSocialApp extends StatelessWidget {
  final bool isAuthed;

  const MalaysiaSocialApp({super.key, required this.isAuthed});

  @override
  Widget build(BuildContext context) {
    final router = buildRouter(isAuthed: isAuthed);
    return MaterialApp.router(
      title: 'Malaysia Social',
      theme: buildTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
