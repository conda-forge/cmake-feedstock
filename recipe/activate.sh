if [[ $CONDA_BUILD -eq 1 ]];
then
    if [[ ! -z $COMSPEC ]];
    then
        export CMAKE_INSTALL_PREFIX=$PREFIX/Library
    else
        export CMAKE_INSTALL_PREFIX=$PREFIX
    fi;
else
    if [[ ! -z $COMSPEC ]];
    then
        export CMAKE_INSTALL_PREFIX=$CONDA_PREFIX/Library
    else
        export CMAKE_INSTALL_PREFIX=$CONDA_PREFIX
    fi;
fi;
