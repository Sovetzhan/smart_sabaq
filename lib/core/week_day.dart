enum WeekDay { mon, tue, wed, thu, fri, sat }

extension WeekDayX on WeekDay {
  static WeekDay fromInt(int value) {
    return WeekDay.values[value];
  }
}
