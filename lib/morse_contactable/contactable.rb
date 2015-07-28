module Contactable
  VALIDATE_ADDRESSABLE = %w{address1 postcode}
  VALIDATE_EMAILABLE = %w{email}
  VALIDATE_PERSONABLE = ["firstname", "lastname"]
  VALIDATE_PHONEABLE = %w{phone}
  extend ActiveSupport::Concern
  include FieldsValidator

  def self.collect_attributes(klass,*_attrs)
    _attrs.map { |rdf| klass.send(rdf.to_sym) }.compact
  end

  module Address
    extend ActiveSupport::Concern
    include FieldsValidator

    REQUIRED_DATABASE_FIELDS = %w{address1 address2 address3 town county country postcode}

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

    REQUIRED_DATABASE_FIELDS = %w{email}

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

    REQUIRED_DATABASE_FIELDS = %w{phone mobile}

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
  include Person
  include Phone
end
