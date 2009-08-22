# $Id: tc_transaction_lookup.rb,v 1.1 2009/06/03 23:25:33 ianmacd Exp $
#

require 'test/unit'
require './setup'

class TestTransactionLookup < AWSTest

  def test_transaction_lookup

    @req.locale = 'us'
    tl = TransactionLookup.new( '103-5663398-5028241' )
    rg = ResponseGroup.new( :TransactionDetails )
    response = @req.search( tl, rg )

    trans = response.kernel

    assert_equal( '2008-04-13T23:49:38', trans.transaction_date )

  end

  def test_transaction_lookup_no_response_group

    @req.locale = 'us'
    tl = TransactionLookup.new( '103-5663398-5028241' )
    tl.response_group = ResponseGroup.new( :TransactionDetails )
    response = @req.search( tl, nil )

    trans = response.kernel

    assert_equal( '2008-04-13T23:49:38', trans.transaction_date )

  end

end
