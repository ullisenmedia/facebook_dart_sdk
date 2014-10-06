import 'dart:mirrors';
import 'dart:core';

@proxy
class TestMirror<T extends TestMirror> {

  Map<String, dynamic> _map;

  TestMirror(): super() {

    _map = new Map<String, dynamic>();
    _map["test_property"] = "testing property";
  }

  @override
  noSuchMethod(InstanceMirror invocation) {

    if(invocation.isGetter || invocation.isSetter) {

      String properName = MirrorSystem.getName(invocation.memberName);

      String key = camelCaseToLowercaseUnderscores(properName);

      bool hasKey = _map.containsKey(key);

      if(hasKey) {

        if(invocation.isGetter) {

          return _map[key] || null;
        }

        if(invocation.isSetter) {

          _map[key] = invocation.positionalArguments.first;

          return;
        }
      }
    }

    super.noSuchMethod(invocation);
  }

  camelCaseToLowercaseUnderscores(String string) {

    RegExp matcher  = new RegExp("([a-z])([A-Z])");

    string = string.trim()
                   .replaceFirst('=', '')
                   .replaceAllMapped(matcher, (m) => '${m[1]}_${m[2]}');


//    string = string.trim().replaceAll("/[-_\s]+(.)?/g", string);

    return string.toLowerCase();
  }

  TestMirror<T>cast(T testMirror) {

    ClassMirror classMirror = reflectClass(testMirror);
    InstanceMirror instanceMirror = classMirror.newInstance(new Symbol(''), []);
//
//    instanceMirror.setField(new Symbol('map'), _map);

//    classMirror.instanceMembers.values.forEach((value){
//
//      print(value);
//    });

    classMirror.declarations.values.forEach((elem) {

      print(elem);

    });
//    TestMirror<T> newTestMirror = classMirror.invoke()

    return instanceMirror.reflectee;
  }

}
