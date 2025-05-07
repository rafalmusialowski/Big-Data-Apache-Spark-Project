@echo off
REM Runs Spark container + Jupyter with current directory mapping

SET IMAGE_NAME=pyspark-container

docker run --rm -it -p 8888:8888 -v "%cd%:/workspace" %IMAGE_NAME%
