import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../core/design_system/theme/custom_asset.dart';
import '../../../../core/design_system/theme/custom_colors.dart';
import '../../../../core/design_system/theme/custom_space.dart';
import '../../../../core/design_system/theme/custom_text_style.dart';
import '../../infra/models/card_model.dart';

class PlayerCardsWidget extends StatelessWidget {
  final List<CardModel> cards;
  final int cardsValueSum;
  final String playerName;
  final bool isInTurn;

  const PlayerCardsWidget({
    super.key,
    required this.cards,
    required this.cardsValueSum,
    required this.playerName,
    required this.isInTurn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: CustomSpace.xl.size),
          child: Text(
            playerName,
            style: CustomTextStyle.h3.value.copyWith(color: CustomColors.white.value.withOpacity(isInTurn ? 1 : 0.5)),
          ),
        ),
        if (cards.isNotEmpty)
          Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '$cardsValueSum',
                  style: CustomTextStyle.h1.value.copyWith(color: CustomColors.white.value),
                ),
              ),
              ...cards.mapIndexed(
                (index, card) => Align(
                  alignment: Alignment.center,
                  widthFactor: 1 + (index / 2.5),
                  child: CachedNetworkImage(
                    imageUrl: card.image,
                    width: 100,
                    progressIndicatorBuilder: (context, url, _) {
                      return CachedNetworkImage(
                        imageUrl: CustomAsset.backOfCardPngNetworkImg.path,
                        width: 100,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
