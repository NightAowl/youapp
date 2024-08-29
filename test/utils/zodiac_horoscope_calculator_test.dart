import 'package:flutter_test/flutter_test.dart';
import 'package:youapp/utils/zodiac_horoscope_calculator.dart';

void main() {
  group(
    'ZodiacHoroscopeCalculator',
    () {
      group(
        'getZodiac',
        () {
          test(
            'returns correct zodiac signs for various dates',
            () {
              final testCases = [
                (DateTime(2023, 3, 21), 'Aries'),
                (DateTime(2023, 4, 19), 'Aries'),
                (DateTime(2023, 4, 20), 'Taurus'),
                (DateTime(2023, 5, 20), 'Taurus'),
                (DateTime(2023, 5, 21), 'Gemini'),
                (DateTime(2023, 6, 21), 'Gemini'),
                (DateTime(2023, 6, 22), 'Cancer'),
                (DateTime(2023, 7, 22), 'Cancer'),
                (DateTime(2023, 7, 23), 'Leo'),
                (DateTime(2023, 8, 22), 'Leo'),
                (DateTime(2023, 8, 23), 'Virgo'),
                (DateTime(2023, 9, 22), 'Virgo'),
                (DateTime(2023, 9, 23), 'Libra'),
                (DateTime(2023, 10, 23), 'Libra'),
                (DateTime(2023, 10, 24), 'Scorpio'),
                (DateTime(2023, 11, 21), 'Scorpio'),
                (DateTime(2023, 11, 22), 'Sagittarius'),
                (DateTime(2023, 12, 21), 'Sagittarius'),
                (DateTime(2023, 12, 22), 'Capricorn'),
                (DateTime(2024, 1, 19), 'Capricorn'),
                (DateTime(2024, 1, 20), 'Aquarius'),
                (DateTime(2024, 2, 18), 'Aquarius'),
                (DateTime(2024, 2, 19), 'Pisces'),
                (DateTime(2024, 3, 20), 'Pisces'),
              ];

              for (final testCase in testCases) {
                expect(
                  ZodiacHoroscopeCalculator.getZodiac(testCase.$1),
                  testCase.$2,
                );
              }
            },
          );
        },
      );

      group(
        'getHoroscope',
        () {
          test(
            'returns correct Chinese zodiac signs for various years',
            () {
              final testCases = [
                (DateTime(1924), 'Rat'),
                (DateTime(1937), 'Ox'),
                (DateTime(1950), 'Tiger'),
                (DateTime(1963), 'Rabbit'),
                (DateTime(1976), 'Dragon'),
                (DateTime(1989), 'Snake'),
                (DateTime(2002), 'Horse'),
                (DateTime(2015), 'Goat'),
                (DateTime(2028), 'Monkey'),
                (DateTime(2017), 'Rooster'),
                (DateTime(2030), 'Dog'),
                (DateTime(2019), 'Pig'),
              ];

              for (final testCase in testCases) {
                expect(
                  ZodiacHoroscopeCalculator.getHoroscope(testCase.$1),
                  testCase.$2,
                );
              }
            },
          );

          test(
            'returns "Unknown" for years not in the list',
            () {
              expect(
                ZodiacHoroscopeCalculator.getHoroscope(DateTime(1900)),
                'Unknown',
              );
              expect(
                ZodiacHoroscopeCalculator.getHoroscope(DateTime(2100)),
                'Unknown',
              );
            },
          );
        },
      );
    },
  );
}
