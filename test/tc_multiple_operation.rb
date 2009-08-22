# $Id: tc_multiple_operation.rb,v 1.3 2009/06/15 21:21:02 ianmacd Exp $
#

require 'test/unit'
require './setup'

class TestMultipleOperation < AWSTest

  def test_unbatched_multiple_same_class_with_separate_response_groups
    il = ItemLookup.new( 'ASIN', { 'ItemId' => 'B000AE4QEC',
				   'MerchantId' => 'Amazon' } )
    il2 = ItemLookup.new( 'ASIN', { 'ItemId' => 'B000051WBE',
				    'MerchantId' => 'Amazon' } )

    il.response_group = ResponseGroup.new( :Large )
    il2.response_group = ResponseGroup.new( :Small )

    # Create a multiple operation of the ItemSearch operation and the two
    # batched ItemLookup operations.
    #
    mo = MultipleOperation.new( il, il2 )
    response = @req.search( mo, nil )
    mor = response.multi_operation_response[0]

    # Ensure our separate response groups were used.
    #
    arguments = mor.operation_request.arguments.argument

    il_rg = arguments.select do |arg|
      arg.attrib['name'] == 'ItemLookup.1.ResponseGroup'
    end[0]

    il2_rg = arguments.select do |arg|
      arg.attrib['name'] == 'ItemLookup.2.ResponseGroup'
    end[0]

    assert_equal( 'Large', il_rg.attrib['value'] )
    assert_equal( 'Small', il2_rg.attrib['value'] )

    # Ensure we received a MultiOperationResponse.
    #
    assert_instance_of( Amazon::AWS::AWSObject::MultiOperationResponse, mor )
    
    # Ensure response contains an ItemLookupResponse.
    #
    assert_instance_of( Amazon::AWS::AWSObject::ItemLookupResponse,
		        mor.item_lookup_response[0] )
 
    il_set = mor.item_lookup_response[0].items
    il_arr1 = il_set[0].item
    il_arr2 = il_set[1].item

    # Ensure that there are two <ItemSet>s for the ItemLookup, because it was
    # a batched operation.
    #
    assert_equal( 2, il_set.size )

    # Assure that all item sets have some results.
    #
    assert( il_arr1.size > 0 )
    assert( il_arr2.size > 0 )
  end

  def test_batched_multiple_with_separate_response_groups
    il = ItemLookup.new( 'ASIN', { 'ItemId' => 'B000AE4QEC',
				   'MerchantId' => 'Amazon' } )
    il2 = ItemLookup.new( 'ASIN', { 'ItemId' => 'B000051WBE',
				    'MerchantId' => 'Amazon' } )
    il3 = ItemLookup.new( 'ASIN', { 'ItemId' => 'B00061F8LO',
				    'MerchantId' => 'Amazon' } )

    il.response_group = ResponseGroup.new( :Large )
    il2.response_group = ResponseGroup.new( :Small )

    # Create a batch request of the two ItemLookup operations.
    #
    il.batch( il2 )

    is = ItemSearch.new( 'Books', { 'Title' => 'Ruby' } )
    is.response_group = ResponseGroup.new( :Medium, :Tags )

    # Create a multiple operation of the ItemSearch operation and the two
    # batched ItemLookup operations.
    #
    mo = MultipleOperation.new( is, il )
    response = @req.search( mo, nil )
    mor = response.multi_operation_response[0]

    # Batch a third ItemLookup operation.
    #
    il.batch( il3 )
    mo = MultipleOperation.new( is, il )

    # Because exception classes aren't created until an exception occurs, we
    # need to create the one we wish to test for now, otherwise we can't refer
    # to it in our code without causing an 'uninitialized constant' error.
    #
    Amazon::AWS::Error.const_set( 'ExceededMaxBatchRequestsPerOperation',
				  Class.new( Amazon::AWS::Error::AWSError ) )

    # Attempt to perform the search.
    #
    assert_raise( Amazon::AWS::Error::ExceededMaxBatchRequestsPerOperation ) do
      @req.search( mo, nil )
    end

    # Ensure our separate response groups were used.
    #
    arguments = mor.operation_request.arguments.argument

    il_rg = arguments.select do |arg|
      arg.attrib['name'] == 'ItemLookup.1.ResponseGroup'
    end[0]

    il2_rg = arguments.select do |arg|
      arg.attrib['name'] == 'ItemLookup.2.ResponseGroup'
    end[0]

    is_rg = arguments.select do |arg|
      arg.attrib['name'] == 'ItemSearch.1.ResponseGroup'
    end[0]

    assert_equal( 'Large', il_rg.attrib['value'] )
    assert_equal( 'Small', il2_rg.attrib['value'] )
    assert_equal( 'Medium,Tags', is_rg.attrib['value'] )

    # Ensure we received a MultiOperationResponse.
    #
    assert_instance_of( Amazon::AWS::AWSObject::MultiOperationResponse, mor )
    
    # Ensure response contains an ItemSearchResponse.
    #
    assert_instance_of( Amazon::AWS::AWSObject::ItemSearchResponse,
		        mor.item_search_response[0] )

    # Ensure response also contains an ItemLookupResponse.
    #
    assert_instance_of( Amazon::AWS::AWSObject::ItemLookupResponse,
		        mor.item_lookup_response[0] )
 
    is_set = mor.item_search_response[0].items
    il_set = mor.item_lookup_response[0].items
    is_arr = is_set.item
    il_arr1 = il_set[0].item
    il_arr2 = il_set[1].item

    # Ensure that there's one <ItemSet> for the ItemSearch.
    #
    assert_equal( 1, is_set.size )

    # Ensure that there are two <ItemSet>s for the ItemLookup, because it was
    # a batched operation.
    #
    assert_equal( 2, il_set.size )

    # Assure that all item sets have some results.
    #
    assert( is_arr.size > 0 )
    assert( il_arr1.size > 0 )
    assert( il_arr2.size > 0 )
  end


  def test_batched_multiple_with_shared_response_group
    il = ItemLookup.new( 'ASIN', { 'ItemId' => 'B000AE4QEC',
				   'MerchantId' => 'Amazon' } )
    il2 = ItemLookup.new( 'ASIN', { 'ItemId' => 'B000051WBE',
				    'MerchantId' => 'Amazon' } )

    # Create a batch request of the two ItemLookup operations.
    #
    il.batch( il2 )

    is = ItemSearch.new( 'Books', { 'Title' => 'Ruby' } )

    # Create a multiple operation of the ItemSearch operation and the two
    # batched ItemLookup operations.
    #
    mo = MultipleOperation.new( is, il )
    
    response = @req.search( mo, @rg )

    mor = response.multi_operation_response[0]

    # Ensure we received a MultiOperationResponse.
    #
    assert_instance_of( Amazon::AWS::AWSObject::MultiOperationResponse, mor )
    
    # Ensure response contains an ItemSearchResponse.
    #
    assert_instance_of( Amazon::AWS::AWSObject::ItemSearchResponse,
		        mor.item_search_response[0] )

    # Ensure response also contains an ItemLookupResponse.
    #
    assert_instance_of( Amazon::AWS::AWSObject::ItemLookupResponse,
		        mor.item_lookup_response[0] )
 
    is_set = response.multi_operation_response.item_search_response[0].items
    il_set = response.multi_operation_response.item_lookup_response[0].items
    is_arr = is_set.item
    il_arr1 = il_set[0].item
    il_arr2 = il_set[1].item

    # Ensure that there's one <ItemSet> for the ItemSearch.
    #
    assert_equal( 1, is_set.size )

    # Ensure that there are two <ItemSet>s for the ItemLookup, because it was
    # a batched operation.
    #
    assert_equal( 2, il_set.size )

    # Assure that all item sets have some results.
    #
    assert( is_arr.size > 0 )
    assert( il_arr1.size > 0 )
    assert( il_arr2.size > 0 )
  end

  def test_multiple_class_method
    il = ItemLookup.new( 'ASIN', { 'ItemId' => 'B000AE4QEC',
				   'MerchantId' => 'Amazon' } )
    il.response_group = ResponseGroup.new( :Large )

    is = ItemSearch.new( 'Books', { 'Title' => 'Ruby' } )
    is.response_group = ResponseGroup.new( :Medium, :Tags )

    response = Amazon::AWS.multiple_operation( is, il )
    mor = response.multi_operation_response[0]

    # Ensure we received a MultiOperationResponse.
    #
    assert_instance_of( Amazon::AWS::AWSObject::MultiOperationResponse, mor )
    
    # Ensure response contains an ItemSearchResponse.
    #
    assert_instance_of( Amazon::AWS::AWSObject::ItemSearchResponse,
		        mor.item_search_response[0] )

    # Ensure response also contains an ItemLookupResponse.
    #
    assert_instance_of( Amazon::AWS::AWSObject::ItemLookupResponse,
		        mor.item_lookup_response[0] )
 
    is_set = response.multi_operation_response.item_search_response[0].items
    il_set = response.multi_operation_response.item_lookup_response[0].items
    is_arr = is_set.item
    il_arr = il_set[0].item

    # Ensure that there's one <ItemSet> for the ItemSearch.
    #
    assert_equal( 1, is_set.size )

    # Ensure that there's one <ItemSet> for the ItemLookup.
    #
    assert_equal( 1, il_set.size )

    # Assure that all item sets have some results.
    #
    assert( is_arr.size > 0 )
    assert( il_arr.size > 0 )
  end

end
