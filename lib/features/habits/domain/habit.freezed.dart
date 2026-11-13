// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Habit {

 String get id; DateTime get createdAt; DateTime get updatedAt; DateTime? get deletedAt; String get name; String get icon; String get colorKey; HabitType get type; double get targetValue; String? get unit; FrequencyType get frequencyType; List<int> get weekdays; int get timesPerWeek; int? get reminderTime; String get startDate; DateTime? get archivedAt; int get sortOrder;
/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitCopyWith<Habit> get copyWith => _$HabitCopyWithImpl<Habit>(this as Habit, _$identity);

  /// Serializes this Habit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Habit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Habit&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.colorKey, _this.colorKey) || other.colorKey == _this.colorKey)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.targetValue, _this.targetValue) || other.targetValue == _this.targetValue)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.frequencyType, _this.frequencyType) || other.frequencyType == _this.frequencyType)&&const DeepCollectionEquality().equals(other.weekdays, _this.weekdays)&&(identical(other.timesPerWeek, _this.timesPerWeek) || other.timesPerWeek == _this.timesPerWeek)&&(identical(other.reminderTime, _this.reminderTime) || other.reminderTime == _this.reminderTime)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.archivedAt, _this.archivedAt) || other.archivedAt == _this.archivedAt)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Habit;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.deletedAt,_this.name,_this.icon,_this.colorKey,_this.type,_this.targetValue,_this.unit,_this.frequencyType,const DeepCollectionEquality().hash(_this.weekdays),_this.timesPerWeek,_this.reminderTime,_this.startDate,_this.archivedAt,_this.sortOrder);
}

@override
String toString() {
  final _this = this as Habit;
  return 'Habit(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, deletedAt: ${_this.deletedAt}, name: ${_this.name}, icon: ${_this.icon}, colorKey: ${_this.colorKey}, type: ${_this.type}, targetValue: ${_this.targetValue}, unit: ${_this.unit}, frequencyType: ${_this.frequencyType}, weekdays: ${_this.weekdays}, timesPerWeek: ${_this.timesPerWeek}, reminderTime: ${_this.reminderTime}, startDate: ${_this.startDate}, archivedAt: ${_this.archivedAt}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $HabitCopyWith<$Res>  {
  factory $HabitCopyWith(Habit value, $Res Function(Habit) _then) = _$HabitCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt, String name, String icon, String colorKey, HabitType type, double targetValue, String? unit, FrequencyType frequencyType, List<int> weekdays, int timesPerWeek, int? reminderTime, String startDate, DateTime? archivedAt, int sortOrder
});




}
/// @nodoc
class _$HabitCopyWithImpl<$Res>
    implements $HabitCopyWith<$Res> {
  _$HabitCopyWithImpl(this._self, this._then);

  final Habit _self;
  final $Res Function(Habit) _then;

/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? name = null,Object? icon = null,Object? colorKey = null,Object? type = null,Object? targetValue = null,Object? unit = freezed,Object? frequencyType = null,Object? weekdays = null,Object? timesPerWeek = null,Object? reminderTime = freezed,Object? startDate = null,Object? archivedAt = freezed,Object? sortOrder = null,}) {
  return _then(Habit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,colorKey: null == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HabitType,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,frequencyType: null == frequencyType ? _self.frequencyType : frequencyType // ignore: cast_nullable_to_non_nullable
as FrequencyType,weekdays: null == weekdays ? _self.weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,timesPerWeek: null == timesPerWeek ? _self.timesPerWeek : timesPerWeek // ignore: cast_nullable_to_non_nullable
as int,reminderTime: freezed == reminderTime ? _self.reminderTime : reminderTime // ignore: cast_nullable_to_non_nullable
as int?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Habit].
extension HabitPatterns on Habit {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Habit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Habit() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Habit value)  $default,){
final _that = this;
switch (_that) {
case _Habit():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Habit value)?  $default,){
final _that = this;
switch (_that) {
case _Habit() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt,  String name,  String icon,  String colorKey,  HabitType type,  double targetValue,  String? unit,  FrequencyType frequencyType,  List<int> weekdays,  int timesPerWeek,  int? reminderTime,  String startDate,  DateTime? archivedAt,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Habit() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.name,_that.icon,_that.colorKey,_that.type,_that.targetValue,_that.unit,_that.frequencyType,_that.weekdays,_that.timesPerWeek,_that.reminderTime,_that.startDate,_that.archivedAt,_that.sortOrder);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt,  String name,  String icon,  String colorKey,  HabitType type,  double targetValue,  String? unit,  FrequencyType frequencyType,  List<int> weekdays,  int timesPerWeek,  int? reminderTime,  String startDate,  DateTime? archivedAt,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _Habit():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.name,_that.icon,_that.colorKey,_that.type,_that.targetValue,_that.unit,_that.frequencyType,_that.weekdays,_that.timesPerWeek,_that.reminderTime,_that.startDate,_that.archivedAt,_that.sortOrder);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt,  String name,  String icon,  String colorKey,  HabitType type,  double targetValue,  String? unit,  FrequencyType frequencyType,  List<int> weekdays,  int timesPerWeek,  int? reminderTime,  String startDate,  DateTime? archivedAt,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _Habit() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.name,_that.icon,_that.colorKey,_that.type,_that.targetValue,_that.unit,_that.frequencyType,_that.weekdays,_that.timesPerWeek,_that.reminderTime,_that.startDate,_that.archivedAt,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Habit extends Habit {
  const _Habit({required this.id, required this.createdAt, required this.updatedAt, this.deletedAt, required this.name, required this.icon, required this.colorKey, required this.type, this.targetValue = 1, this.unit, required this.frequencyType,  List<int> weekdays = const <int>[], this.timesPerWeek = 1, this.reminderTime, required this.startDate, this.archivedAt, this.sortOrder = 0}): _weekdays = weekdays,super._();
  factory _Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? deletedAt;
@override final  String name;
@override final  String icon;
@override final  String colorKey;
@override final  HabitType type;
@override@JsonKey() final  double targetValue;
@override final  String? unit;
@override final  FrequencyType frequencyType;
 final  List<int> _weekdays;
@override@JsonKey() List<int> get weekdays {
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdays);
}

