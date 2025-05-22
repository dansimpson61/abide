class DslTestsController < ApplicationController
  def toggle_panel
    render partial: 'dsl_tests/toggle_panel'
  end

  def sortable
    @reflections = ['Item 1', 'Item 2', 'Item 3'] # Example data
    render partial: 'dsl_tests/sortable', locals: { reflections: @reflections }
  end

  def editable_text
    render partial: 'dsl_tests/editable_text'
  end

  def editable_list
    render partial: 'dsl_tests/editable_list'
  end
end 