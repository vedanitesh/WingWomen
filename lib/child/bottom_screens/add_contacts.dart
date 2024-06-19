import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:women_safety_app/child/bottom_screens/contacts_page.dart';
import 'package:women_safety_app/components/PrimaryButton.dart';
import 'package:women_safety_app/db/db_services.dart';
import 'package:women_safety_app/model/contactsm.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  DatabaseHelper databasehelper = DatabaseHelper();
  List<TContact>? contactList;
  int count = 0;

  void showList() {
    Future<Database> dbFuture = databasehelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContact>> contactListFuture =
          databasehelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          this.contactList = value;
          this.count = value.length;
        });
      });
    });
  }

  void deleteContact(TContact contact) async {
    int result = await databasehelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact removed successfully");
      showList();
    }
  }

  @override
  void initState() {
    super.initState();
    showList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            PrimaryButton(
              title: "Add Trusted Contacts",
              onPressed: () async {
                // Use await with then to handle the result from Navigator.push
                bool? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactsPage(),
                  ),
                ).then((value) {
                  // Handle the result returned from the ContactsPage
                  if (value == true) {
                    showList();
                  }
                  return value;
                });

                // Check the result
                if (result == true) {
                  showList();
                }
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  // Check if contactList is not null before accessing its elements
                  if (contactList != null && index < contactList!.length) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(contactList![index].name),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await FlutterPhoneDirectCaller.callNumber(
                                      contactList![index].number,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteContact(contactList![index]);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Handle the case where contactList is null or index is out of bounds
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
