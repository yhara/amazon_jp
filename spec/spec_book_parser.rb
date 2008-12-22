$LOAD_PATH.unshift File.expand_path("../lib", File.dirname(__FILE__))
require 'amazon_jp'

describe AmazonJP::Book::Parser do
  before :all do
    html_path = File.expand_path("html/book_page.html", 
                                 File.dirname(__FILE__))
    html = File.read(html_path)
    @parser = AmazonJP::Book::Parser.new(html)
  end

  it "should extract 'Buy X Get Y'" do
    y = @parser.bxgy
    y.should be_kind_of(AmazonJP::Book)
    y.title.should == "実装パターン"
  end

end
