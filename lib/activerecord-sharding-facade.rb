require "activerecord-sharding"

# require "active_record/sharding/facade/helper"

module ActiveRecord
  module Sharding
    module Facade
      extend ActiveSupport::Concern

      include ActiveRecord::Sharding::Model
      include ActiveRecord::Sharding::Sequencer

      module ClassMethods
        def hello
          p "hello"
        end
      end


      included do
        before_put do |attributes|
          attributes[:id] ||= next_sequence_id
        end

        before_save on: :create do
          self.id ||= self.class.next_sequence_id
        end
      end
    end
  end
end
