import 'package:dio/dio.dart';
import 'package:mucharity/core/api_client.dart';
import 'package:mucharity/features/campaigns/models/campaign.dart';

class CampaignRepository {
  final ApiClient _apiClient;
  
  CampaignRepository(this._apiClient);
  
  Future<List<Campaign>> getCampaigns({bool? featured}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (featured != null) {
        queryParams['featured'] = featured.toString();
      }
      
      final response = await _apiClient.dio.get(
        '/campaigns',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final dynamic rawData = response.data;
        final List<dynamic> data = (rawData is Map) 
            ? (rawData['campaigns'] ?? rawData['data'] ?? []) 
            : (rawData is List ? rawData : []);
            
        return data.map((json) => Campaign.fromJson(json as Map<String, dynamic>)).toList();
      }
      
      throw Exception('Failed to load campaigns: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
  
  Future<CampaignDetail> getCampaignDetail(String slug) async {
    try {
      final response = await _apiClient.dio.get('/campaigns/$slug');
      
      if (response.statusCode == 200) {
        return CampaignDetail.fromJson(response.data);
      }
      
      if (response.statusCode == 404) {
        throw Exception('Campaign not found');
      }
      
      throw Exception('Failed to load campaign: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}