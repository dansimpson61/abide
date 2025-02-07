require_relative "../config/db"
require_relative "../app/models/reflection"

# Clear existing data first
Reflection.dataset.delete

puts "Seeding database with reflections..."

# Sample Reflections
Reflection.create(name: "First Reflection", type: "Insight", status: "new", order: 1)
Reflection.create(name: "Second Reflection", type: "Observation", status: "new", order: 2)

puts "Seeding complete."
