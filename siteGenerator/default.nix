{ mkDerivation, base, filepath, hakyll, lib, pandoc, sligger, text }:

mkDerivation {
  pname = "siteGenerator";
  version = "0.1.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base filepath hakyll pandoc slugger text ];
  license = lib.licenses.bsd3;
  mainProgram = "hakyll-site";
}
