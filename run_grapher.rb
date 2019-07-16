require_relative 'app/grapher'

recipe_path = File.expand_path(File.join(File.dirname(__FILE__), "input-data","recipe-lister","recipe.json"))

frodo = Grayphr.new("Frodo", recipe_path)

puts "Gimme stuff to build: "
product = gets.chomp
puts "how many stuff tho?"
amount = gets.chomp.to_i

puts frodo.make_graph(product, amount)
