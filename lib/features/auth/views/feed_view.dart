import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/features/auth/bloc/auth/auth_bloc.dart';
import 'package:social_app/features/auth/bloc/auth/auth_event.dart';
import 'package:social_app/features/counter/bloc/counter_bloc.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignedOut());
              context.go('/auth/phone'); // 👈 navigate back to login page
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              context.push('/counter');
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, counter) {
            return Text('Boga Chink $counter');
          },
        ),
      ),
    );
  }
}
