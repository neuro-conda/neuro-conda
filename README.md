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
- [neurotic](https://neurotic.readthedocs.io/en/latest/)
- [nibabel](https://nipy.org/nibabel/) + [napari-nibabel](https://nipy.org/packages/napari-nibabel/index.html)
- [nilearn](https://nilearn.github.io/stable/index.html)
- [nipype](https://nipype.readthedocs.io/en/latest/)
- [nitime](https://nipy.org/nitime/) (only on Windows and Linux)
- [nixio](https://nixio.readthedocs.io)
- [pybids](https://bids-standard.github.io/pybids/)
- [pydicom](https://pydicom.github.io/) + [deid](https://pydicom.github.io/deid/)
- [pynapple](https://pynapple-org.github.io/pynapple/)
- [pynwb](https://pynwb.readthedocs.io)
- [spikeinterface](https://spikeinterface.readthedocs.io)
- [spikeinterface-gui](https://github.com/SpikeInterface/spikeinterface-gui)

More neuroscience tools will be added in the future. Please open an [issue](https://github.com/neuro-conda/neuro-conda/issues) or [pull request](https://github.com/neuro-conda/neuro-conda/pulls) if you'd like a specific package to be included.

Other included non-neuroscience packages are (see [the environment files](/envs) for details)

- [black](https://black.readthedocs.io/en/stable/)
- [dask](https://www.dask.org)
- [esi-acme](https://esi-acme.readthedocs.io)
- [flake8](https://flake8.pycqa.org/en/latest/index.html#) + [pep8-naming](https://github.com/PyCQA/pep8-naming)
- [HDF5](https://www.hdfgroup.org/solutions/hdf5/) + [h5py](https://www.h5py.org/)
- [imageio](https://imageio.readthedocs.io/en/stable/)
- [jupyter](https://jupyter.org)
- [NumPy](https://numpy.org/)
- [SciPy](https://scipy.org/)
- [Matplotlib](https://matplotlib.org/) + [Seaborn](https://seaborn.pydata.org/)
- [mat 7.3](https://github.com/skjerns/mat7.3)
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

### Linux, macOS and Windows Subsystem for Linux (WSL)

Open a terminal (`Terminal.App` in macOS) and run the following command:

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

The following environment variables can be used to control the neuro-conda
installer/uninstaller (detailed explanation below).

| Variable            | Description                    | Windows | Linux/WSL  | macOS |
|---------------------|--------------------------------|:-------:|:----------:|:-----:|
| `ncTargetDirectory` | installation location          |   ✅    |     ✅     |  ✅   |
| `ncDebug`           | show debug messages            |   ✅    |     ✅     |  ✅   |
| `ncEnv`             | choose neuro-conda environment |   ✅    |     ✅     |  ✅   |
| `ncEditor`          | install Spyder                 |   ❌    |     ✅     |  ✅   |
| `ncNoninteractive`  | do not prompt for input        |   ✅    |     ✅     |  ✅   |
| `ncCI`              | CI pipeline mode               |   ✅    |     ✅     |  ✅   |

The variables have to be set **before** running the neuro-conda installer/uninstaller
and must be available to other processes started by the installer, e.g.,

- **Linux/macOS/WSL**:

  ```zsh
  export ncDebug=1
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/libexec/install.sh)"
  ```

- **Windows PowerShell**:

  ```PowerShell
  $Env:ncDebug = 1
  Invoke-WebRequest https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/libexec/install.ps1 -OutFile $Env:temp\install_neuroconda.ps1; Invoke-Expression $Env:temp\install_neuroconda.ps1;
  ```

### `ncTargetDirectory` (installer only)

Specify the location of the neuro-conda installation. By default, neuro-conda
is installed inside the active user's home directory. Note that the specified
directory must not exist.

- **Linux/macOS/WSL**: By default, `ncTargetDirectory="${HOME}/.local/miniconda3"`,
  to install neuro-conda to `/path/to/conda` use `export ncTargetDirectory="/path/to/conda"`
- **Windows PowerShell**: By default, neuro-conda is installed in the directory "miniconda3"
  inside the active user's home folder (usually `C:\Users\<username>`). If no active user is
  detected or the [username contains spaces](https://github.com/conda/conda/issues/8725),
  the installer falls back on the "public" folder (usually `C:\Users\Public`). To point the
  installer to another location use, e.g., `$Env:ncTargetDirectory = "F:\work\neuro-conda"`

### `ncDebug`

If set, the (un)installer prints (a lot of) additional progress/status messages.
Note that the actual value of `ncDebug` is irrelevant, if the variable is
set (to anything), the (un)installer picks it up.

- **Linux/macOS/WSL**: By default, `ncDebug` is not defined. Setting it
  to an arbitrary value, e.g., `export ncDebug=1` activates debug messaging.
- **Windows PowerShell**: By default `ncDebug` is not set. Debug messages
  are shown if `ncDebug` is set to an arbitrary value, e.g., `$Env:ncDebug = 1`

### `ncEnv` (installer only)

Specifies the environment to create during the installation process. By default,
the installer always creates the most recent neuro-conda environment defined
in the YAML file [neuro-conda-latest.yml](./envs/neuro-conda-latest.yml)
(consult the [envs](./envs/) directory for all available environments)

> ℹ️ **INFO** As of June 2023, neuro-conda only ships with a single environment
file (`neuro-conda-latest.yml`) that contains the environment `neuro-conda-2023a`.
Setting `ncEnv` to anything other than `neuro-conda-2023a` results in an
error.

- **Linux/macOS/WSL**: To create an older neuro-conda environment, use, e.g.,
  `export ncEnv="neuro-conda-2023a"`
- **Windows PowerShell**: To create a specific neuro-conda environment,
  use, e.g., `$Env:ncEnv = "neuro-conda-2023a"`

### `ncEditor` (installer only)

If set, the Python IDE [Spyder](https://www.spyder-ide.org/) is installed
alongside neuro-conda.

- **Linux/macOS/WSL**: By default, `ncEditor` is not defined. Setting it
  to an arbitrary value, e.g., `export ncEditor=1` installs Spyder.
- **Windows PowerShell**: Not yet supported.

### `ncNonInteractive`

If set, the (un)installer does not ask for confirmation. The actual value of
`ncNonInteractive` is irrelevant, if the variable is set (to anything),
any confirmation dialogs will be automatically answered with "yes".
By default, the (un)installer asks the user for confirmation when performing
changes to the system.

> ⚠️ **WARNING** The (un)installer only asks for confirmation before making
permanent changes to the system. Automatically confirming all dialogs
without double-checking may result in damaged installations.

- **Linux/macOS/WSL**: By default, `ncNonInteractive` is not defined. Setting it
  to an arbitrary value, e.g., `export ncNonInteractive=1` prevents the
  (un)installer from prompting for confirmation
- **Windows PowerShell**: By default `ncNonInteractive` is not set. All
  confirmation dialogs are automatically answered with "yes" if `ncNonInteractive`
  is set to an arbitrary value, e.g., `$Env:ncNonInteractive = 1`

### `ncCI`

If set, the (un)installer assumes it was executed by a continuous integration
pipeline (e.g., [GitHub Action](https://github.com/features/actions)) and
activates `ncNonInteractive`. Note that the actual value of `ncCI` is
irrelevant, if the variable is set (to anything), the (un)installer picks
it up.

> ⚠️ **WARNING** Setting `ncCI` turns off all confirmation prompts
(see [`ncNonInteractive`](#ncnoninteractive) above).

- **Linux/macOS/WSL**: By default, `ncCI` is not defined. Setting it
  to an arbitrary value, e.g., `export ncCI=1` activates CI mode.
- **Windows PowerShell**: By default `ncCI` is not set. CI mode is activated
  if `ncCI` is set to an arbitrary value, e.g., `$Env:ncCI = 1`

## Extending a neuro-conda installation

Coming soon...
