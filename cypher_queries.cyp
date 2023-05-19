// NEO4J FUNDAMENTALS

// Inventor of of graph theory: Leonhard Euler. When? 1736

// Graphgist
// - use case
// - industry

// Nodes can have labels and properties
// Relationships must have a type and a direction, 
// and may have properties

// Benefits of index-free adjacency: 
// 1 fewer index lookups
// 2 no table scans
// 3 reduced duplication of data

// Non-graph databases to graph: 
// 1 relational
// 2 key-value store
// 3 document store

// **********************************************************************************************************************

// CYPHER FUNDAMENTALS

// Reading data

// We want to know what the tagline is for the movie, The Matrix.
MATCH (m:Movie)
WHERE m.title = 'The Matrix'
RETURN m.tagline

MATCH (p:Person {name: "Kevin Bacon"})
RETURN p.born AS answer

MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
RETURN m.title, p.name

MATCH (m:Movie {title: 'The Matrix'})<-[:DIRECTED]-(p:Person)
RETURN p.name

MATCH (m:Movie {title: 'The Matrix'})<-[:DIRECTED]-(p) 
RETURN p.name

MATCH (:Person {name: "Emil Eifrem"})-[:ACTED_IN]->(m:Movie)
RETURN m.title AS answer

MATCH (m:Movie)
WHERE m.released IN [2000, 2002, 2004, 2006, 2008]
RETURN m.title

MATCH (a:Person)-[:ACTED_IN]->(m:Movie)
WHERE m.title = 'The Matrix' AND a.born > 1960
RETURN a.name, a.born

// ************************

// Writing data

// CREATE and MERGE to create nodes
// When using MERGE, you must specify the label, and the name and the value of property
// that will be the primary key for the node

MERGE (p:Person {name: 'Daniel Kaluuya'})

// Create relationship between two existing nodes
MERGE (p:Person {name: 'Lucille Ball'})
-[:ACTED_IN]->
(m:Movie {title: 'Mame'})
RETURN p, m

MERGE (p:Person {name: 'Daniel Kaluuya'})
MERGE (m:Movie {title: 'Get Out'})
MERGE (p)-[:ACTED_IN]->(m)
RETURN p, m

// ************************

// Updating properties
MATCH (m:Movie {title: 'Get Out'})
SET  m.tagline = 'Gripping, scary, witty and timely!',
     m.released = 2017

// ************************

// Remove properties
MATCH (m:Movie)
REMOVE m.tagline
RETURN m

// ************************

// Merge processing
// Creating two nodes and one relathionsip
MERGE (p:Person {name: 'Lucille Ball'})-[:ACTED_IN]->(m:Movie {title: 'Forever, Darling'})

// Update existing node in the graph
MERGE (p:Person {name: 'Lucille Ball'}}
ON MATCH
SET p.born = 1911
RETURN p

// The following query uses a MERGE clause to find or create a 
// :Movie node with the title Rocketman.
// When initially created, the createdAt property will be set 
// but the matchedAt property will be null. If the node already 
// exists, the createdAt property will not be set, but a 
// matchedAt property will be set.
// For both conditions above, the updatedAt property will be 
// set to the current date and time.

//* First Run - only  createdAt and updatedAt will be set */
MERGE (m:Movie {title: 'Rocketman'})
//* perform the ON MATCH setting of the matchedAt property */
ON MATCH SET m.matchedAt = datetime()
//* perform the ON CREATE setting of the createdAt property */
ON CREATE SET m.createdAt = datetime()
//* set the updatedAt property */
SET m.updatedAt = timestamp()
RETURN m.title, m.createdAt, m.matchedAt, m.updatedAt;


//* Second Run - all three properties will be set */
MERGE (m:Movie {title: 'Rocketman'})
//* perform the ON MATCH setting of the matchedAt property */
ON MATCH SET m.matchedAt = datetime()
//* perform the ON CREATE setting of the createdAt property */
ON CREATE SET m.createdAt = datetime()
//* set the updatedAt property */
SET m.updatedAt = timestamp()
RETURN m.title, m.createdAt, m.matchedAt, m.updatedAt

// ************************

// Deleting data

// DELETE fails because Cypher prevents you from deleting nodes
// without first deleting its relationships
MATCH (p:Person {name: 'River Phoenix'})
DETACH DELETE p

// Delete all nodes and relationships
MATCH (n) DETACH DELETE n

// The following query will find any :Person node with the 
// name Emil Eifrem and then use the DETACH DELETE clause to 
// remove each node and any relationships into our out from 
// the node.
MATCH (p:Person {name: "Emil Eifrem"})
DETACH DELETE p

// **********************************************************************************************************************

// GRAPH DATA MODELING FUNDAMENTALS

// Basic graph data modeling elements
// - Nodes
// - Labels
// - Properties
// - Relationships

// To improve existing graph data model: refactoring

