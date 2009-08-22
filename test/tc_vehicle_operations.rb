#!/usr/bin/ruby -w
#
# $Id: tc_vehicle_operations.rb,v 1.1 2009/02/19 15:50:03 ianmacd Exp $

require 'test/unit'
require './setup'

class TestVehicles < AWSTest

  def test_vehicle_search
    @req.locale = 'us'

    # Get all cars for year 2008.
    #
    vs = VehicleSearch.new( { 'Year' => 2008 } )
    rg = ResponseGroup.new( 'VehicleMakes' )
    response = @req.search( vs, rg )

    makes = response.vehicle_search_response[0].vehicle_years[0].
	    vehicle_year[0].vehicle_makes[0].vehicle_make
    assert( makes.size > 0 )

    make_id = makes.find { |make| make.make_name == 'Audi' }.make_id.to_i


    # Get all Audi models from 2008.
    #
    vs = VehicleSearch.new( { 'Year' => 2008,
			      'MakeId' => make_id } )
    rg = ResponseGroup.new( 'VehicleModels' )
    response = @req.search( vs, rg )

    models = response.vehicle_search_response[0].vehicle_years[0].
	     vehicle_year[0].vehicle_makes[0].vehicle_make[0].
	     vehicle_models[0].vehicle_model
    assert( models.size > 0 )

    model_id = models.find { |model| model.model_name == 'R8' }.model_id.to_i

    # Get all Audi R8 trim packages from 2008.
    #
    vs = VehicleSearch.new( { 'Year' => 2008,
			      'MakeId' => make_id,
			      'ModelId' => model_id } )
    rg = ResponseGroup.new( 'VehicleTrims' )
    response = @req.search( vs, rg )

    trims = response.vehicle_search_response[0].vehicle_years[0].
	    vehicle_year[0].vehicle_makes[0].vehicle_make[0].
	    vehicle_models[0].vehicle_model[0].vehicle_trims[0].vehicle_trim
    assert( trims.size > 0 )

    trim_id = trims.find { |trim| trim.trim_name == 'Base' }.trim_id.to_i

    vs = VehicleSearch.new( { 'Year' => 2008,
			      'MakeId' => make_id,
			      'ModelId' => model_id,
			      'TrimId' => trim_id } )
    rg = ResponseGroup.new( 'VehicleOptions' )
    response = @req.search( vs, rg )

    options = response.vehicle_search_response[0].vehicle_years[0].
	      vehicle_year[0].vehicle_makes[0].vehicle_make[0].
	      vehicle_models[0].vehicle_model[0].vehicle_trims[0].
	      vehicle_trim[0].vehicle_options[0]
    engine = options.vehicle_engine_options.vehicle_engine
    engine_name = engine.engine_name
    engine_id = engine.engine_id
    assert_not_nil( engine_name )

    # Find parts for our 2008 Audi R8 with Base trim and whatever engine that
    # trim package has.
    #
    vps = VehiclePartSearch.new( 2008, make_id, model_id,
				 { 'TrimId' => trim_id,
				   'EngineId' => engine_id } )
    rg = ResponseGroup.new( 'VehicleParts' )
    response = @req.search( vps, rg )

    parts = response.vehicle_part_search_response[0].vehicle_parts[0].part
    assert( parts.size > 0 )

    # Now, we do a reverse look-up.
    #
    # Go through all parts and test to see if they fit in our 2008 Audi R8
    # Base trim. The answer should always be yes.
    #
    # part = parts[rand( parts.size - 1 )].item.asin

    parts.each do |part|
      vpl = VehiclePartLookup.new( part.item.asin,
				   { 'Year' => 2008,
				     'MakeId' => make_id,
				     'ModelId' => model_id,
				     'TrimId' => trim_id } )

      rg = ResponseGroup.new( 'VehiclePartFit' )
      response = @req.search( vpl, rg )

      fit = response.vehicle_part_lookup_response[0].vehicle_parts[0].part.
            vehicle_part_fit.is_fit
      assert_equal( 'YES', fit )
    end
   end

end
