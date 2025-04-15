require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'  # Adjust this filter to exclude directories like your test files
end

require 'rspec'

require File.join(File.dirname(__FILE__), './src/gilded_rose')

describe GildedRose do

  let(:normal_item) {Item.new(name="Normal Long Sword", sell_in=10, quality=20)}

  let(:expired_item) {Item.new(name="Expired Cheese", sell_in=0, quality=10)}

  let(:trash_item) {Item.new(name="Rusted Sword", sell_in=0, quality=0)}

  let(:aged_brie) {Item.new(name="Aged Brie", sell_in=10, quality=0)}

  let(:expired_aged_brie) {Item.new(name="Aged Brie", sell_in=0, quality=10)}

  let(:sulfuras) {Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80)}

  let(:conjured) {Item.new(name="Conjured Mana Cake", sell_in=3, quality=6)}

  let(:items) {[normal_item, expired_item, aged_brie, sulfuras, conjured, expired_aged_brie]}

  let(:gilded_rose) {GildedRose.new(items)}

  it "the quality of an item must never be negative" do
    gilded_rose.update_quality
    expect(trash_item.quality).to eq(0)
  end

  it "should decrease the both quality and sell in by 1 each day" do
    original_quality = normal_item.quality
    original_sell_in = normal_item.sell_in

    gilded_rose.update_quality

    expect(normal_item.quality).to eq(original_quality - 1)
    expect(normal_item.sell_in).to eq(original_sell_in - 1)
  end

  it "once the sell in date is passed the quality should decrease twice as fast" do
    original_quality = expired_item.quality

    gilded_rose.update_quality

    expect(expired_item.quality).to eq(original_quality - 2)
  end

  it "update quality for 'Aged Brie' is an item that will increase the quality by 1 per day the older it's get" do
    gilded_rose.update_quality
    expect(aged_brie.quality).to eq 1
    
  end

  it "update quality for expired 'Aged Brie' by 2 when sell in is negative" do
    gilded_rose.update_quality
    expect(expired_aged_brie.quality).to eq 12
  end

  it "update quality for 'Sulfuras' is a legendary item which will not decrease in quality and never has to be sold" do
    gilded_rose.update_quality
    expect(sulfuras.quality).to eq sulfuras.quality
    expect(sulfuras.sell_in).to eq sulfuras.sell_in
  end

  it "updates quality for 'Backstage passes to concert' which is a item which will increase it quality by 2 when sell in <= 10, increase by 3 when sell in <= 5 but quality will drop to 0 if sell in = 0" do
    # 15 days
    long_before_concert = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20)

    # 10 days
    close_to_concert = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=20)
    
    # 5 days
    imminent_to_concert = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=20)
    
    # After concert
    concert_over = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=0, quality=20)

    GildedRose.new([long_before_concert, close_to_concert, imminent_to_concert, concert_over]).update_quality

    expect(long_before_concert.quality).to eq 21
    expect(close_to_concert.quality).to eq 22
    expect(imminent_to_concert.quality).to eq 23
    expect(concert_over.quality).to eq 0
  end

  it "the quality of an item must not exceed 50" do
    concert_pass = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=2, quality=49)
    # except for legendary item "Sulfuras"
    GildedRose.new([concert_pass, sulfuras]).update_quality
    expect(concert_pass.quality).to eq 50
    expect(sulfuras.quality).to eq 80
  end

  # This doesn't work yet
  it "decrease the quality of the conjured item by 2 (twice as fast)" do
    gilded_rose.update_quality

    expect(conjured.quality).to eq 4
  end
end
