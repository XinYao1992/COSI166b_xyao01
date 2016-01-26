In 'movie_data.rb', I have a class called 'MovieData'. 

def initialize():
    @data: it stores the data from u.data
    @user_movie_rate: it is a hash table, key is user id, and value is other hash table which stores movie id and corresponding rating.
    @movie_user_rate: it is like "@user_movie_rate". THe key of this hash table is movie id, and value is other hash table which stores user id and corresponding rating.

def load_data():
    In this method, I built three data structure: "@data", "@user_movie_rate", "@movie_user_rate" that I mentioned above, which will be used in other methods inside this class.

def popularity(movie_id):
    This method will calculate how many times this specific movie has been watched by people, and return the value that the movie has appeared in the database.

def popularity_list():
    '@movie_user_rate' is used in this method. I traversed '@movie_user_rate', and stored movie id with its frequency into an array called 'hashtable'. Then sorted this array, and reversed it. This method will return an array which stores all movie id on decreasing order.

def similarity(user1,user2):
    '@user_movie_rate' is used in this method. We can directly get the hash table of user1 and user2 that stores every movie id and its rating from that person, then compare their hash table to see if they have watched same movies. For all the movies they commonly watched, compare their rating for each and calculate in this way: if they got the same rating, similarity for that movie will be 4; if one got 4, the other got 3, similarity for that will be 3; and if one got 5, the other got 1, then similarity for that would be 0.

def most_similar(user):
    '@user_movie_rate' is used in this method. I built a new hash table called 'candidates', which stores user id (except for argument 'user') with corresponding similarity. Then, sort the 'candidates', and return the user id of the first one.

Discussion:
1. Describe an algorithm to predict the ranking that a user U would give to a movie M assuming the user hasn’t already ranked the movie in the dataset.
Answer: we can predict user's action by analysizing his/her previous taste, which needs to do some statistics. For example, if movie M is classified into 'dracula movie', the assuming can be calculated by his/her previous average rating for that.
    
    
2. Does your algorithms scale? What factors determine the execution time of your “most_similar” and “popularity_list” algorithms.
Answer: To reduce the runtime, I used hash table structure for both "most_similar" and "popularity_list".
