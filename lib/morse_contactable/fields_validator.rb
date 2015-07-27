module FieldsValidator 
  ERROR = 'please ensure necessary fields are in place'

  extend ActiveSupport::Concern
  class_methods do 
    def validate_required_attributes
      required_attributes.each do |a|
        validates a.to_sym, presence: true 
      end
    end
    def load_required_attributes(*_attrs)
      @required_attributes ||=[]
      @required_attributes += _attrs
      @required_attributes.uniq!
    end

    def required_attributes
      @required_attributes
    end

    def validate_column_names(*_attrs)
      _attrs.each { |rdf| raise "#{rdf} not included. #{ERROR}" unless column_names.include?(rdf)}
    end
  end
end
