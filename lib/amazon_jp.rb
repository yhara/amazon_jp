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

    def initialize(url, attrs={})
      @url = url
      attrs.each do |attr, value|
        self.__send__("#{attr}=", value)
      end
    end
    attr_reader :url
    lazy_attr :parser
    lazy_attr :title
    lazy_attr :buy_x_get_y, :purchase_similarities, :sales_rank

    def calculate_parser
      open(@url) do |f|
        Parser.new(f.read)
      end
    end

    def method_missing(name, *args)
      if name.to_s =~ /calculate_(.*)/ and parser.respond_to?($1)
        parser.__send__($1, *args)
      else
        super
      end
    end

    # should be override whenerver you use method_missing
    def respond_to?(name)
      name.to_s =~ /calculate_(.*)/ and parser.respond_to?($1)
    end

    class Parser

      class Error < StandardError; end

      def initialize(html)
        @doc = Hpricot(html.toutf8)
      end

      def buy_x_get_y
        para = @doc.search("p.bxgy-text").first
        raise Error, "<p class='bxgy-text'> not found" if para.nil?
        link = para.search("a").first

        Book.new(link["href"], :title => link.inner_text)
      end

      def purchase_similarities
        table = @doc.search("table.sims-faceouts").first
        raise Error, "<table class='sims-faceouts'> not found" if table.nil?
        table.search("td").map{|td|
          link = td.search("a")[1]
          raise Error, "'a' tag not found" if link.nil?
          Book.new(link["href"], :title => link.inner_text)
        }
      end

      def sales_rank
        li = @doc.search("li#SalesRank").first
        raise Error, "<li id='SalesRank'> not found" if li.nil?
        rank = li.inner_text[/([\d,]+)位/, 1].gsub(/,/, "").to_i

        rank
      end

    end

  end

end
