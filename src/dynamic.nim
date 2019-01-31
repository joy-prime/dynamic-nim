import typeinfo

type 
  DynKind* = enum
    dkInt

  DynType* = object
    kind*: DynKind

  DynValue* {.inheritable.} = object
    dtype*: DynType
    anyValue: Any

  DynRef*[T] = object of DynValue
    refValue: ref T

proc dynHeapValue*[T](valueRef: ref T): DynRef[T] =
  DynRef[T](dtype: DynType(kind: dkInt), 
                  anyValue: valueRef[].toAny,
                  refValue: valueRef)

proc anyKind*(value: DynValue): AnyKind =
  value.anyValue.kind
    

