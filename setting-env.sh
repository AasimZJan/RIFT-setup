#!/usr/bin/bash

LIGO_USER_NAME=aasim.jan
venv_name=venv-rift

# No need to change anything beyond this
echo "Installing packages"

source /cvmfs/oasis.opensciencegrid.org/ligo/sw/conda/bin/activate

conda activate igwn-py310-20230323

python3 -m venv ${venv_name}

conda deactivate

conda deactivate

source ${venv_name}/bin/activate

cd /home/${LIGO_USER_NAME}/${venv_name}/lib/python3.10/site-packages/

git clone https://github.com/oshaughn/research-projects-RIT.git

cd research-projects-RIT

git checkout rift_O4d

pip install -e .

pip install pyseobnr

CFLAGS='-std=c99' pip --no-cache-dir install -U gwsurrogate

pip --no-cache-dir install NRSur7dq2

python -c "import gwsurrogate; gwsurrogate.catalog.pull('NRHybSur3dq8')"

python -c "import gwsurrogate; gwsurrogate.catalog.pull('NRSur7dq4')"

python -c "import gwsurrogate; gwsurrogate.catalog.pull('NRHybSur2dq15')"

cd ~/${venv_name}

HOME=/home/${LIGO_USER_NAME}
path=`pwd`/lib/python3.10/site-packages

echo 'Creating a setup file in ${path}'

cat >setup-venv.sh<<- EOF
HOME=${HOME}

source `pwd`/bin/activate

export LIGO_ACCOUNTING=ligo.sim.o4.cbc.pe.rift
export LIGO_USER_NAME=${LIGO_USER_NAME}
export RSYNC_RSH=gsissh
export NR_BASE=\`\`

export PATH=${path}/research-projects-RIT/MonteCarloMarginalizeCode/Code/bin:${path}/research-projects-RIT/MonteCarloMarginalizeCode/Code:\${PATH}:${path}:${path}:\${NR_BASE} 
export PYTHONPATH=${path}/research-projects-RIT/MonteCarloMarginalizeCode/Code/bin:${path}/research-projects-RIT/MonteCarloMarginalizeCode/Code:\${PYTHONPATH}:${path}:${path}:\${HOME_JL}/TEOBResumS-v3.0-C-code/teobresums/Python:\${HOME_JL}/TEOBResumS-v1.0-C-code/teobresums/libconfig/lib:\${NR_BASE}
#export PYTHONPATH=\${PYTHONPATH}:\${ROM_SPLINE}

export GW_SURROGATE=${path}/gwsurrogate/
export PYTHONPATH=\${PYTHONPATH}:\${GW_SURROGATE}
export CUDA_DIR=/usr/local/cuda
export LAL_DATA_PATH=/home/aasim.jan/LAL_DATA

export CFLAGS="-std=c99"
export SINGULARITY_RIFT_IMAGE=/cvmfs/singularity.opensciencegrid.org/james-clark/research-projects-rit/rift:latest
export RIFT_GETENV=LD_LIBRARY_PATH,PATH,PYTHONPATH,*RIFT*,LIBRARY_PATH,LAL_DATA_PATH,GW_SURROGATE
EOF
