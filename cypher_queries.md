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





