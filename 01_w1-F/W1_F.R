rm(list = ls())
setwd("~/social_networks/01_w1-F")

# Pulling in an edge list
# V1 - From: 
# V2 - To:
ecomp = as.data.frame(read.table(file = "../Data/email_main_component.txt", sep = "|"))
ecomp[1:5,]

g1 = graph.data.frame(ecomp, directed=FALSE)

out_degree = degree(g1, v = "103559", mode="out")

# plot(g1, vertex.label = NA)


# INFO ON VERTICIES
# give list of vertices for graph g1, 1-5
V(g1)[1:5]

# get name of each vertex - can set or defaults to row
V(g1)$name[1:5]

# Number of vertices
length(V(g1))

# Figure out which index a specific vertex sits at
which(V(g1)$name == "100052")


# INFO ON EDGES
# first few edges
E(g1)[1:5]

# give all edges that include node 1
E(g1)[.inc(1)]


# ATTRIBUTES
# edges and vertices can have other attributes (gender, age, income, distance,etc)

V(g1)$test_attribute = rep(c("A", "B", "C", "D", "E", "F"), times = 243)
V(g1)$test_attribute[1:10]

# find total number of notes with test_attribute == C
length(which(V(g1)$test_attribute=="C"))


# Finding Geodesic
shortest_paths(g1, from=V(g1)[1], to = V(g1)[2])

# measure of centrality (degree) 
# lists degree of the first 5 vertices
degree(g1)[1:5]

hist(degree(g1))

# The adjaceny matrix
g2 = graph.data.frame(ecomp, directed = TRUE)
adj = as_adjacency_matrix(g2, sparse = F)
adj[25:30,25:30]

test = as_adjacency_matrix(g1, sparse = FALSE)
test[25:30, 25:30]
# Some values are 2, has multiple edges/loops
# simplify command to get rid of those
simplify(g1)


# OTHER DATA STRUCTURES
library(igraph)

# g is igraph object
A = as.matrix(as_adjacency_matrix(g1))
# weight is undefined here, but if we had a 3rd column for the weight of the 
# edge this would consider it
# Aw = as.matrix(as_adj_list(g, attr = "weight"))

# #edgelist (2-column matrix)#
# E <- as_edgelist(g)
# Ew <- data.frame(as_edgelist(g), weights = E(g)$weight)
# # edgelist written both ways (u,v) and (v,u)
# E2 <- rbind(E, E[, c(2,1)])
# E2w <- rbind(Ew, Ew[, c(2,1,3)])
# # adjacency
# listL <- as_adj_list(g)


# DISTANCE MATRIX
# Counts number of steps between one node and another; length of geodesic
distance_matrix = distances(g2)
distance_matrix[25:30, 25:30]

# MATRIX MULTIPLCATION
# if you multiply matrix A*A, each cell represents the 
# number of two-step paths between the vertices
# A2 = A %*% A ---> matrix multiplation command
# A2[i,j] ---> sum across all k of A[i,k] * a[k,j]


# SETUP
library(igraphdata)
data("UKfaculty")
UKfaculty = as.undirected(UKfaculty)

plot(UKfaculty, vertex.label = NA)

# TRANSITIVITY
# number of closed vs open triangles
# global transitivity: proportion of closed triangles over all possible triangles int he whole graph
transitivity(UKfaculty, "global")

# local transitivity: proportion of closed triangles over all possible triangles at the individual level
# for each individual, what proportion of their triangles are closed, average all 
transitivity(UKfaculty, "average") # very close, but not identical, to density


# standard error of a mean: SD/root(n)
# No simple way to find a standard error of a network sampling distribution/standard error
# makes it hard to do hypothesis tests

# Is the transitivity of the data better or worse than we'd expect in a random graph
# Does something make these faculty "close" thier triangles?

# BOOTSTRAPPING
d1 = degree(UKfaculty)
t1 = numeric(1000) # vector with 1000 positions, all start as 0
t2 = numeric(1000)

# 10000 versions of a randomized Monte Carlo process
# basically randomizes the edges with same degree distribution
# What does a random graph with the same degree distribution look like?
# This gives us a null hypothesis
for(i in 1:1000){
  randnet = sample_degseq(d1)
  randnet = simplify(randnet)
  t1[i] = transitivity(randnet, "global")
  t2[i] = transitivity(randnet, "average")
}

mean(t1)
mean(t2)
sd(t1)
sd(t2)

# measure global transititivty of UK faculty
UK_global = transitivity(UKfaculty, "global")
z_uk_global = (UK_global - mean(t1)) / (sd(t1))
z_uk_global