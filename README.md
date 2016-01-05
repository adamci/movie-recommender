Movie Recommender
=================

Introduction
------------
The following is my final project for a class I took in the fall of 2015 called
CPSC 458: Automated Decision Systems.

I wanted to use this final project as an opportunity to learn about how
recommender systems work. To this end, I implmented a collaborative filtering
system that recommends films based on drawing associations between users of
similar tastes using a varation of the k-nearest neighbors algorithm. As input,
the system takes a csv file that lists a couple of films that the user has seen
paired with their rating of that film on a scale from 0 to 5.0 (see sample
input files in demo/).

I used the MovieLens dataset, compiled by GroupLens research through their movie
recommendations website, http://movielens.org. Their most updated datasets come
in two sizes, the smaller of which is included in my project folder under
datasets/ml-latest-small. My project and demo runs on the smaller dataset, but
with enough patience, the larger one works as well. The MovieLens dataset was
most useful for building the collaborative filtering system as I had a wealth of
data on user ratings, which gives me better confidence in my ability to match
the input user with a set of k dataset users.

As an additional exercise at the end of my project, I attempted to construct
an evaluation function for my recommendation system.

Usage
-----
1. cd into the repository before running R
2. Run 'source("main.R")'
3. Run the main() function, either with an argument, which should be a path
   to your csv file of preferences, or no argument, which runs the demo


Demo Run
--------
	> source("main.R")
	> main()



	Multiple results were returned for you query 'Elf'
	Enter a number from 0 to 7 to choose an option from the list
	[0] My movie isn't in this list
	[1] Twelfth Night (1996)
	[2] Me Myself I (2000)
	[3] Me, Myself & Irene (2000)
	[4] Elf (2003)
	[5] Wilbur Wants to Kill Himself (2002)
	[6] Bill Cosby, Himself (1983)
	[7] Life Itself (2014)
	4



	Multiple results were returned for you query 'About Time'
	Enter a number from 0 to 3 to choose an option from the list
	[0] My movie isn't in this list
	[1] Amityville 1992: It's About Time (1992)
	[2] Frequently Asked Questions About Time Travel (2009)
	[3] About Time (2013)
	3



	Multiple results were returned for you query 'Rent'
	Enter a number from 0 to 15 to choose an option from the list
	 [0] My movie isn't in this list
	 [1] Rent-a-Kid (1995)
	 [2] Parent Trap, The (1961)
	 [3] Parent Trap, The (1998)
	 [4] Monty Python's And Now for Something Completely Different (1971)
	 [5] Different for Girls (1996)
	 [6] Parenthood (1989)
	 [7] Blood Spattered Bride, The (La novia ensangrentada) (1972)
	 [8] Rent-A-Cop (1988)
	 [9] Meet the Parents (2000)
	[10] Summer Rental (1985)
	[11] Parents (1989)
	[12] Undercurrent (1946)
	[13] Rent (2005)
	[14] Sorcerer's Apprentice, The (2010)
	[15] Inherent Vice (2014)
	13



	Performing collaborative filtering..........
	Selecting from similar user's favorites..........
	Do you want to filter your results by genre? [y/n]
	y

	Pick a genre by selecting a number from 1 to 19:
	 [1] Action
	 [2] Adventure
	 [3] Animation
	 [4] Children
	 [5] Comedy
	 [6] Crime
	 [7] Documentary
	 [8] Drama
	 [9] Fantasy
	[10] Film-Noir
	[11] Horror
	[12] IMAX
	[13] Musical
	[14] Mystery
	[15] Romance
	[16] Sci-Fi
	[17] Thriller
	[18] War
	[19] Western
	5


	Using your personal ratings, we found 10 users that are most like you
	and present you with a list of their 10 favorite Comedy movies,
	sorted by their scores and how closely your interests line up:
		~ Stranger than Fiction (2006)
		~ Hangover, The (2009)
		~ Kung Fury (2015)
		~ Inside Out (2015)
		~ Rushmore (1998)
		~ Royal Tenenbaums, The (2001)
		~ My Night At Maud's (Ma Nuit Chez Maud) (1969)
		~ Pulp Fiction (1994)
		~ Great Dictator, The (1940)
		~ Life Is Beautiful (La Vita è bella) (1997)

Implementation
--------------
My project is divided into four folders
* datasets/ contains two copies of the smaller MovieLens dataset, one for
  running normally, and one for my test() function. Within the ml-latest-small,
  I use two files. movies.csv contains a list of movies with a corresponding
  unique movieId, and genre. ratings.csv contains the ratings of 718 users of
  the MovieLens website
* src/ contains all the source code for the project, which is divided up among
  six scripts. The entry points are main.R and test.R
* demo/ contains some sample input files for the program, the first of which is
  used as the default program input for my recommender system
* test/ contains test input and output for my evaluation function
