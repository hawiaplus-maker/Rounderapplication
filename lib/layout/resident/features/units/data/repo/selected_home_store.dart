import 'package:hive/hive.dart';

/// The home the resident picked on the dashboard's unit selector — a local
/// preference kept in the app's open String box (`rounder_auth`), so the
/// booking journey starts from the same unit without re-asking per order.
class SelectedHomeStore {
  const SelectedHomeStore(this.box);

  static const selectedHomeKey = 'rounder_selected_home';

  final Box<String> box;

  /// `null` when nothing was picked yet or the value is not parseable.
  int? readId() => int.tryParse(box.get(selectedHomeKey) ?? '');

  /// `null` clears the pick.
  Future<void> writeId(int? id) => id == null
      ? box.delete(selectedHomeKey)
      : box.put(selectedHomeKey, '$id');
}
