base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
app_dir  = File.join(base_dir, "app")
test_dir = File.join(base_dir, "test")

$LOAD_PATH.unshift(app_dir)

require 'test/unit'

exit Test::Unit::AutoRunner.run(true, test_dir)