part of 'contacts_bloc.dart';

@immutable
abstract class ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<dynamic> contactLists;
  final bool isLoading;

  ContactsLoaded({
    this.contactLists,
    this.isLoading,
  });
}
