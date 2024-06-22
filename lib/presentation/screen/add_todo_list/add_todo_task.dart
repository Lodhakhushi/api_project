import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app_widgets/app_custom_Button.dart';
import '../../../app_widgets/app_custom_Text_Field.dart';
import '../../../model/task_model.dart';
import '../on_board/login_in_page.dart';

class AddToDoTask extends StatefulWidget {
  @override
  State<AddToDoTask> createState() => _AddToDoTaskState();
}

class _AddToDoTaskState extends State<AddToDoTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference mTasks;
  String? selectedPriority;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString(LoginPage.PREF_USER_ID);

    if (uid != null) {
      mTasks = firestore.collection('users').doc(uid).collection('tasks');
    }

    setState(() {});
  }

  void selectPriority(String priority) {
    setState(() {
      selectedPriority = priority;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.yellow.shade900,
          ),
        ),
        backgroundColor: Colors.yellow.shade100,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Center(
                    child: Lottie.asset("assets/lottie/add_todo.json",
                        width: 200, height: 200),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppCustomTextField(
                  mController: titleController,
                  mText: "Title ",
                  mPreffixIcon: Icons.title,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppCustomTextField(
                  mController: descController,
                  mText: "Desc ",
                  mPreffixIcon: Icons.subtitles,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Set Priority!!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppCustomtBtn(
                    mTitle: "High",
                    mBgcolor: selectedPriority == "High"
                        ? Colors.yellowAccent.shade700
                        : Colors.yellowAccent.shade100,
                    TextColor: Colors.black,
                    mSize: Size(50, 20),
                    onTap: () {
                      selectPriority("High");
                    },
                  ),
                  AppCustomtBtn(
                    mTitle: "Low",
                    mBgcolor: selectedPriority == "Low"
                        ? Colors.yellowAccent.shade700
                        : Colors.yellowAccent.shade100,
                    TextColor: Colors.black,
                    mSize: Size(50, 20),
                    onTap: () {
                      selectPriority("Low");
                    },
                  ),
                  AppCustomtBtn(
                    mTitle: "Medium",
                    mBgcolor: selectedPriority == "Medium"
                        ? Colors.yellowAccent.shade700
                        : Colors.yellowAccent.shade100,
                    TextColor: Colors.black,
                    mSize: Size(50, 20),
                    onTap: () {
                      selectPriority("Medium");
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppCustomtBtn(
                      mTitle: "Add",
                      mBgcolor: Colors.yellowAccent.shade100,
                      TextColor: Colors.black,
                      mSize: Size(100, 40),
                      onTap: () async {
                        if (selectedPriority != null &&
                            titleController.text.isNotEmpty &&
                            descController.text.isNotEmpty) {
                          var task = TaskModel(
                            title: titleController.text,
                            subtitle: descController.text,
                            assignedAt: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            priority: selectedPriority!,
                          );

                          try {
                            DocumentReference docRef =
                                await mTasks.add(task.toDoc());
                            await docRef.update({"todoId": docRef.id});
                            titleController.clear();
                            descController.clear();
                            setState(() {
                              selectedPriority = null;
                            });
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to add task: $e'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please fill all fields and select a priority'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppCustomtBtn(
                      mTitle: "Cancel",
                      mBgcolor: Colors.yellowAccent.shade100,
                      TextColor: Colors.black,
                      mSize: Size(100, 40),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
