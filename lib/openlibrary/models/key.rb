require "uri"

module OpenLibrary
  module Key
    class OLKey
      def kind
      end

      def id
      end

      def as_ol_path
        "/#{kind}/#{id}"
      end

      def as_ol_cover_path
        "/#{kind}/#{id}"
      end

      def to_s
        id
      end
    end

    class ISBN < OLKey
      def initialize(isbn)
        @isbn = isbn
      end

      def id
        @isbn
      end

      def kind
        "isbn"
      end
    end

    class LCCN < OLKey
      def initialize(lccn)
        @lccn = lccn
      end

      def id
        @lccn
      end

      def kind
        "lccn"
      end
    end

    class OCLC < OLKey
      def initialize(oclc)
        @oclc = oclc
      end

      def id
        @oclc
      end

      def kind
        "oclc"
      end
    end

    class CoverID < OLKey
      def initialize(cid)
        @cid = cid.to_s
      end

      def id
        @cid
      end

      def kind
        "coverid"
      end

      def as_ol_path
        raise "CoverID cannot be used to fetch books/works/authors/etc"
      end

      def as_ol_cover_path
        "/id/#{id}"
      end
    end

    class OLID < OLKey
      attr_reader :type

      def initialize(key)
        path = URI(key).path.split("/")
        @type = path[-2]
        @id = path[-1]
      end

      def kind
        "olid"
      end

      def id
        @id
      end

      def as_ol_path
        "/#{@type}/#{@id}"
      end

      def to_s
        as_ol_path
      end
    end
  end
end
