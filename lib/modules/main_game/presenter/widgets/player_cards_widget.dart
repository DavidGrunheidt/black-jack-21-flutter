import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../core/design_system/theme/custom_asset.dart';
import '../../../../core/design_system/theme/custom_colors.dart';
import '../../../../core/design_system/theme/custom_space.dart';
import '../../../../core/design_system/theme/custom_text_style.dart';
import '../../../../core/utils/app_constants.dart';
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
    final halfScreenWidth = MediaQuery.sizeOf(context).width / 2;
    const halfCardWidth = cardWidth / 2;

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
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '$cardsValueSum',
                  style: CustomTextStyle.h1.value.copyWith(color: CustomColors.white.value),
                ),
              ),
              ...cards.mapIndexed(
                (index, card) => Positioned(
                  left: halfScreenWidth - ((cards.length - index) * 20) - halfCardWidth,
                  child: CachedNetworkImage(
                    imageUrl: card.image,
                    width: cardWidth,
                    progressIndicatorBuilder: (context, url, _) {
                      return CachedNetworkImage(
                        imageUrl: CustomAsset.backOfCardPngNetworkImg.path,
                        width: cardWidth,
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
