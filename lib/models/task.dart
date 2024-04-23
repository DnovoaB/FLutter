import 'package:uuid/uuid.dart';

class Task {
 final String id;
 final String title;
 final String description;
 final DateTime dueDate;
 bool isCompleted;

 Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.isCompleted = false,
 });

 // Método para crear una nueva tarea con un ID único
 static Task createNewTask({
    required String title,
    String description = '',
    required DateTime dueDate,
 }) {
    return Task(
      id: Uuid().v4(), // Genera un ID único
      title: title,
      description: description,
      dueDate: dueDate,
    );
 }

 // Función auxiliar para formatear la hora
 String formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour < 12 ? 'AM' : 'PM';
    final formattedHour = hour % 12 == 0 ? 12 : hour % 12;
    final formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $period';
 }
}
