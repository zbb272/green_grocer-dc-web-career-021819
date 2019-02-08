def consolidate_cart(cart)
  new_cart = {}
  cart.each do | cart_item |
    cart_item.each do | item_name, attributes | 
      if new_cart.has_key?(item_name)
        new_cart[item_name][:count] += 1 
      else 
        new_cart[item_name] = attributes
        new_cart[item_name][:count] = 1 
      end 
    end 
  end 
  new_cart
end

# given 
# [
#   {"AVOCADO" => {:price => 3.0, :clearance => true }},
#   {"AVOCADO" => {:price => 3.0, :clearance => true }},
#   {"KALE"    => {:price => 3.0, :clearance => false}}
# ]
# return 
# {
#   "AVOCADO" => {:price => 3.0, :clearance => true, :count => 2},
#   "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
# }

def apply_coupons(cart, coupons)
  new_cart = {}
  # coupons.each do | coupon |
  #   if cart.has_key?(coupon[:item])
  #     if new_cart.has_key?("#{coupon[:item]} W/COUPON")
  #       new_cart["#{coupon[:item]} W/COUPON"][:count] += 1
  #       cart[coupon[:item]][:count] -= coupon[:num]
  #     else 
  #       new_cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => 1}
  #       cart[coupon[:item]][:count] -= coupon[:num]
  #     end 
  #   end 
  # end 
  
  coupons.each do | coupon |
    cart.each do | item, item_details |
      if item == coupon[:item] && coupon[:num] >= item_details[:count]
        puts "#{item} == #{coupon[:item]}"
        puts "#{coupon[:num]} >= #{item_details[:count]}"
        if new_cart.has_key?("#{coupon[:item]} W/COUPON")
          new_cart["#{coupon[:item]} W/COUPON"][:count] += 1
          item_details[:count] -= coupon[:num]
        else 
          new_cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => item_details[:clearance], :count => 1}
          item_details[:count] -= coupon[:num]
        end 
      end 
    end 
  end 
  
  cart.delete_if do | item, item_details |
    item_details[:count] == 0 
  end 
  
  # new_cart.each do | item, item_details |
  #   coupons.each_with_index do | coupon, index |
  #     if item == coupon[:item] && coupon[:num] >= item_details[:count]
  #       if new_cart.has_key?("#{coupon[:item]} W/COUPON")
  #         new_cart["#{coupon[:item]} W/COUPON"][:count] += 1
  #         item_details[:count] -= coupon[:num]
          
  #         coupons.slice!(index)
  #       else 
  #         new_cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => item_details[:clearance], :count => 1}
  #         item_details[:count] -= coupon[:num]
          
  #         coupons.slice!(index)
  #       end 
  #     end 
  #   end 
  # end 
  
  puts cart 
  
  cart 
  
  new_cart = new_cart.merge(cart)
end

# given 
# {
#   "AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
#   "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
# }
# and 
# [{:item => "AVOCADO", :num => 2, :cost => 5.0}]
# return 
# {
#   "AVOCADO" => {:price => 3.0, :clearance => true, :count => 1},
#   "KALE"    => {:price => 3.0, :clearance => false, :count => 1},
#   "AVOCADO W/COUPON" => {:price => 5.0, :clearance => true, :count => 1},
# }

def apply_clearance(cart)
  cart.each do | item, item_details |
    if item_details[:clearance] == true 
      item_details[:price] -= item_details[:price].to_f * (0.2)
    end 
  end 
  cart
end

def checkout(cart, coupons)
  
  new_cart = consolidate_cart(cart)
  new_cart = apply_coupons(new_cart, coupons)
  new_cart = apply_clearance(new_cart)
  
  total = 0.0
  new_cart.each do | item, item_details |
    total += item_details[:price] * item_details[:count]
  end 
  
  if total > 100
    total -= total * 0.1
  end 
  
  total
end
