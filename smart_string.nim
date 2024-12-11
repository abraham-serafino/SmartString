type Str = object
  data: ptr UncheckedArray[char] = nil
  len: 0 .. high(int) = 0

proc `=copy`* (left: var Str, right: Str) =
  let
    len = right.len
    rightData = cast[pointer](right.data)
    leftData = alloc0(len * sizeof(char) + 1)

  assert leftData != nil, "Could not reserve space for string"

  if left.data != nil: dealloc(left.data)
  leftData.copyMem(rightData, len)

  left.len = len
  left.data = cast[ptr UncheckedArray[char]](leftData)
  left.data[len] = '\0';

proc `=destroy`* (this: var Str) =
  when isMainModule: echo "Destroyed"

  if this.data != nil: dealloc(this.data)
  this.data = nil
  this.len = 0

proc `$`* (str: string): Str =
  let
    len = str.len
    data = alloc0(len * sizeof(char) + 1)

  assert data != nil, "Could not reserve space for string"

  result.len = len
  result.data = cast [ptr UncheckedArray[char]](data)

  for i in 0 ..< len:
    result.data[i] = str[i]

  result.data[len] = '\0'

proc `$`* (this: Str): cstring =
  cast[cstring](this.data)

proc `+`* (left: Str, right: Str): Str =
  let
    leftLen = left.len
    rightLen = right.len
    leftData = cast[pointer](left.data)
    rightData = cast[pointer](right.data)
    len = rightLen + leftLen
    data = alloc0(len * sizeof(char) + 1)

  assert data != nil, "Could not reserve space for string"

  data.copyMem(leftData, leftLen)

  let nextIndex = cast[pointer](cast[int](data) +
    (leftLen * sizeof(char)))
  nextIndex.copyMem(rightData, rightLen)

  result.len = len
  result.data = cast[ptr UncheckedArray[char]](data)
  result.data[len] = '\0'

proc append* (left: var Str, right: Str) =
  let
    leftLen = left.len
    rightLen = right.len
    leftData = cast[pointer](left.data)
    rightData = cast[pointer](right.data)
    len = rightLen + leftLen
    data = alloc0(len * sizeof(char) + 1)

  assert data != nil, "Could not reserve space for string"

  data.copyMem(leftData, leftLen)

  let nextIndex = cast[pointer](cast[int](data) +
    (leftLen * sizeof(char)))
  nextIndex.copyMem(rightData, rightLen)

  left.len = len
  left.data = cast[ptr UncheckedArray[char]](data)
  left.data[len] = '\0'

proc `+=`* (left: var Str, right: Str) =
  left.append(right)

when isMainModule:
  var
    message = $"Hello"
    newMessage = message

  message += $"\n"
  newMessage += $" world\n"

  echo $(message + newMessage)
