module Merb
  module GlobalHelpers
    def currency_tip
      tag :span, '(in Php)', :class => 'tip'
    end
  end
end
