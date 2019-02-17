type
  DynKind* = enum
    ## Closely modeled after system/hti.nim TNimKind
    dkNone,
    dkBool,
    dkChar,
    dkEmpty,
    dkArrayConstr,
    dkNil,
    dkExpr,
    dkStmt,
    dkTypeDesc,
    dkGenericInvocation, # ``T[a, b]`` for dtypes to invoke
    dkGenericBody,       # ``T[a, b, body]`` last parameter is the body
    dkGenericInst,       # ``T[a, b, realInstance]`` instantiated generic dtype
    dkGenericParam,      # ``a`` in the example
    dkDistinct,          # distinct dtype
    dkEnum,
    dkOrdinal,
    dkArray,
    dkObject,
    dkTuple,
    dkSet,
    dkRange,
    dkPtr,
    dkRef,
    dkVar,
    dkSequence,
    dkProc,
    dkPointer,
    dkOpenArray,
    dkString,
    dkCString,
    dkForward,
    dkInt,
    dkInt8,
    dkInt16,
    dkInt32,
    dkInt64,
    dkFloat,
    dkFloat32,
    dkFloat64,
    dkFloat128,
    dkUInt,
    dkUInt8,
    dkUInt16,
    dkUInt32,
    dkUInt64,
    dkOptAsRef,
    dkVarargsHidden,
    dkUnusedHidden,
    dkProxyHidden,
    dkBuiltInTypeClassHidden,
    dkUserTypeClassHidden,
    dkUserTypeClassInstHidden,
    dkCompositeTypeClassHidden,
    dkInferredHidden,
    dkAndHidden, dkOrHidden, dkNotHidden,
    dkAnythingHidden,
    dkStaticHidden,
    dkFromExprHidden,
    dkOpt,
    dkVoidHidden

  DynNodeKind* = enum 
    ## Modeled closely after system/hti.nim TNimNodeKind
    dnkNone, dnkSlot, dnkList, dnkCase

  DynNode* = object
    ## Modeled closely after system/hti.nim TNimNode
    kind: DynNodeKind
    typ: ref DynType
    name: string
    sons: seq[DynNode]

  DynType* = object
    ## Modeled closely after system/hti.nim TNimType
    case kind*: DynKind
    of dkObject:
      base*: ref DynType
      objNode*: DynNode
    of dkTuple:
      tupNode*: DynNode
    of dkEnum:
      enumNode*: DynNode
    else:
      discard

proc `==`*(x: DynType, y: DynType): bool =
  if x.kind != y.kind:
    return false
  case x.kind:
    of dkObject:
      return x.base == y.base and x.objNode == y.objNode
    of dkTuple:
      return x.tupNode == y.tupNode
    of dkEnum:
      return x.enumNode == y.enumNode
    else:
      return true


proc `=`*(dst: var DynType; src: DynType) =
  dst.kind = src.kind
  case src.kind:
    of dkObject:
      dst.base = src.base
      dst.objNode = src.objNode
    of dkTuple:
      dst.tupNode = src.tupNode
    of dkEnum:
      dst.enumNode = src.enumNode
    else:
      discard

type
  DynValue* {.inheritable.} = object
    dtype*: DynType

  DynInline*[T] = object of DynValue
    val*: T

  DynRef*[T] = object of DynValue
    refVal*: ref T

proc `=`*[T](dst: var DynInLine[T]; src: DynInLine[T]) =
  dst.dtype = src.dtype
  dst.val = src.val

proc `=destroy`*[T](v: var DynInLine[T]) =
  discard

proc `=`*[T](dst: var DynRef[T]; src: DynRef[T]) =
  dst.dtype = src.dtype
  dst.refVal = src.refVal

proc `=destroy`*[T](v: var DynRef[T]) =
  discard

func toDynType(t: type): DynType =
  DynType(kind: dkInt)

func toDynamic*[T](v: T): DynValue =
  DynInline[T](dtype: toDynType(T),
               val: v)
    

