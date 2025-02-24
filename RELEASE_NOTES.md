# Release Notes for neuro-conda

## neuro-conda-2025a

4th release of neuro-conda with a few updates.

**Added**

- braindecode 0.8

**Updated**

- brian2 2.5 &rarr; 2.7
- eelbrain 0.39 &rarr; 0.40
- elephant 1.0 &rarr; 1.1
- mne 1.6 &rarr; 1.9
  - mne-bids-pipeline &rarr; 1.9
  - mne-connectivity &rarr; 0.7
  - mne-features &rarr; 0.3
  - mne-icalabel &rarr; 0.7
  - mne-nirs &rarr; 0.7
  - mne-rsa 0.9.*
- neurodsp 2.2 &rarr; 2.3
- neo 0.13 &rarr; 0.14
- nipype 1.8 &rarr; 1.9
- nitime 0.10 &rarr; 0.11
- pybids 0.16 &rarr; 0.17
- pynapple 0.4 &rarr; 0.8
- pynwb 2.5 &rarr; 2.8
- spikeinterface 0.100 &rarr; 0.102
- spikeinterface-gui 0.7 &rarr; 0.10

**Removed**

- SpyKING CIRCUS: Mostly an application. Please use in its own environment.
- suite2p: Mostly an application. Please use in its own environment.
- mnelab: Mostly an application. Please use in its own environment.
- neurotic: Mostly an application. Please use in its own environment.
- sesameeg: Incompatible with mne>=1.7.1


## neuro-conda-2024a

3rd release of neuro-conda with a few updates.

**Added**

- ephyviewer 1.5

**Updated**

- dataconf 2.1 &rarr; 2.5
- dipy 1.7 &rarr; 1.8
- elephant 0.14 &rarr; 1.0
- esi-acme 2023.4 &rarr; 2023.12
- esi-syncopy 2023.5 &rarr; 2023.9
- h5py 3.9 &rarr; 3.10
- mne 1.5 &rarr; 1.6
- mne-icalabel 0.4 &rarr; 0.6
- mne-nirs 0.5 &rarr; 0.6
- neo 0.12 &rarr; 0.13
- pywavelets 1.4 &rarr; 1.5
- scikit-image 0.20 &rarr; 0.22
- scikit-learn 1.3 &rarr; 1.4
- scipy 1.11 &rarr; 1.12
- spikeinterface 0.98 &rarr; 0.100
- tensorflow 2.14 &rarr; 2.15
- torch 2.1 &rarr; 2.2

**Removed**

- r-base
- r-irkernel

## neuro-conda-2023b

2nd release of neuro-conda with a few new packages and updates.

**Added**

- spikeinterface-gui (#21)
- neurotic (#22)
- spyking-circuse (#24)
- black, pylint, flake, pep8-naming (#34)
- mat73 (#35)
- pynapple (#37)
- suite2p (#39)
- brian2 (#40)
- neurokit2 (#41)
- tensorflow-datasets
- sbxreader

**Updated**

- numpy 1.23 &rarr; 1.24
- scipy 1.10 &rarr; 1.11
- matplotlib 3.6 &rarr; 3.7
- pandas 1.5 &rarr; 2.1
- dipy 1.5 &rarr; 1.7
- mne 1.3 &rarr; 1.5
- mne-realtime 0.2 &rarr; 0.3
- mne-rsa 0.8 &rarr; 0.9
- mne-features 0.2 &rarr; 0.3
- mne-bids-pipeline 1.1 &rarr; 1.4
- eelbrain 0.38 &rarr; 0.39
- pytest 7.2 &rarr; 7.4
- h5py 3.8 &rarr; 3.9
- pynwb 2.3 &rarr; 2.5
- esi-acme 2022.12 &rarr; 2023.4
- esi-syncopy 2022.12 &rarr; 2023.5
- dask 2022.10 &rarr; 2023.3
- elephant 0.11 &rarr; 0.14
- viziphant 0.2 &rarr; 0.3
- foof 1.0 &rarr; 1.1
- bycycle 1.0 &rarr; 1.1
- spikeinterface 0.97 &rarr; 0.98
- torch 1.13 &rarr; 2.1
- torchvision 0.14.1 &rarr; 0.16
- torchaudio 0.13.1 &rarr; 2.1
- opencv 4.7 &rarr; 4.8
- tensorflow 2.11 &rarr; 2.14
- scikit-learn 1.2 &rarr; 1.3
- pybids 0.15 &rarr; 0.16
- nitime 0.9 &rarr; 0.10

## neuro-conda-2023a

Initial release of neuro-conda including

- [bycycle](https://bycycle-tools.github.io)
- [dipy](https://dipy.org/)
- [elephant](https://elephant.readthedocs.io) + [viziphant](https://viziphant.readthedocs.io)
- [esi-syncopy](https://syncopy.readthedocs.io)
- [fooof](https://fooof-tools.github.io)
- [intensity-normalization](https://intensity-normalization.readthedocs.io/en/latest/readme.html)
- [mne](https://mne.tools) including the extensions
    [alphaCSC](https://alphacsc.github.io/stable/index.html),
    [eelbrain](https://eelbrain.readthedocs.io/en/stable/index.html),
    [invertmeeg](https://github.com/LukeTheHecker/invert) (only on Linux),
    [mne-ari](https://github.com/john-veillette/mne-ari),
    [mne-bids](https://mne.tools/mne-bids/stable/index.html),
    [mne-bids-pipeline](https://mne.tools/mne-bids-pipeline/1.1/index.html),
    [mne-connectivity](https://mne.tools/mne-connectivity/stable/index.html),
    [mne-features](https://mne.tools/mne-features/),
    [mne-icalabel](https://mne.tools/mne-icalabel/stable/index.html),
    [mnelab](https://mnelab.readthedocs.io/en/latest/index.html),
    [mne-microstates](https://github.com/wmvanvliet/mne_microstates),
    [mne-nirs](https://mne.tools/mne-nirs/stable/index.html),
    [mne-realtime](https://mne.tools/mne-realtime/),
    [mne-rsa](https://users.aalto.fi/~vanvlm1/mne-rsa/),
    [pactools](https://pactools.github.io/index.html),
    [pyprep](https://github.com/sappelhoff/pyprep),
    [sesameeg](https://pybees.github.io/sesameeg/)
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
