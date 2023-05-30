import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../l10n/app_localizations.dart';
import '../Widgets/navigate_drawer.dart';

class ConnectUsPage extends StatefulWidget {
  static const routeName = "/connect_us";

  @override
  _ConnectUsPageState createState() => _ConnectUsPageState();
}

class _ConnectUsPageState extends State<ConnectUsPage> {
  final _formKey = GlobalKey<FormState>();
  String _subject = "";
  String _message = "";
  String _userID = FirebaseAuth.instance.currentUser!.uid;

  final List<String> _subjectOptions = [
    "Complaint",
    "Something didn't work",
    "General message",
  ];
  final List<Map<String, String>> _qaList = [
    {
      "question": "Is the images of my training saved in the db?",
      "answer": "No"
    },
    {"question": "Question number 2?", "answer": "Answer"},
    {"question": "Question number 3?", "answer": "Answer"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            AppLocalizations.of(context).translate('Connect Us'),
          ),
        ),
      ),
      drawer: NavigateDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)
                    .translate('What would you like to contact us about?'),
              ),
              SizedBox(height: 8),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      //value: _subject,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('Select subject'),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _subject = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)
                              .translate('Please select a subject');
                        }
                        return null;
                      },
                      items: _subjectOptions
                          .map((subject) => DropdownMenuItem<String>(
                              value: subject, child: Text(subject)))
                          .toList(),
                    ),
                    TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context).translate('Message'),
                        hintText: AppLocalizations.of(context)
                            .translate('Type your message here'),
                      ),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate('Please enter a message');
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _message = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _sendMessage();
                          }
                        },
                        child: Text(
                            AppLocalizations.of(context).translate('Send')),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate('Common Questions:'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return ExpansionTile(
                          title: Text(
                            _qaList[index]['question']!,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                _qaList[index]['answer']!,
                              ),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    FirebaseFirestore.instance.collection("Messages").add({
      "subject": _subject,
      "content": _message,
      "userID": _userID,
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).translate('Message sent'),
        ),
        content: Text(
          AppLocalizations.of(context).translate(
              'Thank you for contacting us. We will get back to you as soon as possible.'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context).translate('OK'),
            ),
          ),
        ],
      ),
    );
  }
}
