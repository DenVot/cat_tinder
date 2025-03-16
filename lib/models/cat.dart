class Cat {
  final String id;
  final String url;
  final String breedName;

  Cat({required this.id, required this.url, required this.breedName});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      url: json['url'],
      breedName:
          json['breeds'] != null && json['breeds'].isNotEmpty
              ? json['breeds'][0]['name']
              : 'Unknown',
    );
  }
}
