class ZodiacHoroscopeCalculator {
  static String getZodiac(DateTime date) {
    final month = date.month;
    final day = date.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return "Aries";
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return "Taurus";
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 21)) {
      return "Gemini";
    } else if ((month == 6 && day >= 22) || (month == 7 && day <= 22)) {
      return "Cancer";
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return "Leo";
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return "Virgo";
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 23)) {
      return "Libra";
    } else if ((month == 10 && day >= 24) || (month == 11 && day <= 21)) {
      return "Scorpio";
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return "Sagittarius";
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return "Capricorn";
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return "Aquarius";
    } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
      return "Pisces";
    } else {
      return "Unknown";
    }
  }

  static String getHoroscope(DateTime date) {
    final chineseZodiacYears = {
      'Rat': [1924, 1936, 1948, 1960, 1972, 1984, 1996, 2008, 2020],
      'Ox': [1925, 1937, 1949, 1961, 1973, 1985, 1997, 2009, 2021],
      'Tiger': [1926, 1938, 1950, 1962, 1974, 1986, 1998, 2010, 2022],
      'Rabbit': [1927, 1939, 1951, 1963, 1975, 1987, 1999, 2011, 2023],
      'Dragon': [1928, 1940, 1952, 1964, 1976, 1988, 2000, 2012, 2024],
      'Snake': [1929, 1941, 1953, 1965, 1977, 1989, 2001, 2013, 2025],
      'Horse': [1930, 1942, 1954, 1966, 1978, 1990, 2002, 2014, 2026],
      'Goat': [1931, 1943, 1955, 1967, 1979, 1991, 2003, 2015, 2027],
      'Monkey': [1932, 1944, 1956, 1968, 1980, 1992, 2004, 2016, 2028],
      'Rooster': [1933, 1945, 1957, 1969, 1981, 1993, 2005, 2017, 2029],
      'Dog': [1934, 1946, 1958, 1970, 1982, 1994, 2006, 2018, 2030],
      'Pig': [1935, 1947, 1959, 1971, 1983, 1995, 2007, 2019, 2031],
    };

    final year = date.year;

    for (var zodiac in chineseZodiacYears.keys) {
      if (chineseZodiacYears[zodiac]!.contains(year)) {
        return zodiac;
      }
    }

    return "Unknown";
  }
}
