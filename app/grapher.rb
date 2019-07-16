require "json"
require "uri"
require "dotenv"


Product = Struct.new(:energy, :product_amount)

class Grayphr
    
    def initialize(name, recipe_path)
        @name = name
        @recipe_path = recipe_path
    end 

    def recipes
        @recipes ||= JSON.parse(File.read(@recipe_path)) 
    end

    def get_product(product_name)
        Product.new(recipes[product_name]["energy"], recipes[product_name]['products'].select{|p| p["name"] == product_name}[0]['amount'])
    end

    def get_ingredients(product_name, amount = 1)
        return nil if recipes[product_name].nil?
        ingredients = {}
        recipes[product_name]["ingredients"].each do |ingredient|
            ingredients[ingredient["name"]] = ingredient["amount"]*amount
        end
        return ingredients   
    end

    def get_ingreds_recursive(product_name, amount = 1, product_ingreds = {})
        # product_name to get_ingredients
        (get_ingredients(product_name, amount) || {}).each do |ingredient, amount|
            product_ingreds[ingredient] ||= {}
            product_ingreds[ingredient][product_name] ||= 0
            product_ingreds[ingredient][product_name] += amount
            get_ingreds_recursive(ingredient, amount, product_ingreds)
        end
        return product_ingreds
    end

    def make_graph(product_name, amount = 1)
        product_ingreds = get_ingreds_recursive(product_name, amount)
        labels = {product_name => "#{product_name} x #{amount}"}
        product_ingreds.each do |component, ingreds|
            labels[component] = "#{component} x #{ingreds.values.sum}"
        end
        inglist = ["digraph G {"]
        product_ingreds.each do |component, ingreds|
            ingreds.each do |product_name, amount|
                inglist.append "\"#{labels[component]}\" -> \"#{labels[product_name]}\"[label=\"#{amount}\"]"
            end
        end
        # puts "---MEOOOOooooOOOOOW I'm fat---"
        puts """    
         /\\**/\\
        ( o_o  )_)     Meow.
        ,(u  u  ,),
       {}{}{}{}{}{}
       """
        return "https://dreampuf.github.io/GraphvizOnline/#" + URI::encode(inglist.append("}").join("\n"))
    end
end
