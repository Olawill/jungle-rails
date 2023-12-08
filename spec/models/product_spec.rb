require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    # validations test/exampled here
    before(:each) do
      @category = Category.find_or_create_by! name: "Test"
    end

    it "saves successfully with all four fields set" do
    
      product = @category.products.create!({
        name: "Example Product",
        description: "This is a sample product",
        price: 19.99,
        quantity: 5
      })
      expect(product.save).to be_truthy
    end

    it "requires name to be present" do

      product = Product.new({
        name: nil,
        description: "This is a sample product",
        price: 19.99,
        quantity: 5,
        category_id: @category.id
      })

      expect(product.save).to be_falsey
      expect(product.errors.full_messages).to include("Name can't be blank")
    end

    it "requires quantity to be present" do

      product = Product.new({
        name: "Example Product",
        description: nil,
        price: 19.99,
        quantity: nil,
        category_id: @category.id
      })

      expect(product.save).to be_falsey
      expect(product.errors.full_messages).to include("Quantity can't be blank")
    end

    it "requires price to be present" do
      product = Product.new({
        name: "Example Product",
        description: "This is a sample product",
        price_cents: nil,
        quantity: 5,
        category_id: @category.id
      })

      expect(product.save).to be_falsey
      expect(product.errors.full_messages).to include("Price can't be blank")
    end

    it "requires category to be present" do
      product = Product.new(
        name: "Example Product",
        description: "This is a sample product",
        price: 19.99,
        quantity: 5,
        category_id: nil
      )
      expect(product.save).to be_falsey
      expect(product.errors.full_messages).to include("Category can't be blank")
    end
    
  end
end
