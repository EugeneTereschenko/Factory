require './factory.rb'

# frozen_string_literal: true

Car = Factory.new(:brand, :model, :year)

kia = Car.new('Kia', 'Cerato', '2014')
bmw = Car.new('BMW', 'X3', '2015')

puts kia.brand
puts bmw.year
puts kia['brand']
puts kia[2]
puts kia.length
puts kia.dig
