require_relative('../db/sql_runner')

class Customer
  attr_reader :id, :deleted
  attr_accessor :name, :funds

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
      RETURNING id;"
    @id = SqlRunner.run(sql)[0]["id"].to_i
  end

  def update_name()
    sql = "UPDATE customers SET
    (
      name
    ) =
    (
      '#{@name}'
    )
    WHERE id = #{id};"
    SqlRunner.run(sql)
  end

  def update_funds()
    sql = "UPDATE customers SET
    (
      funds
    ) = 
    (
      #{@funds}
    )
    WHERE id = #{id}"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "UPDATE customers SET deleted = TRUE WHERE id = #{id}"
    SqlRunner.run(sql)
  end

  def Customer.all()
    sql = "SELECT * FROM customers"
    customer_hash = SqlRunner.run(sql)
    return customer_hash.map {|customer| Customer.new(customer)}
  end

  def Customer.all_current
    sql = "SELECT * FROM customers WHERE deleted = FALSE"
    customer_hash = SqlRunner.run(sql)
    return customer_hash.map {|customer| Customer.new(customer)}
  end

  def Customer.delete_all_console()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def Customer.delete_all()
    sql = "UPDATE customers SET deleted = TRUE"
    SqlRunner.run(sql)
  end

end