
class MovieTest

    def initialize()
        @results = []
    end
    
    attr_accessor :results

    #returns the average predication error (which should be close to zero)
    def mean()
        error_sum = 0
        @results.each do |array|
            error_sum += (array[2].to_i - array[3].to_i).abs
        end
        mean = error_sum / @results.length
        return mean
    end
    
    #returns the standard deviation of the error
    #Math.sqrt()
    def stddev()
        gap = 0.0
        mean_error = mean()
        @results.each do |array|
            gap += ((array[2].to_i - array[3].to_i).abs - mean_error) ** 2
        end
        sd = Math.sqrt(gap / @results.length)
        return sd.round(2)
    end 
    
    #returns the root mean square error of the prediction
    def rms()
        return stddev() ** 2
    end
    
    #returns an array of the predictions in the form [u,m,r,p].
    def to_a()
        return @results
    end
    

end
