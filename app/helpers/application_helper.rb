module ApplicationHelper

  def title(page_title)
    content_for :title, page_title.to_s
  end

  module BootstrapExtension
    FORM_CONTROL_CLASS = "form-control"

    def add_class(options = {})
      class_name = options[:class]
      if class_name.nil?
        options[:class] = FORM_CONTROL_CLASS
      else
        options[:class] << " #{FORM_CONTROL_CLASS}" if
          " #{class_name} ".index(" #{FORM_CONTROL_CLASS} ").nil?
      end
    end

    def text_field(name, value = nil, options = {})
      add_class options
      super
    end

    def text_area(name, value = nil, options = {})
      add_class options
      super
    end
  end

  include BootstrapExtension
end
