import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_app/providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'task_detail_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String formatDateTime(DateTime dateTime) {
    final String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    final String formattedTime = DateFormat('HH:mm').format(dateTime);
    final String period = dateTime.hour < 12 ? 'AM' : 'PM';
    final String formattedHour =
        dateTime.hour % 12 == 0 ? '12' : (dateTime.hour % 12).toString();
    final String formattedMinute = dateTime.minute.toString().padLeft(2, '0');
    return '$formattedDate $formattedHour:$formattedMinute $period';
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'Lista de Tareas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue[900],
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          return Dismissible(
            key: Key(task.id),
            onDismissed: (_) {
              taskProvider.deleteTask(task);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(
                  task.title,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.blue[900],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.description,
                      style: GoogleFonts.montserrat(
                        color: Colors.grey[700],
                        fontSize: 14.0,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.date_range, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Fecha de Entrega: ${DateFormat('dd/MM/yyyy').format(task.dueDate)}',
                          style: GoogleFonts.montserrat(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Hora de Entrega: ${DateFormat('HH:mm').format(task.dueDate)}',
                          style: GoogleFonts.montserrat(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(task.isCompleted
                          ? Icons.check_box
                          : Icons.check_box_outline_blank),
                      onPressed: () {
                        taskProvider.toggleTaskCompletion(task);
                        if (task.isCompleted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Tarea terminada'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailPage(
                                task: taskProvider.tasks[index],
                                isEditing: true),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        taskProvider.deleteTask(task);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
