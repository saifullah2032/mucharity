import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mucharity/core/api_client.dart';
import 'package:mucharity/features/campaigns/models/campaign.dart';
import 'package:mucharity/features/campaigns/repositories/campaign_repository.dart';

// 1. Core API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// 2. Campaign Repository Provider
final campaignRepositoryProvider = Provider<CampaignRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CampaignRepository(apiClient);
});

// 3. FutureProvider for All Campaigns
final campaignsProvider = FutureProvider.autoDispose<List<Campaign>>((ref) async {
  final repository = ref.watch(campaignRepositoryProvider);
  return repository.getCampaigns();
});

// 4. FutureProvider for Featured Campaigns
final featuredCampaignsProvider = FutureProvider.autoDispose<List<Campaign>>((ref) async {
  final repository = ref.watch(campaignRepositoryProvider);
  return repository.getCampaigns(featured: true);
});

// 5. Family FutureProvider for Campaign Details (by Slug)
final campaignDetailProvider = FutureProvider.autoDispose.family<CampaignDetail, String>((ref, slug) async {
  final repository = ref.watch(campaignRepositoryProvider);
  return repository.getCampaignDetail(slug);
});