// Ways to prepare for modeling
// - Describe the domain in detail
// - Identify the systems and users of the application.
// - Enumerate the use cases of the application.

// Purpose of models
// - to  help us confirm that our data model can satisfy use cases of the application

// What elements of uses cases are used to define labels?
// Nouns

// What can node properties be used for?
// - uniquely identifying a node
// - answering specific details of the use cases
// - returning data

// ************************

// Creating nodes

MATCH (n) DETACH DELETE n;

MERGE (:Movie {title: 'Apollo 13', tmdbId: 568, released: '1995-06-30', imdbRating: 7.6, genres: ['Drama', 'Adventure', 'IMAX']})
MERGE (:Person {name: 'Tom Hanks', tmdbId: 31, born: '1956-07-09'})
MERGE (:Person {name: 'Meg Ryan', tmdbId: 5344, born: '1961-11-19'})
MERGE (:Person {name: 'Danny DeVito', tmdbId: 518, born: '1944-11-17'})
MERGE (:Person {name: 'Jack Nicholson', tmdbId: 514, born: '1937-04-22'})
MERGE (:Movie {title: 'Sleepless in Seattle', tmdbId: 858, released: '1993-06-25', imdbRating: 6.8, genres: ['Comedy', 'Drama', 'Romance']})
MERGE (:Movie {title: 'Hoffa', tmdbId: 10410, released: '1992-12-25', imdbRating: 6.6, genres: ['Crime', 'Drama']})

MATCH (n) RETURN count(n)

// Creating more nodes

MERGE (sandy:User {userId: 534}) SET sandy.name = "Sandy Jones"
MERGE (clinton:User {userId: 105}) SET clinton.name = "Clinton Spencer"

// What elements of the use cases are used to define the relationships in the data model?
// Verbs

// When you define relationships in the graph data model, what must you define?
// - The starting node (with label) for the relationship.
// - The ending node (with label) for the relationship.
// - The name (type) for the relationship.

// ************************

// Creating initial relationships

MATCH (n) DETACH DELETE n;

MERGE (:Movie {title: 'Apollo 13', tmdbId: 568, released: '1995-06-30', imdbRating: 7.6, genres: ['Drama', 'Adventure', 'IMAX']})
MERGE (:Person {name: 'Tom Hanks', tmdbId: 31, born: '1956-07-09'})
MERGE (:Person {name: 'Meg Ryan', tmdbId: 5344, born: '1961-11-19'})
MERGE (:Person {name: 'Danny DeVito', tmdbId: 518, born: '1944-11-17'})
MERGE (:Movie {title: 'Sleepless in Seattle', tmdbId: 858, released: '1993-06-25', imdbRating: 6.8, genres: ['Comedy', 'Drama', 'Romance']})
MERGE (:Movie {title: 'Hoffa', tmdbId: 10410, released: '1992-12-25', imdbRating: 6.6, genres: ['Crime', 'Drama']})
MERGE (:Person {name: 'Jack Nicholson', tmdbId: 514, born: '1937-04-22'})
MERGE (:User {name: 'Sandy Jones', userId: 534})
MERGE (:User {name: 'Clinton Spencer', userId: 105})

MATCH (apollo:Movie {title: 'Apollo 13'})
MATCH (tom:Person {name: 'Tom Hanks'})
MATCH (meg:Person {name: 'Meg Ryan'})
MATCH (danny:Person {name: 'Danny DeVito'})
MATCH (sleep:Movie {title: 'Sleepless in Seattle'})
MATCH (hoffa:Movie {title: 'Hoffa'})
MATCH (jack:Person {name: 'Jack Nicholson'})

// create the relationships between nodes
MERGE (tom)-[:ACTED_IN {role: 'Jim Lovell'}]->(apollo)
MERGE (tom)-[:ACTED_IN {role: 'Sam Baldwin'}]->(sleep)
MERGE (meg)-[:ACTED_IN {role: 'Annie Reed'}]->(sleep)
MERGE (danny)-[:ACTED_IN {role: 'Bobby Ciaro'}]->(hoffa)
MERGE (danny)-[:DIRECTED]->(hoffa)
MERGE (jack)-[:ACTED_IN {role: 'Jimmy Hoffa'}]->(hoffa)

// Creating more relationships

MATCH (sandy:User {name: 'Sandy Jones'})
MATCH (clinton:User {name: 'Clinton Spencer'})
MATCH (apollo:Movie {title: 'Apollo 13'})
MATCH (sleep:Movie {title: 'Sleepless in Seattle'})
MATCH (hoffa:Movie {title: 'Hoffa'})
MERGE (sandy)-[:RATED {rating:5}]->(apollo)
MERGE (sandy)-[:RATED {rating:4}]->(sleep)
MERGE (clinton)-[:RATED {rating:3}]->(apollo)
MERGE (clinton)-[:RATED {rating:3}]->(sleep)
MERGE (clinton)-[:RATED {rating:3}]->(hoffa)

// ************************

