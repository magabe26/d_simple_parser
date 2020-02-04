/// Copyright 2020 - MagabeLab (Tanzania). All Rights Reserved.
/// Author Edwin Magabe    edyma50@yahoo.com

abstract class Result {
  bool get isSuccess => false;
  bool get isFailure => false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Result &&
          runtimeType == other.runtimeType &&
          isSuccess == other.isSuccess &&
          isFailure == other.isFailure;

  @override
  int get hashCode => 0;
}

class Success extends Result {
  final int start;
  final int end;
  String _value;

  String get value => _value;

  set value(String value) => _value ??= value;

  Success setValue(String value) {
    this.value = value;
    return this;
  }

  Success(this.start, this.end);

  @override
  bool get isSuccess => true;

  @override
  bool get isFailure => false;

  @override
  String toString() {
    return '>>> Success:  $value (start: $start - end: $end) <<<';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Success &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end &&
          _value == other._value &&
          isSuccess == other.isSuccess &&
          isFailure == other.isFailure;

  @override
  int get hashCode =>
      super.hashCode ^ start.hashCode ^ end.hashCode ^ _value.hashCode;
}

class Failure extends Result {
  final int position;
  String message;

  Failure(this.position, [String message = '']) {
    this.message = message;
  }

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;

  @override
  String toString() {
    return '>>> Failure:  (position: $position)\n$message <<<\n';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Failure &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          message == other.message &&
          isSuccess == other.isSuccess &&
          isFailure == other.isFailure;

  @override
  int get hashCode => super.hashCode ^ position.hashCode ^ message.hashCode;
}
