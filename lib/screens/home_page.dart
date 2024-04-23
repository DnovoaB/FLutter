import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_app/providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'task_detail_page.dart';

class HomePage extends StatelessWidget {
 const HomePage({Key? key}) : super(key: key);

 // Función auxiliar para formatear la hora
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
        title: Text(
          'App de Tareas',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/task-list');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                    Text(
                      'Tareas Pendientes',
                      style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.blue[900],
                      child: Text(
                        '${taskProvider.pendingTasks.length}',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                 ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.pendingTasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.pendingTasks[index];
                return Padding(
                 padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                 ),
                 child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4.0,
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
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
                            color: Colors.blue[900],
                          ),
                          // IconButton para eliminar tareas eliminado
                        ],
                      ),
                    ),
                 ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/task-list', arguments: null);
              },
              backgroundColor: Colors.white, // Fondo blanco
              foregroundColor: Colors.blue, // Color del icono
              elevation: 0.0, // Elimina la sombra predeterminada
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.blue, width: 2.0), // Borde azul
              ),
              child: Icon(Icons.note), // Icono de hoja escrita
            ),
          ),
          Positioned(
            bottom: 70.0,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/task-detail', arguments: null);
              },
              backgroundColor: Colors.white, // Fondo blanco
              foregroundColor: Colors.blue, // Color del icono
              elevation: 0.0, // Elimina la sombra predeterminada
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.blue, width: 2.0), // Borde azul
              ),
              child: Icon(Icons.add), // Icono de signo de más
            ),
          ),
        ],
      ),
    );
 }
}
