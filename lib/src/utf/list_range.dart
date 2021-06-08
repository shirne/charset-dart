import 'dart:collection';

/// _ListRange in an internal type used to create a lightweight Interable on a
/// range within a source list. DO NOT MODIFY the underlying list while
/// iterating over it. The results of doing so are undefined.
// TODO(floitsch): Consider removing the extend and switch to implements since
// that's cheaper to allocate.
class ListRange extends IterableBase<int?> {
  final List<int?> _source;
  final int _offset;
  final int _length;

  ListRange(List<int?> source, [int offset = 0, int? length])
      : _source = source,
        _offset = offset,
        _length = (length ?? source.length - offset) {
    if (_offset < 0 || _offset > _source.length) {
      throw RangeError.value(_offset);
    }
    if (_length < 0) {
      throw RangeError.value(_length);
    }
    if (_length + _offset > _source.length) {
      throw RangeError.value(_length + _offset);
    }
  }

  @override
  ListRangeIterator get iterator =>
      _ListRangeIteratorImpl(_source, _offset, _offset + _length);

  @override
  int get length => _length;
}

/// The ListRangeIterator provides more capabilities than a standard iterator,
/// including the ability to get the current position, count remaining items,
/// and move forward/backward within the iterator.
abstract class ListRangeIterator implements Iterator<int?> {
  @override
  bool moveNext();
  @override
  int? get current;
  int get position;
  void backup([int? by]);
  int get remaining;
  void skip([int? count]);
}

class _ListRangeIteratorImpl implements ListRangeIterator {
  final List<int?> _source;
  int _offset;
  final int _end;

  _ListRangeIteratorImpl(this._source, int offset, this._end)
      : _offset = offset - 1;

  @override
  int? get current => _source[_offset];

  @override
  bool moveNext() => ++_offset < _end;

  @override
  int get position => _offset;

  @override
  void backup([int? by = 1]) {
    _offset -= by!;
  }

  @override
  int get remaining => _end - _offset - 1;

  @override
  void skip([int? count = 1]) {
    _offset += count!;
  }
}
