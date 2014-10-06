part of facebook;

class GraphObjectList<T extends GraphObject> extends List<T> {

  GraphObjectList<T> castToListOf(T graphObjectClass);
}
