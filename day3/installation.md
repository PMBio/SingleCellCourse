# Single Cell Course 2021 - Day 3 practical
Author: Luca Marconato, Ilia Kats

## installation
We will work in Python, so you should have a Python environment and ideally Jupyter Notebook or Jupyter Lab installed.
On Windows and Mac, a Conda environment is probably the easiest option, while on Linux, we found plain virtualenvs (or even no virtual environment at all) to work best.

You will need the following packages from your repository of choice (PyPi/Conda/your Linux distribution's packages):

* `numpy`
* `scipy`
* `pandas`
* `matplotlib`
* `seaborn`
* `jupyter`
* `anndata`
* `napari`
* `pyqt5`
* `mofapy2` (you should have alredy installed this for day 2)
* `scanpy`
* `squidpy`
* `muon`

You will also need the development versions of some packages.
These need to be installed with `pip`/`pip3`, even in a Conda environment, using `pip install git+repository_url`

* `SpatialDE`: https://github.com/ilia-kats/SpatialDE
* `mofax`: https://github.com/bioFAM/mofax
* `cell2location`: https://github.com/BayraktarLab/cell2location

---

Note: Currently, there are some incompatibilities between packages when using Python 3.10.
This is due to the fact that the latest NumPy version is 1.22, but numba is not yet compatible with it and requires NumPy 1.21.
However, some other packages using the NumPy C API have been compiled against 1.22 already and are not compatible with 1.21.
Older versions of some of these packages (e.g. tables) are not compatible with Python 3.10.
In conclusion, at this moment you probably want to use Python 3.9 and you may have to manually massage some versions if you find that packages raise exceptions upon import.

---

### using Conda
Either [miniconda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/) or [anaconda](https://docs.anaconda.com/anaconda/install/) is required, with Python >= 3.7.
If you didn't just install the latest version of conda you may encounter errors.
In such a case please update miniconda/anaconda (e.g. by running `conda update --all`) or install the latest version.
Open a terminal and create a conda environment with all the required libraries by running  `conda create -n day3_python python==3.9 numpy scipy pandas matplotlib seaborn anndata napari notebook -c anaconda -c conda-forge -c bioconda`.
If you encounter errors you can try

* Updading conda and then trying again the command above; to update conda use
* From the message error that you get, find the package that is issuing the error, remove that package from the command line shown above and run again the command.
When you don't get any more errors install the left-out packages with pip (the specific pip command is package dependent, please search online)

Finally, activate the conda environment with `conda activate day3_python` and install additional packages with `pip` as described above.

### using virtualenv
First, install the `virtualenv` package globally.
You may do so with `pip` or from your Linux distribution's repositories.
Create a virtual environment with `virtualenv --system-site-packages practical`.
This will create a virtual environment that will use your system's default Python interpreter and also have access to globally installed Python packages.
Activate the environment with `source practical/bin/activate`.
You can now install packages into the environment with `pip install package_name`.

If Jupyter is installed globally (e.g. from your distribution's repositories), you need to enable it to see your new virtual environment.
Run `python -m ipykernel install --user --name=practical` from within the virtual environment to do that.

### installing globally
Use `pip install package_name`.
This will install packages into your user directory, but without isolating different projects from each other.
