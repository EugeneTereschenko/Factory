# frozen_string_literal: true

# * Here you must define your `Factory` class.
# * Each instance of Factory could be stored into variable. The name of this variable is the name of created Class
# * Arguments of creatable Factory instance are fields/attributes of created class
# * The ability to add some methods to this class must be provided while creating a Factory
# * We must have an ability to get/set the value of attribute like [0], ['attribute_name'], [:attribute_name]
#
# * Instance of creatable Factory class should correctly respond to main methods of Struct
# - each
# - each_pair
# - dig
# - size/length
# - members
# - select
# - to_a
# - values_at
# - ==, eql?

class Factory
  class << self
  def new(*args, &block)
    if args[0].is_a? String
      class_name = args.shift
      const_set(class_name.capitalize, new_class(*args, &block))
    else
      new_class(*args, &block)
    end
  end

  def new_class(*args, &block)
    Class.new do
      args.each do |arg|
        attr_reader arg
      end

      class_eval(&block) if block_given?

      define_method :initialize do |*val|
        raise ArgumentError if args.length != val.length

        args.each_index do |i|
          instance_variable_set("@#{args[i]}", val[i])
        end
      end

      define_method :size do
        instance_variables.size
      end

      define_method :members do
        instance_variables.map { |arg| arg.to_s.delete('@').to_sym }
      end

      define_method :values do
        instance_variables.map { |var| instance_variable_get(var) }
      end

      define_method :== do |obj|
        self.class == obj.class && values == obj.values
      end

      define_method :eql? do |obj|
        self.class == obj.class && values.eql?(obj.values)
      end

      define_method :[] do |param_name|
        if (param_name.is_a? String) || (param_name.is_a? Symbol)
          instance_variable_get("@#{param_name}")
        elsif param_name.is_a? Integer
          instance_variable_get(instance_variables[param_name])
        end
      end

      define_method :[]= do |field, value|
        param = ('@' + (field.is_a?(Integer) ? args[field] : field).to_s)
        instance_variables.map { instance_variable_set(param, value) }
      end

      define_method :each do |&block|
        to_a.each(&block) 
      end

      def to_a
        instance_variables.map { |values| instance_variable_get values }
      end

      define_method :each_pair do |&block|
        to_h.each_pair &block
      end

      define_method :to_h do
        Hash[members.zip(to_a)]
      end

      define_method :dig do |*args|
        to_h.dig(*args)
      end

      define_method :select do |&block|
        to_a.select(&block)
      end

      define_method :values_at do |index1, index2|
        values.values_at(index1, index2)
      end

      define_method :to_a do
        instance_variables.map { |var| instance_variable_get(var) }
      end

      alias_method :length, :size
    end
  end
end
end
