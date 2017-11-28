describe ActiveRecord::Sharding::Facade do
  describe "including modules" do
    it "includes ActiveRecord::Sharding::Model and ActiveRecord::Sharding::Sequencer" do
      expect(User).to be_include ActiveRecord::Sharding::Facade
      expect(User).to be_include ActiveRecord::Sharding::Model
      expect(User).to be_include ActiveRecord::Sharding::Sequencer
    end
  end

  shared_examples_for "successfully" do
    it "inserts a record" do
      expect(alice.persisted?).to be true
      expect(alice.id).to eq User.current_sequence_id
      expect(alice.name).to eq "Alice"
      expect(alice.class.name).to match(/User::ShardFor/)
    end
  end

  describe ".put!" do
    let(:alice) { User.put!(name: "Alice") }

    it_behaves_like "successfully"
  end

  describe ".new and #save" do
    let(:alice) do
      alice = User.shard_for(1).new(name: "Alice")
      alice.save
      alice
    end

    it_behaves_like "successfully"
  end
end
