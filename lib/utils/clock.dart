/// Fonte de "agora" injetável, para cálculos de SLA e testes determinísticos.
abstract interface class Clock {
  DateTime now();
}

final class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now().toUtc();
}
