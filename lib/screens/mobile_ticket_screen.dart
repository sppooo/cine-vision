import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/movie.dart';

class MobileTicketScreen extends StatelessWidget {
  final Movie movie;
  final String date;
  final String time;
  final String theatre;
  final List<String> selectedSeats;

  const MobileTicketScreen({
    Key? key,
    required this.movie,
    required this.date,
    required this.time,
    required this.theatre,
    required this.selectedSeats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Actual data based on the image
    const bookingId = "SRCM0000076256";
    const confirmationNumber = "76256";
    const paymentMethod = "Amazon Pay";
    const bookingDateTime = "Wed, 11 June, 2025 ";
    const double ticketAmount = 100.00;
    const double internetFees = 32.92;

    final ticketData = '''
Movie: ${movie.title}
Theatre: $theatre
Date: $date
Time: $time
Seats: ${selectedSeats.join(', ')}
Booking ID: $bookingId
''';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1C),
      appBar: AppBar(
        title: const Text("Your Ticket"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E2746), Color(0xFF121726)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Your booking is confirmed!",
                    style: TextStyle(color: Colors.deepOrange[200], fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "Booking ID $bookingId",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      movie.posterPath,
                      width: 160,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTicketInfo("🎬", "Movie", movie.title),
                _buildTicketInfo("📍", "Theatre", theatre),
                _buildTicketInfo("📅", "Date", date),
                _buildTicketInfo("⏰", "Time", time),
                _buildTicketInfo("💺", "Seats", selectedSeats.join(', ')),
                _buildTicketInfo("🎟️", "Tickets", "${selectedSeats.length}"),
                const SizedBox(height: 16),

                const Divider(color: Colors.white24),
                const SizedBox(height: 8),

                // Order Summary
                const Text("Order Summary", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                _buildSummaryRow("Ticket Amount", "Rs. ${ticketAmount.toStringAsFixed(2)}"),
                _buildSummaryRow("Internet Handling Fees", "Rs. ${internetFees.toStringAsFixed(2)}"),
                const Divider(color: Colors.white24),
                _buildSummaryRow("Amount Paid", "Rs. ${(ticketAmount + internetFees).toStringAsFixed(2)}"),
                const SizedBox(height: 16),

                // Payment Info
                _buildTicketInfo("📅", "Booking Date & Time", bookingDateTime),
                _buildTicketInfo("💳", "Payment Type", paymentMethod),
                _buildTicketInfo("🔖", "Confirmation #", confirmationNumber),
                const SizedBox(height: 16),

                // QR Code
                Center(
                  child: QrImageView(
                    data: ticketData,
                    version: QrVersions.auto,
                    size: 180,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Done Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.check, color: Colors.black),
                    label: const Text(
                      "Done",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Instructions
                const Text(
                  "IMPORTANT INSTRUCTIONS",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "1. Please collect physical ticket from the box office.\n"
                      "2. Please carry your CC/DC card which was used for booking tickets.\n"
                      "3. Only BookMyShow server messages are allowed. Printed and forwarded messages are not allowed.\n"
                      "4. Children aged 5 and above will require a separate ticket.\n"
                      "This transaction cannot be cancelled as per cinema cancellation policy.",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketInfo(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "$emoji $label: $value",
        style: const TextStyle(
          color: Colors.deepOrangeAccent,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
