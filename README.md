# neuro-conda - a Python distribution for neuroscience based on [conda](https://www.anaconda.com)

Although creating a virtual environment for each project is considered best practice, it can be a major obstacle for early-career neuroscientists that are just starting to learn programming. **neuro-conda** aims to simplify learning and using Python in neuroscience by bundling commonly used packages in neuroscience into curated conda environments.

It is inspired by the similar projects at the [Ernst Strüngmann Institute for Neuroscience](https://github.com/esi-neuroscience/esi-conda) and [University of Cambridge](https://github.com/jooh/neuroconda) as well as [NeuroDesk](https://www.neurodesk.org) providing easy-to-install Python environments for neuroscience.

Currently the neuro-conda includes the following neuroscientific Python packages (in alphabetic order):

- [bycycle](https://bycycle-tools.github.io)
- [elephant](https://elephant.readthedocs.io) + [viziphant](https://viziphant.readthedocs.io)
- [esi-syncopy](https://syncopy.readthedocs.io)
- [fooof](https://fooof-tools.github.io)
- [mne](https://mne.tools)
- [neo](https://neo.readthedocs.io)
- [neurodsp](https://neurodsp-tools.github.io)
- [nixio](https://nixio.readthedocs.io)
- [pynwb](https://pynwb.readthedocs.io)
- [spikeinterface](https://spikeinterface.readthedocs.io)

More neuroscience tools will be added in the future.

Other non-neuroscience includes are (see [the environment files](/envs) for details)
- [dask](https://www.dask.org)
- [esi-acme](https://esi-acme.readthedocs.io)
- [jupyter](https://jupyter.org)

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