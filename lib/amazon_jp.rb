require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'kconv'

module LazyAttribute
  def lazy_attr_reader(*names)
    names.each do |name|
      module_eval <<-EOD
        def #{name}
          @#{name} ||= calculate_#{name}
        end
      EOD
    end
  end

  def lazy_attr(*names)
    lazy_attr_reader *names
    attr_writer *names
  end
end

module AmazonJP

  class Book
    extend LazyAttribute

    def initialize(url)
      @url = url
    end
    lazy_attr :parser
    lazy_attr :title, :bxgy

    def calculate_parser
      open(@url) do |f|
        Parser.new(f.read)
      end
    end

    def calculate_title
      parser.title
    end

    def calculate_bxgy
      parser.bxgy
    end

    class Parser

      class Error < StandardError; end

      def initialize(html)
        @doc = Hpricot(html.toutf8)
      end

      def bxgy
        para = @doc.search("p[@class=bxgy-text]").first
        raise Error, "<p class='bxgy-text'> not found" if para.nil?
        link = para.search("a").first

        y = Book.new(link["href"])
        y.title = link.inner_text
        y
      end

    end

  end

end
