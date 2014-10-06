part of facebook;

class GraphObject<T extends GraphObject> {

  Map<String, dynamic> map = new Map<String, dynamic>();

  GraphObject([this.map]);

  @override
  noSuchMethod(InstanceMirror invocation) {

    if(invocation.isGetter || invocation.isSetter) {

      String properName = MirrorSystem.getName(invocation.memberName);
      String key = camelCaseToLowercaseUnderscores(properName);

      bool hasKey = map.containsKey(key);

      if(hasKey) {

        if(invocation.isGetter) {

          InstanceMirror instanceMirror = reflect(this);

          ClassMirror classMirror = instanceMirror.type;

          var test = classMirror.getField(new Symbol(properName));

//          var method = classMirror.getField("birthday");

          dynamic value = getProperty(properName);

          return value;
        }

        if(invocation.isSetter) {

          _setProperty(properName, invocation.positionalArguments.first);

          return;
        }
      }
    }

    super.noSuchMethod(invocation);
  }

  GraphObject<T> cast(T graphObjectClass) {

    ClassMirror classMirror = reflectClass(graphObjectClass);
    InstanceMirror instanceMirror = classMirror.newInstance(new Symbol(''), []);
    instanceMirror.setField(new Symbol('map'), map);

    return instanceMirror.reflectee;
  }

  GraphObjectList<T> createList(List<T> list, T graphObjectClass) {

    return null;
  }

  camelCaseToLowercaseUnderscores(String string) {

    RegExp matcher  = new RegExp("([a-z])([A-Z])");

    string = string.trim()
    .replaceFirst('=', '')
    .replaceAllMapped(matcher, (m) => '${m[1]}_${m[2]}');

    return string.toLowerCase();
  }

  _setProperty(String propertyName, dynamic value) {

    String key = camelCaseToLowercaseUnderscores(propertyName);

    if(value is GraphObject) {

      map[key] = (value as GraphObject).map;

    } else {

      map[key] = value;
    }

  }

  dynamic getProperty(String propertyName, {Type type: null}) {

    String key = camelCaseToLowercaseUnderscores(propertyName);

    if(map.containsKey(key)) {

      dynamic value = map[key];

      if(type != null) {

        if(type is GraphObject) {

          GraphObject graphObject = new GraphObject(value);

          return graphObject.cast(type);

        } else {

          return new DateFormat.yMd('en_US').parse(value);
        }

//        if(type is DateTime) {
//
//          return new DateFormat.yMd('en_US').parse(value);
//        }

      } else {

        return value;
      }
    }

    return null;
  }
}
