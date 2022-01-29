import std/os, std/strformat, zippy/tarballs

let testFilePath = "tests/data/tarballs/Nim-1.6.2.tar.gz"

removeDir("tmp/tar")

createDir("tmp/tar")
extractAll(testFilePath, "tmp/tar/zippy")

createDir("tmp/tar/gold")
let cmd = &"tar -xf {testFilePath} -C tmp/tar/gold"
doAssert execShellCmd(cmd) == 0

for path in walkDirRec("tmp/tar/gold", relative = true):
  let
    goldPath = "tmp/tar/gold" / path
    zippyPath = "tmp/tar/zippy" / path

  if dirExists(goldPath):
    doAssert dirExists(zippyPath)
  else:
    when defined(windows):
      # tar on Windows creates this monster, zippy handles this file correctly
      if path == "Nim-1.6.2\\tests\\misc\\\226\148\156\195\145\226\148\156\195\177\226\148\156\226\149\162.nim":
        continue
    doAssert fileExists(zippyPath)
    doAssert readFile(goldPath) == readFile(zippyPath)

  when defined(windows):
    doAssert getFilePermissions(goldPath) == getFilePermissions(zippyPath)
  doAssert getLastModificationTime(goldPath) == getLastModificationTime(zippyPath)

removeDir("tmp/tar")
