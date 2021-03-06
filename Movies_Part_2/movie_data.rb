require "./movie_test.rb"

class MovieData

    def initialize(*args)
        if args.length == 1
            path = args[0].to_s + "/u.data"
            in_file = File.open(path, "r")
            @data = in_file.read
            in_file.close
        elsif args.length == 2
            path = args[0].to_s + "/" + args[1].to_s + ".base"
            path2 = args[0].to_s + "/" + args[1].to_s + ".test"
            in_file = File.open(path, "r")
            in_file2 = File.open(path2, "r")
            @data = in_file.read
            @test_data = in_file2.read
            in_file.close
            in_file2.close
        end
        
        @user_movie_rate = Hash.new()
        @movie_user_rate = Hash.new()
    end
    
    #this will read in the data from the original ml-100k files and stores them in whichever 
    #way it needs to be stored
    def load_data()
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
        hashtable = hashtable.sort_by {|_id, ppl| ppl}.reverse
        (0...hashtable.length).each do |i|
            id, _pup = hashtable[i]
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
            user2_table.each do |id, _rate|
                if user1_table.include?(id)
                    gap = (user1_table[id].to_i - user2_table[id].to_i).abs
                    similarity += 4 - gap
                end
            end
        else
            user1_table.each do |id, _rate|
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
        @user_movie_rate.each do |u, _movie_rate_hash|
            if u.to_i != user.to_i
                sml = similarity(user, u)
                candidates[u] = sml
            end
        end
        candidates = candidates.sort_by {|_user_id, sml| sml}.reverse
        best_candidate, _similarity = candidates[0]
        return best_candidate
    end
    
    #returns the rating that user u gave movie m in the training set, and 0 if user u did not rate movie m
    def rating(user, movie)
        user_table = @user_movie_rate[user]
        if user_table.has_key?(movie)
            return user_table[movie]
        else
            return 0
        end
    end
    
    #returns a floating point number between 1.0 and 5.0 as an estimate of what user u would rate movie m
    def predict(user, _movie)
        sum = 0.0
        number = 0.0
        user_table = @user_movie_rate[user]
        user_table.each do |_m, r|
            sum += r.to_f
            number += 1
        end
        estimate = sum / number
        return estimate.round(2)
    end
    
    #returns the array of movies that user u has watched
    def movies(user)
        movie_list = Array.new
        user_table = @user_movie_rate[user]
        user_table.each do |m, _r|
            movie_list.push(m)
        end
        return movie_list
    end
    
    # returns the array of users that have seen movie m
    def viewers(movie)
        user_list = Array.new()
        movie_table = @movie_user_rate[movie]
        movie_table.each do |u, _r|
            user_list << u
        end
        return user_list
    end
    
    #runs the z.predict method on the first k ratings in the test set and returns a MovieTest object containing the results. 
    def run_test(k=20000)
        z = MovieTest.new()
        index = 0
        @test_data.each_line do |line|
            parts = line.split
            z.results.push([parts[0], parts[1], parts[2], predict(parts[0], parts[1])])
            index += 1
            if index >= k
                break
            end
        end
        return z
    end
    

end


process = MovieData.new("ml-100k", :u1)
process.load_data()
z = process.run_test(10000)
puts z.to_a()






