import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/features/auth/views/feed_view.dart';
import 'package:social_app/features/counter/view/inc_dec_page.dart';
import 'package:social_app/features/auth/views/otp_view.dart';
import 'package:social_app/features/auth/views/phone_input_view.dart';

GoRouter buildRouter({required bool isAuthed}) {
  return GoRouter(
    // initialLocation: isAuthed ? '/feed' : '/auth/phone',
    initialLocation: isAuthed ? '/feed' : '/feed',
    routes: [
      GoRoute(
        path: '/auth/phone',
        builder: (context, state) => const PhoneInputView(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (context, state) =>
            OtpView(phone: state.extra as String?), // <-- pass extra here
      ),
      GoRoute(
        path: '/feed',
        builder: (context, state) => const FeedView(),
      ),
      GoRoute(
        path: '/counter',
        builder: (context, state) => const IncDecPage(),
      ),
    ],
  );
}
