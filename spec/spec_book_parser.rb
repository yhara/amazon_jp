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
    y = @parser.buy_x_get_y
    y.should be_kind_of(AmazonJP::Book)
    y.title.should == "実装パターン"
  end

  it "should extract 'purchase similarities'" do
    sims = @parser.purchase_similarities
    sims.size.should == 5
    sims.first.should be_kind_of(AmazonJP::Book)
    sims.first.title.should == "ゲームプログラマになる前に覚えておきたい技術"
  end

end
