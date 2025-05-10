
# Spark IMDb Analysis – Set 4
Big Data project using Apache Spark (RDD + DataFrame API) to process IMDb data and identify top movie participants by profession.

## Project Description

This notebook implements a Big Data processing task using Apache Spark. The goal is to analyze IMDb datasets and determine which individuals participated in the most movies for the most common professions.

The **main objective** is to find the **top three individuals** in terms of movie participation for each of the **four most common professions** found in the data. Only movies with a **fully credited cast** are included, defined as those with:
- at least one actor or actress (role in `actor`, `actress`, `self`)
- at least one director (`role = director`)
- at least two additional people with any role

Two separate implementations are included:
- **Part 1** – Using the low-level **RDD API**
- **Part 2** – Using the higher-level **Spark SQL / DataFrame API**

The results of both parts are consistent and demonstrate different approaches to solving the same task.

## Technologies Used

- Apache Spark (tested in local mode with Docker and on Dataproc cluster)
- Python 3.x
- Jupyter Notebook
- Docker




## How to Run the Project

There are two ways to run this project: locally using Docker, or on a distributed Spark cluster using Google Cloud Dataproc.

---

### ▶️ Option 1: Run Locally (Docker)

1. Build and run the Docker container:
   ```bash
   docker build -t spark-local .
   docker run -p 8888:8888 -v %cd%:/home/jovyan/work spark-local
   ```

   Or on Windows, run the included script:
   ```
   run_spark_container_windows.bat
   ```

2. Open the Jupyter notebook in your browser at [http://localhost:8888](http://localhost:8888) and run `spark-imdb-analysis-set4.ipynb`.

3. Ensure the flag `is_cluster = False` is set to use local filesystem paths.

---

### ☁️ Option 2: Run on a Dataproc Cluster (GCP)

1. **Create the Dataproc Cluster**

Use the following `gcloud` command:

```bash
gcloud dataproc clusters create imdb-spark-cluster \
  --enable-component-gateway \
  --region europe-central2 \
  --subnet default \
  --public-ip-address \
  --master-machine-type n2-standard-4 \
  --master-boot-disk-size 50 \
  --num-workers 2 \
  --worker-machine-type n2-standard-2 \
  --worker-boot-disk-size 50 \
  --image-version 2.2-debian12 \
  --optional-components JUPYTER \
  --project YOUR_PROJECT_ID \
  --max-age=3h
```

2. **Upload the Notebook and Data**

- Open the JupyterLab interface of the Dataproc cluster.
- Upload `spark-imdb-analysis-set4.ipynb`.
- Upload the required datasets to a Google Cloud Storage bucket.

3. **Enable Cluster Mode**

In the notebook:
```python
is_cluster = True
input_dir = "gs://your-bucket-name/set4/input"
```

This enables Spark to load data from `datasource1` and `datasource4` subfolders located at the specified path in your GCS bucket.

4. **Run the Notebook**

Execute all cells to perform the analysis on the cluster.


## Repository Structure

- `spark-imdb-analysis-set4.ipynb` – Jupyter notebook with RDD and DataFrame implementations
- `Dockerfile` – development environment (Spark local mode)
- `run_spark_container_windows.bat` – run script for Windows
- `.gitignore` – excludes outputs, datasets, and temp files
- `LICENSE` – open source license

## Input Data

IMDb source datasets are not included in the repository.  
To run the project, download the data from the following link:

📁 [IMDb Dataset Folder](https://drive.google.com/drive/folders/1UUu-A6qtEwHEFl7YBrIojvT_vR35fgEi?usp=sharing)

### Dataset Descriptions

#### `datasource1` – title.crew.tsv
This dataset contains detailed information about the people credited in individual movies. Each row describes a person’s involvement in a specific title (film), with role metadata.

- Format: Tab-separated values (TSV), **no header**
- Sample fields:
  - `tconst` – unique identifier for a title (movie)
  - `ordering` – order of appearance in the credits
  - `nconst` – unique identifier for a person
  - `role` – general category of the person's role (e.g., actor, director)
  - `job` – specific job title (e.g., writer, cinematographer)
  - `characters` – names of characters portrayed (if applicable)

This dataset allows us to determine each person's function in the creation of a movie and evaluate whether a title meets the definition of a "fully credited cast".

#### `datasource4` – name.basics.tsv
This dataset contains biographical and professional information about people in the film industry.

- Format: Tab-separated values (TSV), **with header**
- Sample fields:
  - `nconst` – unique identifier for a person
  - `primaryName` – full name of the person
  - `birthYear` – year of birth
  - `deathYear` – year of death (\N if unknown)
  - `primaryProfession` – comma-separated list of professions (e.g., actor, director)
  - `knownForTitles` – list of title IDs associated with the person

We use this dataset to determine a person's profession(s), life span, and popularity metrics (based on the number of people in each profession).
