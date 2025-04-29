@echo off
REM Uruchamia kontener Spark + Jupyter z mapowaniem bieżącego katalogu

SET IMAGE_NAME=pyspark-container

docker run --rm -it -p 8888:8888 -v "%cd%:/workspace" %IMAGE_NAME%
