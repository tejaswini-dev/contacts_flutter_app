import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(ContactsLoading());

  @override
  Stream<ContactsState> mapEventToState(
    ContactsEvent event,
  ) async* {
    if (event is FetchContacts) {
      yield* _mapFetchContactstoState(event);
    }
  }

  Stream<ContactsState> _mapFetchContactstoState(FetchContacts event) async* {
    List<dynamic> contactLists = [];

    bool isLoading = false;

    getContactDetails() async {
      final firestoreInstance = FirebaseFirestore.instance;
      if (event.startPage == true) {
        await firestoreInstance
            .collection("contact")
            .limit(10)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            if (result != null &&
                result.data != null &&
                result.data().isNotEmpty) {
              contactLists.addAll(result.data()['users']);
            }
          });
        });
      } else {
        if (isLoading == true) {
          return;
        } else if (isLoading == false) {
          isLoading = true;

          await firestoreInstance
              .collection("contact")
              .limit(15)
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              if (result != null &&
                  result.data != null &&
                  result.data().isNotEmpty) {
                contactLists.addAll(result.data()['users']);
                isLoading = false;
              }
            });
          });
        }
      }
    }

    await getContactDetails();
    yield ContactsLoaded(
      contactLists: contactLists,
      isLoading: isLoading,
    );
  }
}
