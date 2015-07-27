require 'spec_helper'

RSpec.describe Contactable::Address, type: :module do

  describe "REQUIRED_DATABASE_FIELDS" do 
    class KlassWithNoAddressableFields
      def self.column_names
        ["cheese"]
      end
    end
    class KlassWithSomeAddressableFields
      def self.column_names
        ["address1"]
      end
    end
    class KlassWithAllAddressableFields
      def self.column_names
        Contactable::Address::REQUIRED_DATABASE_FIELDS
      end
    end
    describe "KlassWithNoAddressableFields" do 
      it "raises RuntimeError: address1 not included. please ensure necessary fields are in place" do 
        expect{KlassWithNoAddressableFields.include Contactable::Address}.to raise_error(RuntimeError, "address1 not included. please ensure necessary fields are in place")
      end   
    end
    describe "KlassWithSomeAddressableFields" do 
      it "raises RuntimeError: address2 not included. please ensure necessary fields are in place" do 
        expect{KlassWithSomeAddressableFields.include Contactable::Address}.to raise_error(RuntimeError, "address2 not included. please ensure necessary fields are in place")
      end   
    end
    describe "KlassWithAllAddressableFields" do 
      it "doesnt raise error" do 
        expect{KlassWithAllAddressableFields.include Contactable::Address}.to_not raise_error
      end   
    end
  end
  describe "load_required_attributes" do 
    class KlassWithSomeValidations
      def self.column_names
        Contactable::Address::REQUIRED_DATABASE_FIELDS
      end
      include ActiveModel::Validations
      Contactable::Address::REQUIRED_DATABASE_FIELDS.map { |x| attr_accessor x.to_sym }
      include Contactable::Address
      validate_required_attributes
    end
    describe KlassWithSomeValidations do 
      it { is_expected.to validate_presence_of(:address1) }
      it { is_expected.to validate_presence_of(:postcode) }

      it { is_expected.to_not validate_presence_of(:town) } 
    end
  end
  describe "title" do 
    class KlassWithTitle
      def self.column_names
        Contactable::Address::REQUIRED_DATABASE_FIELDS
      end
      include ActiveModel::Validations
      Contactable::Address::REQUIRED_DATABASE_FIELDS.map { |x| attr_accessor x.to_sym }
      include Contactable::Address
      validate_required_attributes
      # def address1=(value)
      #   value
      # end
    end
    describe KlassWithTitle do 
      let(:klass_with_title){KlassWithTitle.new}
      it "contactable_address equals fred@fred.com" do
        klass_with_title.address1 = "fred@fred.com"
        expect(klass_with_title.contactable_address).to eq ["fred@fred.com"]
      end
    end
  end
end
