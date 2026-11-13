// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_completion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitCompletion {

 String get id; DateTime get createdAt; DateTime get updatedAt; DateTime? get deletedAt; String get habitId; String get date; double get value; String? get note; DateTime? get completedAt;
/// Create a copy of HabitCompletion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitCompletionCopyWith<HabitCompletion> get copyWith => _$HabitCompletionCopyWithImpl<HabitCompletion>(this as HabitCompletion, _$identity);

  /// Serializes this HabitCompletion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HabitCompletion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitCompletion&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.habitId, _this.habitId) || other.habitId == _this.habitId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HabitCompletion;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.deletedAt,_this.habitId,_this.date,_this.value,_this.note,_this.completedAt);
}

@override
String toString() {
  final _this = this as HabitCompletion;
  return 'HabitCompletion(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, deletedAt: ${_this.deletedAt}, habitId: ${_this.habitId}, date: ${_this.date}, value: ${_this.value}, note: ${_this.note}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $HabitCompletionCopyWith<$Res>  {
  factory $HabitCompletionCopyWith(HabitCompletion value, $Res Function(HabitCompletion) _then) = _$HabitCompletionCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt, String habitId, String date, double value, String? note, DateTime? completedAt
});




}
/// @nodoc
class _$HabitCompletionCopyWithImpl<$Res>
    implements $HabitCompletionCopyWith<$Res> {
  _$HabitCompletionCopyWithImpl(this._self, this._then);

  final HabitCompletion _self;
  final $Res Function(HabitCompletion) _then;

/// Create a copy of HabitCompletion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? habitId = null,Object? date = null,Object? value = null,Object? note = freezed,Object? completedAt = freezed,}) {
  return _then(HabitCompletion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitCompletion].
extension HabitCompletionPatterns on HabitCompletion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitCompletion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitCompletion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitCompletion value)  $default,){
final _that = this;
switch (_that) {
case _HabitCompletion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitCompletion value)?  $default,){
final _that = this;
switch (_that) {
case _HabitCompletion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt,  String habitId,  String date,  double value,  String? note,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitCompletion() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.habitId,_that.date,_that.value,_that.note,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt,  String habitId,  String date,  double value,  String? note,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _HabitCompletion():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.habitId,_that.date,_that.value,_that.note,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt,  String habitId,  String date,  double value,  String? note,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _HabitCompletion() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.habitId,_that.date,_that.value,_that.note,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitCompletion implements HabitCompletion {
  const _HabitCompletion({required this.id, required this.createdAt, required this.updatedAt, this.deletedAt, required this.habitId, required this.date, this.value = 1, this.note, this.completedAt});
  factory _HabitCompletion.fromJson(Map<String, dynamic> json) => _$HabitCompletionFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? deletedAt;
@override final  String habitId;
@override final  String date;
@override@JsonKey() final  double value;
@override final  String? note;
@override final  DateTime? completedAt;

/// Create a copy of HabitCompletion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitCompletionCopyWith<_HabitCompletion> get copyWith => __$HabitCompletionCopyWithImpl<_HabitCompletion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitCompletionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitCompletion&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.habitId, habitId) || other.habitId == habitId)&&(identical(other.date, date) || other.date == date)&&(identical(other.value, value) || other.value == value)&&(identical(other.note, note) || other.note == note)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,deletedAt,habitId,date,value,note,completedAt);
}

@override
String toString() {
    return 'HabitCompletion(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, habitId: $habitId, date: $date, value: $value, note: $note, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$HabitCompletionCopyWith<$Res> implements $HabitCompletionCopyWith<$Res> {
  factory _$HabitCompletionCopyWith(_HabitCompletion value, $Res Function(_HabitCompletion) _then) = __$HabitCompletionCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt, String habitId, String date, double value, String? note, DateTime? completedAt
});




}
/// @nodoc
class __$HabitCompletionCopyWithImpl<$Res>
    implements _$HabitCompletionCopyWith<$Res> {
  __$HabitCompletionCopyWithImpl(this._self, this._then);

  final _HabitCompletion _self;
  final $Res Function(_HabitCompletion) _then;

/// Create a copy of HabitCompletion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? habitId = null,Object? date = null,Object? value = null,Object? note = freezed,Object? completedAt = freezed,}) {
  return _then(_HabitCompletion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,habitId: null == habitId ? _self.habitId : habitId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
