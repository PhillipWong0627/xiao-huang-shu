import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() {
    log('Increment');
    emit(state + 1);
  }

  void decrement() {
    log('Decrement');
    if (state == 0) return;
    emit(state - 1);
  }
}
