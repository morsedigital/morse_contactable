module Contactable
  VALIDATE_ADDRESSABLE = %w{address1 postcode} unless const_defined? :VALIDATE_ADDRESSABLE
  VALIDATE_EMAILABLE = %w{email} unless const_defined? :VALIDATE_EMAILABLE 
  VALIDATE_PERSONABLE = ["firstname", "lastname"] unless const_defined? :VALIDATE_PERSONABLE 
  VALIDATE_PHONEABLE = %w{phone} unless const_defined? :VALIDATE_PHONEABLE
  extend ActiveSupport::Concern
  include FieldsValidator

  def self.collect_attributes(klass,*_attrs)
    _attrs.map { |rdf| klass.send(rdf.to_sym) }.compact
  end

  module Address
    extend ActiveSupport::Concern
    include FieldsValidator

    REQUIRED_DATABASE_FIELDS = %w{address1 address2 address3 town county country postcode} unless const_defined? :REQUIRED_DATABASE_FIELDS 

    included do
      validate_column_names(*REQUIRED_DATABASE_FIELDS)
      load_required_attributes(*VALIDATE_ADDRESSABLE)
    end
    def contactable_address
      Contactable.collect_attributes(self,*REQUIRED_DATABASE_FIELDS)
    end
  end

  module Email 
    extend ActiveSupport::Concern
    include FieldsValidator

    REQUIRED_DATABASE_FIELDS = %w{email} unless const_defined? :REQUIRED_DATABASE_FIELDS 

    included do
      validate_column_names(*REQUIRED_DATABASE_FIELDS)
      load_required_attributes(*VALIDATE_EMAILABLE)
    end
    def contactable_email
      Contactable.collect_attributes(self,*REQUIRED_DATABASE_FIELDS)
    end
  end

  module Phone
    extend ActiveSupport::Concern
    include FieldsValidator

    REQUIRED_DATABASE_FIELDS = %w{phone mobile} unless const_defined? :REQUIRED_DATABASE_FIELDS 

    included do
      validate_column_names(*REQUIRED_DATABASE_FIELDS)
      load_required_attributes(*VALIDATE_PHONEABLE)
    end
    def contactable_phone
      Contactable.collect_attributes(self,*REQUIRED_DATABASE_FIELDS)
    end
  end


  include Address
  include Email
  include Phone
end
