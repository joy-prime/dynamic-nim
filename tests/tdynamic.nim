import unittest, dynamic

test "DynType assignment":
  let t1 = DynType(kind: dkInt)
  check t1.kind == dkInt

proc checkVal[T](v: T, expectedDt: DynType) =
  let d: DynValue  = v.toDynamic
  check d.dtype == expectedDt

test "int":
  checkVal(42,
           DynType(kind: dkInt))

