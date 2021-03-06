module Emailable
  extend ActiveSupport::Concern
  include FieldsValidator

  included do
    validate_required_attributes
  end

  class_methods do
    def required_attributes
      result=defined?(super) ? super : []
      result+=required_emailable_attributes
    end

    def required_database_fields
      result=defined?(super) ? super : []
      result+=[:email]
    end

    def required_emailable_attributes
      [:email]
    end
  end

  public

  private


end

