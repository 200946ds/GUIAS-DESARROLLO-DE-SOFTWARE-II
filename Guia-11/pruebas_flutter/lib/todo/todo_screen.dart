import 'package:flutter/material.dart';
import 'task.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Task> _tasks = [];
  final _descController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.media;

  void _addTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const ValueKey('input_task_description'),
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TaskPriority>(
                key: const ValueKey('dropdown_priority'),
                value: _selectedPriority,
                items: TaskPriority.values
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.name.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedPriority = v);
                },
                decoration: const InputDecoration(
                  labelText: 'Prioridad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const ValueKey('btn_save_task'),
                  onPressed: () {
                    if (_descController.text.trim().isEmpty) return;
                    setState(() {
                      _tasks.add(Task(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        description: _descController.text.trim(),
                        priority: _selectedPriority,
                      ));
                      _descController.clear();
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Guardar'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _deleteTask(String id) {
    setState(() => _tasks.removeWhere((t) => t.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Tareas')),
      body: _tasks.isEmpty
          ? const Center(
              key: ValueKey('empty_state'),
              child: Text('No hay tareas. ¡Agrega una!'),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: ValueKey('task_${task.id}'),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteTask(task.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(task.description),
                    trailing: Chip(
                      key: ValueKey('chip_priority_${task.id}'),
                      label: Text(task.priority.name.toUpperCase()),
                      backgroundColor: switch (task.priority) {
                        TaskPriority.alta => Colors.red.shade100,
                        TaskPriority.media => Colors.orange.shade100,
                        TaskPriority.baja => Colors.green.shade100,
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('fab_add_task'),
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}