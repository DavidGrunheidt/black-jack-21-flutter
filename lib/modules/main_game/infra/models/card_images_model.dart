import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_images_model.g.dart';

@CopyWith()
@JsonSerializable()
class CardImagesModel extends Equatable {
  const CardImagesModel({
    required this.svg,
    required this.png,
  });

  final String svg;
  final String png;

  factory CardImagesModel.fromJson(Map<String, dynamic> json) => _$CardImagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardImagesModelToJson(this);

  @override
  List<Object?> get props => [svg, png];
}
