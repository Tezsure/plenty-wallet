import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';

String tz1Shortner(String tz1) => tz1.length > 3
    ? ("${tz1.substring(0, 3)}...${tz1.substring(tz1.length - 3, tz1.length)}")
    : tz1;

extension StringHelper on String {
  /// Shortens tz1 address to tz1...qfz format
  String tz1Short() {
    if (length > 4) {
      return ("${substring(0, 4)}...${substring(length - 4, length)}");
    } else {
      return this;
    }
  }

  bool get isValidWalletAddress =>
      (startsWith("tz1") || startsWith("tz2") || startsWith("tz3")) &&
      length == 36;

  get removeTrailing0 =>
      contains(".") ? replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "") : this;
}

String relativeDate(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  }
  if (diff.inDays > 0) {
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  }
  if (diff.inHours > 0) {
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  }
  return "just now";
}

extension DecimalsRoundUp on num {
  String roundUpDollar(double xtzPrice,
      {int decimals = 2, bool price = false}) {
    if (!price) {
      if (ServiceConfig.currency == Currency.usd) {
        return this == 0
            ? r"$ 0.00"
            : this < 0.01
                ? r"<$0.01"
                : this >= 100
                    ? r"$ " + toStringAsFixed(0)
                    : r"$ " + toStringAsFixed(decimals);
      } else if (ServiceConfig.currency == Currency.inr) {
        print((this * ServiceConfig.inr).toStringAsFixed(0));
        return this == 0
            ? r"₹ 0.00"
            : this * ServiceConfig.inr < 0.01
                ? r"<₹0.01"
                : this * ServiceConfig.inr >= 1000
                    ? r"₹ " + (this * ServiceConfig.inr).toStringAsFixed(0)
                    : r"₹ " +
                        (this * ServiceConfig.inr).toStringAsFixed(decimals);
      } else if (ServiceConfig.currency == Currency.eur) {
        return this == 0
            ? r"€ 0.00"
            : this * ServiceConfig.eur < 0.01
                ? r"<€0.01"
                : this * ServiceConfig.eur >= 100
                    ? r"€ " + (this * ServiceConfig.eur).toStringAsFixed(0)
                    : r"€ " +
                        (this * ServiceConfig.eur).toStringAsFixed(decimals);
      } else if (ServiceConfig.currency == Currency.aud) {
        return this == 0
            ? r"A$ 0.00"
            : this * ServiceConfig.aud < 0.01
                ? r"<A$0.01"
                : this * ServiceConfig.aud >= 100
                    ? r"A$ " + (this * ServiceConfig.aud).toStringAsFixed(0)
                    : r"A$ " +
                        (this * ServiceConfig.aud).toStringAsFixed(decimals);
      } else {
        return this == 0
            ? r"0.00 tez"
            : this / xtzPrice < 0.01
                ? r"<0.01 tez"
                : this / xtzPrice >= 100
                    ? (this / xtzPrice).toStringAsFixed(0) + r" tez"
                    : (this / xtzPrice).toStringAsFixed(decimals) + r" tez";
      }
    } else {
      if (ServiceConfig.currency == Currency.usd) {
        return this == 0
            ? r"$ 0.00"
            : this < 0.01
                ? r"<$0.01"
                : this >= 100
                    ? r"$ " + toStringAsFixed(0)
                    : r"$ " + toStringAsFixed(decimals);
      } else if (ServiceConfig.currency == Currency.inr) {
        return this == 0
            ? r"₹ 0.00"
            : this < 0.01
                ? r"<₹0.01"
                : this >= 1000
                    ? r"₹ " + (this).toStringAsFixed(0)
                    : r"₹ " + (this).toStringAsFixed(decimals);
      } else if (ServiceConfig.currency == Currency.eur) {
        return this == 0
            ? r"€ 0.00"
            : this < 0.01
                ? r"<€0.01"
                : this >= 100
                    ? r"€ " + (this).toStringAsFixed(0)
                    : r"€ " + (this).toStringAsFixed(decimals);
      } else if (ServiceConfig.currency == Currency.aud) {
        return this == 0
            ? r"A$ 0.00"
            : this < 0.01
                ? r"<A$0.01"
                : this >= 100
                    ? r"A$ " + (this).toStringAsFixed(0)
                    : r"A$ " + (this).toStringAsFixed(decimals);
      } else {
        return this == 0
            ? r"0.00 tez"
            : this < 0.01
                ? r"<0.01 tez"
                : this >= 100
                    ? (this).toStringAsFixed(0) + r" tez"
                    : (this).toStringAsFixed(decimals) + r" tez";
      }
    }
  }
}
