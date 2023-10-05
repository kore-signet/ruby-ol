# frozen_string_literal: true
require "dry-types"
require "dry-struct"
require "dry-validation"

module Types
  include Dry::Types()
end

module OpenLibrary
  class Error < StandardError; end
  class WrongIdKind < Error; end
end

require_relative "openlibrary/version"
require_relative "openlibrary/models/init"
require_relative "openlibrary/client"
