import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'drawn_card_images_model.g.dart';

@CopyWith()
@JsonSerializable()
class DrawnCardImagesModel extends Equatable {
  const DrawnCardImagesModel({
    required this.svg,
    required this.png,
  });

  final String svg;
  final String png;

  factory DrawnCardImagesModel.fromJson(Map<String, dynamic> json) => _$DrawnCardImagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrawnCardImagesModelToJson(this);

  @override
  List<Object?> get props => [svg, png];
}
