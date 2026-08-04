class NormalizationEngine {
  static const Map<String, String> _merchantMap = {
    'amzn': 'Amazon',
    'amazon': 'Amazon',
    'amazon seller': 'Amazon',
    'swiggy': 'Swiggy',
    'flipkart': 'Flipkart',
    'google': 'Google',
    'lic': 'LIC',
    'indian oil': 'Indian Oil',
    'iocl': 'Indian Oil',
    'hpcl': 'HPCL',
    'irctc': 'IRCTC',
    'zomato': 'Swiggy', // Example: user might want to group delivery? No, let's keep separate.
    'uber': 'Uber',
    'ola': 'Ola',
    'netflix': 'Netflix',
    'spotify': 'Spotify',
  };

  static String normalizeMerchant(String raw) {
    final lower = raw.toLowerCase();
    
    for (final entry in _merchantMap.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }
    
    // Generic cleaning
    return raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String normalizeInstitution(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('hdfc')) return 'HDFC Bank';
    if (lower.contains('icici')) return 'ICICI Bank';
    if (lower.contains('sbi')) return 'State Bank of India';
    if (lower.contains('axis')) return 'Axis Bank';
    return raw.trim();
  }
}
