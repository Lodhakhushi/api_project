import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/task_model.dart';
import '../add_todo_list/add_todo_task.dart';
import '../on_board/login_in_page.dart';
import '../update_todo_list/update_todo_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference mUsers;

  String? uid;
  static const COLLECTION_USER_KEY = "users";
  static const COLLECTION_TODO_KEY = "tasks";

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(LoginPage.PREF_USER_ID);
    setState(() {});
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(LoginPage.PREF_USER_ID);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return LoginPage();
      },
    ));
  }

  void showCompletionDialogBox(BuildContext context, bool isCompleted) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isCompleted ? 'Task Completed' : 'Task Incomplete',
            style: TextStyle(
              color: Colors.yellow.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            isCompleted
                ? 'Congratulations on completing the task!'
                : 'The task has been marked as incomplete.',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 15.0,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.yellow.shade900),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadowColor: Colors.grey,
          backgroundColor: Colors.yellow.shade100,
        );
      },
    );
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red.shade300;
      case 'Medium':
        return Colors.orange.shade200;
      case 'Low':
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  int getPriorityValue(String priority) {
    switch (priority) {
      case 'High':
        return 3;
      case 'Medium':
        return 2;
      case 'Low':
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    mUsers = firestore.collection('users').doc(uid).collection('tasks');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Your Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.yellow.shade900,
          ),
        ),
        backgroundColor: Colors.yellow.shade100,
        centerTitle: true,
        elevation: 10,
        actions: [
          IconButton(
              onPressed: () {
                logout();
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: uid != null
          ? StreamBuilder(
              stream: firestore
                  .collection(COLLECTION_USER_KEY)
                  .doc(uid)
                  .collection(COLLECTION_TODO_KEY)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Image.asset('assets/images/nodata-found.jpg'));
                }

                // Sort the tasks based on priority
                List<QueryDocumentSnapshot> sortedDocs = snapshot.data!.docs;
                sortedDocs.sort((a, b) {
                  String priorityA = a.get('priority');
                  String priorityB = b.get('priority');
                  return getPriorityValue(priorityB)
                      .compareTo(getPriorityValue(priorityA));
                });

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: sortedDocs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data =
                          sortedDocs[index].data() as Map<String, dynamic>;
                      TaskModel eachModel = TaskModel.fromDoc(data);

                      var myformat = DateFormat.yMMMMEEEEd();

                      String assignTime = "";
                      if (eachModel.assignedAt != null &&
                          eachModel.assignedAt.toString().isNotEmpty) {
                        int? assignedAtMillis =
                            int.tryParse(eachModel.assignedAt.toString());
                        if (assignedAtMillis != null) {
                          assignTime = myformat.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  assignedAtMillis));
                        }
                      }

                      String completedTime = "";
                      if (eachModel.completedAt != null &&
                          eachModel.completedAt.toString().isNotEmpty) {
                        int? completedAtMillis =
                            int.tryParse(eachModel.completedAt.toString());
                        if (completedAtMillis != null) {
                          completedTime = myformat.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  completedAtMillis));
                        }
                      }

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: getPriorityColor(eachModel.priority.toString()),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Colors.amber.shade700,
                                side: BorderSide(color: Colors.white),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eachModel.title.toString(),
                                        style: TextStyle(color: Colors.black)
                                            .copyWith(
                                                decoration: eachModel
                                                        .isCompleted!
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    InkWell(
                                        onTap: () {
                                          firestore
                                              .collection(COLLECTION_USER_KEY)
                                              .doc(uid)
                                              .collection(COLLECTION_TODO_KEY)
                                              .doc(eachModel.todoId)
                                              .delete();
                                        },
                                        child: Icon(Icons.delete))
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eachModel.subtitle.toString(),
                                        style: TextStyle(color: Colors.black)
                                            .copyWith(
                                                decoration: eachModel
                                                        .isCompleted!
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    if (!eachModel.isCompleted!)
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return UpdateToDoTask(
                                                    task: eachModel);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.update))
                                  ],
                                ),
                                checkColor: Colors.white,
                                value: eachModel.isCompleted,
                                onChanged: (value) {
                                  if (value != null) {
                                    String completedAt = value
                                        ? DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString()
                                        : "";

                                    firestore
                                        .collection('users')
                                        .doc(uid)
                                        .collection(COLLECTION_TODO_KEY)
                                        .doc(eachModel.todoId)
                                        .update({
                                      "isCompleted": value,
                                      "completedAt": completedAt,
                                    });

                                    showCompletionDialogBox(context, value);
                                  }
                                },
                              ),
                              if (assignTime.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    "Assigned at: $assignTime",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              if (completedTime.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    "Completed at: $completedTime",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddToDoTask();
              },
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.amber.shade700,
      ),
    );
  }
}
