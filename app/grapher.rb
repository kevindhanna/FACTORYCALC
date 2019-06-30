require "json"
require "uri"

recipepath = File.join("..","input-data","recipe-lister","recipe.json")
recipiefile = File.read(recipepath)
RECIPES = JSON.parse(recipiefile)

def get_ingredients(product, amount = 1)
    return nil if RECIPES[product].nil?
    ingredients = {}
    RECIPES[product]["ingredients"].each do |ingredient|
        ingredients[ingredient["name"]] = ingredient["amount"]*amount
    end
    return ingredients   
end

def get_ingreds_recursive(product, amount = 1, product_ingreds = {})
    # product to get_ingredients
    (get_ingredients(product, amount) || {}).each do |ingredient, amount|
        product_ingreds[ingredient] ||= {}
        product_ingreds[ingredient][product] ||= 0
        product_ingreds[ingredient][product] += amount
        get_ingreds_recursive(ingredient, amount, product_ingreds)
    end
    return product_ingreds
end

def graph_maker(product, amount = 1)
    product_ingreds = get_ingreds_recursive(product, amount)
    labels = {product => "#{product} x #{amount}"}
    product_ingreds.each do |component, ingreds|
        labels[component] = "#{component} x #{ingreds.values.sum}"
    end
    inglist = ["digraph G {"]
    product_ingreds.each do |component, ingreds|
        ingreds.each do |product, amount|
            inglist.append "\"#{labels[component]}\" -> \"#{labels[product]}\"[label=\"#{amount}\"]"
        end
    end
    return "https://dreampuf.github.io/GraphvizOnline/#" + URI::encode(inglist.append("}").join("\n"))
end


product = gets.chomp
amount = gets.chomp.to_i
puts graph_maker(product, amount)