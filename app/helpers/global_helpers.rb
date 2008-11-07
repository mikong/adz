module Merb
  module GlobalHelpers
    def currency_tip
      tag :span, '(in Php)', :class => 'tip'
    end
    
    def currency_field(name)
      "#{text_field(name, :class => 'money')} .00"
    end
  end
end
