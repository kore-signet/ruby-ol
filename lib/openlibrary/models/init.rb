require_relative "key"

module OpenLibrary
  def self.ISBN(s)
    Key::ISBN.new s
  end

  def self.LCCN(s)
    Key::LCCN.new s
  end

  def self.OCLC(s)
    Key::OCLC.new s
  end

  def self.CoverID(i)
    Key::CoverID.new i
  end

  def self.OLID(s)
    Key::OLID.new s
  end
end

require_relative "edition"
require_relative "work"
require_relative "cover"
