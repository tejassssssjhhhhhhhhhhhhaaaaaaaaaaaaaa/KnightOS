enum FinanceCategory {
  salary,
  statement,
  emi,
  loan,
  insurance,
  refund,
  investment,
  bill,
  upi,
  creditCard,
  debitCard,
  unknownFinancial,
  nonFinancial,
}

abstract class IFinanceClassificationEngine {
  Future<FinanceCategory> classify(String subject, String body);
}
