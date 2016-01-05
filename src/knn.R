# 	knn.R
#
# The following function will implement a simple version of the k-nearest
# neighbors algorithm. It takes a table of movieId values and scores from
# users in the dataset and outputs a list of the k closest users, where distance
# is really only measured against movies that both the user of the program and
# the dataset users have both seen. There is also a bonus for the number of films
# both users have seen and a small penalty for those users who have distance 0.
#


source("const.R")



knn <- function(user_data, test=FALSE) {
    if (test) {
        path <- ratings_test_path
    } else {
        path <- ratings_path
    }

    ratings_tbl <- read.csv(path, as.is=TRUE)
    k_list <- list()

    # Initialize parameters for knn
    distance <- .Machine$integer.max
    current_user <- 0
    number_matches <- 0
    progress_bar_count <- nrow(ratings_tbl)/10

    cat("\nPerforming collaborative filtering")

    # Iterate over all the ratings of all the dataset users, keeping track of the
    # current user in order to calculate a distance
    for (i in 1:nrow(ratings_tbl)) {
        if (ratings_tbl[[1]][i] != current_user) {
            if (number_matches != 0) {
                # Penalize artificially good matches by epsilon amount
                if (distance == 0) {
                    distance <- epsilon
                }

                # Scale the distance as a function of the number of matches found
                distance <- sqrt(distance) / (number_matches**match_factor)

                # Insert data into bounded data structure
                datapoint <- c(current_user, distance)
                k_list <- k_insert(k_list, datapoint, k)
            }

            # Set up parameters for next user
            current_user <- ratings_tbl[[1]][i]
            distance <- 0
            number_matches <- 0
        }

        # If it's a movie the user has seen, update the net distance
        user_row <- subset(user_data, subset=(V1 == ratings_tbl[[2]][i]))
        if (nrow(user_row) != 0) {
            delta <- (ratings_tbl[[3]][i] - user_row[[2]][1])**2
            number_matches <- number_matches + 1

            distance <- distance + delta
        }

        # Update progress bar
        if (i > progress_bar_count) {
            cat(".")
            progress_bar_count <- progress_bar_count + nrow(ratings_tbl)/10
        }
    }

    # Print new line after progress bar
    cat("\n")

    return(k_list)
}



# This function allows me to insert a vector into a list where the vectors
# are sorted by the second elements and where there is a cap of k on the length
# of the vector.
k_insert <- function(k_list, item, k) {
    if (length(k_list) == 0) {
        return(list(item))
    }

    # Insert in the middle of the list
    for (i in 1:length(k_list)) {
        if (item[2] < k_list[[i]][2]) {
            k_list <- append(k_list, list(item), i-1)

            if (length(k_list) > k) {
                k_list <- k_list[1:(length(k_list)-1)]
            }

            return(k_list)
        }
    }

    # Insert at the end of the list
    if (length(k_list) + 1 < k) {
        k_list <- append(k_list, list(item))
    }

    return(k_list)
}
