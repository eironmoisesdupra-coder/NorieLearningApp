import 'package:flutter/material.dart';
import '../../../core/theme/norie_theme.dart';
import '../domain/norie_shop_models.dart';

/// Small, offline illustrations using the same symbols as the usable reward.
class NorieCommerceArt extends StatelessWidget {
  const NorieCommerceArt(
      {super.key, required this.icon, required this.color, this.frame = false});
  final IconData icon;
  final Color color;
  final bool frame;

  static IconData itemIcon(NorieShopItem item) => switch (item.type) {
        NorieShopItemType.consumable => Icons.shield_rounded,
        NorieShopItemType.profileFrame => Icons.person_rounded,
        NorieShopItemType.badge => item.id == 'badge-atom'
            ? Icons.science_rounded
            : Icons.local_fire_department_rounded,
        NorieShopItemType.theme => Icons.palette_rounded,
      };
  static Color itemColor(NorieShopItem item) =>
      item.id.contains('ember') || item.id.contains('streak')
          ? NorieColors.orange
          : item.id.contains('violet')
              ? NorieColors.violet
              : NorieColors.cyan;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
      child: SizedBox(
          width: 112,
          height: 112,
          child: Stack(alignment: Alignment.center, children: [
            Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      color.withValues(alpha: .35),
                      color.withValues(alpha: 0)
                    ]))),
            Transform.rotate(
                angle: .2,
                child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(frame ? 36 : 22),
                        border: Border.all(
                            color: color.withValues(alpha: .45), width: 2)))),
            Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    shape: frame ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: frame ? null : BorderRadius.circular(18),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withValues(alpha: .45),
                          NorieColors.surface
                        ]),
                    border: Border.all(color: color, width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: color.withValues(alpha: .2), blurRadius: 18)
                    ]),
                child: Icon(icon, color: Colors.white, size: 36)),
            Positioned(
                top: 12,
                right: 12,
                child:
                    Icon(Icons.auto_awesome_rounded, color: color, size: 22)),
            Positioned(
                bottom: 17,
                left: 16,
                child: Icon(Icons.star_rounded,
                    color: color.withValues(alpha: .7), size: 12)),
          ])));
}
