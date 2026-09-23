// ignore_for_file: prefer_iterable_wheretype, deprecated_member_use, use_super_parameters
class Campaign {
  final String id;
  final String slug;
  final String title;
  final String? subtitle;
  final String coverImage;
  final bool featured;
  final Organizer organizer;
  final Funding funding;
  final int supportersCount;
  final String currency;
  
  const Campaign({
    required this.id,
    required this.slug,
    required this.title,
    this.subtitle,
    required this.coverImage,
    required this.featured,
    required this.organizer,
    required this.funding,
    required this.supportersCount,
    required this.currency,
  });
  
  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      coverImage: json['coverImageUrl']?.toString() ?? json['coverImage']?.toString() ?? '',
      featured: json['featured'] as bool? ?? false,
      organizer: json['organizer'] != null && json['organizer'] is Map<String, dynamic>
          ? Organizer.fromJson(json['organizer'])
          : const Organizer(id: '', name: 'Anonymous', country: ''),
      funding: Funding.fromJson(json),
      supportersCount: (json['supporters'] as num?)?.toInt() ?? (json['supportersCount'] as num?)?.toInt() ?? 0,
      currency: json['currency']?.toString() ?? 'USD',
    );
  }
  
  double get progress {
    if (funding.targetAmount <= 0) return 0.0;
    return (funding.collectedAmount / funding.targetAmount).clamp(0.0, 1.0);
  }
  
  String get progressPercentage => '${(progress * 100).toInt()}%';
}

class Organizer {
  final String id;
  final String name;
  final String? avatar;
  final String country;
  
  const Organizer({
    required this.id,
    required this.name,
    this.avatar,
    required this.country,
  });
  
  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Organizer',
      avatar: json['avatar']?.toString(),
      country: json['country']?.toString() ?? '',
    );
  }
}

class Funding {
  final double collectedAmount;
  final double targetAmount;
  
  const Funding({
    required this.collectedAmount,
    required this.targetAmount,
  });
  
  factory Funding.fromJson(Map<String, dynamic> json) {
    final fundingMap = json['funding'] is Map<String, dynamic> ? json['funding'] : json;
    return Funding(
      collectedAmount: (fundingMap['collectedAmount'] as num?)?.toDouble() ?? 
                       (fundingMap['collected_amount'] as num?)?.toDouble() ?? 0.0,
      targetAmount: (fundingMap['targetAmount'] as num?)?.toDouble() ?? 
                    (fundingMap['target_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CampaignDetail {
  final String id;
  final String slug;
  final String title;
  final String? subtitle;
  final String coverImage;
  final Organizer organizer;
  final Funding funding;
  final int supportersCount;
  final String currency;
  final String story;
  final DonationSettings donationSettings;
  
  const CampaignDetail({
    required this.id,
    required this.slug,
    required this.title,
    this.subtitle,
    required this.coverImage,
    required this.organizer,
    required this.funding,
    required this.supportersCount,
    required this.currency,
    required this.story,
    required this.donationSettings,
  });
  
  factory CampaignDetail.fromJson(Map<String, dynamic> json) {
    // Safely unwrap if data is wrapped under a 'campaign' key
    final data = json['campaign'] is Map<String, dynamic> ? json['campaign'] : json;
    
    return CampaignDetail(
      id: data['id']?.toString() ?? '',
      slug: data['slug']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      subtitle: data['subtitle']?.toString(),
      coverImage: data['coverImageUrl']?.toString() ?? data['coverImage']?.toString() ?? '',
      organizer: data['organizer'] != null && data['organizer'] is Map<String, dynamic>
          ? Organizer.fromJson(data['organizer'])
          : const Organizer(id: '', name: 'Anonymous', country: ''),
      funding: Funding.fromJson(data),
      supportersCount: (data['supporters'] as num?)?.toInt() ?? (data['supportersCount'] as num?)?.toInt() ?? 0,
      currency: data['currency']?.toString() ?? 'USD',
      story: data['story']?.toString() ?? '',
      donationSettings: DonationSettings.fromJson(data),
    );
  }
  
  double get progress {
    if (funding.targetAmount <= 0) return 0.0;
    return (funding.collectedAmount / funding.targetAmount).clamp(0.0, 1.0);
  }
  
  String get progressPercentage => '${(progress * 100).toInt()}%';
}

class DonationSettings {
  final bool oneTimeDonation;
  final bool recurringDonation;
  final bool customDonation;
  final double minimumDonationAmount;
  final double recurringMinimumDonationAmount;
  final List<GivingLevel> givingLevels;
  
  const DonationSettings({
    required this.oneTimeDonation,
    required this.recurringDonation,
    required this.customDonation,
    required this.minimumDonationAmount,
    required this.recurringMinimumDonationAmount,
    required this.givingLevels,
  });
  
  factory DonationSettings.fromJson(Map<String, dynamic> json) {
    var levelsRaw = json['givingLevels'] ?? json['giving_levels'] ?? [];
    List<GivingLevel> levels = [];
    if (levelsRaw is List) {
      levels = levelsRaw
          .where((e) => e is Map<String, dynamic>)
          .map((e) => GivingLevel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    
    return DonationSettings(
      oneTimeDonation: json['oneTimeDonation'] as bool? ?? json['one_time_donation'] as bool? ?? true,
      recurringDonation: json['recurringDonation'] as bool? ?? json['recurring_donation'] as bool? ?? false,
      customDonation: json['customDonation'] as bool? ?? json['custom_donation'] as bool? ?? true,
      minimumDonationAmount: (json['minimumDonationAmount'] as num?)?.toDouble() ?? 
                              (json['minimum_donation_amount'] as num?)?.toDouble() ?? 5.0,
      recurringMinimumDonationAmount: (json['recurringMinimumDonationAmount'] as num?)?.toDouble() ?? 
                                     (json['recurring_minimum_donation_amount'] as num?)?.toDouble() ?? 10.0,
      givingLevels: levels,
    );
  }
}

class GivingLevel {
  final String id;
  final double amount;
  final String label;
  final String? description;
  final bool isDefault;
  
  const GivingLevel({
    required this.id,
    required this.amount,
    required this.label,
    this.description,
    this.isDefault = false,
  });
  
  factory GivingLevel.fromJson(Map<String, dynamic> json) {
    return GivingLevel(
      id: json['id']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      label: json['label']?.toString() ?? json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      isDefault: json['isDefault'] as bool? ?? json['is_default'] as bool? ?? false,
    );
  }
}