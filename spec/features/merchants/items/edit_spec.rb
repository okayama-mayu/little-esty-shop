require 'rails_helper'

RSpec.describe 'Merchant Items Edit Page' do
  before :each do
    @walmart = Merchant.create!(name: "Wal-Mart")

    @target = Merchant.create!(name: "Target")

    @costco = Merchant.create!(name: "Costco")

    @pencil = Item.create!( name: "Pencil",
                            description: "Sharpen it and write with it.",
                            unit_price: 199,
                            merchant_id: @walmart.id)

    @marker = Item.create!( name: "Marker",
                            description: "Washable!",
                            unit_price: 159,
                            merchant_id: @walmart.id)

    @eraser = Item.create!( name: "Eraser",
                            description: "Use it to fix mistakes.",
                            unit_price: 205,
                            merchant_id: @walmart.id)

    @highlighter = Item.create!( name: "Highlighter",
                            description: "Highlight things and make them yellow!",
                            unit_price: 305,
                            merchant_id: @target.id)
  end

  # User Story 8
  # Merchant Item Update

  # As a merchant,
  # When I visit the merchant show page of an item
  # I see a link to update the item information.
  # When I click the link
  # Then I am taken to a page to edit this item
  # And I see a form filled in with the existing item attribute information
  # When I update the information in the form and I click ‘submit’
  # Then I am redirected back to the item show page where I see the updated information
  # And I see a flash message stating that the information has been successfully updated.
  it 'has a form pre-filled with the existing attribute information for an item' do
    visit "/merchants/#{@walmart.id}/items/#{@pencil.id}/edit"
  
    within '#name-field' do
      expect(page).to have_field(:name, with: @pencil.name)
    end
    
    within '#description-field' do
      expect(page).to have_field(:description, with: @pencil.description)
    end

    within '#unit_price-field' do
      expect(page).to have_field(:unit_price, with: 199)
    end
  end

  it 'can update the information for an item' do
    visit "/merchants/#{@walmart.id}/items/#{@pencil.id}/edit"

    within '#name-field' do
      fill_in :name, with: "Mechanical Pencil"
    end
    
    within '#description-field' do
      fill_in :description, with: "You can refill it with lead!"
    end

    within '#unit_price-field' do
      fill_in :unit_price, with: 299
    end

    click_button 'Update Item'

    expect(current_path).to eq("/merchants/#{@walmart.id}/items/#{@pencil.id}")

    expect(page).to have_content("Item successfully updated!")
    expect(page).to have_content("Mechanical Pencil")
    expect(page).to have_content("You can refill it with lead!")
    expect(page).to have_content('$2.99')
    expect(page).to_not have_content("Sharpen it and write with it.")
    expect(page).to_not have_content(199)
  end
end