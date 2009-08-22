# $Id: tc_seller_listing_search.rb,v 1.1 2009/05/30 23:27:47 ianmacd Exp $
#

require 'test/unit'
require './setup'

class TestSellerListingSearch < AWSTest

  def test_seller_listing_search

    sl = SellerListingSearch.new( 'AP8U6Y3PYQ9VO',
				  { 'Keywords' => 'Killing Joke' } )
    rg = ResponseGroup.new( 'SellerListing' )
    response = @req.search( sl, rg )

    items = response.seller_listing_search_response[0].seller_listings[0].
	    seller_listing


    # Ensure we got some actual items back.
    #
    assert( items.size > 0 )

  end

  def test_seller_listing_search_no_response_group

    sl = SellerListingSearch.new( 'AP8U6Y3PYQ9VO',
				  { 'Keywords' => 'Killing Joke' } )
    sl.response_group = ResponseGroup.new( :SellerListing )
    response = @req.search( sl )

    items = response.seller_listing_search_response[0].seller_listings[0].
	    seller_listing

    # Ensure we got some actual items back.
    #
    assert( items.size > 0 )

  end

  def test_seller_listing_search_class_method

    response = Amazon::AWS.seller_listing_search( 'AP8U6Y3PYQ9VO',
					    { 'Keywords' => 'Killing Joke' } )

    items = response.seller_listing_search_response[0].seller_listings[0].
	    seller_listing

    # Ensure we got some actual items back.
    #
    assert( items.size > 0 )

  end

  def test_seller_listing_search_class_method_block

    Amazon::AWS.seller_listing_search( 'AP8U6Y3PYQ9VO',
				      { 'Keywords' => 'Killing Joke' } ) do |r|

      items = r.seller_listing_search_response[0].seller_listings[0].
	      seller_listing

      # Ensure we got some actual items back.
      #
      assert( items.size > 0 )
    end
  end

end
