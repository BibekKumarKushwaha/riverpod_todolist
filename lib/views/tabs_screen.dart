// lib/views/tabs_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riverpod_todolist/models/task.dart';
import '../viewmodels/task_viewmodel.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['All', 'Active', 'Favourite', 'Done'];

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);

    List<Task> getFilteredTasks() {
      switch (_selectedIndex) {
        case 1:
          return taskViewModel.tasks.where((task) => !task.isCompleted).toList();
        case 2:
          return taskViewModel.tasks.where((task) => task.isFavorite).toList();
        case 3:
          return taskViewModel.tasks.where((task) => task.isCompleted).toList();
        default:
          return taskViewModel.tasks;
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                taskViewModel.addTask(value);
              }
            },
            decoration: InputDecoration(
              labelText: 'What do you want to do?',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Text('${taskViewModel.completedTasks} of ${taskViewModel.totalTasks} tasks completed'),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _tabs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      color: _selectedIndex == index ? Colors.green : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: getFilteredTasks().length,
            itemBuilder: (context, index) {
              final task = getFilteredTasks()[index];
              return ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => taskViewModel.toggleTaskStatus(task.id),
                ),
                trailing: IconButton(
                  icon: Icon(task.isFavorite ? Icons.star : Icons.star_border),
                  onPressed: () => taskViewModel.toggleFavoriteStatus(task.id),
                ),
                onLongPress: () => taskViewModel.removeTask(task.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
