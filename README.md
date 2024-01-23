# Prediction of tie strength in social networks
In this project, we aim to predict the tie strength between two users in a social network.
We use a dataset containing information about interactions between users on the website of
the Austrian newspaper [Der Standard](https://derstandard.at/) in May 2019. We are working
on this project as a part of the course [Social Network
Analysis](https://tiss.tuwien.ac.at/course/educationDetails.xhtml?semester=2023W&courseNr=194050)
at the Technical University of Vienna.

## Folder and File Structure

```
.
├── 1_data_import.ipynb
├── 2_counting_interactions.ipynb
├── 3_data_preparation.ipynb
├── 4_modeling.ipynb
├── data/
│   ├── Following_Ignoring_Relationships_01052019_31052019.csv
│   ├── interaction_test_set.csv
│   ├── interaction_train_set.csv
│   ├── interaction_val_set.csv
│   ├── Postings_01052019_07052019.csv
│   ├── Postings_08052019_15052019.csv
│   ├── Postings_16052019_23052019.csv
│   ├── Postings_24052019_31052019.csv
│   ├── Votes_01052019_07052019.csv
│   ├── Votes_08052019_15052019.csv
│   ├── Votes_16052019_23052019.csv
│   └── Votes_24052019_31052019.csv
├── docker-compose.yml
├── Dockerfile
├── graph/
│   ├── article.csv
│   ├── downvoted.csv
│   ├── follows.csv
│   ├── has_parent.csv
│   ├── ignores.csv
│   ├── interaction-final.csv
│   ├── interaction.csv
│   ├── posted_by.csv
│   ├── posted_on.csv
│   ├── posting_1.csv
│   ├── posting_2.csv
│   ├── upvoted_1.csv
│   ├── upvoted_2.csv
│   └── user.csv
├── README.md
└── requirements.txt
```

## Prerequisites
- Docker and Docker-Compose
- Python environment
    - Libraries can be found in [requirements.txt](requirements.txt)

## 1. Data import
To be able to work with the data properly, we store it in a [Neo4j](https://neo4j.com/)
graph database. In order to import our data, we have to transform it into a format that
Neo4j understands. This is done in the [data import notebook](1_data_import.ipynb).

The resulting files are then imported into a dockerized Neo4j instance. In order to start
a populated Neo4j container locally, run the following commands:

```{bash}
docker compose build
docker compose up
```

## 2. Counting Interactions
This notebook contains all neo4j queries to calculate the different measures of user-user
interactions. Also a first analysis on the data is conducted.

## 3. Data Preparation
Within this notebook we calculate our groundtruth and generate all features which are
needed for model creation. This takes quite a while. The
[interaction-final.csv](graph/interaction-final.csv) contains
all interaction data including the generated features including
neighbourhood overlap,min local clusterin coefficient, tie strength, reciprocity,
multiplexity, closenesss, sentiment, and interaction frequency.
Moreover we create splits of this dataset to train our model, validate it and lastly test it.

## 4. Modeling
We train different models on the training data and afterward evaluate on the results.
Last, the results of the models are visualized.