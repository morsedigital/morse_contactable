require 'spec_helper'

RSpec.describe Contactable::Email, type: :module do

  describe "REQUIRED_DATABASE_FIELDS" do 
    class KlassWithNoEmailableFields
      def self.column_names
        "cheese"
      end
    end
    class KlassWithAllEmailableFields
      def self.column_names
        Contactable::Email::REQUIRED_DATABASE_FIELDS
      end
    end
    describe "KlassWithNoEmailableFields" do 
      it "raises RuntimeError RuntimeError: email not included. please ensure necessary fields are in place" do 
        expect{KlassWithNoEmailableFields.include Contactable::Email}.to raise_error(RuntimeError, "email not included. please ensure necessary fields are in place")
      end   
    end
    describe "KlassWithAllEmailableFields" do 
      it "doesnt raise error" do 
        expect{KlassWithAllEmailableFields.include Contactable::Email}.to_not raise_error
      end   
    end
  end
  describe "load_required_attributes" do 
    class KlassWithSomeValidations
      def self.column_names
        Contactable::Email::REQUIRED_DATABASE_FIELDS
      end
      include ActiveModel::Validations
      Contactable::Email::REQUIRED_DATABASE_FIELDS.map { |x| attr_accessor x.to_sym }
      include Contactable::Email
      validate_required_attributes
    end
    describe KlassWithSomeValidations do 
      it { is_expected.to validate_presence_of(:email) }
    end
  end
  describe "title" do 
    class KlassWithTitle
      def self.column_names
        Contactable::Email::REQUIRED_DATABASE_FIELDS
      end
      include ActiveModel::Validations
      Contactable::Email::REQUIRED_DATABASE_FIELDS.map { |x| attr_accessor x.to_sym }
      include Contactable::Email
      validate_required_attributes
    end
    describe KlassWithTitle do 
      let(:klass_with_title){KlassWithTitle.new}
      it "contactable_email equals fred@fred.com" do
        klass_with_title.email = "fred@fred.com"
        expect(klass_with_title.contactable_email).to eq ["fred@fred.com"]
      end
    end
  end
end
