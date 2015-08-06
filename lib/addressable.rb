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
      result+=[:address1, :address2, :address3, :town, :county, :country, :postcode]
    end

    def required_addressable_attributes
      [:address1,:postcode]
    end
  end

  public

  private


end

