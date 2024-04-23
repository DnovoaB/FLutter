import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/providers/task_provider.dart';
import 'package:uuid/uuid.dart';

class TaskDetailPage extends StatefulWidget {
  final Task? task;
  final bool isEditing;

  const TaskDetailPage({Key? key, this.task, this.isEditing = false})
      : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;

  // Función auxiliar para formatear la hora
  String formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour < 12 ? 'AM' : 'PM';
    final formattedHour = hour % 12 == 0 ? 12 : hour % 12;
    final formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $period';
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
      _selectTime(context);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate),
    );
    if (picked != null) {
      setState(() {
        _dueDate = DateTime(_dueDate.year, _dueDate.month, _dueDate.day,
            picked.hour, picked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Editar Tarea' : 'Nueva tarea',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titulo'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingresa un Titulo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripcion'),
              ),
              const SizedBox(height: 16.0),
              Text('Fecha de Entrega: ${formatTime(_dueDate)}'),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Colors.blue), // Cambia el color de fondo del botón
                  foregroundColor: MaterialStateProperty.all(Colors
                      .white), // Cambia el color del texto/icono del botón
                ),
                child: const Text('Selecciona fecha y hora'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      final taskId = widget.isEditing ? widget.task!.id : Uuid().v4();
      final updatedTask = Task(
        id: taskId,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
      );
      if (widget.isEditing) {
        taskProvider.updateTask(updatedTask);
      } else {
        taskProvider.addTask(updatedTask);
      }
      Navigator.pop(context);
    }
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.blue), // Cambia el color de fondo del botón
    foregroundColor: MaterialStateProperty.all(Colors.white), // Cambia el color del texto/icono del botón
  ),
  child: Text(widget.isEditing ? 'Modificar' : 'Crear'),
),

            ],
          ),
        ),
      ),
    );
  }
}