// During your testing of the use cases, what might you need to do?
// - Add more data to the graph to test scalability.
// - Test and modify any Cypher code used to test the use cases.
// -  Refactor the data model if a use case cannot be answered.

// Testing with instance model

MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle'
RETURN p.name AS Actor

MATCH (p:Person)-[:DIRECTED]-(m:Movie)
WHERE m.title = 'Hoffa'
RETURN  p.name AS Director

MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks'
RETURN m.title AS Movie

MATCH (u:User)-[:RATED]-(m:Movie)
WHERE m.title = 'Apollo 13'
RETURN count(*) AS `Number of reviewers`

MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Hoffa'
RETURN  p.name AS Actor, p.born as `Year Born` ORDER BY p.born DESC LIMIT 1

MATCH (p:Person)-[r:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle' AND
p.name = 'Meg Ryan'
RETURN  r.role AS Role

MATCH (m:Movie)
WHERE m.released STARTS WITH '1995'
RETURN  m.title as Movie, m.imdbRating as Rating ORDER BY m.imdbRating DESC LIMIT 1

MERGE (casino:Movie {title: 'Casino', tmdbId: 524, released: '1995-11-22', imdbRating: 8.2, genres: ['Drama','Crime']})
MERGE (martin:Person {name: 'Martin Scorsese', tmdbId: 1032})
MERGE (martin)-[:DIRECTED]->(casino)

MATCH (p:Person)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks' AND
'Drama' IN m.genres
RETURN m.title AS Movie

MATCH (u:User)-[r:RATED]-(m:Movie)
WHERE m.title = 'Apollo 13' AND
r.rating = 5
RETURN u.name as Reviewer

MATCH (n) RETURN n

// ************************

// Why refactor?
// - Any of the use cases cannot be answered by the graph.
// - Another use case has been created that needs to be accounted for.
// - The data model does not scale.

// Why add labels?
// -  To reduce the number of data accessed at runtime.

// As a best practice, what is the maximum number of labels a node should have?
// 4

// ************************

// Adding the actor label

// Profile the query
PROFILE MATCH (p:Person)-[:ACTED_IN]-()
WHERE p.born < '1950'
RETURN p.name

// Refactor the graph
// With Cypher, you can easily transform the graph to add Actor labels.
// Execute this Cypher code to add the Actor label to the appropriate nodes:
MATCH (p:Person)
WHERE exists ((p)-[:ACTED_IN]-())
SET p:Actor

// Steps after refactoring
// - Rewrite any Cypher queries for use cases that are affected by the refactoring.
// - Retest all use cases that are affected by the refactoring.

// ************************

// Retesting with Actor label

MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle'
RETURN p.name AS Actor

MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks'
RETURN m.title AS Movie

MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)
WHERE m.title = 'Hoffa'
RETURN  p.name AS Actor, p.born as `Year Born` ORDER BY p.born DESC LIMIT 1

MATCH (p:Actor)-[r:ACTED_IN]-(m:Movie)
WHERE m.title = 'Sleepless in Seattle' AND
p.name = 'Meg Ryan'
RETURN  r.role AS Role

MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks' AND
'Drama' IN m.genres
RETURN m.title AS Movie

MATCH (p:Actor)
WHERE p.born < '1950'
RETURN p.name

MATCH (n)
RETURN n

// ************************

// Adding the Director label
MATCH (p:Person)
WHERE exists ((p)-[:DIRECTED]-())
SET p:Director

MATCH (p:Director)-[:DIRECTED]-(m:Movie)
WHERE m.title = 'Hoffa'
RETURN  p.name AS Director

// ************************

// What label practices should you avoid when creating your graph data model?
// - Semantically orthogonal labels.
// - Labels to represent class hierarchies for your data.

// ************************

// Why eliminate duplication?
// - Improve query performance.
// - Reduce the amount of storage required for the graph.

// ************************

// Adding Language data

// Execute this Cypher code to add a languages property to the Movie nodes of the graph:
MATCH (apollo:Movie {title: 'Apollo 13', tmdbId: 568, released: '1995-06-30', imdbRating: 7.6, genres: ['Drama', 'Adventure', 'IMAX']})
MATCH (sleep:Movie {title: 'Sleepless in Seattle', tmdbId: 858, released: '1993-06-25', imdbRating: 6.8, genres: ['Comedy', 'Drama', 'Romance']})
MATCH (hoffa:Movie {title: 'Hoffa', tmdbId: 10410, released: '1992-12-25', imdbRating: 6.6, genres: ['Crime', 'Drama']})
MATCH (casino:Movie {title: 'Casino', tmdbId: 524, released: '1995-11-22', imdbRating: 8.2, genres: ['Drama','Crime']})
SET apollo.languages = ['English']
SET sleep.languages =  ['English']
SET hoffa.languages =  ['English', 'Italian', 'Latin']
SET casino.languages =  ['English']

