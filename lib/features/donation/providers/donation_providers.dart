import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mucharity/features/campaigns/providers/campaign_providers.dart';
import 'package:mucharity/features/donation/models/donation.dart';
import 'package:mucharity/features/donation/repositories/donation_repository.dart';

final donationRepositoryProvider = Provider<DonationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DonationRepository(apiClient);
});

class DonationFormNotifier extends StateNotifier<DonationFormData> {
  DonationFormNotifier() : super(const DonationFormData());

  void setAmount(double amount) {
    state = state.copyWith(amount: amount, isCustomAmount: false, selectedGivingLevelId: null);
  }

  void setCustomAmount(double amount) {
    state = state.copyWith(amount: amount, isCustomAmount: true, selectedGivingLevelId: null);
  }

  void setDonationType(DonationType type) {
    state = state.copyWith(type: type);
  }

  void selectGivingLevel(String id, double amount) {
    state = state.copyWith(
      selectedGivingLevelId: id,
      amount: amount,
      isCustomAmount: false,
    );
  }
}

final donationFormProvider = StateNotifierProvider<DonationFormNotifier, DonationFormData>((ref) {
  return DonationFormNotifier();
});