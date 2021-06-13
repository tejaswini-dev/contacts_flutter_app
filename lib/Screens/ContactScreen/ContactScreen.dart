import 'dart:io';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_contacts/Constants/ColorConstants.dart';
import 'package:flutter_app_contacts/Screens/ContactScreen/bloc/contacts_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ContactsBloc contactsBloc = ContactsBloc();

  int selectedIndex = 0;
  String appBarTitleText = "Contacts";
  String exitText = "Are you sure you want to exit ?";
  String yesText = "Yes";
  String noText = "No";

  @override
  void initState() {
    super.initState();
    contactsBloc.add(FetchContacts(true));
  }

  @override
  void dispose() {
    contactsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        cubit: contactsBloc,
        builder: (context, state) {
          if (state is ContactsLoading) {
            return Scaffold(
              backgroundColor: AppColors.whiteColor,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ContactsLoaded) {
            return WillPopScope(
              onWillPop: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                          exitText ?? "",
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: new Text(
                              yesText ?? "Yes",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {
                              exit(0);
                            },
                          ),
                          TextButton(
                            child: new Text(
                              noText ?? "No",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Scaffold(
                backgroundColor: AppColors.whiteColor,
                appBar: AppBar(
                  backgroundColor: AppColors.whiteColor,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  elevation: 0.0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 18.0,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                  title: Text(
                    appBarTitleText.toUpperCase() ?? "",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: NotificationListener(
                        onNotification: (ScrollNotification scrollState) {
                          FocusScope.of(context).unfocus();
                          if (scrollState.metrics.pixels ==
                              scrollState.metrics.maxScrollExtent) {
                            if (state.isLoading == false) {
                              contactsBloc.add(FetchContacts(false));
                            }
                          }
                        },
                        child: AlphabetScrollView(
                          list: state.contactLists
                              .map((e) => AlphaModel(e['name']))
                              .toList(),
                          // isAlphabetsFiltered: false,
                          alignment: LetterAlignment.right,
                          itemExtent: 50,
                          unselectedTextStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                          selectedTextStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blueColor,
                          ),
                          overlayWidget: (value) => Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                size: 50,
                                color: Colors.red,
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$value'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          itemBuilder: (_, k, id) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: ListTile(
                                title: Text('${id}'),
                                subtitle: Text(
                                    '${state.contactLists[k]['phNumber']}'),
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.blueColor,
                                  radius: 20.0,
                                  child: Icon(
                                    Icons.person,
                                    size: 22.0,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
