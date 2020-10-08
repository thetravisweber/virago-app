class Review {
  final int id;
  final int brandId;
  final double rating;
  final int helpfulness;
  final String content;
  final DateTime date;

  Review({this.id, this.brandId, this.rating, this.helpfulness, this.content, this.date});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      brandId: json['brand_id'],
      rating: json['rating'],
      helpfulness: json['helpfulness'],
      date: DateTime.parse(json['date']),
      content: json['content']
    );
  }
}