# 数值
class Number < Struct.new(:value)
    def to_s
        value.to_s
    end

    def inspect
        "<<#{self}>>"
    end
    def reducible?
        false
    end
end

# 布尔值
class Boolean < Struct.new(:value)
    def to_s
        value.to_s
    end

    def inspect
        "<<#{self}>>"
    end
    def reducible?
        false
    end
end

class Add < Struct.new(:left, :right)
    def to_s
        "#{left} + #{right}"
    end
    
    def inspect
        "<<#{self}>>"
    end

    def reducible?
        true
    end

    def reduce(environment)
        if left.reducible?
            Add.new(left.reduce(environment), right)
        elsif right.reducible?
            Add.new(left, right.reduce(environment))
        else
            Number.new(left.value + right.value)
        end
    end
end

class Multiply < Struct.new(:left, :right)
    def to_s
        "#{left} * #{right}"
    end
    
    def inspect
        "<<#{self}>>"
    end

    def reducible?
        true
    end

    def reduce(environment)
        if left.reducible?
            Multiply.new(left.reduce(environment), right)
        elsif right.reducible?
            Multiply.new(left, right.reduce(environment))
        else
            Number.new(left.value * right.value)
        end
    end
end

# 小于运算符
class LessThan < Struct.new(:left, :right)
    def to_s
        "#{left} < #{right}"
    end
    
    def inspect
        "<<#{self}>>"
    end

    def reducible?
        true
    end

    def reduce(environment)
        if left.reducible?
            LessThan.new(left.reduce(environment), right)
        elsif right.reducible?
            LessThan.new(left, right.reduce(environment))
        else
            Boolean.new(left.value < right.value)
        end
    end
end

# 变量. 变量的值存储在虚拟机的环境里边(hash)
class Variable < Struct.new(:name)
    def to_s
        name.to_s
    end

    def inspect 
        "<<#{name}>>"
    end

    def reducible?
        true
    end

    def reduce(environment)
        environment[name]
    end
end

# 虚拟机
class Machine < Struct.new(:expression, :environment)
    def step
        self.expression = expression.reduce(environment)
    end

    def run
        while expression.reducible?
            puts expression
            step
        end
        puts expression
    end
end


a = Add.new(
    Multiply.new(Number.new(1), Number.new(2)),
    Multiply.new(Number.new(3), Number.new(4))
)

Machine.new(a).run

b = Add.new(
    Variable.new(:x),
    Variable.new(:y),
)

Machine.new(
    b,
    {x: Number.new(1), y: Number.new(2)}
).run
