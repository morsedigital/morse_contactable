module Phoneable
  extend ActiveSupport::Concern
  include FieldsValidator

  included do
    validate_required_attributes
  end

  class_methods do
    def required_attributes
      result=defined?(super) ? super : []
      result+=required_nameable_attributes
    end

    def required_database_fields
      result=defined?(super) ? super : []
      result+=[:phone, :mobile]
    end

    def required_nameable_attributes
      [:phone]
    end
  end

  public

  def landline
    phone
  end

  private


end

