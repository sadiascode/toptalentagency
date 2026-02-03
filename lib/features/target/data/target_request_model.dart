// ------------------- Month Stats -------------------

class TargetRequestModel {
  final int diamonds;
  final double hours;

  TargetRequestModel({required this.diamonds, required this.hours});

  factory TargetRequestModel.fromJson(Map<String, dynamic> json) {
    print('🔍 TargetRequestModel.fromJson called with:');
    print('   - Full JSON keys: ${json.keys.toList()}');
    print('   - All JSON data: $json');
    print(
      '   - total_diamond key exists: ${json.containsKey('total_diamond')}',
    );
    print('   - diamonds key exists: ${json.containsKey('diamonds')}');
    print('   - diamondtotal key exists: ${json.containsKey('diamondtotal')}');

    // Try multiple possible diamond field names
    final diamondsRaw =
        json['total_diamond'] ??
            json['diamonds'] ??
            json['totalDiamonds'] ??
            json['total_diamonds'] ??
            json['diamond_count'] ??
            json['diamonds_count'] ??
            json['diamondtotal'] ??
            json['diamond_total'] ??
            json['totalDiamond'] ??
            json['sum_diamonds'] ??
            json['diamond_sum'] ??
            json['all_diamonds'] ??
            json['diamonds_total'] ??
            0;

    final hoursRaw = json['total_hour'] ?? json['hours'] ?? 0;

    print('   - diamondsRaw: $diamondsRaw (type: ${diamondsRaw.runtimeType})');
    print('   - hoursRaw: $hoursRaw (type: ${hoursRaw.runtimeType})');

    final diamondsDouble = double.tryParse(diamondsRaw.toString()) ?? 0.0;

    final diamondsInt = diamondsDouble.toInt();

    print('   - diamondsDouble: $diamondsDouble');
    print('   - diamondsInt: $diamondsInt');

    return TargetRequestModel(
      diamonds: diamondsInt,
      hours: double.tryParse(hoursRaw.toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'diamonds': diamonds, 'hours': hours};
  }

  @override
  String toString() => 'MonthStats(diamonds: $diamonds, hours: $hours)';
}

// ------------------- Last 3 Months -------------------

class Last3Months {
  final Map<String, TargetRequestModel> months;

  Last3Months({required this.months});

  factory Last3Months.fromJson(Map<String, dynamic> json) {
    final Map<String, TargetRequestModel> monthsMap = {};

    json.forEach((month, stats) {
      if (stats is Map<String, dynamic>) {
        monthsMap[month] = TargetRequestModel.fromJson(stats);
      }
    });

    return Last3Months(months: monthsMap);
  }

  Map<String, dynamic> toJson() {
    return months.map((month, stats) => MapEntry(month, stats.toJson()));
  }

  @override
  String toString() => months.toString();
}
