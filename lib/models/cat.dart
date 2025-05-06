class Cat {
  final String id;
  final String url;
  final String breedName;
  final String weight;
  final String height;
  final String lifeSpan;
  final DateTime? likedAt;

  Cat({
    required this.id,
    required this.url,
    required this.breedName,
    required this.weight,
    required this.height,
    required this.lifeSpan,
    this.likedAt,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      url: json['url'],
      breedName:
          json['breeds'] != null && json['breeds'].isNotEmpty
              ? json['breeds'][0]['name']
              : 'Unknown',
      weight:
          json['breeds'] != null && json['breeds'].isNotEmpty
              ? json['breeds'][0]['weight']["imperial"]
              : 'Unknown',
      height:
          json['breeds'] != null && json['breeds'].isNotEmpty
              ? json['breeds'][0]['height'].toString()
              : 'Unknown',
      lifeSpan:
          json['breeds'] != null && json['breeds'].isNotEmpty
              ? json['breeds'][0]['life_span'].toString()
              : 'Unknown',
    );
  }

  factory Cat.fromJsonSharedPrefences(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      url: json['url'],
      breedName: json['breedName'],
      weight: json['weight'],
      height: json['height'],
      lifeSpan: json['lifeSpan'],
      likedAt: DateTime.parse(json['likedAt'] as String)
    );
  }

  Cat copyWith({DateTime? likedAt}) {
    return Cat(
      id: id,
      url: url,
      breedName: breedName,
      weight: weight,
      height: height,
      lifeSpan: lifeSpan,
      likedAt: likedAt ?? this.likedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'breedName': breedName,
      'weight': weight,
      'height': height,
      'lifeSpan': lifeSpan,
      'likedAt': likedAt!.toIso8601String(),
    };
  }
}
