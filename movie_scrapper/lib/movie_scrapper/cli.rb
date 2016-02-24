class MovieScrapper::CLI

  def call
    list_movies
  end

  def list_movies
    puts "List of Movies"
    MovieScrapper::Movie.all
  end

end


