require_relative('../models/customer')
require_relative('../models/film')
require_relative('../models/ticket')

require('pry-byebug')

Customer.delete_all_console
Film.delete_all_console

customer1 = Customer.new({'name' => 'Finn Porter', 'funds' => 20})
customer1.save()

customer2 = Customer.new({'name' => 'Sarah Johnson', 'funds' => 15})
customer2.save()

film1 = Film.new({'title' => 'Withnail and I', 'price' => 9})
film1.save()

film2 = Film.new({'title' => 'Love Actually', 'price' => 7})
film2.save






binding.pry
nil