# $Id: tc_item_lookup.rb,v 1.2 2009/05/30 11:11:27 ianmacd Exp $
#

require 'test/unit'
require './setup'

class TestItemLookup < AWSTest

  def test_item_lookup

    is = ItemLookup.new( 'ASIN', { 'ItemId' => 'B000AE4QEC' } )
    response = @req.search( is, @rg )

    results = response.kernel

    # Ensure we got some actual results back.
    #
    assert( results.size > 0 )

  end

  def test_item_lookup_no_response_group

    is = ItemLookup.new( 'ASIN', { 'ItemId' => 'B000AE4QEC' } )
    is.response_group = ResponseGroup.new( :Small )
    response = @req.search( is, nil )

    results = response.kernel

    # Ensure we got more than 10 results back.
    #
    assert( results.size > 0 )

  end

  def test_item_lookup_class_method

    response = Amazon::AWS.item_lookup( 'ASIN', { 'ItemId' => 'B000AE4QEC' } )

    results = response.kernel

    # Ensure we got some actual results back.
    #
    assert( results.size > 0 )

  end

  def test_item_search_class_method_block

    Amazon::AWS.item_lookup( 'ASIN', { 'ItemId' => 'B000AE4QEC' } ) do |r|

      results = r.kernel

      # Ensure we got some actual results back.
      #
      assert( results.size > 0 )
    end
  end

end
