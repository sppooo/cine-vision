import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  String selectedDate = '';
  String selectedTime = '';
  String selectedTheatre = '';

  final Map<String, List<String>> theatreTimings = {
    'PVR Cinemas': ['10:00 AM', '1:00 PM', '4:00 PM', '7:00 PM'],
    'INOX': ['10:00 AM', '1:00 PM', '4:00 PM', '7:00 PM'],
    'Cinepolis': ['10:00 AM', '1:00 PM', '4:00 PM', '7:00 PM'],
    'Carnival Cinemas': ['11:00 AM', '2:00 PM', '5:00 PM'],
    'Miraj Cinemas': ['9:30 AM', '12:30 PM', '3:30 PM', '6:30 PM'],
    'Mukta A2': ['10:45 AM', '1:45 PM', '4:45 PM'],
  };

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.deepOrangeAccent,
              onPrimary: Colors.black,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1E1E1E),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('MMMM d, yyyy').format(picked);
      });
    }
  }

  void _launchTrailer(String url) async {
    final Uri trailerUri = Uri.parse(url);
    if (await canLaunchUrl(trailerUri)) {
      await launchUrl(trailerUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch trailer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Text(widget.movie.title),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.movie.posterPath,
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.movie.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange[200],
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.movie.description,
              style: TextStyle(fontSize: 16, color: Colors.deepOrangeAccent),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _launchTrailer(widget.movie.trailerUrl),
              child: Row(
                children: [
                  Icon(Icons.play_circle_fill, color: Colors.deepOrange[200], size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Watch Trailer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepOrange[200],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Select Date'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepOrangeAccent),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.deepOrangeAccent, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      selectedDate.isEmpty ? 'Choose Date' : selectedDate,
                      style: TextStyle(
                        color: selectedDate.isEmpty ? Colors.deepOrangeAccent : Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Select Theatre & Time'),
            const SizedBox(height: 8),
            Column(
              children: _buildTheatreRows(),
            ),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: (selectedDate.isNotEmpty &&
                    selectedTime.isNotEmpty &&
                    selectedTheatre.isNotEmpty)
                    ? () {
                  Navigator.pushNamed(
                    context,
                    '/seats',
                    arguments: {
                      'movie': widget.movie,
                      'date': selectedDate,
                      'time': selectedTime,
                      'theatre': selectedTheatre,
                    },
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange[200],
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: const Text(
                  'Select Seats',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.deepOrange[200],
      ),
    );
  }

  List<Widget> _buildTheatreRows() {
    List<Widget> rows = [];
    List<String> theatreNames = theatreTimings.keys.toList();

    for (int i = 0; i < theatreNames.length; i += 2) {
      int endIndex = (i + 1 < theatreNames.length) ? i + 1 : i;
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTheatreCard(theatreNames[i]),
          const SizedBox(width: 16),
          if (endIndex != i) _buildTheatreCard(theatreNames[endIndex]),
        ],
      ));
    }

    return rows;
  }

  Widget _buildTheatreCard(String theatre) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selectedTheatre == theatre ? Colors.deepOrangeAccent : Colors.white10,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                theatre,
                style: const TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: theatreTimings[theatre]!.map((time) {
                  final isSelected = selectedTime == time && selectedTheatre == theatre;
                  return ChoiceChip(
                    label: Text(time),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedTime = time;
                        selectedTheatre = theatre;
                      });
                    },
                    selectedColor: Colors.deepOrange[200],
                    backgroundColor: Colors.white10,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.deepOrangeAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
