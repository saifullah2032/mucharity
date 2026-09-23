// ignore_for_file: curly_braces_in_flow_control_structures, non_constant_identifier_names, deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mucharity/features/campaigns/providers/campaign_providers.dart';
import 'package:mucharity/features/campaigns/views/widgets/campaign_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignsAsync = ref.watch(campaignsProvider);
    final featuredAsync = ref.watch(featuredCampaignsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9F6),
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Mucharity',
              style: TextStyle(
                  color: Color(0xFF2C4A3E),
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: const Color(0xFF4A7C59).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Give kindness',
                style: TextStyle(
                    color: Color(0xFF4A7C59),
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF4A7C59),
        onRefresh: () async {
          final _ = ref.refresh(campaignsProvider);
          final __ = ref.refresh(featuredCampaignsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7C59).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'GIVE KINDNESS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A7C59),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Small acts.\nReal change.',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C4A3E),
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Support a cause close to your heart.',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 70,
                      color: const Color(0xFF4A7C59).withOpacity(0.25),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Featured Campaigns Section
              const Text(
                'Featured Campaigns',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 300,
                child: featuredAsync.when(
                  data: (campaigns) {
                    if (campaigns.isEmpty)
                      return const Center(child: Text('No featured campaigns'));
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: campaigns.length,
                      itemBuilder: (context, index) {
                        return CampaignCard(
                          campaign: campaigns[index],
                          isHorizontal: true,
                          onTap: () => context
                              .push('/campaign/${campaigns[index].slug}'),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF4A7C59))),
                  error: (err, stack) =>
                      Center(child: Text('Error loading featured: $err')),
                ),
              ),
              const SizedBox(height: 24),

              // All Campaigns Section
              const Text(
                'All Campaigns',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 12),
              campaignsAsync.when(
                data: (campaigns) {
                  if (campaigns.isEmpty)
                    return const Center(child: Text('No campaigns available'));
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: campaigns.length,
                    itemBuilder: (context, index) {
                      return CampaignCard(
                        campaign: campaigns[index],
                        onTap: () =>
                            context.push('/campaign/${campaigns[index].slug}'),
                      );
                    },
                  );
                },
                loading: () => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4A7C59))),
                error: (err, stack) =>
                    Center(child: Text('Error loading campaigns: $err')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
