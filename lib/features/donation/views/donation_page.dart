// ignore_for_file: deprecated_member_use, prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mucharity/features/campaigns/models/campaign.dart';
import 'package:mucharity/features/donation/models/donation.dart';
import 'package:mucharity/features/donation/providers/donation_providers.dart';

class DonationPage extends ConsumerStatefulWidget {
  final CampaignDetail campaign;

  const DonationPage({Key? key, required this.campaign}) : super(key: key);

  @override
  ConsumerState<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends ConsumerState<DonationPage> {
  bool _isLoading = false;
  final TextEditingController _customAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = widget.campaign.donationSettings;
      if (settings.givingLevels.isNotEmpty) {
        final defaultLevel = settings.givingLevels.first;
        ref
            .read(donationFormProvider.notifier)
            .selectGivingLevel(defaultLevel.id, defaultLevel.amount);
      } else {
        ref
            .read(donationFormProvider.notifier)
            .setAmount(settings.minimumDonationAmount);
      }
    });
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  Future<void> _submitDonation() async {
    const minAmount = 5.0;
    final formData = ref.read(donationFormProvider);

    if (formData.amount < minAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Minimum donation amount is \$$minAmount')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(donationRepositoryProvider);
      final request = DonationRequest(
        campaignSlug: widget.campaign.slug,
        amount: formData.amount,
        donationType: formData.type.apiValue,
      );

      final response = await repository.submitDonation(request);

      if (mounted) {
        context.pushReplacement('/donation-success', extra: response);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Donation failed: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(donationFormProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9F6),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 16, color: Colors.black87),
            ),
            onPressed: () => context.pop(),
          ),
        ),
        title: const Text(
          'Your donation',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Scrollable Form Content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Text
                const Text(
                  'Make a difference.',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.1),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose how you’d like to give.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),

                // Campaign Mini Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.campaign.coverImage,
                          height: 75,
                          width: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.campaign.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.campaign.organizer.name,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Donation Frequency
                const Text('Donation frequency',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => ref
                              .read(donationFormProvider.notifier)
                              .setDonationType(DonationType.oneTime),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: formData.type == DonationType.oneTime
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: formData.type == DonationType.oneTime
                                  ? [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2))
                                    ]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Give once',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: formData.type == DonationType.oneTime
                                    ? const Color(0xFF4A7C59)
                                    : const Color.fromARGB(255, 193, 193, 193),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => ref
                              .read(donationFormProvider.notifier)
                              .setDonationType(DonationType.recurring),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: formData.type == DonationType.recurring
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: formData.type == DonationType.recurring
                                  ? [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2))
                                    ]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Recurring',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: formData.type == DonationType.recurring
                                    ? const Color(0xFF4A7C59)
                                    : const Color.fromARGB(255, 193, 193, 193),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Choose your impact cards
                const Text('Choose your impact',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 12),
                ...widget.campaign.donationSettings.givingLevels.map((level) {
                  final isSelected = formData.selectedGivingLevelId == level.id;
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(donationFormProvider.notifier)
                          .selectGivingLevel(level.id, level.amount);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF4A7C59)
                              : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: isSelected
                                ? const Color(0xFF4A7C59)
                                : Colors.grey[400],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level.label,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black87),
                                ),
                                if (level.description != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    level.description!,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Text(
                            '\$${level.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or choose your own amount',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 16),

                // Custom Amount
                TextField(
                  controller: _customAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    suffixText: 'USD',
                    suffixStyle: TextStyle(
                        color: Colors.grey[500], fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFF4A7C59), width: 1.5)),
                  ),
                  onChanged: (value) {
                    final amount = double.tryParse(value);
                    if (amount != null) {
                      ref
                          .read(donationFormProvider.notifier)
                          .setCustomAmount(amount);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Floating Button
          Positioned(
            bottom: 8,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C4A3E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                onPressed: _isLoading ? null : _submitDonation,
                child: _isLoading
                        .toString()
                        .contains('true') // fallback check if loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(
                            'Donate   \$${formData.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
