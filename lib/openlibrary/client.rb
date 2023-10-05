require "faraday"
require "faraday/follow_redirects"
require "faraday/http_cache"

module OpenLibrary
  UserAgent =
    class Client
      def initialize
        api_opts = {
          :headers => { "User-Agent" => "RubyOpenLibrary/0.0.1 +https://github.com/kore-signet/openlibrary" },
          :url => "https://openlibrary.org",
        }

        cover_opts = {
          :headers => { "User-Agent" => "RubyOpenLibrary/0.0.1 +https://github.com/kore-signet/openlibrary" },
          :url => "https://covers.openlibrary.org",
        }

        @api = Faraday.new api_opts do |f|
          f.response :json
          f.response :raise_error
          f.response :follow_redirects
          f.use :http_cache
        end

        @cover_api = Faraday.new cover_opts do |f|
          f.response :raise_error
          f.response :follow_redirects
        end
      end

      def work(id, include_editions: false)
        path = case
        when (id.is_a? String and id.start_with? "OL")
          "/works/#{id}.json"
        when (id.is_a? Key::OLID and id.type == "works")
          "#{id.as_ol_path}.json"
        when id.is_a?(Key::ISBN)
          return work_by_isbn(id, include_editions: include_editions)
        else
          raise WrongIdKind
        end

        work = @api.get path
        eds = if include_editions then work_editions(id) else [] end

        OpenLibrary::Work.parse work.body, editions: eds
      end

      def cover(id, size: CoverSize::Small)
        res = @cover_api.get "/b#{id.as_ol_cover_path}-#{size}.jpg"
        res.body
      end

      def work_by_isbn(id, **kwargs)
        ed = self.edition id
        self.work(ed.works[0], **kwargs)
      end

      def edition(id)
        path = case
        when (id.is_a? String and id.start_with? "OL")
          "/books/#{id}.json"
        when (id.is_a? Key::OLID and id.type == "books")
          "#{id.as_ol_path}.json"
        when id.is_a?(Key::ISBN)
          "#{id.as_ol_path}.json"
        else
          raise WrongIdKind
        end

        res = @api.get path
        OpenLibrary::Edition.parse res.body
      end

      def work_editions(id)
        path = case
        when (id.is_a? String and id.start_with? "OL")
          "/works/#{id}/editions.json"
        when (id.is_a? Key::OLID and id.type == "works")
          "#{id.as_ol_path}/editions.json"
        else
          raise WrongIdKind
        end

        res = @api.get path
        res.body["entries"].map { |b| OpenLibrary::Edition.parse b }.to_a
      end
    end
end
