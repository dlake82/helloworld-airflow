#!/bin/bash

pip3 install --upgrade pip

# set airflow environment
python -m venv .venv
source .venv/bin/activate

# set airflow's version
AIRFLOW_VERSION=2.7.1
export AIRFLOW_HOME=~/airflow
PYTHON_VERSION="$(python3 --version | cut -d " " -f 2 | cut -d "." -f 1-2)"

# install airflow
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip3 install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# check airflow install
pip3 check
python3 -m airflow

cd $AIRFLOW_HOME

airflow db init

# set examples options to false
sed -i '.original' 's/load_examples = True/load_examples = False/g' airflow.cfg
rm -rf airflow.db

airflow db init
mkdir dags

# create user
airflow users create \
    --username admin \
    --firstname predict \
    --lastname one \
    --role Admin \
    --email hyunwoo.kim2@onepredict.com

# run airflow
airflow webserver --port 9090