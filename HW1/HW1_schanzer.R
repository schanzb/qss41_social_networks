rm(list = ls())

# Set working dir
setwd("~/social_networks/HW1")

# Question 1:
# Generate a dataframe with at least ten named individuals. Give them scores on five assignments Include some missing assignments. Add one column that gives the mean of all their scores, figuring the mean for those with missing assignments based on the number submitted, not the number assigned.

# create list of names
names = c("Fred", "Ashely", "Owen", "Avery", "Andy", "Andrea", "Emily", "Danny", "Ben", "Conor")

#create matrix of scores
scores <- matrix(c(
  91, 90, 69, 82, 89,
  60, 65, NA, 79, 67,
  75, NA, 95, 72, 84,
  98, 73, 61, NA, 76,
  NA, 80, 70, 93, 62,
  87, 64, 78, 96, 71,
  83, 92, 66, 74, NA,
  68, 77, 100, 63, 88,
  81, NA, 86, 70, 94,
  72, 85, 91, NA, 79
), ncol = 5, byrow = TRUE)

# turn scores into a df
df = as.data.frame(scores)
# add the names to the df
df = cbind(Student =names, df)

# find row averages, ignoring NA values
# na.rm = TRUE to ignore NA values
df$row_avg <- rowMeans(as.matrix(df[,-1]), na.rm = TRUE)

# give the cols names so it looks nicer
colnames(df) = c("Student", "Test 1", "Test 2", "Test 3", "Test 4", "Test 5", "Average Test Score")

# QUESTION 2
# Using the UKfaculty graph from igraphdata, generate an edgelist and an adjacency matrix.  You can display the first 10 rows of the edgelist and   the upper left 10 x 10 of the adjacency matrix.  Do not use the sparse matrix.   Create a separate dataframe that lists each node id, along with columns for degree, closeness centrality and betweenness centrality.

# Load Packages
library(igraphdata)
library(igraph)
# Load data
data("UKfaculty")
# Create Adj Matrix
A = as_adjacency_matrix(UKfaculty, sparse = F)
# Create edge list
E = as_edgelist(UKfaculty)

print(A[1:10,1:10]) # print top-left 10x10
print(E[1:10,]) # print first 10 rows

unique_nodes = unique(as.vector(E)) # get unique nodes
df2 = data.frame(node = unique_nodes) # put them into a dataframe
df2$degree = degree(UKfaculty)[unique_nodes]
df2$closeness = closeness(UKfaculty)[unique_nodes]
df2$betweenness = betweenness(UKfaculty)[unique_nodes]

# QUESTION 3
# Create an edgelist that includes the connections between you and and at least 10 friends or family.  Create an Igraph object from the edgelist.  Plot the graph of your connections.  Include also whether your friends and family are connected with each other, not just with you.

# Define pairs of Nodes (to/from)
# Ben, Jonah, Cole, Savannah, Caden, Emily, Danny, Marty, Avery, Mom
edges <- c("Ben", "Jonah",
           "Ben", "Cole",
           "Ben", "Savannah",
           "Ben", "Caden",
           "Ben", "Emily",
           "Ben", "Danny",
           "Ben", "Marty",
           "Ben", "Avery",
           "Ben", "Mom",
           "Jonah", "Cole",
           "Jonah", "Emily",
           "Jonah", "Danny",
           "Jonah", "Mom",
           "Savannah", "Caden",
           "Savannah", "Emily",
           "Savannah", "Danny",
           "Savannah", "Mom",
           "Caden", "Emily",
           "Caden", "Avery",
           "Caden", "Marty",
           "Caden", "Mom",
           "Emily", "Danny",
           "Emily", "Mom",
           "Danny", "Mom",
           "Marty", "Avery"
)

edge_list <- matrix(edges, ncol = 2, byrow = TRUE)

g = graph_from_edgelist(edge_list,directed=F)
plot(g, 
     vertex.size = 25, 
     edge.curved = 0.25, 
     )