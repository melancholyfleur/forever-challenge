require 'rails_helper'

RSpec.describe Album, type: :model do
  it "requires a name" do
    expect(Album.new(name: "")).to_not be_valid
  end
end
