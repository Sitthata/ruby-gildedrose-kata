require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  let(:normal_item) {Item.new(name="Normal Long Sword", sell_in=10, quality=20)}

  let(:expired_item) {Item.new(name="Expired Cheese", sell_in=0, quality=10)}

  let(:trash_item) {Item.new(name="Rusted Sword", sell_in=0, quality=0)}

  let(:items) {[normal_item, expired_item]}
  
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

  it "the quality of an item must not exceed 50" do
    items = [Item.new(name="+5 Dexterity Vest", sell_in=10, quality=60)]
    expect {
      GildedRose.new(items)
    }.to raise_error(ArgumentError, "quality of normal item is exceeding 50")
  end
end
