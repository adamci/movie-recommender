# 	query.R
#
# These functions are used for querying the movie dataset. The functions to convert
# from movieId to movie name or genre are very simple lookups. The function to
# convert from movie name to movieId is much more complex, as it must deal with
# open-ended user input.
#

source("const.R")

# Open table
tbl <- read.csv(movies_path, as.is=TRUE)


# This function processes the inputted movie_title so that it greps for all movies
# in the dataset that contain all of the words in the movie_title string. If
# multiple results are returned, the user is asked to choose a movie among a list.
str_to_movieId <- function(movie_title) {
    # Create grep string from query string
    remove_alnum <- gsub("[^[:alnum:] ]", "", movie_title)
    split <- strsplit(remove_alnum, " +")[[1]]
    add_regex <- lapply(split, function(x) { return(paste("(?=.*",x,")",sep="")) })
    grep_string <- paste(add_regex, collapse="")

    # Run query on grep string
    search_results <- tbl[, ][grep(grep_string, tbl[["title"]], ignore.case=TRUE, perl=TRUE), ]

    # Further query based on user input
    cat("\n")
    row_num <- nrow(search_results)
    if (row_num == 0) {
        # Not found
        cat(paste("Could not find '", movie_title, "' in database\n", sep=""))
        return(-1)

    } else if (row_num == 1) {
        # Found single result
        return(search_results[[1]][1])

    } else if (row_num > 25) {
        # Found too many results to present nicely
        cat(paste("Too many returns for '", movie_title, "' in database\n", sep=""))
        cat("Try to refine your search query.\n")
        return(-1)

    } else {
        # Found may results and is now asking user to pick from list
        cat(paste("Multiple results were returned for you query '", movie_title, "'\n", sep=""))
        cat("Enter a number from 0 to", row_num,
            "to choose an option from the list\n")
        if (row_num > 9) {
            cat("", "[0] My movie isn't in this list\n")
        }
        else {
            cat("[0] My movie isn't in this list\n")
        }

        # Print movie options
        for (i in 1:nrow(search_results)) {
            selector <- paste("[", i, "] ", sep="")

            if (nrow(search_results) > 9 && i < 10) {
                selector <- cat("", selector)
            }

            line <- paste(selector, search_results[[2]][i], "\n", sep="")
            cat(line)
        }

        # Get optiion from user
        repeat {
            n <- readline()
            n <- as.integer(n)

            if (n < 0 || n > row_num) {
                cat("Integer out of range. Try again.\n")
            } else {
                break
            }
        }

        # Return selection
        if (n == 0) {
            cat("Could not find your movie\n")
            return(-1)
        } else {
            return(search_results[[1]][n])
        }
    }
}


movieId_to_str <- function(movieID) {
    subset <- subset(tbl, subset=(movieId == movieID))
    return(subset[["title"]])
}

movieId_to_genre <- function(movieID) {
    subset <- subset(tbl, subset=(movieId == movieID))
    return(subset[["genres"]])
}
