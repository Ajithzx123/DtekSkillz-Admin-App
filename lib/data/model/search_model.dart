class SearchModel {
  final String? id;
  final String? name;
  final String? partnerName;
  final String? rating;
  final String? image;
  final String? providerId;

  SearchModel({
    this.id,
    this.name,
    this.partnerName,
    this.rating,
    this.image,
    this.providerId,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      partnerName: json['partnerName'] as String?,
      rating: json['rating'] as String?,
      image: json['image'] as String?,
      providerId: json['providerId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['partnerName'] = partnerName;
    data['rating'] = rating;
    data['image'] = image;
    data['providerId'] = providerId;
    return data;
  }
}
