import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/features/auth/views/feed_view.dart';
import 'package:social_app/features/auth/views/phone_input_view.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/auth/phone',
    routes: [
      GoRoute(
        path: '/auth/phone',
        builder: (_, __) => const PhoneInputView(),
      ),
      GoRoute(
        path: '/feed',
        builder: (_, __) => const FeedView(),
      ),
    ],
  );
}
