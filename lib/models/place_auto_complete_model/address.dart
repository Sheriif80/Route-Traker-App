class Address {
  String? name;
  String? county;
  String? state;
  String? postcode;
  String? country;
  String? countryCode;

  Address({
    this.name,
    this.county,
    this.state,
    this.postcode,
    this.country,
    this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    name: json['name'] as String?,
    county: json['county'] as String?,
    state: json['state'] as String?,
    postcode: json['postcode'] as String?,
    country: json['country'] as String?,
    countryCode: json['country_code'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'county': county,
    'state': state,
    'postcode': postcode,
    'country': country,
    'country_code': countryCode,
  };
}
