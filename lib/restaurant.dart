import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart'; // This is the generated file

@JsonSerializable()
class Restaurant {
  String id;
  String name;
  String address;
  List<double> coordinates;
  double rating;
  String cuisine;
  String cost;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.coordinates,
    required this.rating,
    required this.cuisine,
    required this.cost,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