MATCH (m:Movie)
WHERE 'Italian' IN m.languages
RETURN m.title

// ************************

// UNWIND to separate list elements

// Refactoring duplicate data

// Creating language nodes
// Execute this code to refactor the graph to turn the languages property values into Language nodes:
MATCH (m:Movie)
UNWIND m.languages AS language
WITH  language, collect(m) AS movies
MERGE (l:Language {name:language})
WITH l, movies
UNWIND movies AS m
WITH l,m
MERGE (m)-[:IN_LANGUAGE]->(l);
MATCH (m:Movie)
SET m.languages = null

// Modifying the Cypher statement
// This is the Cypher code for what our use case used to be before the refactoring.
MATCH (m:Movie)
WHERE 'Italian' IN m.languages
RETURN m.title
// This query can now be modified to instead use the newly-created Language node.
MATCH (m:Movie)-[:IN_LANGUAGE]-(l:Language)
WHERE  l.name = 'Italian'
RETURN m.title

// Adding Genre nodes
//refactor code
MATCH (m:Movie)
UNWIND m.genres AS genre
MERGE (g:Genre {name: genre})
MERGE (m)-[:IN_GENRE]->(g)
SET m.genres = null

//revised query
MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)--(g:Genre)
WHERE p.name = 'Tom Hanks' AND
g.name = 'Drama'
RETURN m.title AS Movie

// Why do you refactor a graph that has complex data in nodes?
// - Eliminate duplication of data in multiple nodes.
// - Improve query performance.

// Why do you refactor a graph to specialize relationships?
// - Reduce the number of nodes that need to be retrieved.
// - improve query performance.

// What do you do to create a dynamic relationship in Cypher?
// - Use the APOC library.

// Specializing ACTED_IN and DIRECTED Relationships
// Execute the following code to create a new set of relationships based on the year of the released property for each Node.
// For example, Apollo 13 was released in 1995, so an additional ACTED_IN_1995 will be created between Apollo 13 and any actor that acted in the movie.
MATCH (n:Actor)-[:ACTED_IN]->(m:Movie)
CALL apoc.merge.relationship(n,
  'ACTED_IN_' + left(m.released,4),
  {},
  {},
  m ,
  {}
) YIELD rel
RETURN count(*) AS `Number of relationships merged`;

MATCH (n:Director)-[r:DIRECTED]->(m:Movie)
CALL apoc.merge.relationship(n,
  'DIRECTED_' + left(m.released,4),
  {},
  {},
  m,
  {}
) YIELD rel
RETURN COUNT(*) AS `Number of relationships added`;

// Use case #12: What movies did an actor act in for a particular year?
// To verify the query has run successfully, we can attempt to use the newly created ACTED_IN_1995 relationship 
// to see which Movies Tom Hanks acted in that were released in 1995.
MATCH (p:Actor)-[:ACTED_IN_1995]->(m:Movie)
WHERE p.name = 'Tom Hanks'
RETURN m.title AS Movie

// Refactor all DIRECTED relationships
// We can use the same method to create DIRECTED_{year} relationships between the Director and the Movie.
// Modify the code you have just run to match the following pattern.
// MATCH (n:Director)-[:DIRECTED]→(m:Movie)
// Then modify the procedure call change the prefix of the relationship to DIRECTED_.
// It should create 2 relationships.

// With this refactoring and the previous refactoring, we can now confirm that our rewritten query works for the use case:
MATCH (p:Person)-[:ACTED_IN_1995|DIRECTED_1995]->()
RETURN p.name as `Actor or Director`

// Specializing RATED Relationships

MATCH (u:User)-[r:RATED]->(m:Movie)
WHERE m.title = 'Apollo 13' AND
r.rating = 5
RETURN u.name as Reviewer

// It should return one User, Sandy Jones.
// What if there were thousands of Users in the graph. This query would need to traverse all RATED relationships and evaluate the rating property. 
// For a large graph, more evaluations mean longer query processing time.
// In this challenge, you will specialize the RATED relationships to reflect the rating. Unlike the refactoring where we removed the genres and 
// languages properties from the nodes, we will not remove the rating property from the RATED relationship. This is because we may need it for a query 
// that has a reference to the relationship and needs to return the rating value.

//Creating specialized RATED_{rating} Relationships
// To pass this challenge, you must use the knowledge you gained in the previous lesson to merge a relationship between the graph using apoc.merge.relationship.
// The pattern you must search for is:
// MATCH (u:User)-[r:RATED]→(m:Movie)
// The relationship type passed as the second parameter should be:
// 'RATED_'+ r.rating

MATCH (n:User)-[r:RATED]->(m:Movie)
CALL apoc.merge.relationship(n,
  'RATED_' + r.rating,
  {},
  {},
  m,
  {}
) YIELD rel
RETURN COUNT(*) AS `Number of relationships added`;

// Why do you refactor to create intermediate nodes?
// - Connect more than two nodes in a single context.
// - Share data in the graph.
// - Relate something to a relationship.

