module SimpleForm
  module Inputs
    module CancelButton
      def cancel_button(*args, &block)
        options = args.extract_options!
        value = args.first || 'Cancel'
        options[:class] = "cancel #{options[:class].join(' ')}".strip
        options[:type] = 'button'
        options[:'data-url'] = options.delete(:url) || '/'
        
        template.button_tag value, options
      end
    end
  end
  
  class FormBuilder
    include SimpleForm::Inputs::CancelButton
  end
end