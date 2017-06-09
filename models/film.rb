require_relative('../db/sql_runner')

class Film
  attr_reader :id, :price

  def initialize(options)
    @title = options['title']
    @price = options['price'].to_f.round(2)
    @id = options['id'].to_i if options ['id']
  end

end