import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/customs/custom.dart';
import 'package:todolist/provider/taskprovider.dart';
import 'package:todolist/screens/addtask.dart';
import 'package:todolist/screens/updatetask.dart';

class Taskscreen extends StatelessWidget {
  const Taskscreen({
    super.key,
  }); // Fixed constructor name from 'new' to 'Taskscreen'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the modal bottom sheet for adding a new task
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return const AddTask();
            },
          );
        },
        backgroundColor: Colors.red[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Colors.teal,
      body: Container(
        // padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Icon and App Title
            const Row(
              children: [
                Icon(Icons.playlist_add_check, size: 40, color: Colors.white),
                Text(
                  "ToDayDo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Consumer<TaskProvider>(
              builder: (context, value, child) {
                return IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    value.getAllData();
                  },
                );
              },
            ),
            Consumer<TaskProvider>(
              builder: (context, value, child) {
                final total = value.datamodel?.result.length ?? 0;
                return Text(
                  "$total Tasks",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                );
              },
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Consumer<TaskProvider>(
                  builder: (context, value, child) {
                    var data = value.datamodel?.result;
                    if (data == null) {
                      value.getAllData();
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        itemCount: data
                            .length, // Added itemCount to prevent RangeError
                        itemBuilder: (context, index) {
                          return TaskTile(
                            taskTitle: data[index].title,
                            onEdit: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  return UpdateTask(
                                    id: data[index].id,
                                    oldTitle: data[index].title,
                                  );
                                },
                              );
                            },
                            onDelete: () {
                              value.deleteTask(data[index].id);
                            }, // Closed onDelete callback
                          ); //
                        }, // Closed itemBuilder
                      ); // Closed ListView.builder
                    } // Closed else
                  }, // Closed Consumer builder
                ), // Closed Consumer
              ), // Closed Container
            ), // Closed Expanded
          ], // Closed Column children
        ), // Closed Column
      ), // Closed body Container
    ); // Closed Scaffold
  } // Closed build method
} // Closed Taskscreen class
