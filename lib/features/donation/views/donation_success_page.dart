// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mucharity/features/donation/models/donation.dart';

class DonationSuccessPage extends StatelessWidget {
  final DonationResponse response;

  const DonationSuccessPage({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9F6),
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black87),
            ),
            onPressed: () => context.go('/'),
          ),
        ),
        title: const Text(
          'Confirmation',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color: const Color(0xFF4A7C59).withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, size: 52, color: Color(0xFF4A7C59)),
      ),
      const SizedBox(height: 20),
      const Text(
        'Thank you\nfor your kindness.',
        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF2C4A3E), height: 1.1),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 12),
      Text(
        'Your donation was submitted successfully.',
        style: TextStyle(fontSize: 20, color: Colors.grey[600]),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),

      // Summary Card
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            const Text(
              'THE DONATION CONFIRMED',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF4A7C59), letterSpacing: 1.1),
            ),
            const SizedBox(height: 12),
            Text(
              '\$${response.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF2C4A3E)),
            ),
            const SizedBox(height: 4),
            Text(
              '${response.donationType == 'one_time' ? 'One-time' : 'Recurring'} · ${response.currency}',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
            const Divider(height: 32),
            _buildDetailRow('Status', response.status.toUpperCase(), valueColor: const Color(0xFF4A7C59)),
            const SizedBox(height: 10),
            _buildDetailRow('Transaction ID', response.id.substring(0, 18)),
            const SizedBox(height: 10),
            _buildDetailRow('Date', response.createdAt.toLocal().toString().split('.').first),
          ],
        ),
      ),
    ],
  ),
), 
const SizedBox(height: 24),
              // Back to campaigns button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C4A3E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () => context.go('/'),
                  child: const Text('Back to campaigns', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: 16,
              color: valueColor ?? Colors.black87,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}