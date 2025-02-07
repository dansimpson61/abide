#!/bin/bash

# Create the directories
mkdir -p views views/_partials

# Create the files
touch app.rb views/layout.slim views/index.slim \
      views/_partials/_place.slim views/_partials/_collection.slim \
      views/_partials/_item.slim

# Populate the files with initial content (optional)
cat << EOF > app.rb
require 'sinatra'
require 'slim'

get '/' do
  # Sample data (replace with your actual data retrieval logic)
  @page_data = {
    market: [
      { basket: %w[Apple Banana Cherry Dragonfruit] },
      { shelf: %w[Milk Bread Cheese] }
    ],
    park: [
      { pond: %w[Duck Fish Turtle] },
      { playground: %w[Slide Swing Sandbox] }
    ]
  }
  slim:index
end
EOF

cat << EOF > views/layout.slim
doctype html
html
  head
    title My DRY Sinatra App
  body
    == yield
EOF

cat << EOF > views/index.slim
- @page_data.each do |place_name, collections|
  div class="place"
    h2 = place_name.capitalize
    - collections.each do |collection|
      == slim:_collection, locals: { collection: collection }
EOF

cat << EOF > views/_partials/_collection.slim
div class="collection"
  - collection.each do |collection_name, items|
    h3 = collection_name.capitalize
    - items.each do |item|
      == slim:_item, locals: { item: item }
EOF

cat << EOF > views/_partials/_item.slim
div class="item"
  p = item
EOF

echo "File structure created successfully!"