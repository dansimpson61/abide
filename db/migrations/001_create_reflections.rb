Sequel.migration do
  change do
    create_table(:reflections) do
      primary_key :id
      String :type, null: false  # Retaining existing type system
      String :name, null: false
      Text :description
      String :status, null: false, default: "todo"  # Retaining status
      Integer :order, null: false, default: 0
      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
