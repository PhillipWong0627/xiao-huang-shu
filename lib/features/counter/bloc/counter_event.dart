//Can only be subclassed (or implemented) within the same file where it is defined.
part of 'counter_bloc.dart';

sealed class CounterEvent {}

final class CounterIncremented extends CounterEvent {}

final class CounterDecremented extends CounterEvent {}
