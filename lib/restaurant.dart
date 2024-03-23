class Restaurant {
  String name;
  String address;
  String cost;
  List<double> coordinates;
  String licNo;
  String link;
  double rating;
  String ratingCount;
  String cuisine;

  Restaurant({
    required this.name,
    required this.address,
    required this.cost,
    required this.coordinates,
    required this.licNo,
    required this.link,
    required this.rating,
    required this.ratingCount,
    required this.cuisine,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        name: json['name'] as String,
        address: json['address'] as String,
        cost: json['cost'] as String,
        coordinates: (json['coordinates'] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
        licNo: json['licNo'] != null && json['licNo'] != ''
            ? json['licNo'] as String
            : 'DefaultLicNo',
        link: json['link'] as String,
        rating: json['rating'] != null
            ? double.tryParse(json['rating']) ?? 3.0
            : 3.0,
        ratingCount: json['ratingCount'] != null && json['ratingCount'] != ''
            ? json['ratingCount'] as String
            : '',
        cuisine: json['cuisine'] != null && json['cuisine'] != ''
            ? json['cuisine'] as String
            : '',
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'address': address,
        'cost': cost,
        'coordinates': coordinates,
        'licNo': licNo,
        'link': link,
        'rating': rating,
        'ratingCount': ratingCount,
        'cuisine': cuisine,
      };
}
