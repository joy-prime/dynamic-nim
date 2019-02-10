import typeinfo

type

  DynTypeKind* = enum
    ## Closely modeled after system/hti.nim TNimKind
    dtyNone,
    dtyBool,
    dtyChar,
    dtyEmpty,
    dtyArrayConstr,
    dtyNil,
    dtyExpr,
    dtyStmt,
    dtyTypeDesc,
    dtyGenericInvocation, # ``T[a, b]`` for dtypes to invoke
    dtyGenericBody,       # ``T[a, b, body]`` last parameter is the body
    dtyGenericInst,       # ``T[a, b, realInstance]`` instantiated generic dtype
    dtyGenericParam,      # ``a`` in the example
    dtyDistinct,          # distinct dtype
    dtyEnum,
    dtyOrdinal,
    dtyArray,
    dtyObject,
    dtyTuple,
    dtySet,
    dtyRange,
    dtyPtr,
    dtyRef,
    dtyVar,
    dtySequence,
    dtyProc,
    dtyPointer,
    dtyOpenArray,
    dtyString,
    dtyCString,
    dtyForward,
    dtyInt,
    dtyInt8,
    dtyInt16,
    dtyInt32,
    dtyInt64,
    dtyFloat,
    dtyFloat32,
    dtyFloat64,
    dtyFloat128,
    dtyUInt,
    dtyUInt8,
    dtyUInt16,
    dtyUInt32,
    dtyUInt64,
    dtyOptAsRef,
    dtyVarargsHidden,
    dtyUnusedHidden,
    dtyProxyHidden,
    dtyBuiltInTypeClassHidden,
    dtyUserTypeClassHidden,
    dtyUserTypeClassInstHidden,
    dtyCompositeTypeClassHidden,
    dtyInferredHidden,
    dtyAndHidden, dtyOrHidden, dtyNotHidden,
    dtyAnythingHidden,
    dtyStaticHidden,
    dtyFromExprHidden,
    dtyOpt,
    dtyVoidHidden

  DynTypeNodeKind* = enum 
    ## Modeled closely after system/hti.nim TNimNodeKind
    dnkNone, dnkSlot, dnkList, dnkCase

  DynTypeNode* = object
    ## Modeled closely after system/hti.nim TNimNode
    kind: DynTypeNodeKind
    offset: int
    typ: ref DynType
    name: string
    len: int
    sons: seq[DynTypeNode]

  DynType = object
    ## Modeled closely after system/hti.nim TNimTypeFlag
    size: int
    base: ref DynType
    case kind: DynTypeKind
    of dtyObject, dtyTuple, dtyEnum:
      node: ref DynTypeNode
    else:
      discard

  DynValue* {.inheritable.} = object
    dtype*: DynType

  DynCopy*[T] = object of DynValue
    val*: T

  DynHeap*[T] = object of DynValue
    refVal*: ref T
    

