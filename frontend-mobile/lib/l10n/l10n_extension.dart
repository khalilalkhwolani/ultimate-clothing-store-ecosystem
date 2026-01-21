import 'package:flutter/material.dart';
import 'package:myprojectshop/l10n/app_localizations.dart';

/// Extension to easily access AppLocalizations from BuildContext
/// Usage: context.l10n.home instead of AppLocalizations.of(context)!.home
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
