/// A logged [value] finishes the habit when it reaches [target].
bool meetsTarget(double value, double target) {
  if (target <= 0) return value > 0;
  return value >= target;
}

/// One step on a quantity habit. The result stays inside 0…999.
double stepQuantity(double current, double delta) {
  final next = current + delta;
  if (next <= 0) return 0;
  if (next >= 999) return 999;
  return next;
}
