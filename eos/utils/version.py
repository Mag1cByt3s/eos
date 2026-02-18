"""
Versions helper.

Small version wrapper used for Symfony version comparisons.
"""

from __future__ import annotations

import re
from functools import total_ordering


@total_ordering
class Version:
    """
    EOS Version.

    distutils was removed from the stdlib in Python 3.12+, so we keep a tiny
    implementation that supports the comparisons EOS needs (e.g. "4.1" <= "4.4").
    """

    def __init__(self, value):
        self.raw = str(value)

        # Extract the first dotted numeric version-like substring.
        # Examples:
        # - "5.0.1" -> (5, 0, 1)
        # - "Symfony 5.0.1" -> (5, 0, 1)
        # - "5.0.1-rc1" -> (5, 0, 1)
        match = re.search(r"\d+(?:\.\d+)*", self.raw)
        if match:
            self.parts = tuple(int(p) for p in match.group(0).split("."))
        else:
            self.parts = (0,)

    def _cmp_tuple(self, other: object) -> tuple[tuple[int, ...], tuple[int, ...]]:
        other_version = other if isinstance(other, Version) else Version(other)

        max_len = max(len(self.parts), len(other_version.parts))
        left = self.parts + (0,) * (max_len - len(self.parts))
        right = other_version.parts + (0,) * (max_len - len(other_version.parts))
        return left, right

    def __eq__(self, other: object) -> bool:
        left, right = self._cmp_tuple(other)
        return left == right

    def __lt__(self, other: object) -> bool:
        left, right = self._cmp_tuple(other)
        return left < right

    def __str__(self) -> str:
        return self.raw
