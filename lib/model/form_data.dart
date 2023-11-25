class DynamicFormData {
  String? formName;
  List<Sections>? sections;
  List<ValueMapping>? valueMapping;

  DynamicFormData({this.formName, this.sections, this.valueMapping});

  DynamicFormData.fromJson(Map<String, dynamic> json) {
    formName = json['formName'];
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(Sections.fromJson(v));
      });
    }
    if (json['valueMapping'] != null) {
      valueMapping = <ValueMapping>[];
      json['valueMapping'].forEach((v) {
        valueMapping!.add(ValueMapping.fromJson(v));
      });
    }
  }
}

class Sections {
  String? name;
  String? key;
  List<Fields>? fields;

  Sections({this.name, this.key, this.fields});

  Sections.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    key = json['key'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'Sections{name: $name, key: $key, fields: $fields}';
  }
}

class Fields {
  int? id;
  String? key;
  Properties? properties;

  Fields({this.id, this.key, this.properties});

  Fields.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  @override
  String toString() {
    return 'Fields{id: $id, key: $key, properties: $properties}';
  }
}

class Properties {
  String? type;
  dynamic? defaultValue;
  String? hintText;
  int? minLength;
  int? maxLength;
  String? label;
  String? listItems;

  Properties(
      {this.type,
      this.defaultValue,
      this.hintText,
      this.minLength,
      this.maxLength,
      this.label,
      this.listItems});

  Properties.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    defaultValue = json['defaultValue'];
    hintText = json['hintText'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
    label = json['label'];
    listItems = json['listItems'];
  }
}

class ValueMapping {
  List<SearchList>? searchList;
  List<SearchList>? displayList;

  ValueMapping({this.searchList, this.displayList});

  ValueMapping.fromJson(Map<String, dynamic> json) {
    if (json['searchList'] != null) {
      searchList = <SearchList>[];
      json['searchList'].forEach((v) {
        searchList!.add(SearchList.fromJson(v));
      });
    }
    if (json['displayList'] != null) {
      displayList = <SearchList>[];
      json['displayList'].forEach((v) {
        displayList!.add(SearchList.fromJson(v));
      });
    }
  }
}

class SearchList {
  String? fieldKey;
  String? dataColumn;

  SearchList({this.fieldKey, this.dataColumn});

  SearchList.fromJson(Map<String, dynamic> json) {
    fieldKey = json['fieldKey'];
    dataColumn = json['dataColumn'];
  }
}
