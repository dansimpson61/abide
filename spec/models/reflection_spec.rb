require_relative "../spec_helper"

RSpec.describe Reflection do
  let(:valid_attrs) { 
    { name: "Retirement Plan", type: "Milestone", status: "complete" } 
  }

  it "requires name, type, and status" do
    reflection = Reflection.new
    expect(reflection.valid?).to be false
    expect(reflection.errors[:name]).to include("is not present")
    expect(reflection.errors[:type]).to include("is not present")
    expect(reflection.errors[:status]).to include("is not present")
  end

  it "validates allowed types" do
    reflection = Reflection.new(valid_attrs.merge(type: "Invalid"))
    expect(reflection.valid?).to be false
    expect(reflection.errors[:type]).to include("is not in range or set: [\"Milestone\", \"Feature\", \"Task\"]")
  end  

  it "auto-assigns order on creation" do
    reflection1 = Reflection.create(valid_attrs)
    reflection2 = Reflection.create(valid_attrs.merge(name: "Another Plan"))
    expect(reflection2.order).to eq(reflection1.order + 1)
  end
end