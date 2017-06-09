require_relative('../db/SqlRunner')

class Film
  attr_reader id:

  def initialize(options)
    @title = options['title']
    @price = options['price'].to_i
    @id = options['id'].to_i
  end

end