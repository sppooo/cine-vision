import 'package:flutter/material.dart';
import '../models/movie.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Movie movie;
  final String date;
  final String time;
  final String theatre;

  const SeatSelectionScreen({
    Key? key,
    required this.movie,
    required this.date,
    required this.time,
    required this.theatre,
  }) : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  int? numberOfSeats;
  final List<String> selectedSeats = [];

  final List<String> regularRows = ['A', 'B', 'C'];
  final List<String> balconyRows = ['D', 'E', 'F', 'G'];
  final List<String> premiumRows = ['H', 'I'];

  final int seatsPerRow = 10;

  final Set<String> soldSeats = {
    'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8',
    'B5', 'B6', 'C3', 'C4', 'D1', 'D2', 'E3', 'E4', 'F5',
    'G6', 'H7', 'I8', 'I9', 'I10'
  };

  final Set<String> availableSeats = {
    for (var row in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'])
      for (var i = 1; i <= 10; i++)
        if (!{
          'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8',
          'B5', 'B6', 'C3', 'C4', 'D1', 'D2', 'E3', 'E4', 'F5',
          'G6', 'H7', 'I8', 'I9', 'I10'
        }.contains('$row$i')) '$row$i',
  };

  final Map<String, int> sectionPrices = {
    'A': 200, 'B': 200, 'C': 200,
    'D': 300, 'E': 300, 'F': 300, 'G': 300,
    'H': 400, 'I': 400,
  };

  int getTotalPrice() {
    int total = 0;
    for (var seat in selectedSeats) {
      String row = seat[0];
      total += sectionPrices[row] ?? 0;
    }
    return total;
  }

  void toggleSeat(String seatId) {
    if (!availableSeats.contains(seatId)) return;
    setState(() {
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId);
      } else {
        if (selectedSeats.length < (numberOfSeats ?? 0)) {
          selectedSeats.add(seatId);
        }
      }
    });
  }

  Widget buildCurvedScreen() {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white24, Colors.white12]),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(300, 40),
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        'SCREEN',
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildSection(String title, List<String> rows, Color labelColor, int price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title - ₹$price',
          style: TextStyle(
            color: labelColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        ...rows.map((row) => buildSeatRow(row)).toList(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildSeatRow(String row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(seatsPerRow, (i) {
        final seatId = '$row${i + 1}';
        final isSold = soldSeats.contains(seatId);
        final isAvailable = availableSeats.contains(seatId);
        final isSelected = selectedSeats.contains(seatId);

        return GestureDetector(
          onTap: () => toggleSeat(seatId),
          child: Container(
            margin: const EdgeInsets.all(4),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: isSold
                  ? Colors.grey.shade300
                  : isSelected
                  ? Colors.deepOrangeAccent
                  : Colors.grey.shade700,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isSold ? Colors.grey.shade500 : Colors.white30,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: Colors.deepOrangeAccent.withOpacity(0.5),
                  blurRadius: 4,
                ),
              ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              '${i + 1}',
              style: TextStyle(
                color: isSold
                    ? Colors.black54
                    : isAvailable
                    ? (isSelected ? Colors.black : Colors.white70)
                    : Colors.grey,
                fontSize: 10,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildLegendBox(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final seatOptions = List.generate(6, (index) => index + 1);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1C),
      appBar: AppBar(
        title: const Text('Select Seats'),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              '${widget.movie.title}\n${widget.date}, ${widget.time}\n${widget.theatre}',
              style: TextStyle(
                color: Colors.deepOrange[200],
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Text(
                  'Select number of seats:',
                  style: TextStyle(color: Colors.deepOrange[200], fontSize: 16),
                ),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  dropdownColor: Colors.deepOrange[200],
                  value: numberOfSeats,
                  hint: Text('Choose', style: TextStyle(color: Colors.deepOrange[200])),
                  items: seatOptions.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value', style: const TextStyle(color: Colors.deepOrangeAccent)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      numberOfSeats = value;
                      selectedSeats.clear();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            buildCurvedScreen(),

            if (numberOfSeats != null)
              Expanded(
                child: ListView(
                  children: [
                    buildSection('Regular', regularRows, Colors.deepOrangeAccent, 200),
                    buildSection('First Balcony', balconyRows, Colors.deepOrangeAccent, 300),
                    buildSection('Premium', premiumRows, Colors.deepOrangeAccent, 400),
                  ],
                ),
              ),

            if (selectedSeats.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Total: ₹${getTotalPrice()}',
                style: TextStyle(
                  color: Colors.deepOrange[200],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLegendBox(Colors.grey.shade700, 'Available'),
                const SizedBox(width: 10),
                buildLegendBox(Colors.deepOrangeAccent, 'Selected'),
                const SizedBox(width: 10),
                buildLegendBox(Colors.grey.shade300, 'Sold'),
              ],
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: selectedSeats.length == numberOfSeats && numberOfSeats != null
                  ? () {
                Navigator.pushNamed(
                  context,
                  '/payment',
                  arguments: {
                    'movie': widget.movie,
                    'date': widget.date,
                    'time': widget.time,
                    'theatre': widget.theatre,
                    'selectedSeats': selectedSeats,
                    'totalAmount': getTotalPrice(),
                  },
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange[200],
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                disabledBackgroundColor: Colors.grey.shade800,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              child: const Text('Confirm Booking', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
