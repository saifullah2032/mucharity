// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mucharity/features/campaigns/models/campaign.dart';
import 'package:mucharity/features/campaigns/views/campaign_detail_page.dart';
import 'package:mucharity/features/campaigns/views/home_screen.dart';
import 'package:mucharity/features/donation/models/donation.dart';
import 'package:mucharity/features/donation/views/donation_page.dart';
import 'package:mucharity/features/donation/views/donation_success_page.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(const ProviderScope(child: MucharityApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'campaign/:slug',
          builder: (context, state) {
            final slug = state.pathParameters['slug']!;
            return CampaignDetailPage(slug: slug);
          },
          routes: [
            GoRoute(
              path: 'donate',
              builder: (context, state) {
                final campaign = state.extra as CampaignDetail;
                return DonationPage(campaign: campaign);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/donation-success',
      builder: (context, state) {
        final response = state.extra as DonationResponse;
        return DonationSuccessPage(response: response);
      },
    ),
  ],
);

class MucharityApp extends StatelessWidget {
  const MucharityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mucharity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A7C59),
          primary: const Color(0xFF4A7C59),
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9F6),
      ),
      
      routerConfig: _router,
    );
  }
}