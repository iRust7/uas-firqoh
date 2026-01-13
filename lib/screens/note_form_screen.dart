import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/hive_boxes.dart';
import '../models/note.dart';
import '../utils/note_colors.dart';
import '../widgets/color_picker_widget.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;

  const NoteFormScreen({super.key, this.note});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _tagController;
  late TextEditingController _contentController;
  late bool _isPinned;
  int _selectedColorIndex = 0;

  bool get isEditMode => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _tagController = TextEditingController(text: widget.note?.tag ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _isPinned = widget.note?.isPinned ?? false;
    _selectedColorIndex = widget.note?.colorIndex ?? 0;

    if (!isEditMode) {
      _loadDefaultColor();
    }
  }

  Future<void> _loadDefaultColor() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedColorIndex = prefs.getInt('defaultColorIndex') ??  0;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final tag = _tagController.text.trim();
    final content = _contentController.text.trim();

    if (isEditMode) {
      final updatedNote = widget.note!.copyWith(
        title: title,
        content: content,
        tag: tag,
        isPinned: _isPinned,
        colorIndex: _selectedColorIndex,
      );
      // Update timestamp manually
      updatedNote.updatedAt = DateTime.now().millisecondsSinceEpoch;
      await updatedNote.save();
    } else {
      final newNote = Note.create(
        title: title,
        content: content,
        tag: tag,
        isPinned: _isPinned,
        colorIndex: _selectedColorIndex,
      );
      await HiveBoxes.notesBox.add(newNote);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final noteColor = NoteColors.getColor(_selectedColorIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _handleSave,
            tooltip: 'Save',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tagController,
              decoration: InputDecoration(
                labelText: 'Tag',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.label),
                hintText: 'e.g., Flutter, Study, Work',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a tag';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 10,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter content';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ColorPickerWidget(
                  selectedColorIndex: _selectedColorIndex,
                  onColorSelected: (colorIndex) {
                    setState(() {
                      _selectedColorIndex = colorIndex;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: SwitchListTile(
                title: const Text('Pin Note'),
                subtitle: const Text('Pinned notes appear first'),
                value: _isPinned,
                onChanged: (value) {
                  setState(() {
                    _isPinned = value;
                  });
                },
                secondary: Icon(
                  _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: _isPinned ? Colors.orange : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _handleSave,
                icon: const Icon(Icons.save),
                label: Text(isEditMode ? 'Update Note' : 'Save Note'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
