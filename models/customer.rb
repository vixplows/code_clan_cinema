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

# ??? as per delete.all, on calling Customer.all and Customer.all_undeleted shows deleted = t, but calling customer.1 deleted = f ???
  def delete()
    sql = "UPDATE customers SET deleted = TRUE WHERE id = #{@id}"
    SqlRunner.run(sql)
  end

# select all films a customer has booked to see:
  def films()
    sql = "SELECT films.* from films
          INNER JOIN tickets ON tickets.film_id = films.id
          WHERE customer_id = #{@id}"
    return Film.map_items(sql)
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