require_relative('../db/sql_runner')

class Film
  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @title = options['title']
    @price = options['price'].to_f.round(2)
    @id = options['id'].to_i if options ['id']
    @deleted = options['deleted']
  end

  def save()
    sql = " INSERT INTO films
    (
      title,
      price
    )
      VALUES 
    (
      '#{@title}',
      #{@price}
    )
      RETURNING id;"
    @id = SqlRunner.run(sql)[0]["id"].to_i
  end

  def update_title()
    sql = "UPDATE films SET
    (
      title
    ) =
    (
      '#{@title}'
    )
    WHERE id = #{id};"
    SqlRunner.run(sql)
  end

  def update_price()
    sql = "UPDATE films SET
    (
      price
    ) = 
    (
      #{@price}
    )
    WHERE id = #{id}"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "UPDATE films SET deleted = TRUE WHERE id = #{id}"
    SqlRunner.run(sql)
  end

  def Film.all()
    sql = "SELECT * FROM films"
    films_hash = SqlRunner.run(sql)
    return films_hash.map {|film| Film.new(film)}
  end

  def Film.all_current
    sql = "SELECT * FROM films WHERE deleted = FALSE"
    films_hash = SqlRunner.run(sql)
    return films_hash.map {|film| Film.new(film)}
  end

  def Film.delete_all_console()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def Film.delete_all()
    sql = "UPDATE films SET deleted = TRUE"
    SqlRunner.run(sql)
  end

end