// The contents of this file are subject to the Common Public Attribution
// License Version 1.0. (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// https://raw.githubusercontent.com/bgourlie/noBS/master/LICENSE.
// The License is based on the Mozilla Public License Version 1.1, but Sections
// 14 and 15 have been added to cover use of software over a computer network
// and provide for limited attribution for the Original Developer. In addition,
// Exhibit A has been modified to be consistent with Exhibit B.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
// the specific language governing rights and limitations under the License.
//
// The Original Code is noBS Exercise Logger.
//
// The Original Developer is the Initial Developer.  The Initial Developer of
// the Original Code is W. Brian Gourlie.
//
// All portions of the code written by W. Brian Gourlie are Copyright (c)
// 2014-2015 W. Brian Gourlie. All Rights Reserved.

part of storage_engine;

/// Provides implementations to serialize and deserialize [Storable] objects.
abstract class Serializer<T extends Storable> {
  static const String _FK_KEY = '__fk';

  /// This method should not be called directly outside of [Serializer].
  /// Instead, call [serialize].
  Map<String, Object> serializeImpl(T storable);

  /// This method should not be called directly outside of [Serializer].
  /// Instead, call [deserialize].
  T deserializeImpl(Map value);

  /// Serializes a [Storable] object.  If [isForeign] is set to true, the
  /// database key is serialized as well.  This is useful in denormalized
  /// scenarios where you're storing an object with it's own canonical
  /// storage representation in another table.
  Map<String, Object> serialize(T storable, {bool isForeign: false}) {
    final obj = serializeImpl(storable);
    if (isForeign) {
      obj[_FK_KEY] = storable.dbKey;
    }

    return obj;
  }

  /// Deserializes a [Storable] object.
  T deserialize(int key, Map value) {
    _logger.finest('deserializing storable with key $key from $value');
    final T obj = deserializeImpl(value);
    obj.dbKey = key;
    return obj;
  }

  /// Deserializes a [Storable] object who's db key is stored in the row itself.
  T deserializeForeign(Map value) {
    assert(value[_FK_KEY] != null);
    _logger.finest(
        'deserializing storable with key ${value[_FK_KEY]} from $value');
    final T obj = deserializeImpl(value);
    obj.dbKey = value[_FK_KEY];
    return obj;
  }
}
