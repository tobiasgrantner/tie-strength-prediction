# Counting Interactions

In order to analyze the data, we need to count the interactions between users. What we are interested in are the number of comments/postings between two users, the number of upvotes/downvotes of one user on another users posts, and the number of follows/ignores between two users. We will store these numbers in a new relationship type called `INTERACTION`.


## Postings

```{Cypher}
MATCH (u1:User) -[:POSTED_BY]- (:Posting) -[:HAS_PARENT]- (:Posting) -[:POSTED_BY]- (u2:User)
WHERE u1.id < u2.id
WITH u1, u2, COUNT(*) AS postings
MERGE (u1) -[i:INTERACTION]- (u2)
SET i.postings = postings
```


## Upvotes/Downvotes

```{Cypher}
:auto
CALL {
    MATCH (u1:User) -[:UPVOTED]- (:Posting) -[:POSTED_BY]- (u2:User)
    WHERE u1.id < u2.id
    RETURN u1, u2, COUNT(*) AS upvotes
    UNION ALL
    MATCH (u2:User) -[:UPVOTED]- (:Posting) -[:POSTED_BY]- (u1:User)
    WHERE u1.id < u2.id
    RETURN u1, u2, COUNT(*) AS upvotes
}
WITH u1, u2, SUM(upvotes) AS upvotes
CALL {
    WITH u1, u2, upvotes
    MERGE (u1) -[i:INTERACTION]- (u2)
    SET i.upvotes = upvotes
} IN TRANSACTIONS OF 1000 ROWS
```


```{Cypher}
:auto
CALL {
    MATCH (u1:User) -[:DOWNVOTED]- (:Posting) -[:POSTED_BY]- (u2:User)
    WHERE u1.id < u2.id
    RETURN u1, u2, COUNT(*) AS downvotes
    UNION ALL
    MATCH (u2:User) -[:DOWNVOTED]- (:Posting) -[:POSTED_BY]- (u1:User)
    WHERE u1.id < u2.id
    RETURN u1, u2, COUNT(*) AS downvotes
}
WITH u1, u2, SUM(downvotes) AS downvotes
CALL {
    WITH u1, u2, downvotes
    MERGE (u1) -[i:INTERACTION]- (u2)
    SET i.downvotes = downvotes
} IN TRANSACTIONS OF 1000 ROWS
```


## Follows/Ignores

```{Cypher}
CALL {
    MATCH (u1:User) -[:FOLLOWS]-> (u2:User)
    WHERE u1.id < u2.id
    RETURN u1, u2
    UNION ALL
    MATCH (u1:User) <-[:FOLLOWS]- (u2:User)
    WHERE u1.id < u2.id
    RETURN u1, u2
}
WITH u1, u2, COUNT(*) AS follows
MERGE (u1) -[i:INTERACTION]- (u2)
SET i.follows = follows
```


```{Cypher}
CALL {
    MATCH (u1:User) -[:IGNORES]-> (u2:User)
    WHERE u1.id < u2.id
    RETURN u1, u2
    UNION ALL
    MATCH (u1:User) <-[:IGNORES]- (u2:User)
    WHERE u1.id < u2.id
    RETURN u1, u2
}
WITH u1, u2, COUNT(*) AS ignores
MERGE (u1) -[i:INTERACTION]- (u2)
SET i.ignores = ignores
```


## Export to CSV

```{Cypher}
WITH "MATCH (u1:User) -[i:INTERACTION]- (u2:User)
      WHERE u1.id < u2.id
      RETURN 'u' + u1.id AS `:START_ID`, 'u' + u2.id AS `:END_ID`, i.postings AS `postings:int`, i.upvotes AS `upvotes:int`, i.downvotes AS `downvotes:int`, i.follows AS `follows:int`, i.ignores AS `ignores:int`" AS query
CALL apoc.export.csv.query(query, "interaction.csv", {})
YIELD file, source, format, nodes, relationships, properties, time, rows, batchSize, batches, done, data
RETURN file, source, format, nodes, relationships, properties, time, rows, batchSize, batches, done, data;
```

Once the aggregation is done, we can export the `INTERACTION` relationship to a CSV file, so that it can be imported into the Neo4j database like the other relationships.


```{bash}
docker cp tie-strength-prediction-neo4j-1:/var/lib/neo4j/import/interaction.csv graph/
```

We can then copy the CSV files into our repository for later use.
