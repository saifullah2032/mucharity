enum DonationType {
  oneTime,
  recurring;

  String get apiValue {
    switch (this) {
      case DonationType.oneTime:
        return 'one_time';
      case DonationType.recurring:
        return 'recurring';
    }
  }

  static DonationType? fromApiValue(String value) {
    switch (value) {
      case 'one_time':
        return DonationType.oneTime;
      case 'recurring':
        return DonationType.recurring;
      default:
        return null;
    }
  }
}

class DonationRequest {
  final String campaignSlug;
  final double amount;
  final String donationType;
  
  const DonationRequest({
    required this.campaignSlug,
    required this.amount,
    required this.donationType,
  });
  
  Map<String, dynamic> toJson() => {
    'campaignSlug': campaignSlug,
    'amount': amount,
    'donationType': donationType,
  };
}

class DonationResponse {
  final String id;
  final String campaignSlug;
  final double amount;
  final String currency;
  final String donationType;
  final String status;
  final DateTime createdAt;
  
  const DonationResponse({
    required this.id,
    required this.campaignSlug,
    required this.amount,
    required this.currency,
    required this.donationType,
    required this.status,
    required this.createdAt,
  });
  
  factory DonationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['donation'] is Map<String, dynamic> ? json['donation'] : json;
    
    return DonationResponse(
      id: data['id']?.toString() ?? '',
      campaignSlug: data['campaignSlug']?.toString() ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency']?.toString() ?? 'USD',
      donationType: data['donationType']?.toString() ?? 'one_time',
      status: data['status']?.toString() ?? 'succeeded',
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class DonationFormData {
  final double amount;
  final DonationType type;
  final String? selectedGivingLevelId;
  final bool isCustomAmount;
  
  const DonationFormData({
    this.amount = 0,
    this.type = DonationType.oneTime,
    this.selectedGivingLevelId,
    this.isCustomAmount = false,
  });
  
  DonationFormData copyWith({
    double? amount,
    DonationType? type,
    String? selectedGivingLevelId,
    bool? isCustomAmount,
  }) {
    return DonationFormData(
      amount: amount ?? this.amount,
      type: type ?? this.type,
      selectedGivingLevelId: selectedGivingLevelId ?? this.selectedGivingLevelId,
      isCustomAmount: isCustomAmount ?? this.isCustomAmount,
    );
  }
}