class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final LoyaltyInfo? loyalty;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.loyalty,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      loyalty: json['loyalty'] != null
          ? LoyaltyInfo.fromJson(json['loyalty'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'loyalty': loyalty?.toJson(),
    };
  }
}

class LoyaltyInfo {
  final int points;
  final String tier;
  final int pointsToNextTier;

  LoyaltyInfo({
    required this.points,
    required this.tier,
    required this.pointsToNextTier,
  });

  factory LoyaltyInfo.fromJson(Map<String, dynamic> json) {
    return LoyaltyInfo(
      points: json['points'] ?? 0,
      tier: json['tier'] ?? 'Bronze',
      pointsToNextTier: json['pointsToNextTier'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'tier': tier,
      'pointsToNextTier': pointsToNextTier,
    };
  }
}
