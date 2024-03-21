@echo off

if "%CONDA_BUILD%" EQU "1" (
    set CMAKE_INSTALL_PREFIX=%PREFIX%\Library
) else (
    set CMAKE_INSTALL_PREFIX=%CONDA_PREFIX%\Library
)
