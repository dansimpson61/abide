require "sequel"

class Reflection < Sequel::Model
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  def validate
    super
    validates_presence [:name, :type, :status]
    validates_includes ["Milestone", "Feature", "Task"], :type
    validates_includes ["todo", "in-progress", "complete", "rethinking", "future"], :status
  end

  def before_create
    self.order ||= (Reflection.max(:order) || 0) + 1
    super
  end

  # ✅ Dataset-Level Transformation Method
  def self.dataset_to_h
    self.order(:order).all.map do |reflection|
      reflection.values.transform_keys(&:to_sym) # Ensures all keys are Symbols for consistency
    end
  end
end
