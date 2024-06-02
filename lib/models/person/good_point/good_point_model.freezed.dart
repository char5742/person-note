// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'good_point_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GoodPoint _$GoodPointFromJson(Map<String, dynamic> json) {
  return _GoodPoint.fromJson(json);
}

/// @nodoc
mixin _$GoodPoint {
  String get id => throw _privateConstructorUsedError;
  String get point => throw _privateConstructorUsedError;
  @UpdatedConverter()
  DateTime? get updated => throw _privateConstructorUsedError;
  @CreatedConverter()
  DateTime? get created => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoodPointCopyWith<GoodPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoodPointCopyWith<$Res> {
  factory $GoodPointCopyWith(GoodPoint value, $Res Function(GoodPoint) then) =
      _$GoodPointCopyWithImpl<$Res, GoodPoint>;
  @useResult
  $Res call(
      {String id,
      String point,
      @UpdatedConverter() DateTime? updated,
      @CreatedConverter() DateTime? created});
}

/// @nodoc
class _$GoodPointCopyWithImpl<$Res, $Val extends GoodPoint>
    implements $GoodPointCopyWith<$Res> {
  _$GoodPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? point = null,
    Object? updated = freezed,
    Object? created = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      point: null == point
          ? _value.point
          : point // ignore: cast_nullable_to_non_nullable
              as String,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoodPointImplCopyWith<$Res>
    implements $GoodPointCopyWith<$Res> {
  factory _$$GoodPointImplCopyWith(
          _$GoodPointImpl value, $Res Function(_$GoodPointImpl) then) =
      __$$GoodPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String point,
      @UpdatedConverter() DateTime? updated,
      @CreatedConverter() DateTime? created});
}

/// @nodoc
class __$$GoodPointImplCopyWithImpl<$Res>
    extends _$GoodPointCopyWithImpl<$Res, _$GoodPointImpl>
    implements _$$GoodPointImplCopyWith<$Res> {
  __$$GoodPointImplCopyWithImpl(
      _$GoodPointImpl _value, $Res Function(_$GoodPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? point = null,
    Object? updated = freezed,
    Object? created = freezed,
  }) {
    return _then(_$GoodPointImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      point: null == point
          ? _value.point
          : point // ignore: cast_nullable_to_non_nullable
              as String,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoodPointImpl with DiagnosticableTreeMixin implements _GoodPoint {
  const _$GoodPointImpl(
      {required this.id,
      required this.point,
      @UpdatedConverter() this.updated,
      @CreatedConverter() this.created});

  factory _$GoodPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoodPointImplFromJson(json);

  @override
  final String id;
  @override
  final String point;
  @override
  @UpdatedConverter()
  final DateTime? updated;
  @override
  @CreatedConverter()
  final DateTime? created;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GoodPoint(id: $id, point: $point, updated: $updated, created: $created)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GoodPoint'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('point', point))
      ..add(DiagnosticsProperty('updated', updated))
      ..add(DiagnosticsProperty('created', created));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoodPointImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.point, point) || other.point == point) &&
            (identical(other.updated, updated) || other.updated == updated) &&
            (identical(other.created, created) || other.created == created));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, point, updated, created);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoodPointImplCopyWith<_$GoodPointImpl> get copyWith =>
      __$$GoodPointImplCopyWithImpl<_$GoodPointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoodPointImplToJson(
      this,
    );
  }
}

abstract class _GoodPoint implements GoodPoint {
  const factory _GoodPoint(
      {required final String id,
      required final String point,
      @UpdatedConverter() final DateTime? updated,
      @CreatedConverter() final DateTime? created}) = _$GoodPointImpl;

  factory _GoodPoint.fromJson(Map<String, dynamic> json) =
      _$GoodPointImpl.fromJson;

  @override
  String get id;
  @override
  String get point;
  @override
  @UpdatedConverter()
  DateTime? get updated;
  @override
  @CreatedConverter()
  DateTime? get created;
  @override
  @JsonKey(ignore: true)
  _$$GoodPointImplCopyWith<_$GoodPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
