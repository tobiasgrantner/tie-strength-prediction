FROM neo4j:5.15

COPY graph/* /var/lib/neo4j/import/

RUN bin/neo4j-admin database import full --nodes=Posting=import/posting_1.csv --nodes=Posting=import/posting_2.csv --nodes=User=import/user.csv --nodes=Article=import/article.csv --relationships=HAS_PARENT=import/has_parent.csv --relationships=POSTED_ON=import/posted_on.csv --relationships=POSTED_BY=import/posted_by.csv --relationships=FOLLOWS=import/follows.csv --relationships=IGNORES=import/ignores.csv --relationships=UPVOTED=import/upvoted_1.csv --relationships=UPVOTED=import/upvoted_2.csv --relationships=DOWNVOTED=import/downvoted.csv neo4j

RUN rm -rf /var/lib/neo4j/import/*
