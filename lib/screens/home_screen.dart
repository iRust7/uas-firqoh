import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/hive_boxes.dart';
import '../models/note.dart';
import '../utils/note_filter.dart';
import '../widgets/note_card.dart';
import 'note_detail_screen.dart';
import 'note_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGridMode = false;
  NoteFilter _currentFilter = NoteFilter.pinned;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentFilter = NoteFilterExtension.fromValue(
        prefs.getString('noteFilter') ?? 'pinned',
      );
    });
  }

  Future<void> _saveFilter(NoteFilter filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('noteFilter', filter.value);
    setState(() {
      _currentFilter = filter;
    });
  }

  void _toggleViewMode() {
    setState(() {
      _isGridMode = !_isGridMode;
    });
  }

  List<Note> _getSortedNotes(Box<Note> box) {
    final notes = box.values.toList();
    
    switch (_currentFilter) {
      case NoteFilter.pinned:
        // Pinned first, then by updated date (newest first)
        notes.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.updatedAt.compareTo(a.updatedAt);
        });
        break;
      
      case NoteFilter.alphabetical:
        // A-Z by title
        notes.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      
      case NoteFilter.newestFirst:
        // Recently updated first
        notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      
      case NoteFilter.oldestFirst:
        // Oldest updated first
        notes.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
    }
    
    return notes;
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Sort Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...NoteFilter.values.map((filter) => ListTile(
            leading: Icon(
              _currentFilter == filter ? Icons.check : Icons.sort,
              color: _currentFilter == filter ? Theme.of(context).primaryColor : null,
            ),
            title: Text(filter.displayName),
            onTap: () {
              _saveFilter(filter);
              Navigator.pop(context);
            },
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filter and toggle buttons at top
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Filter button
                OutlinedButton.icon(
                  icon: const Icon(Icons.filter_list),
                  label: Text(_currentFilter.displayName),
                  onPressed: _showFilterMenu,
                ),
                // View mode toggle
                IconButton(
                  icon: Icon(_isGridMode ? Icons.view_list : Icons.grid_view),
                  onPressed: _toggleViewMode,
                  tooltip: _isGridMode ? 'List View' : 'Grid View',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: HiveBoxes.notesBox.listenable(),
              builder: (context, Box<Note> box, _) {
                if (box.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notes yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to create your first note',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final notes = _getSortedNotes(box);

                if (_isGridMode) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return NoteCard(
                        note: note,
                        isGridMode: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NoteDetailScreen(note: note),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      note: note,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NoteDetailScreen(note: note),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NoteFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
