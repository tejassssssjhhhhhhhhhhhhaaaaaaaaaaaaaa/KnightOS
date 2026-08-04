import 'package:drift/drift.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';

class IdentityResolutionService {
  IdentityResolutionService({required this.db});
  final KnightDatabase db;

  final Map<String, String> _staticAliasMap = {
    'AMAZON INDIA': 'AMAZON',
    'AMAZON PAY': 'AMAZON',
    'AMAZON.IN': 'AMAZON',
    'SWIGGY INSTAMART': 'SWIGGY',
    'SWIGGY FOOD': 'SWIGGY',
    'UBER INDIA': 'UBER',
    'UBER EATS': 'UBER',
    'HDFC BANK': 'HDFC',
    'HDFC CREDIT CARD': 'HDFC',
  };

  /// Returns the canonical identity ID for a raw name.
  Future<String?> resolve(String rawName, String category) async {
    final normalized = rawName.trim().toUpperCase();
    
    // 1. Check static aliases
    String target = normalized;
    if (_staticAliasMap.containsKey(normalized)) {
      target = _staticAliasMap[normalized]!;
    }

    // 2. Check DB aliases
    final dbIdentity = await db.canonicalIdentityDao.resolveFromAlias(normalized);
    if (dbIdentity != null) return dbIdentity.id;

    // 3. Check if exact canonical name exists
    final existing = await db.canonicalIdentityDao.getByName(target);
    if (existing != null) {
      // Map the variation to the existing canonical
      await db.canonicalIdentityDao.registerAlias(normalized, existing.id);
      return existing.id;
    }

    // 4. Create new canonical identity
    final id = 'can-${DateTime.now().microsecondsSinceEpoch}';
    await db.into(db.canonicalIdentityTable).insert(CanonicalIdentityTableCompanion.insert(
      id: id,
      canonicalName: target,
      category: category,
      updatedAt: Value(DateTime.now()),
    ));

    // Register variation
    if (normalized != target) {
      await db.canonicalIdentityDao.registerAlias(normalized, id);
    }

    KnightLogger.info('[IDENTITY] Resolved "$rawName" to canonical $target ($id)');
    return id;
  }
}
