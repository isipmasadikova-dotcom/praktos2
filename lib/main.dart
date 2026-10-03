import 'package:flutter/material.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Заметки',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF42A5F5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF2F8FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF90CAF9),
          foregroundColor: Color(0xFF12334A),
          centerTitle: true,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFBBDEFB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
          ),
        ),
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  final List<String> _notes = <String>[];

  @override
  void dispose() {
    _noteController.dispose();
    _editController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final String text = _noteController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Введите текст заметки')));
      return;
    }

    setState(() {
      _notes.add(text);
      _noteController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _editNote(int index) async {
    _editController.text = _notes[index];

    final String? editedText = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Редактирование заметки'),
          content: TextField(
            key: const Key('editNoteField'),
            controller: _editController,
            autofocus: true,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(hintText: 'Текст заметки'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Отмена'),
            ),
            FilledButton(
              key: const Key('confirmEditButton'),
              onPressed: () {
                final String value = _editController.text.trim();
                if (value.isNotEmpty) {
                  Navigator.pop(dialogContext, value);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );

    if (editedText != null && mounted) {
      setState(() => _notes[index] = editedText);
    }
  }

  Future<void> _deleteNote(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Удалить заметку'),
          content: const Text('Вы уверены, что хотите удалить эту заметку?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              key: const Key('confirmDeleteButton'),
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() => _notes.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заметки'),
        leading: const Center(
          child: Text('📝', style: TextStyle(fontSize: 24)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                key: const Key('newNoteField'),
                controller: _noteController,
                minLines: 2,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: 'Новая заметка',
                  hintText: 'Введите текст...',
                  prefixIcon: Center(
                    widthFactor: 1,
                    child: Text('📒', style: TextStyle(fontSize: 22)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                key: const Key('saveNoteButton'),
                onPressed: _saveNote,
                icon: const Text('💾', style: TextStyle(fontSize: 18)),
                label: const Text('Сохранить'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Заметки (${_notes.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF12334A),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _notes.isEmpty
                    ? const _EmptyNotes()
                    : ListView.separated(
                        itemCount: _notes.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Color(0xFFBBDEFB)),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.fromLTRB(
                                16,
                                8,
                                6,
                                8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFFE3F2FD),
                                foregroundColor: const Color(0xFF1976D2),
                                child: Text('${index + 1}'),
                              ),
                              title: Text(_notes[index]),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    key: Key('editNote$index'),
                                    tooltip: 'Редактировать',
                                    onPressed: () => _editNote(index),
                                    icon: const Text(
                                      '✏️',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    color: const Color(0xFF1976D2),
                                  ),
                                  IconButton(
                                    key: Key('deleteNote$index'),
                                    tooltip: 'Удалить',
                                    onPressed: () => _deleteNote(index),
                                    icon: const Text(
                                      '🗑️',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    color: Colors.redAccent,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyNotes extends StatelessWidget {
  const _EmptyNotes();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('📝', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 12),
          Text(
            'Заметок пока нет',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}
