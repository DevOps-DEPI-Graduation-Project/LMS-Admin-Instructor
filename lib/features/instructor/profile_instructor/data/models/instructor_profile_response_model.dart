import 'package:json_annotation/json_annotation.dart';

part 'instructor_profile_response_model.g.dart';

@JsonSerializable()
class InstructorProfileResponseModel {
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? email;
  final String? slug;
  final String? bio;
  final String? description;
  final String? image;
  final List<InstructorLinkModel>? links;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  InstructorProfileResponseModel({
    this.firstName,
    this.lastName,
    this.email,
    this.slug,
    this.bio,
    this.description,
    this.image,
    this.links,
    this.createdAt,
  });

  factory InstructorProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$InstructorProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorProfileResponseModelToJson(this);
}

@JsonSerializable()
class InstructorLinkModel {
  final String? slug;
  final String? platformName;
  final String? url;

  InstructorLinkModel({
    this.slug,
    this.platformName,
    this.url,
  });

  factory InstructorLinkModel.fromJson(Map<String, dynamic> json) =>
      _$InstructorLinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorLinkModelToJson(this);
}
