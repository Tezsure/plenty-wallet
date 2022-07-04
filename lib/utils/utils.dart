/// Shortens tz1 address to tz1...qfz format
String tz1Shortner(String tz1) => tz1.length > 3
    ? (tz1.substring(0, 3) + "..." + tz1.substring(tz1.length - 3, tz1.length))
    : tz1;
