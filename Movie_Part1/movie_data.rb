class MovieData

    def initialize()
        @data
        @user_movie_rate = Hash.new()
        @movie_user_rate = Hash.new()
    end
    
    #this will read in the data from the original ml-100k files and stores them in whichever 
    #way it needs to be stored
    def load_data()
        in_file = open('u.data')
        @data = in_file.read
        @data.each_line do |line|
            nums = line.split
            if @user_movie_rate.include?(nums[0])
                @user_movie_rate[nums[0]][nums[1]] = nums[2]
            else
                @user_movie_rate[nums[0]] = Hash.new()
                @user_movie_rate[nums[0]][nums[1]] = nums[2]
            end
            
            if @movie_user_rate.include?(nums[1])
                @movie_user_rate[nums[1]][nums[0]] = nums[2]
            else
                @movie_user_rate[nums[1]] = Hash.new()
                @movie_user_rate[nums[1]][nums[0]] = nums[2]
            end
        end
        in_file.close
    end
    
    #this will return a number that indicates the popularity (higher numbers are more popular). 
    #You should be prepared to explain the reasoning behind your definition of popularity
    def popularity(movie_id)
        pplrt = 0
        @data.each_line do |line|
            nums = line.split
            if nums[1].to_i == movie_id.to_i
                pplrt += 1
            end
        end
        return pplrt
    end
    
    #this will generate a list of all movie_id’s ordered by decreasing popularity
    def popularity_list()
        hashtable = []
        list = []
        @movie_user_rate.each do |m, user_rate|
            ppl = user_rate.length
            if ppl != 0
                hashtable.push([m, ppl])
            end
        end
        hashtable = hashtable.sort_by {|id, ppl| ppl}.reverse
        (0...hashtable.length).each do |i|
            id, pup = hashtable[i]
            list.push(id)
        end
        return list
    end
    
    #this will generate a number which indicates the similarity in movie preference 
    #between user1 and user2 (where higher numbers indicate greater similarity) 
    def similarity(user1,user2)
        similarity = 0#higher numbers indicate greater similarity
        user1_table = @user_movie_rate[user1]#key: movie id; value: rating
        user2_table = @user_movie_rate[user2]#key: movie id; value: rating 
        
        if user1_table.length > user2_table.length
            user2_table.each do |id, rate|
                if user1_table.include?(id)
                    gap = (user1_table[id].to_i - user2_table[id].to_i).abs
                    similarity += 4 - gap
                end
            end
        else
            user1_table.each do |id, rate|
                if user2_table.include?(id)
                    gap = (user1_table[id].to_i - user2_table[id].to_i).abs
                    similarity += 4 - gap
                end
            end
        end
        
        return similarity
    end
    
    #this return a list of users whose tastes are most similar to the tastes of user u
    def most_similar(user)
        candidates = Hash.new()#this array stores the list of user with the similarity to the comparer. key:user id; value:similarity.
        @user_movie_rate.each do |u, movie_rate_hash|
            if u.to_i != user.to_i
                sml = similarity(user, u)
                candidates[u] = sml
            end
        end
        candidates = candidates.sort_by {|user_id, sml| sml}.reverse
        best_candidate, similarity = candidates[0]
        return best_candidate
    end
    
end#end of 'MovieData' class


process_movie = MovieData.new()
process_movie.load_data()

# first ten elements of popularity list
list = process_movie.popularity_list()
(0..9).each do |i|
    puts list[i]
end

# last ten elements of popularity list
(-10..-1).each do |i|
    puts list[i]
end

# most_similar(1)
puts process_movie.most_similar("1")














