import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'security_keys.dart';

part 'serializers.g.dart';

@SerializersFor(
  <Type>[SecurityKeys],
)
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
