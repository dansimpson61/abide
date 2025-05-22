# file: 'app/helpers/dsl_helpers.rb'
module DslHelpers
# This is a placeholder for a more structured StimulusElement class and subclasses
  DSL_DEFINITIONS = {
    'toggle_panel'  => { controller: 'toggle-panel',  default_tag: 'div', css_class: 'toggle-panel' },
    'sortable'      => { controller: 'sortable',      default_tag: 'div', css_class: 'sortable' },
    'editable_text' => { controller: 'editable-text', default_tag: 'span', css_class: 'editable-text', data_field: true },
    'editable_list' => { controller: 'editable-list', default_tag: 'div', css_class: 'editable-list', data_field: true }
  }
end
