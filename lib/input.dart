bool isNull(Object o) => o == null;

bool notNull(Object o) => !isNull(o);

bool stringIsNullOrEmpty(String s) => (isNull(s) || s.isEmpty);

String capitalize(String s) =>
    s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1)}';

bool isEvenNumber(int i) => i % 2 == 0;