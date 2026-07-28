import '../../core/repositories/finance_repository.dart';
import '../../core/repositories/fitness_repository.dart';
import '../../core/repositories/sleep_repository.dart';
import '../../core/repositories/user_repository.dart';
import '../../core/repositories/work_repository.dart';
import '../../core/platform/storage/storage_engine.dart';
import '../finance/domain/finance_transaction.dart';
import '../fitness/domain/workout_session.dart';
import 'dashboard_models.dart';

class DashboardRepository {
  DashboardRepository({
    required StorageEngine engine,
    UserRepository? userRepository,
    SleepRepository? sleepRepository,
    FitnessRepository? fitnessRepository,
    FinanceRepository? financeRepository,
    WorkRepository? workRepository,
  }) : _userRepository = userRepository ?? UserRepository(engine: engine),
       _sleepRepository = sleepRepository ?? SleepRepository(),
       _fitnessRepository = fitnessRepository ?? FitnessRepository(),
       _financeRepository = financeRepository ?? FinanceRepository(),
       _workRepository = workRepository ?? WorkRepository(engine: engine);

  final UserRepository _userRepository;
  final SleepRepository _sleepRepository;
  final FitnessRepository _fitnessRepository;
  final FinanceRepository _financeRepository;
  final WorkRepository _workRepository;

  Future<DashboardData> loadDashboardData() async {
    final profileFuture = _userRepository.loadProfile();
    final sleepFuture = _sleepRepository.loadSessions();
    final fitnessFuture = _fitnessRepository.loadSessions();
    final financeFuture = _financeRepository.loadTransactions();
    final workFuture = _workRepository.loadSessions();

    final profile = await profileFuture;
    final sleepSessions = await sleepFuture;
    final workoutSessions = await fitnessFuture;
    final financeTransactions = await financeFuture;
    final workSessions = await workFuture;

    final financeMetrics = FinanceTransactionMetrics.fromTransactions(
      financeTransactions,
    );
    final fitnessMetrics = WorkoutSessionMetrics.fromSessions(workoutSessions);

    return DashboardData(
      profile: profile,
      sleepSessions: sleepSessions,
      workoutSessions: workoutSessions,
      workSessions: workSessions,
      financeTransactions: financeTransactions,
      financeMetrics: financeMetrics,
      fitnessMetrics: fitnessMetrics,
    );
  }
}
