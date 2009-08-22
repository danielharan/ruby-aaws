# $Id: tc_browse_node_lookup.rb,v 1.2 2009/06/02 00:39:43 ianmacd Exp $
#

require 'test/unit'
require './setup'

class TestBrowseNodeLookup < AWSTest

  def test_browse_node_lookup

    bnl = BrowseNodeLookup.new( 694212 )
    rg = ResponseGroup.new( :BrowseNodeInfo )

    response = @req.search( bnl, rg )

    results = response.kernel

    # Ensure we got some actual results back.
    #
    assert( results.size > 0 )

  end

  def test_browse_node_lookup_no_response_group

    bnl = BrowseNodeLookup.new( 694212 )
    bnl.response_group = ResponseGroup.new( :BrowseNodeInfo )
    response = @req.search( bnl, nil )

    results = response.kernel

    # Ensure we got more than 10 results back.
    #
    assert( results.size > 0 )

  end

  def test_browse_node_lookup_class_method

    response = Amazon::AWS.browse_node_lookup( 694212 )

    results = response.kernel

    # Ensure we got some actual results back.
    #
    assert( results.size > 0 )

  end

  def test_browse_node_lookup_class_method_block

    Amazon::AWS.browse_node_lookup( '694212' ) do |r|

      results = r.kernel

      # Ensure we got some actual results back.
      #
      assert( results.size > 0 )
    end
  end

end
