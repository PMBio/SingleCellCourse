# Single Cell Course 2020 - Day 3 practical
Author: Luca Marconato, PhD student, EMBL

## Installation
You will need
* A conda environment for the Python part
* A conda environment for the R part (they don't need to be separated, but in this way the changes of errors decrease)
* A software called Loupe Browser

### A conda environment for the Python part
* It is required either [miniconda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/) or [anaconda](https://docs.anaconda.com/anaconda/install/), for Python >= 3.7
* If you don't have just installed the latest version of conda you may encounter errors, in such a case please update miniconda/anaconda (instructions on the website), either install the latest version.
    * For instance, in my case I could not install a package in my machine so I needed to update miniconda with the command `conda update --all`
* Open a terminal and run the following line to create a conda environment with all the required libraries

`conda create -n day3_python python==3.7 seaborn pillow tqdm jupyterlab scanpy anndata -c anaconda -c conda-forge -c bioconda`

If all is fine skip this step, if the previous command gives you errors you can try
    * Updading conda and then trying again the command above; to update conda use 
    * From the message error that you get, find the package that is issuing the error, remove that package from the command line shown above and run again the command. When you don't get any more errors install the left-out packages with pip (the specific pip command is package dependent, please search online)
* Now activate the conda environment

`conda activate day3_python`

* Install additional packages with pip running the following command

`pip install spatialde`

* Another package must be installed directly from [its repository on GitHub](https://github.com/almaan/stereoscope), by using the following commands
    ```
    mkdir single_cell_course
    cd single_cell_course
    git clone https://github.com/almaan/stereoscope 
    ```
    
    If you don't have `git` you can open teh link of the repository above, download the `.zip` file and 
    ```
    cd stereoscope
    ./setup.py install
    ```
    
    To test that `stereoscope` is installed please run
    ```
    python -c "import stsc; print(stsc.__version__)"
    ```
    
    which should give you `stereoscope : 0.2.0`

    And then run
    ```
    STereoSCope test
    ```
    
    which should give you `successfully installed stereoscope CLI`

### A conda environment for the R part (they don't need to be separated, but in this way the changes of errors decrease)
* First activate the conda environment with the R packages that you used in the previous days, do that with

    `conda activate name_you_gave_to_the_environment`

* Now start R with `R`
* Within R run
    ```
    install.packages("devtools")
    devtools::install_github("satijalab/seurat", ref = "spatial")
    devtools::install_github("https://github.com/MarcElosua/SPOTlight")
    # if you can't install SPOTlight with the above command you can try using the two following ones
    # install.packages("remotes")
    # remotes::install_github("MarcElosua/SPOTlight")
    ```
* Please check that you are able to load the `Seurat` and the `SPOTlight` packages, respectively with the commands `library(Seurat)` and `library(SPOTlight)`

### A software called Loupe Browser
* 10x Genomics provides a software for exploration of Visium data, please [download it from here](https://support.10xgenomics.com/single-cell-gene-expression/software/visualization/latest/what-is-loupe-cell-browser)
