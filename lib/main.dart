import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const IsaacsTasksApp());

class IsaacsTasksApp extends StatelessWidget {
  const IsaacsTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Isaac's Tasks",
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)), useMaterial3: true),
      home: const TasksPage(),
    );
  }
}

class Task {
  Task(this.title, {this.done = false});
  final String title;
  bool done;
}

class Quote {
  const Quote(this.text, this.author);
  final String text;
  final String author;
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _controller = TextEditingController();
  final _tasks = <Task>[
    Task('Turn in CSC 305 Assignment 3', done: true),
    Task('Study for the Week 3 reflection', done: true),
    Task('Review Scrum user stories'),
  ];
  Quote? _quote;

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    try {
      final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));
      if (response.statusCode != 200) throw Exception('Quote request failed');
      final item = (jsonDecode(response.body) as List).first as Map<String, dynamic>;
      if (!mounted) return;
      setState(() => _quote = Quote(item['q'] as String, item['a'] as String));
    } catch (_) {
      if (!mounted) return;
      setState(() => _quote = const Quote('The secret of getting ahead is getting started.', 'Mark Twain'));
    }
  }

  void _addTask() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    setState(() => _tasks.add(Task(title)));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Isaac's Tasks", style: TextStyle(fontWeight: FontWeight.w700)),
        actions: const [Padding(padding: EdgeInsets.only(right: 20), child: CircleAvatar(child: Text('IG')))],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text('Make today count.', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const Text('Add a task, focus on one thing, and keep moving.'),
                const SizedBox(height: 24),
                Row(children: [
                  Expanded(child: TextField(controller: _controller, onSubmitted: (_) => _addTask(), decoration: const InputDecoration(labelText: 'What needs to be done?', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  FilledButton.icon(onPressed: _addTask, icon: const Icon(Icons.add), label: const Text('Add')),
                ]),
                const SizedBox(height: 18),
                ..._tasks.asMap().entries.map((entry) => Card(
                      child: CheckboxListTile(
                        value: entry.value.done,
                        title: Text(entry.value.title, style: TextStyle(decoration: entry.value.done ? TextDecoration.lineThrough : null)),
                        onChanged: (value) => setState(() => entry.value.done = value ?? false),
                        secondary: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() => _tasks.removeAt(entry.key))),
                      ),
                    )),
                const SizedBox(height: 24),
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: _quote == null
                        ? const Center(child: CircularProgressIndicator())
                        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Icon(Icons.format_quote, size: 34),
                            const SizedBox(height: 8),
                            Text(_quote!.text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 10),
                            Text('— ${_quote!.author}'),
                          ]),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Profile · Isaac Gbaba · Hometown: Providence', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
