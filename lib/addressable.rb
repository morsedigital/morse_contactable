module Addressable
  extend ActiveSupport::Concern
  include FieldsValidator

  included do
    validate_required_attributes
  end

  class_methods do
    def required_attributes
      result=defined?(super) ? super : []
      result+=required_addressable_attributes
    end

    def required_database_fields
      result=defined?(super) ? super : []
      result+=[:title, :address1, :address2, :address3, :town, :county, :country, :postcode]
    end

    def required_addressable_attributes
      [:address1,:postcode]
    end
  end

  public

  def address_array
    Array.new.tap { |a| required_database_fields.select { |key| a<<self.send(key) } }
  end

  def address_pretty
    stringify_array address_array
  end

  def city
    town
  end

  def city=(thing)
    self.town = thing
  end

  def state
    county
  end

  def state=(thing)
    self.county = thing
  end

  def zip
    postcode
  end

  def zip=(thing)
    self.postcode = thing
  end

  def zipcode
    postcode
  end

  def zipcode=(thing)
    self.postcode = thing
  end

  private

  def stringify_array(array)
    array.compact.join(", ")
  end

end

