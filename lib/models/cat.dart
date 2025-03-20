class Cat {
  final String id;
  final String url;
  final String breedName;
  final String weight;
  final String height;
  final String lifeSpan;

  Cat({required this.id, required this.url, required this.breedName, required this.weight, required this.height, required this.lifeSpan});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      url: json['url'],
      breedName:
          json['breeds'] != null && json['breeds'].isNotEmpty
              ? json['breeds'][0]['name']
              : 'Unknown',
      weight: json['breeds'] != null && json['breeds'].isNotEmpty
              ? json['breeds'][0]['weight']
              : 'Unknown',
      height: json['breeds'] != null && json['breeds'].isNotEmpty
              ? json['breeds'][0]['height']
              : 'Unknown',
      lifeSpan: json['breeds'] != null && json['breeds'].isNotEmpty
              ? json['breeds'][0]['life_span']
              : 'Unknown',
    );
  }
}
