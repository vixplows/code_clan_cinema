require_relative('../db/sql_runner')

class Customer
  attr_reader :id, :funds

  def initialize (options)
    @name = options['name']
    @funds = options['funds'].to_f.round(2)
    @id = options['id'].to_i if options ['id']
  end

  def save
    sql = "INSERT INTO customers (name, funds) VALUES (#{@name}, #{@funds}) RETURNING id"
    customer = SqlRunner.run(sql).first
    @id = customer['id'].to_i
  end

end