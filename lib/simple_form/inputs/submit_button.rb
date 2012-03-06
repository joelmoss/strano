module SimpleForm
  module Inputs
    module SubmitButton
      def submit_button(*args, &block)
        options = args.extract_options!
        value = args.first || submit_default_value
        options[:class] = "btn-primary #{options[:class].join(' ')}".strip
        
        template.button_tag value, options
      end
    end
  end
  
  class FormBuilder
    include SimpleForm::Inputs::SubmitButton
  end
end