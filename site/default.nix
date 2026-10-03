{ mkDerivation, base, filepath, hakyll, hakyll-images, lib, pandoc, slugger, text }:
mkDerivation {
  pname = "caret";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base filepath hakyll hakyll-images pandoc slugger text ];
  license = lib.licenses.bsd3;
  mainProgram = "caret";
}  
