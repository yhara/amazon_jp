$LOAD_PATH.unshift File.expand_path("../lib", File.dirname(__FILE__))
require 'amazon_jp'

describe AmazonJP::Book do
  it "should create an instance from url" do
    book = AmazonJP::Book.new("http://www.amazon.co.jp/dp/4839927847/")
    book.should be_kind_of(AmazonJP::Book)
  end
end
