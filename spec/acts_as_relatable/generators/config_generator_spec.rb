require "spec_helper"
# describe ActsAsRelatable::Generators::ConfigGenerator do
#
#   context "generates config file" do
#
#     before { setup }
#     after { teardown }
#
#     it "copy it in config/initializers" do
#       Rails::Generators::Scripts::Generate.new.run([""], :destination => fake_rails_root)
#       new_file = (file_list - @original_files).first
#       assert_equal "definition.txt", File.basename(new_file)
#     end
#
#     def setup
#       FileUtils.mkdir_p(fake_rails_root)
#       @original_files = file_list
#     end
#
#     def teardown
#       FileUtils.rm_r(fake_rails_root)
#     end
#
#     def fake_rails_root
#       File.join(File.dirname(__FILE__), 'rails_root')
#     end
#
#     def file_list
#       Dir.glob(File.join(fake_rails_root, "*"))
#     end
#
#   end
#
# end