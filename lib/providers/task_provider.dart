import 'package:flutter/material.dart';
import 'package:task_app/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  List<Task> get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final taskIndex = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (taskIndex >= 0) {
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex >= 0) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      notifyListeners();
    }
  }
}
