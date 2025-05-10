FROM python:3.8-slim

# Set environment variables for Spark & Hadoop
ENV SPARK_VERSION=3.4.1
ENV HADOOP_VERSION=3
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root"

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    default-jdk \
    curl \
    wget \
    tar \
    && apt-get clean

# Set dependencies for Python and Spark
RUN pip3 install --no-cache-dir \
    jupyter \
    pandas \
    numpy \
    matplotlib \
    pyspark==3.4.1 \
    cloudpickle

# Download and configure Apache Spark
RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz && \
    tar -xzf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz && \
    mv spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION /opt/spark && \
    rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz

# Add Spark config for better serialization
RUN echo "spark.serializer org.apache.spark.serializer.KryoSerializer" >> $SPARK_HOME/conf/spark-defaults.conf

# Set Jupyter Notebook port
EXPOSE 8888

# Set work dir
WORKDIR /workspace

# Starting command
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
