/// `1200` -> `EGP 1,200`, `99.5` -> `EGP 99.50` (Figma price style).
String egp(num value) => 'EGP ${groupThousands(value)}';

String groupThousands(num value) {
  final whole = value == value.roundToDouble();
  final text = whole ? value.round().toString() : value.toStringAsFixed(2);
  final parts = text.split('.');
  final digits = parts[0].replaceFirst('-', '');
  final buffer = StringBuffer(value < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  if (parts.length > 1) buffer.write('.${parts[1]}');
  return buffer.toString();
}
