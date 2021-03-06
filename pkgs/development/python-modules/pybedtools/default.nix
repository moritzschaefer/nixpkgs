{ bash, stdenv, buildPythonPackage, fetchPypi, numpy, pandas, pysam, six,
  pytest, numpydoc, psutil, pyyaml, sphinx, zlib, bedtools, python
}:
buildPythonPackage rec {
  version = "0.8.1";
  pname = "pybedtools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c035e078617f94720eb627e20c91f2377a7bd9158a137872a6ac88f800898593";
  };

  checkInputs = [ pytest numpydoc psutil pyyaml sphinx ];
  propagatedBuildInputs = [ numpy pandas pysam six zlib bash bedtools ];

  # checkPhase = ''
    # pytest -v --doctest-modules
  # '';
  pythonImportsCheck = [ "pybedtools" ];

  doCheck = false;  # both pytest and import-test do not work in checkPhase because the built pyx file cannot be importet

  meta = with stdenv.lib; {
    homepage = "https://github.com/daler/pybedtools";
    description = "Python wrapper -- and more -- for Aaron Quinlan's BEDTools (bioinformatics tools) http://daler.github.io/pybedtools";
    license = licenses.gpl2;
    maintainers = [ maintainers.moritzs ];
  };
}
