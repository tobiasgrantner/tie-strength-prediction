## Cypher Queries
`Get all channelcounts for all users and add them to the user`
```{cypher}
MATCH (u:User)<-[:POSTED_BY]-(p:Posting)-[:POSTED_ON]- (a:Article)
WITH u, COUNT(DISTINCT a.channel) AS DistinctChannels
SET u.channelCount = DistinctChannels
RETURN u.id AS UserID, u.channelCount AS ChannelCount
ORDER BY ChannelCount DESC
```
remark: there are 9835  of 33760 users without any postings
Stats:
- 22 distinct channels of articles
- 33760 users
- 739095 postings
- 4352 articles

```{cypher}
CALL {
    MATCH (u1:User) -[:UPVOTED]- (p:Posting) -[:POSTED_BY]->(u2:User),
    (p)-[:POSTED_ON]-(a:Article)
    Return u2, a.channel AS ChannelCount
    UNION ALL
    MATCH (u1:User) -[:DOWNVOTED]- (p:Posting) -[:POSTED_BY]->(u2:User),
    (p)-[:POSTED_ON]-(a:Article)
    Return u2, a.channel AS ChannelCount
    UNION ALL
    MATCH (u1:User)-[:POSTED_BY]-(:Posting)-[:HAS_PARENT]-(p:Posting)-[:POSTED_BY]- (u2:User),
    (p)-[:POSTED_ON]-(a:Article)
    Return u2, a.channel AS ChannelCount
}
WITH u2, COUNT(DISTINCT ChannelCount) AS ChannelCountAll
MERGE (u1) -[i:INTERACTION]- (u2)
SET i.channelCount = ChannelCountAll
```