require 'spec_helper'

RSpec.describe Contactable::Person, type: :module do

  describe "REQUIRED_DATABASE_FIELDS" do 
    class KlassWithNoPersonableFields
      def self.column_names
        "cheese"
      end
    end
    class KlassWithSomePersonableFields
      def self.column_names
        ["firstname"]
      end
    end
    class KlassWithAllPersonableFields
      def self.column_names
        Contactable::Person::REQUIRED_DATABASE_FIELDS
      end
    end
    describe "KlassWithSomePersonableFields" do 
      it "raises RuntimeError: address2 not included. please ensure necessary fields are in place" do 
        expect{KlassWithSomePersonableFields.include Contactable::Person}.to raise_error(RuntimeError, "lastname not included. please ensure necessary fields are in place")
      end   
    end
    describe "KlassWithNoPersonableFields" do 
      it "raises RuntimeError: firstname not included. please ensure necessary fields are in place" do 
        expect{KlassWithNoPersonableFields.include Contactable::Person}.to raise_error(RuntimeError, "firstname not included. please ensure necessary fields are in place")
      end   
    end
    describe "KlassWithAllPersonableFields" do 
      it "doesnt raise error" do 
        expect{KlassWithAllPersonableFields.include Contactable::Person}.to_not raise_error
      end   
    end
  end
  describe "load_required_attributes" do 
    class KlassWithSomeValidations
      def self.column_names
        Contactable::Person::REQUIRED_DATABASE_FIELDS
      end
      include ActiveModel::Validations
      Contactable::Person::REQUIRED_DATABASE_FIELDS.map { |x| attr_accessor x.to_sym }
      include Contactable::Person
      validate_required_attributes
    end
    describe KlassWithSomeValidations do 
      it { is_expected.to validate_presence_of(:firstname) }
      it { is_expected.to validate_presence_of(:lastname) }
    end
  end
  describe "title" do 
    class KlassWithTitle
      def self.column_names
        Contactable::Person::REQUIRED_DATABASE_FIELDS
      end
      include ActiveModel::Validations
      Contactable::Person::REQUIRED_DATABASE_FIELDS.map { |x| attr_accessor x.to_sym }
      include Contactable::Person
      validate_required_attributes
    end
    describe KlassWithTitle do 
      let(:klass_with_title){KlassWithTitle.new}
      it "contactable_Person equals fred@fred.com" do
        klass_with_title.firstname = "fred@fred.com"
        
        expect(klass_with_title.contactable_person).to eq ["fred@fred.com"]
      end
    end
  end
end
