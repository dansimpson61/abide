require "spec_helper"
require "capybara/rspec"

RSpec.describe "Drag-and-Drop Reflections", type: :feature, js: true do
  before do
    # Clear test DB and add records
    Reflection.dataset.delete

    @reflection1 = Reflection.create(name: "Reflection A", type: "Task", status: "todo", order: 1)
    @reflection2 = Reflection.create(name: "Reflection B", type: "Task", status: "todo", order: 2)
    @reflection3 = Reflection.create(name: "Reflection C", type: "Task", status: "todo", order: 3)

    puts "🔍 DEBUG: Test DB contains reflections: #{Reflection.all.map(&:values).inspect}"
  end

  it "persists the new order after dragging" do
    visit "/"

    # Ensure only the reflection names are rendered correctly
    expect(page).to have_css("div.name", text: "Reflection A")
    expect(page).to have_css("div.name", text: "Reflection B")
    expect(page).to have_css("div.name", text: "Reflection C")

    # Simulate drag-and-drop of Reflection C to the top
    reflection_c = find("li[data-id='#{@reflection3.id}']")
    reflection_a = find("li[data-id='#{@reflection1.id}']")
    reflection_c.drag_to(reflection_a)

    # Wait for order update
    sleep 1

    # Confirm UI updates correctly
    within ".garden" do
      names = all("div.name").map(&:text)
      expect(names).to eq(["Reflection C", "Reflection A", "Reflection B"])
    end

    # Ensure order is saved in the database
    updated_reflections = Reflection.order(:order).all
    puts "🔍 DEBUG: Order after dragging: #{updated_reflections.map(&:values).inspect}"

    expect(updated_reflections[0].id).to eq(@reflection3.id)
    expect(updated_reflections[1].id).to eq(@reflection1.id)
    expect(updated_reflections[2].id).to eq(@reflection2.id)
  end
end
