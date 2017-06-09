require_relative('../db/SqlRunner')

class Customer
  attr_reader id:

  def initialize (options)
    @name = options['name']
    @funds = options['funds'].to_i
    @id = options['id'].to_i
  end

end