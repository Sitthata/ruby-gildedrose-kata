class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      if item.name.downcase == "aged brie"
        update_aged_brie item
        next
      end
      
      if item.name == "Backstage passes to a TAFKAL80ETC concert"
        update_backstage_pass item
        next
      end

      if item.name.downcase.include? "conjured"
        update_conjured item
        next
      end
      
      update_standard_item item
    end
  end

  private

  def update_standard_item(item)
    item.sell_in -= 1
    if item.quality <= 0
      return
    end
      
    if item.sell_in <= 0
      item.quality -= 2
      return
    end

    item.quality -= 1
  end

  def update_aged_brie(aged_brie)
    aged_brie.sell_in -= 1

    if aged_brie.sell_in < 0 && aged_brie.quality <= 50
      aged_brie.quality += 2
    else
      aged_brie.quality += 1
    end
  end

  def update_backstage_pass(backstage_pass)
    backstage_pass.sell_in -= 1
    # return if backstage_pass.quality >= 50
    
    if backstage_pass.sell_in < 0
      backstage_pass.quality = 0
    elsif backstage_pass.sell_in < 5
      backstage_pass.quality += 3
    elsif backstage_pass.sell_in < 10
      backstage_pass.quality += 2
    else
      backstage_pass.quality += 1
    end
  end

  def update_conjured(conjured)
    conjured.sell_in -= 1
    if conjured.quality <= 0
      return
    end

    if conjured.sell_in <= 0
      conjured.quality -= 4
      return
    end

    conjured.quality -= 2
  end
end
