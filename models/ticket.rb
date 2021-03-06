require_relative('../db/sql_runner')
require_relative('film')
require_relative('ticket')

class Ticket
  attr_reader :id
  attr_accessor :film_id, :customer_id

  def initialize (options)
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @id = options['id'].to_i if options ['id']
    @deleted = options['deleted']
  end
  
  def save()
    sql = "INSERT INTO tickets
    (
      customer_id,
      film_id
    ) VALUES
    (
      #{@customer_id},
      #{@film_id}
    )
      RETURNING id, deleted"
    result = SqlRunner.run(sql)
    @id = result[0]["id"].to_i
    @deleted = result[0]["deleted"]
  end

  def update()
    sql = "UPDATE tickets SET
    (
      customer_id,
      film_id,
      deleted
    ) =
    (
      #{@customer_id},
      #{@film_id},
      '#{@deleted}'
    )
      WHERE id = #{id}"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "UPDATE tickets SET deleted = TRUE
        WHERE id = #{@id}
        RETURNING deleted"
    result = SqlRunner.run(sql)
    @deleted = result[0]["deleted"]
  end

  def film()
    sql = "SELECT * FROM films WHERE id = #{@film_id}"
    return Film.map_items(sql)
  end

  def customer()
    sql = "SELECT * FROM customers WHERE id = #{@customer_id}"
    return Customer.map_items(sql)
  end

  def Ticket.all()
    sql = "SELECT * FROM tickets"
    return Ticket.map_items(sql)
  end

  def Ticket.all_undeleted()
    sql = "SELECT * FROM tickets WHERE deleted = FALSE"
   return Ticket.map_items(sql)
  end

  def Ticket.delete_all_console()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

#same issue as with self.delete_all method in film and customer.
  def Ticket.delete_all()
    sql = "UPDATE tickets SET deleted = TRUE"
    SqlRunner.run(sql)
  end

  def Ticket.map_items(sql)
    tickets_hash = SqlRunner.run(sql)
    return tickets_hash.map {|ticket| Ticket.new(ticket)}
  end

end