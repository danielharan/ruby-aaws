# $Id: tc_tag_lookup.rb,v 1.1 2009/06/03 23:20:37 ianmacd Exp $
#

require 'test/unit'
require './setup'

class TestTagLookup < AWSTest

  def test_tag_lookup

    @req.locale = 'us'
    tl = TagLookup.new( 'Awful' )
    rg = ResponseGroup.new( :Tags, :TagsSummary )
    response = @req.search( tl, rg )

    tag = response.kernel

    assert_equal( '2005-11-21 16:46:53', tag.first_tagging.time )

  end

  def test_tag_lookup_no_response_group

    @req.locale = 'us'
    tl = TagLookup.new( 'Awful' )
    tl.response_group = ResponseGroup.new( :Tags, :TagsSummary )
    response = @req.search( tl, nil )

    tag = response.kernel

    assert_equal( '2005-11-21 16:46:53', tag.first_tagging.time )

  end

end
