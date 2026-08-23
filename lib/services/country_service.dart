import '../models/islamic_country.dart';

class CountryService {
  const CountryService();

  static const IslamicCountry
      defaultCountry =
      IslamicCountry(
    code: 'AE',
    name: 'United Arab Emirates',
    flagEmoji: '🇦🇪',
    supportsOfficialIslamicDates: true,
  );

  static const List<IslamicCountry>
      countries = [
    IslamicCountry(
      code: 'AE',
      name: 'United Arab Emirates',
      flagEmoji: '🇦🇪',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'SA',
      name: 'Saudi Arabia',
      flagEmoji: '🇸🇦',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'BH',
      name: 'Bahrain',
      flagEmoji: '🇧🇭',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'KW',
      name: 'Kuwait',
      flagEmoji: '🇰🇼',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'OM',
      name: 'Oman',
      flagEmoji: '🇴🇲',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'QA',
      name: 'Qatar',
      flagEmoji: '🇶🇦',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'IN',
      name: 'India',
      flagEmoji: '🇮🇳',
      supportsOfficialIslamicDates: false,
    ),
    IslamicCountry(
      code: 'PK',
      name: 'Pakistan',
      flagEmoji: '🇵🇰',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'BD',
      name: 'Bangladesh',
      flagEmoji: '🇧🇩',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'ID',
      name: 'Indonesia',
      flagEmoji: '🇮🇩',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'MY',
      name: 'Malaysia',
      flagEmoji: '🇲🇾',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'SG',
      name: 'Singapore',
      flagEmoji: '🇸🇬',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'GB',
      name: 'United Kingdom',
      flagEmoji: '🇬🇧',
      supportsOfficialIslamicDates: false,
    ),
    IslamicCountry(
      code: 'US',
      name: 'United States',
      flagEmoji: '🇺🇸',
      supportsOfficialIslamicDates: false,
    ),
    IslamicCountry(
      code: 'CA',
      name: 'Canada',
      flagEmoji: '🇨🇦',
      supportsOfficialIslamicDates: false,
    ),
    IslamicCountry(
      code: 'AU',
      name: 'Australia',
      flagEmoji: '🇦🇺',
      supportsOfficialIslamicDates: false,
    ),
    IslamicCountry(
      code: 'NZ',
      name: 'New Zealand',
      flagEmoji: '🇳🇿',
      supportsOfficialIslamicDates: false,
    ),
    IslamicCountry(
      code: 'ZA',
      name: 'South Africa',
      flagEmoji: '🇿🇦',
      supportsOfficialIslamicDates: false,
    ),
    IslamicCountry(
      code: 'EG',
      name: 'Egypt',
      flagEmoji: '🇪🇬',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'TR',
      name: 'Türkiye',
      flagEmoji: '🇹🇷',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'JO',
      name: 'Jordan',
      flagEmoji: '🇯🇴',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'MA',
      name: 'Morocco',
      flagEmoji: '🇲🇦',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'DZ',
      name: 'Algeria',
      flagEmoji: '🇩🇿',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'TN',
      name: 'Tunisia',
      flagEmoji: '🇹🇳',
      supportsOfficialIslamicDates: true,
    ),
    IslamicCountry(
      code: 'LK',
      name: 'Sri Lanka',
      flagEmoji: '🇱🇰',
      supportsOfficialIslamicDates: false,
    ),
    IslamicCountry(
      code: 'MV',
      name: 'Maldives',
      flagEmoji: '🇲🇻',
      supportsOfficialIslamicDates: true,
    ),
  ];

  List<IslamicCountry> get allCountries {
    final result =
        List<IslamicCountry>.from(
      countries,
    );

    result.sort(
      (
        a,
        b,
      ) =>
          a.name.compareTo(
        b.name,
      ),
    );

    return result;
  }

  IslamicCountry countryFromCode(
    String? code,
  ) {
    if (code == null ||
        code.trim().isEmpty) {
      return defaultCountry;
    }

    final normalized =
        code.trim().toUpperCase();

    for (final country in countries) {
      if (country.code ==
          normalized) {
        return country;
      }
    }

    return defaultCountry;
  }

  List<IslamicCountry> search(
    String query,
  ) {
    final normalized =
        query.trim().toLowerCase();

    if (normalized.isEmpty) {
      return allCountries;
    }

    return allCountries.where(
      (
        country,
      ) {
        return country.name
                .toLowerCase()
                .contains(
                  normalized,
                ) ||
            country.code
                .toLowerCase()
                .contains(
                  normalized,
                );
      },
    ).toList();
  }
}