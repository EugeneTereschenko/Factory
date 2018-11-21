require "./factory.rb"


Car = Factory.new(:brand, :model, :year)

kia = Car.new("Kia", "Cerato", "2014")
bmw = Car.new("BMW", "X3", "2015")
toyota = Car.new("Toyota", "Corolla", "2017")

puts kia.brand
puts bmw.year
puts kia["brand"]
puts kia[2]
puts kia.length
puts kia.dig

puts ([5, 10, 20]).reduce{0} { |sum, num| sum + num }
