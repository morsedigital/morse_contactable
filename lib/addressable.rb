module Addressable
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
      result+=[:address1, :address2, :address3, :town, :county, :country, :postcode]
    end

    def required_nameable_attributes
      [:address1,:postcode]
    end
  end

  public

  def address_1
    address1
  end

  def first_name=(thing)
    self.address1=thing
  end

  def full_name
    "#{address1} #{postcode}"
  end

  def proper_name
    "#{postcode.upcase}, #{address1}"
  end

  def surname
    postcode
  end

  def surname=(thing)
    self.postcode=thing
  end

  def title
    return super if defined?(super)
    full_name
  end

  private


end

