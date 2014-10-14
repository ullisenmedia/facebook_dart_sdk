part of facebook;

class GraphObject<T extends GraphObject> {

  Map<String, dynamic> map = new Map<String, dynamic>();
  Map<String, Type> typeMap = new Map<String, dynamic>();

  GraphObject([Map<String, dynamic> map]) {

    if(map != null) {
      this.map = map;
    }
  }

  @override
  noSuchMethod(InstanceMirror invocation) {

    if(invocation.isGetter || invocation.isSetter) {

      String propertyName = MirrorSystem.getName(invocation.memberName);
      String key = camelCaseToLowercaseUnderscores(propertyName);

      bool hasKey = map.containsKey(key);

      if(hasKey) {

        if(invocation.isGetter) {

          Type type = null;
          dynamic value = null;

          InstanceMirror instanceMirror = reflect(this);
          ClassMirror classMirror = instanceMirror.type;

          Map<Symbol, DeclarationMirror> declarations = classMirror.declarations;

          var propertySymbol = new Symbol(propertyName);

          if(declarations.containsKey(propertySymbol)) {

            var methodMirror = declarations[propertySymbol];
            var typeMirror = methodMirror.returnType;
            var graphObjectTypeMirror = reflectType(GraphObject);
            var graphObjectListTypeMirror = reflectType(List);

            if(typeMirror.isSubtypeOf(graphObjectTypeMirror)) {

              type = methodMirror.returnType.reflectedType;

              value = getProperty(propertyName, type: type);
            } else if(typeMirror.isSubtypeOf(graphObjectListTypeMirror)) {

              var listTypeMirror = reflectType(typeMirror.reflectedType);
              var typeArguments = listTypeMirror.typeArguments;
              var genericClassMirror = typeArguments.first;

              value = getPropertyAsList(propertyName, type: genericClassMirror.reflectedType);

            } else {

              value = getProperty(propertyName);
            }

          } else {

            value = getProperty(propertyName);
          }


          return value;
        }

        if(invocation.isSetter) {

          _setProperty(propertyName, invocation.positionalArguments.first);

          return;
        }

      } else {

        if(invocation.isSetter) {

          _setProperty(propertyName, invocation.positionalArguments.first);

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

        if(type == DateTime) {

          return new DateFormat.yMd('en_US').parse(value);
        }

        return new GraphObject<T>(value).cast(type);

      } else {

        return value;
      }
    }

    return null;
  }

  GraphObjectList<T> getPropertyAsList(String propertyName, {Type type: GraphObject}) {

    String key = camelCaseToLowercaseUnderscores(propertyName);

    if(map.containsKey(key)) {

      List<dynamic> values = map[key];

      if(type != null) {

        GraphObjectList<T> graphObjectList = new GraphObjectList<T>.castToListFrom(values, type);

        return graphObjectList;

      } else {

        return values;
      }
    }
  }
}
