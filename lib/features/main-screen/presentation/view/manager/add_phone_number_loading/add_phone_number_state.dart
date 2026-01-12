part of 'add_phone_number_cubit.dart';

@immutable
sealed class AddPhoneNumberState {}

final class AddPhoneNumberInitial extends AddPhoneNumberState {}
// ignore: must_be_immutable
class AddPhoneNumberLoading extends AddPhoneNumberState {
  var loading = false;
  AddPhoneNumberLoading({required this.loading});
}