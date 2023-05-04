import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        title: Text("Connect Us"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("What would you like to contact us about?"),
              SizedBox(height: 8),
              ToggleButtons(
                children:
                    _subjectOptions.map((subject) => Text(subject)).toList(),
                isSelected: List.generate(_subjectOptions.length,
                    (index) => _subject == _subjectOptions[index]),
                onPressed: (index) {
                  setState(() {
                    _subject = _subjectOptions[index];
                  });
                },
              ),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Message",
                        hintText: "Type your message here",
                      ),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please enter a message";
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
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _sendMessage();
                        }
                      },
                      child: Text("Send"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Common Qestions:",
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
        title: Text("Message sent"),
        content: Text(
            "Thank you for contacting us. We will get back to you as soon as possible."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
