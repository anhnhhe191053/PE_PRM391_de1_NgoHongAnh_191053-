import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_helper.dart';
import '../models/task_model.dart';

class TaskViewModel extends StateNotifier<List<Task>> {
  TaskViewModel() : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final tasks = await DatabaseHelper.instance.getTasks();
    state = tasks;
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper.instance.updateTask(task);
    await loadTasks();
  }
}

final taskProvider = StateNotifierProvider<TaskViewModel, List<Task>>((ref) {
  return TaskViewModel();
});