// Intermediate nodes
// Find an actor that acted in a Movie
MATCH (a:Actor)-[r:ACTED_IN]->(m:Movie)

// Create a Role node
MERGE (x:Role {name: r.role})

// Create the PLAYED relationship
// relationship between the Actor and the Role nodes.
MERGE (a)-[:PLAYED]->(x)

// Create the IN_MOVIE relationship between
// the Role and the Movie nodes.
MERGE (x)-[:IN_MOVIE]->(m)

// **********************************************************************************************************************

// IMPORTING CSV DATA INTO NEO4J

// What format of source data file does Cypher support out-of-the-box for importing?
// CSV

// De-normalized CSV data
// - Typically represents data from multiple tables in the RDBMS.
// - There is duplication of data in the CSV file.
// - IDs representing an entity that will be loaded as a Node must be unique.

// Delimiting fields in CSV files
// Use FIELDTERMINATOR if not the delimiter is not a comma

// Load CSV data
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing/ratings.csv'
AS row
RETURN count(row)

// Return the count of the number of nodes in the graph
MATCH (n) RETURN count(n)

// Return the count of the number of relathionships
MATCH ()-[r]->() RETURN count(r)

// Inpsect names and types of node properties
CALL apoc.meta.nodeTypeProperties()

// Inpsect names and type of relationship properties
CALL apoc.meta.relTypeProperties()

// ************************

// Transforming multi-value properties

// When you transform a multi-value property to a list of strings, what type does it have in the graph?
// StringArray

// What built-in Cypher functions help you to transform a list?
// split()
// coalesce()

// Transform properties to lists
MATCH (m:Movie)
SET m.countries = split(coalesce(m.countries,""), "|"),
m.languages = split(coalesce(m.languages,""), "|"),
m.genres = split(coalesce(m.genres,""), "|")

// ************************

// Adding labels to nodes
MATCH (p:Person)-[:DIRECTED]->()
WITH DISTINCT p
SET p: Director 

// ************************

// Refactoring properties as nodes 

SHOW CONSTRAINTS 

// Why do you add a uniqueness constraint to the graph prior to creating nodes?
// - A best practice is to have a unique ID for a node of a given type in the graph.
// - It prevents duplicate nodes when you create them in the graph.
// - It speeds up MERGE performance.

// add the uniqueness constraint for the Genre nodes to the graph:
CREATE CONSTRAINT Genre_name IF NOT EXISTS
FOR (x:Genre)
REQUIRE x.name IS UNIQUE

// create the Genre nodes in the graph, and the IN_GENRE relationships:
MATCH (m:Movie)
UNWIND m.genres AS genre
WITH m, genre
MERGE (g:Genre {name:genre})
MERGE (m)-[:IN_GENRE]->(g)

// Remove the genres property.
MATCH (m:Movie)
SET m.genres = null

// View the schema.
CALL db.schema.visualization

// **********************************************************************************************************************

// IMPORTING DATA WITH CYPHER


// Import Movie and Genre data
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing/2-movieData.csv'
AS row
//process only Movie rows
WITH row WHERE row.Entity = "Movie"
RETURN
toInteger(row.tmdbId),
toInteger(row.imdbId),
toInteger(row.movieId),
toFloat(row.imdbRating),
row.released,
row.title,
toInteger(row.year),
row.poster,
toInteger(row.runtime),
split(coalesce(row.countries,""), "|"),
toInteger(row.imdbVotes),
toInteger(row.revenue),
row.plot,
row.url,
toInteger(row.budget),
split(coalesce(row.languages,""), "|"),
split(coalesce(row.genres,""), "|")
LIMIT 10

CALL {
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing/2-movieData.csv'
AS row
//process only Movie rows
WITH row WHERE row.Entity = "Movie"
MERGE (m:Movie {movieId: toInteger(row.movieId)})
ON CREATE SET
m.tmdbId = toInteger(row.tmdbId),
m.imdbId = toInteger(row.imdbId),
m.imdbRating = toFloat(row.imdbRating),
m.released = datetime(row.released),
m.title = row.title,
m.year = toInteger(row.year),
m.poster = row.poster,
m.runtime = toInteger(row.runtime),
m.countries = split(coalesce(row.countries,""), "|"),
m.imdbVotes = toInteger(row.imdbVotes),
m.revenue = toInteger(row.revenue),
m.plot = row.plot,
m.url = row.url,
m.budget = toInteger(row.budget),
m.languages = split(coalesce(row.languages,""), "|")
WITH m,split(coalesce(row.genres,""), "|") AS genres
UNWIND genres AS genre
WITH m, genre
MERGE (g:Genre {name:genre})
MERGE (m)-[:IN_GENRE]->(g)
}


