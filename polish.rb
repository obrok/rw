# -*- coding: iso-8859-2 -*-

POLISH_SMALL = "ąęśćżźółń".split(//)
POLISH_CAPITAL = "ĄĘŚĆŻŹÓŁŃ".split(//)
POLISH = POLISH_SMALL + POLISH_CAPITAL

LETTER = "(?:[a-z]|[A-Z]|#{POLISH.join("|")})"
SMALL_LETTER = "(?:[a-z]|#{POLISH_SMALL.join("|")})"
CAPITAL_LETTER = "(?:[A-Z]|#{POLISH_CAPITAL.join("|")})"
