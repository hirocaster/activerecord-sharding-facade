base = { "adapter" => "mysql2", "encoding" => "utf8", "pool" => 5, "username" => "root", "password" => "", "host" => "localhost" }
ActiveRecord::Base.configurations = {
  "test_user_001" => base.merge("database" => "user_001"),
  "test_user_002" => base.merge("database" => "user_002"),
  "test_user_003" => base.merge("database" => "user_003"),
  "test_user_sequencer" => base.merge("database" => "user_sequencer"),
  "test" => base.merge("database" => "default")
}
ActiveRecord::Base.establish_connection(:test)

ActiveRecord::Sharding.configure do |config|
  config.define_cluster(:user) do |cluster|
    cluster.register_connection(:test_user_001)
    cluster.register_connection(:test_user_002)
    cluster.register_connection(:test_user_003)
  end

  config.define_sequencer(:user) do |sequencer|
    sequencer.register_connection(:test_user_sequencer)
    sequencer.register_table_name("user_id")
  end
end

class User < ActiveRecord::Base
  include ActiveRecord::Sharding::Facade

  use_sharding :user, :modulo
  define_sharding_key :id
  use_sequencer :user
end
