import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'drawn_card_images_model.dart';

part 'drawn_card_model.g.dart';

@CopyWith()
@JsonSerializable()
class DrawnCardModel extends Equatable {
  const DrawnCardModel({
    required this.code,
    required this.image,
    required this.images,
    required this.value,
    required this.suit,
  });

  final String code;
  final String image;
  final String value;
  final String suit;

  final DrawnCardImagesModel images;

  factory DrawnCardModel.fromJson(Map<String, dynamic> json) => _$DrawnCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrawnCardModelToJson(this);

  @override
  List<Object?> get props => [code, image, images, value, suit];
}
