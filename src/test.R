# 	test.R
#
# This file contains a test run on a portion of the user data from the original
# dataset. For a given test user, it splits the user's ratings into two groups.
# The first group is inputted in the recommender system. The outputted films from
# the system are then compared to the second group. Any overlap between the two
# groups is then reported as the output of the test. The test will only look at
# movies with above average ratings in the second group when counting overlap.
#

source("const.R")
source("knn.R")
source("filter.R")


# Input and output csv files for our five test users
user1_i <- read.csv("../test/user1_input.csv", as.is=TRUE, header=FALSE)
user1_o <- read.csv("../test/user1_output.csv", as.is=TRUE)
user2_i <- read.csv("../test/user2_input.csv", as.is=TRUE, header=FALSE)
user2_o <- read.csv("../test/user2_output.csv", as.is=TRUE)
user3_i <- read.csv("../test/user3_input.csv", as.is=TRUE, header=FALSE)
user3_o <- read.csv("../test/user3_output.csv", as.is=TRUE)
user4_i <- read.csv("../test/user4_input.csv", as.is=TRUE, header=FALSE)
user4_o <- read.csv("../test/user4_output.csv", as.is=TRUE)
user5_i <- read.csv("../test/user5_input.csv", as.is=TRUE, header=FALSE)
user5_o <- read.csv("../test/user5_output.csv", as.is=TRUE)


# Function to run when running this test
evaluate <- function() {
    test(user1_i, user1_o, "TEST 1")
    test(user2_i, user2_o, "TEST 2")
    test(user3_i, user3_o, "TEST 3")
    test(user4_i, user4_o, "TEST 4")
    test(user5_i, user5_o, "TEST 5")
}


# Function that runs the recommender system pipeline to see if output
# in any way matches the expected output
test <- function(input, output, test_name) {
    cat(paste("\n\nRunning ", test_name, "\n", sep=""))

    # Produce list of recommendations
    k_list <- knn(input, TRUE)
    ret <- combine_users_favorites(k_list, input, TRUE)
    recs <- ret[[1]]

    if (length(recs) > nrecs) {
        length(recs) <- nrecs
    }

    # Get average score
    ratings_tbl <- read.csv(ratings_test_path, as.is=TRUE)
    average_score <- mean(ratings_tbl[["rating"]])

    # Check if recommendations for user correspond to film that user also likes
    overlap <- 0
    for (i in 1:length(recs)) {
        movieID <- recs[[i]][4]
        row <- subset(output, subset=(movieId == movieID))

        if (nrow(row) == 1) {
            if (row[["rating"]][1] > average_score) {
                overlap <- overlap + 1
            }
        }
    }

    # Print output of test
    cat(paste(test_name, " returned with an overlap of ", overlap, "\n", sep=""))
}
