import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/hive_boxes.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'note_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<Note> _getNotesForDay(DateTime day) {
    final notes = HiveBoxes.notesBox.values.toList();
    return notes.where((note) {
      final noteDate = DateTime.fromMillisecondsSinceEpoch(note.updatedAt);
      return isSameDay(noteDate, day);
    }).toList();
  }

  Map<DateTime, List<Note>> _getEventMap() {
    final notes = HiveBoxes.notesBox.values.toList();
    final Map<DateTime, List<Note>> events = {};
    
    for (final note in notes) {
      final noteDate = DateTime.fromMillisecondsSinceEpoch(note.updatedAt);
      final dateKey = DateTime(noteDate.year, noteDate.month, noteDate.day);
      
      if (events[dateKey] == null) {
        events[dateKey] = [];
      }
      events[dateKey]!.add(note);
    }
    
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveBoxes.notesBox.listenable(),
      builder: (context, Box<Note> box, _) {
        final selectedNotes = _selectedDay != null ? _getNotesForDay(_selectedDay!) : [];
        final eventMap = _getEventMap();

        return Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarFormat: CalendarFormat.month,
                eventLoader: (day) {
                  final dateKey = DateTime(day.year, day.month, day.day);
                  return eventMap[dateKey] ?? [];
                },
                calendarStyle: CalendarStyle(
                  markersMaxCount: 3,
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _selectedDay != null
                    ? 'Notes on ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}'
                    : 'Select a date',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: selectedNotes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_note,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notes on this date',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: selectedNotes.length,
                      itemBuilder: (context, index) {
                        final note = selectedNotes[index];
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
                    ),
            ),
          ],
        );
      },
    );
  }
}
