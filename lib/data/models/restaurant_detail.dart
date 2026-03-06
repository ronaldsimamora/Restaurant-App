class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String address;
  final double rating;
  final List<String> categories;
  final List<String> foods;
  final List<String> drinks;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.rating,
    required this.categories,
    required this.foods,
    required this.drinks,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,

      categories:
          (json['categories'] as List?)
              ?.map((e) => e['name'] as String)
              .toList() ??
          [],

      foods:
          (json['menus']?['foods'] as List?)
              ?.map((e) => e['name'] as String)
              .toList() ??
          [],

      drinks:
          (json['menus']?['drinks'] as List?)
              ?.map((e) => e['name'] as String)
              .toList() ??
          [],

      customerReviews:
          (json['customerReviews'] as List?)
              ?.map((e) => CustomerReview.fromJson(e))
              .toList() ??
          [],
    );
  }
}
