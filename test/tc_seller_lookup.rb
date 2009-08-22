# $Id: tc_seller_lookup.rb,v 1.1 2009/06/03 09:53:02 ianmacd Exp $
#

require 'test/unit'
require './setup'

class TestSellerLookup < AWSTest

  def test_seller_lookup

    sl = SellerLookup.new( 'A3QFR0K2KCB7EG' )
    rg = ResponseGroup.new( 'Seller' )
    response = @req.search( sl, rg )

    seller = response.kernel

    assert_equal( 'wherehouse', seller.nickname )

  end

  def test_seller_lookup_no_response_group

    sl = SellerLookup.new( 'A3QFR0K2KCB7EG' )
    sl.response_group = ResponseGroup.new( :Seller )
    response = @req.search( sl )

    seller = response.kernel

    assert_equal( 'wherehouse', seller.nickname )

  end

  def test_seller_lookup_class_method

    response = Amazon::AWS.seller_lookup( 'A3QFR0K2KCB7EG' )

    seller = response.kernel

    assert_equal( 'wherehouse', seller.nickname )

  end

  def test_seller_lookup_class_method_block

    Amazon::AWS.seller_lookup( 'A3QFR0K2KCB7EG' ) do |r|

      seller = r.kernel

      assert_equal( 'wherehouse', seller.nickname )

    end
  end

end
