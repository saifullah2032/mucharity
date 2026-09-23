import 'package:mucharity/core/api_client.dart';
import 'package:mucharity/features/donation/models/donation.dart';

class DonationRepository {
  final ApiClient _apiClient;

  DonationRepository(this._apiClient);

  Future<DonationResponse> submitDonation(DonationRequest request) async {
    final response = await _apiClient.dio.post(
      '/donations/test',
      data: request.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return DonationResponse.fromJson(response.data);
    }

    throw Exception('Failed to submit donation: ${response.statusCode}');
  }
}