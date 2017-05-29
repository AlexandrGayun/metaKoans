class Module
  def attribute(name, &block)
    if name.instance_of?(Hash)
      name.each do |name, value|
        create_setter_getter_query(name, value)
      end
    elsif block_given?
      create_setter_getter_query(name, &block)
    else
      create_setter_getter_query(name)
    end
  end

  def create_setter_getter_query(name, default_value = nil, &block)
    define_method("#{name}?".to_sym) do
      instance_variable_get("@#{name}".to_sym) ? true : false
    end

    define_method("#{name}=".to_sym) do |setting_value|
      instance_variable_set("@#{name}".to_sym, setting_value)
    end

    define_method(name.to_sym) do
      if instance_variables.include?("@#{name}".to_sym)
        instance_variable_get("@#{name}")
      elsif default_value
        instance_variable_set("@#{name}".to_sym, default_value)
      else
        instance_variable_set("@#{name}".to_sym, instance_eval(&block))
      end
    end
  end
end
