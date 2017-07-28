# Copyright (c) 2017 Xored Software, Inc.

import godotbase

type
  Color* {.byref.} = object
    r*: float32
    g*: float32
    b*: float32
    a*: float32

proc initColor*(r, g, b: float32; a: float32 = 1.0'f32): Color {.inline.} =
  Color(
    r: r,
    g: g,
    b: b,
    a: a
  )

proc initColor*(): Color {.inline.} =
  ## Initializes black color with 1.0 alpha
  initColor(0, 0, 0)

proc h*(self: Color): float32 {.
    importc: "godot_color_get_h".}
proc s*(self: Color): float32 {.
    importc: "godot_color_get_s".}
proc v*(self: Color): float32 {.
    importc: "godot_color_get_v".}

proc `$`*(self: Color): string {.inline.} =
  result = newStringOfCap(50)
  result.add($self.r)
  result.add(", ")
  result.add($self.g)
  result.add(", ")
  result.add($self.b)
  result.add(", ")
  result.add($self.a)

proc toHex(val: float32, target: var string, targetIdx: int) =
  let val = clamp(int(val * 255), 0, 255)
  let nums = [(val and 0xF0) shr 4, val and 0xF]
  for i, num in nums:
    target[targetIdx + i] = if num < 10: chr(ord('0') + num)
                            else: chr(ord('A') + (num - 10))

proc toHtml*(self: Color, withAlpha: bool): string =
  let size = if withAlpha: 8 else: 6
  result = newString(size)
  toHex(self.r, result, 0)
  toHex(self.g, result, 2)
  toHex(self.b, result, 4)
  if withAlpha:
    toHex(self.b, result, 6)

proc toARGB32*(self: Color): uint32 {.inline.} =
  result = uint8(self.a * 255)
  result = (result shl 8) or uint8(self.r * 255)
  result = (result shl 8) or uint8(self.g * 255)
  result = (result shl 8) or uint8(self.b * 255)

proc gray*(self: Color): float32 {.
    importc: "godot_color_gray".}
proc inverted*(self: Color): Color {.
    importc: "godot_color_inverted".}
proc contrasted*(self: Color): Color {.
    importc: "godot_color_contrasted".}
proc lerp*(self: Color; b: Color; t: float32): Color {.
    importc: "godot_color_linear_interpolate".}
proc blend*(self: Color; over: Color): Color {.
    importc: "godot_color_blend".}

proc `==`*(a, b: Color): bool {.inline.} =
  a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a

proc `<`*(a, b: Color): bool =
  if a.r == b.r:
    if a.g == b.g:
      if a.b == b.b:
        return a.a < b.a
      return a.b < b.b
    return a.g < b.g
  return a.r < b.r
