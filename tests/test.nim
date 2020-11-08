import strformat, ../src/zippy

const
  zs = [
    "randtest1.z",
    "randtest2.z",
    "randtest3.z",
    "rfctest1.z",
    "rfctest2.z",
    "rfctest3.z",
    "tor-list.z",
    "zerotest1.z",
    "zerotest2.z",
    "zerotest3.z",
  ]
  golds = [
    "randtest1.gold",
    "randtest2.gold",
    "randtest3.gold",
    "rfctest1.gold",
    "rfctest2.gold",
    "rfctest3.gold",
    "tor-list.gold",
    "zerotest1.gold",
    "zerotest2.gold",
    "zerotest3.gold",
    "empty.gold",
    "alice29.txt",
    "asyoulik.txt",
    "fireworks.jpg",
    "geo.protodata",
    "html",
    "html_x_4",
    "kppkn.gtb",
    "lcet10.txt",
    "paper-100k.pdf",
    "plrabn12.txt",
    "urls.10K"
  ]

for i, z in zs:
  let
    compressed = readFile(&"tests/data/{z}")
    gold = readFile(&"tests/data/{golds[i]}")
  echo &"{z} compressed: {z.len} gold: {gold.len}"
  doAssert uncompress(compressed) == gold

block fixed:
  let
    compressed = readFile(&"tests/data/fixed.z")
    gold = readFile(&"tests/data/urls.10K")
  doAssert uncompress(compressed) == gold

for gold in golds:
  let
    original = readFile(&"tests/data/{gold}")
    compressed = compress(original)
    uncompressed = uncompress(compressed)
  echo &"{gold} original: {original.len} compressed: {compressed.len}"
  doAssert original == uncompressed

block all_uint8:
  var original: seq[uint8]
  for i in 0.uint8 .. high(uint8):
    original.add(i)
  let compressed = compress(original)
  echo &"all_uint8 original: {original.len} compressed: {compressed.len}"
  doAssert original == uncompress(compressed)

# let
#   original = cast[seq[uint8]]("zSAM SAM SAM a SAM SAM SAMz")
#   encoded = compress(original)
# echo &"original: {original.len} encoded: {encoded.len}"
# echo cast[string](uncompress(encoded))
# doAssert original == uncompress(encoded)

let
  compressed = cast[seq[uint8]](readFile("tests/data/gzipfiletest.txt.gz"))
  original = readFile("tests/data/gzipfiletest.txt")
  uncompressed = cast[string](gzu(compressed))
echo cast[string](uncompressed)
assert original == uncompressed
