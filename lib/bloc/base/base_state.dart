import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object> get props => [];
}

// TODO: template for other classes
// abstract class BaseStateEmpty extends BaseState {}

// abstract class BaseStateLoading extends BaseState {}

// abstract class BaseStateSuccess<T> extends BaseState {
//   final T item;
//   const BaseStateSuccess(this.item);

//   @override
//   List<Object> get props => [item];
// }

// abstract class BaseStateError extends BaseState {
//   final AppError error;

//   const BaseStateError(this.error);

//   @override
//   List<Object> get props => [error];
// }
