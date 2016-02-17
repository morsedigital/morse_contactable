module Addressable
  extend ActiveSupport::Concern
  include FieldsValidator
  REQUIRED_DATABASE_FIELDS = [:title, :address1, :address2, :address3, :town, :county, :country, :postcode]

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
      result+= REQUIRED_DATABASE_FIELDS
    end

    def required_addressable_attributes
      [:address1,:postcode]
    end
  end

  public

  def address_array
    Array.new.tap { |a| REQUIRED_DATABASE_FIELDS.select { |key| a<<self.send(key) } }
  end

  def address_hash
    REQUIRED_DATABASE_FIELDS.each_with_object({}) { |f, o| o.merge!(f => self.send(f)) }
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

