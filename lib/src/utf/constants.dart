/// Invalid codepoints or encodings may be substituted with the value U+fffd.
const int unicodeReplacementCharacterCodepoint = 0xfffd;
const int unicodeBom = 0xfeff;
const int unicodeUtfBomLo = 0xff;
const int unicodeUtfBomHi = 0xfe;

const int unicodeByteZeroMask = 0xff;
const int unicodeByteOneMask = 0xff00;
const int unicodeValidRangeMax = 0x10ffff;
const int unicodePlaneOneMax = 0xffff;
const int unicodeUtf16ReservedLo = 0xd800;
const int unicodeUtf16ReservedHi = 0xdfff;
const int unicodeUtf16Offset = 0x10000;
const int unicodeUtf16SurrogateUnit0Base = 0xd800;
const int unicodeUtf16SurrogateUnit1Base = 0xdc00;
const int unicodeUtf16HiMask = 0xffc00;
const int unicodeUtf16LoMask = 0x3ff;
