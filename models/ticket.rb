require_relative('../db/sql_runner')
require_relative('film')
require_relative('ticket')

class Ticket
  attr_reader :id, :film_id, :customer_id

  def initialize (options)
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @id = options['id'].to_i if options ['id']
  end
  
end