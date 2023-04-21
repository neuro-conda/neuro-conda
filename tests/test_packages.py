#!~/.local/miniconda3/envs/neuroconda
#
# Test basic functionality of all provided packages
#

import os
import pytest
import pathlib
import importlib
import yaml
import platform

@pytest.mark.full
def test_packages():

    # Mainly for illustration purposes: run ACME's test suite
    import acme
    acmePath = str(pathlib.Path(acme.__file__).resolve().parent)
    pytest.main(["-v", acmePath])

    return

def test_imports():

    # We only do this for the current neuro-conda environment
    ncDir = pathlib.Path(__file__).resolve().parents[1]
    envFile = ncDir / "envs" / "neuro-conda-latest.yml"
    with open(envFile, "r", encoding="utf-8") as ymlFile:
        ymlDict = yaml.safe_load(ymlFile)

    # Don't attempt to import these packages
    ignorePkgs = ["python", "r-", "pip", "pytest", "hdf5"]

    # Additionally, don't bother trying to import these packages in a CI run
    if os.getenv("ncCI"):
         ignorePkgs += ["invertmeeg", "torchaudio", "tensorflow"]

    # Packages whose name does not correspond to their Python module name
    pkgMap = {
         "esi-acme" : "acme",
         "esi-syncopy" : "syncopy",
         "invertmeeg" : "invert",
         "opencv-python" : "cv2",
         "pybids" : "bids",
         "pywavelets" : "pywt",
         "scikit-image" : "skimage",
         "scikit-learn" : "sklearn",
         "scikit-learn-intelex" : "sklearnex",
    }

    # Split off pip-installed packages since those contain additional
    # platform/arch restrictions that have to be dealt with separately
    pipDeps = ymlDict["dependencies"].pop(-1)

    # Filter based on platform specs
    pkgList = ymlDict["dependencies"]
    for pkg in pipDeps["pip"]:
        platformSpec = pkg.partition("platform_")[-1]
        if not platformSpec or platform.system() in platformSpec or platform.machine() in platformSpec:
                pkgList.append(pkg.partition(";")[0])

    # Filter based on above ignore-list
    pkgList = [pkg for pkg in pkgList if not any(pkg.startswith(rmpkg) for rmpkg in ignorePkgs)]

    # Remove version specifiers (if present) from package name
    pkgList = [pkg.partition("=")[0].partition("<")[0].partition(">")[0] for pkg in pkgList]

    # Map packages to their correct module names
    for pkgName, modName in pkgMap.items():
         if pkgName in pkgList:
              pkgList[pkgList.index(pkgName)] = modName

    # Replace dashes (okay for package-names, not for modules) with underlines
    pkgList = [pkg.replace("-", "_") for pkg in pkgList]

    # Remove installation specifiers (e.g., `[full]`)
    pkgList = [pkg.partition("[")[0] for pkg in pkgList]

    # Finally start the actual test
    print("\n")
    for pkg in pkgList:
        print(">>> importing ", pkg)
        importlib.import_module(pkg)

    return
