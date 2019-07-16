require 'test/unit'
require 'grapher'

RECIPE_PATH = File.expand_path(File.join(File.dirname(__FILE__), "..", "fixtures","test_recipe.json"))

class TestGrapher < Test::Unit::TestCase
  def setup
    @ginger_cat = Grayphr.new("dick_cat", RECIPE_PATH)
    @product = "electronic-circuit"
    @amount = 10
  end

  def test_get_ingredients
    ingredients = @ginger_cat.get_ingredients(@product, @amount)
    assert_equal(ingredients, {'iron-plate' => 10, 'copper-cable' => 30})
  end

  def test_get_ingredients_recursive
    ingredients = @ginger_cat.get_ingreds_recursive(@product, @amount)
    expect = {'iron-ore' => {'iron-plate' => 10},
    'copper-ore' => {'copper-plate' => 30},
    'copper-plate' => {'copper-cable' => 30},
    'iron-plate' => {'electronic-circuit'=> 10},
    'copper-cable' => {'electronic-circuit'=> 30} 
   }
   assert_equal(ingredients, expect)
  end

  def test_make_graph
    graph = @ginger_cat.make_graph(@product, @amount)
    expect = 'https://dreampuf.github.io/GraphvizOnline/#digraph%20G%20%7B%0A%22iron-plate%20x%2010%22%20-%3E%20%22electronic-circuit%20x%2010%22[label=%2210%22]%0A%22iron-ore%20x%2010%22%20-%3E%20%22iron-plate%20x%2010%22[label=%2210%22]%0A%22copper-cable%20x%2030%22%20-%3E%20%22electronic-circuit%20x%2010%22[label=%2230%22]%0A%22copper-plate%20x%2030%22%20-%3E%20%22copper-cable%20x%2030%22[label=%2230%22]%0A%22copper-ore%20x%2030%22%20-%3E%20%22copper-plate%20x%2030%22[label=%2230%22]%0A%7D'
    assert_equal(graph, expect)
  end

  def test_ingredient_struct
    actual = @ginger_cat.get_product(@product)
    expect = Product.new(0.5, 1)
    assert_equal(actual, expect)
  end 

  def teardown
  end

end
