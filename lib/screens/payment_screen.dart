import 'package:flutter/material.dart';
import '../models/movie.dart';

class PaymentScreen extends StatefulWidget {
  final Movie movie;
  final String date;
  final String time;
  final String theatre;
  final List<String> selectedSeats;
  final int totalAmount;

  const PaymentScreen({
    Key? key,
    required this.movie,
    required this.date,
    required this.time,
    required this.theatre,
    required this.selectedSeats,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'Card';
  final cardNumberController = TextEditingController();
  final upiController = TextEditingController();
  double walletBalance = 10000.00;

  double discount = 0.0;
  String? selectedCoupon;
  String? selectedUpiApp;

  final List<Map<String, dynamic>> coupons = [
    {'code': 'SAVE50', 'label': 'SAVE50 - ₹50 Off', 'discount': 50.0},
    {'code': 'CINE100', 'label': 'CINE100 - ₹100 Off', 'discount': 100.0},
    {'code': 'MOVIE30', 'label': 'MOVIE30 - ₹30 Off', 'discount': 30.0},
    {'code': 'FESTIVE75', 'label': 'FESTIVE75 - ₹75 Off', 'discount': 75.0},
  ];

  final List<Map<String, dynamic>> upiApps = [
    {'name': 'GPay', 'icon': Icons.phone_android},
    {'name': 'PhonePe', 'icon': Icons.payment},
    {'name': 'Paytm', 'icon': Icons.account_balance_wallet},
  ];

  @override
  void dispose() {
    cardNumberController.dispose();
    upiController.dispose();
    super.dispose();
  }

  bool isPaymentValid() {
    double total = widget.totalAmount - discount;
    switch (selectedMethod) {
      case 'Card':
        return cardNumberController.text.length == 16;
      case 'UPI':
        return upiController.text.contains('@') && selectedUpiApp != null;
      case 'Wallet':
        return walletBalance >= total;
      default:
        return false;
    }
  }

  void handlePayment() {

    double total = widget.totalAmount - discount;
    if (!isPaymentValid()) return;

    setState(() {
      if (selectedMethod == 'Wallet') {
        walletBalance -= total;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Successful!', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.deepOrangeAccent,
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      Navigator.pushNamed(
        context,
        '/ticket',
        arguments: {
          'movie': widget.movie,
          'date': widget.date,
          'time': widget.time,
          'theatre': widget.theatre,
          'selectedSeats': widget.selectedSeats,
          'paymentMethod': selectedMethod,
          'ticketAmount': widget.totalAmount.toDouble() - discount,
        },
      );

    });
  }

  Widget buildBillDetails() {
    double baseAmount = widget.totalAmount.toDouble();
    double finalAmount = baseAmount - discount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepOrangeAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bill Summary', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ticket Price:', style: TextStyle(color: Colors.white)),
              Text('₹${widget.totalAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quantity:', style: TextStyle(color: Colors.white)),
              Text('${widget.selectedSeats.length}', style: const TextStyle(color: Colors.white)),
            ],
          ),
          const Divider(color: Colors.white24, thickness: 0.6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal:', style: TextStyle(color: Colors.white)),
              Text('₹${baseAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Discount:', style: TextStyle(color: Colors.deepOrangeAccent)),
              Text('- ₹${discount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.deepOrangeAccent)),
            ],
          ),
          const Divider(color: Colors.white30, thickness: 0.8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total to Pay:', style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold)),
              Text('₹${finalAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPaymentInput() {
    switch (selectedMethod) {
      case 'Card':
        return TextField(
          controller: cardNumberController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            labelText: 'Card Number',
            labelStyle: TextStyle(color: Colors.deepOrangeAccent),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepOrangeAccent)),
          ),
        );
      case 'UPI':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: upiController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: 'Enter UPI ID',
                labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepOrangeAccent)),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Choose UPI App:', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedUpiApp,
              dropdownColor: Colors.black,
              decoration: const InputDecoration(
                labelText: 'Select UPI App',
                labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepOrangeAccent)),
              ),
              items: upiApps.map((upiApp) {
                return DropdownMenuItem<String>(
                  value: upiApp['name'],
                  child: Row(
                    children: [
                      Icon(upiApp['icon'], color: Colors.deepOrange[200]),
                      const SizedBox(width: 10),
                      Text(upiApp['name'], style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUpiApp = value;
                });
              },
            ),
          ],
        );
      case 'Wallet':
        return Text(
          'Wallet Balance: ₹${walletBalance.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.deepOrangeAccent, fontSize: 16),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildPaymentMethodRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment Method',
          style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16),
        ),
        const SizedBox(height: 8),
        RadioListTile<String>(
          value: 'Card',
          groupValue: selectedMethod,
          onChanged: (value) => setState(() => selectedMethod = value!),
          title: const Text('Card Payment', style: TextStyle(color: Colors.black)),
          activeColor: Colors.deepOrangeAccent,
          tileColor: Colors.deepOrange[200],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        RadioListTile<String>(
          value: 'UPI',
          groupValue: selectedMethod,
          onChanged: (value) => setState(() => selectedMethod = value!),
          title: const Text('UPI Payment', style: TextStyle(color: Colors.black)),
          activeColor: Colors.deepOrangeAccent,
          tileColor: Colors.deepOrange[200],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        RadioListTile<String>(
          value: 'Wallet',
          groupValue: selectedMethod,
          onChanged: (value) => setState(() => selectedMethod = value!),
          title: const Text('Wallet', style: TextStyle(color: Colors.black)),
          activeColor: Colors.deepOrangeAccent,
          tileColor: Colors.deepOrange[200],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1C),
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.movie.posterPath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Pay for ${widget.movie.title}',
              style: TextStyle(
                color: Colors.deepOrange[200],
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            buildBillDetails(),
            DropdownButtonFormField<String>(
              value: selectedCoupon,
              dropdownColor: Colors.deepOrangeAccent,
              decoration: const InputDecoration(
                labelText: 'Select Discount Coupon',
                labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrangeAccent),
                ),
              ),
              items: coupons.map((coupon) {
                return DropdownMenuItem<String>(
                  value: coupon['code'],
                  child: Text(coupon['label'], style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCoupon = value;
                  discount = coupons.firstWhere((coupon) => coupon['code'] == value)['discount'];
                });
              },
            ),
            const SizedBox(height: 24),
            buildPaymentMethodRadioButtons(),
            const SizedBox(height: 16),
            buildPaymentInput(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isPaymentValid() ? handlePayment : null,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange[200],
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              child: const Text('Confirm Payment', style: TextStyle(color: Colors.black)),

            ),
          ],
        ),
      ),
    );
  }
}
