require_relative('../db/SqlRunner')
require_relative('film')
require_relative('ticket')

class Ticket
  attr_reader id:

  def initialize (options)
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @id = options['id'].to_i
  end
  
end