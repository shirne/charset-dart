/// Invalid codepoints or encodings may be substituted with the value U+fffd.
const int unicodeReplacementCharacterCodepoint = 0xfffd;

/// unicode BOM
const int unicodeBom = 0xfeff;

/// unicode BOM Low
const int unicodeUtfBomLo = 0xff;

/// unicode BOM High
const int unicodeUtfBomHi = 0xfe;

/// unicodeByteZeroMask
const int unicodeByteZeroMask = 0xff;

/// unicodeByteOneMask
const int unicodeByteOneMask = 0xff00;

/// unicodeValidRangeMax
const int unicodeValidRangeMax = 0x10ffff;

/// unicodePlaneOneMax
const int unicodePlaneOneMax = 0xffff;

/// unicodeUtf16ReservedLo
const int unicodeUtf16ReservedLo = 0xd800;

/// unicodeUtf16ReservedHi
const int unicodeUtf16ReservedHi = 0xdfff;

/// unicodeUtf16Offset
const int unicodeUtf16Offset = 0x10000;

/// unicodeUtf16SurrogateUnit0Base
const int unicodeUtf16SurrogateUnit0Base = 0xd800;

/// unicodeUtf16SurrogateUnit1Base
const int unicodeUtf16SurrogateUnit1Base = 0xdc00;

/// unicodeUtf16HiMask
const int unicodeUtf16HiMask = 0xffc00;

/// unicodeUtf16LoMask
const int unicodeUtf16LoMask = 0x3ff;
