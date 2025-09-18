part of 'phone_number_cubit.dart';

@immutable
sealed class PhoneNumberState {}

final class PhoneNumberInitial extends PhoneNumberState {}

final class SelectedCategory extends PhoneNumberState {
  var selectedCategory = "";
  SelectedCategory({required this.selectedCategory});
}
