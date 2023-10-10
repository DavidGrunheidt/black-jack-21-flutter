import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'deck_model.g.dart';

@CopyWith()
@JsonSerializable()
class DeckModel extends Equatable {
  const DeckModel({
    required this.success,
    required this.shuffled,
    required this.remaining,
    required this.deckId,
  });

  final bool success;
  final bool shuffled;
  final int remaining;

  @JsonKey(name: 'deck_id')
  final String deckId;

  factory DeckModel.fromJson(Map<String, dynamic> json) => _$DeckModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeckModelToJson(this);

  @override
  List<Object?> get props => [success, shuffled, remaining, deckId];
}
