rm(list = ls())

# Set working dir
setwd("~/social_networks")

# Entering a constant
a = 5

# Entering a vector
b = c(18,19,18, 20, 18, 20, 19)

# Entering a Matrix
# enters all the values, then the number of columns by row. So first 3 go in row 1, 2nd 3 go in row 2...
scores = matrix(c(540, 620, 680, 710, 720, 510, 640, 760, 750, 480, 210, 570), ncol=3, byrow=TRUE)

# Declare names for the students
student_names = c("Jo", "Lee", "Ramon", "Jess")

# create a dataframe based on the matrix
scores = as.data.frame(scores)

#Add student names to the data frame
scores = cbind(student_names, scores)

#Add descriptions to the columns
names(scores) <- c("Student", "SATV", "SATM", "SATW")

#Add one more student to the dataframe
ncol(scores)
scores[5,1] <- "Cris"
scores[5,2:4] <- c(710, 720, 690)

#Remove one student from the dataframe
scores <- rbind(scores[1:2,], scores[4:5,])

#Change one value in the dataframe
scores[3,2] <- 730
#View one variable from the data frame
print(scores[,2])
print(scores$SATV)
#View one row of data
print(scores[1,])
# View one col of data
print(scores[,1])

#Find sums
sum(scores[,2])
sum(scores$SATV)
# sum(scores[1,]) errors because summing the text
sum(scores[1,2:4])

#Find Means
mean(scores[,3])
mean(scores$SATM)
colMeans(scores[,2:4])
rowMeans(scores[1,2:4])
rowMeans(scores[,2:4])

# Find Standard Deviations
# SD of all values in column 2 (SATV scores across all students)
sd(scores[,2])
# SD of SATV column using $ notation (same result as above, different syntax)
sd(scores$SATV)
# SD of all numeric values in row 1 (spread of scores for student 1)
sd(as.numeric(scores[1,]))
# SD of columns 2 through 4 in row 1 (spread of SAT/GPA scores for student 1)
sd(as.numeric(scores[1, 2:4]))

# Find Column Standard Deviations
# SD of all values in column 3 (SATM scores across all students)
sd(scores[,3])
# SD of SATM column using $ notation
sd(scores$SATM)
# SD for each column (2 through 4) across all students — returns a named vector
sapply(scores[, 2:4], sd)
# SD across columns 2-4 for row 1 only (same as sd of row above)
sd(as.numeric(scores[1, 2:4]))
# SD across columns 2-4 for EVERY row — returns one SD value per student
apply(scores[, 2:4], 1, sd)

# DO OURSELF
# Create a vector of surfer names
# • Create a matrix giving their score for four waves (1-10)
# • Combine the vector and the matrix into a dataframe
# • Add two more surfers with scores
# • Remove the second surfer
# • Change one score for one surfer
# • Find the mean score for each wave
# • Find the mean score for each surfer
# • Add an additional column with the mean score for each surfer and give
# it a name
# • Add a column with the minimum score for each surfer and another
# column with the maximum score for each surfer and give these columns
# names
# • Allow each surfer to drop their worst score and then get the average of
# the remaining scores and add it as a named column

