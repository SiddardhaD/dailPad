import 'dart:io';

import 'package:dailpad/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:phone_state/phone_state.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    intializeDailPad();
    intializePhoneState();
    setStream();

    super.initState();
  }

  bool inialize = false;
  late List<Contact> contacts;
  intializeDailPad() async {
    setState(() {
      inialize = true;
    });
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts();
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      Contact? contact = await FlutterContacts.getContact(contacts.first.id);

      // Insert new contact
      // final newContact = Contact()
      //   ..name.first = 'John'
      //   ..name.last = 'Smith'
      //   ..phones = [Phone('555-123-4567')];
      // await newContact.insert();

      // // Update contact
      // contact!.name.first = 'Bob';
      // await contact.update();

      // // Delete contact
      // await contact.delete();

      // Open external contact app to view/edit/pick/insert contacts.
      // await FlutterContacts.openExternalView(contact.id);
      // await FlutterContacts.openExternalEdit(contact.id);
      //  contact = await FlutterContacts.openExternalPick();
      //  contact = await FlutterContacts.openExternalInsert();

      // Listen to contact database changes
      // FlutterContacts.addListener(() => print('Contact DB changed'));

      // Create a new group (iOS) / label (Android).
      // await FlutterContacts.insertGroup(Group('', 'Coworkers'));

      // Export contact to vCard
      // String vCard = contact!.toVCard();

      // Import contact from vCard
      // contact = Contact.fromVCard('BEGIN:VCARD\n'
      //     'VERSION:3.0\n'
      //     'N:;Joe;;;\n'
      //     'TEL;TYPE=HOME:123456\n'
      //     'END:VCARD');
    }
    setState(() {
      inialize = false;
    });
  }

  intializePhoneState() async {
    await requestPermission();
  }

  var statuss;
  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();
    setState(() {
      statuss = status;
    });

    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.granted:
        return true;
    }
  }

  void setStream() {
    PhoneState.phoneStateStream.listen((event) {
      setState(() {
        if (event != null) {
          statuss = event;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Stack(
        children: [
          Container(
            child: TextButton(
              child: Text("Listenn calls"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondRoute()),
                );
              },
            ),
          ),
          inialize == false
              ? ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Column(
                        children: [
                          Row(
                            children: [Text(contacts[index].displayName)],
                          ),
                        ],
                      )),
                    );
                  })
              : CircularProgressIndicator(),
        ],
      )),
    );
  }   
}
