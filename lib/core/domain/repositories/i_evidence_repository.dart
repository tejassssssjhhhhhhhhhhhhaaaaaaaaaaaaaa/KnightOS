import '../entities/evidence.dart';

abstract class IEvidenceRepository {
  Future<void> store(Evidence evidence);
  Future<Evidence?> getByCaid(String caid);
  Future<List<Evidence>> getAll();
}
