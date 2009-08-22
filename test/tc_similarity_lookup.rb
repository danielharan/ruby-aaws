# $Id: tc_similarity_lookup.rb,v 1.1 2009/06/03 10:29:24 ianmacd Exp $
#

require 'test/unit'
require './setup'

class TestSimilarityLookup < AWSTest

  def test_similarity_lookup

    sl = SimilarityLookup.new( [ 'B000AE4QEC', 'B000051WBE' ] )
    rg = ResponseGroup.new( :Subjects )
    response = @req.search( sl, rg )

    items = response.similarity_lookup_response[0].items

    assert_match( /^\w+/, items.item[0].subjects.subject[0] )
    assert_match( /^\w+/, items.item[1].subjects.subject[0] )

  end

  def test_similarity_lookup_no_response_group

    sl = SimilarityLookup.new( [ 'B000AE4QEC', 'B000051WBE' ] )
    sl.response_group = ResponseGroup.new( :Subjects )
    response = @req.search( sl, nil )

    items = response.similarity_lookup_response[0].items

    assert_match( /^\w+/, items.item[0].subjects.subject[0] )
    assert_match( /^\w+/, items.item[1].subjects.subject[0] )

  end

  def test_similarity_lookup_class_method

    response = Amazon::AWS.similarity_lookup( [ 'B000AE4QEC', 'B000051WBE' ] )

    items = response.similarity_lookup_response[0].items

    assert_match( /^http:/, items.item[0].detail_page_url )
    assert_match( /^http:/, items.item[1].detail_page_url )

  end

  def test_item_search_class_method_block

    Amazon::AWS.similarity_lookup( [ 'B000AE4QEC', 'B000051WBE' ] ) do |r|

    items = r.similarity_lookup_response[0].items

    assert_match( /^http:/, items.item[0].detail_page_url )
    assert_match( /^http:/, items.item[1].detail_page_url )

    end

  end

end