// Import Person data
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing/2-movieData.csv'
AS row
WITH row WHERE row.Entity = "Person"
RETURN
toInteger(row.tmdbId),
toInteger(row.imdbId),
row.bornIn,
row.name,
row.bio,
row.poster,
row.url,
CASE row.born WHEN "" THEN null ELSE datetime(row.born) END,
CASE row.died WHEN "" THEN null ELSE datetime(row.died) END
LIMIT 10

CALL {
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing/2-movieData.csv'
AS row
WITH row WHERE row.Entity = "Person"
MERGE (p:Person {tmdbId: toInteger(row.tmdbId)})
ON CREATE SET
p.imdbId = toInteger(row.imdbId),
p.bornIn = row.bornIn,
p.name = row.name,
p.bio = row.bio,
p.poster = row.poster,
p.url = row.url,
p.born = CASE row.born WHEN "" THEN null ELSE date(row.born) END,
p.died = CASE row.died WHEN "" THEN null ELSE date(row.died) END
}


// Import the ACTED_IN relationships
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing/2-movieData.csv'
AS row
WITH row WHERE row.Entity = "Join" AND row.Work = "Acting"
RETURN
toInteger(row.tmdbId),
toInteger(row.movieId),
row.role
LIMIT 10

CALL {
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing/2-movieData.csv'
AS row
WITH row WHERE row.Entity = "Join" AND row.Work = "Acting"
MATCH (p:Person {tmdbId: toInteger(row.tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[r:ACTED_IN]->(m)
ON CREATE
SET r.role = row.role
SET p:Actor
}


// Import the DIRECTED relationships
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing/2-movieData.csv'
AS row
WITH row WHERE row.Entity = "Join" AND row.Work = "Directing"
RETURN
toInteger(row.tmdbId),
toInteger(row.movieId),
row.role
LIMIT 10

CALL {
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing/2-movieData.csv'
AS row
WITH row WHERE row.Entity = "Join" AND row.Work = "Directing"
MATCH (p:Person {tmdbId: toInteger(row.tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[r:DIRECTED]->(m)
ON CREATE
SET r.role = row.role
SET p:Director
}

// Import the User data
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing/2-ratingData.csv'
AS row
RETURN
toInteger(row.movieId),
toInteger(row.userId),
row.name,
toInteger(row.rating),
toInteger(row.timestamp)
LIMIT 100

CALL {
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing/2-ratingData.csv'
AS row
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (u:User {userId: toInteger(row.userId)})
ON CREATE SET u.name = row.name
MERGE (u)-[r:RATED]->(m)
ON CREATE SET r.rating = toInteger(row.rating),
r.timestamp = toInteger(row.timestamp)
}

// **********************************************************************************************************************

// INTERMEDIATE CYPHER QUERIES

// Filtering queries

// View data model
CALL db.schema.visualization()

// View property nodes
CALL db.schema.nodeTypeProperties()

// View relationship nodes
CALL db.schema.relTypeProperties()

// View uniqueness constraints
SHOW CONSTRAINTS

MATCH (p:Person)-[r:DIRECTED]->(m:Movie)
WHERE r.role IS NOT null
AND m.year = 2015
RETURN p.name, r.role, m.title

MATCH (d:Director)-[:DIRECTED]->(m:Movie)-[:IN_GENRE]->(g:Genre)
WHERE m.year = 2000 AND g.name = "Horror"
RETURN d.name

// return people born in the 1950’s (1950 - 1959) that are both Actors and Directors.
MATCH (p:Person)
WHERE p:Actor AND p:Director
AND  1950 <= p.born.year < 1960
RETURN p.name, labels(p), p.born

// Write and execute a query to return people who both acted in and directed a movie released in the German language.
MATCH (p:Director)-[:DIRECTED]->(m:Movie)<-[:ACTED_IN]-(p)
WHERE "German" IN m.languages
OR " German" IN m.languages
OR " German " IN m.languages
OR "German " IN m.languages
return p.name, labels(p), m.title, m.languages

// We want to find all actors whose name begins with Robert. What clause do you use?
MATCH (p:Person)
WHERE p.name STARTS WITH 'Robert'
RETURN p.name

// What Cypher keyword can you use to determine if an index will be used for a query?
// EXPLAIN

// Write and execute a query to return the name of the person, their role, and the movie title where 
// the role played by the actors or director had a value that included 'dog' (case-insensitive)? 
// That is, the role could contain "Dog", "dog", or even "DOG".
MATCH (p:Person)-[r]->(m:Movie)
WHERE toLower(r.role) CONTAINS "dog"
RETURN p.name, r.role, m.title

// Testing if a pattern exists
// We want to return the movies that Clint Eastwood acted in and directed.
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE  p.name = "Clint Eastwood"
AND exists {(p)-[:DIRECTED]->(m)}
RETURN m.title

// What Cypher keyword helps you to understand the performance of a query when it runs?
// PROFILE

PROFILE MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name = 'Clint Eastwood'
AND NOT exists {(p)-[:DIRECTED]->(m)}
RETURN m.title

// We want to return the names of all actors whose name begins with Tom and also the names of the movies they directed. 
// If they did not direct the movie, then return a null value.
MATCH (p:Person)
WHERE p.name STARTS WITH 'Tom'
OPTIONAL MATCH (p)-[:DIRECTED]->(m:Movie)
RETURN p.name, m.title

// What value does OPTIONAL MATCH return if there is no value for a string property being returned in a row?
// null

// Here is a query that returns the titles of all Film Noir movies and the users who rated them.
// In this query we are performing two MATCH clauses where the movie found in the first match 
// is used to find all users that rated that particular movie.
MATCH (m:Movie)-[:IN_GENRE]->(g:Genre)
WHERE g.name = 'Film-Noir'
MATCH (m)<-[:RATED]-(u:User)
RETURN m.title, u.name

// OPTIONAL MATCH
MATCH (m:Movie)-[:IN_GENRE]->(g:Genre)
WHERE g.name = 'Film-Noir'
OPTIONAL MATCH (m)<-[:RATED]-(u:User)
RETURN m.title, u.name


// ************************

// Controlling results returned

// We want to return the ratings that Sandy Jones gave movies and return the rating from highest to lowest.
MATCH (u:User)-[r:RATED]->(m:Movie)
WHERE u.name = 'Sandy Jones'
RETURN m.title AS movie, r.rating AS rating
ORDER BY r.rating DESC

// What is the maximum number of properties can you order in your results?
// Unlimited

MATCH (m:Movie)
WHERE m.imdbRating IS NOT NULL
RETURN m.title
ORDER BY m.imdbRating DESC

MATCH (m:Movie)<-[ACTED_IN]-(p:Person)
WHERE m.imdbRating IS NOT NULL
RETURN m.title, m.imdbRating, p.name, p.born
ORDER BY m.imdbRating DESC, p.born DESC

// We want to return the movies that have been reviewed.
// How would you complete this query so that duplicate movie titles are not returned?
MATCH (m:Movie)<-[:RATED]-()
RETURN DISTINCT m.title

// Here is a query that returns the names people who acted or directed the movie Toy Story 
// and then retrieves all people who acted in the same movie.
MATCH (p:Person)-[:ACTED_IN| DIRECTED]->(m)
WHERE m.title = 'Toy Story'
MATCH (p)-[:ACTED_IN]->()<-[:ACTED_IN]-(p2:Person)
RETURN  p.name, p2.name

// We want to return the title and release date as Movie objects 
// for all Woody Allen movies. Select the correct RETURN clause to do this.
MATCH (m:Movie)<-[:DIRECTED]-(d:Director)
WHERE d.name = 'Woody Allen'
RETURN m {.title, .released} AS movie
ORDER BY m.released

// What is returned in every rows?
MATCH (p:Person)
WHERE p.name CONTAINS "Thomas"
RETURN p AS person ORDER BY p.name
// - labels
// - identity
// - properties

// We want to return information about actors who acted in the Toy Story movies. 
// We want to return the age that an actor will turn this year or that the actor died.
MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
WHERE m.title CONTAINS 'Toy Story'
RETURN m.title AS movie,
p.name AS actor,
p.born AS dob,
CASE WHEN p.died IS NULL THEN date().year - p.born.year
WHEN p.died IS NOT NULL THEN 'Died'
END AS ageThisYear

// **********************************************************************************************************************

// WORKING WITH CYPHER DATA

// We want to return the list of names of actors in the movie Toy Story as a single row. What code do you use?
MATCH (movie:Movie {title:'Toy Story'})<-[:ACTED_IN]-(actor:Person)
RETURN collect(actor.name) AS actors

// What Cypher function can you use to return the number of elements in a list of Movie nodes, movies?
// size(movies)

// Most active director?
MATCH (p:Person)-[:DIRECTED]->(m:Movie)
RETURN p.name, count(m.title)
ORDER BY count(m.title) DESC

// For the largest cast, how many actors were in the movies with the title "Hamlet"?
MATCH (a:Actor)-[:ACTED_IN]->(m:Movie)
RETURN m.title AS movie,
collect(a.name) AS cast,
size(collect(a.name)) AS num
ORDER BY num DESC LIMIT 1

// We need to calculate how old Charlie Chaplin was when he died. What code do you use?
MATCH (p:Person)
WHERE p.name = 'Charlie Chaplin'
RETURN duration.between(p.born, p.died).years



MERGE (x:Test {id: 1})
SET
x.date = date(),
x.datetime = datetime(),
x.timestamp = timestamp(),
x.date1 = date('2022-04-08'),
x.date2 = date('2022-09-20'),
x.datetime1 = datetime('2022-02-02T15:25:33'),
x.datetime2 = datetime('2022-02-02T22:06:12')
RETURN x

MATCH (x:Test)
RETURN duration.inDays(x.date1, x.date2).days

MATCH (x:Test)
RETURN duration.between(x.datetime1, x.datetime2).minutes

// **********************************************************************************************************************

// GRAPH TRAVERSAL

// What term best describes the traversal behavior during a query?
// depth-first

// What actors are up to 6 hops away?
// We want to return a list of actors that are up to 6 hops away from Tom Hanks.
MATCH (p:Person)-[:ACTED_IN*1..6]-(others:Person)
WHERE p.name = 'Tom Hanks'
RETURN  others.name

// Finding the shortest path between 2 nodes
// shortestPath()

// **********************************************************************************************************************

// PIPELINING QUERIES

// Scoping variables
// Here is a query to return the name of the actor (Clint Eastwood) and all the movies that he acted in that contain the string 'high'. 
// How do you complete this query so it can return the desired results?
WITH  'Clint Eastwood' AS a, 'high' AS t
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WITH p, m, toLower(m.title) AS movieTitle
WHERE p.name = a
AND movieTitle CONTAINS t
RETURN p.name AS actor, m.title AS movie

WITH  'Tom Hanks' AS theActor
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name = theActor
AND m.revenue IS NOT NULL
WITH m ORDER BY m.revenue DESC LIMIT 1
RETURN m.revenue AS revenue, m.title AS title

// Top movies
// data returned for each Movie node to include:
// title
// imdbRating
// List of actor names
// List of Genre names
MATCH (n:Movie)
WHERE n.imdbRating IS NOT NULL AND n.poster IS NOT NULL
WITH n {
  .title,
  .imdbRating,
  actors: [ (n)<-[:ACTED_IN]-(p) | p { tmdbId:p.imdbId, .name } ],
  genres: [ (n)-[:IN_GENRE]->(g) | g {.name}]
}
ORDER BY n.imdbRating DESC
LIMIT 4
RETURN collect(n)

// Limiting results
// Here is a query to return the names of Directors who directed movies that Keanu Reeves acted in. \
// How do you specify that you want to limit the number of rows returned to 3?
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name = 'Keanu Reeves'
WITH m LIMIT 3
MATCH (d:Person)-[:DIRECTED]->(m)
RETURN collect(d.name) AS directors,
m.title AS movies

// What Tom Hanks movie had the highest average rating greater than 4?
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[r:RATED]-(:User)
WHERE p.name = 'Tom Hanks'
WITH m, avg(r.rating) AS avgRating
WHERE avgRating > 4
RETURN m.title AS Movie, avgRating AS `AverageRating`
ORDER BY avgRating DESC

// Unwinding lists
// Here is a query to return the title of a movie and language pair for any Tom Hanks movie that has exactly two languages associated with it. 
//That is each movie will have two rows, the title is repeated and then each language for that title. 
// How do you complete this query to create a lang value that is an element of the languages list?
MATCH (m:Movie)-[:ACTED_IN]-(a:Actor)
WHERE a.name = 'Tom Hanks'
AND size(m.languages) = 2
UNWIND m.languages as lang
RETURN m.title AS movie,lang AS languages

// What type of data can UNWIND be used for?
// - List of strings
// - List of numerics

// How many movies released in the UK are in the graph?
MATCH (m:Movie)
UNWIND m.countries AS country
WITH m, trim(country) AS trimmedCountry
// this automatically, makes the trimmedCountry distinct because it's a grouping key
WITH trimmedCountry, collect(m.title) AS movies
RETURN trimmedCountry, size(movies)

// **********************************************************************************************************************

// REDUCING MEMORY

// Using a subquery
// Here is a query that has a subquery. The enclosing query finds all User nodes. 
// The subquery finds all movies that this user rated with 5 and return them.
MATCH (u:User)
CALL {
  with u
  MATCH (m:Movie)<-[r:RATED]-(u)
     WHERE r.rating = 5
    RETURN m
}
RETURN m.title, count(m) AS numReviews
ORDER BY numReviews DESC

// Top French movie
MATCH (g:Genre)
CALL { WITH g
MATCH (g)<-[:IN_GENRE]-(m) WHERE 'France' IN m.countries
RETURN count(m) AS numMovies
}
RETURN g.name AS Genre, numMovies ORDER BY numMovies DESC

// Combining Results
// Actors and Directors from 2015
MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
WHERE m.year = 2015
RETURN "Actor" AS type,
p.name AS workedAs,
collect(m.title) AS movies
UNION ALL
MATCH (m:Movie)<-[:DIRECTED]-(p:Person)
WHERE m.year = 2015
RETURN "Director" AS type,
p.name AS workedAs,
collect(m.title) AS movies

// **********************************************************************************************************************

// USING PARAMETERS

// set the following parameters:
:params {actorName: 'Tom Cruise', movieName: 'Top Gun', l:2}

MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE m.title = $movieName
RETURN p.name
LIMIT $l

// Parameters for the session?
// : params

// Setting Integers
// :param myNumber ⇒ 10

// Set name parameter to Tom
:param name: "Tom"