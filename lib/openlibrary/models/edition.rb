module OpenLibrary
  class Edition < Dry::Struct
    attribute :title, Types::String
    attribute :authors, Types::Array.of(Types.Instance(Key::OLID))
    attribute :key, Types.Instance(Key::OLID)
    attribute :source_records, Types::Array.of(Types::String)
    attribute :works, Types::Array.of(Types.Instance(Key::OLID))

    attribute :full_title, Types::String.optional
    attribute :physical_format, Types::String.optional
    attribute :number_of_pages, Types::Integer.optional
    attribute :publishers, Types::Array.of(Types::String).optional
    attribute :covers, Types::Array.of(Types.Instance(Key::CoverID))
    attribute :publish_date, Types::String.optional

    attribute :isbn_10, Types::Array.of(Types.Instance(Key::ISBN))
    attribute :isbn_13, Types::Array.of(Types.Instance(Key::ISBN))
    attribute :lccn, Types::Array.of(Types.Instance(Key::LCCN))
    attribute :oclc_numbers, Types::Array.of(Types.Instance(Key::OCLC))
    attribute :lc_classifications, Types::Array.of(Types::String)

    attribute :last_modified, Types::DateTime
    attribute :created, Types::DateTime

    def self.parse(inp)
      res = OpenLibrary::EditionContract.new.call inp
      r = res.to_h
      Edition.new(**{
        :title => r[:title],
        :authors => (r[:authors] or []).map { |a| OpenLibrary::OLID(a[:key]) } .to_a,
        :key => OpenLibrary::OLID(r[:key]),
        :source_records => (r[:source_records] or []),
        :works => r[:works].map { |w| OpenLibrary::OLID(w[:key]) }.to_a,
        :full_title => r[:full_title],
        :physical_format => r[:physical_format],
        :publishers => r[:publishers],
        :number_of_pages => r[:number_of_pages],
        :covers => (r[:covers] or []).map { |c| OpenLibrary::Key::CoverID.new(c) }.to_a,
        :publish_date => r[:publish_date],
        :isbn_10 => (r[:isbn_10] or []).map { |i| OpenLibrary::ISBN(i) }.to_a,
        :isbn_13 => (r[:isbn_13] or []).map { |i| OpenLibrary::ISBN(i) }.to_a,
        :lccn => (r[:lccn] or []).map { |c| OpenLibrary::LCCN(c) }.to_a,
        :oclc_numbers => (r[:oclc_numbers] or []).map { |c| OpenLibrary::OCLC(c) }.to_a,
        :lc_classifications => (r[:lc_classifications] or []),
        :created => r[:created][:value],
        :last_modified => r[:last_modified][:value]
      })
    end
  end

  class EditionContract < Dry::Validation::Contract
    json do
      required(:title).value(:string)
      required(:authors).array(:hash) do
        required(:key).value(:string)
      end
      required(:key).value(:string)
      required(:source_records).array(:string)
      required(:works).array(:hash) do
        required(:key).value(:string)
      end

      # extra info
      optional(:full_title).value(:string)
      optional(:number_of_pages).value(:integer)
      optional(:publishers).array(:string)
      optional(:covers).array(:integer)
      optional(:publish_date).value(:string)
      optional(:physical_format).value(:string)

      # ids
      optional(:isbn_10).array(:string)
      optional(:isbn_13).array(:string)
      optional(:lccn).array(:string)
      optional(:oclc_numbers).array(:string)
      optional(:lc_classifications).array(:string)

      # time

      required(:last_modified).hash do
        required(:type).value(:string, eql?: "/type/datetime")
        required(:value).value(Types::JSON::DateTime)
      end
      required(:created).hash do
        required(:type).value(:string, eql?: "/type/datetime")
        required(:value).value(Types::JSON::DateTime)
      end
    end
  end
end
