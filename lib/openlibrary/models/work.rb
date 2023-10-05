# typed: false

module OpenLibrary
  class Work < Dry::Struct
    attribute :title, Types::String
    attribute :key, Types.Instance(Key::OLID)
    attribute :subjects, Types::Array.of(Types::String)
    attribute :covers, Types::Array.of(Types::Integer)
    attribute :authors, Types::Array do
      attribute :author, Types.Instance(Key::OLID)
      attribute :kind, Types::String
    end
    attribute :description, Types::String
    attribute :last_modified, Types::DateTime
    attribute :created, Types::DateTime
    attribute? :editions, Types::Array

    def self.parse(inp, editions: [])
      res = OpenLibrary::WorkContract.new.call inp
      res = res.to_h

      Work.new **{
        :title => res[:title],
        :key => OpenLibrary::OLID(res[:key]),
        :subjects => res[:subjects],
        :covers => res[:covers],
        :authors => res[:authors].map { |a| { :author => OpenLibrary::OLID(a[:author][:key]), :kind => a[:type][:key] } }.to_a,
        :description => if res[:description].is_a? Hash then res[:description]["value"] else res[:description] end,
        :created => res[:created][:value],
        :last_modified => res[:last_modified][:value],
        :editions => editions,
      }
    end
  end

  class WorkContract < Dry::Validation::Contract
    json do
      required(:title).value(:string)
      required(:key).value(:string)
      required(:subjects).array(:string)
      required(:covers).array(:integer)
      required(:authors).array(:hash) do
        required(:author).hash do
          required(:key).value(:string)
        end
        required(:type).hash do
          required(:key).value(:string)
        end
      end
      required(:description).value(Types::String | Types::Hash.schema(type: Types::String.constrained(eql: "type/text"), value: Types::String))
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
