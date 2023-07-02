import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/local_provider.dart';
import '../l10n/l10n.dart';
import '../services/shared_preference.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({Key? key}) : super(key: key);

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale ?? const Locale('en'),
        iconEnabledColor: Colors.black,
        // icon: const Icon(Icons.language), // you can change the icon from here
        items: L10n.all.map((locale) {
          final languageName = L10n.getLanguage(locale.languageCode);
          return DropdownMenuItem(
              value: locale,
              onTap: () {
                final provider = Provider.of<LocaleProvider>(context, listen: false);
                provider.setLocale(locale);
                UserSharedPreference.setLanguage(locale.toString());
              },
              child: Center(
                child: Text(
                    languageName,
                    style: const TextStyle(fontSize: 18),
                ),
              ),
          );
        }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
