{ lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "eos";
  version = "1.0.0";

  src = lib.cleanSource ./.;

  # setup.py (setuptools), no pyproject.toml
  pyproject = false;

  nativeBuildInputs = with python3Packages; [
    setuptoolsBuildHook
    pypaInstallHook
    # setup.py imports `eos`, which imports `requests` (see eos.Dockerfile).
    requests
    beautifulsoup4
    lxml
  ];

  propagatedBuildInputs = with python3Packages; [
    requests
    beautifulsoup4
    lxml
  ];

  pythonImportsCheck = [
    "eos"
  ];

  meta = with lib; {
    description = "Enemies Of Symfony";
    homepage = "https://github.com/synacktiv/eos";
    license = licenses.gpl3Only;
    mainProgram = "eos";
  };
}
