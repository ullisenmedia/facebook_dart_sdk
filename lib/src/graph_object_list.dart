part of facebook;

class GraphObjectList<T extends GraphObject> extends ListBase<T> {

  List<T> _innerList = new List<T>();

  GraphObjectList();

  GraphObjectList.castToListFrom(List<dynamic> values, T graphObjectClass) {

    values.forEach((dynamic value) {

      GraphObject<T> graphObject = new GraphObject<T>(value).cast(graphObjectClass);
      _innerList.add(graphObject);

    });
  }

  GraphObjectList<T> castToListOf(T graphObjectClass) {

    GraphObjectList<T> graphObjectList = new GraphObjectList<T>();

    this.forEach((GraphObject<T> value) {

      GraphObject<T> graphObject = new GraphObject<T>(value).cast(graphObjectClass);
      graphObjectList.add(graphObject);

    });

    return graphObjectList;
  }

  int get length => _innerList.length;

  void set length(int length) {
    _innerList.length = length;
  }

  void operator[]=(int index, E value) {
    _innerList[index] = value;
  }

  T operator [](int index) => _innerList[index];

  T get first => _innerList.first;

  void add(T value) => _innerList.add(value);

  void addAll(Iterable<T> all) => _innerList.addAll(all);
}
