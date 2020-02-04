/// Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
/// Author Edwin Magabe    edyma50@yahoo.com

class Context {
  final String buffer;
  int position;

  Context(this.buffer, this.position)
      : assert(buffer != null),
        assert(position != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Context &&
          runtimeType == other.runtimeType &&
          buffer == other.buffer &&
          position == other.position;

  @override
  int get hashCode => buffer.hashCode ^ position.hashCode;
}
