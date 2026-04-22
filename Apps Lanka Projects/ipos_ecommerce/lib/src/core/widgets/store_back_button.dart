import 'package:flutter/material.dart';

import 'package:flutter_store_app/src/core/theme/app_theme.dart';

class StoreBackButton extends StatelessWidget {
  const StoreBackButton({
    super.key,
    this.onHero = false,
    this.margin = const EdgeInsets.only(left: 12),
  });

  final bool onHero;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    final backgroundColor = onHero
        ? tokens.onHero.withValues(alpha: 0.16)
        : tokens.softSurface;
    final foregroundColor = onHero
        ? tokens.onHero
        : Theme.of(context).appBarTheme.iconTheme?.color ??
              tokens.heroGradientStart;

    return Padding(
      padding: margin,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 42,
              height: 42,
              child: Icon(
                Icons.arrow_back_rounded,
                color: foregroundColor,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
