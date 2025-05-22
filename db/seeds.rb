require_relative "../config/db"
require_relative "../app/models/reflection"

# Clear existing data first
Reflection.dataset.delete

puts "Seeding database with reflections..."

milestone = Reflection.create(
  name: "Foundation Laid",
  type: "Milestone",
  status: "complete",
  order: 1 
)

feature1 = Reflection.create(
  name: "Define Data Models",
  type: "Feature",
  status: "in-progress",
  order: 2 
)

feature2 = Reflection.create(
  name: "Define Relationships",
  type: "Feature",
  status: "in-progress",
  order: 3
)

Reflection.create(
  name: "Create Reflection superclass",
  type: "Task",
  status: "todo",
  order: 4
)

Reflection.create(
  name: "Implement Single Table Inheritance (STI)",
  type: "Task",
  status: "todo",
  order: 5
)

Reflection.create(
  name: "Link parent-child dependencies",
  type: "Task",
  status: "todo",
  order: 6
)

puts "Seeding complete."
