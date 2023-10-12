import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'card_images_model.dart';

part 'card_model.g.dart';

@CopyWith()
@JsonSerializable()
class CardModel extends Equatable {
  const CardModel({
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

  final CardImagesModel images;

  factory CardModel.fromJson(Map<String, dynamic> json) => _$CardModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardModelToJson(this);

  @override
  List<Object?> get props => [code, image, images, value, suit];
}
