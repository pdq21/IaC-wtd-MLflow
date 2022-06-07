#!/usr/bin/env sh

tagusecase="mlflow"
mlflowgetextras="extras"
reg="localhost"
reguser="wtd-io"

tardevtools="devtools"
tarusecase="usecase"
tarall="all"

if [ "$1" == "$tardevtools" ] || [ "$1" == "$tarusecase" ]; then
  target=$1
elif [ "$1" == "$tarall" ]; then
  target="$tardevtools $tarusecase"
else
  target=$tarusecase
fi

for t in $target; do

  #TODO --squash or --squash-all ?
  param=" --target $t"

  if [ $t == $tarusecase ]; then
    tagtmp=$tagusecase
    ba=' --build-arg '
    if [ ! "$1" == "$tarall" ]; then
      #ARG FROM syntax needs $-denotion
      param+=$ba'$BASEIMAGE_USECASE='${reg}/${reguser}/${tardevtools}:${2:-latest}
    fi
    if [ "$3" == "$mlflowgetextras" ]; then
      param+="${ba}MLFLOW_GET_EXTRAS=extras"
    elif [ ! -z $3 ]; then
      echo "Wrong Extras param. Extras will not be installed."
    fi
    if [ "$4" == "$condaget" ]; then
      param+="${ba}CONDA_GET=conda"
    elif [ ! -z $4 ]; then
      echo "Wrong Conda param. Conda will not be installed."
    fi
  else
    tagtmp=$t
  fi

  tagtmp="${reguser}/${tagtmp}:${2:-latest}"

  echo "##########################################"
  echo "#    Building $tagtmp"
  echo "##########################################"
  echo $param
  podman build . -t $tagtmp $param

done
