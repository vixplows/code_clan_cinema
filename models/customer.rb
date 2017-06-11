require_relative('../db/sql_runner')

class Customer
  attr_reader :id
  attr_accessor :name, :funds, :deleted

  def initialize (options)
    @name = options['name']
    @funds = options['funds'].to_f.round(2)
    @id = options['id'].to_i if options ['id']
    @deleted = options['deleted']
  end

  def save()
    sql = " INSERT INTO customers
    (
      name,
      funds
    )
      VALUES 
    (
      '#{@name}',
      #{@funds}
    )
      RETURNING id, deleted"
    result = SqlRunner.run(sql)
    @id = result[0]["id"].to_i
    @deleted = result[0]["deleted"]
  end

  def update()
    sql = "UPDATE customers SET
      (
        name,
        funds,
        deleted
      ) =
      (
        '#{@name}',
        #{@funds},
        '#{@deleted}'
      )
        WHERE id = #{@id}"
      SqlRunner.run(sql)
  end

  def delete()
    sql = "UPDATE customers SET deleted = TRUE 
      WHERE id = #{@id}
      RETURNING deleted"
    result = SqlRunner.run(sql)
    @deleted = result[0]["deleted"]
  end

# select all films a customer has booked to see:
  def films()
    sql = "SELECT films.* FROM films
          INNER JOIN tickets ON tickets.film_id = films.id
          WHERE customer_id = #{@id}"
    return Film.map_items(sql)
  end

# need to be called on tickets, otherwise how know which ticket to deduct from customer if booked more than once??
  def deduct_funds()
    sql = "SELECT films.price, customers.funds FROM films
        INNER JOIN tickets ON tickets.film_id = films.id
        INNER JOIN customers ON customers.id = tickets.customer_id
        WHERE tickets.customer_id = #{@id}"
    results_hash = SqlRunner.run(sql)[0]
    sql = "UPDATE customers SET funds = #{results_hash['funds'].to_i - results_hash['price'].to_i} WHERE id = #{@id}"
    SqlRunner.run(sql)
  end

  def tickets()
    sql = "SELECT tickets.* FROM tickets WHERE customer_id = #{@id}"
    tickets_array = Ticket.map_items(sql)
    tickets_array.length
  end

  def Customer.all()
    sql = "SELECT * FROM customers"
    return Customer.map_items(sql)
  end

  def Customer.all_undeleted
    sql = "SELECT * FROM customers WHERE deleted = FALSE"
    return Customer.map_items(sql)
  end

  def Customer.delete_all_console()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

# ??? on calling Customer.all and Customer.all_undeleted shows deleted = t, but calling customer.1 deleted = f ???
  def Customer.delete_all
    sql = "UPDATE customers SET deleted = TRUE"
    SqlRunner.run(sql)
  end

  def Customer.map_items(sql)
    customers_hash = SqlRunner.run(sql)
    return customers_hash.map { |customer| Customer.new(customer)}
  end

end