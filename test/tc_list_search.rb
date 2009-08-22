# $Id: tc_list_search.rb,v 1.2 2009/06/03 22:32:42 ianmacd Exp $
#

require 'test/unit'
require './setup'

class TestListSearch < AWSTest

  def test_list_search

    @req.locale = 'us'
    rg = ResponseGroup.new( :ListInfo )
    ls = ListSearch.new( 'WishList', { 'Name' => 'Peter Duff' } )
    response = @req.search( ls, rg )

    lists = response.kernel

    assert( lists.collect { |l| l.list_id }.include?( '18Y9QEW3A4SRY' ) )

  end

  def test_list_search_no_response_group

    @req.locale = 'us'
    ls = ListSearch.new( 'WishList', { 'Name' => 'Peter Duff' } )
    ls.response_group = ResponseGroup.new( :ListMinimum )
    response = @req.search( ls, nil )

    lists = response.kernel

    assert( lists.collect { |l| l.list_id }.include?( '18Y9QEW3A4SRY' ) )

  end

  def test_list_search_class_method

    response = Amazon::AWS.list_search( 'WishList', { :Name => 'Peter Duff' } )

    lists = response.kernel

    assert( lists.size > 5 )

  end

  def test_item_search_class_method_block

    Amazon::AWS.list_search( 'WishList', { 'Name' => 'Peter Duff' } ) do |r|

      lists = r.kernel

      assert( lists.size > 5 )
    end
  end

end
