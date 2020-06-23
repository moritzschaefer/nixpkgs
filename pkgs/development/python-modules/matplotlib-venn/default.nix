{ stdenv, buildPythonPackage, fetchPypi, pytest, matplotlib, numpy, scipy }:
buildPythonPackage rec {
  version = "0.11.5";
  pname = "matplotlib-venn";

  src = builtins.fetchGit {
    url = "git://github.com/konstantint/matplotlib-venn";
    rev = "c26796c9925bdac512edf48387452fbd1848c791";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ matplotlib numpy scipy ];

  checkPhase = ''
    pytest
  '';

  # Tests require extra dependencies
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/konstantint/matplotlib-venn";
    description = "Area-weighted venn-diagrams for Python/matplotlib";
    license = licenses.mit;
  };
}
