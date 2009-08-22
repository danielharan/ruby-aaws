# $Id: tc_list_lookup.rb,v 1.2 2009/06/03 22:33:04 ianmacd Exp $
#

require 'test/unit'
require './setup'

class TestListLookup < AWSTest

  def test_list_lookup

    @req.locale = 'us'
    rg = ResponseGroup.new( :ListInfo )
    ll = ListLookup.new( '3TV12MGLOJI4R', :WishList )
    response = @req.search( ll, rg )

    list = response.kernel

    assert_equal( '2008-06-30', list.date_created )

  end

  def test_list_lookup_no_response_group

    @req.locale = 'us'
    ll = ListLookup.new( '3P722DU4KUPCP', 'Listmania' )
    ll.response_group = ResponseGroup.new( :ListInfo, :Small )
    response = @req.search( ll, nil )

    list = response.kernel

    assert_equal( 'Computer History', list.list_name )

  end

  def test_list_lookup_class_method

    response = Amazon::AWS.list_lookup( 'R35BA7X0YD3YP', 'Listmania' )

    list = response.kernel

    assert_equal( 'examples of perfection', list.list_name )

  end

  def test_item_search_class_method_block

    Amazon::AWS.list_lookup( 'R35BA7X0YD3YP', :Listmania ) do |r|

      list = r.kernel

      assert_equal( 'examples of perfection', list.list_name )
    end
  end

end
