require "morse_contactable/version"
require 'active_model'
require 'active_support/all'
require 'morse_fields_validator'
require "addressable"
require "emailable"
require "phoneable"
module MorseContactable
  extend ActiveSupport::Concern
  include FieldsValidator
  include Addressable,
          Emailable,
          Phoneable
end
