import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

final localData = Hive.box('userdata');

class Task {
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  // final Color color;
  bool completed;

  Task({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    // required this.color,
    this.completed = false,
  });
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Task> tasks = [];
  List addtask = [];
  @override
  void initState() {
    super.initState();
    addstarttask();
  }

  void addstarttask() {
    addtask = localData.get("TaskName") ?? [];
    for (var task in addtask) {
      tasks.add(
        Task(
          name: task["name"],
          description: task["description"],
          startDate: task["startDate"],
          endDate: task["endDate"],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: tasks.isNotEmpty
          ? ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Opacity(
                  opacity: tasks[index].completed ? 0.5 : 1.0,
                  child: Card(
                    color: tasks[index].completed
                        ? Colors.grey.shade700
                        : Colors.grey.shade800,
                    child: ListTile(
                      leading: Checkbox(
                        value: tasks[index].completed,
                        onChanged: (value) {
                          setState(() {
                            tasks[index].completed = value!;
                          });
                          _checkAllTasksCompleted();
                        },
                      ),
                      title: Text(
                        tasks[index].name,
                        style: TextStyle(
                          color: tasks[index].completed
                              ? Colors.white70
                              : Colors.white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tasks[index].description,
                            style: TextStyle(
                              color: tasks[index].completed
                                  ? Colors.white70
                                  : Colors.white,
                            ),
                          ),
                          Text(
                            'Start Date: ${DateFormat('yyyy-MM-dd hh:mm a').format(tasks[index].startDate)}',
                            style: TextStyle(
                              color: tasks[index].completed
                                  ? Colors.white70
                                  : Colors.white,
                            ),
                          ),
                          Text(
                            'End Date: ${DateFormat('yyyy-MM-dd hh:mm a').format(tasks[index].endDate)}',
                            style: TextStyle(
                              color: tasks[index].completed
                                  ? Colors.white70
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            tasks.removeAt(index);
                            addtask.removeAt(index);
                            localData.put("TaskName", addtask);
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text("No Task Found😀")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Task Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text('Start Date and Time:'),
                  subtitle: GestureDetector(
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        startTime = await showTimePicker(
                          // ignore: use_build_context_synchronously
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (startTime != null) {
                          setState(() {
                            startDateController.text =
                                _formatTime(selectedDate, startTime!);
                          });
                        }
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: startDateController,
                        decoration: const InputDecoration(
                            hintText: 'Select Start Date and Time'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text('End Date and Time:'),
                  subtitle: GestureDetector(
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        endTime = await showTimePicker(
                          // ignore: use_build_context_synchronously
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (endTime != null) {
                          setState(() {
                            endDateController.text =
                                _formatTime(selectedDate, endTime!);
                          });

                          // Check if end date and time is in the past
                          DateTime selectedDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            endTime!.hour,
                            endTime!.minute,
                          );
                          if (selectedDateTime.isBefore(DateTime.now())) {
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Warning'),
                                  content: const Text(
                                      'End date and time should not be in the past.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: endDateController,
                        decoration: const InputDecoration(
                            hintText: 'Select End Date and Time'),
                      ),
                    ),
                  ),
                ),
                // Add more fields for color selection, etc.
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    startDateController.text.isNotEmpty &&
                    endDateController.text.isNotEmpty) {
                  try {
                    // Parse dates
                    DateTime selectedStartDate =
                        DateFormat('yyyy-MM-dd hh:mm a')
                            .parse(startDateController.text);
                    DateTime selectedEndDate = DateFormat('yyyy-MM-dd hh:mm a')
                        .parse(endDateController.text);

                    // Check if end date and time is in the past
                    if (selectedEndDate.isBefore(DateTime.now())) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Warning'),
                            content: const Text(
                                'End date and time should not be in the past.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return; // Do not add task if end date and time is in the past
                    }

                    // Create a new Task object and add it to the list
                    setState(() {
                      tasks.add(
                        Task(
                          name: nameController.text,
                          description: descriptionController.text,
                          startDate: selectedStartDate,
                          endDate: selectedEndDate,
                          // color: Colors.blue,
                        ),
                      );
                      addtask.add({
                        "name": nameController.text,
                        "description": descriptionController.text,
                        "startDate": selectedStartDate,
                        "endDate": selectedEndDate
                      });
                      localData.put("TaskName", addtask);
                      // print(localData.get("Task"));
                    });

                    // Clear text controllers
                    nameController.clear();
                    descriptionController.clear();
                    startDateController.clear();
                    endDateController.clear();

                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid date format'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning'),
                        content: const Text('Please fill in all fields.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(DateTime date, TimeOfDay time) {
    // Format time
    String formattedTime =
        '${time.hour}:${time.minute} ${time.period == DayPeriod.am ? 'AM' : 'PM'}';

    // Concatenate date and time
    String formattedDateTime =
        '${DateFormat('yyyy-MM-dd').format(date)} $formattedTime';

    return formattedDateTime;
  }

  void _checkAllTasksCompleted() {
    bool allCompleted = tasks.every((task) => task.completed);
    if (allCompleted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Congratulations!'),
            content: const Text('All tasks completed. Well done!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    tasks.clear();
                    addtask.clear();
                    localData.put("TaskName", addtask);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
