class Number < Struct.new(:value)
    def to_s
        value.to_s
    end

    def inspect
        "<<#{self}>>"
    end
end

class Add < Struct.new(:left, :right)
    def to_s
        "#{left} + #{right}"
    end
    
    def inspect
        "<<#{self}>>"
    end
end

class Multiply < Struct.new(:left, :right)
    def to_s
        "#{left} * #{right}"
    end
    
    def inspect
        "<<#{self}>>"
    end
end

# 是否能够规约
def reducible?(expression)
    case expression
    when Number
        false
    when Add, Multiply
        true
    end

end

a = Add.new(
    Multiply.new(Number.new(1), Number.new(2)),
    Multiply.new(Number.new(3), Number.new(4))
)

puts a
puts Number.new(1)
