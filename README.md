[![Test Installation](https://github.com/neuro-conda/neuro-conda/actions/workflows/test-fresh-installation.yml/badge.svg)](https://github.com/neuro-conda/neuro-conda/actions/workflows/test-fresh-installation.yml)

# neuro-conda 🧠🐍

Although creating a virtual environment for each project is considered best practice, it can be a major obstacle for early-career neuroscientists that are just starting to learn programming. **neuro-conda** aims to simplify learning and using Python in neuroscience by bundling commonly used packages in neuroscience into curated conda environments, i.e. providing a **Python distribution for neuroscience based on [conda](https://www.anaconda.com)**

Currently neuro-conda includes the following neuroscientific Python packages (in alphabetic order):

- [bycycle](https://bycycle-tools.github.io)
- [dipy](https://dipy.org/)
- [elephant](https://elephant.readthedocs.io) + [viziphant](https://viziphant.readthedocs.io)
- [esi-syncopy](https://syncopy.readthedocs.io)
- [fooof](https://fooof-tools.github.io)
- [intensity-normalization](https://intensity-normalization.readthedocs.io/en/latest/readme.html)
- [mne](https://mne.tools) including the extensions:
  - [alphaCSC](https://alphacsc.github.io/stable/index.html)
  - [eelbrain](https://eelbrain.readthedocs.io/en/stable/index.html)
  - [invertmeeg](https://github.com/LukeTheHecker/invert) (only on Linux)
  - [mne-ari](https://github.com/john-veillette/mne-ari)
  - [mne-bids](https://mne.tools/mne-bids/stable/index.html)
  - [mne-bids-pipeline](https://mne.tools/mne-bids-pipeline/1.1/index.html)
  - [mne-connectivity](https://mne.tools/mne-connectivity/stable/index.html)
  - [mne-features](https://mne.tools/mne-features/)
  - [mne-icalabel](https://mne.tools/mne-icalabel/stable/index.html)
  - [mnelab](https://mnelab.readthedocs.io/en/latest/index.html)
  - [mne-microstates](https://github.com/wmvanvliet/mne_microstates)
  - [mne-nirs](https://mne.tools/mne-nirs/stable/index.html)
  - [mne-realtime](https://mne.tools/mne-realtime/)
  - [mne-rsa](https://users.aalto.fi/~vanvlm1/mne-rsa/)
  - [pactools](https://pactools.github.io/index.html)
  - [pyprep](https://github.com/sappelhoff/pyprep)
  - [sesameeg](https://pybees.github.io/sesameeg/)
- [neo](https://neo.readthedocs.io)
- [neurodsp](https://neurodsp-tools.github.io)
- [nibabel](https://nipy.org/nibabel/) + [napari-nibabel](https://nipy.org/packages/napari-nibabel/index.html)
- [nilearn](https://nilearn.github.io/stable/index.html)
- [nipype](https://nipype.readthedocs.io/en/latest/)
- [nitime](https://nipy.org/nitime/) (only on Windows and Linux)
- [nixio](https://nixio.readthedocs.io)
- [pybids](https://bids-standard.github.io/pybids/)
- [pydicom](https://pydicom.github.io/) + [deid](https://pydicom.github.io/deid/)
- [pynwb](https://pynwb.readthedocs.io)
- [spikeinterface](https://spikeinterface.readthedocs.io)

More neuroscience tools will be added in the future. Please open an [issue](https://github.com/neuro-conda/neuro-conda/issues) or [pull request](https://github.com/neuro-conda/neuro-conda/pulls) if you'd like a specific package to be included.

Other included non-neuroscience packages are (see [the environment files](/envs) for details)

- [dask](https://www.dask.org)
- [esi-acme](https://esi-acme.readthedocs.io)
- [HDF5](https://www.hdfgroup.org/solutions/hdf5/) + [h5py](https://www.h5py.org/)
- [imageio](https://imageio.readthedocs.io/en/stable/)
- [jupyter](https://jupyter.org)
- [NumPy](https://numpy.org/)
- [SciPy](https://scipy.org/)
- [Matplotlib](https://matplotlib.org/) + [Seaborn](https://seaborn.pydata.org/)
- [R](https://www.r-project.org/)

On Linux, several machine-learning tools are installed as well:

- [tensorflow](https://www.tensorflow.org)
- [PyTorch](https://pytorch.org)
- [scikit-learn](https://scikit-learn.org)

neuro-conda is inspired by similar projects at the [Ernst Strüngmann Institute for Neuroscience](https://github.com/esi-neuroscience/esi-conda), [University of Cambridge](https://github.com/jooh/neuroconda) and [NeuroDesk](https://www.neurodesk.org), providing easy-to-install Python environments for neuroscience.

## Fresh installation

### Windows 10 and 11 (PowerShell)

Open a PowerShell and run the following command:

```PowerShell
Invoke-WebRequest https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/libexec/install.ps1 -OutFile $Env:temp\install_neuroconda.ps1; Invoke-Expression $Env:temp\install_neuroconda.ps1;
```

### Linux and Windows Subsystem for Linux (WSL)

Open a terminal and run the following command:

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/libexec/install.sh)"
```

### macOS

Open `Terminal.App` and run the following command:

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/libexec/install.sh)"
```

## Install neuro-conda using an existing conda installation

### Windows 10/11 (PowerShell)

```
Invoke-WebRequest "https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/envs/neuro-conda-latest.yml" -OutFile "$Env:temp\neuro-conda-latest.yml"
conda env create --file "$Env:temp\neuro-conda-latest.yml"
```

### Linux, WSL, macOS

```bash
wget "https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/envs/neuro-conda-latest.yml" -O /tmp/neuro-conda-latest.yml
conda env create --file /tmp/neuro-conda-latest.yml
```

## Uninstall neuro-conda

### Windows 10 and 11 (PowerShell)

Open a PowerShell and run the following command:

```PowerShell
Invoke-WebRequest https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/libexec/uninstall.ps1 -OutFile $Env:temp\uninstall_neuroconda.ps1; Invoke-Expression $Env:temp\uninstall_neuroconda.ps1;
```

### Linux, WSL, macOS

Open a terminal and run the following command:

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/libexec/uninstall.sh)"
```

## Customizing neuro-conda

The following environment variables can be used to modify the neuro-conda
installer

| Variable            | Description                    | Windows | Linux  | macOS |
|---------------------|--------------------------------|:-------:|:------:|:-----:|
| `ncTargetDirectory` | installation location          |  [ x ]  |  [ x ] | [ x ] |
| `ncDebug`           | show debug messages            |  [ x ]  |  [ x ] | [ x ] |
| `ncEnv`             | choose neuro-conda environment |  [ x ]  |  [ x ] | [ x ] |
| `ncEditor`          | install Spyder                 |  [   ]  |  [ x ] | [ x ] |
| `ncNoninteractive`  | do not prompt for input        |  [ x ]  |  [ x ] | [ x ] |
| `ncCI`              | CI pipeline mode               |  [ x ]  |  [ x ] | [ x ] |

## Extending a neuro-conda installation

Coming soon...

