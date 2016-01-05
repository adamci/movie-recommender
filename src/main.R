# 	main.R
#
# This function is the main user interface for the recommender system and is
# the script that the user will call when running the system. It takes a path
# to a csv file of movie names and scores. Otherwise, it uses the demo default.
#

source("const.R")
source("query.R")
source("knn.R")
source("filter.R")



main <- function(input = default_input) {
    # Read user data
    user_data <- read.csv(input, header=FALSE, as.is=TRUE)

    # Convert movie names into movieIds
    for (i in 1:nrow(user_data)) {
        id <- str_to_movieId(user_data[[1]][i])

        if (id == -1) {
            cat("Please update your movie csv to complete the recommendation.\n")
            return("\n")
        }

        user_data[[1]][i] = id
    }

    # Get list of k closest users
    k_list <- knn(user_data)

    # Acquire list of recommendations
    favorites <- combine_users_favorites(k_list, user_data)

    # Filter by genre
    ret <- filter_by_genre(favorites)
    recs <- ret[[1]]
    genre <- ret[[2]]

    if (length(recs) > nrecs) {
        rec_num <- nrecs
    } else {
        rec_num <- length(recs)
    }

    # Present recommendations
    cat("\n\nUsing your personal ratings, we found", k, "users that are most like",
        "you\nand present you with a list of their", rec_num)
    if (is.na(genre)) {
        cat(" favorite movies,\nsorted by their scores and how closely your",
            "interests line up:\n")
    } else {
        cat(" favorite", genre, "movies,\nsorted by their scores and how closely",
            "your interests line up:\n")
    }


    for (i in 1:rec_num) {
        cat("\t~ ")
        cat(recs[[i]][2])
        cat("\n")
    }
}
