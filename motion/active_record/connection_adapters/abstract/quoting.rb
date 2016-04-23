require __ORIGINAL__

module ActiveRecord
  module ConnectionAdapters
    module Quoting
      # def _quote(value)
      #   case value
      #   when String, ActiveSupport::Multibyte::Chars, Type::Binary::Data
      #     "'#{quote_string(value.to_s)}'"
      #   when true       then quoted_true
      #   when false      then quoted_false
      #   when nil        then "NULL"
      #   # BigDecimals need to be put in a non-normalized form and quoted.
      #   when BigDecimal then value.to_s('F')
      #   when Numeric, ActiveSupport::Duration then value.to_s
      #   when Date, Time then "'#{quoted_date(value)}'"
      #   when Symbol     then "'#{quote_string(value.to_s)}'"
      #   when Class      then "'#{value}'"
      #   else
      #     "'#{quote_string(YAML.dump(value))}'"
      #   end
      # end
      def _quote(value)
        case value
        when String, Type::Binary::Data
          "'#{quote_string(value.to_s)}'"
        when true       then quoted_true
        when false      then quoted_false
        when nil        then "NULL"
        # BigDecimals need to be put in a non-normalized form and quoted.
        when BigDecimal then value.to_s('F')
        when Numeric, ActiveSupport::Duration then value.to_s
        when Date, Time then "'#{quoted_date(value)}'"
        when Symbol     then "'#{quote_string(value.to_s)}'"
        when Class      then "'#{value}'"
        else
          "'#{quote_string(YAML.dump(value))}'"
        end
      end

      # def _type_cast(value)
      #   case value
      #   when Symbol, ActiveSupport::Multibyte::Chars, Type::Binary::Data
      #     value.to_s
      #   when true       then unquoted_true
      #   when false      then unquoted_false
      #   # BigDecimals need to be put in a non-normalized form and quoted.
      #   when BigDecimal then value.to_s('F')
      #   when Date, Time then quoted_date(value)
      #   when *types_which_need_no_typecasting
      #     value
      #   else raise TypeError
      #   end
      # end
      def _type_cast(value)
        case value
        when Symbol, Type::Binary::Data
          value.to_s
        when true       then unquoted_true
        when false      then unquoted_false
        # BigDecimals need to be put in a non-normalized form and quoted.
        when BigDecimal then value.to_s('F')
        when Date, Time then quoted_date(value)
        when *types_which_need_no_typecasting
          value
        else raise TypeError
        end
      end
    end
  end
end
