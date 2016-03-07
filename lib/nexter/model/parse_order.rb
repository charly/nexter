class Nexter::Model
  class ParseOrder
    attr_reader :order_values

    def self.parse(order_values)
      new(order_values).parse
    end

    def initialize(order_values)
      @order_values = order_values
    end


    def parse
      order_values.flat_map do |value|
        value.is_a?(String) ? parse_string(value) : parse_arel(value)
      end
    end

    # helper to turn mixed order attributes to a consistant array of vals
    def parse_string(string)
      string.split(",").map(&:strip).map do |column|
        splits = column.split(" ").map(&:strip).map(&:downcase)
        splits << "asc" if splits.size == 1
        splits
      end
    end

    def parse_arel(arel)
      ["#{arel.value.name}", "#{arel.direction}"]
    end


  end
end