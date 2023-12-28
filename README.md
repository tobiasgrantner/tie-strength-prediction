# Prediction of tie strength in social networks

In this project, we aim to predict the tie strength between two users in a social network. We use a dataset containing information about interactions between users on the website of the Austrian newspaper [Der Standard](https://derstandard.at/) in May 2019. We are working on this project as a part of the course [Social Network Analysis](https://tiss.tuwien.ac.at/course/educationDetails.xhtml?semester=2023W&courseNr=194050) at the Technical University of Vienna.


## 1. Data import

To be able to work with the data properly, we store it in a [Neo4j](https://neo4j.com/) graph database. In order to import our data, we have to transform it into a format that Neo4j understands. This is done in the [data import notebook](1_data_import.ipynb).

The resulting files are then imported into a dockerized Neo4j instance. In order to start a populated Neo4j container locally, run the following commands:

```{bash}
docker compose build
docker compose up
```
