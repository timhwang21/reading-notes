# GraphQL

## Downsides

- Because associations are loaded at runtime, it's hard to query the database in an optimized way. This is because resolvers are intentionally isolated from each other, and if a query hits 3 resolvers that each need the same DB record, the DB will be hit with duplicate queries 3 times.

### Naive solutions
1. Load parent, the individually load all associations after ("1+N loading")
2. Eagerly load everything (high resource usage; potentially wasted effort unless you are absolutely sure you'll use the eagerly loaded data)

### Advanced solutions

#### [DataLoader](https://github.com/graphql/dataloader) pattern

DataLoader is an additional layer that handles batching and caching. When a N+1 query is fired, all the Ns will be collected and passed to the DataLoader which is responsible for batch loading them.

Fundamentally, resolvers no longer serially build up the query result, but instead return promises; when the promises are collected and coalesced, DB hits are deduplicated.

DataLoaders place "loaders" between the application and the DB. Loaders usually have an interface like `load<T> = (key: string) => Promise<T>` and `perform<T>(keys: string[]) => Promise<T[]>`. `load()` queues up a load for the next execution tick, and `perform()` actually runs it.

One downside of the DataLoader pattern is that [it is optimized for K-V stores](https://github.com/graphql/dataloader/blob/master/examples/SQL.md), and not for relational databases.

#### Lookahead

Allow resolvers to analyze the query to see if certain other fields are needed. Is challenging to get right because queries can get arbitrarily complex.

[Sample implementation in GraphQL Ruby](https://graphql-ruby.org/queries/lookahead.html).

## Resources

- [The GraphQL DataLoader pattern visualized](https://medium.com/@__xuorig__/the-graphql-dataloader-pattern-visualized-3064a00f319f)
- [EvilMartials Ruby GraphQL guide](https://evilmartians.com/chronicles/how-to-graphql-with-ruby-rails-active-record-and-no-n-plus-one)
