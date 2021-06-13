part of 'contacts_bloc.dart';

@immutable
abstract class ContactsEvent {}

class FetchContacts extends ContactsEvent {
  bool startPage;

  FetchContacts(this.startPage);
}
