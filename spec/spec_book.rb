$LOAD_PATH.unshift File.expand_path("../lib", File.dirname(__FILE__))
require 'amazon_jp'

describe AmazonJP::Book do

  before :all do
    @book = AmazonJP::Book.new("http://www.amazon.co.jp/dp/4839927847/")
  end

  it "should extract 'Buy X Get Y'" do
    b = @book.buy_x_get_y
    b.should be_kind_of(AmazonJP::Book)
  end

  it "should extract 'purchase similarities'" do
    sims = @book.purchase_similarities
    sims.size.should == 5
    sims.first.should be_kind_of(AmazonJP::Book)
  end

end
