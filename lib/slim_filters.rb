# lib/slim_filters.rb (Corrected on_slim_embedded)
require_relative "../app/helpers/dsl_helpers"

module Slim
  class StimulusFilter < Filter
    DSL_DEFINITIONS = DslHelpers::DSL_DEFINITIONS

    def on_slim_embedded(filter_type, content_ast, ignored_body)
      # Compile the 'engine' (which seems to contain the actual content)
      puts "***** on_slim_embedded ***********"
      puts "type: #{filter_type.inspect}"
      puts "engine: #{content_ast.inspect}"
      puts "body: #{ignored_body.inspect}"
      puts "**********************************"

      compile(content_ast) 
    end

    def on_multi(*expressions)
      [:multi, *expressions.map { |exp| compile(exp) }]
    end

    def on_html_tag(name, attrs, content)
      attrs = process_dsl_attributes(attrs)
      [:html, :tag, name, attrs, content ? compile(content) : nil]
    end

    def on_html_attrs(*attrs)
      [:html, :attrs, *attrs]
    end

    def on_html_attr(name, value)
      [:html, :attr, name, value]
    end

    def on_static(text)
      [:static, text]
    end

    def on_slim_interpolation(text)
      [:slim, :interpolation, text]
    end

    private

    def process_dsl_attributes(attrs)
      # This is a placeholder for interaction with StimulusElement subclasses
      new_attrs = []
      dsl_attr_found = false

      attrs.each do |attr|
        name, value = attr[2], attr[3]
        if DSL_DEFINITIONS.key?(name)
          dsl_attr_found = true
          dsl_def = DSL_DEFINITIONS[name]
          new_attrs << [:html, :attr, 'data-controller', [:static, dsl_def[:controller]]]
          new_attrs << [:html, :attr, 'class', [:static, dsl_def[:css_class]]] if dsl_def[:css_class]
          if dsl_def[:data_field]
            new_attrs << [:html, :attr, 'data-field', value]
          elsif value[1].is_a?(String) # Corrected value[1]
            new_attrs << [:html, :attr, 'data-label', value]
          end
        else
          new_attrs << attr # Keep non-DSL attributes
        end
      end
      dsl_attr_found ? [:html, :attrs, *new_attrs] : [:html, :attrs, *attrs]
    end
  end
end

Slim::Embedded.register(:stimulus, Slim::StimulusFilter)