@override@JsonKey() final  int timesPerWeek;
@override final  int? reminderTime;
@override final  String startDate;
@override final  DateTime? archivedAt;
@override@JsonKey() final  int sortOrder;

/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitCopyWith<_Habit> get copyWith => __$HabitCopyWithImpl<_Habit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Habit&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.colorKey, colorKey) || other.colorKey == colorKey)&&(identical(other.type, type) || other.type == type)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.frequencyType, frequencyType) || other.frequencyType == frequencyType)&&const DeepCollectionEquality().equals(other.weekdays, _weekdays)&&(identical(other.timesPerWeek, timesPerWeek) || other.timesPerWeek == timesPerWeek)&&(identical(other.reminderTime, reminderTime) || other.reminderTime == reminderTime)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,deletedAt,name,icon,colorKey,type,targetValue,unit,frequencyType,const DeepCollectionEquality().hash(_weekdays),timesPerWeek,reminderTime,startDate,archivedAt,sortOrder);
}

@override
String toString() {
    return 'Habit(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, name: $name, icon: $icon, colorKey: $colorKey, type: $type, targetValue: $targetValue, unit: $unit, frequencyType: $frequencyType, weekdays: $weekdays, timesPerWeek: $timesPerWeek, reminderTime: $reminderTime, startDate: $startDate, archivedAt: $archivedAt, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$HabitCopyWith<$Res> implements $HabitCopyWith<$Res> {
  factory _$HabitCopyWith(_Habit value, $Res Function(_Habit) _then) = __$HabitCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt, String name, String icon, String colorKey, HabitType type, double targetValue, String? unit, FrequencyType frequencyType, List<int> weekdays, int timesPerWeek, int? reminderTime, String startDate, DateTime? archivedAt, int sortOrder
});




}
/// @nodoc
class __$HabitCopyWithImpl<$Res>
    implements _$HabitCopyWith<$Res> {
  __$HabitCopyWithImpl(this._self, this._then);

  final _Habit _self;
  final $Res Function(_Habit) _then;

/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? name = null,Object? icon = null,Object? colorKey = null,Object? type = null,Object? targetValue = null,Object? unit = freezed,Object? frequencyType = null,Object? weekdays = null,Object? timesPerWeek = null,Object? reminderTime = freezed,Object? startDate = null,Object? archivedAt = freezed,Object? sortOrder = null,}) {
  return _then(_Habit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,colorKey: null == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HabitType,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,frequencyType: null == frequencyType ? _self.frequencyType : frequencyType // ignore: cast_nullable_to_non_nullable
as FrequencyType,weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,timesPerWeek: null == timesPerWeek ? _self.timesPerWeek : timesPerWeek // ignore: cast_nullable_to_non_nullable
as int,reminderTime: freezed == reminderTime ? _self.reminderTime : reminderTime // ignore: cast_nullable_to_non_nullable
as int?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
