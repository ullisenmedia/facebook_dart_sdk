import 'dart:mirrors';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import '../lib/facebook.dart';

void main() {

  useHtmlConfiguration();

  var json = '{"bio":"Love sports of all kinds.","birthday":"01/01/1980","favorite_athletes":[{"id":"20242388857","name":"Usain Bolt"}],"first_name":"Chris","hometown":{"id":"106033362761104","name":"Campbell, Caifornia"},"id":"100003086810435","languages":[{"id":"108106272550772","name":"French"},{"id":"312525296370","name":"Spanish"}],"last_name":"Colm","link":"http://www.facebook.com/chris.colm","locale":"en_US","location":{"id":"104048449631599","name":"Menlo Park, California"},"middle_name":"Abe","name":"Chris Abe Colm","timezone":"-7","updated_time":"2012-08-09T03:33:32+0000","username":"chris.colm","verified":1}';

  test('test graph object', () {

    Map<string , dynamic> map = new Map();

    JSON.decode(json, reviver: (key, value) {

      map[key] = value;
    });

    GraphObject graphObject = new GraphObject(map);

    expect(graphObject.getProperty('name'), map['name']);
    expect(graphObject.getProperty('languages'), map['languages']);
    expect(graphObject.getProperty('birthday', type: DateTime), new DateFormat.yMd('en_US').parse(map['birthday']));
  });

  test('test graph user object', () {

    Map<string , dynamic> map = new Map();

    JSON.decode(json, reviver: (key, value) {

      map[key] = value;
    });

    GraphObject graphObject = new GraphObject(map);
    GraphUser graphUser = graphObject.cast(GraphUser);

    expect(graphUser.name, map['name']);
    expect(graphUser.birthday, new DateFormat.yMd('en_US').parse(map['birthday']));

  });

}