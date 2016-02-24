class Scrape
  attr_accessor :title, :hotness, :image_url, :rating, :director,
  :genre, :runtime, :synopsis, :failure

  def scrape_new_movie
    begin
      doc = Nokogiri::HTML(open("http://www.rottentomatoes.com/m/the_martian/"))
      doc.css('script').remove 
      self.title = doc.at("//h1[@itemprop = 'name']").text  
      self.hotness = doc.at("//span[@itemprop = 'ratingValue']").text.to_i 
      self.image_url = doc.at_css('#movie-image-section img')['src'] 
      self.rating = doc.at("//td[@itemprop = 'contentRating']").text 
      self.director = doc.at("//td[@itemprop = 'director']").css('a').first.text 
      self.genre = doc.at("//span[@itemprop = 'genre']").text 
      self.runtime = doc.at("//time[@itemprop = 'duration']").text 
      self.synopsis = doc.css('#movieSynopsis').text
      s = doc.css('#movieSynopsis').text
      if ! s.valid_encoding?
        s = s.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
      end
      self.synopsis = s
      return true
    rescue Exception => e
      self.failure = "Something went wrong with the scrape"
    end
  end

  def save_movie
    movie = Movie.new(
      title: self.title,
      hotness: self.hotness,
      image_url: self.image_url,
      synopsis: self.synopsis,
      rating: self.rating,
      genre: self.genre,
      director: self.director,
      runtime: self.runtime
      )
    movie.save
  end
end