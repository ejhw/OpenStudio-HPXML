def create_osws
  require 'json'
  require_relative 'HPXMLtoOpenStudio/resources/constants'
  require_relative 'HPXMLtoOpenStudio/resources/hpxml'

  this_dir = File.dirname(__FILE__)
  tests_dir = File.join(this_dir, 'BuildResidentialHPXML/tests')

  # Hash of OSW -> Parent OSW
  osws_files = {
    'base.osw' => nil, # single-family detached
    'base-single-family-attached.osw' => 'base.osw',
    'base-multifamily.osw' => 'base.osw',
    'base-appliances-dehumidifier.osw' => 'base.osw',
    'base-appliances-dehumidifier-50percent.osw' => 'base.osw',
    'base-appliances-dehumidifier-ief.osw' => 'base.osw',
    'base-appliances-gas.osw' => 'base.osw',
    'base-appliances-modified.osw' => 'base.osw',
    'base-appliances-none.osw' => 'base.osw',
    'base-appliances-oil.osw' => 'base.osw',
    'base-appliances-propane.osw' => 'base.osw',
    'base-appliances-wood.osw' => 'base.osw',
    # 'base-atticroof-cathedral.osw' => 'base.osw', # TODO: conditioned attic ceiling heights are greater than wall height
    # 'base-atticroof-conditioned.osw' => 'base.osw', # TODO: has both conditioned and unconditioned attics
    'base-atticroof-flat.osw' => 'base.osw',
    'base-atticroof-radiant-barrier.osw' => 'base.osw',
    'base-atticroof-unvented-insulated-roof.osw' => 'base.osw',
    'base-atticroof-vented.osw' => 'base.osw',
    'base-dhw-combi-tankless.osw' => 'base.osw',
    'base-dhw-combi-tankless-outside.osw' => 'base.osw',
    # 'base-dhw-desuperheater.osw' => 'base.osw', # Not supporting desuperheater for now
    # 'base-dhw-desuperheater-2-speed.osw' => 'base.osw', # Not supporting desuperheater for now
    # 'base-dhw-desuperheater-gshp.osw' => 'base.osw', # Not supporting desuperheater for now
    # 'base-dhw-desuperheater-hpwh.osw' => 'base.osw', # Not supporting desuperheater for now
    # 'base-dhw-desuperheater-tankless.osw' => 'base.osw', # Not supporting desuperheater for now
    # 'base-dhw-desuperheater-var-speed.osw' => 'base.osw', # Not supporting desuperheater for now
    'base-dhw-dwhr.osw' => 'base.osw',
    'base-dhw-indirect.osw' => 'base.osw',
    # 'base-dhw-indirect-dse.osw' => 'base.osw', # Not going to support DSE
    'base-dhw-indirect-outside.osw' => 'base.osw',
    'base-dhw-indirect-standbyloss.osw' => 'base.osw',
    'base-dhw-indirect-with-solar-fraction.osw' => 'base.osw',
    'base-dhw-jacket-electric.osw' => 'base.osw',
    'base-dhw-jacket-gas.osw' => 'base.osw',
    'base-dhw-jacket-hpwh.osw' => 'base.osw',
    'base-dhw-jacket-indirect.osw' => 'base.osw',
    'base-dhw-low-flow-fixtures.osw' => 'base.osw',
    # 'base-dhw-multiple.osw' => 'base.osw', # Not supporting multiple water heaters for now
    'base-dhw-none.osw' => 'base.osw',
    'base-dhw-recirc-demand.osw' => 'base.osw',
    'base-dhw-recirc-manual.osw' => 'base.osw',
    'base-dhw-recirc-nocontrol.osw' => 'base.osw',
    'base-dhw-recirc-temperature.osw' => 'base.osw',
    'base-dhw-recirc-timer.osw' => 'base.osw',
    'base-dhw-solar-direct-evacuated-tube.osw' => 'base.osw',
    'base-dhw-solar-direct-flat-plate.osw' => 'base.osw',
    'base-dhw-solar-direct-ics.osw' => 'base.osw',
    'base-dhw-solar-fraction.osw' => 'base.osw',
    'base-dhw-solar-indirect-flat-plate.osw' => 'base.osw',
    'base-dhw-solar-thermosyphon-flat-plate.osw' => 'base.osw',
    'base-dhw-tank-gas.osw' => 'base.osw',
    'base-dhw-tank-gas-outside.osw' => 'base.osw',
    'base-dhw-tank-heat-pump.osw' => 'base.osw',
    'base-dhw-tank-heat-pump-outside.osw' => 'base.osw',
    'base-dhw-tank-heat-pump-with-solar.osw' => 'base.osw',
    'base-dhw-tank-heat-pump-with-solar-fraction.osw' => 'base.osw',
    'base-dhw-tankless-electric.osw' => 'base.osw',
    'base-dhw-tankless-electric-outside.osw' => 'base.osw',
    'base-dhw-tankless-gas.osw' => 'base.osw',
    'base-dhw-tankless-gas-with-solar.osw' => 'base.osw',
    'base-dhw-tankless-gas-with-solar-fraction.osw' => 'base.osw',
    'base-dhw-tankless-propane.osw' => 'base.osw',
    'base-dhw-tank-oil.osw' => 'base.osw',
    'base-dhw-tank-wood.osw' => 'base.osw',
    'base-dhw-uef.osw' => 'base.osw',
    'base-enclosure-2stories.osw' => 'base.osw',
    'base-enclosure-2stories-garage.osw' => 'base.osw',
    'base-enclosure-3d-coordinates.osw' => 'base.osw',
    # 'base-enclosure-attached-multifamily.osw' => 'base.osw',
    'base-enclosure-beds-1.osw' => 'base.osw',
    'base-enclosure-beds-2.osw' => 'base.osw',
    'base-enclosure-beds-4.osw' => 'base.osw',
    'base-enclosure-beds-5.osw' => 'base.osw',
    'base-enclosure-garage.osw' => 'base.osw',
    'base-enclosure-infil-cfm50.osw' => 'base.osw',
    'base-enclosure-infil-natural-ach.osw' => 'base.osw',
    # 'base-enclosure-other-heated-space.osw' => 'base.osw',
    # 'base-enclosure-other-housing-unit.osw' => 'base.osw',
    # 'base-enclosure-other-multifamily-buffer-space.osw' => 'base.osw',
    # 'base-enclosure-other-non-freezing-space.osw' => 'base.osw',
    'base-enclosure-overhangs.osw' => 'base.osw',
    # 'base-enclosure-skylights.osw' => 'base.osw', # There are no front roof surfaces, but 15.0 ft^2 of skylights were specified.
    # 'base-enclosure-split-surfaces.osw' => 'base.osw',
    # 'base-enclosure-walltypes.osw' => 'base.osw',
    # 'base-enclosure-windows-interior-shading.osw' => 'base.osw', # Not going to support interior shading by facade
    'base-enclosure-windows-none.osw' => 'base.osw',
    'base-foundation-ambient.osw' => 'base.osw',
    # 'base-foundation-complex.osw' => 'base.osw', # 1 kiva object instead of 10
    'base-foundation-conditioned-basement-slab-insulation.osw' => 'base.osw',
    # 'base-foundation-conditioned-basement-wall-interior-insulation.osw' => 'base.osw',
    # 'base-foundation-multiple.osw' => 'base.osw', # Not supporting multiple foundations for now
    'base-foundation-slab.osw' => 'base.osw',
    'base-foundation-unconditioned-basement.osw' => 'base.osw',
    # 'base-foundation-unconditioned-basement-above-grade.osw' => 'base.osw', # TODO: add foundation wall windows
    'base-foundation-unconditioned-basement-assembly-r.osw' => 'base.osw',
    'base-foundation-unconditioned-basement-wall-insulation.osw' => 'base.osw',
    'base-foundation-unvented-crawlspace.osw' => 'base.osw',
    'base-foundation-vented-crawlspace.osw' => 'base.osw',
    # 'base-foundation-walkout-basement.osw' => 'base.osw', # 1 kiva object instead of 4
    'base-hvac-air-to-air-heat-pump-1-speed.osw' => 'base.osw',
    'base-hvac-air-to-air-heat-pump-2-speed.osw' => 'base.osw',
    'base-hvac-air-to-air-heat-pump-var-speed.osw' => 'base.osw',
    'base-hvac-boiler-elec-only.osw' => 'base.osw',
    'base-hvac-boiler-gas-central-ac-1-speed.osw' => 'base.osw',
    'base-hvac-boiler-gas-only.osw' => 'base.osw',
    'base-hvac-boiler-oil-only.osw' => 'base.osw',
    'base-hvac-boiler-propane-only.osw' => 'base.osw',
    'base-hvac-boiler-wood-only.osw' => 'base.osw',
    'base-hvac-central-ac-only-1-speed.osw' => 'base.osw',
    'base-hvac-central-ac-only-2-speed.osw' => 'base.osw',
    'base-hvac-central-ac-only-var-speed.osw' => 'base.osw',
    'base-hvac-central-ac-plus-air-to-air-heat-pump-heating.osw' => 'base.osw',
    # 'base-hvac-dse.osw' => 'base.osw', # Not going to support DSE
    'base-hvac-dual-fuel-air-to-air-heat-pump-1-speed.osw' => 'base.osw',
    'base-hvac-dual-fuel-air-to-air-heat-pump-1-speed-electric.osw' => 'base.osw',
    'base-hvac-dual-fuel-air-to-air-heat-pump-2-speed.osw' => 'base.osw',
    'base-hvac-dual-fuel-air-to-air-heat-pump-var-speed.osw' => 'base.osw',
    'base-hvac-dual-fuel-mini-split-heat-pump-ducted.osw' => 'base.osw',
    'base-hvac-ducts-leakage-percent.osw' => 'base.osw',
    'base-hvac-elec-resistance-only.osw' => 'base.osw',
    'base-hvac-evap-cooler-furnace-gas.osw' => 'base.osw',
    'base-hvac-evap-cooler-only.osw' => 'base.osw',
    'base-hvac-evap-cooler-only-ducted.osw' => 'base.osw',
    'base-hvac-fireplace-wood-only.osw' => 'base.osw',
    'base-hvac-floor-furnace-propane-only.osw' => 'base.osw',
    # 'base-hvac-flowrate.osw' => 'base.osw', # Not going to support in the measure
    'base-hvac-furnace-elec-central-ac-1-speed.osw' => 'base.osw',
    'base-hvac-furnace-elec-only.osw' => 'base.osw',
    'base-hvac-furnace-gas-central-ac-2-speed.osw' => 'base.osw',
    'base-hvac-furnace-gas-central-ac-var-speed.osw' => 'base.osw',
    'base-hvac-furnace-gas-only.osw' => 'base.osw',
    'base-hvac-furnace-gas-room-ac.osw' => 'base.osw',
    'base-hvac-furnace-oil-only.osw' => 'base.osw',
    'base-hvac-furnace-propane-only.osw' => 'base.osw',
    'base-hvac-furnace-wood-only.osw' => 'base.osw',
    # 'base-hvac-furnace-x3-dse.osw' => 'base.osw', # Not going to support DSE
    'base-hvac-ground-to-air-heat-pump.osw' => 'base.osw',
    # 'base-hvac-ideal-air.osw' => 'base.osw',
    'base-hvac-mini-split-heat-pump-ducted.osw' => 'base.osw',
    'base-hvac-mini-split-heat-pump-ducted-cooling-only.osw' => 'base.osw',
    'base-hvac-mini-split-heat-pump-ducted-heating-only.osw' => 'base.osw',
    'base-hvac-mini-split-heat-pump-ductless.osw' => 'base.osw',
    # 'base-hvac-multiple.osw' => 'base.osw', # Not supporting multiple heating/cooling systems for now
    # 'base-hvac-multiple2.osw' => 'base.osw', # Not supporting multiple heating/cooling systems for now
    'base-hvac-none.osw' => 'base.osw',
    # 'base-hvac-none-no-fuel-access.osw' => 'base.osw', # Doesn't affect model
    'base-hvac-portable-heater-electric-only.osw' => 'base.osw',
    'base-hvac-programmable-thermostat.osw' => 'base.osw',
    'base-hvac-room-ac-only.osw' => 'base.osw',
    'base-hvac-room-ac-only-33percent.osw' => 'base.osw',
    'base-hvac-setpoints.osw' => 'base.osw',
    'base-hvac-stove-oil-only.osw' => 'base.osw',
    'base-hvac-stove-wood-pellets-only.osw' => 'base.osw',
    'base-hvac-undersized.osw' => 'base.osw',
    'base-hvac-wall-furnace-elec-only.osw' => 'base.osw',
    'base-location-baltimore-md.osw' => 'base.osw',
    'base-location-dallas-tx.osw' => 'base.osw',
    'base-location-duluth-mn.osw' => 'base.osw',
    'base-location-epw-filepath.osw' => 'base.osw',
    'base-location-epw-filepath-AMY-2012.osw' => 'base.osw',
    'base-location-miami-fl.osw' => 'base.osw',
    'base-mechvent-balanced.osw' => 'base.osw',
    'base-mechvent-bath-kitchen-fans.osw' => 'base.osw',
    'base-mechvent-cfis.osw' => 'base.osw',
    # 'base-mechvent-cfis-dse.osw' => 'base.osw', # Not going to support DSE
    'base-mechvent-cfis-evap-cooler-only-ducted.osw' => 'base.osw',
    'base-mechvent-erv.osw' => 'base.osw',
    'base-mechvent-erv-atre-asre.osw' => 'base.osw',
    'base-mechvent-exhaust.osw' => 'base.osw',
    # 'base-mechvent-exhaust-rated-flow-rate.osw' => 'base.osw', # No difference
    'base-mechvent-hrv.osw' => 'base.osw',
    'base-mechvent-hrv-asre.osw' => 'base.osw',
    'base-mechvent-supply.osw' => 'base.osw',
    'base-misc-ceiling-fans.osw' => 'base.osw',
    # 'base-misc-defaults.osw' => 'base.osw',
    'base-misc-defaults2.osw' => 'base.osw',
    'base-misc-neighbor-shading.osw' => 'base.osw',
    'base-misc-runperiod-1-month.osw' => 'base.osw',
    'base-misc-timestep-10-mins.osw' => 'base.osw',
    'base-misc-usage-multiplier.osw' => 'base.osw',
    'base-misc-whole-house-fan.osw' => 'base.osw',
    'base-pv.osw' => 'base.osw',

    # Extra test files that don't correspond with sample files
    'extra-auto.osw' => 'base.osw',
    'extra-pv-roofpitch.osw' => 'base.osw',
    'extra-dhw-solar-latitude.osw' => 'base.osw',
    'extra-second-refrigerator.osw' => 'base.osw',

    'invalid_files/non-electric-heat-pump-water-heater.osw' => 'base.osw',
    'invalid_files/multiple-heating-and-cooling-systems.osw' => 'base.osw',
    'invalid_files/non-integer-geometry-num-bathrooms.osw' => 'base.osw',
    'invalid_files/non-integer-ceiling-fan-quantity.osw' => 'base.osw',
    'invalid_files/single-family-detached-slab-non-zero-foundation-height.osw' => 'base.osw',
    'invalid_files/single-family-detached-finished-basement-zero-foundation-height.osw' => 'base.osw',
    'invalid_files/single-family-attached-ambient.osw' => 'base.osw',
    'invalid_files/multifamily-bottom-slab-non-zero-foundation-height.osw' => 'base.osw',
    'invalid_files/multifamily-bottom-crawlspace-zero-foundation-height.osw' => 'base.osw',
    'invalid_files/slab-non-zero-foundation-height-above-grade.osw' => 'base.osw',
    'invalid_files/ducts-location-and-areas-not-same-type.osw' => 'base.osw'
  }

  puts "Generating #{osws_files.size} OSW files..."

  osws_files.each do |derivative, parent|
    print '.'

    osw_path = File.absolute_path(File.join(tests_dir, derivative))

    begin
      osw_files = [derivative]
      unless parent.nil?
        osw_files.unshift(parent)
      end
      while not parent.nil?
        next unless osws_files.keys.include? parent

        unless osws_files[parent].nil?
          osw_files.unshift(osws_files[parent])
        end
        parent = osws_files[parent]
      end

      workflow = OpenStudio::WorkflowJSON.new
      workflow.setOswPath(osw_path)
      workflow.addMeasurePath('.')
      steps = OpenStudio::WorkflowStepVector.new
      step = OpenStudio::MeasureStep.new('BuildResidentialHPXML')

      osw_files.each do |osw_file|
        step = get_values(osw_file, step)
      end

      steps.push(step)
      workflow.setWorkflowSteps(steps)
      workflow.save

      workflow_hash = JSON.parse(File.read(osw_path))
      workflow_hash.delete('created_at')
      workflow_hash.delete('updated_at')

      File.open(osw_path, 'w') do |f|
        f.write(JSON.pretty_generate(workflow_hash))
      end
    rescue Exception => e
      puts "\n#{e}\n#{e.backtrace.join('\n')}"
      puts "\nError: Did not successfully generate #{derivative}."
      exit!
    end
  end

  puts "\n"

  # Print warnings about extra files
  abs_osw_files = []
  dirs = [nil]
  osws_files.keys.each do |osw_file|
    abs_osw_files << File.absolute_path(File.join(tests_dir, osw_file))
    next unless osw_file.include? '/'

    dirs << osw_file.split('/')[0] + '/'
  end
  dirs.uniq.each do |dir|
    Dir["#{tests_dir}/#{dir}*.osw"].each do |osw|
      next if abs_osw_files.include? File.absolute_path(osw)

      puts "Warning: Extra OSW file found at #{File.absolute_path(osw)}"
    end
  end
end

def get_values(osw_file, step)
  step.setArgument('hpxml_path', "../BuildResidentialHPXML/tests/built_residential_hpxml/#{File.basename(osw_file, '.*')}.xml")

  if ['base.osw'].include? osw_file
    step.setArgument('weather_dir', 'weather')
    step.setArgument('simulation_control_timestep', 60)
    step.setArgument('simulation_control_begin_month', 1)
    step.setArgument('simulation_control_begin_day_of_month', 1)
    step.setArgument('simulation_control_end_month', 12)
    step.setArgument('simulation_control_end_day_of_month', 31)
    step.setArgument('schedules_output_path', 'BuildResidentialHPXML/tests/run/schedules.csv')
    step.setArgument('weather_station_epw_filepath', 'USA_CO_Denver.Intl.AP.725650_TMY3.epw')
    step.setArgument('site_type', HPXML::SiteTypeSuburban)
    step.setArgument('geometry_unit_type', HPXML::ResidentialTypeSFD)
    step.setArgument('geometry_num_units', 1)
    step.setArgument('geometry_cfa', 2700.0)
    step.setArgument('geometry_num_floors_above_grade', 1)
    step.setArgument('geometry_wall_height', 8.0)
    step.setArgument('geometry_orientation', 180.0)
    step.setArgument('geometry_aspect_ratio', 1.5)
    step.setArgument('geometry_level', 'Bottom')
    step.setArgument('geometry_horizontal_location', 'Left')
    step.setArgument('geometry_corridor_position', 'Double-Loaded Interior')
    step.setArgument('geometry_corridor_width', 10.0)
    step.setArgument('geometry_inset_width', 0.0)
    step.setArgument('geometry_inset_depth', 0.0)
    step.setArgument('geometry_inset_position', 'Right')
    step.setArgument('geometry_balcony_depth', 0.0)
    step.setArgument('geometry_garage_width', 0.0)
    step.setArgument('geometry_garage_depth', 20.0)
    step.setArgument('geometry_garage_protrusion', 0.0)
    step.setArgument('geometry_garage_position', 'Right')
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeBasementConditioned)
    step.setArgument('geometry_foundation_height', 8.0)
    step.setArgument('geometry_foundation_height_above_grade', 1.0)
    step.setArgument('geometry_roof_type', 'gable')
    step.setArgument('geometry_roof_pitch', '6:12')
    step.setArgument('geometry_roof_structure', 'truss, cantilever')
    step.setArgument('geometry_attic_type', HPXML::AtticTypeUnvented)
    step.setArgument('geometry_eaves_depth', 0)
    step.setArgument('geometry_num_bedrooms', 3)
    step.setArgument('geometry_num_bathrooms', Constants.Auto)
    step.setArgument('geometry_num_occupants', '3')
    step.setArgument('geometry_export_3d_coordinates', false)
    step.setArgument('floor_assembly_r', 0)
    step.setArgument('foundation_wall_insulation_r', 8.9)
    step.setArgument('foundation_wall_insulation_distance_to_top', 0.0)
    step.setArgument('foundation_wall_insulation_distance_to_bottom', 8.0)
    step.setArgument('slab_perimeter_insulation_r', 0)
    step.setArgument('slab_perimeter_depth', 0)
    step.setArgument('slab_under_insulation_r', 0)
    step.setArgument('slab_under_width', 0)
    step.setArgument('slab_carpet_fraction', 0.0)
    step.setArgument('slab_carpet_r', 0.0)
    step.setArgument('ceiling_assembly_r', 39.3)
    step.setArgument('roof_assembly_r', 2.3)
    step.setArgument('roof_solar_absorptance', 0.7)
    step.setArgument('roof_emittance', 0.92)
    step.setArgument('roof_radiant_barrier', false)
    step.setArgument('neighbor_front_distance', 0)
    step.setArgument('neighbor_back_distance', 0)
    step.setArgument('neighbor_left_distance', 0)
    step.setArgument('neighbor_right_distance', 0)
    step.setArgument('neighbor_front_height', Constants.Auto)
    step.setArgument('neighbor_back_height', Constants.Auto)
    step.setArgument('neighbor_left_height', Constants.Auto)
    step.setArgument('neighbor_right_height', Constants.Auto)
    step.setArgument('wall_type', HPXML::WallTypeWoodStud)
    step.setArgument('wall_assembly_r', 23)
    step.setArgument('wall_solar_absorptance', 0.7)
    step.setArgument('wall_emittance', 0.92)
    step.setArgument('window_front_wwr', 0)
    step.setArgument('window_back_wwr', 0)
    step.setArgument('window_left_wwr', 0)
    step.setArgument('window_right_wwr', 0)
    step.setArgument('window_area_front', 108.0)
    step.setArgument('window_area_back', 108.0)
    step.setArgument('window_area_left', 72.0)
    step.setArgument('window_area_right', 72.0)
    step.setArgument('window_aspect_ratio', 1.333)
    step.setArgument('window_fraction_operable', 0.67)
    step.setArgument('window_ufactor', 0.33)
    step.setArgument('window_shgc', 0.45)
    step.setArgument('window_interior_shading_winter', 0.85)
    step.setArgument('window_interior_shading_summer', 0.7)
    step.setArgument('overhangs_front_depth', 0)
    step.setArgument('overhangs_front_distance_to_top_of_window', 0)
    step.setArgument('overhangs_back_depth', 0)
    step.setArgument('overhangs_back_distance_to_top_of_window', 0)
    step.setArgument('overhangs_left_depth', 0)
    step.setArgument('overhangs_left_distance_to_top_of_window', 0)
    step.setArgument('overhangs_right_depth', 0)
    step.setArgument('overhangs_right_distance_to_top_of_window', 0)
    step.setArgument('skylight_area_front', 0)
    step.setArgument('skylight_area_back', 0)
    step.setArgument('skylight_area_left', 0)
    step.setArgument('skylight_area_right', 0)
    step.setArgument('skylight_ufactor', 0.33)
    step.setArgument('skylight_shgc', 0.45)
    step.setArgument('door_area', 80.0)
    step.setArgument('door_rvalue', 4.4)
    step.setArgument('air_leakage_units', HPXML::UnitsACH50)
    step.setArgument('air_leakage_value', 3)
    step.setArgument('air_leakage_shelter_coefficient', Constants.Auto)
    step.setArgument('heating_system_type', HPXML::HVACTypeFurnace)
    step.setArgument('heating_system_fuel', HPXML::FuelTypeNaturalGas)
    step.setArgument('heating_system_heating_efficiency_afue', 0.92)
    step.setArgument('heating_system_heating_efficiency_percent', 1.0)
    step.setArgument('heating_system_heating_capacity', '64000.0')
    step.setArgument('heating_system_fraction_heat_load_served', 1)
    step.setArgument('heating_system_electric_auxiliary_energy', 0)
    step.setArgument('cooling_system_type', HPXML::HVACTypeCentralAirConditioner)
    step.setArgument('cooling_system_cooling_efficiency_seer', 13.0)
    step.setArgument('cooling_system_cooling_efficiency_eer', 8.5)
    step.setArgument('cooling_system_cooling_compressor_type', HPXML::HVACCompressorTypeSingleStage)
    step.setArgument('cooling_system_cooling_sensible_heat_fraction', 0.73)
    step.setArgument('cooling_system_cooling_capacity', '48000.0')
    step.setArgument('cooling_system_fraction_cool_load_served', 1)
    step.setArgument('cooling_system_evap_cooler_is_ducted', false)
    step.setArgument('heat_pump_type', 'none')
    step.setArgument('heat_pump_heating_efficiency_hspf', 7.7)
    step.setArgument('heat_pump_heating_efficiency_cop', 3.6)
    step.setArgument('heat_pump_cooling_efficiency_seer', 13.0)
    step.setArgument('heat_pump_cooling_efficiency_eer', 16.6)
    step.setArgument('heat_pump_cooling_compressor_type', HPXML::HVACCompressorTypeSingleStage)
    step.setArgument('heat_pump_cooling_sensible_heat_fraction', 0.73)
    step.setArgument('heat_pump_heating_capacity', '64000.0')
    step.setArgument('heat_pump_heating_capacity_17F', Constants.Auto)
    step.setArgument('heat_pump_cooling_capacity', '48000.0')
    step.setArgument('heat_pump_fraction_heat_load_served', 1)
    step.setArgument('heat_pump_fraction_cool_load_served', 1)
    step.setArgument('heat_pump_backup_fuel', 'none')
    step.setArgument('heat_pump_backup_heating_efficiency', 1)
    step.setArgument('heat_pump_backup_heating_capacity', '34121.0')
    step.setArgument('heat_pump_mini_split_is_ducted', false)
    step.setArgument('setpoint_heating_temp', 68)
    step.setArgument('setpoint_heating_setback_temp', 68)
    step.setArgument('setpoint_heating_setback_hours_per_week', 0)
    step.setArgument('setpoint_heating_setback_start_hour', 0)
    step.setArgument('setpoint_cooling_temp', 78)
    step.setArgument('setpoint_cooling_setup_temp', 78)
    step.setArgument('setpoint_cooling_setup_hours_per_week', 0)
    step.setArgument('setpoint_cooling_setup_start_hour', 0)
    step.setArgument('ducts_supply_leakage_units', HPXML::UnitsCFM25)
    step.setArgument('ducts_return_leakage_units', HPXML::UnitsCFM25)
    step.setArgument('ducts_supply_leakage_value', 75.0)
    step.setArgument('ducts_return_leakage_value', 25.0)
    step.setArgument('ducts_supply_insulation_r', 4.0)
    step.setArgument('ducts_return_insulation_r', 0.0)
    step.setArgument('ducts_supply_location', HPXML::LocationAtticUnvented)
    step.setArgument('ducts_return_location', HPXML::LocationAtticUnvented)
    step.setArgument('ducts_supply_surface_area', '150.0')
    step.setArgument('ducts_return_surface_area', '50.0')
    step.setArgument('mech_vent_fan_type', 'none')
    step.setArgument('mech_vent_flow_rate', 110)
    step.setArgument('mech_vent_hours_in_operation', 24)
    step.setArgument('mech_vent_total_recovery_efficiency_type', 'Unadjusted')
    step.setArgument('mech_vent_total_recovery_efficiency', 0.48)
    step.setArgument('mech_vent_sensible_recovery_efficiency_type', 'Unadjusted')
    step.setArgument('mech_vent_sensible_recovery_efficiency', 0.72)
    step.setArgument('mech_vent_fan_power', 30)
    step.setArgument('kitchen_fan_present', false)
    step.setArgument('kitchen_fan_flow_rate', 100)
    step.setArgument('kitchen_fan_hours_in_operation', 1.5)
    step.setArgument('kitchen_fan_power', 30)
    step.setArgument('kitchen_fan_start_hour', 18)
    step.setArgument('bathroom_fans_present', false)
    step.setArgument('bathroom_fans_flow_rate', 50)
    step.setArgument('bathroom_fans_hours_in_operation', 1.5)
    step.setArgument('bathroom_fans_power', 15)
    step.setArgument('bathroom_fans_start_hour', 7)
    step.setArgument('bathroom_fans_quantity', 2)
    step.setArgument('whole_house_fan_present', false)
    step.setArgument('whole_house_fan_flow_rate', 4500)
    step.setArgument('whole_house_fan_power', 300)
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeStorage)
    step.setArgument('water_heater_fuel_type', HPXML::FuelTypeElectricity)
    step.setArgument('water_heater_location', HPXML::LocationLivingSpace)
    step.setArgument('water_heater_tank_volume', '40')
    step.setArgument('water_heater_heating_capacity', '18767')
    step.setArgument('water_heater_efficiency_type', 'EnergyFactor')
    step.setArgument('water_heater_efficiency_ef', 0.95)
    step.setArgument('water_heater_efficiency_uef', 0.93)
    step.setArgument('water_heater_recovery_efficiency', '0.76')
    step.setArgument('water_heater_standby_loss', 0)
    step.setArgument('water_heater_jacket_rvalue', 0)
    step.setArgument('water_heater_setpoint_temperature', '125')
    step.setArgument('dhw_distribution_system_type', HPXML::DHWDistTypeStandard)
    step.setArgument('dhw_distribution_standard_piping_length', '50')
    step.setArgument('dhw_distribution_recirc_control_type', HPXML::DHWRecirControlTypeNone)
    step.setArgument('dhw_distribution_recirc_piping_length', '50')
    step.setArgument('dhw_distribution_recirc_branch_piping_length', '50')
    step.setArgument('dhw_distribution_recirc_pump_power', '50')
    step.setArgument('dhw_distribution_pipe_r', 0.0)
    step.setArgument('dwhr_facilities_connected', 'none')
    step.setArgument('dwhr_equal_flow', true)
    step.setArgument('dwhr_efficiency', 0.55)
    step.setArgument('water_fixtures_shower_low_flow', true)
    step.setArgument('water_fixtures_sink_low_flow', false)
    step.setArgument('water_fixtures_usage_multiplier', 1.0)
    step.setArgument('solar_thermal_system_type', 'none')
    step.setArgument('solar_thermal_collector_area', 40.0)
    step.setArgument('solar_thermal_collector_loop_type', HPXML::SolarThermalLoopTypeDirect)
    step.setArgument('solar_thermal_collector_type', HPXML::SolarThermalTypeEvacuatedTube)
    step.setArgument('solar_thermal_collector_azimuth', 180)
    step.setArgument('solar_thermal_collector_tilt', '20')
    step.setArgument('solar_thermal_collector_rated_optical_efficiency', 0.5)
    step.setArgument('solar_thermal_collector_rated_thermal_losses', 0.2799)
    step.setArgument('solar_thermal_storage_volume', Constants.Auto)
    step.setArgument('solar_thermal_solar_fraction', 0)
    step.setArgument('pv_system_module_type_1', 'none')
    step.setArgument('pv_system_location_1', HPXML::LocationRoof)
    step.setArgument('pv_system_tracking_1', HPXML::PVTrackingTypeFixed)
    step.setArgument('pv_system_array_azimuth_1', 180)
    step.setArgument('pv_system_array_tilt_1', '20')
    step.setArgument('pv_system_max_power_output_1', 4000)
    step.setArgument('pv_system_inverter_efficiency_1', 0.96)
    step.setArgument('pv_system_system_losses_fraction_1', 0.14)
    step.setArgument('pv_system_module_type_2', 'none')
    step.setArgument('pv_system_location_2', HPXML::LocationRoof)
    step.setArgument('pv_system_tracking_2', HPXML::PVTrackingTypeFixed)
    step.setArgument('pv_system_array_azimuth_2', 180)
    step.setArgument('pv_system_array_tilt_2', '20')
    step.setArgument('pv_system_max_power_output_2', 4000)
    step.setArgument('pv_system_inverter_efficiency_2', 0.96)
    step.setArgument('pv_system_system_losses_fraction_2', 0.14)
    step.setArgument('lighting_fraction_cfl_interior', 0.4)
    step.setArgument('lighting_fraction_lfl_interior', 0.1)
    step.setArgument('lighting_fraction_led_interior', 0.25)
    step.setArgument('lighting_fraction_cfl_exterior', 0.4)
    step.setArgument('lighting_fraction_lfl_exterior', 0.1)
    step.setArgument('lighting_fraction_led_exterior', 0.25)
    step.setArgument('lighting_fraction_cfl_garage', 0.4)
    step.setArgument('lighting_fraction_lfl_garage', 0.1)
    step.setArgument('lighting_fraction_led_garage', 0.25)
    step.setArgument('lighting_usage_multiplier', 1.0)
    step.setArgument('dehumidifier_present', false)
    step.setArgument('dehumidifier_efficiency_type', 'EnergyFactor')
    step.setArgument('dehumidifier_efficiency_ef', 1.8)
    step.setArgument('dehumidifier_efficiency_ief', 1.5)
    step.setArgument('dehumidifier_capacity', 40)
    step.setArgument('dehumidifier_rh_setpoint', 0.5)
    step.setArgument('dehumidifier_fraction_dehumidification_load_served', 1)
    step.setArgument('clothes_washer_present', true)
    step.setArgument('clothes_washer_location', HPXML::LocationLivingSpace)
    step.setArgument('clothes_washer_efficiency_type', 'IntegratedModifiedEnergyFactor')
    step.setArgument('clothes_washer_efficiency_mef', 1.453)
    step.setArgument('clothes_washer_efficiency_imef', 1.21)
    step.setArgument('clothes_washer_rated_annual_kwh', 380.0)
    step.setArgument('clothes_washer_label_electric_rate', 0.12)
    step.setArgument('clothes_washer_label_gas_rate', 1.09)
    step.setArgument('clothes_washer_label_annual_gas_cost', 27.0)
    step.setArgument('clothes_washer_label_usage', 6.0)
    step.setArgument('clothes_washer_capacity', 3.2)
    step.setArgument('clothes_washer_usage_multiplier', 1.0)
    step.setArgument('clothes_dryer_present', true)
    step.setArgument('clothes_dryer_location', HPXML::LocationLivingSpace)
    step.setArgument('clothes_dryer_fuel_type', HPXML::FuelTypeElectricity)
    step.setArgument('clothes_dryer_efficiency_type', 'CombinedEnergyFactor')
    step.setArgument('clothes_dryer_efficiency_ef', 3.4615)
    step.setArgument('clothes_dryer_efficiency_cef', 3.73)
    step.setArgument('clothes_dryer_control_type', HPXML::ClothesDryerControlTypeTimer)
    step.setArgument('clothes_dryer_usage_multiplier', 1.0)
    step.setArgument('dishwasher_present', true)
    step.setArgument('dishwasher_location', HPXML::LocationLivingSpace)
    step.setArgument('dishwasher_efficiency_type', 'RatedAnnualkWh')
    step.setArgument('dishwasher_efficiency_kwh', 307)
    step.setArgument('dishwasher_efficiency_ef', 0.46)
    step.setArgument('dishwasher_label_electric_rate', 0.12)
    step.setArgument('dishwasher_label_gas_rate', 1.09)
    step.setArgument('dishwasher_label_annual_gas_cost', 22.32)
    step.setArgument('dishwasher_label_usage', 4.0)
    step.setArgument('dishwasher_place_setting_capacity', 12)
    step.setArgument('dishwasher_usage_multiplier', 1.0)
    step.setArgument('refrigerator_present', true)
    step.setArgument('refrigerator_location', HPXML::LocationLivingSpace)
    step.setArgument('refrigerator_rated_annual_kwh', 650.0)
    step.setArgument('refrigerator_usage_multiplier', 1.0)
    step.setArgument('refrigerator_weekday_fractions', Constants.Auto)
    step.setArgument('refrigerator_weekend_fractions', Constants.Auto)
    step.setArgument('refrigerator_monthly_multipliers', Constants.Auto)
    step.setArgument('extra_refrigerator_present', false)
    step.setArgument('extra_refrigerator_location', HPXML::LocationLivingSpace)
    step.setArgument('extra_refrigerator_rated_annual_kwh', 650.0)
    step.setArgument('extra_refrigerator_usage_multiplier', 1.0)
    step.setArgument('cooking_range_oven_present', true)
    step.setArgument('cooking_range_oven_location', HPXML::LocationLivingSpace)
    step.setArgument('cooking_range_oven_fuel_type', HPXML::FuelTypeElectricity)
    step.setArgument('cooking_range_oven_is_induction', false)
    step.setArgument('cooking_range_oven_is_convection', false)
    step.setArgument('cooking_range_oven_usage_multiplier', 1.0)
    step.setArgument('cooking_range_oven_weekday_fractions', Constants.Auto)
    step.setArgument('cooking_range_oven_weekend_fractions', Constants.Auto)
    step.setArgument('cooking_range_oven_monthly_multipliers', Constants.Auto)
    step.setArgument('ceiling_fan_efficiency', 70.4)
    step.setArgument('ceiling_fan_quantity', '0')
    step.setArgument('ceiling_fan_cooling_setpoint_temp_offset', 0)
    step.setArgument('plug_loads_television_annual_kwh', '620.0')
    step.setArgument('plug_loads_other_annual_kwh', '2457.0')
    step.setArgument('plug_loads_other_frac_sensible', 0.855)
    step.setArgument('plug_loads_other_frac_latent', 0.045)
    step.setArgument('plug_loads_usage_multiplier', 1.0)
    step.setArgument('plug_loads_weekday_fractions', '0.04, 0.037, 0.037, 0.036, 0.033, 0.036, 0.043, 0.047, 0.034, 0.023, 0.024, 0.025, 0.024, 0.028, 0.031, 0.032, 0.039, 0.053, 0.063, 0.067, 0.071, 0.069, 0.059, 0.05')
    step.setArgument('plug_loads_weekend_fractions', '0.04, 0.037, 0.037, 0.036, 0.033, 0.036, 0.043, 0.047, 0.034, 0.023, 0.024, 0.025, 0.024, 0.028, 0.031, 0.032, 0.039, 0.053, 0.063, 0.067, 0.071, 0.069, 0.059, 0.05')
    step.setArgument('plug_loads_monthly_multipliers', '1.248, 1.257, 0.993, 0.989, 0.993, 0.827, 0.821, 0.821, 0.827, 0.99, 0.987, 1.248')
  elsif ['base-single-family-attached.osw'].include? osw_file
    step.setArgument('geometry_unit_type', HPXML::ResidentialTypeSFA)
    step.setArgument('geometry_cfa', 900.0)
    step.setArgument('geometry_num_units', 3)
    step.setArgument('geometry_corridor_position', 'None')
    step.setArgument('window_front_wwr', 0.18)
    step.setArgument('window_back_wwr', 0.18)
    step.setArgument('window_left_wwr', 0.18)
    step.setArgument('window_right_wwr', 0.18)
    step.setArgument('window_area_front', 0)
    step.setArgument('window_area_back', 0)
    step.setArgument('window_area_left', 0)
    step.setArgument('window_area_right', 0)
  elsif ['base-multifamily.osw'].include? osw_file
    step.setArgument('geometry_unit_type', HPXML::ResidentialTypeMF)
    step.setArgument('geometry_cfa', 900.0)
    step.setArgument('geometry_num_units', 3)
    step.setArgument('geometry_corridor_position', 'None')
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeBasementUnconditioned)
    step.setArgument('window_front_wwr', 0.18)
    step.setArgument('window_back_wwr', 0.18)
    step.setArgument('window_left_wwr', 0.18)
    step.setArgument('window_right_wwr', 0.18)
    step.setArgument('window_area_front', 0)
    step.setArgument('window_area_back', 0)
    step.setArgument('window_area_left', 0)
    step.setArgument('window_area_right', 0)
    step.setArgument('ducts_supply_leakage_value', 0)
    step.setArgument('ducts_return_leakage_value', 0)
  elsif ['base-appliances-dehumidifier.osw'].include? osw_file
    step.setArgument('weather_station_epw_filepath', 'USA_TX_Dallas-Fort.Worth.Intl.AP.722590_TMY3.epw')
    step.setArgument('dehumidifier_present', true)
  elsif ['base-appliances-dehumidifier-50percent.osw'].include? osw_file
    step.setArgument('weather_station_epw_filepath', 'USA_TX_Dallas-Fort.Worth.Intl.AP.722590_TMY3.epw')
    step.setArgument('dehumidifier_present', true)
    step.setArgument('dehumidifier_fraction_dehumidification_load_served', 0.5)
  elsif ['base-appliances-dehumidifier-ief.osw'].include? osw_file
    step.setArgument('weather_station_epw_filepath', 'USA_TX_Dallas-Fort.Worth.Intl.AP.722590_TMY3.epw')
    step.setArgument('dehumidifier_present', true)
    step.setArgument('dehumidifier_efficiency_type', 'IntegratedEnergyFactor')
  elsif ['base-appliances-gas.osw'].include? osw_file
    step.setArgument('clothes_dryer_fuel_type', HPXML::FuelTypeNaturalGas)
    step.setArgument('clothes_dryer_efficiency_cef', 3.3)
    step.setArgument('clothes_dryer_control_type', HPXML::ClothesDryerControlTypeMoisture)
    step.setArgument('cooking_range_oven_fuel_type', HPXML::FuelTypeNaturalGas)
  elsif ['base-appliances-modified.osw'].include? osw_file
    step.setArgument('clothes_washer_efficiency_type', 'ModifiedEnergyFactor')
    step.setArgument('clothes_washer_efficiency_mef', 1.65)
    step.setArgument('clothes_dryer_efficiency_type', 'EnergyFactor')
    step.setArgument('clothes_dryer_efficiency_ef', 4.29)
    step.setArgument('clothes_dryer_control_type', HPXML::ClothesDryerControlTypeMoisture)
    step.setArgument('dishwasher_efficiency_type', 'EnergyFactor')
    step.setArgument('dishwasher_efficiency_ef', 0.7)
  elsif ['base-appliances-none.osw'].include? osw_file
    step.setArgument('clothes_washer_present', false)
    step.setArgument('clothes_dryer_present', false)
    step.setArgument('dishwasher_present', false)
    step.setArgument('refrigerator_present', false)
    step.setArgument('cooking_range_oven_present', false)
  elsif ['base-appliances-oil.osw'].include? osw_file
    step.setArgument('clothes_dryer_fuel_type', HPXML::FuelTypeOil)
    step.setArgument('clothes_dryer_efficiency_cef', 3.3)
    step.setArgument('clothes_dryer_control_type', HPXML::ClothesDryerControlTypeMoisture)
    step.setArgument('cooking_range_oven_fuel_type', HPXML::FuelTypeOil)
  elsif ['base-appliances-propane.osw'].include? osw_file
    step.setArgument('clothes_dryer_fuel_type', HPXML::FuelTypePropane)
    step.setArgument('clothes_dryer_efficiency_cef', 3.3)
    step.setArgument('clothes_dryer_control_type', HPXML::ClothesDryerControlTypeMoisture)
    step.setArgument('cooking_range_oven_fuel_type', HPXML::FuelTypePropane)
  elsif ['base-appliances-wood.osw'].include? osw_file
    step.setArgument('clothes_dryer_fuel_type', HPXML::FuelTypeWood)
    step.setArgument('clothes_dryer_efficiency_cef', 3.3)
    step.setArgument('clothes_dryer_control_type', HPXML::ClothesDryerControlTypeMoisture)
    step.setArgument('cooking_range_oven_fuel_type', HPXML::FuelTypeWood)
  elsif ['base-atticroof-cathedral.osw'].include? osw_file
    step.setArgument('geometry_attic_type', HPXML::AtticTypeConditioned)
    step.setArgument('roof_assembly_r', 25.8)
    step.setArgument('ducts_supply_location', HPXML::LocationLivingSpace)
    step.setArgument('ducts_return_location', HPXML::LocationLivingSpace)
    step.setArgument('ducts_supply_leakage_value', 0.0)
    step.setArgument('ducts_return_leakage_value', 0.0)
  elsif ['base-atticroof-conditioned.osw'].include? osw_file
    step.setArgument('geometry_cfa', 3600.0)
    step.setArgument('geometry_num_floors_above_grade', 2)
    step.setArgument('geometry_attic_type', HPXML::AtticTypeConditioned)
    step.setArgument('roof_assembly_r', 25.8)
    step.setArgument('ducts_supply_location', HPXML::LocationLivingSpace)
    step.setArgument('ducts_return_location', HPXML::LocationLivingSpace)
    step.setArgument('ducts_supply_leakage_value', 0.0)
    step.setArgument('ducts_return_leakage_value', 0.0)
    step.setArgument('water_heater_location', HPXML::LocationBasementConditioned)
    step.setArgument('clothes_washer_location', HPXML::LocationBasementConditioned)
    step.setArgument('clothes_dryer_location', HPXML::LocationBasementConditioned)
    step.setArgument('refrigerator_location', HPXML::LocationBasementConditioned)
  elsif ['base-atticroof-flat.osw'].include? osw_file
    step.setArgument('geometry_roof_type', 'flat')
    step.setArgument('roof_assembly_r', 25.8)
    step.setArgument('ducts_supply_leakage_value', 0.0)
    step.setArgument('ducts_return_leakage_value', 0.0)
    step.setArgument('ducts_supply_location', HPXML::LocationBasementConditioned)
    step.setArgument('ducts_return_location', HPXML::LocationBasementConditioned)
  elsif ['base-atticroof-radiant-barrier.osw'].include? osw_file
    step.setArgument('weather_station_epw_filepath', 'USA_TX_Dallas-Fort.Worth.Intl.AP.722590_TMY3.epw')
    step.setArgument('roof_radiant_barrier', true)
  elsif ['base-atticroof-unvented-insulated-roof.osw'].include? osw_file
    step.setArgument('ceiling_assembly_r', 2.1)
    step.setArgument('roof_assembly_r', 25.8)
  elsif ['base-atticroof-vented.osw'].include? osw_file
    step.setArgument('geometry_attic_type', HPXML::AtticTypeVented)
    step.setArgument('water_heater_location', HPXML::LocationAtticVented)
    step.setArgument('ducts_supply_location', HPXML::LocationAtticVented)
    step.setArgument('ducts_return_location', HPXML::LocationAtticVented)
  elsif ['base-dhw-combi-tankless.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeCombiTankless)
    step.setArgument('water_heater_tank_volume', Constants.Auto)
  elsif ['base-dhw-combi-tankless-outside.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeCombiTankless)
    step.setArgument('water_heater_location', HPXML::LocationOtherExterior)
    step.setArgument('water_heater_tank_volume', Constants.Auto)
  elsif ['base-dhw-dwhr.osw'].include? osw_file
    step.setArgument('dwhr_facilities_connected', HPXML::DWHRFacilitiesConnectedAll)
  elsif ['base-dhw-indirect.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeCombiStorage)
    step.setArgument('water_heater_tank_volume', '50')
  elsif ['base-dhw-indirect-outside.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeCombiStorage)
    step.setArgument('water_heater_location', HPXML::LocationOtherExterior)
    step.setArgument('water_heater_tank_volume', '50')
  elsif ['base-dhw-indirect-standbyloss.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeCombiStorage)
    step.setArgument('water_heater_tank_volume', '50')
    step.setArgument('water_heater_standby_loss', 1.0)
  elsif ['base-dhw-indirect-with-solar-fraction.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeCombiStorage)
    step.setArgument('water_heater_tank_volume', '50')
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_solar_fraction', 0.65)
  elsif ['base-dhw-jacket-electric.osw'].include? osw_file
    step.setArgument('water_heater_jacket_rvalue', 10.0)
  elsif ['base-dhw-jacket-gas.osw'].include? osw_file
    step.setArgument('water_heater_fuel_type', HPXML::FuelTypeNaturalGas)
    step.setArgument('water_heater_tank_volume', '50')
    step.setArgument('water_heater_heating_capacity', '40000')
    step.setArgument('water_heater_efficiency_ef', 0.59)
    step.setArgument('water_heater_jacket_rvalue', 10.0)
  elsif ['base-dhw-jacket-hpwh.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeHeatPump)
    step.setArgument('water_heater_tank_volume', '80')
    step.setArgument('water_heater_heating_capacity', Constants.Auto)
    step.setArgument('water_heater_efficiency_ef', 2.3)
    step.setArgument('water_heater_jacket_rvalue', 10.0)
  elsif ['base-dhw-jacket-indirect.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeCombiStorage)
    step.setArgument('water_heater_tank_volume', '50')
    step.setArgument('water_heater_jacket_rvalue', 10.0)
  elsif ['base-dhw-low-flow-fixtures.osw'].include? osw_file
    step.setArgument('water_fixtures_sink_low_flow', true)
  elsif ['base-dhw-none.osw'].include? osw_file
    step.setArgument('water_heater_type', 'none')
  elsif ['base-dhw-recirc-demand.osw'].include? osw_file
    step.setArgument('dhw_distribution_system_type', HPXML::DHWDistTypeRecirc)
    step.setArgument('dhw_distribution_recirc_control_type', HPXML::DHWRecirControlTypeSensor)
    step.setArgument('dhw_distribution_pipe_r', 3.0)
  elsif ['base-dhw-recirc-manual.osw'].include? osw_file
    step.setArgument('dhw_distribution_system_type', HPXML::DHWDistTypeRecirc)
    step.setArgument('dhw_distribution_recirc_control_type', HPXML::DHWRecirControlTypeManual)
    step.setArgument('dhw_distribution_pipe_r', 3.0)
  elsif ['base-dhw-recirc-nocontrol.osw'].include? osw_file
    step.setArgument('dhw_distribution_system_type', HPXML::DHWDistTypeRecirc)
  elsif ['base-dhw-recirc-temperature.osw'].include? osw_file
    step.setArgument('dhw_distribution_system_type', HPXML::DHWDistTypeRecirc)
    step.setArgument('dhw_distribution_recirc_control_type', HPXML::DHWRecirControlTypeTemperature)
  elsif ['base-dhw-recirc-timer.osw'].include? osw_file
    step.setArgument('dhw_distribution_system_type', HPXML::DHWDistTypeRecirc)
    step.setArgument('dhw_distribution_recirc_control_type', HPXML::DHWRecirControlTypeTimer)
  elsif ['base-dhw-solar-direct-evacuated-tube.osw'].include? osw_file
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_storage_volume', '60')
  elsif ['base-dhw-solar-direct-flat-plate.osw'].include? osw_file
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_collector_type', HPXML::SolarThermalTypeSingleGlazing)
    step.setArgument('solar_thermal_collector_rated_optical_efficiency', 0.77)
    step.setArgument('solar_thermal_collector_rated_thermal_losses', 0.793)
    step.setArgument('solar_thermal_storage_volume', '60')
  elsif ['base-dhw-solar-direct-ics.osw'].include? osw_file
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_collector_type', HPXML::SolarThermalTypeICS)
    step.setArgument('solar_thermal_collector_rated_optical_efficiency', 0.77)
    step.setArgument('solar_thermal_collector_rated_thermal_losses', 0.793)
    step.setArgument('solar_thermal_storage_volume', '60')
  elsif ['base-dhw-solar-fraction.osw'].include? osw_file
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_solar_fraction', 0.65)
  elsif ['base-dhw-solar-indirect-flat-plate.osw'].include? osw_file
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_collector_loop_type', HPXML::SolarThermalLoopTypeIndirect)
    step.setArgument('solar_thermal_collector_type', HPXML::SolarThermalTypeSingleGlazing)
    step.setArgument('solar_thermal_collector_rated_optical_efficiency', 0.77)
    step.setArgument('solar_thermal_collector_rated_thermal_losses', 0.793)
    step.setArgument('solar_thermal_storage_volume', '60')
  elsif ['base-dhw-solar-thermosyphon-flat-plate.osw'].include? osw_file
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_collector_loop_type', HPXML::SolarThermalLoopTypeThermosyphon)
    step.setArgument('solar_thermal_collector_type', HPXML::SolarThermalTypeSingleGlazing)
    step.setArgument('solar_thermal_collector_rated_optical_efficiency', 0.77)
    step.setArgument('solar_thermal_collector_rated_thermal_losses', 0.793)
    step.setArgument('solar_thermal_storage_volume', '60')
  elsif ['base-dhw-tank-gas.osw'].include? osw_file
    step.setArgument('water_heater_fuel_type', HPXML::FuelTypeNaturalGas)
    step.setArgument('water_heater_tank_volume', '50')
    step.setArgument('water_heater_heating_capacity', '40000')
    step.setArgument('water_heater_efficiency_ef', 0.59)
  elsif ['base-dhw-tank-gas-outside.osw'].include? osw_file
    step.setArgument('water_heater_fuel_type', HPXML::FuelTypeNaturalGas)
    step.setArgument('water_heater_location', HPXML::LocationOtherExterior)
    step.setArgument('water_heater_tank_volume', '50')
    step.setArgument('water_heater_heating_capacity', '40000')
    step.setArgument('water_heater_efficiency_ef', 0.59)
  elsif ['base-dhw-tank-heat-pump.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeHeatPump)
    step.setArgument('water_heater_tank_volume', '80')
    step.setArgument('water_heater_heating_capacity', Constants.Auto)
    step.setArgument('water_heater_efficiency_ef', 2.3)
  elsif ['base-dhw-tank-heat-pump-outside.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeHeatPump)
    step.setArgument('water_heater_location', HPXML::LocationOtherExterior)
    step.setArgument('water_heater_tank_volume', '80')
    step.setArgument('water_heater_heating_capacity', Constants.Auto)
    step.setArgument('water_heater_efficiency_ef', 2.3)
  elsif ['base-dhw-tank-heat-pump-with-solar.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeHeatPump)
    step.setArgument('water_heater_tank_volume', '80')
    step.setArgument('water_heater_heating_capacity', Constants.Auto)
    step.setArgument('water_heater_efficiency_ef', 2.3)
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_collector_loop_type', HPXML::SolarThermalLoopTypeIndirect)
    step.setArgument('solar_thermal_collector_type', HPXML::SolarThermalTypeSingleGlazing)
    step.setArgument('solar_thermal_collector_rated_optical_efficiency', 0.77)
    step.setArgument('solar_thermal_collector_rated_thermal_losses', 0.793)
    step.setArgument('solar_thermal_storage_volume', '60')
  elsif ['base-dhw-tank-heat-pump-with-solar-fraction.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeHeatPump)
    step.setArgument('water_heater_tank_volume', '80')
    step.setArgument('water_heater_heating_capacity', Constants.Auto)
    step.setArgument('water_heater_efficiency_ef', 2.3)
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_solar_fraction', 0.65)
  elsif ['base-dhw-tankless-electric.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeTankless)
    step.setArgument('water_heater_tank_volume', Constants.Auto)
    step.setArgument('water_heater_efficiency_ef', 0.99)
  elsif ['base-dhw-tankless-electric-outside.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeTankless)
    step.setArgument('water_heater_location', HPXML::LocationOtherExterior)
    step.setArgument('water_heater_tank_volume', Constants.Auto)
    step.setArgument('water_heater_efficiency_ef', 0.99)
  elsif ['base-dhw-tankless-gas.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeTankless)
    step.setArgument('water_heater_fuel_type', HPXML::FuelTypeNaturalGas)
    step.setArgument('water_heater_tank_volume', Constants.Auto)
    step.setArgument('water_heater_efficiency_ef', 0.82)
  elsif ['base-dhw-tankless-gas-with-solar.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeTankless)
    step.setArgument('water_heater_fuel_type', HPXML::FuelTypeNaturalGas)
    step.setArgument('water_heater_tank_volume', Constants.Auto)
    step.setArgument('water_heater_efficiency_ef', 0.82)
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_collector_loop_type', HPXML::SolarThermalLoopTypeIndirect)
    step.setArgument('solar_thermal_collector_type', HPXML::SolarThermalTypeSingleGlazing)
    step.setArgument('solar_thermal_collector_rated_optical_efficiency', 0.77)
    step.setArgument('solar_thermal_collector_rated_thermal_losses', 0.793)
    step.setArgument('solar_thermal_storage_volume', '60')
  elsif ['base-dhw-tankless-gas-with-solar-fraction.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeTankless)
    step.setArgument('water_heater_fuel_type', HPXML::FuelTypeNaturalGas)
    step.setArgument('water_heater_tank_volume', Constants.Auto)
    step.setArgument('water_heater_efficiency_ef', 0.82)
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_solar_fraction', 0.65)
  elsif ['base-dhw-tankless-propane.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeTankless)
    step.setArgument('water_heater_fuel_type', HPXML::FuelTypePropane)
    step.setArgument('water_heater_tank_volume', Constants.Auto)
    step.setArgument('water_heater_efficiency_ef', 0.82)
  elsif ['base-dhw-tank-oil.osw'].include? osw_file
    step.setArgument('water_heater_fuel_type', HPXML::FuelTypeOil)
    step.setArgument('water_heater_tank_volume', '50')
    step.setArgument('water_heater_heating_capacity', '40000')
    step.setArgument('water_heater_efficiency_ef', 0.59)
  elsif ['base-dhw-tank-wood.osw'].include? osw_file
    step.setArgument('water_heater_fuel_type', HPXML::FuelTypeWood)
    step.setArgument('water_heater_tank_volume', '50')
    step.setArgument('water_heater_heating_capacity', '40000')
    step.setArgument('water_heater_efficiency_ef', 0.59)
  elsif ['base-dhw-uef.osw'].include? osw_file
    step.setArgument('water_heater_efficiency_type', 'UniformEnergyFactor')
    step.setArgument('water_heater_efficiency_uef', 0.93)
  elsif ['base-enclosure-2stories.osw'].include? osw_file
    step.setArgument('geometry_cfa', 4050.0)
    step.setArgument('geometry_num_floors_above_grade', 2)
    step.setArgument('window_area_front', 216.0)
    step.setArgument('window_area_back', 216.0)
    step.setArgument('window_area_left', 144.0)
    step.setArgument('window_area_right', 144.0)
    step.setArgument('plug_loads_other_annual_kwh', '3685.5')
  elsif ['base-enclosure-2stories-garage.osw'].include? osw_file
    step.setArgument('geometry_cfa', 3250.0)
    step.setArgument('geometry_num_floors_above_grade', 2)
    step.setArgument('geometry_garage_width', 20.0)
    step.setArgument('window_area_front', 216.0)
    step.setArgument('window_area_back', 216.0)
    step.setArgument('window_area_left', 144.0)
    step.setArgument('window_area_right', 144.0)
    step.setArgument('ducts_supply_surface_area', '112.5')
    step.setArgument('ducts_return_surface_area', '37.5')
    step.setArgument('plug_loads_other_annual_kwh', '2957.5')
  elsif ['base-enclosure-3d-coordinates.osw'].include? osw_file
    step.setArgument('geometry_export_3d_coordinates', true)
  elsif ['base-enclosure-attached-multifamily.osw'].include? osw_file

  elsif ['base-enclosure-beds-1.osw'].include? osw_file
    step.setArgument('geometry_num_bedrooms', 1)
    step.setArgument('geometry_num_occupants', '1')
    step.setArgument('water_heater_heating_capacity', '18767')
    step.setArgument('plug_loads_television_annual_kwh', '482.0')
  elsif ['base-enclosure-beds-2.osw'].include? osw_file
    step.setArgument('geometry_num_bedrooms', 2)
    step.setArgument('geometry_num_occupants', '2')
    step.setArgument('water_heater_heating_capacity', '18767')
    step.setArgument('plug_loads_television_annual_kwh', '551.0')
  elsif ['base-enclosure-beds-4.osw'].include? osw_file
    step.setArgument('geometry_num_bedrooms', 4)
    step.setArgument('geometry_num_occupants', '4')
    step.setArgument('plug_loads_television_annual_kwh', '689.0')
  elsif ['base-enclosure-beds-5.osw'].include? osw_file
    step.setArgument('geometry_num_bedrooms', 5)
    step.setArgument('geometry_num_occupants', '5')
    step.setArgument('plug_loads_television_annual_kwh', '758.0')
  elsif ['base-enclosure-garage.osw'].include? osw_file
    step.setArgument('geometry_garage_width', 30.0)
    step.setArgument('geometry_garage_protrusion', 1.0)
    step.setArgument('window_area_front', 12.0)
    step.setArgument('ducts_supply_location', HPXML::LocationGarage)
    step.setArgument('ducts_return_location', HPXML::LocationGarage)
    step.setArgument('water_heater_location', HPXML::LocationGarage)
    step.setArgument('clothes_washer_location', HPXML::LocationGarage)
    step.setArgument('clothes_dryer_location', HPXML::LocationGarage)
    step.setArgument('dishwasher_location', HPXML::LocationGarage)
    step.setArgument('refrigerator_location', HPXML::LocationGarage)
    step.setArgument('cooking_range_oven_location', HPXML::LocationGarage)
  elsif ['base-enclosure-infil-cfm50.osw'].include? osw_file
    step.setArgument('air_leakage_units', HPXML::UnitsCFM50)
    step.setArgument('air_leakage_value', 1080)
  elsif ['base-enclosure-infil-natural-ach.osw'].include? osw_file
    step.setArgument('air_leakage_units', HPXML::UnitsACHNatural)
    step.setArgument('air_leakage_value', 0.67)
  elsif ['base-enclosure-other-heated-space.osw'].include? osw_file

  elsif ['base-enclosure-other-housing-unit.osw'].include? osw_file

  elsif ['base-enclosure-other-multifamily-buffer-space.osw'].include? osw_file

  elsif ['base-enclosure-other-non-freezing-space.osw'].include? osw_file

  elsif ['base-enclosure-overhangs.osw'].include? osw_file
    step.setArgument('overhangs_back_depth', 2.5)
    step.setArgument('overhangs_left_depth', 1.5)
    step.setArgument('overhangs_left_distance_to_top_of_window', 2.0)
    step.setArgument('overhangs_right_depth', 1.5)
    step.setArgument('overhangs_right_distance_to_top_of_window', 2.0)
  elsif ['base-enclosure-skylights.osw'].include? osw_file
    step.setArgument('skylight_area_front', 15)
    step.setArgument('skylight_area_back', 15)
  elsif ['base-enclosure-windows-none.osw'].include? osw_file
    step.setArgument('window_area_front', 0)
    step.setArgument('window_area_back', 0)
    step.setArgument('window_area_left', 0)
    step.setArgument('window_area_right', 0)
  elsif ['base-foundation-ambient.osw'].include? osw_file
    step.setArgument('geometry_cfa', 1350.0)
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeAmbient)
    step.setArgument('floor_assembly_r', 18.7)
    step.setArgument('plug_loads_other_annual_kwh', '1228.5')
  elsif ['base-foundation-conditioned-basement-slab-insulation.osw'].include? osw_file
    step.setArgument('slab_under_insulation_r', 10)
    step.setArgument('slab_under_width', 4)
  elsif ['base-foundation-conditioned-basement-wall-interior-insulation.osw'].include? osw_file
    step.setArgument('foundation_wall_insulation_r', 18.9)
    step.setArgument('foundation_wall_insulation_distance_to_top', 1.0)
  elsif ['base-foundation-slab.osw'].include? osw_file
    step.setArgument('geometry_cfa', 1350.0)
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeSlab)
    step.setArgument('geometry_foundation_height', 0.0)
    step.setArgument('geometry_foundation_height_above_grade', 0.0)
    step.setArgument('slab_under_insulation_r', 5)
    step.setArgument('slab_under_width', 999)
    step.setArgument('slab_carpet_fraction', 1.0)
    step.setArgument('slab_carpet_r', 2.5)
    step.setArgument('ducts_supply_location', HPXML::LocationUnderSlab)
    step.setArgument('ducts_return_location', HPXML::LocationUnderSlab)
    step.setArgument('plug_loads_other_annual_kwh', '1228.5')
  elsif ['base-foundation-unconditioned-basement.osw'].include? osw_file
    step.setArgument('geometry_cfa', 1350.0)
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeBasementUnconditioned)
    step.setArgument('floor_assembly_r', 18.7)
    step.setArgument('foundation_wall_insulation_r', 0)
    step.setArgument('foundation_wall_insulation_distance_to_bottom', 0)
    step.setArgument('ducts_supply_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('ducts_return_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('water_heater_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('clothes_washer_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('clothes_dryer_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('dishwasher_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('refrigerator_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('cooking_range_oven_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('plug_loads_other_annual_kwh', '1228.5')
  elsif ['base-foundation-unconditioned-basement-above-grade.osw'].include? osw_file
    step.setArgument('geometry_cfa', 1350.0)
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeBasementUnconditioned)
    step.setArgument('geometry_foundation_height_above_grade', 4.0)
    step.setArgument('foundation_wall_insulation_r', 0)
    step.setArgument('foundation_wall_insulation_distance_to_bottom', 0)
    step.setArgument('ducts_supply_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('ducts_return_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('water_heater_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('clothes_washer_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('clothes_dryer_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('dishwasher_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('refrigerator_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('cooking_range_oven_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('plug_loads_other_annual_kwh', '1228.5')
  elsif ['base-foundation-unconditioned-basement-assembly-r.osw'].include? osw_file
    step.setArgument('geometry_cfa', 1350.0)
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeBasementUnconditioned)
    step.setArgument('floor_assembly_r', 18.7)
    step.setArgument('foundation_wall_assembly_r', 10.69)
    step.setArgument('ducts_supply_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('ducts_return_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('water_heater_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('clothes_washer_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('clothes_dryer_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('dishwasher_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('refrigerator_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('cooking_range_oven_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('plug_loads_other_annual_kwh', '1228.5')
  elsif ['base-foundation-unconditioned-basement-wall-insulation.osw'].include? osw_file
    step.setArgument('geometry_cfa', 1350.0)
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeBasementUnconditioned)
    step.setArgument('floor_assembly_r', 2.1)
    step.setArgument('foundation_wall_insulation_distance_to_bottom', 4)
    step.setArgument('ducts_supply_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('ducts_return_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('water_heater_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('clothes_washer_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('clothes_dryer_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('dishwasher_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('refrigerator_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('cooking_range_oven_location', HPXML::LocationBasementUnconditioned)
    step.setArgument('plug_loads_other_annual_kwh', '1228.5')
  elsif ['base-foundation-unvented-crawlspace.osw'].include? osw_file
    step.setArgument('geometry_cfa', 1350.0)
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeCrawlspaceUnvented)
    step.setArgument('geometry_foundation_height', 4.0)
    step.setArgument('geometry_foundation_height_above_grade', 1.0)
    step.setArgument('floor_assembly_r', 18.7)
    step.setArgument('foundation_wall_insulation_distance_to_bottom', 4.0)
    step.setArgument('slab_carpet_r', 2.5)
    step.setArgument('ducts_supply_location', HPXML::LocationCrawlspaceUnvented)
    step.setArgument('ducts_return_location', HPXML::LocationCrawlspaceUnvented)
    step.setArgument('water_heater_location', HPXML::LocationCrawlspaceUnvented)
    step.setArgument('plug_loads_other_annual_kwh', '1228.5')
  elsif ['base-foundation-vented-crawlspace.osw'].include? osw_file
    step.setArgument('geometry_cfa', 1350.0)
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeCrawlspaceVented)
    step.setArgument('geometry_foundation_height', 4.0)
    step.setArgument('geometry_foundation_height_above_grade', 1.0)
    step.setArgument('floor_assembly_r', 18.7)
    step.setArgument('foundation_wall_insulation_distance_to_bottom', 4.0)
    step.setArgument('slab_carpet_r', 2.5)
    step.setArgument('ducts_supply_location', HPXML::LocationCrawlspaceVented)
    step.setArgument('ducts_return_location', HPXML::LocationCrawlspaceVented)
    step.setArgument('water_heater_location', HPXML::LocationCrawlspaceVented)
    step.setArgument('plug_loads_other_annual_kwh', '1228.5')
  elsif ['base-foundation-walkout-basement.osw'].include? osw_file
    step.setArgument('geometry_foundation_height_above_grade', 5.0)
    step.setArgument('foundation_wall_insulation_distance_to_bottom', 4.0)
  elsif ['base-hvac-air-to-air-heat-pump-1-speed.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpAirToAir)
    step.setArgument('heat_pump_heating_capacity', '42000.0')
    step.setArgument('heat_pump_heating_capacity_17F', '26460.0')
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeElectricity)
  elsif ['base-hvac-air-to-air-heat-pump-2-speed.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpAirToAir)
    step.setArgument('heat_pump_heating_efficiency_hspf', 9.3)
    step.setArgument('heat_pump_cooling_compressor_type', HPXML::HVACCompressorTypeTwoStage)
    step.setArgument('heat_pump_heating_capacity', '42000.0')
    step.setArgument('heat_pump_heating_capacity_17F', '24780.0')
    step.setArgument('heat_pump_cooling_efficiency_seer', 18.0)
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeElectricity)
  elsif ['base-hvac-air-to-air-heat-pump-var-speed.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpAirToAir)
    step.setArgument('heat_pump_heating_efficiency_hspf', 10.0)
    step.setArgument('heat_pump_cooling_compressor_type', HPXML::HVACCompressorTypeVariableSpeed)
    step.setArgument('heat_pump_cooling_sensible_heat_fraction', 0.78)
    step.setArgument('heat_pump_heating_capacity', '42000.0')
    step.setArgument('heat_pump_heating_capacity_17F', '26880.0')
    step.setArgument('heat_pump_cooling_efficiency_seer', 22.0)
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeElectricity)
  elsif ['base-hvac-boiler-elec-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_fuel', HPXML::FuelTypeElectricity)
    step.setArgument('heating_system_heating_efficiency_afue', 1.0)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-boiler-gas-central-ac-1-speed.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
  elsif ['base-hvac-boiler-gas-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-boiler-oil-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_fuel', HPXML::FuelTypeOil)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-boiler-propane-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_fuel', HPXML::FuelTypePropane)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-boiler-wood-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeBoiler)
    step.setArgument('heating_system_fuel', HPXML::FuelTypeWood)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-central-ac-only-1-speed.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
  elsif ['base-hvac-central-ac-only-2-speed.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_cooling_efficiency_seer', 18.0)
    step.setArgument('cooling_system_cooling_compressor_type', HPXML::HVACCompressorTypeTwoStage)
  elsif ['base-hvac-central-ac-only-var-speed.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_cooling_efficiency_seer', 24.0)
    step.setArgument('cooling_system_cooling_compressor_type', HPXML::HVACCompressorTypeVariableSpeed)
    step.setArgument('cooling_system_cooling_sensible_heat_fraction', 0.78)
  elsif ['base-hvac-central-ac-plus-air-to-air-heat-pump-heating.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpAirToAir)
    step.setArgument('heat_pump_heating_efficiency_hspf', 7.7)
    step.setArgument('heat_pump_heating_capacity', '42000.0')
    step.setArgument('heat_pump_heating_capacity_17F', '26460.0')
    step.setArgument('heat_pump_fraction_cool_load_served', 0)
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeElectricity)
  elsif ['base-hvac-dual-fuel-air-to-air-heat-pump-1-speed.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpAirToAir)
    step.setArgument('heat_pump_heating_efficiency_hspf', 7.7)
    step.setArgument('heat_pump_heating_capacity', '42000.0')
    step.setArgument('heat_pump_heating_capacity_17F', '26460.0')
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeNaturalGas)
    step.setArgument('heat_pump_backup_heating_efficiency', 0.95)
    step.setArgument('heat_pump_backup_heating_capacity', '36000.0')
    step.setArgument('heat_pump_backup_heating_switchover_temp', 25)
  elsif ['base-hvac-dual-fuel-air-to-air-heat-pump-1-speed-electric.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpAirToAir)
    step.setArgument('heat_pump_heating_efficiency_hspf', 7.7)
    step.setArgument('heat_pump_heating_capacity', '42000.0')
    step.setArgument('heat_pump_heating_capacity_17F', '26460.0')
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeElectricity)
    step.setArgument('heat_pump_backup_heating_capacity', '36000.0')
    step.setArgument('heat_pump_backup_heating_switchover_temp', 25)
  elsif ['base-hvac-dual-fuel-air-to-air-heat-pump-2-speed.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpAirToAir)
    step.setArgument('heat_pump_heating_efficiency_hspf', 9.3)
    step.setArgument('heat_pump_cooling_compressor_type', HPXML::HVACCompressorTypeTwoStage)
    step.setArgument('heat_pump_heating_capacity', '42000.0')
    step.setArgument('heat_pump_heating_capacity_17F', '24780.0')
    step.setArgument('heat_pump_cooling_efficiency_seer', 18.0)
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeNaturalGas)
    step.setArgument('heat_pump_backup_heating_efficiency', 0.95)
    step.setArgument('heat_pump_backup_heating_capacity', '36000.0')
    step.setArgument('heat_pump_backup_heating_switchover_temp', 25)
  elsif ['base-hvac-dual-fuel-air-to-air-heat-pump-var-speed.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpAirToAir)
    step.setArgument('heat_pump_heating_efficiency_hspf', 10.0)
    step.setArgument('heat_pump_cooling_compressor_type', HPXML::HVACCompressorTypeVariableSpeed)
    step.setArgument('heat_pump_cooling_sensible_heat_fraction', 0.78)
    step.setArgument('heat_pump_heating_capacity', '42000.0')
    step.setArgument('heat_pump_heating_capacity_17F', '26880.0')
    step.setArgument('heat_pump_cooling_efficiency_seer', 22.0)
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeNaturalGas)
    step.setArgument('heat_pump_backup_heating_efficiency', 0.95)
    step.setArgument('heat_pump_backup_heating_capacity', '36000.0')
    step.setArgument('heat_pump_backup_heating_switchover_temp', 25)
  elsif ['base-hvac-dual-fuel-mini-split-heat-pump-ducted.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpMiniSplit)
    step.setArgument('heat_pump_heating_efficiency_hspf', 10.0)
    step.removeArgument('heat_pump_cooling_compressor_type')
    step.setArgument('heat_pump_heating_capacity', '52000.0')
    step.setArgument('heat_pump_heating_capacity_17F', '29500.0')
    step.setArgument('heat_pump_cooling_efficiency_seer', 19.0)
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeNaturalGas)
    step.setArgument('heat_pump_backup_heating_efficiency', 0.95)
    step.setArgument('heat_pump_backup_heating_capacity', '36000.0')
    step.setArgument('heat_pump_mini_split_is_ducted', true)
    step.setArgument('ducts_supply_leakage_value', 15.0)
    step.setArgument('ducts_return_leakage_value', 5.0)
    step.setArgument('ducts_supply_insulation_r', 0.0)
    step.setArgument('ducts_supply_surface_area', '30.0')
    step.setArgument('ducts_return_surface_area', '10.0')
    step.setArgument('heat_pump_backup_heating_switchover_temp', 25)
  elsif ['base-hvac-ducts-leakage-percent.osw'].include? osw_file
    step.setArgument('ducts_supply_leakage_units', HPXML::UnitsPercent)
    step.setArgument('ducts_return_leakage_units', HPXML::UnitsPercent)
    step.setArgument('ducts_supply_leakage_value', 0.1)
    step.setArgument('ducts_return_leakage_value', 0.05)
  elsif ['base-hvac-elec-resistance-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeElectricResistance)
    step.setArgument('heating_system_fuel', HPXML::FuelTypeElectricity)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-evap-cooler-furnace-gas.osw'].include? osw_file
    step.setArgument('cooling_system_type', HPXML::HVACTypeEvaporativeCooler)
    step.removeArgument('cooling_system_cooling_compressor_type')
    step.removeArgument('cooling_system_cooling_sensible_heat_fraction')
  elsif ['base-hvac-evap-cooler-only.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', HPXML::HVACTypeEvaporativeCooler)
    step.removeArgument('cooling_system_cooling_compressor_type')
    step.removeArgument('cooling_system_cooling_sensible_heat_fraction')
  elsif ['base-hvac-evap-cooler-only-ducted.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', HPXML::HVACTypeEvaporativeCooler)
    step.removeArgument('cooling_system_cooling_compressor_type')
    step.removeArgument('cooling_system_cooling_sensible_heat_fraction')
    step.setArgument('cooling_system_evap_cooler_is_ducted', true)
  elsif ['base-hvac-fireplace-wood-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeFireplace)
    step.setArgument('heating_system_fuel', HPXML::FuelTypeWood)
    step.setArgument('heating_system_heating_efficiency_percent', 0.8)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-floor-furnace-propane-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeFloorFurnace)
    step.setArgument('heating_system_fuel', HPXML::FuelTypePropane)
    step.setArgument('heating_system_heating_efficiency_afue', 0.8)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-furnace-elec-central-ac-1-speed.osw'].include? osw_file
    step.setArgument('heating_system_fuel', HPXML::FuelTypeElectricity)
    step.setArgument('heating_system_heating_efficiency_afue', 1.0)
  elsif ['base-hvac-furnace-elec-only.osw'].include? osw_file
    step.setArgument('heating_system_fuel', HPXML::FuelTypeElectricity)
    step.setArgument('heating_system_heating_efficiency_afue', 1.0)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-furnace-gas-central-ac-2-speed.osw'].include? osw_file
    step.setArgument('cooling_system_cooling_efficiency_seer', 18.0)
    step.setArgument('cooling_system_cooling_compressor_type', HPXML::HVACCompressorTypeTwoStage)
  elsif ['base-hvac-furnace-gas-central-ac-var-speed.osw'].include? osw_file
    step.setArgument('cooling_system_cooling_efficiency_seer', 24.0)
    step.setArgument('cooling_system_cooling_compressor_type', HPXML::HVACCompressorTypeVariableSpeed)
    step.setArgument('cooling_system_cooling_sensible_heat_fraction', 0.78)
  elsif ['base-hvac-furnace-gas-only.osw'].include? osw_file
    step.setArgument('heating_system_electric_auxiliary_energy', 700.0)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-furnace-gas-room-ac.osw'].include? osw_file
    step.setArgument('cooling_system_type', HPXML::HVACTypeRoomAirConditioner)
    step.removeArgument('cooling_system_cooling_compressor_type')
    step.setArgument('cooling_system_cooling_sensible_heat_fraction', 0.65)
  elsif ['base-hvac-furnace-oil-only.osw'].include? osw_file
    step.setArgument('heating_system_fuel', HPXML::FuelTypeOil)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-furnace-propane-only.osw'].include? osw_file
    step.setArgument('heating_system_fuel', HPXML::FuelTypePropane)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-furnace-wood-only.osw'].include? osw_file
    step.setArgument('heating_system_fuel', HPXML::FuelTypeWood)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-ground-to-air-heat-pump.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpGroundToAir)
    step.setArgument('heat_pump_heating_efficiency_cop', 3.6)
    step.setArgument('heat_pump_cooling_efficiency_eer', 16.6)
    step.removeArgument('heat_pump_cooling_compressor_type')
    step.setArgument('heat_pump_heating_capacity', '42000.0')
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeElectricity)
  elsif ['base-hvac-mini-split-heat-pump-ducted.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpMiniSplit)
    step.setArgument('heat_pump_heating_capacity', '52000.0')
    step.setArgument('heat_pump_heating_capacity_17F', '29500.0')
    step.setArgument('heat_pump_heating_efficiency_hspf', 10.0)
    step.setArgument('heat_pump_cooling_efficiency_seer', 19.0)
    step.removeArgument('heat_pump_cooling_compressor_type')
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeElectricity)
    step.setArgument('heat_pump_mini_split_is_ducted', true)
    step.setArgument('ducts_supply_leakage_value', 15.0)
    step.setArgument('ducts_return_leakage_value', 5.0)
    step.setArgument('ducts_supply_insulation_r', 0.0)
    step.setArgument('ducts_supply_surface_area', '30.0')
    step.setArgument('ducts_return_surface_area', '10.0')
  elsif ['base-hvac-mini-split-heat-pump-ducted-cooling-only.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpMiniSplit)
    step.setArgument('heat_pump_heating_efficiency_hspf', 10.0)
    step.setArgument('heat_pump_cooling_efficiency_seer', 19.0)
    step.removeArgument('heat_pump_cooling_compressor_type')
    step.setArgument('heat_pump_heating_capacity', '0')
    step.setArgument('heat_pump_heating_capacity_17F', '0')
    step.setArgument('heat_pump_fraction_heat_load_served', 0)
    step.setArgument('heat_pump_mini_split_is_ducted', true)
    step.setArgument('ducts_supply_leakage_value', 15.0)
    step.setArgument('ducts_return_leakage_value', 5.0)
    step.setArgument('ducts_supply_insulation_r', 0.0)
    step.setArgument('ducts_supply_surface_area', '30.0')
    step.setArgument('ducts_return_surface_area', '10.0')
  elsif ['base-hvac-mini-split-heat-pump-ducted-heating-only.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpMiniSplit)
    step.setArgument('heat_pump_heating_capacity', '52000.0')
    step.setArgument('heat_pump_heating_capacity_17F', '29500.0')
    step.setArgument('heat_pump_heating_efficiency_hspf', 10.0)
    step.setArgument('heat_pump_cooling_efficiency_seer', 19.0)
    step.removeArgument('heat_pump_cooling_compressor_type')
    step.setArgument('heat_pump_cooling_capacity', '0')
    step.setArgument('heat_pump_fraction_cool_load_served', 0)
    step.setArgument('heat_pump_backup_fuel', HPXML::FuelTypeElectricity)
    step.setArgument('heat_pump_mini_split_is_ducted', true)
    step.setArgument('ducts_supply_leakage_value', 15.0)
    step.setArgument('ducts_return_leakage_value', 5.0)
    step.setArgument('ducts_supply_insulation_r', 0.0)
    step.setArgument('ducts_supply_surface_area', '30.0')
    step.setArgument('ducts_return_surface_area', '10.0')
  elsif ['base-hvac-mini-split-heat-pump-ductless.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpMiniSplit)
    step.setArgument('heat_pump_heating_capacity', '52000.0')
    step.removeArgument('heat_pump_cooling_compressor_type')
    step.setArgument('heat_pump_heating_capacity_17F', '29500.0')
    step.setArgument('heat_pump_heating_efficiency_hspf', 10.0)
    step.setArgument('heat_pump_cooling_efficiency_seer', 19.0)
  elsif ['base-hvac-none.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-portable-heater-electric-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypePortableHeater)
    step.setArgument('heating_system_fuel', HPXML::FuelTypeElectricity)
    step.setArgument('heating_system_heating_efficiency_percent', 1.0)
  elsif ['base-hvac-programmable-thermostat.osw'].include? osw_file
    step.setArgument('setpoint_heating_setback_temp', 66)
    step.setArgument('setpoint_heating_setback_hours_per_week', 49)
    step.setArgument('setpoint_heating_setback_start_hour', 23)
    step.setArgument('setpoint_cooling_setup_temp', 80)
    step.setArgument('setpoint_cooling_setup_hours_per_week', 42)
    step.setArgument('setpoint_cooling_setup_start_hour', 9)
  elsif ['base-hvac-room-ac-only.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', HPXML::HVACTypeRoomAirConditioner)
    step.removeArgument('cooling_system_cooling_compressor_type')
    step.setArgument('cooling_system_cooling_sensible_heat_fraction', 0.65)
  elsif ['base-hvac-room-ac-only-33percent.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', HPXML::HVACTypeRoomAirConditioner)
    step.removeArgument('cooling_system_cooling_compressor_type')
    step.setArgument('cooling_system_cooling_sensible_heat_fraction', 0.65)
    step.setArgument('cooling_system_fraction_cool_load_served', 0.33)
  elsif ['base-hvac-setpoints.osw'].include? osw_file
    step.setArgument('setpoint_heating_temp', 60.0)
    step.setArgument('setpoint_cooling_temp', 80.0)
  elsif ['base-hvac-stove-oil-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeStove)
    step.setArgument('heating_system_fuel', HPXML::FuelTypeOil)
    step.setArgument('heating_system_heating_efficiency_percent', 0.8)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-stove-wood-pellets-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeStove)
    step.setArgument('heating_system_fuel', HPXML::FuelTypeWoodPellets)
    step.setArgument('heating_system_heating_efficiency_percent', 0.8)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-hvac-undersized.osw'].include? osw_file
    step.setArgument('heating_system_heating_capacity', '6400.0')
    step.setArgument('cooling_system_cooling_capacity', '4800.0')
    step.setArgument('ducts_supply_leakage_value', 7.5)
    step.setArgument('ducts_return_leakage_value', 2.5)
  elsif ['base-hvac-wall-furnace-elec-only.osw'].include? osw_file
    step.setArgument('heating_system_type', HPXML::HVACTypeWallFurnace)
    step.setArgument('heating_system_fuel', HPXML::FuelTypeElectricity)
    step.setArgument('heating_system_heating_efficiency_afue', 1.0)
    step.setArgument('heating_system_electric_auxiliary_energy', 200.0)
    step.setArgument('cooling_system_type', 'none')
  elsif ['base-location-baltimore-md.osw'].include? osw_file
    step.setArgument('weather_station_epw_filepath', 'USA_MD_Baltimore-Washington.Intl.AP.724060_TMY3.epw')
  elsif ['base-location-dallas-tx.osw'].include? osw_file
    step.setArgument('weather_station_epw_filepath', 'USA_TX_Dallas-Fort.Worth.Intl.AP.722590_TMY3.epw')
  elsif ['base-location-duluth-mn.osw'].include? osw_file
    step.setArgument('weather_station_epw_filepath', 'USA_MN_Duluth.Intl.AP.727450_TMY3.epw')
  elsif ['base-location-epw-filepath.osw'].include? osw_file
  elsif ['base-location-epw-filepath-AMY-2012.osw'].include? osw_file
    step.setArgument('weather_station_epw_filepath', 'US_CO_Boulder_AMY_2012.epw')
  elsif ['base-location-miami-fl.osw'].include? osw_file
    step.setArgument('weather_station_epw_filepath', 'USA_FL_Miami.Intl.AP.722020_TMY3.epw')
  elsif ['base-mechvent-balanced.osw'].include? osw_file
    step.setArgument('mech_vent_fan_type', HPXML::MechVentTypeBalanced)
    step.setArgument('mech_vent_fan_power', 60)
  elsif ['base-mechvent-bath-kitchen-fans.osw'].include? osw_file
    step.setArgument('kitchen_fan_present', true)
    step.setArgument('bathroom_fans_present', true)
  elsif ['base-mechvent-cfis.osw'].include? osw_file
    step.setArgument('mech_vent_fan_type', HPXML::MechVentTypeCFIS)
    step.setArgument('mech_vent_flow_rate', 330)
    step.setArgument('mech_vent_hours_in_operation', 8)
    step.setArgument('mech_vent_fan_power', 300)
  elsif ['base-mechvent-cfis-evap-cooler-only-ducted.osw'].include? osw_file
    step.setArgument('heating_system_type', 'none')
    step.setArgument('cooling_system_type', HPXML::HVACTypeEvaporativeCooler)
    step.removeArgument('cooling_system_cooling_compressor_type')
    step.removeArgument('cooling_system_cooling_sensible_heat_fraction')
    step.setArgument('cooling_system_evap_cooler_is_ducted', true)
    step.setArgument('mech_vent_fan_type', HPXML::MechVentTypeCFIS)
    step.setArgument('mech_vent_flow_rate', 330)
    step.setArgument('mech_vent_hours_in_operation', 8)
    step.setArgument('mech_vent_fan_power', 300)
  elsif ['base-mechvent-erv.osw'].include? osw_file
    step.setArgument('mech_vent_fan_type', HPXML::MechVentTypeERV)
    step.setArgument('mech_vent_fan_power', 60)
  elsif ['base-mechvent-erv-atre-asre.osw'].include? osw_file
    step.setArgument('mech_vent_fan_type', HPXML::MechVentTypeERV)
    step.setArgument('mech_vent_total_recovery_efficiency_type', 'Adjusted')
    step.setArgument('mech_vent_total_recovery_efficiency', 0.526)
    step.setArgument('mech_vent_sensible_recovery_efficiency_type', 'Adjusted')
    step.setArgument('mech_vent_sensible_recovery_efficiency', 0.79)
    step.setArgument('mech_vent_fan_power', 60)
  elsif ['base-mechvent-exhaust.osw'].include? osw_file
    step.setArgument('mech_vent_fan_type', HPXML::MechVentTypeExhaust)
  elsif ['base-mechvent-hrv.osw'].include? osw_file
    step.setArgument('mech_vent_fan_type', HPXML::MechVentTypeHRV)
    step.setArgument('mech_vent_fan_power', 60)
  elsif ['base-mechvent-hrv-asre.osw'].include? osw_file
    step.setArgument('mech_vent_fan_type', HPXML::MechVentTypeHRV)
    step.setArgument('mech_vent_sensible_recovery_efficiency_type', 'Adjusted')
    step.setArgument('mech_vent_sensible_recovery_efficiency', 0.79)
    step.setArgument('mech_vent_fan_power', 60)
  elsif ['base-mechvent-supply.osw'].include? osw_file
    step.setArgument('mech_vent_fan_type', HPXML::MechVentTypeSupply)
  elsif ['base-misc-ceiling-fans.osw'].include? osw_file
    step.setArgument('ceiling_fan_efficiency', 100.0)
    step.setArgument('ceiling_fan_quantity', '2')
    step.setArgument('ceiling_fan_cooling_setpoint_temp_offset', 0.5)
  elsif ['base-misc-defaults.osw'].include? osw_file

  elsif ['base-misc-defaults2.osw'].include? osw_file
    step.setArgument('water_heater_location', Constants.Auto)
    step.setArgument('water_heater_tank_volume', Constants.Auto)
    step.setArgument('water_heater_efficiency_type', 'UniformEnergyFactor')
    step.setArgument('water_heater_heating_capacity', Constants.Auto)
    step.setArgument('water_heater_setpoint_temperature', Constants.Auto)
    step.setArgument('dhw_distribution_system_type', HPXML::DHWDistTypeRecirc)
    step.setArgument('dhw_distribution_recirc_control_type', HPXML::DHWRecirControlTypeSensor)
    step.setArgument('dhw_distribution_recirc_piping_length', Constants.Auto)
    step.setArgument('dhw_distribution_recirc_branch_piping_length', Constants.Auto)
    step.setArgument('dhw_distribution_recirc_pump_power', Constants.Auto)
    step.setArgument('dhw_distribution_pipe_r', 3)
  elsif ['base-misc-neighbor-shading.osw'].include? osw_file
    step.setArgument('neighbor_back_distance', 10)
    step.setArgument('neighbor_front_distance', 15)
    step.setArgument('neighbor_front_height', '12')
  elsif ['base-misc-runperiod-1-month.osw'].include? osw_file
    step.setArgument('simulation_control_end_month', 1)
  elsif ['base-misc-timestep-10-mins.osw'].include? osw_file
    step.setArgument('simulation_control_timestep', 10)
  elsif ['base-misc-usage-multiplier.osw'].include? osw_file
    step.setArgument('water_fixtures_usage_multiplier', 0.9)
    step.setArgument('lighting_usage_multiplier', 0.9)
    step.setArgument('clothes_washer_usage_multiplier', 0.9)
    step.setArgument('clothes_dryer_usage_multiplier', 0.9)
    step.setArgument('dishwasher_usage_multiplier', 0.9)
    step.setArgument('refrigerator_usage_multiplier', 0.9)
    step.setArgument('cooking_range_oven_usage_multiplier', 0.9)
    step.setArgument('plug_loads_usage_multiplier', 0.9)
  elsif ['base-misc-whole-house-fan.osw'].include? osw_file
    step.setArgument('whole_house_fan_present', true)
  elsif ['base-pv.osw'].include? osw_file
    step.setArgument('pv_system_module_type_1', HPXML::PVModuleTypeStandard)
    step.setArgument('pv_system_module_type_2', HPXML::PVModuleTypePremium)
    step.setArgument('pv_system_array_azimuth_2', 90)
    step.setArgument('pv_system_max_power_output_2', 1500)
  elsif ['extra-auto.osw'].include? osw_file
    step.setArgument('geometry_num_occupants', Constants.Auto)
    step.setArgument('ducts_supply_location', Constants.Auto)
    step.setArgument('ducts_return_location', Constants.Auto)
    step.setArgument('ducts_supply_surface_area', Constants.Auto)
    step.setArgument('ducts_return_surface_area', Constants.Auto)
    step.setArgument('water_heater_location', Constants.Auto)
    step.setArgument('water_heater_tank_volume', Constants.Auto)
    step.setArgument('dhw_distribution_standard_piping_length', Constants.Auto)
    step.setArgument('clothes_washer_location', Constants.Auto)
    step.setArgument('clothes_dryer_location', Constants.Auto)
    step.setArgument('refrigerator_location', Constants.Auto)
  elsif ['extra-pv-roofpitch.osw'].include? osw_file
    step.setArgument('pv_system_module_type_1', HPXML::PVModuleTypeStandard)
    step.setArgument('pv_system_module_type_2', HPXML::PVModuleTypeStandard)
    step.setArgument('pv_system_array_tilt_1', 'roofpitch')
    step.setArgument('pv_system_array_tilt_2', 'roofpitch+15')
  elsif ['extra-dhw-solar-latitude.osw'].include? osw_file
    step.setArgument('solar_thermal_system_type', 'hot water')
    step.setArgument('solar_thermal_collector_tilt', 'latitude-15')
  elsif ['extra-second-refrigerator.osw'].include? osw_file
    step.setArgument('extra_refrigerator_present', true)
  elsif ['invalid_files/non-electric-heat-pump-water-heater.osw'].include? osw_file
    step.setArgument('water_heater_type', HPXML::WaterHeaterTypeHeatPump)
    step.setArgument('water_heater_fuel_type', HPXML::FuelTypeNaturalGas)
  elsif ['invalid_files/multiple-heating-and-cooling-systems.osw'].include? osw_file
    step.setArgument('heat_pump_type', HPXML::HVACTypeHeatPumpAirToAir)
  elsif ['invalid_files/non-integer-geometry-num-bathrooms.osw'].include? osw_file
    step.setArgument('geometry_num_bathrooms', '1.5')
  elsif ['invalid_files/non-integer-ceiling-fan-quantity.osw'].include? osw_file
    step.setArgument('ceiling_fan_quantity', '0.5')
  elsif ['invalid_files/single-family-detached-slab-non-zero-foundation-height.osw'].include? osw_file
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeSlab)
    step.setArgument('geometry_foundation_height_above_grade', 0.0)
  elsif ['invalid_files/single-family-detached-finished-basement-zero-foundation-height.osw'].include? osw_file
    step.setArgument('geometry_foundation_height', 0.0)
  elsif ['invalid_files/single-family-attached-ambient.osw'].include? osw_file
    step.setArgument('geometry_unit_type', HPXML::ResidentialTypeSFA)
    step.setArgument('geometry_corridor_position', 'None')
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeAmbient)
  elsif ['invalid_files/multifamily-bottom-slab-non-zero-foundation-height.osw'].include? osw_file
    step.setArgument('geometry_unit_type', HPXML::ResidentialTypeMF)
    step.setArgument('geometry_corridor_position', 'None')
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeSlab)
    step.setArgument('geometry_foundation_height_above_grade', 0.0)
  elsif ['invalid_files/multifamily-bottom-crawlspace-zero-foundation-height.osw'].include? osw_file
    step.setArgument('geometry_unit_type', HPXML::ResidentialTypeMF)
    step.setArgument('geometry_corridor_position', 'None')
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeCrawlspaceUnvented)
    step.setArgument('geometry_foundation_height', 0.0)
  elsif ['invalid_files/slab-non-zero-foundation-height-above-grade.osw'].include? osw_file
    step.setArgument('geometry_foundation_type', HPXML::FoundationTypeSlab)
    step.setArgument('geometry_foundation_height', 0.0)
  elsif ['invalid_files/ducts-location-and-areas-not-same-type.osw'].include? osw_file
    step.setArgument('ducts_supply_location', Constants.Auto)
  end
  return step
end

# frozen_string_literal: true

def create_hpxmls
  require 'oga'
  require_relative 'HPXMLtoOpenStudio/resources/constants'
  require_relative 'HPXMLtoOpenStudio/resources/hotwater_appliances'
  require_relative 'HPXMLtoOpenStudio/resources/hpxml'
  require_relative 'HPXMLtoOpenStudio/resources/misc_loads'
  require_relative 'HPXMLtoOpenStudio/resources/waterheater'
  require_relative 'HPXMLtoOpenStudio/resources/xmlhelper'

  this_dir = File.dirname(__FILE__)
  sample_files_dir = File.join(this_dir, 'workflow/sample_files')

  # Hash of HPXML -> Parent HPXML
  hpxmls_files = {
    'base.xml' => nil,

    'ASHRAE_Standard_140/L100AC.xml' => nil,
    'ASHRAE_Standard_140/L100AL.xml' => nil,
    'ASHRAE_Standard_140/L110AC.xml' => 'ASHRAE_Standard_140/L100AC.xml',
    'ASHRAE_Standard_140/L110AL.xml' => 'ASHRAE_Standard_140/L100AL.xml',
    'ASHRAE_Standard_140/L120AC.xml' => 'ASHRAE_Standard_140/L100AC.xml',
    'ASHRAE_Standard_140/L120AL.xml' => 'ASHRAE_Standard_140/L100AL.xml',
    'ASHRAE_Standard_140/L130AC.xml' => 'ASHRAE_Standard_140/L100AC.xml',
    'ASHRAE_Standard_140/L130AL.xml' => 'ASHRAE_Standard_140/L100AL.xml',
    'ASHRAE_Standard_140/L140AC.xml' => 'ASHRAE_Standard_140/L100AC.xml',
    'ASHRAE_Standard_140/L140AL.xml' => 'ASHRAE_Standard_140/L100AL.xml',
    'ASHRAE_Standard_140/L150AC.xml' => 'ASHRAE_Standard_140/L100AC.xml',
    'ASHRAE_Standard_140/L150AL.xml' => 'ASHRAE_Standard_140/L100AL.xml',
    'ASHRAE_Standard_140/L160AC.xml' => 'ASHRAE_Standard_140/L100AC.xml',
    'ASHRAE_Standard_140/L160AL.xml' => 'ASHRAE_Standard_140/L100AL.xml',
    'ASHRAE_Standard_140/L170AC.xml' => 'ASHRAE_Standard_140/L100AC.xml',
    'ASHRAE_Standard_140/L170AL.xml' => 'ASHRAE_Standard_140/L100AL.xml',
    'ASHRAE_Standard_140/L200AC.xml' => 'ASHRAE_Standard_140/L100AC.xml',
    'ASHRAE_Standard_140/L200AL.xml' => 'ASHRAE_Standard_140/L100AL.xml',
    'ASHRAE_Standard_140/L302XC.xml' => 'ASHRAE_Standard_140/L100AC.xml',
    'ASHRAE_Standard_140/L322XC.xml' => 'ASHRAE_Standard_140/L100AC.xml',
    'ASHRAE_Standard_140/L155AC.xml' => 'ASHRAE_Standard_140/L150AC.xml',
    'ASHRAE_Standard_140/L155AL.xml' => 'ASHRAE_Standard_140/L150AL.xml',
    'ASHRAE_Standard_140/L202AC.xml' => 'ASHRAE_Standard_140/L200AC.xml',
    'ASHRAE_Standard_140/L202AL.xml' => 'ASHRAE_Standard_140/L200AL.xml',
    'ASHRAE_Standard_140/L304XC.xml' => 'ASHRAE_Standard_140/L302XC.xml',
    'ASHRAE_Standard_140/L324XC.xml' => 'ASHRAE_Standard_140/L322XC.xml',

    'invalid_files/cfis-with-hydronic-distribution.xml' => 'base-hvac-boiler-gas-only.xml',
    'invalid_files/clothes-washer-location.xml' => 'base.xml',
    'invalid_files/clothes-dryer-location.xml' => 'base.xml',
    'invalid_files/cooking-range-location.xml' => 'base.xml',
    'invalid_files/appliances-location-unconditioned-space.xml' => 'base.xml',
    'invalid_files/dhw-frac-load-served.xml' => 'base-dhw-multiple.xml',
    'invalid_files/dishwasher-location.xml' => 'base.xml',
    'invalid_files/duct-location.xml' => 'base.xml',
    'invalid_files/duct-location-unconditioned-space.xml' => 'base.xml',
    'invalid_files/duplicate-id.xml' => 'base.xml',
    'invalid_files/enclosure-attic-missing-roof.xml' => 'base.xml',
    'invalid_files/enclosure-basement-missing-exterior-foundation-wall.xml' => 'base-foundation-unconditioned-basement.xml',
    'invalid_files/enclosure-basement-missing-slab.xml' => 'base-foundation-unconditioned-basement.xml',
    'invalid_files/enclosure-garage-missing-exterior-wall.xml' => 'base-enclosure-garage.xml',
    'invalid_files/enclosure-garage-missing-roof-ceiling.xml' => 'base-enclosure-garage.xml',
    'invalid_files/enclosure-garage-missing-slab.xml' => 'base-enclosure-garage.xml',
    'invalid_files/enclosure-living-missing-ceiling-roof.xml' => 'base.xml',
    'invalid_files/enclosure-living-missing-exterior-wall.xml' => 'base.xml',
    'invalid_files/enclosure-living-missing-floor-slab.xml' => 'base.xml',
    'invalid_files/heat-pump-mixed-fixed-and-autosize-capacities.xml' => 'base-hvac-air-to-air-heat-pump-1-speed.xml',
    'invalid_files/heat-pump-mixed-fixed-and-autosize-capacities2.xml' => 'base-hvac-air-to-air-heat-pump-1-speed.xml',
    'invalid_files/hvac-invalid-distribution-system-type.xml' => 'base.xml',
    'invalid_files/hvac-distribution-multiple-attached-cooling.xml' => 'base-hvac-multiple.xml',
    'invalid_files/hvac-distribution-multiple-attached-heating.xml' => 'base-hvac-multiple.xml',
    'invalid_files/hvac-distribution-return-duct-leakage-missing.xml' => 'base-hvac-evap-cooler-only-ducted.xml',
    'invalid_files/hvac-dse-multiple-attached-cooling.xml' => 'base-hvac-dse.xml',
    'invalid_files/hvac-dse-multiple-attached-heating.xml' => 'base-hvac-dse.xml',
    'invalid_files/hvac-frac-load-served.xml' => 'base-hvac-multiple.xml',
    'invalid_files/invalid-epw-filepath.xml' => 'base-location-epw-filepath.xml',
    'invalid_files/invalid-neighbor-shading-azimuth.xml' => 'base-misc-neighbor-shading.xml',
    'invalid_files/invalid-relatedhvac-dhw-indirect.xml' => 'base-dhw-indirect.xml',
    'invalid_files/invalid-relatedhvac-desuperheater.xml' => 'base-hvac-central-ac-only-1-speed.xml',
    'invalid_files/invalid-timestep.xml' => 'base.xml',
    'invalid_files/invalid-runperiod.xml' => 'base.xml',
    'invalid_files/invalid-window-height.xml' => 'base-enclosure-overhangs.xml',
    'invalid_files/invalid-window-interior-shading.xml' => 'base.xml',
    'invalid_files/invalid-wmo.xml' => 'base.xml',
    'invalid_files/lighting-fractions.xml' => 'base.xml',
    'invalid_files/missing-elements.xml' => 'base.xml',
    'invalid_files/net-area-negative-roof.xml' => 'base-enclosure-skylights.xml',
    'invalid_files/net-area-negative-wall.xml' => 'base.xml',
    'invalid_files/orphaned-hvac-distribution.xml' => 'base-hvac-furnace-gas-room-ac.xml',
    'invalid_files/refrigerator-location.xml' => 'base.xml',
    'invalid_files/repeated-relatedhvac-dhw-indirect.xml' => 'base-dhw-indirect.xml',
    'invalid_files/repeated-relatedhvac-desuperheater.xml' => 'base-hvac-central-ac-only-1-speed.xml',
    'invalid_files/slab-zero-exposed-perimeter.xml' => 'base.xml',
    'invalid_files/solar-thermal-system-with-combi-tankless.xml' => 'base-dhw-combi-tankless.xml',
    'invalid_files/solar-thermal-system-with-desuperheater.xml' => 'base-dhw-desuperheater.xml',
    'invalid_files/solar-thermal-system-with-dhw-indirect.xml' => 'base-dhw-combi-tankless.xml',
    'invalid_files/unattached-cfis.xml' => 'base.xml',
    'invalid_files/unattached-door.xml' => 'base.xml',
    'invalid_files/unattached-hvac-distribution.xml' => 'base.xml',
    'invalid_files/unattached-skylight.xml' => 'base-enclosure-skylights.xml',
    'invalid_files/unattached-solar-thermal-system.xml' => 'base-dhw-solar-indirect-flat-plate.xml',
    'invalid_files/unattached-window.xml' => 'base.xml',
    'invalid_files/water-heater-location.xml' => 'base.xml',
    'invalid_files/water-heater-location-other.xml' => 'base.xml',
    'invalid_files/attached-multifamily-window-outside-condition.xml' => 'base-enclosure-attached-multifamily.xml',
    'invalid_files/missing-duct-location.xml' => 'base-hvac-multiple.xml',
    'invalid_files/invalid-distribution-cfa-served.xml' => 'base.xml',
    'base-appliances-dehumidifier.xml' => 'base-location-dallas-tx.xml',
    'base-appliances-dehumidifier-ief.xml' => 'base-appliances-dehumidifier.xml',
    'base-appliances-dehumidifier-50percent.xml' => 'base-appliances-dehumidifier.xml',
    'base-appliances-gas.xml' => 'base.xml',
    'base-appliances-wood.xml' => 'base.xml',
    'base-appliances-modified.xml' => 'base.xml',
    'base-appliances-none.xml' => 'base.xml',
    'base-appliances-oil.xml' => 'base.xml',
    'base-appliances-propane.xml' => 'base.xml',
    'base-atticroof-cathedral.xml' => 'base.xml',
    'base-atticroof-conditioned.xml' => 'base.xml',
    'base-atticroof-flat.xml' => 'base.xml',
    'base-atticroof-radiant-barrier.xml' => 'base-location-dallas-tx.xml',
    'base-atticroof-vented.xml' => 'base.xml',
    'base-atticroof-unvented-insulated-roof.xml' => 'base.xml',
    'base-dhw-combi-tankless.xml' => 'base-dhw-indirect.xml',
    'base-dhw-combi-tankless-outside.xml' => 'base-dhw-combi-tankless.xml',
    'base-dhw-desuperheater.xml' => 'base-hvac-central-ac-only-1-speed.xml',
    'base-dhw-desuperheater-hpwh.xml' => 'base-dhw-tank-heat-pump.xml',
    'base-dhw-desuperheater-tankless.xml' => 'base-hvac-central-ac-only-1-speed.xml',
    'base-dhw-desuperheater-2-speed.xml' => 'base-hvac-central-ac-only-2-speed.xml',
    'base-dhw-desuperheater-var-speed.xml' => 'base-hvac-central-ac-only-var-speed.xml',
    'base-dhw-desuperheater-gshp.xml' => 'base-hvac-ground-to-air-heat-pump.xml',
    'base-dhw-dwhr.xml' => 'base.xml',
    'base-dhw-indirect.xml' => 'base-hvac-boiler-gas-only.xml',
    'base-dhw-indirect-dse.xml' => 'base-dhw-indirect.xml',
    'base-dhw-indirect-outside.xml' => 'base-dhw-indirect.xml',
    'base-dhw-indirect-standbyloss.xml' => 'base-dhw-indirect.xml',
    'base-dhw-indirect-with-solar-fraction.xml' => 'base-dhw-indirect.xml',
    'base-dhw-low-flow-fixtures.xml' => 'base.xml',
    'base-dhw-multiple.xml' => 'base-hvac-boiler-gas-only.xml',
    'base-dhw-none.xml' => 'base.xml',
    'base-dhw-recirc-demand.xml' => 'base.xml',
    'base-dhw-recirc-manual.xml' => 'base.xml',
    'base-dhw-recirc-nocontrol.xml' => 'base.xml',
    'base-dhw-recirc-temperature.xml' => 'base.xml',
    'base-dhw-recirc-timer.xml' => 'base.xml',
    'base-dhw-solar-direct-evacuated-tube.xml' => 'base.xml',
    'base-dhw-solar-direct-flat-plate.xml' => 'base.xml',
    'base-dhw-solar-direct-ics.xml' => 'base.xml',
    'base-dhw-solar-fraction.xml' => 'base.xml',
    'base-dhw-solar-indirect-flat-plate.xml' => 'base.xml',
    'base-dhw-solar-thermosyphon-flat-plate.xml' => 'base.xml',
    'base-dhw-tank-gas.xml' => 'base.xml',
    'base-dhw-tank-gas-outside.xml' => 'base-dhw-tank-gas.xml',
    'base-dhw-tank-heat-pump.xml' => 'base.xml',
    'base-dhw-tank-heat-pump-outside.xml' => 'base-dhw-tank-heat-pump.xml',
    'base-dhw-tank-heat-pump-with-solar.xml' => 'base-dhw-tank-heat-pump.xml',
    'base-dhw-tank-heat-pump-with-solar-fraction.xml' => 'base-dhw-tank-heat-pump.xml',
    'base-dhw-tank-oil.xml' => 'base.xml',
    'base-dhw-tank-wood.xml' => 'base.xml',
    'base-dhw-tankless-electric.xml' => 'base.xml',
    'base-dhw-tankless-electric-outside.xml' => 'base-dhw-tankless-electric.xml',
    'base-dhw-tankless-gas.xml' => 'base.xml',
    'base-dhw-tankless-gas-with-solar.xml' => 'base-dhw-tankless-gas.xml',
    'base-dhw-tankless-gas-with-solar-fraction.xml' => 'base-dhw-tankless-gas.xml',
    'base-dhw-tankless-propane.xml' => 'base.xml',
    'base-dhw-uef.xml' => 'base.xml',
    'base-dhw-jacket-electric.xml' => 'base.xml',
    'base-dhw-jacket-gas.xml' => 'base-dhw-tank-gas.xml',
    'base-dhw-jacket-indirect.xml' => 'base-dhw-indirect.xml',
    'base-dhw-jacket-hpwh.xml' => 'base-dhw-tank-heat-pump.xml',
    'base-enclosure-2stories.xml' => 'base.xml',
    'base-enclosure-2stories-garage.xml' => 'base-enclosure-2stories.xml',
    'base-enclosure-3d-coordinates.xml' => 'base.xml',
    'base-enclosure-other-housing-unit.xml' => 'base-foundation-ambient.xml',
    'base-enclosure-other-heated-space.xml' => 'base-foundation-ambient.xml',
    'base-enclosure-other-non-freezing-space.xml' => 'base-foundation-ambient.xml',
    'base-enclosure-other-multifamily-buffer-space.xml' => 'base-foundation-ambient.xml',
    'base-enclosure-beds-1.xml' => 'base.xml',
    'base-enclosure-beds-2.xml' => 'base.xml',
    'base-enclosure-beds-4.xml' => 'base.xml',
    'base-enclosure-beds-5.xml' => 'base.xml',
    'base-enclosure-garage.xml' => 'base.xml',
    'base-enclosure-infil-cfm50.xml' => 'base.xml',
    'base-enclosure-infil-natural-ach.xml' => 'base.xml',
    'base-enclosure-overhangs.xml' => 'base.xml',
    'base-enclosure-skylights.xml' => 'base.xml',
    'base-enclosure-split-surfaces.xml' => 'base-enclosure-skylights.xml',
    'base-enclosure-walltypes.xml' => 'base.xml',
    'base-enclosure-windows-interior-shading.xml' => 'base.xml',
    'base-enclosure-windows-none.xml' => 'base.xml',
    'base-enclosure-attached-multifamily.xml' => 'base.xml',
    'base-foundation-multiple.xml' => 'base-foundation-unconditioned-basement.xml',
    'base-foundation-ambient.xml' => 'base.xml',
    'base-foundation-conditioned-basement-slab-insulation.xml' => 'base.xml',
    'base-foundation-conditioned-basement-wall-interior-insulation.xml' => 'base.xml',
    'base-foundation-slab.xml' => 'base.xml',
    'base-foundation-unconditioned-basement.xml' => 'base.xml',
    'base-foundation-unconditioned-basement-assembly-r.xml' => 'base-foundation-unconditioned-basement.xml',
    'base-foundation-unconditioned-basement-above-grade.xml' => 'base-foundation-unconditioned-basement.xml',
    'base-foundation-unconditioned-basement-wall-insulation.xml' => 'base-foundation-unconditioned-basement.xml',
    'base-foundation-unvented-crawlspace.xml' => 'base.xml',
    'base-foundation-vented-crawlspace.xml' => 'base.xml',
    'base-foundation-walkout-basement.xml' => 'base.xml',
    'base-foundation-complex.xml' => 'base.xml',
    'base-hvac-air-to-air-heat-pump-1-speed.xml' => 'base.xml',
    'base-hvac-air-to-air-heat-pump-2-speed.xml' => 'base.xml',
    'base-hvac-air-to-air-heat-pump-var-speed.xml' => 'base.xml',
    'base-hvac-boiler-elec-only.xml' => 'base.xml',
    'base-hvac-boiler-gas-central-ac-1-speed.xml' => 'base.xml',
    'base-hvac-boiler-gas-only.xml' => 'base.xml',
    'base-hvac-boiler-oil-only.xml' => 'base.xml',
    'base-hvac-boiler-propane-only.xml' => 'base.xml',
    'base-hvac-boiler-wood-only.xml' => 'base.xml',
    'base-hvac-central-ac-only-1-speed.xml' => 'base.xml',
    'base-hvac-central-ac-only-2-speed.xml' => 'base.xml',
    'base-hvac-central-ac-only-var-speed.xml' => 'base.xml',
    'base-hvac-central-ac-plus-air-to-air-heat-pump-heating.xml' => 'base-hvac-central-ac-only-1-speed.xml',
    'base-hvac-dse.xml' => 'base.xml',
    'base-hvac-dual-fuel-air-to-air-heat-pump-1-speed.xml' => 'base-hvac-air-to-air-heat-pump-1-speed.xml',
    'base-hvac-dual-fuel-air-to-air-heat-pump-1-speed-electric.xml' => 'base-hvac-dual-fuel-air-to-air-heat-pump-1-speed.xml',
    'base-hvac-dual-fuel-air-to-air-heat-pump-2-speed.xml' => 'base-hvac-air-to-air-heat-pump-2-speed.xml',
    'base-hvac-dual-fuel-air-to-air-heat-pump-var-speed.xml' => 'base-hvac-air-to-air-heat-pump-var-speed.xml',
    'base-hvac-dual-fuel-mini-split-heat-pump-ducted.xml' => 'base-hvac-mini-split-heat-pump-ducted.xml',
    'base-hvac-ducts-leakage-percent.xml' => 'base.xml',
    'base-hvac-elec-resistance-only.xml' => 'base.xml',
    'base-hvac-evap-cooler-furnace-gas.xml' => 'base.xml',
    'base-hvac-evap-cooler-only.xml' => 'base.xml',
    'base-hvac-evap-cooler-only-ducted.xml' => 'base.xml',
    'base-hvac-fireplace-wood-only.xml' => 'base.xml',
    'base-hvac-floor-furnace-propane-only.xml' => 'base.xml',
    'base-hvac-flowrate.xml' => 'base.xml',
    'base-hvac-furnace-elec-central-ac-1-speed.xml' => 'base.xml',
    'base-hvac-furnace-elec-only.xml' => 'base.xml',
    'base-hvac-furnace-gas-central-ac-2-speed.xml' => 'base.xml',
    'base-hvac-furnace-gas-central-ac-var-speed.xml' => 'base.xml',
    'base-hvac-furnace-gas-only.xml' => 'base.xml',
    'base-hvac-furnace-gas-room-ac.xml' => 'base.xml',
    'base-hvac-furnace-oil-only.xml' => 'base.xml',
    'base-hvac-furnace-propane-only.xml' => 'base.xml',
    'base-hvac-furnace-wood-only.xml' => 'base.xml',
    'base-hvac-furnace-x3-dse.xml' => 'base.xml',
    'base-hvac-ground-to-air-heat-pump.xml' => 'base.xml',
    'base-hvac-ideal-air.xml' => 'base.xml',
    'base-hvac-mini-split-heat-pump-ducted.xml' => 'base.xml',
    'base-hvac-mini-split-heat-pump-ducted-heating-only.xml' => 'base-hvac-mini-split-heat-pump-ducted.xml',
    'base-hvac-mini-split-heat-pump-ducted-cooling-only.xml' => 'base-hvac-mini-split-heat-pump-ducted.xml',
    'base-hvac-mini-split-heat-pump-ductless.xml' => 'base-hvac-mini-split-heat-pump-ducted.xml',
    'base-hvac-multiple.xml' => 'base.xml',
    'base-hvac-multiple2.xml' => 'base.xml',
    'base-hvac-none.xml' => 'base.xml',
    'base-hvac-portable-heater-electric-only.xml' => 'base.xml',
    'base-hvac-programmable-thermostat.xml' => 'base.xml',
    'base-hvac-room-ac-only.xml' => 'base.xml',
    'base-hvac-room-ac-only-33percent.xml' => 'base-hvac-room-ac-only.xml',
    'base-hvac-setpoints.xml' => 'base.xml',
    'base-hvac-stove-oil-only.xml' => 'base.xml',
    'base-hvac-stove-wood-pellets-only.xml' => 'base.xml',
    'base-hvac-undersized.xml' => 'base.xml',
    'base-hvac-wall-furnace-elec-only.xml' => 'base.xml',
    'base-location-baltimore-md.xml' => 'base.xml',
    'base-location-dallas-tx.xml' => 'base.xml',
    'base-location-duluth-mn.xml' => 'base.xml',
    'base-location-miami-fl.xml' => 'base.xml',
    'base-location-epw-filepath.xml' => 'base.xml',
    'base-location-epw-filepath-AMY-2012.xml' => 'base.xml',
    'base-mechvent-balanced.xml' => 'base.xml',
    'base-mechvent-cfis.xml' => 'base.xml',
    'base-mechvent-cfis-dse.xml' => 'base-hvac-dse.xml',
    'base-mechvent-cfis-evap-cooler-only-ducted.xml' => 'base-hvac-evap-cooler-only-ducted.xml',
    'base-mechvent-erv.xml' => 'base.xml',
    'base-mechvent-erv-atre-asre.xml' => 'base.xml',
    'base-mechvent-exhaust.xml' => 'base.xml',
    'base-mechvent-exhaust-rated-flow-rate.xml' => 'base.xml',
    'base-mechvent-hrv.xml' => 'base.xml',
    'base-mechvent-hrv-asre.xml' => 'base.xml',
    'base-mechvent-supply.xml' => 'base.xml',
    'base-mechvent-bath-kitchen-fans.xml' => 'base.xml',
    'base-misc-ceiling-fans.xml' => 'base.xml',
    'base-misc-defaults.xml' => 'base.xml',
    'base-misc-defaults2.xml' => 'base-dhw-recirc-demand.xml',
    'base-misc-timestep-10-mins.xml' => 'base.xml',
    'base-misc-runperiod-1-month.xml' => 'base.xml',
    'base-misc-usage-multiplier.xml' => 'base.xml',
    'base-misc-whole-house-fan.xml' => 'base.xml',
    'base-pv.xml' => 'base.xml',
    'base-misc-neighbor-shading.xml' => 'base.xml',

    'hvac_autosizing/base-autosize.xml' => 'base.xml',
    'hvac_autosizing/base-hvac-air-to-air-heat-pump-1-speed-autosize.xml' => 'base-hvac-air-to-air-heat-pump-1-speed.xml',
    'hvac_autosizing/base-hvac-air-to-air-heat-pump-2-speed-autosize.xml' => 'base-hvac-air-to-air-heat-pump-2-speed.xml',
    'hvac_autosizing/base-hvac-air-to-air-heat-pump-var-speed-autosize.xml' => 'base-hvac-air-to-air-heat-pump-var-speed.xml',
    'hvac_autosizing/base-hvac-boiler-elec-only-autosize.xml' => 'base-hvac-boiler-elec-only.xml',
    'hvac_autosizing/base-hvac-boiler-gas-central-ac-1-speed-autosize.xml' => 'base-hvac-boiler-gas-central-ac-1-speed.xml',
    'hvac_autosizing/base-hvac-boiler-gas-only-autosize.xml' => 'base-hvac-boiler-gas-only.xml',
    'hvac_autosizing/base-hvac-central-ac-only-1-speed-autosize.xml' => 'base-hvac-central-ac-only-1-speed.xml',
    'hvac_autosizing/base-hvac-central-ac-only-2-speed-autosize.xml' => 'base-hvac-central-ac-only-2-speed.xml',
    'hvac_autosizing/base-hvac-central-ac-only-var-speed-autosize.xml' => 'base-hvac-central-ac-only-var-speed.xml',
    'hvac_autosizing/base-hvac-central-ac-plus-air-to-air-heat-pump-heating-autosize.xml' => 'base-hvac-central-ac-plus-air-to-air-heat-pump-heating.xml',
    'hvac_autosizing/base-hvac-dual-fuel-air-to-air-heat-pump-1-speed-autosize.xml' => 'base-hvac-dual-fuel-air-to-air-heat-pump-1-speed.xml',
    'hvac_autosizing/base-hvac-dual-fuel-mini-split-heat-pump-ducted-autosize.xml' => 'base-hvac-dual-fuel-mini-split-heat-pump-ducted.xml',
    'hvac_autosizing/base-hvac-elec-resistance-only-autosize.xml' => 'base-hvac-elec-resistance-only.xml',
    'hvac_autosizing/base-hvac-evap-cooler-furnace-gas-autosize.xml' => 'base-hvac-evap-cooler-furnace-gas.xml',
    'hvac_autosizing/base-hvac-floor-furnace-propane-only-autosize.xml' => 'base-hvac-floor-furnace-propane-only.xml',
    'hvac_autosizing/base-hvac-furnace-elec-only-autosize.xml' => 'base-hvac-furnace-elec-only.xml',
    'hvac_autosizing/base-hvac-furnace-gas-central-ac-2-speed-autosize.xml' => 'base-hvac-furnace-gas-central-ac-2-speed.xml',
    'hvac_autosizing/base-hvac-furnace-gas-central-ac-var-speed-autosize.xml' => 'base-hvac-furnace-gas-central-ac-var-speed.xml',
    'hvac_autosizing/base-hvac-furnace-gas-only-autosize.xml' => 'base-hvac-furnace-gas-only.xml',
    'hvac_autosizing/base-hvac-furnace-gas-room-ac-autosize.xml' => 'base-hvac-furnace-gas-room-ac.xml',
    'hvac_autosizing/base-hvac-ground-to-air-heat-pump-autosize.xml' => 'base-hvac-ground-to-air-heat-pump.xml',
    'hvac_autosizing/base-hvac-mini-split-heat-pump-ducted-autosize.xml' => 'base-hvac-mini-split-heat-pump-ducted.xml',
    'hvac_autosizing/base-hvac-room-ac-only-autosize.xml' => 'base-hvac-room-ac-only.xml',
    'hvac_autosizing/base-hvac-stove-oil-only-autosize.xml' => 'base-hvac-stove-oil-only.xml',
    'hvac_autosizing/base-hvac-wall-furnace-elec-only-autosize.xml' => 'base-hvac-wall-furnace-elec-only.xml',
  }

  puts "Generating #{hpxmls_files.size} HPXML files..."

  hpxmls_files.each do |derivative, parent|
    print '.'

    begin
      hpxml_files = [derivative]
      unless parent.nil?
        hpxml_files.unshift(parent)
      end
      while not parent.nil?
        next unless hpxmls_files.keys.include? parent

        unless hpxmls_files[parent].nil?
          hpxml_files.unshift(hpxmls_files[parent])
        end
        parent = hpxmls_files[parent]
      end

      hpxml = HPXML.new
      hpxml_files.each do |hpxml_file|
        set_hpxml_header(hpxml_file, hpxml)
        set_hpxml_site(hpxml_file, hpxml)
        set_hpxml_neighbor_buildings(hpxml_file, hpxml)
        set_hpxml_building_construction(hpxml_file, hpxml)
        set_hpxml_building_occupancy(hpxml_file, hpxml)
        set_hpxml_climate_and_risk_zones(hpxml_file, hpxml)
        set_hpxml_air_infiltration_measurements(hpxml_file, hpxml)
        set_hpxml_attics(hpxml_file, hpxml)
        set_hpxml_foundations(hpxml_file, hpxml)
        set_hpxml_roofs(hpxml_file, hpxml)
        set_hpxml_rim_joists(hpxml_file, hpxml)
        set_hpxml_walls(hpxml_file, hpxml)
        set_hpxml_foundation_walls(hpxml_file, hpxml)
        set_hpxml_frame_floors(hpxml_file, hpxml)
        set_hpxml_slabs(hpxml_file, hpxml)
        set_hpxml_windows(hpxml_file, hpxml)
        set_hpxml_skylights(hpxml_file, hpxml)
        set_hpxml_doors(hpxml_file, hpxml)
        set_hpxml_heating_systems(hpxml_file, hpxml)
        set_hpxml_cooling_systems(hpxml_file, hpxml)
        set_hpxml_heat_pumps(hpxml_file, hpxml)
        set_hpxml_hvac_control(hpxml_file, hpxml)
        set_hpxml_hvac_distributions(hpxml_file, hpxml)
        set_hpxml_ventilation_fans(hpxml_file, hpxml)
        set_hpxml_water_heating_systems(hpxml_file, hpxml)
        set_hpxml_hot_water_distribution(hpxml_file, hpxml)
        set_hpxml_water_fixtures(hpxml_file, hpxml)
        set_hpxml_solar_thermal_system(hpxml_file, hpxml)
        set_hpxml_pv_systems(hpxml_file, hpxml)
        set_hpxml_clothes_washer(hpxml_file, hpxml)
        set_hpxml_clothes_dryer(hpxml_file, hpxml)
        set_hpxml_dishwasher(hpxml_file, hpxml)
        set_hpxml_refrigerator(hpxml_file, hpxml)
        set_hpxml_dehumidifier(hpxml_file, hpxml)
        set_hpxml_cooking_range(hpxml_file, hpxml)
        set_hpxml_oven(hpxml_file, hpxml)
        set_hpxml_lighting(hpxml_file, hpxml)
        set_hpxml_ceiling_fans(hpxml_file, hpxml)
        set_hpxml_plug_loads(hpxml_file, hpxml)
        set_hpxml_misc_load_schedule(hpxml_file, hpxml)
      end

      hpxml_doc = hpxml.to_oga()

      if ['invalid_files/missing-elements.xml'].include? derivative
        XMLHelper.delete_element(hpxml_doc, '/HPXML/Building/BuildingDetails/BuildingSummary/BuildingConstruction/NumberofConditionedFloors')
        XMLHelper.delete_element(hpxml_doc, '/HPXML/Building/BuildingDetails/BuildingSummary/BuildingConstruction/ConditionedFloorArea')
      end

      if derivative.include? 'ASHRAE_Standard_140'
        hpxml_path = File.join(sample_files_dir, '../tests', derivative)
      else
        hpxml_path = File.join(sample_files_dir, derivative)
      end

      if not hpxml_path.include? 'invalid_files'
        # Validate file against HPXML schema
        schemas_dir = File.absolute_path(File.join(File.dirname(__FILE__), 'HPXMLtoOpenStudio/resources'))
        errors = XMLHelper.validate(hpxml_doc.to_s, File.join(schemas_dir, 'HPXML.xsd'), nil)
        if errors.size > 0
          fail "ERRORS: #{errors}"
        end

        # Check for additional errors
        errors = hpxml.check_for_errors()
        if errors.size > 0
          fail "ERRORS: #{errors}"
        end
      end

      XMLHelper.write_file(hpxml_doc, hpxml_path)
    rescue Exception => e
      puts "\n#{e}\n#{e.backtrace.join('\n')}"
      puts "\nError: Did not successfully generate #{derivative}."
      exit!
    end
  end

  puts "\n"

  # Print warnings about extra files
  abs_hpxml_files = []
  dirs = [nil]
  hpxmls_files.keys.each do |hpxml_file|
    abs_hpxml_files << File.absolute_path(File.join(sample_files_dir, hpxml_file))
    next unless hpxml_file.include? '/'

    dirs << hpxml_file.split('/')[0] + '/'
  end
  dirs.uniq.each do |dir|
    Dir["#{sample_files_dir}/#{dir}*.xml"].each do |xml|
      next if abs_hpxml_files.include? File.absolute_path(xml)

      puts "Warning: Extra HPXML file found at #{File.absolute_path(xml)}"
    end
  end
end

def set_hpxml_header(hpxml_file, hpxml)
  if ['base.xml',
      'ASHRAE_Standard_140/L100AC.xml',
      'ASHRAE_Standard_140/L100AL.xml'].include? hpxml_file
    hpxml.header.xml_type = 'HPXML'
    hpxml.header.xml_generated_by = 'tasks.rb'
    hpxml.header.transaction = 'create'
    hpxml.header.building_id = 'MyBuilding'
    hpxml.header.event_type = 'proposed workscope'
    hpxml.header.created_date_and_time = Time.new(2000, 1, 1).strftime('%Y-%m-%dT%H:%M:%S%:z') # Hard-code to prevent diffs
    if hpxml_file == 'base.xml'
      hpxml.header.timestep = 60
    else
      hpxml.header.apply_ashrae140_assumptions = true
    end
  elsif ['base-misc-timestep-10-mins.xml'].include? hpxml_file
    hpxml.header.timestep = 10
  elsif ['base-misc-runperiod-1-month.xml'].include? hpxml_file
    hpxml.header.end_month = 1
    hpxml.header.end_day_of_month = 31
  elsif ['invalid_files/invalid-timestep.xml'].include? hpxml_file
    hpxml.header.timestep = 45
  elsif ['invalid_files/invalid-runperiod.xml'].include? hpxml_file
    hpxml.header.end_month = 4
    hpxml.header.end_day_of_month = 31
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.header.timestep = nil
  end
end

def set_hpxml_site(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.site.fuels = [HPXML::FuelTypeElectricity, HPXML::FuelTypeNaturalGas]
    hpxml.site.site_type = HPXML::SiteTypeSuburban
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.site.site_type = nil
  end
end

def set_hpxml_neighbor_buildings(hpxml_file, hpxml)
  if ['base-misc-neighbor-shading.xml'].include? hpxml_file
    hpxml.neighbor_buildings.add(azimuth: 0,
                                 distance: 10)
    hpxml.neighbor_buildings.add(azimuth: 180,
                                 distance: 15,
                                 height: 12)
  elsif ['invalid_files/invalid-neighbor-shading-azimuth.xml'].include? hpxml_file
    hpxml.neighbor_buildings[0].azimuth = 145
  end
end

def set_hpxml_building_construction(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L100AC.xml',
      'ASHRAE_Standard_140/L100AL.xml'].include? hpxml_file
    hpxml.building_construction.number_of_conditioned_floors = 1
    hpxml.building_construction.number_of_conditioned_floors_above_grade = 1
    hpxml.building_construction.number_of_bedrooms = 3
    hpxml.building_construction.conditioned_floor_area = 1539
    hpxml.building_construction.conditioned_building_volume = 12312
    hpxml.building_construction.residential_facility_type = HPXML::ResidentialTypeSFD
  elsif ['ASHRAE_Standard_140/L322XC.xml'].include? hpxml_file
    hpxml.building_construction.number_of_conditioned_floors = 2
    hpxml.building_construction.conditioned_floor_area = 3078
    hpxml.building_construction.conditioned_building_volume = 24624
  elsif ['base.xml'].include? hpxml_file
    hpxml.building_construction.residential_facility_type = HPXML::ResidentialTypeSFD
    hpxml.building_construction.number_of_conditioned_floors = 2
    hpxml.building_construction.number_of_conditioned_floors_above_grade = 1
    hpxml.building_construction.number_of_bedrooms = 3
    hpxml.building_construction.conditioned_floor_area = 2700
    hpxml.building_construction.conditioned_building_volume = 2700 * 8
  elsif ['base-enclosure-beds-1.xml'].include? hpxml_file
    hpxml.building_construction.number_of_bedrooms = 1
  elsif ['base-enclosure-beds-2.xml'].include? hpxml_file
    hpxml.building_construction.number_of_bedrooms = 2
  elsif ['base-enclosure-beds-4.xml'].include? hpxml_file
    hpxml.building_construction.number_of_bedrooms = 4
  elsif ['base-enclosure-beds-5.xml'].include? hpxml_file
    hpxml.building_construction.number_of_bedrooms = 5
  elsif ['base-foundation-ambient.xml',
         'base-foundation-slab.xml',
         'base-foundation-unconditioned-basement.xml',
         'base-foundation-unvented-crawlspace.xml',
         'base-foundation-vented-crawlspace.xml'].include? hpxml_file
    hpxml.building_construction.number_of_conditioned_floors -= 1
    hpxml.building_construction.conditioned_floor_area -= 1350
    hpxml.building_construction.conditioned_building_volume -= 1350 * 8
  elsif ['base-hvac-ideal-air.xml'].include? hpxml_file
    hpxml.building_construction.use_only_ideal_air_system = true
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.building_construction.number_of_conditioned_floors += 1
    hpxml.building_construction.number_of_conditioned_floors_above_grade += 1
    hpxml.building_construction.conditioned_floor_area += 900
    hpxml.building_construction.conditioned_building_volume += 2250
  elsif ['base-atticroof-cathedral.xml'].include? hpxml_file
    hpxml.building_construction.conditioned_building_volume += 10800
  elsif ['base-enclosure-2stories.xml'].include? hpxml_file
    hpxml.building_construction.number_of_conditioned_floors += 1
    hpxml.building_construction.number_of_conditioned_floors_above_grade += 1
    hpxml.building_construction.conditioned_floor_area += 1350
    hpxml.building_construction.conditioned_building_volume += 1350 * 8
  elsif ['base-enclosure-2stories-garage.xml'].include? hpxml_file
    hpxml.building_construction.conditioned_floor_area -= 400 * 2
    hpxml.building_construction.conditioned_building_volume -= 400 * 2 * 8
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.building_construction.conditioned_building_volume = nil
    hpxml.building_construction.average_ceiling_height = 8
  elsif ['base-enclosure-attached-multifamily.xml',
         'base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.building_construction.residential_facility_type = HPXML::ResidentialTypeApartment
  elsif ['base-foundation-walkout-basement.xml'].include? hpxml_file
    hpxml.building_construction.number_of_conditioned_floors_above_grade += 1
  end
end

def set_hpxml_building_occupancy(hpxml_file, hpxml)
  if hpxml_file.include?('ASHRAE_Standard_140')
    hpxml.building_occupancy.number_of_residents = 0
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.building_occupancy.number_of_residents = nil
  else
    hpxml.building_occupancy.number_of_residents = hpxml.building_construction.number_of_bedrooms
  end
end

def set_hpxml_climate_and_risk_zones(hpxml_file, hpxml)
  hpxml.climate_and_risk_zones.weather_station_id = 'WeatherStation'
  hpxml.climate_and_risk_zones.iecc_year = 2006
  if hpxml_file == 'ASHRAE_Standard_140/L100AC.xml'
    hpxml.climate_and_risk_zones.weather_station_name = 'Colorado Springs, CO'
    hpxml.climate_and_risk_zones.weather_station_wmo = '724660'
  elsif hpxml_file == 'ASHRAE_Standard_140/L100AL.xml'
    hpxml.climate_and_risk_zones.weather_station_name = 'Las Vegas, NV'
    hpxml.climate_and_risk_zones.weather_station_wmo = '723860'
  elsif ['base.xml'].include? hpxml_file
    hpxml.climate_and_risk_zones.iecc_zone = '5B'
    hpxml.climate_and_risk_zones.weather_station_name = 'Denver, CO'
    hpxml.climate_and_risk_zones.weather_station_wmo = '725650'
  elsif ['base-location-baltimore-md.xml'].include? hpxml_file
    hpxml.climate_and_risk_zones.iecc_zone = '4A'
    hpxml.climate_and_risk_zones.weather_station_name = 'Baltimore, MD'
    hpxml.climate_and_risk_zones.weather_station_wmo = '724060'
  elsif ['base-location-dallas-tx.xml'].include? hpxml_file
    hpxml.climate_and_risk_zones.iecc_zone = '3A'
    hpxml.climate_and_risk_zones.weather_station_name = 'Dallas, TX'
    hpxml.climate_and_risk_zones.weather_station_wmo = '722590'
  elsif ['base-location-duluth-mn.xml'].include? hpxml_file
    hpxml.climate_and_risk_zones.iecc_zone = '7'
    hpxml.climate_and_risk_zones.weather_station_name = 'Duluth, MN'
    hpxml.climate_and_risk_zones.weather_station_wmo = '727450'
  elsif ['base-location-miami-fl.xml'].include? hpxml_file
    hpxml.climate_and_risk_zones.iecc_zone = '1A'
    hpxml.climate_and_risk_zones.weather_station_name = 'Miami, FL'
    hpxml.climate_and_risk_zones.weather_station_wmo = '722020'
  elsif ['base-location-epw-filepath.xml'].include? hpxml_file
    hpxml.climate_and_risk_zones.weather_station_wmo = nil
    hpxml.climate_and_risk_zones.weather_station_epw_filepath = 'USA_CO_Denver.Intl.AP.725650_TMY3.epw'
  elsif ['base-location-epw-filepath-AMY-2012.xml'].include? hpxml_file
    hpxml.climate_and_risk_zones.iecc_year = nil
    hpxml.climate_and_risk_zones.iecc_zone = nil
    hpxml.climate_and_risk_zones.weather_station_wmo = nil
    hpxml.climate_and_risk_zones.weather_station_name = 'Boulder, CO'
    hpxml.climate_and_risk_zones.weather_station_epw_filepath = 'US_CO_Boulder_AMY_2012.epw'
  elsif ['invalid_files/invalid-wmo.xml'].include? hpxml_file
    hpxml.climate_and_risk_zones.weather_station_wmo = '999999'
  elsif ['invalid_files/invalid-epw-filepath.xml'].include? hpxml_file
    hpxml.climate_and_risk_zones.weather_station_epw_filepath = 'foo.epw'
  end
end

def set_hpxml_air_infiltration_measurements(hpxml_file, hpxml)
  infil_volume = hpxml.building_construction.conditioned_building_volume
  if ['ASHRAE_Standard_140/L100AC.xml',
      'ASHRAE_Standard_140/L100AL.xml',
      'base-enclosure-infil-natural-ach.xml'].include? hpxml_file
    hpxml.air_infiltration_measurements.clear
    hpxml.air_infiltration_measurements.add(id: 'InfiltrationMeasurement',
                                            unit_of_measure: HPXML::UnitsACHNatural,
                                            air_leakage: 0.67)
  elsif ['ASHRAE_Standard_140/L322XC.xml'].include? hpxml_file
    hpxml.air_infiltration_measurements[0].air_leakage = 0.335
  elsif ['ASHRAE_Standard_140/L110AC.xml',
         'ASHRAE_Standard_140/L110AL.xml',
         'ASHRAE_Standard_140/L200AC.xml',
         'ASHRAE_Standard_140/L200AL.xml'].include? hpxml_file
    hpxml.air_infiltration_measurements[0].air_leakage = 1.5
  elsif ['base.xml'].include? hpxml_file
    hpxml.air_infiltration_measurements.add(id: 'InfiltrationMeasurement',
                                            house_pressure: 50,
                                            unit_of_measure: HPXML::UnitsACH,
                                            air_leakage: 3.0)
  elsif ['base-enclosure-infil-cfm50.xml'].include? hpxml_file
    hpxml.air_infiltration_measurements.clear
    hpxml.air_infiltration_measurements.add(id: 'InfiltrationMeasurement',
                                            house_pressure: 50,
                                            unit_of_measure: HPXML::UnitsCFM,
                                            air_leakage: 3.0 / 60.0 * infil_volume)
  end
  if ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.air_infiltration_measurements[0].infiltration_volume = nil
  else
    hpxml.air_infiltration_measurements[0].infiltration_volume = infil_volume
  end
end

def set_hpxml_attics(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L100AC.xml',
      'ASHRAE_Standard_140/L100AL.xml'].include? hpxml_file
    hpxml.attics.add(id: 'VentedAttic',
                     attic_type: HPXML::AtticTypeVented,
                     vented_attic_ach: 2.4)
  elsif ['base.xml'].include? hpxml_file
    hpxml.attics.add(id: 'UnventedAttic',
                     attic_type: HPXML::AtticTypeUnvented,
                     within_infiltration_volume: false)
  elsif ['base-atticroof-cathedral.xml'].include? hpxml_file
    hpxml.attics.clear
    hpxml.attics.add(id: 'CathedralCeiling',
                     attic_type: HPXML::AtticTypeCathedral)
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.attics.add(id: 'ConditionedAttic',
                     attic_type: HPXML::AtticTypeConditioned)
  elsif ['base-atticroof-flat.xml'].include? hpxml_file
    hpxml.attics.clear
    hpxml.attics.add(id: 'FlatRoof',
                     attic_type: HPXML::AtticTypeFlatRoof)
  elsif ['base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.attics.clear
  elsif ['base-atticroof-vented.xml'].include? hpxml_file
    hpxml.attics.clear
    hpxml.attics.add(id: 'VentedAttic',
                     attic_type: HPXML::AtticTypeVented,
                     vented_attic_sla: 0.003)
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.attics.clear
  end
end

def set_hpxml_foundations(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.foundations.add(id: 'ConditionedBasement',
                          foundation_type: HPXML::FoundationTypeBasementConditioned)
  elsif ['base-foundation-vented-crawlspace.xml'].include? hpxml_file
    hpxml.foundations.clear
    hpxml.foundations.add(id: 'VentedCrawlspace',
                          foundation_type: HPXML::FoundationTypeCrawlspaceVented,
                          vented_crawlspace_sla: 0.00667)
  elsif ['base-foundation-unvented-crawlspace.xml'].include? hpxml_file
    hpxml.foundations.clear
    hpxml.foundations.add(id: 'UnventedCrawlspace',
                          foundation_type: HPXML::FoundationTypeCrawlspaceUnvented,
                          within_infiltration_volume: false)
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    hpxml.foundations.clear
    hpxml.foundations.add(id: 'UnconditionedBasement',
                          foundation_type: HPXML::FoundationTypeBasementUnconditioned,
                          unconditioned_basement_thermal_boundary: HPXML::FoundationThermalBoundaryFloor,
                          within_infiltration_volume: false)
  elsif ['base-foundation-unconditioned-basement-wall-insulation.xml'].include? hpxml_file
    hpxml.foundations[0].unconditioned_basement_thermal_boundary = HPXML::FoundationThermalBoundaryWall
  elsif ['base-foundation-multiple.xml'].include? hpxml_file
    hpxml.foundations.add(id: 'UnventedCrawlspace',
                          foundation_type: HPXML::FoundationTypeCrawlspaceUnvented,
                          within_infiltration_volume: false)
  elsif ['base-foundation-ambient.xml'].include? hpxml_file
    hpxml.foundations.clear
    hpxml.foundations.add(id: 'AmbientFoundation',
                          foundation_type: HPXML::FoundationTypeAmbient)
  elsif ['base-foundation-slab.xml'].include? hpxml_file
    hpxml.foundations.clear
    hpxml.foundations.add(id: 'SlabFoundation',
                          foundation_type: HPXML::FoundationTypeSlab)
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.foundations.clear
  end
end

def set_hpxml_roofs(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L100AC.xml',
      'ASHRAE_Standard_140/L100AL.xml'].include? hpxml_file
    hpxml.roofs.add(id: 'AtticRoofNorth',
                    interior_adjacent_to: HPXML::LocationAtticVented,
                    area: 811.1,
                    azimuth: 0,
                    solar_absorptance: 0.6,
                    emittance: 0.9,
                    pitch: 4,
                    radiant_barrier: false,
                    insulation_assembly_r_value: 1.99)
    hpxml.roofs.add(id: 'AtticRoofSouth',
                    interior_adjacent_to: HPXML::LocationAtticVented,
                    area: 811.1,
                    azimuth: 180,
                    solar_absorptance: 0.6,
                    emittance: 0.9,
                    pitch: 4,
                    radiant_barrier: false,
                    insulation_assembly_r_value: 1.99)
  elsif ['ASHRAE_Standard_140/L202AC.xml',
         'ASHRAE_Standard_140/L202AL.xml'].include? hpxml_file
    for i in 0..hpxml.roofs.size - 1
      hpxml.roofs[i].solar_absorptance = 0.2
    end
  elsif ['base.xml'].include? hpxml_file
    hpxml.roofs.add(id: 'Roof',
                    interior_adjacent_to: HPXML::LocationAtticUnvented,
                    area: 1510,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    pitch: 6,
                    radiant_barrier: false,
                    insulation_assembly_r_value: 2.3)
  elsif ['base-atticroof-flat.xml'].include? hpxml_file
    hpxml.roofs.clear
    hpxml.roofs.add(id: 'Roof',
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    area: 1350,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    pitch: 0,
                    radiant_barrier: false,
                    insulation_assembly_r_value: 25.8)
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.roofs.clear
    hpxml.roofs.add(id: 'RoofCond',
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    area: 1006,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    pitch: 6,
                    radiant_barrier: false,
                    insulation_assembly_r_value: 25.8)
    hpxml.roofs.add(id: 'RoofUncond',
                    interior_adjacent_to: HPXML::LocationAtticUnvented,
                    area: 504,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    pitch: 6,
                    radiant_barrier: false,
                    insulation_assembly_r_value: 2.3)
  elsif ['base-atticroof-vented.xml'].include? hpxml_file
    hpxml.roofs[0].interior_adjacent_to = HPXML::LocationAtticVented
  elsif ['base-atticroof-cathedral.xml'].include? hpxml_file
    hpxml.roofs[0].interior_adjacent_to = HPXML::LocationLivingSpace
    hpxml.roofs[0].insulation_assembly_r_value = 25.8
  elsif ['base-enclosure-3d-coordinates.xml'].include? hpxml_file
    hpxml.roofs.clear()
    hpxml.roofs.add(id: 'Surface_8',
                    interior_adjacent_to: HPXML::LocationAtticUnvented,
                    area: 755,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    pitch: 6,
                    radiant_barrier: false,
                    insulation_assembly_r_value: 2.3,
                    coordinates: [{ x: 45, y: 15, z: 15.5 }, { x: 0, y: 15, z: 15.5 }, { x: 0, y: 0, z: 8 }, { x: 45, y: 0, z: 8 }])
    hpxml.roofs.add(id: 'Surface_9',
                    interior_adjacent_to: HPXML::LocationAtticUnvented,
                    area: 755,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    pitch: 6,
                    radiant_barrier: false,
                    insulation_assembly_r_value: 2.3,
                    coordinates: [{ x: 0, y: 15, z: 15.5 }, { x: 45, y: 15, z: 15.5 }, { x: 45, y: 30, z: 8 }, { x: 0, y: 30, z: 8 }])
  elsif ['base-enclosure-garage.xml'].include? hpxml_file
    hpxml.roofs[0].area += 670
  elsif ['base-atticroof-unvented-insulated-roof.xml'].include? hpxml_file
    hpxml.roofs[0].insulation_assembly_r_value = 25.8
  elsif ['base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.roofs.clear
  elsif ['base-enclosure-split-surfaces.xml'].include? hpxml_file
    for n in 1..hpxml.roofs.size
      hpxml.roofs[n - 1].area /= 9.0
      for i in 2..9
        hpxml.roofs << hpxml.roofs[n - 1].dup
        hpxml.roofs[-1].id += i.to_s
      end
    end
    hpxml.roofs << hpxml.roofs[-1].dup
    hpxml.roofs[-1].id = 'TinyRoof'
    hpxml.roofs[-1].area = 0.05
  elsif ['base-atticroof-radiant-barrier.xml'].include? hpxml_file
    hpxml.roofs[0].radiant_barrier = true
  elsif ['invalid_files/enclosure-attic-missing-roof.xml'].include? hpxml_file
    hpxml.roofs[0].delete
  end
end

def set_hpxml_rim_joists(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L322XC.xml'].include? hpxml_file
    hpxml.rim_joists.add(id: 'RimJoistNorth',
                         exterior_adjacent_to: HPXML::LocationOutside,
                         interior_adjacent_to: HPXML::LocationBasementConditioned,
                         area: 42.75,
                         azimuth: 0,
                         solar_absorptance: 0.6,
                         emittance: 0.9,
                         insulation_assembly_r_value: 5.01)
    hpxml.rim_joists.add(id: 'RimJoistEast',
                         exterior_adjacent_to: HPXML::LocationOutside,
                         interior_adjacent_to: HPXML::LocationBasementConditioned,
                         area: 20.25,
                         azimuth: 90,
                         solar_absorptance: 0.6,
                         emittance: 0.9,
                         insulation_assembly_r_value: 5.01)
    hpxml.rim_joists.add(id: 'RimJoistSouth',
                         exterior_adjacent_to: HPXML::LocationOutside,
                         interior_adjacent_to: HPXML::LocationBasementConditioned,
                         area: 42.75,
                         azimuth: 180,
                         solar_absorptance: 0.6,
                         emittance: 0.9,
                         insulation_assembly_r_value: 5.01)
    hpxml.rim_joists.add(id: 'RimJoistWest',
                         exterior_adjacent_to: HPXML::LocationOutside,
                         interior_adjacent_to: HPXML::LocationBasementConditioned,
                         area: 20.25,
                         azimuth: 270,
                         solar_absorptance: 0.6,
                         emittance: 0.9,
                         insulation_assembly_r_value: 5.01)
  elsif ['ASHRAE_Standard_140/L324XC.xml'].include? hpxml_file
    for i in 0..hpxml.rim_joists.size - 1
      hpxml.rim_joists[i].insulation_assembly_r_value = 13.14
    end
  elsif ['base.xml'].include? hpxml_file
    # TODO: Other geometry values (e.g., building volume) assume
    # no rim joists.
    hpxml.rim_joists.add(id: 'RimJoistFoundation',
                         exterior_adjacent_to: HPXML::LocationOutside,
                         interior_adjacent_to: HPXML::LocationBasementConditioned,
                         area: 116,
                         solar_absorptance: 0.7,
                         emittance: 0.92,
                         insulation_assembly_r_value: 23.0)
  elsif ['base-foundation-ambient.xml',
         'base-foundation-slab.xml'].include? hpxml_file
    hpxml.rim_joists.clear
  elsif ['base-enclosure-attached-multifamily.xml'].include? hpxml_file
    hpxml.rim_joists[0].exterior_adjacent_to = HPXML::LocationOtherNonFreezingSpace
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    for i in 0..hpxml.rim_joists.size - 1
      hpxml.rim_joists[i].interior_adjacent_to = HPXML::LocationBasementUnconditioned
      hpxml.rim_joists[i].insulation_assembly_r_value = 2.3
    end
  elsif ['base-foundation-unconditioned-basement-wall-insulation.xml'].include? hpxml_file
    for i in 0..hpxml.rim_joists.size - 1
      hpxml.rim_joists[i].insulation_assembly_r_value = 23.0
    end
  elsif ['base-foundation-unvented-crawlspace.xml'].include? hpxml_file
    for i in 0..hpxml.rim_joists.size - 1
      hpxml.rim_joists[i].interior_adjacent_to = HPXML::LocationCrawlspaceUnvented
    end
  elsif ['base-foundation-vented-crawlspace.xml'].include? hpxml_file
    for i in 0..hpxml.rim_joists.size - 1
      hpxml.rim_joists[i].interior_adjacent_to = HPXML::LocationCrawlspaceVented
    end
  elsif ['base-foundation-multiple.xml'].include? hpxml_file
    hpxml.rim_joists[0].exterior_adjacent_to = HPXML::LocationCrawlspaceUnvented
    hpxml.rim_joists.add(id: 'RimJoistCrawlspace',
                         exterior_adjacent_to: HPXML::LocationOutside,
                         interior_adjacent_to: HPXML::LocationCrawlspaceUnvented,
                         area: 81,
                         solar_absorptance: 0.7,
                         emittance: 0.92,
                         insulation_assembly_r_value: 2.3)
  elsif ['base-enclosure-2stories.xml'].include? hpxml_file
    hpxml.rim_joists.add(id: 'RimJoist2ndStory',
                         exterior_adjacent_to: HPXML::LocationOutside,
                         interior_adjacent_to: HPXML::LocationLivingSpace,
                         area: 116,
                         solar_absorptance: 0.7,
                         emittance: 0.92,
                         insulation_assembly_r_value: 23.0)
  elsif ['base-enclosure-split-surfaces.xml'].include? hpxml_file
    for n in 1..hpxml.rim_joists.size
      hpxml.rim_joists[n - 1].area /= 9.0
      for i in 2..9
        hpxml.rim_joists << hpxml.rim_joists[n - 1].dup
        hpxml.rim_joists[-1].id += i.to_s
      end
    end
    hpxml.rim_joists << hpxml.rim_joists[-1].dup
    hpxml.rim_joists[-1].id = 'TinyRimJoist'
    hpxml.rim_joists[-1].area = 0.05
  end
end

def set_hpxml_walls(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L100AC.xml',
      'ASHRAE_Standard_140/L100AL.xml'].include? hpxml_file
    hpxml.walls.add(id: 'WallNorth',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 456,
                    azimuth: 0,
                    solar_absorptance: 0.6,
                    emittance: 0.9,
                    insulation_assembly_r_value: 11.76)
    hpxml.walls.add(id: 'WallEast',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 216,
                    azimuth: 90,
                    solar_absorptance: 0.6,
                    emittance: 0.9,
                    insulation_assembly_r_value: 11.76)
    hpxml.walls.add(id: 'WallSouth',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 456,
                    azimuth: 180,
                    solar_absorptance: 0.6,
                    emittance: 0.9,
                    insulation_assembly_r_value: 11.76)
    hpxml.walls.add(id: 'WallWest',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 216,
                    azimuth: 270,
                    solar_absorptance: 0.6,
                    emittance: 0.9,
                    insulation_assembly_r_value: 11.76)
    hpxml.walls.add(id: 'WallAtticGableEast',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationAtticVented,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 60.75,
                    azimuth: 90,
                    solar_absorptance: 0.6,
                    emittance: 0.9,
                    insulation_assembly_r_value: 2.15)
    hpxml.walls.add(id: 'WallAtticGableWest',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationAtticVented,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 60.75,
                    azimuth: 270,
                    solar_absorptance: 0.6,
                    emittance: 0.9,
                    insulation_assembly_r_value: 2.15)
  elsif ['ASHRAE_Standard_140/L120AC.xml',
         'ASHRAE_Standard_140/L120AL.xml'].include? hpxml_file
    for i in 0..hpxml.walls.size - 3
      hpxml.walls[i].insulation_assembly_r_value = 23.58
    end
  elsif ['ASHRAE_Standard_140/L200AC.xml',
         'ASHRAE_Standard_140/L200AL.xml'].include? hpxml_file
    for i in 0..hpxml.walls.size - 3
      hpxml.walls[i].insulation_assembly_r_value = 4.84
    end
  elsif ['ASHRAE_Standard_140/L202AC.xml',
         'ASHRAE_Standard_140/L202AL.xml'].include? hpxml_file
    for i in 0..hpxml.walls.size - 1
      hpxml.walls[i].solar_absorptance = 0.2
    end
  elsif ['base.xml'].include? hpxml_file
    hpxml.walls.add(id: 'Wall',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 1200,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23.0)
    hpxml.walls.add(id: 'WallAtticGable',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationAtticUnvented,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 290,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 4.0)
  elsif ['base-atticroof-flat.xml'].include? hpxml_file
    hpxml.walls.delete_at(1)
  elsif ['base-atticroof-vented.xml'].include? hpxml_file
    hpxml.walls[1].interior_adjacent_to = HPXML::LocationAtticVented
  elsif ['base-atticroof-cathedral.xml'].include? hpxml_file
    hpxml.walls[1].interior_adjacent_to = HPXML::LocationLivingSpace
    hpxml.walls[1].insulation_assembly_r_value = 23.0
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.walls.delete_at(1)
    hpxml.walls.add(id: 'WallAtticKneeWall',
                    exterior_adjacent_to: HPXML::LocationAtticUnvented,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 316,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23.0)
    hpxml.walls.add(id: 'WallAtticGableCond',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 240,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 22.3)
    hpxml.walls.add(id: 'WallAtticGableUncond',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationAtticUnvented,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 50,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 4.0)
  elsif ['base-enclosure-3d-coordinates.xml'].include? hpxml_file
    hpxml.walls.clear()
    hpxml.walls.add(id: 'Surface_4',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 240,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23.0,
                    coordinates: [{ x: 45, y: 0, z: 8 }, { x: 45, y: 0, z: 0 }, { x: 45, y: 30, z: 0 }, { x: 45, y: 30, z: 8 }])
    hpxml.walls.add(id: 'Surface_2',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 240,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23.0,
                    coordinates: [{ x: 0, y: 30, z: 8 }, { x: 0, y: 30, z: 0 }, { x: 0, y: 0, z: 0 }, { x: 0, y: 0, z: 8 }])
    hpxml.walls.add(id: 'Surface_3',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 360,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23.0,
                    coordinates: [{ x: 45, y: 30, z: 8 }, { x: 45, y: 30, z: 0 }, { x: 0, y: 30, z: 0 }, { x: 0, y: 30, z: 8 }])
    hpxml.walls.add(id: 'Surface_5',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 360,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23.0,
                    coordinates: [{ x: 0, y: 0, z: 8 }, { x: 0, y: 0, z: 0 }, { x: 45, y: 0, z: 0 }, { x: 45, y: 0, z: 8 }])
    hpxml.walls.add(id: 'Surface_10',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationAtticUnvented,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 113,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 4.0,
                    coordinates: [{ x: 0, y: 15, z: 15.5 }, { x: 0, y: 30, z: 8 }, { x: 0, y: 0, z: 8 }])
    hpxml.walls.add(id: 'Surface_11',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationAtticUnvented,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 113,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 4.0,
                    coordinates: [{ x: 45, y: 15, z: 15.5 }, { x: 45, y: 0, z: 8 }, { x: 45, y: 30, z: 8 }])
  elsif ['base-enclosure-attached-multifamily.xml'].include? hpxml_file
    hpxml.walls.add(id: 'WallOtherHeatedSpace',
                    exterior_adjacent_to: HPXML::LocationOtherHeatedSpace,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: 'WoodStud',
                    area: 100,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23.0)
    hpxml.walls.add(id: 'WallOtherMultifamilyBufferSpace',
                    exterior_adjacent_to: HPXML::LocationOtherMultifamilyBufferSpace,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: 'WoodStud',
                    area: 100,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23.0)
    hpxml.walls.add(id: 'WallOtherNonFreezingSpace',
                    exterior_adjacent_to: HPXML::LocationOtherNonFreezingSpace,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: 'WoodStud',
                    area: 100,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23.0)
    hpxml.walls.add(id: 'WallOtherHousingUnit',
                    exterior_adjacent_to: HPXML::LocationOtherHousingUnit,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: 'WoodStud',
                    area: 100,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 4.0)
    hpxml.walls.add(id: 'WallAtticLivingWall',
                    exterior_adjacent_to: HPXML::LocationAtticUnvented,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 50,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 4.0)
  elsif ['base-enclosure-walltypes.xml'].include? hpxml_file
    walls_map = { HPXML::WallTypeCMU => 12,
                  HPXML::WallTypeDoubleWoodStud => 28.7,
                  HPXML::WallTypeICF => 21,
                  HPXML::WallTypeLog => 7.1,
                  HPXML::WallTypeSIP => 16.1,
                  HPXML::WallTypeConcrete => 1.35,
                  HPXML::WallTypeSteelStud => 8.1,
                  HPXML::WallTypeStone => 5.4,
                  HPXML::WallTypeStrawBale => 58.8,
                  HPXML::WallTypeBrick => 7.9 }
    last_wall = hpxml.walls[-1]
    hpxml.walls.clear
    walls_map.each_with_index do |(wall_type, assembly_r), i|
      hpxml.walls.add(id: "Wall#{i + 1}",
                      exterior_adjacent_to: HPXML::LocationOutside,
                      interior_adjacent_to: HPXML::LocationLivingSpace,
                      wall_type: wall_type,
                      area: 1200 / walls_map.size,
                      solar_absorptance: 0.7,
                      emittance: 0.92,
                      insulation_assembly_r_value: assembly_r)
    end
    hpxml.walls << last_wall
  elsif ['base-enclosure-2stories.xml'].include? hpxml_file
    hpxml.walls[0].area *= 2.0
  elsif ['base-enclosure-2stories-garage.xml'].include? hpxml_file
    hpxml.walls.clear
    hpxml.walls.add(id: 'Wall',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 2080,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23)
    hpxml.walls.add(id: 'WallGarageInterior',
                    exterior_adjacent_to: HPXML::LocationGarage,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 320,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23)
    hpxml.walls.add(id: 'WallGarageExterior',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationGarage,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 320,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 4)
    hpxml.walls.add(id: 'WallAtticGable',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationAtticUnvented,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 113,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 4)
  elsif ['base-enclosure-garage.xml'].include? hpxml_file
    hpxml.walls.clear
    hpxml.walls.add(id: 'Wall',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 960,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23)
    hpxml.walls.add(id: 'WallGarageInterior',
                    exterior_adjacent_to: HPXML::LocationGarage,
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 240,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 23)
    hpxml.walls.add(id: 'WallGarageExterior',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationGarage,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 560,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 4)
    hpxml.walls.add(id: 'WallAtticGable',
                    exterior_adjacent_to: HPXML::LocationOutside,
                    interior_adjacent_to: HPXML::LocationAtticUnvented,
                    wall_type: HPXML::WallTypeWoodStud,
                    area: 113,
                    solar_absorptance: 0.7,
                    emittance: 0.92,
                    insulation_assembly_r_value: 4)
  elsif ['base-atticroof-unvented-insulated-roof.xml'].include? hpxml_file
    hpxml.walls[1].insulation_assembly_r_value = 23
  elsif ['base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.walls.delete_at(1)
    hpxml.walls << hpxml.walls[0].dup
    hpxml.walls[0].area *= 0.35
    hpxml.walls[-1].area *= 0.65
    if ['base-enclosure-other-housing-unit.xml'].include? hpxml_file
      hpxml.walls[-1].id = 'WallOtherHousingUnit'
      hpxml.walls[-1].exterior_adjacent_to = HPXML::LocationOtherHousingUnit
      hpxml.walls[-1].insulation_assembly_r_value = 4
    elsif ['base-enclosure-other-heated-space.xml'].include? hpxml_file
      hpxml.walls[-1].id = 'WallOtherHeatedSpace'
      hpxml.walls[-1].exterior_adjacent_to = HPXML::LocationOtherHeatedSpace
      hpxml.walls[-1].insulation_assembly_r_value = 4
    elsif ['base-enclosure-other-non-freezing-space.xml'].include? hpxml_file
      hpxml.walls[-1].id = 'WallOtherNonFreezingSpace'
      hpxml.walls[-1].exterior_adjacent_to = HPXML::LocationOtherNonFreezingSpace
      hpxml.walls[-1].insulation_assembly_r_value = 23
    elsif ['base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
      hpxml.walls[-1].id = 'WallOtherMultifamilyBufferSpace'
      hpxml.walls[-1].exterior_adjacent_to = HPXML::LocationOtherMultifamilyBufferSpace
      hpxml.walls[-1].insulation_assembly_r_value = 23
    end
  elsif ['base-enclosure-split-surfaces.xml'].include? hpxml_file
    for n in 1..hpxml.walls.size
      hpxml.walls[n - 1].area /= 9.0
      for i in 2..9
        hpxml.walls << hpxml.walls[n - 1].dup
        hpxml.walls[-1].id += i.to_s
      end
    end
    hpxml.walls << hpxml.walls[-1].dup
    hpxml.walls[-1].id = 'TinyWall'
    hpxml.walls[-1].area = 0.05
  elsif ['invalid_files/duplicate-id.xml'].include? hpxml_file
    hpxml.walls[-1].id = hpxml.walls[0].id
  elsif ['invalid_files/enclosure-living-missing-exterior-wall.xml'].include? hpxml_file
    hpxml.walls[0].delete
  elsif ['invalid_files/enclosure-garage-missing-exterior-wall.xml'].include? hpxml_file
    hpxml.walls[-2].delete
  end
end

def set_hpxml_foundation_walls(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L322XC.xml'].include? hpxml_file
    hpxml.foundation_walls.add(id: 'FoundationWallNorth',
                               exterior_adjacent_to: 'ground',
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 7.25,
                               area: 413.25,
                               azimuth: 0,
                               thickness: 6,
                               depth_below_grade: 6.583,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_r_value: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 0)
    hpxml.foundation_walls.add(id: 'FoundationWallEast',
                               exterior_adjacent_to: 'ground',
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 7.25,
                               area: 195.75,
                               azimuth: 90,
                               thickness: 6,
                               depth_below_grade: 6.583,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_r_value: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 0)
    hpxml.foundation_walls.add(id: 'FoundationWallSouth',
                               exterior_adjacent_to: 'ground',
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 7.25,
                               area: 413.25,
                               azimuth: 180,
                               thickness: 6,
                               depth_below_grade: 6.583,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_r_value: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 0)
    hpxml.foundation_walls.add(id: 'FoundationWallWest',
                               exterior_adjacent_to: 'ground',
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 7.25,
                               area: 195.75,
                               azimuth: 270,
                               thickness: 6,
                               depth_below_grade: 6.583,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_r_value: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 0)
  elsif ['ASHRAE_Standard_140/L324XC.xml'].include? hpxml_file
    for i in 0..hpxml.foundation_walls.size - 1
      hpxml.foundation_walls[i].insulation_interior_r_value = 10.2
      hpxml.foundation_walls[i].insulation_interior_distance_to_top = 0.0
      hpxml.foundation_walls[i].insulation_interior_distance_to_bottom = 7.25
    end
  elsif ['base.xml'].include? hpxml_file
    hpxml. foundation_walls.add(id: 'FoundationWall',
                                exterior_adjacent_to: HPXML::LocationGround,
                                interior_adjacent_to: HPXML::LocationBasementConditioned,
                                height: 8,
                                area: 1200,
                                thickness: 8,
                                depth_below_grade: 7,
                                insulation_interior_r_value: 0,
                                insulation_interior_distance_to_top: 0,
                                insulation_interior_distance_to_bottom: 0,
                                insulation_exterior_distance_to_top: 0,
                                insulation_exterior_distance_to_bottom: 8,
                                insulation_exterior_r_value: 8.9)
  elsif ['base-enclosure-3d-coordinates.xml'].include? hpxml_file
    hpxml.foundation_walls.clear()
    hpxml.foundation_walls.add(id: 'Surface_13',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 8,
                               area: 240,
                               thickness: 8,
                               depth_below_grade: 7,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 8,
                               insulation_exterior_r_value: 8.9,
                               coordinates: [{ x: 0, y: 30, z: 0 }, { x: 0, y: 30, z: -8 }, { x: 0, y: 0, z: -8 }, { x: 0, y: 0, z: 0 }])
    hpxml.foundation_walls.add(id: 'Surface_14',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 8,
                               area: 360,
                               thickness: 8,
                               depth_below_grade: 7,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 8,
                               insulation_exterior_r_value: 8.9,
                               coordinates: [{ x: 45, y: 30, z: 0 }, { x: 45, y: 30, z: -8 }, { x: 0, y: 30, z: -8 }, { x: 0, y: 30, z: 0 }])
    hpxml.foundation_walls.add(id: 'Surface_15',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 8,
                               area: 240,
                               thickness: 8,
                               depth_below_grade: 7,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 8,
                               insulation_exterior_r_value: 8.9,
                               coordinates: [{ x: 45, y: 0, z: 0 }, { x: 45, y: 0, z: -8 }, { x: 45, y: 30, z: -8 }, { x: 45, y: 30, z: 0 }])
    hpxml.foundation_walls.add(id: 'Surface_16',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 8,
                               area: 360,
                               thickness: 8,
                               depth_below_grade: 7,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 8,
                               insulation_exterior_r_value: 8.9,
                               coordinates: [{ x: 0, y: 0, z: 0 }, { x: 0, y: 0, z: -8 }, { x: 45, y: 0, z: -8 }, { x: 45, y: 0, z: 0 }])
  elsif ['base-enclosure-attached-multifamily.xml'].include? hpxml_file
    hpxml.foundation_walls.add(id: 'FoundationWallOtherNonFreezingSpace',
                               exterior_adjacent_to: HPXML::LocationOtherNonFreezingSpace,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 8,
                               area: 480,
                               thickness: 8,
                               depth_below_grade: 7,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 8,
                               insulation_exterior_r_value: 8.9)
    hpxml.foundation_walls.add(id: 'FoundationWallOtherMultifamilyBufferSpace',
                               exterior_adjacent_to: HPXML::LocationOtherMultifamilyBufferSpace,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 4,
                               area: 120,
                               thickness: 8,
                               depth_below_grade: 3,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 4,
                               insulation_exterior_r_value: 8.9)
    hpxml.foundation_walls.add(id: 'FoundationWallOtherHeatedSpace',
                               exterior_adjacent_to: HPXML::LocationOtherHeatedSpace,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 2,
                               area: 60,
                               thickness: 8,
                               depth_below_grade: 1,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 2,
                               insulation_exterior_r_value: 8.9)
  elsif ['base-foundation-conditioned-basement-wall-interior-insulation.xml'].include? hpxml_file
    hpxml.foundation_walls[0].insulation_interior_distance_to_top = 0
    hpxml.foundation_walls[0].insulation_interior_distance_to_bottom = 8
    hpxml.foundation_walls[0].insulation_interior_r_value = 10
    hpxml.foundation_walls[0].insulation_exterior_distance_to_top = 1
    hpxml.foundation_walls[0].insulation_exterior_distance_to_bottom = 8
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    hpxml.foundation_walls[0].interior_adjacent_to = HPXML::LocationBasementUnconditioned
    hpxml.foundation_walls[0].insulation_exterior_distance_to_bottom = 0
    hpxml.foundation_walls[0].insulation_exterior_r_value = 0
  elsif ['base-foundation-unconditioned-basement-wall-insulation.xml'].include? hpxml_file
    hpxml.foundation_walls[0].insulation_exterior_distance_to_bottom = 4
    hpxml.foundation_walls[0].insulation_exterior_r_value = 8.9
  elsif ['base-foundation-unconditioned-basement-assembly-r.xml'].include? hpxml_file
    hpxml.foundation_walls[0].insulation_exterior_distance_to_top = nil
    hpxml.foundation_walls[0].insulation_exterior_distance_to_bottom = nil
    hpxml.foundation_walls[0].insulation_exterior_r_value = nil
    hpxml.foundation_walls[0].insulation_interior_distance_to_top = nil
    hpxml.foundation_walls[0].insulation_interior_distance_to_bottom = nil
    hpxml.foundation_walls[0].insulation_interior_r_value = nil
    hpxml.foundation_walls[0].insulation_assembly_r_value = 10.69
  elsif ['base-foundation-unconditioned-basement-above-grade.xml'].include? hpxml_file
    hpxml.foundation_walls[0].depth_below_grade = 4
  elsif ['base-foundation-unvented-crawlspace.xml',
         'base-foundation-vented-crawlspace.xml'].include? hpxml_file
    if ['base-foundation-unvented-crawlspace.xml'].include? hpxml_file
      hpxml.foundation_walls[0].interior_adjacent_to = HPXML::LocationCrawlspaceUnvented
    else
      hpxml.foundation_walls[0].interior_adjacent_to = HPXML::LocationCrawlspaceVented
    end
    hpxml.foundation_walls[0].height -= 4
    hpxml.foundation_walls[0].area /= 2.0
    hpxml.foundation_walls[0].depth_below_grade -= 4
    hpxml.foundation_walls[0].insulation_exterior_distance_to_bottom -= 4
  elsif ['base-foundation-multiple.xml'].include? hpxml_file
    hpxml.foundation_walls[0].area = 600
    hpxml.foundation_walls.add(id: 'FoundationWallInterior',
                               exterior_adjacent_to: HPXML::LocationCrawlspaceUnvented,
                               interior_adjacent_to: HPXML::LocationBasementUnconditioned,
                               height: 8,
                               area: 360,
                               thickness: 8,
                               depth_below_grade: 4,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 0,
                               insulation_exterior_r_value: 0)
    hpxml.foundation_walls.add(id: 'FoundationWallCrawlspace',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationCrawlspaceUnvented,
                               height: 4,
                               area: 600,
                               thickness: 8,
                               depth_below_grade: 3,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 0,
                               insulation_exterior_r_value: 0)
  elsif ['base-foundation-ambient.xml',
         'base-foundation-slab.xml'].include? hpxml_file
    hpxml.foundation_walls.clear
  elsif ['base-foundation-walkout-basement.xml'].include? hpxml_file
    hpxml.foundation_walls.clear
    hpxml.foundation_walls.add(id: 'FoundationWall1',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 8,
                               area: 480,
                               thickness: 8,
                               depth_below_grade: 7,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 8,
                               insulation_exterior_r_value: 8.9)
    hpxml.foundation_walls.add(id: 'FoundationWall2',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 4,
                               area: 120,
                               thickness: 8,
                               depth_below_grade: 3,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 4,
                               insulation_exterior_r_value: 8.9)
    hpxml.foundation_walls.add(id: 'FoundationWall3',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 2,
                               area: 60,
                               thickness: 8,
                               depth_below_grade: 1,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 2,
                               insulation_exterior_r_value: 8.9)
  elsif ['base-foundation-complex.xml'].include? hpxml_file
    hpxml.foundation_walls.clear
    hpxml.foundation_walls.add(id: 'FoundationWall1',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 8,
                               area: 160,
                               thickness: 8,
                               depth_below_grade: 7,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 0,
                               insulation_exterior_r_value: 0.0)
    hpxml.foundation_walls.add(id: 'FoundationWall2',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 8,
                               area: 240,
                               thickness: 8,
                               depth_below_grade: 7,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 8,
                               insulation_exterior_r_value: 8.9)
    hpxml.foundation_walls.add(id: 'FoundationWall3',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 4,
                               area: 160,
                               thickness: 8,
                               depth_below_grade: 3,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 0,
                               insulation_exterior_r_value: 0.0)
    hpxml.foundation_walls.add(id: 'FoundationWall4',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 4,
                               area: 120,
                               thickness: 8,
                               depth_below_grade: 3,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 4,
                               insulation_exterior_r_value: 8.9)
    hpxml.foundation_walls.add(id: 'FoundationWall5',
                               exterior_adjacent_to: HPXML::LocationGround,
                               interior_adjacent_to: HPXML::LocationBasementConditioned,
                               height: 4,
                               area: 80,
                               thickness: 8,
                               depth_below_grade: 3,
                               insulation_interior_r_value: 0,
                               insulation_interior_distance_to_top: 0,
                               insulation_interior_distance_to_bottom: 0,
                               insulation_exterior_distance_to_top: 0,
                               insulation_exterior_distance_to_bottom: 4,
                               insulation_exterior_r_value: 8.9)
  elsif ['base-enclosure-split-surfaces.xml'].include? hpxml_file
    for n in 1..hpxml.foundation_walls.size
      hpxml.foundation_walls[n - 1].area /= 9.0
      for i in 2..9
        hpxml.foundation_walls << hpxml.foundation_walls[n - 1].dup
        hpxml.foundation_walls[-1].id += i.to_s
      end
    end
    hpxml.foundation_walls << hpxml.foundation_walls[-1].dup
    hpxml.foundation_walls[-1].id = 'TinyFoundationWall'
    hpxml.foundation_walls[-1].area = 0.05
  elsif ['base-enclosure-2stories-garage.xml'].include? hpxml_file
    hpxml.foundation_walls[-1].area = 880
  elsif ['invalid_files/enclosure-basement-missing-exterior-foundation-wall.xml'].include? hpxml_file
    hpxml.foundation_walls[0].delete
  end
end

def set_hpxml_frame_floors(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L100AC.xml',
      'ASHRAE_Standard_140/L100AL.xml'].include? hpxml_file
    hpxml.frame_floors.add(id: 'FloorUnderAttic',
                           exterior_adjacent_to: HPXML::LocationAtticVented,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 1539,
                           insulation_assembly_r_value: 18.45)
    hpxml.frame_floors.add(id: 'FloorOverFoundation',
                           exterior_adjacent_to: HPXML::LocationOutside,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 1539,
                           insulation_assembly_r_value: 14.15)
  elsif ['ASHRAE_Standard_140/L120AC.xml',
         'ASHRAE_Standard_140/L120AL.xml'].include? hpxml_file
    hpxml.frame_floors[0].insulation_assembly_r_value = 57.49
  elsif ['ASHRAE_Standard_140/L200AC.xml',
         'ASHRAE_Standard_140/L200AL.xml'].include? hpxml_file
    hpxml.frame_floors[0].insulation_assembly_r_value = 11.75
    hpxml.frame_floors[1].insulation_assembly_r_value = 4.24
  elsif ['ASHRAE_Standard_140/L302XC.xml',
         'ASHRAE_Standard_140/L322XC.xml',
         'ASHRAE_Standard_140/L324XC.xml'].include? hpxml_file
    hpxml.frame_floors.delete_at(1)
  elsif ['base.xml'].include? hpxml_file
    hpxml.frame_floors.add(id: 'FloorBelowAttic',
                           exterior_adjacent_to: HPXML::LocationAtticUnvented,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 1350,
                           insulation_assembly_r_value: 39.3)
  elsif ['base-atticroof-flat.xml',
         'base-atticroof-cathedral.xml'].include? hpxml_file
    hpxml.frame_floors.delete_at(0)
  elsif ['base-atticroof-vented.xml'].include? hpxml_file
    hpxml.frame_floors[0].exterior_adjacent_to = HPXML::LocationAtticVented
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.frame_floors[0].area = 450
  elsif ['base-enclosure-3d-coordinates.xml'].include? hpxml_file
    hpxml.frame_floors.clear()
    hpxml.frame_floors.add(id: 'Surface_6',
                           exterior_adjacent_to: HPXML::LocationAtticUnvented,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 1350,
                           insulation_assembly_r_value: 39.3,
                           coordinates: [{ x: 45, y: 0, z: 8 }, { x: 45, y: 30, z: 8 }, { x: 0, y: 30, z: 8 }, { x: 0, y: 0, z: 8 }])
    hpxml.frame_floors.add(id: 'Surface_1',
                           exterior_adjacent_to: HPXML::LocationBasementConditioned,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 1350,
                           insulation_assembly_r_value: 2.1,
                           coordinates: [{ x: 0, y: 0, z: 0 }, { x: 0, y: 30, z: 0 }, { x: 45, y: 30, z: 0 }, { x: 45, y: 0, z: 0 }])
  elsif ['base-enclosure-garage.xml'].include? hpxml_file
    hpxml.frame_floors.add(id: 'FloorBetweenAtticGarage',
                           exterior_adjacent_to: HPXML::LocationAtticUnvented,
                           interior_adjacent_to: HPXML::LocationGarage,
                           area: 600,
                           insulation_assembly_r_value: 2.1)
  elsif ['base-foundation-ambient.xml'].include? hpxml_file
    hpxml.frame_floors.add(id: 'FloorAboveAmbient',
                           exterior_adjacent_to: HPXML::LocationOutside,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 1350,
                           insulation_assembly_r_value: 18.7)
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    hpxml.frame_floors.add(id: 'FloorAboveUncondBasement',
                           exterior_adjacent_to: HPXML::LocationBasementUnconditioned,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 1350,
                           insulation_assembly_r_value: 18.7)
  elsif ['base-foundation-unconditioned-basement-wall-insulation.xml'].include? hpxml_file
    hpxml.frame_floors[1].insulation_assembly_r_value = 2.1
  elsif ['base-foundation-unvented-crawlspace.xml'].include? hpxml_file
    hpxml.frame_floors.add(id: 'FloorAboveUnventedCrawl',
                           exterior_adjacent_to: HPXML::LocationCrawlspaceUnvented,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 1350,
                           insulation_assembly_r_value: 18.7)
  elsif ['base-foundation-vented-crawlspace.xml'].include? hpxml_file
    hpxml.frame_floors.add(id: 'FloorAboveVentedCrawl',
                           exterior_adjacent_to: HPXML::LocationCrawlspaceVented,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 1350,
                           insulation_assembly_r_value: 18.7)
  elsif ['base-foundation-multiple.xml'].include? hpxml_file
    hpxml.frame_floors[1].area = 675
    hpxml.frame_floors.add(id: 'FloorAboveUnventedCrawlspace',
                           exterior_adjacent_to: HPXML::LocationCrawlspaceUnvented,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 675,
                           insulation_assembly_r_value: 18.7)
  elsif ['base-enclosure-2stories-garage.xml'].include? hpxml_file
    hpxml.frame_floors.add(id: 'FloorAboveGarage',
                           exterior_adjacent_to: HPXML::LocationGarage,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 400,
                           insulation_assembly_r_value: 39.3)
  elsif ['base-atticroof-unvented-insulated-roof.xml'].include? hpxml_file
    hpxml.frame_floors[0].insulation_assembly_r_value = 2.1
  elsif ['base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.frame_floors.clear
    hpxml.frame_floors.add(interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 1350,
                           other_space_above_or_below: HPXML::FrameFloorOtherSpaceAbove)
    if ['base-enclosure-other-housing-unit.xml'].include? hpxml_file
      hpxml.frame_floors[0].exterior_adjacent_to = HPXML::LocationOtherHousingUnit
      hpxml.frame_floors[0].id = 'FloorBelowOtherHousingUnit'
      hpxml.frame_floors[0].insulation_assembly_r_value = 2.1
    elsif ['base-enclosure-other-heated-space.xml'].include? hpxml_file
      hpxml.frame_floors[0].exterior_adjacent_to = HPXML::LocationOtherHeatedSpace
      hpxml.frame_floors[0].id = 'FloorBelowOtherHeatedSpace'
      hpxml.frame_floors[0].insulation_assembly_r_value = 2.1
    elsif ['base-enclosure-other-non-freezing-space.xml'].include? hpxml_file
      hpxml.frame_floors[0].exterior_adjacent_to = HPXML::LocationOtherNonFreezingSpace
      hpxml.frame_floors[0].id = 'FloorBelowOtherNonFreezingSpace'
      hpxml.frame_floors[0].insulation_assembly_r_value = 18.7
    elsif ['base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
      hpxml.frame_floors[0].exterior_adjacent_to = HPXML::LocationOtherMultifamilyBufferSpace
      hpxml.frame_floors[0].id = 'FloorBelowOtherMultifamilyBufferSpace'
      hpxml.frame_floors[0].insulation_assembly_r_value = 18.7
    end
    hpxml.frame_floors << hpxml.frame_floors[0].dup
    hpxml.frame_floors[1].id = hpxml.frame_floors[0].id.gsub('Below', 'Above')
    hpxml.frame_floors[1].other_space_above_or_below = HPXML::FrameFloorOtherSpaceBelow
  elsif ['base-enclosure-attached-multifamily.xml'].include? hpxml_file
    hpxml.frame_floors.add(id: 'FloorAboveNonFreezingSpace',
                           exterior_adjacent_to: HPXML::LocationOtherNonFreezingSpace,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 1000,
                           insulation_assembly_r_value: 18.7,
                           other_space_above_or_below: HPXML::FrameFloorOtherSpaceBelow)
    hpxml.frame_floors.add(id: 'FloorAboveMultifamilyBuffer',
                           exterior_adjacent_to: HPXML::LocationOtherMultifamilyBufferSpace,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 200,
                           insulation_assembly_r_value: 18.7,
                           other_space_above_or_below: HPXML::FrameFloorOtherSpaceBelow)
    hpxml.frame_floors.add(id: 'FloorAboveOtherHeatedSpace',
                           exterior_adjacent_to: HPXML::LocationOtherHeatedSpace,
                           interior_adjacent_to: HPXML::LocationLivingSpace,
                           area: 150,
                           insulation_assembly_r_value: 2.1,
                           other_space_above_or_below: HPXML::FrameFloorOtherSpaceBelow)
  elsif ['base-enclosure-split-surfaces.xml'].include? hpxml_file
    for n in 1..hpxml.frame_floors.size
      hpxml.frame_floors[n - 1].area /= 9.0
      for i in 2..9
        hpxml.frame_floors << hpxml.frame_floors[n - 1].dup
        hpxml.frame_floors[-1].id += i.to_s
      end
    end
    hpxml.frame_floors << hpxml.frame_floors[-1].dup
    hpxml.frame_floors[-1].id = 'TinyFloor'
    hpxml.frame_floors[-1].area = 0.05
  elsif ['invalid_files/enclosure-living-missing-ceiling-roof.xml'].include? hpxml_file
    hpxml.frame_floors[0].delete
  elsif ['invalid_files/enclosure-basement-missing-ceiling.xml',
         'invalid_files/enclosure-garage-missing-roof-ceiling.xml'].include? hpxml_file
    hpxml.frame_floors[1].delete
  end
end

def set_hpxml_slabs(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L302XC.xml'].include? hpxml_file
    hpxml.slabs.add(id: 'Slab',
                    interior_adjacent_to: HPXML::LocationLivingSpace,
                    area: 1539,
                    thickness: 4,
                    exposed_perimeter: 168,
                    perimeter_insulation_depth: 0,
                    under_slab_insulation_width: 0,
                    under_slab_insulation_spans_entire_slab: nil,
                    depth_below_grade: 0,
                    perimeter_insulation_r_value: 0,
                    under_slab_insulation_r_value: 0,
                    carpet_fraction: 1,
                    carpet_r_value: 2.08)
  elsif ['ASHRAE_Standard_140/L304XC.xml'].include? hpxml_file
    hpxml.slabs[0].perimeter_insulation_depth = 2.5
    hpxml.slabs[0].perimeter_insulation_r_value = 5.4
  elsif ['ASHRAE_Standard_140/L322XC.xml'].include? hpxml_file
    hpxml.slabs.add(id: 'Slab',
                    interior_adjacent_to: HPXML::LocationBasementConditioned,
                    area: 1539,
                    thickness: 4,
                    exposed_perimeter: 168,
                    perimeter_insulation_depth: 0,
                    under_slab_insulation_width: 0,
                    under_slab_insulation_spans_entire_slab: nil,
                    perimeter_insulation_r_value: 0,
                    under_slab_insulation_r_value: 0,
                    carpet_fraction: 0,
                    carpet_r_value: 0)
  elsif ['base.xml'].include? hpxml_file
    hpxml.slabs.add(id: 'Slab',
                    interior_adjacent_to: HPXML::LocationBasementConditioned,
                    area: 1350,
                    thickness: 4,
                    exposed_perimeter: 150,
                    perimeter_insulation_depth: 0,
                    under_slab_insulation_width: 0,
                    perimeter_insulation_r_value: 0,
                    under_slab_insulation_r_value: 0,
                    carpet_fraction: 0,
                    carpet_r_value: 0)
  elsif ['base-enclosure-3d-coordinates.xml'].include? hpxml_file
    hpxml.slabs.clear()
    hpxml.slabs.add(id: 'Surface_12',
                    interior_adjacent_to: HPXML::LocationBasementConditioned,
                    area: 1350,
                    thickness: 4,
                    exposed_perimeter: 150,
                    perimeter_insulation_depth: 0,
                    under_slab_insulation_width: 0,
                    perimeter_insulation_r_value: 0,
                    under_slab_insulation_r_value: 0,
                    carpet_fraction: 0,
                    carpet_r_value: 0,
                    coordinates: [{ x: 0, y: 0, z: -8 }, { x: 0, y: 30, z: -8 }, { x: 45, y: 30, z: -8 }, { x: 45, y: 0, z: -8 }])
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    hpxml.slabs[0].interior_adjacent_to = HPXML::LocationBasementUnconditioned
  elsif ['base-foundation-conditioned-basement-slab-insulation.xml'].include? hpxml_file
    hpxml.slabs[0].under_slab_insulation_width = 4
    hpxml.slabs[0].under_slab_insulation_r_value = 10
  elsif ['base-foundation-slab.xml'].include? hpxml_file
    hpxml.slabs[0].interior_adjacent_to = HPXML::LocationLivingSpace
    hpxml.slabs[0].under_slab_insulation_width = nil
    hpxml.slabs[0].under_slab_insulation_spans_entire_slab = true
    hpxml.slabs[0].depth_below_grade = 0
    hpxml.slabs[0].under_slab_insulation_r_value = 5
    hpxml.slabs[0].carpet_fraction = 1
    hpxml.slabs[0].carpet_r_value = 2.5
  elsif ['base-foundation-unvented-crawlspace.xml',
         'base-foundation-vented-crawlspace.xml'].include? hpxml_file
    if ['base-foundation-unvented-crawlspace.xml'].include? hpxml_file
      hpxml.slabs[0].interior_adjacent_to = HPXML::LocationCrawlspaceUnvented
    else
      hpxml.slabs[0].interior_adjacent_to = HPXML::LocationCrawlspaceVented
    end
    hpxml.slabs[0].thickness = 0
    hpxml.slabs[0].carpet_r_value = 2.5
  elsif ['base-foundation-multiple.xml'].include? hpxml_file
    hpxml.slabs[0].area = 675
    hpxml.slabs[0].exposed_perimeter = 75
    hpxml.slabs.add(id: 'SlabUnderCrawlspace',
                    interior_adjacent_to: HPXML::LocationCrawlspaceUnvented,
                    area: 675,
                    thickness: 0,
                    exposed_perimeter: 75,
                    perimeter_insulation_depth: 0,
                    under_slab_insulation_width: 0,
                    perimeter_insulation_r_value: 0,
                    under_slab_insulation_r_value: 0,
                    carpet_fraction: 0,
                    carpet_r_value: 0)
  elsif ['base-foundation-ambient.xml'].include? hpxml_file
    hpxml.slabs.clear
  elsif ['base-enclosure-2stories-garage.xml'].include? hpxml_file
    hpxml.slabs[0].area -= 400
    hpxml.slabs[0].exposed_perimeter -= 40
    hpxml.slabs.add(id: 'SlabUnderGarage',
                    interior_adjacent_to: HPXML::LocationGarage,
                    area: 400,
                    thickness: 4,
                    exposed_perimeter: 40,
                    perimeter_insulation_depth: 0,
                    under_slab_insulation_width: 0,
                    depth_below_grade: 0,
                    perimeter_insulation_r_value: 0,
                    under_slab_insulation_r_value: 0,
                    carpet_fraction: 0,
                    carpet_r_value: 0)
  elsif ['base-enclosure-garage.xml'].include? hpxml_file
    hpxml.slabs[0].exposed_perimeter -= 30
    hpxml.slabs.add(id: 'SlabUnderGarage',
                    interior_adjacent_to: HPXML::LocationGarage,
                    area: 600,
                    thickness: 4,
                    exposed_perimeter: 70,
                    perimeter_insulation_depth: 0,
                    under_slab_insulation_width: 0,
                    depth_below_grade: 0,
                    perimeter_insulation_r_value: 0,
                    under_slab_insulation_r_value: 0,
                    carpet_fraction: 0,
                    carpet_r_value: 0)
  elsif ['base-foundation-complex.xml'].include? hpxml_file
    hpxml.slabs.clear
    hpxml.slabs.add(id: 'Slab1',
                    interior_adjacent_to: HPXML::LocationBasementConditioned,
                    area: 675,
                    thickness: 4,
                    exposed_perimeter: 75,
                    perimeter_insulation_depth: 0,
                    under_slab_insulation_width: 0,
                    perimeter_insulation_r_value: 0,
                    under_slab_insulation_r_value: 0,
                    carpet_fraction: 0,
                    carpet_r_value: 0)
    hpxml.slabs.add(id: 'Slab2',
                    interior_adjacent_to: HPXML::LocationBasementConditioned,
                    area: 405,
                    thickness: 4,
                    exposed_perimeter: 45,
                    perimeter_insulation_depth: 1,
                    under_slab_insulation_width: 0,
                    perimeter_insulation_r_value: 5,
                    under_slab_insulation_r_value: 0,
                    carpet_fraction: 0,
                    carpet_r_value: 0)
    hpxml.slabs.add(id: 'Slab3',
                    interior_adjacent_to: HPXML::LocationBasementConditioned,
                    area: 270,
                    thickness: 4,
                    exposed_perimeter: 30,
                    perimeter_insulation_depth: 1,
                    under_slab_insulation_width: 0,
                    perimeter_insulation_r_value: 5,
                    under_slab_insulation_r_value: 0,
                    carpet_fraction: 0,
                    carpet_r_value: 0)
  elsif ['base-enclosure-split-surfaces.xml'].include? hpxml_file
    for n in 1..hpxml.slabs.size
      hpxml.slabs[n - 1].area /= 9.0
      hpxml.slabs[n - 1].exposed_perimeter /= 9.0
      for i in 2..9
        hpxml.slabs << hpxml.slabs[n - 1].dup
        hpxml.slabs[-1].id += i.to_s
      end
    end
    hpxml.slabs << hpxml.slabs[-1].dup
    hpxml.slabs[-1].id = 'TinySlab'
    hpxml.slabs[-1].area = 0.05
  elsif ['invalid_files/mismatched-slab-and-foundation-wall.xml'].include? hpxml_file
    hpxml.slabs[0].interior_adjacent_to = HPXML::LocationBasementUnconditioned
    hpxml.slabs[0].depth_below_grade = 7.0
  elsif ['invalid_files/slab-zero-exposed-perimeter.xml'].include? hpxml_file
    hpxml.slabs[0].exposed_perimeter = 0
  elsif ['invalid_files/enclosure-living-missing-floor-slab.xml',
         'invalid_files/enclosure-basement-missing-slab.xml'].include? hpxml_file
    hpxml.slabs[0].delete
  elsif ['invalid_files/enclosure-garage-missing-slab.xml'].include? hpxml_file
    hpxml.slabs[1].delete
  end
end

def set_hpxml_windows(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L100AC.xml',
      'ASHRAE_Standard_140/L100AL.xml'].include? hpxml_file
    windows = { 'WindowNorth' => [0, 90, 'WallNorth'],
                'WindowEast' => [90, 45, 'WallEast'],
                'WindowSouth' => [180, 90, 'WallSouth'],
                'WindowWest' => [270, 45, 'WallWest'] }
    windows.each do |window_name, window_values|
      azimuth, area, wall = window_values
      hpxml.windows.add(id: window_name,
                        area: area,
                        azimuth: azimuth,
                        ufactor: 1.039,
                        shgc: 0.67,
                        fraction_operable: 0.0,
                        wall_idref: wall,
                        interior_shading_factor_summer: 1,
                        interior_shading_factor_winter: 1)
    end
  elsif ['ASHRAE_Standard_140/L130AC.xml',
         'ASHRAE_Standard_140/L130AL.xml'].include? hpxml_file
    for i in 0..hpxml.windows.size - 1
      hpxml.windows[i].ufactor = 0.3
      hpxml.windows[i].shgc = 0.335
    end
  elsif ['ASHRAE_Standard_140/L140AC.xml',
         'ASHRAE_Standard_140/L140AL.xml'].include? hpxml_file
    hpxml.windows.clear
  elsif ['ASHRAE_Standard_140/L150AC.xml',
         'ASHRAE_Standard_140/L150AL.xml'].include? hpxml_file
    hpxml.windows.clear
    hpxml.windows.add(id: 'WindowSouth',
                      area: 270,
                      azimuth: 180,
                      ufactor: 1.039,
                      shgc: 0.67,
                      fraction_operable: 0.0,
                      wall_idref: 'WallSouth',
                      interior_shading_factor_summer: 1,
                      interior_shading_factor_winter: 1)
  elsif ['ASHRAE_Standard_140/L155AC.xml',
         'ASHRAE_Standard_140/L155AL.xml'].include? hpxml_file
    hpxml.windows[0].overhangs_depth = 2.5
    hpxml.windows[0].overhangs_distance_to_top_of_window = 1
    hpxml.windows[0].overhangs_distance_to_bottom_of_window = 6
  elsif ['ASHRAE_Standard_140/L160AC.xml',
         'ASHRAE_Standard_140/L160AL.xml'].include? hpxml_file
    hpxml.windows.clear
    windows = { 'WindowEast' => [90, 135, 'WallEast'],
                'WindowWest' => [270, 135, 'WallWest'] }
    windows.each do |window_name, window_values|
      azimuth, area, wall = window_values
      hpxml.windows.add(id: window_name,
                        area: area,
                        azimuth: azimuth,
                        ufactor: 1.039,
                        shgc: 0.67,
                        fraction_operable: 0.0,
                        wall_idref: wall,
                        interior_shading_factor_summer: 1,
                        interior_shading_factor_winter: 1)
    end
  elsif ['base.xml'].include? hpxml_file
    hpxml.windows.add(id: 'WindowNorth',
                      area: 108,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Wall')
    hpxml.windows.add(id: 'WindowSouth',
                      area: 108,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Wall')
    hpxml.windows.add(id: 'WindowEast',
                      area: 72,
                      azimuth: 90,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Wall')
    hpxml.windows.add(id: 'WindowWest',
                      area: 72,
                      azimuth: 270,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Wall')
  elsif ['base-enclosure-3d-coordinates.xml'].include? hpxml_file
    hpxml.windows.clear()
    hpxml.windows.add(id: 'Surface_4_-_Window_5_right',
                      area: 12,
                      azimuth: 90,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_4',
                      coordinates: [{ x: 45, y: 19.4, z: 7 }, { x: 45, y: 19.4, z: 3 }, { x: 45, y: 22.4, z: 3 }, { x: 45, y: 22.4, z: 7 }])
    hpxml.windows.add(id: 'Surface_4_-_Window_6_right',
                      area: 12,
                      azimuth: 90,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_4',
                      coordinates: [{ x: 45, y: 22.6, z: 7 }, { x: 45, y: 22.6, z: 3 }, { x: 45, y: 25.6, z: 3 }, { x: 45, y: 25.6, z: 7 }])
    hpxml.windows.add(id: 'Surface_4_-_Window_3_right',
                      area: 12,
                      azimuth: 90,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_4',
                      coordinates: [{ x: 45, y: 11.9, z: 7 }, { x: 45, y: 11.9, z: 3 }, { x: 45, y: 14.9, z: 3 }, { x: 45, y: 14.9, z: 7 }])
    hpxml.windows.add(id: 'Surface_4_-_Window_1_right',
                      area: 12,
                      azimuth: 90,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_4',
                      coordinates: [{ x: 45, y: 4.4, z: 7 }, { x: 45, y: 4.4, z: 3 }, { x: 45, y: 7.4, z: 3 }, { x: 45, y: 7.4, z: 7 }])
    hpxml.windows.add(id: 'Surface_4_-_Window_2_right',
                      area: 12,
                      azimuth: 90,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_4',
                      coordinates: [{ x: 45, y: 7.6, z: 7 }, { x: 45, y: 7.6, z: 3 }, { x: 45, y: 10.6, z: 3 }, { x: 45, y: 10.6, z: 7 }])
    hpxml.windows.add(id: 'Surface_4_-_Window_4_right',
                      area: 12,
                      azimuth: 90,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_4',
                      coordinates: [{ x: 45, y: 15.1, z: 7 }, { x: 45, y: 15.1, z: 3 }, { x: 45, y: 18.1, z: 3 }, { x: 45, y: 18.1, z: 7 }])
    hpxml.windows.add(id: 'Surface_2_-_Window_1_left',
                      area: 12,
                      azimuth: 270,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_2',
                      coordinates: [{ x: 0, y: 25.6, z: 7 }, { x: 0, y: 25.6, z: 3 }, { x: 0, y: 22.6, z: 3 }, { x: 0, y: 22.6, z: 7 }])
    hpxml.windows.add(id: 'Surface_2_-_Window_3_left',
                      area: 12,
                      azimuth: 270,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_2',
                      coordinates: [{ x: 0, y: 18.1, z: 7 }, { x: 0, y: 18.1, z: 3 }, { x: 0, y: 15.1, z: 3 }, { x: 0, y: 15.1, z: 7 }])
    hpxml.windows.add(id: 'Surface_2_-_Window_6_left',
                      area: 12,
                      azimuth: 270,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_2',
                      coordinates: [{ x: 0, y: 7.4, z: 7 }, { x: 0, y: 7.4, z: 3 }, { x: 0, y: 4.4, z: 3 }, { x: 0, y: 4.4, z: 7 }])
    hpxml.windows.add(id: 'Surface_2_-_Window_4_left',
                      area: 12,
                      azimuth: 270,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_2',
                      coordinates: [{ x: 0, y: 14.9, z: 7 }, { x: 0, y: 14.9, z: 3 }, { x: 0, y: 11.9, z: 3 }, { x: 0, y: 11.9, z: 7 }])
    hpxml.windows.add(id: 'Surface_2_-_Window_5_left',
                      area: 12,
                      azimuth: 270,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_2',
                      coordinates: [{ x: 0, y: 10.6, z: 7 }, { x: 0, y: 10.6, z: 3 }, { x: 0, y: 7.6, z: 3 }, { x: 0, y: 7.6, z: 7 }])
    hpxml.windows.add(id: 'Surface_2_-_Window_2_left',
                      area: 12,
                      azimuth: 270,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_2',
                      coordinates: [{ x: 0, y: 22.4, z: 7 }, { x: 0, y: 22.4, z: 3 }, { x: 0, y: 19.4, z: 3 }, { x: 0, y: 19.4, z: 7 }])
    hpxml.windows.add(id: 'Surface_3_-_Window_5_back',
                      area: 12,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_3',
                      coordinates: [{ x: 25.6, y: 30, z: 7 }, { x: 25.6, y: 30, z: 3 }, { x: 22.6, y: 30, z: 3 }, { x: 22.6, y: 30, z: 7 }])
    hpxml.windows.add(id: 'Surface_3_-_Window_6_back',
                      area: 12,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_3',
                      coordinates: [{ x: 22.4, y: 30, z: 7 }, { x: 22.4, y: 30, z: 3 }, { x: 19.4, y: 30, z: 3 }, { x: 19.4, y: 30, z: 7 }])
    hpxml.windows.add(id: 'Surface_3_-_Window_3_back',
                      area: 12,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_3',
                      coordinates: [{ x: 33.1, y: 30, z: 7 }, { x: 33.1, y: 30, z: 3 }, { x: 30.1, y: 30, z: 3 }, { x: 30.1, y: 30, z: 7 }])
    hpxml.windows.add(id: 'Surface_3_-_Window_1_back',
                      area: 12,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_3',
                      coordinates: [{ x: 40.6, y: 30, z: 7 }, { x: 40.6, y: 30, z: 3 }, { x: 37.6, y: 30, z: 3 }, { x: 37.6, y: 30, z: 7 }])
    hpxml.windows.add(id: 'Surface_3_-_Window_7_back',
                      area: 12,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_3',
                      coordinates: [{ x: 18.1, y: 30, z: 7 }, { x: 18.1, y: 30, z: 3 }, { x: 15.1, y: 30, z: 3 }, { x: 15.1, y: 30, z: 7 }])
    hpxml.windows.add(id: 'Surface_3_-_Window_8_back',
                      area: 12,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_3',
                      coordinates: [{ x: 14.9, y: 30, z: 7 }, { x: 14.9, y: 30, z: 3 }, { x: 11.9, y: 30, z: 3 }, { x: 11.9, y: 30, z: 7 }])
    hpxml.windows.add(id: 'Surface_3_-_Window_4_back',
                      area: 12,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_3',
                      coordinates: [{ x: 29.9, y: 30, z: 7 }, { x: 29.9, y: 30, z: 3 }, { x: 26.9, y: 30, z: 3 }, { x: 26.9, y: 30, z: 7 }])
    hpxml.windows.add(id: 'Surface_3_-_Window_2_back',
                      area: 12,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_3',
                      coordinates: [{ x: 37.4, y: 30, z: 7 }, { x: 37.4, y: 30, z: 3 }, { x: 34.4, y: 30, z: 3 }, { x: 34.4, y: 30, z: 7 }])
    hpxml.windows.add(id: 'Surface_3_-_Window_9_back',
                      area: 12,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_3',
                      coordinates: [{ x: 9, y: 30, z: 7 }, { x: 9, y: 30, z: 3 }, { x: 6, y: 30, z: 3 }, { x: 6, y: 30, z: 7 }])
    hpxml.windows.add(id: 'Surface_5_-_Window_1_front',
                      area: 12,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_5',
                      coordinates: [{ x: 4.4, y: 0, z: 7 }, { x: 4.4, y: 0, z: 3 }, { x: 7.4, y: 0, z: 3 }, { x: 7.4, y: 0, z: 7 }])
    hpxml.windows.add(id: 'Surface_5_-_Window_2_front',
                      area: 12,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_5',
                      coordinates: [{ x: 7.6, y: 0, z: 7 }, { x: 7.6, y: 0, z: 3 }, { x: 10.6, y: 0, z: 3 }, { x: 10.6, y: 0, z: 7 }])
    hpxml.windows.add(id: 'Surface_5_-_Window_7_front',
                      area: 12,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_5',
                      coordinates: [{ x: 26.9, y: 0, z: 7 }, { x: 26.9, y: 0, z: 3 }, { x: 29.9, y: 0, z: 3 }, { x: 29.9, y: 0, z: 7 }])
    hpxml.windows.add(id: 'Surface_5_-_Window_4_front',
                      area: 12,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_5',
                      coordinates: [{ x: 15.1, y: 0, z: 7 }, { x: 15.1, y: 0, z: 3 }, { x: 18.1, y: 0, z: 3 }, { x: 18.1, y: 0, z: 7 }])
    hpxml.windows.add(id: 'Surface_5_-_Window_9_front',
                      area: 12,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_5',
                      coordinates: [{ x: 36, y: 0, z: 7 }, { x: 36, y: 0, z: 3 }, { x: 39, y: 0, z: 3 }, { x: 39, y: 0, z: 7 }])
    hpxml.windows.add(id: 'Surface_5_-_Window_3_front',
                      area: 12,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_5',
                      coordinates: [{ x: 11.9, y: 0, z: 7 }, { x: 11.9, y: 0, z: 3 }, { x: 14.9, y: 0, z: 3 }, { x: 14.9, y: 0, z: 7 }])
    hpxml.windows.add(id: 'Surface_5_-_Window_8_front',
                      area: 12,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_5',
                      coordinates: [{ x: 30.1, y: 0, z: 7 }, { x: 30.1, y: 0, z: 3 }, { x: 33.1, y: 0, z: 3 }, { x: 33.1, y: 0, z: 7 }])
    hpxml.windows.add(id: 'Surface_5_-_Window_5_front',
                      area: 12,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_5',
                      coordinates: [{ x: 19.4, y: 0, z: 7 }, { x: 19.4, y: 0, z: 3 }, { x: 22.4, y: 0, z: 3 }, { x: 22.4, y: 0, z: 7 }])
    hpxml.windows.add(id: 'Surface_5_-_Window_6_front',
                      area: 12,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      interior_shading_factor_summer: 0.7,
                      interior_shading_factor_winter: 0.85,
                      wall_idref: 'Surface_5',
                      coordinates: [{ x: 22.6, y: 0, z: 7 }, { x: 22.6, y: 0, z: 3 }, { x: 25.6, y: 0, z: 3 }, { x: 25.6, y: 0, z: 7 }])
  elsif ['invalid_files/attached-multifamily-window-outside-condition.xml'].include? hpxml_file
    hpxml.windows[0].area = 50
    hpxml.windows[0].wall_idref = 'WallOtherMultifamilyBufferSpace'
  elsif ['base-enclosure-overhangs.xml'].include? hpxml_file
    hpxml.windows[0].overhangs_depth = 2.5
    hpxml.windows[0].overhangs_distance_to_top_of_window = 0
    hpxml.windows[0].overhangs_distance_to_bottom_of_window = 4
    hpxml.windows[2].overhangs_depth = 1.5
    hpxml.windows[2].overhangs_distance_to_top_of_window = 2
    hpxml.windows[2].overhangs_distance_to_bottom_of_window = 6
    hpxml.windows[3].overhangs_depth = 1.5
    hpxml.windows[3].overhangs_distance_to_top_of_window = 2
    hpxml.windows[3].overhangs_distance_to_bottom_of_window = 7
  elsif ['base-enclosure-windows-interior-shading.xml'].include? hpxml_file
    hpxml.windows[1].interior_shading_factor_summer = 0.01
    hpxml.windows[1].interior_shading_factor_winter = 0.99
    hpxml.windows[2].interior_shading_factor_summer = 0.0
    hpxml.windows[2].interior_shading_factor_winter = 0.5
    hpxml.windows[3].interior_shading_factor_summer = 1.0
    hpxml.windows[3].interior_shading_factor_winter = 1.0
  elsif ['invalid_files/invalid-window-interior-shading.xml'].include? hpxml_file
    hpxml.windows[0].interior_shading_factor_summer = 0.85
    hpxml.windows[0].interior_shading_factor_winter = 0.7
  elsif ['base-enclosure-windows-none.xml'].include? hpxml_file
    hpxml.windows.clear
  elsif ['invalid_files/net-area-negative-wall.xml'].include? hpxml_file
    hpxml.windows[0].area = 1000
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.windows[0].area = 108
    hpxml.windows[1].area = 108
    hpxml.windows[2].area = 108
    hpxml.windows[3].area = 108
    hpxml.windows.add(id: 'AtticGableWindowEast',
                      area: 12,
                      azimuth: 90,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.0,
                      wall_idref: 'WallAtticGableCond')
    hpxml.windows.add(id: 'AtticGableWindowWest',
                      area: 62,
                      azimuth: 270,
                      ufactor: 0.3,
                      shgc: 0.45,
                      fraction_operable: 0.0,
                      wall_idref: 'WallAtticGableCond')
  elsif ['base-atticroof-cathedral.xml'].include? hpxml_file
    hpxml.windows[0].area = 108
    hpxml.windows[1].area = 108
    hpxml.windows[2].area = 108
    hpxml.windows[3].area = 108
    hpxml.windows.add(id: 'AtticGableWindowEast',
                      area: 12,
                      azimuth: 90,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.0,
                      wall_idref: 'WallAtticGable')
    hpxml.windows.add(id: 'AtticGableWindowWest',
                      area: 12,
                      azimuth: 270,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.0,
                      wall_idref: 'WallAtticGable')
  elsif ['base-enclosure-garage.xml'].include? hpxml_file
    hpxml.windows[1].area = 12
  elsif ['base-enclosure-2stories.xml'].include? hpxml_file
    hpxml.windows[0].area = 216
    hpxml.windows[1].area = 216
    hpxml.windows[2].area = 144
    hpxml.windows[3].area = 144
  elsif ['base-enclosure-2stories-garage'].include? hpxml_file
    hpxml.windows[0].area = 168
    hpxml.windows[1].area = 216
    hpxml.windows[2].area = 144
    hpxml.windows[3].area = 96
  elsif ['base-foundation-unconditioned-basement-above-grade.xml'].include? hpxml_file
    hpxml.windows.add(id: 'FoundationWindowNorth',
                      area: 20,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.0,
                      wall_idref: 'FoundationWall')
    hpxml.windows.add(id: 'FoundationWindowSouth',
                      area: 20,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.0,
                      wall_idref: 'FoundationWall')
    hpxml.windows.add(id: 'FoundationWindowEast',
                      area: 10,
                      azimuth: 90,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.0,
                      wall_idref: 'FoundationWall')
    hpxml.windows.add(id: 'FoundationWindowWest',
                      area: 10,
                      azimuth: 270,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.0,
                      wall_idref: 'FoundationWall')
  elsif ['base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.windows.each do |window|
      window.area *= 0.35
    end
  elsif ['invalid_files/unattached-window.xml'].include? hpxml_file
    hpxml.windows[0].wall_idref = 'foobar'
  elsif ['base-enclosure-split-surfaces.xml'].include? hpxml_file
    area_adjustments = []
    for n in 1..hpxml.windows.size
      hpxml.windows[n - 1].area /= 9.0
      hpxml.windows[n - 1].fraction_operable = 0.0
      for i in 2..9
        hpxml.windows << hpxml.windows[n - 1].dup
        hpxml.windows[-1].id += i.to_s
        hpxml.windows[-1].wall_idref += i.to_s
        if i >= 4
          hpxml.windows[-1].fraction_operable = 1.0
        end
      end
    end
    hpxml.windows << hpxml.windows[-1].dup
    hpxml.windows[-1].id = 'TinyWindow'
    hpxml.windows[-1].area = 0.05
  elsif ['base-foundation-walkout-basement.xml'].include? hpxml_file
    hpxml.windows.add(id: 'FoundationWindow',
                      area: 20,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.0,
                      wall_idref: 'FoundationWall3')
  elsif ['invalid_files/invalid-window-height.xml'].include? hpxml_file
    hpxml.windows[2].overhangs_distance_to_bottom_of_window = hpxml.windows[2].overhangs_distance_to_top_of_window
  elsif ['base-enclosure-walltypes.xml'].include? hpxml_file
    hpxml.windows.clear
    hpxml.windows.add(id: 'WindowNorth',
                      area: 108 / 8,
                      azimuth: 0,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      wall_idref: 'Wall1')
    hpxml.windows.add(id: 'WindowSouth',
                      area: 108 / 8,
                      azimuth: 180,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      wall_idref: 'Wall2')
    hpxml.windows.add(id: 'WindowEast',
                      area: 72 / 8,
                      azimuth: 90,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      wall_idref: 'Wall3')
    hpxml.windows.add(id: 'WindowWest',
                      area: 72 / 8,
                      azimuth: 270,
                      ufactor: 0.33,
                      shgc: 0.45,
                      fraction_operable: 0.67,
                      wall_idref: 'Wall4')
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.windows.each do |window|
      window.interior_shading_factor_summer = nil
      window.interior_shading_factor_winter = nil
      window.fraction_operable = nil
    end
  end
end

def set_hpxml_skylights(hpxml_file, hpxml)
  if ['base-enclosure-skylights.xml'].include? hpxml_file
    hpxml.skylights.add(id: 'SkylightNorth',
                        area: 45,
                        azimuth: 0,
                        ufactor: 0.33,
                        shgc: 0.45,
                        roof_idref: 'Roof')
    hpxml.skylights.add(id: 'SkylightSouth',
                        area: 45,
                        azimuth: 180,
                        ufactor: 0.35,
                        shgc: 0.47,
                        roof_idref: 'Roof')
  elsif ['invalid_files/net-area-negative-roof.xml'].include? hpxml_file
    hpxml.skylights[0].area = 4000
  elsif ['invalid_files/unattached-skylight.xml'].include? hpxml_file
    hpxml.skylights[0].roof_idref = 'foobar'
  elsif ['base-enclosure-split-surfaces.xml'].include? hpxml_file
    for n in 1..hpxml.skylights.size
      hpxml.skylights[n - 1].area /= 9.0
      for i in 2..9
        hpxml.skylights << hpxml.skylights[n - 1].dup
        hpxml.skylights[-1].id += i.to_s
        hpxml.skylights[-1].roof_idref += i.to_s if i % 2 == 0
      end
    end
    hpxml.skylights << hpxml.skylights[-1].dup
    hpxml.skylights[-1].id = 'TinySkylight'
    hpxml.skylights[-1].area = 0.05
  end
end

def set_hpxml_doors(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L100AC.xml',
      'ASHRAE_Standard_140/L100AL.xml'].include? hpxml_file
    doors = { 'DoorSouth' => [180, 20, 'WallSouth'],
              'DoorNorth' => [0, 20, 'WallNorth'] }
    doors.each do |door_name, door_values|
      azimuth, area, wall = door_values
      hpxml.doors.add(id: door_name,
                      wall_idref: wall,
                      area: area,
                      azimuth: azimuth,
                      r_value: 3.04)
    end
  elsif ['base.xml'].include? hpxml_file
    hpxml.doors.add(id: 'DoorNorth',
                    wall_idref: 'Wall',
                    area: 40,
                    azimuth: 0,
                    r_value: 4.4)
    hpxml.doors.add(id: 'DoorSouth',
                    wall_idref: 'Wall',
                    area: 40,
                    azimuth: 180,
                    r_value: 4.4)
  elsif ['base-enclosure-3d-coordinates.xml'].include? hpxml_file
    hpxml.doors.clear()
    hpxml.doors.add(id: 'Surface_5_-_Door_front',
                    wall_idref: 'Surface_5',
                    area: 80,
                    azimuth: 180,
                    r_value: 4.4,
                    coordinates: [{ x: 0.5, y: 0, z: 7 }, { x: 0.5, y: 0, z: 0 }, { x: 11.93, y: 0, z: 0 }, { x: 11.93, y: 0, z: 7 }])
  elsif ['base-enclosure-garage.xml',
         'base-enclosure-2stories-garage.xml'].include? hpxml_file
    hpxml.doors.add(id: 'GarageDoorSouth',
                    wall_idref: 'WallGarageExterior',
                    area: 70,
                    azimuth: 180,
                    r_value: 4.4)
  elsif ['base-enclosure-attached-multifamily.xml'].include? hpxml_file
    hpxml.doors.add(id: 'DoorOnWallOtherHeatedSpace',
                    wall_idref: 'WallOtherHeatedSpace',
                    area: 40,
                    azimuth: 0,
                    r_value: 4.4)
    hpxml.doors.add(id: 'DoorOnFoundationWallOtherNonFreezingSpace',
                    wall_idref: 'FoundationWallOtherNonFreezingSpace',
                    area: 40,
                    azimuth: 0,
                    r_value: 4.4)
    hpxml.doors.add(id: 'DoorOnWallOtherHousingUnit',
                    wall_idref: 'WallOtherHousingUnit',
                    area: 40,
                    azimuth: 0,
                    r_value: 4.4)
    hpxml.doors.add(id: 'DoorOnWallAtticLivingWall',
                    wall_idref: 'WallAtticLivingWall',
                    area: 10,
                    azimuth: 0,
                    r_value: 4.4)
  elsif ['base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.doors.add(id: 'DoorOnWallOtherHousingUnit',
                    wall_idref: 'WallOtherHousingUnit',
                    area: 40,
                    azimuth: 0,
                    r_value: 4.4)
    if ['base-enclosure-other-heated-space.xml'].include? hpxml_file
      hpxml.doors[-1].id = 'DoorOnWallOtherHeatedSpace'
      hpxml.doors[-1].wall_idref = 'WallOtherHeatedSpace'
    elsif ['base-enclosure-other-non-freezing-space.xml'].include? hpxml_file
      hpxml.doors[-1].id = 'DoorOnWallOtherNonFreezingSpace'
      hpxml.doors[-1].wall_idref = 'WallOtherNonFreezingSpace'
    elsif ['base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
      hpxml.doors[-1].id = 'DoorOnWallOtherMultifamilyBufferSpace'
      hpxml.doors[-1].wall_idref = 'WallOtherMultifamilyBufferSpace'
    end
  elsif ['invalid_files/unattached-door.xml'].include? hpxml_file
    hpxml.doors[0].wall_idref = 'foobar'
  elsif ['base-enclosure-split-surfaces.xml'].include? hpxml_file
    area_adjustments = []
    for n in 1..hpxml.doors.size
      hpxml.doors[n - 1].area /= 9.0
      for i in 2..9
        hpxml.doors << hpxml.doors[n - 1].dup
        hpxml.doors[-1].id += i.to_s
        hpxml.doors[-1].wall_idref += i.to_s
      end
    end
    hpxml.doors << hpxml.doors[-1].dup
    hpxml.doors[-1].id = 'TinyDoor'
    hpxml.doors[-1].area = 0.05
  elsif ['base-enclosure-walltypes.xml'].include? hpxml_file
    hpxml.doors.clear
    hpxml.doors.add(id: 'DoorNorth',
                    wall_idref: 'Wall9',
                    area: 40,
                    azimuth: 0,
                    r_value: 4.4)
    hpxml.doors.add(id: 'DoorSouth',
                    wall_idref: 'Wall10',
                    area: 40,
                    azimuth: 180,
                    r_value: 4.4)
  end
end

def set_hpxml_heating_systems(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.heating_systems.add(id: 'HeatingSystem',
                              distribution_system_idref: 'HVACDistribution',
                              heating_system_type: HPXML::HVACTypeFurnace,
                              heating_system_fuel: HPXML::FuelTypeNaturalGas,
                              heating_capacity: 64000,
                              heating_efficiency_afue: 0.92,
                              fraction_heat_load_served: 1)
  elsif ['base-hvac-air-to-air-heat-pump-1-speed.xml',
         'base-hvac-air-to-air-heat-pump-2-speed.xml',
         'base-hvac-air-to-air-heat-pump-var-speed.xml',
         'base-hvac-central-ac-only-1-speed.xml',
         'base-hvac-central-ac-only-2-speed.xml',
         'base-hvac-central-ac-only-var-speed.xml',
         'base-hvac-evap-cooler-only.xml',
         'base-hvac-evap-cooler-only-ducted.xml',
         'base-hvac-ground-to-air-heat-pump.xml',
         'base-hvac-mini-split-heat-pump-ducted.xml',
         'base-hvac-ideal-air.xml',
         'base-hvac-none.xml',
         'base-hvac-room-ac-only.xml',
         'invalid_files/orphaned-hvac-distribution.xml'].include? hpxml_file
    hpxml.heating_systems.clear
  elsif ['base-hvac-boiler-elec-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypeBoiler
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeElectricity
    hpxml.heating_systems[0].heating_efficiency_afue = 1
  elsif ['base-hvac-boiler-gas-central-ac-1-speed.xml',
         'base-hvac-boiler-gas-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypeBoiler
    hpxml.heating_systems[0].electric_auxiliary_energy = 200
  elsif ['base-hvac-boiler-oil-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypeBoiler
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeOil
  elsif ['base-hvac-boiler-propane-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypeBoiler
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypePropane
  elsif ['base-hvac-boiler-wood-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypeBoiler
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeWood
  elsif ['base-hvac-elec-resistance-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].distribution_system_idref = nil
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypeElectricResistance
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeElectricity
    hpxml.heating_systems[0].heating_efficiency_afue = nil
    hpxml.heating_systems[0].heating_efficiency_percent = 1
  elsif ['base-hvac-furnace-elec-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeElectricity
    hpxml.heating_systems[0].heating_efficiency_afue = 1
  elsif ['base-hvac-furnace-gas-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].electric_auxiliary_energy = 700
  elsif ['base-hvac-furnace-oil-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeOil
  elsif ['base-hvac-furnace-propane-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypePropane
  elsif ['base-hvac-furnace-wood-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeWood
  elsif ['base-hvac-multiple.xml'].include? hpxml_file
    hpxml.heating_systems.clear
    hpxml.heating_systems.add(id: 'HeatingSystem',
                              distribution_system_idref: 'HVACDistribution',
                              heating_system_type: HPXML::HVACTypeFurnace,
                              heating_system_fuel: HPXML::FuelTypeElectricity,
                              heating_capacity: 6400,
                              heating_efficiency_afue: 1,
                              fraction_heat_load_served: 0.1)
    hpxml.heating_systems.add(id: 'HeatingSystem2',
                              distribution_system_idref: 'HVACDistribution2',
                              heating_system_type: HPXML::HVACTypeFurnace,
                              heating_system_fuel: HPXML::FuelTypeNaturalGas,
                              heating_capacity: 6400,
                              heating_efficiency_afue: 0.92,
                              fraction_heat_load_served: 0.1,
                              electric_auxiliary_energy: 700)
    hpxml.heating_systems.add(id: 'HeatingSystem3',
                              distribution_system_idref: 'HVACDistribution3',
                              heating_system_type: HPXML::HVACTypeBoiler,
                              heating_system_fuel: HPXML::FuelTypeElectricity,
                              heating_capacity: 6400,
                              heating_efficiency_afue: 1,
                              fraction_heat_load_served: 0.1)
    hpxml.heating_systems.add(id: 'HeatingSystem4',
                              distribution_system_idref: 'HVACDistribution4',
                              heating_system_type: HPXML::HVACTypeBoiler,
                              heating_system_fuel: HPXML::FuelTypeNaturalGas,
                              heating_capacity: 6400,
                              heating_efficiency_afue: 0.92,
                              fraction_heat_load_served: 0.1,
                              electric_auxiliary_energy: 200)
    hpxml.heating_systems.add(id: 'HeatingSystem5',
                              heating_system_type: HPXML::HVACTypeElectricResistance,
                              heating_system_fuel: HPXML::FuelTypeElectricity,
                              heating_capacity: 6400,
                              heating_efficiency_percent: 1,
                              fraction_heat_load_served: 0.1)
    hpxml.heating_systems.add(id: 'HeatingSystem6',
                              heating_system_type: HPXML::HVACTypeStove,
                              heating_system_fuel: HPXML::FuelTypeOil,
                              heating_capacity: 6400,
                              heating_efficiency_percent: 0.8,
                              fraction_heat_load_served: 0.1,
                              electric_auxiliary_energy: 200)
    hpxml.heating_systems.add(id: 'HeatingSystem7',
                              heating_system_type: HPXML::HVACTypeWallFurnace,
                              heating_system_fuel: HPXML::FuelTypePropane,
                              heating_capacity: 6400,
                              heating_efficiency_afue: 0.8,
                              fraction_heat_load_served: 0.1,
                              electric_auxiliary_energy: 200)
  elsif ['base-hvac-multiple2.xml'].include? hpxml_file
    hpxml.heating_systems.clear
    hpxml.heating_systems.add(id: 'HeatingSystem',
                              distribution_system_idref: 'HVACDistribution',
                              heating_system_type: HPXML::HVACTypeFurnace,
                              heating_system_fuel: HPXML::FuelTypeElectricity,
                              heating_capacity: 6400,
                              heating_efficiency_afue: 1,
                              fraction_heat_load_served: 0.2)
    hpxml.heating_systems.add(id: 'HeatingSystem2',
                              distribution_system_idref: 'HVACDistribution2',
                              heating_system_type: HPXML::HVACTypeFurnace,
                              heating_system_fuel: HPXML::FuelTypeElectricity,
                              heating_capacity: 6400,
                              heating_efficiency_afue: 0.92,
                              fraction_heat_load_served: 0.2,
                              electric_auxiliary_energy: 700)
    hpxml.heating_systems.add(id: 'HeatingSystem3',
                              distribution_system_idref: 'HVACDistribution3',
                              heating_system_type: HPXML::HVACTypeBoiler,
                              heating_system_fuel: HPXML::FuelTypeElectricity,
                              heating_capacity: 6400,
                              heating_efficiency_afue: 1,
                              fraction_heat_load_served: 0.2)
    hpxml.heating_systems.add(id: 'HeatingSystem4',
                              heating_system_type: HPXML::HVACTypeElectricResistance,
                              heating_system_fuel: HPXML::FuelTypeElectricity,
                              heating_capacity: 3200,
                              heating_efficiency_percent: 1,
                              fraction_heat_load_served: 0.1)
  elsif ['invalid_files/hvac-frac-load-served.xml'].include? hpxml_file
    hpxml.heating_systems[0].fraction_heat_load_served += 0.1
  elsif ['base-hvac-fireplace-wood-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].distribution_system_idref = nil
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypeFireplace
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeWood
    hpxml.heating_systems[0].heating_efficiency_afue = nil
    hpxml.heating_systems[0].heating_efficiency_percent = 0.8
  elsif ['base-hvac-floor-furnace-propane-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].distribution_system_idref = nil
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypeFloorFurnace
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypePropane
    hpxml.heating_systems[0].heating_efficiency_afue = 0.8
    hpxml.heating_systems[0].electric_auxiliary_energy = 200
  elsif ['base-hvac-portable-heater-electric-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].distribution_system_idref = nil
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypePortableHeater
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeElectricity
    hpxml.heating_systems[0].heating_efficiency_afue = nil
    hpxml.heating_systems[0].heating_efficiency_percent = 1.0
  elsif ['base-hvac-stove-oil-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].distribution_system_idref = nil
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypeStove
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeOil
    hpxml.heating_systems[0].heating_efficiency_afue = nil
    hpxml.heating_systems[0].heating_efficiency_percent = 0.8
    hpxml.heating_systems[0].electric_auxiliary_energy = 200
  elsif ['base-hvac-stove-wood-pellets-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].distribution_system_idref = nil
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypeStove
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeWoodPellets
    hpxml.heating_systems[0].heating_efficiency_afue = nil
    hpxml.heating_systems[0].heating_efficiency_percent = 0.8
    hpxml.heating_systems[0].electric_auxiliary_energy = 200
  elsif ['base-hvac-wall-furnace-elec-only.xml'].include? hpxml_file
    hpxml.heating_systems[0].distribution_system_idref = nil
    hpxml.heating_systems[0].heating_system_type = HPXML::HVACTypeWallFurnace
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeElectricity
    hpxml.heating_systems[0].heating_efficiency_afue = 1.0
    hpxml.heating_systems[0].electric_auxiliary_energy = 200
  elsif ['base-hvac-furnace-x3-dse.xml'].include? hpxml_file
    hpxml.heating_systems << hpxml.heating_systems[0].dup
    hpxml.heating_systems << hpxml.heating_systems[1].dup
    hpxml.heating_systems[1].id = 'HeatingSystem2'
    hpxml.heating_systems[1].distribution_system_idref = 'HVACDistribution2'
    hpxml.heating_systems[2].id = 'HeatingSystem3'
    hpxml.heating_systems[2].distribution_system_idref = 'HVACDistribution3'
    for i in 0..2
      hpxml.heating_systems[i].heating_capacity /= 3.0
      # Test a file where sum is slightly greater than 1
      if i < 2
        hpxml.heating_systems[i].fraction_heat_load_served = 0.33
      else
        hpxml.heating_systems[i].fraction_heat_load_served = 0.35
      end
    end
  elsif ['base-hvac-furnace-elec-central-ac-1-speed.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_system_fuel = HPXML::FuelTypeElectricity
    hpxml.heating_systems[0].heating_efficiency_afue = 1
  elsif ['invalid_files/unattached-hvac-distribution.xml'].include? hpxml_file
    hpxml.heating_systems[0].distribution_system_idref = 'foobar'
  elsif ['invalid_files/hvac-invalid-distribution-system-type.xml'].include? hpxml_file
    hpxml.heating_systems[0].distribution_system_idref = 'HVACDistribution2'
  elsif ['invalid_files/hvac-dse-multiple-attached-heating.xml'].include? hpxml_file
    hpxml.heating_systems[0].fraction_heat_load_served = 0.5
    hpxml.heating_systems << hpxml.heating_systems[0].dup
    hpxml.heating_systems[1].id += '2'
  elsif ['base-hvac-undersized.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_capacity /= 10.0
  elsif ['base-hvac-flowrate.xml'].include? hpxml_file
    hpxml.heating_systems[0].heating_cfm = hpxml.heating_systems[0].heating_capacity * 360.0 / 12000.0
  elsif hpxml_file.include?('hvac_autosizing') && (not hpxml.heating_systems.nil?) && (hpxml.heating_systems.size > 0)
    hpxml.heating_systems[0].heating_capacity = nil
  end
end

def set_hpxml_cooling_systems(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.cooling_systems.add(id: 'CoolingSystem',
                              distribution_system_idref: 'HVACDistribution',
                              cooling_system_type: HPXML::HVACTypeCentralAirConditioner,
                              cooling_system_fuel: HPXML::FuelTypeElectricity,
                              cooling_capacity: 48000,
                              fraction_cool_load_served: 1,
                              cooling_efficiency_seer: 13,
                              cooling_shr: 0.73,
                              compressor_type: HPXML::HVACCompressorTypeSingleStage)
  elsif ['base-hvac-air-to-air-heat-pump-1-speed.xml',
         'base-hvac-air-to-air-heat-pump-2-speed.xml',
         'base-hvac-air-to-air-heat-pump-var-speed.xml',
         'base-hvac-boiler-elec-only.xml',
         'base-hvac-boiler-gas-only.xml',
         'base-hvac-boiler-oil-only.xml',
         'base-hvac-boiler-propane-only.xml',
         'base-hvac-boiler-wood-only.xml',
         'base-hvac-elec-resistance-only.xml',
         'base-hvac-fireplace-wood-only.xml',
         'base-hvac-floor-furnace-propane-only.xml',
         'base-hvac-furnace-elec-only.xml',
         'base-hvac-furnace-gas-only.xml',
         'base-hvac-furnace-oil-only.xml',
         'base-hvac-furnace-propane-only.xml',
         'base-hvac-furnace-wood-only.xml',
         'base-hvac-ground-to-air-heat-pump.xml',
         'base-hvac-mini-split-heat-pump-ducted.xml',
         'base-hvac-ideal-air.xml',
         'base-hvac-none.xml',
         'base-hvac-stove-oil-only.xml',
         'base-hvac-stove-wood-pellets-only.xml',
         'base-hvac-wall-furnace-elec-only.xml'].include? hpxml_file
    hpxml.cooling_systems.clear
  elsif ['base-hvac-boiler-gas-central-ac-1-speed.xml'].include? hpxml_file
    hpxml.cooling_systems[0].distribution_system_idref = 'HVACDistribution2'
  elsif ['base-hvac-furnace-gas-central-ac-2-speed.xml',
         'base-hvac-central-ac-only-2-speed.xml'].include? hpxml_file
    hpxml.cooling_systems[0].cooling_efficiency_seer = 18
    hpxml.cooling_systems[0].cooling_shr = 0.73
    hpxml.cooling_systems[0].compressor_type = HPXML::HVACCompressorTypeTwoStage
  elsif ['base-hvac-furnace-gas-central-ac-var-speed.xml',
         'base-hvac-central-ac-only-var-speed.xml'].include? hpxml_file
    hpxml.cooling_systems[0].cooling_efficiency_seer = 24
    hpxml.cooling_systems[0].cooling_shr = 0.78
    hpxml.cooling_systems[0].compressor_type = HPXML::HVACCompressorTypeVariableSpeed
  elsif ['base-hvac-furnace-gas-room-ac.xml',
         'base-hvac-room-ac-only.xml'].include? hpxml_file
    hpxml.cooling_systems[0].distribution_system_idref = nil
    hpxml.cooling_systems[0].cooling_system_type = HPXML::HVACTypeRoomAirConditioner
    hpxml.cooling_systems[0].cooling_efficiency_seer = nil
    hpxml.cooling_systems[0].cooling_efficiency_eer = 8.5
    hpxml.cooling_systems[0].cooling_shr = 0.65
    hpxml.cooling_systems[0].compressor_type = nil
  elsif ['base-hvac-room-ac-only-33percent.xml'].include? hpxml_file
    hpxml.cooling_systems[0].fraction_cool_load_served = 0.33
  elsif ['base-hvac-evap-cooler-only-ducted.xml',
         'base-hvac-evap-cooler-furnace-gas.xml',
         'base-hvac-evap-cooler-only.xml',
         'hvac_autosizing/base-hvac-evap-cooler-furnace-gas-autosize.xml'].include? hpxml_file
    hpxml.cooling_systems[0].cooling_system_type = HPXML::HVACTypeEvaporativeCooler
    hpxml.cooling_systems[0].cooling_efficiency_seer = nil
    hpxml.cooling_systems[0].cooling_efficiency_eer = nil
    hpxml.cooling_systems[0].cooling_capacity = nil
    hpxml.cooling_systems[0].cooling_shr = nil
    hpxml.cooling_systems[0].compressor_type = nil
    if ['base-hvac-evap-cooler-furnace-gas.xml',
        'hvac_autosizing/base-hvac-evap-cooler-furnace-gas-autosize.xml',
        'base-hvac-evap-cooler-only.xml'].include? hpxml_file
      hpxml.cooling_systems[0].distribution_system_idref = nil
    end
  elsif ['base-hvac-multiple.xml'].include? hpxml_file
    hpxml.cooling_systems[0].distribution_system_idref = 'HVACDistribution2'
    hpxml.cooling_systems[0].fraction_cool_load_served = 0.2
    hpxml.cooling_systems[0].cooling_capacity *= 0.2
    hpxml.cooling_systems.add(id: 'CoolingSystem2',
                              cooling_system_type: HPXML::HVACTypeRoomAirConditioner,
                              cooling_system_fuel: HPXML::FuelTypeElectricity,
                              cooling_capacity: 9600,
                              fraction_cool_load_served: 0.2,
                              cooling_efficiency_eer: 8.5,
                              cooling_shr: 0.65)
  elsif ['base-hvac-multiple2.xml'].include? hpxml_file
    hpxml.cooling_systems[0].distribution_system_idref = 'HVACDistribution'
    hpxml.cooling_systems[0].fraction_cool_load_served = 0.25
    hpxml.cooling_systems[0].cooling_capacity *= 0.25
    hpxml.cooling_systems.add(id: 'CoolingSystem2',
                              distribution_system_idref: 'HVACDistribution2',
                              cooling_system_type: HPXML::HVACTypeCentralAirConditioner,
                              cooling_system_fuel: HPXML::FuelTypeElectricity,
                              cooling_capacity: 9600,
                              fraction_cool_load_served: 0.25,
                              cooling_efficiency_seer: 13,
                              cooling_shr: 0.65)
  elsif ['invalid_files/hvac-frac-load-served.xml'].include? hpxml_file
    hpxml.cooling_systems[0].fraction_cool_load_served += 0.2
  elsif ['invalid_files/hvac-dse-multiple-attached-cooling.xml'].include? hpxml_file
    hpxml.cooling_systems[0].fraction_cool_load_served = 0.5
    hpxml.cooling_systems << hpxml.cooling_systems[0].dup
    hpxml.cooling_systems[1].id += '2'
  elsif ['base-hvac-undersized.xml'].include? hpxml_file
    hpxml.cooling_systems[0].cooling_capacity /= 10.0
  elsif ['base-hvac-flowrate.xml'].include? hpxml_file
    hpxml.cooling_systems[0].cooling_cfm = hpxml.cooling_systems[0].cooling_capacity * 360.0 / 12000.0
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.cooling_systems[0].cooling_shr = nil
    hpxml.cooling_systems[0].compressor_type = nil
  elsif hpxml_file.include?('hvac_autosizing') && (not hpxml.cooling_systems.nil?) && (hpxml.cooling_systems.size > 0)
    hpxml.cooling_systems[0].cooling_capacity = nil
  end
end

def set_hpxml_heat_pumps(hpxml_file, hpxml)
  if ['base-hvac-air-to-air-heat-pump-1-speed.xml',
      'base-hvac-central-ac-plus-air-to-air-heat-pump-heating.xml'].include? hpxml_file
    hpxml.heat_pumps.add(id: 'HeatPump',
                         distribution_system_idref: 'HVACDistribution',
                         heat_pump_type: HPXML::HVACTypeHeatPumpAirToAir,
                         heat_pump_fuel: HPXML::FuelTypeElectricity,
                         heating_capacity: 42000,
                         cooling_capacity: 48000,
                         backup_heating_fuel: HPXML::FuelTypeElectricity,
                         backup_heating_capacity: 34121,
                         backup_heating_efficiency_percent: 1.0,
                         fraction_heat_load_served: 1,
                         fraction_cool_load_served: 1,
                         heating_efficiency_hspf: 7.7,
                         cooling_efficiency_seer: 13,
                         heating_capacity_17F: 42000 * 0.630, # Based on OAT slope of default curves
                         cooling_shr: 0.73,
                         compressor_type: HPXML::HVACCompressorTypeSingleStage)
    if hpxml_file == 'base-hvac-central-ac-plus-air-to-air-heat-pump-heating.xml'
      hpxml.heat_pumps[0].fraction_cool_load_served = 0
    end
  elsif ['base-hvac-air-to-air-heat-pump-2-speed.xml'].include? hpxml_file
    hpxml.heat_pumps.add(id: 'HeatPump',
                         distribution_system_idref: 'HVACDistribution',
                         heat_pump_type: HPXML::HVACTypeHeatPumpAirToAir,
                         heat_pump_fuel: HPXML::FuelTypeElectricity,
                         heating_capacity: 42000,
                         cooling_capacity: 48000,
                         backup_heating_fuel: HPXML::FuelTypeElectricity,
                         backup_heating_capacity: 34121,
                         backup_heating_efficiency_percent: 1.0,
                         fraction_heat_load_served: 1,
                         fraction_cool_load_served: 1,
                         heating_efficiency_hspf: 9.3,
                         cooling_efficiency_seer: 18,
                         heating_capacity_17F: 42000 * 0.590, # Based on OAT slope of default curves
                         cooling_shr: 0.73,
                         compressor_type: HPXML::HVACCompressorTypeTwoStage)
  elsif ['base-hvac-air-to-air-heat-pump-var-speed.xml'].include? hpxml_file
    hpxml.heat_pumps.add(id: 'HeatPump',
                         distribution_system_idref: 'HVACDistribution',
                         heat_pump_type: HPXML::HVACTypeHeatPumpAirToAir,
                         heat_pump_fuel: HPXML::FuelTypeElectricity,
                         heating_capacity: 42000,
                         cooling_capacity: 48000,
                         backup_heating_fuel: HPXML::FuelTypeElectricity,
                         backup_heating_capacity: 34121,
                         backup_heating_efficiency_percent: 1.0,
                         fraction_heat_load_served: 1,
                         fraction_cool_load_served: 1,
                         heating_efficiency_hspf: 10,
                         cooling_efficiency_seer: 22,
                         heating_capacity_17F: 42000 * 0.640, # Based on OAT slope of default curves
                         cooling_shr: 0.78,
                         compressor_type: HPXML::HVACCompressorTypeVariableSpeed)
  elsif ['base-hvac-ground-to-air-heat-pump.xml'].include? hpxml_file
    hpxml.heat_pumps.add(id: 'HeatPump',
                         distribution_system_idref: 'HVACDistribution',
                         heat_pump_type: HPXML::HVACTypeHeatPumpGroundToAir,
                         heat_pump_fuel: HPXML::FuelTypeElectricity,
                         heating_capacity: 42000,
                         cooling_capacity: 48000,
                         backup_heating_fuel: HPXML::FuelTypeElectricity,
                         backup_heating_capacity: 34121,
                         backup_heating_efficiency_percent: 1.0,
                         fraction_heat_load_served: 1,
                         fraction_cool_load_served: 1,
                         heating_efficiency_cop: 3.6,
                         cooling_efficiency_eer: 16.6,
                         cooling_shr: 0.73)
  elsif ['base-hvac-mini-split-heat-pump-ducted.xml'].include? hpxml_file
    f = 1.0 - (1.0 - 0.25) / (47.0 + 5.0) * (47.0 - 17.0)
    hpxml.heat_pumps.add(id: 'HeatPump',
                         distribution_system_idref: 'HVACDistribution',
                         heat_pump_type: HPXML::HVACTypeHeatPumpMiniSplit,
                         heat_pump_fuel: HPXML::FuelTypeElectricity,
                         heating_capacity: 52000,
                         cooling_capacity: 48000,
                         backup_heating_fuel: HPXML::FuelTypeElectricity,
                         backup_heating_capacity: 34121,
                         backup_heating_efficiency_percent: 1.0,
                         fraction_heat_load_served: 1,
                         fraction_cool_load_served: 1,
                         heating_efficiency_hspf: 10,
                         cooling_efficiency_seer: 19,
                         heating_capacity_17F: 52000 * f,
                         cooling_shr: 0.73)
  elsif ['base-hvac-mini-split-heat-pump-ducted-heating-only.xml'].include? hpxml_file
    hpxml.heat_pumps[0].cooling_capacity = 0
    hpxml.heat_pumps[0].fraction_cool_load_served = 0
  elsif ['base-hvac-mini-split-heat-pump-ducted-cooling-only.xml'].include? hpxml_file
    hpxml.heat_pumps[0].heating_capacity = 0
    hpxml.heat_pumps[0].heating_capacity_17F = 0
    hpxml.heat_pumps[0].fraction_heat_load_served = 0
    hpxml.heat_pumps[0].backup_heating_fuel = nil
  elsif ['base-hvac-mini-split-heat-pump-ductless.xml'].include? hpxml_file
    hpxml.heat_pumps[0].distribution_system_idref = nil
    hpxml.heat_pumps[0].backup_heating_fuel = nil
  elsif ['invalid_files/heat-pump-mixed-fixed-and-autosize-capacities.xml'].include? hpxml_file
    hpxml.heat_pumps[0].cooling_capacity = nil
    hpxml.heat_pumps[0].heating_capacity = nil
    hpxml.heat_pumps[0].heating_capacity_17F = 25000
  elsif ['invalid_files/heat-pump-mixed-fixed-and-autosize-capacities2.xml'].include? hpxml_file
    hpxml.heat_pumps[0].backup_heating_capacity = nil
  elsif ['base-hvac-multiple.xml'].include? hpxml_file
    hpxml.heat_pumps.add(id: 'HeatPump',
                         distribution_system_idref: 'HVACDistribution5',
                         heat_pump_type: HPXML::HVACTypeHeatPumpAirToAir,
                         heat_pump_fuel: HPXML::FuelTypeElectricity,
                         heating_capacity: 4800,
                         cooling_capacity: 4800,
                         backup_heating_fuel: HPXML::FuelTypeElectricity,
                         backup_heating_capacity: 3412,
                         backup_heating_efficiency_percent: 1.0,
                         fraction_heat_load_served: 0.1,
                         fraction_cool_load_served: 0.2,
                         heating_efficiency_hspf: 7.7,
                         cooling_efficiency_seer: 13,
                         heating_capacity_17F: 4800 * 0.630, # Based on OAT slope of default curves
                         cooling_shr: 0.73,
                         compressor_type: HPXML::HVACCompressorTypeSingleStage)
    hpxml.heat_pumps.add(id: 'HeatPump2',
                         distribution_system_idref: 'HVACDistribution6',
                         heat_pump_type: HPXML::HVACTypeHeatPumpGroundToAir,
                         heat_pump_fuel: HPXML::FuelTypeElectricity,
                         heating_capacity: 4800,
                         cooling_capacity: 4800,
                         backup_heating_fuel: HPXML::FuelTypeElectricity,
                         backup_heating_capacity: 3412,
                         backup_heating_efficiency_percent: 1.0,
                         fraction_heat_load_served: 0.1,
                         fraction_cool_load_served: 0.2,
                         heating_efficiency_cop: 3.6,
                         cooling_efficiency_eer: 16.6,
                         cooling_shr: 0.73)
    f = 1.0 - (1.0 - 0.25) / (47.0 + 5.0) * (47.0 - 17.0)
    hpxml.heat_pumps.add(id: 'HeatPump3',
                         heat_pump_type: HPXML::HVACTypeHeatPumpMiniSplit,
                         heat_pump_fuel: HPXML::FuelTypeElectricity,
                         heating_capacity: 4800,
                         cooling_capacity: 4800,
                         backup_heating_fuel: HPXML::FuelTypeElectricity,
                         backup_heating_capacity: 3412,
                         backup_heating_efficiency_percent: 1.0,
                         fraction_heat_load_served: 0.1,
                         fraction_cool_load_served: 0.2,
                         heating_efficiency_hspf: 10,
                         cooling_efficiency_seer: 19,
                         heating_capacity_17F: 4800 * f,
                         cooling_shr: 0.73)
  elsif ['base-hvac-multiple2.xml'].include? hpxml_file
    hpxml.heat_pumps.add(id: 'HeatPump',
                         distribution_system_idref: 'HVACDistribution4',
                         heat_pump_type: HPXML::HVACTypeHeatPumpAirToAir,
                         heat_pump_fuel: HPXML::FuelTypeElectricity,
                         heating_capacity: 4800,
                         cooling_capacity: 4800,
                         backup_heating_fuel: HPXML::FuelTypeElectricity,
                         backup_heating_capacity: 3412,
                         backup_heating_efficiency_percent: 1.0,
                         fraction_heat_load_served: 0.1,
                         fraction_cool_load_served: 0.2,
                         heating_efficiency_hspf: 7.7,
                         cooling_efficiency_seer: 13,
                         heating_capacity_17F: 4800 * 0.630, # Based on OAT slope of default curves
                         cooling_shr: 0.73,
                         compressor_type: HPXML::HVACCompressorTypeSingleStage)
    hpxml.heat_pumps.add(id: 'HeatPump2',
                         distribution_system_idref: 'HVACDistribution5',
                         heat_pump_type: HPXML::HVACTypeHeatPumpGroundToAir,
                         heat_pump_fuel: HPXML::FuelTypeElectricity,
                         heating_capacity: 4800,
                         cooling_capacity: 4800,
                         backup_heating_fuel: HPXML::FuelTypeElectricity,
                         backup_heating_capacity: 3412,
                         backup_heating_efficiency_percent: 1.0,
                         fraction_heat_load_served: 0.1,
                         fraction_cool_load_served: 0.2,
                         heating_efficiency_cop: 3.6,
                         cooling_efficiency_eer: 16.6,
                         cooling_shr: 0.73)
  elsif ['invalid_files/hvac-distribution-multiple-attached-heating.xml'].include? hpxml_file
    hpxml.heat_pumps[0].distribution_system_idref = 'HVACDistribution'
  elsif ['invalid_files/hvac-distribution-multiple-attached-cooling.xml'].include? hpxml_file
    hpxml.heat_pumps[0].distribution_system_idref = 'HVACDistribution2'
  elsif ['base-hvac-dual-fuel-air-to-air-heat-pump-1-speed.xml',
         'base-hvac-dual-fuel-air-to-air-heat-pump-2-speed.xml',
         'base-hvac-dual-fuel-air-to-air-heat-pump-var-speed.xml',
         'base-hvac-dual-fuel-mini-split-heat-pump-ducted.xml'].include? hpxml_file
    hpxml.heat_pumps[0].backup_heating_fuel = HPXML::FuelTypeNaturalGas
    hpxml.heat_pumps[0].backup_heating_capacity = 36000
    hpxml.heat_pumps[0].backup_heating_efficiency_percent = nil
    hpxml.heat_pumps[0].backup_heating_efficiency_afue = 0.95
    hpxml.heat_pumps[0].backup_heating_switchover_temp = 25
  elsif ['base-hvac-dual-fuel-air-to-air-heat-pump-1-speed-electric.xml'].include? hpxml_file
    hpxml.heat_pumps[0].backup_heating_fuel = HPXML::FuelTypeElectricity
    hpxml.heat_pumps[0].backup_heating_efficiency_afue = 1.0
  elsif hpxml_file.include?('hvac_autosizing') && (not hpxml.heat_pumps.nil?) && (hpxml.heat_pumps.size > 0)
    hpxml.heat_pumps[0].cooling_capacity = nil
    hpxml.heat_pumps[0].heating_capacity = nil
    hpxml.heat_pumps[0].heating_capacity_17F = nil
    hpxml.heat_pumps[0].backup_heating_capacity = nil
  end
end

def set_hpxml_hvac_control(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L100AC.xml',
      'ASHRAE_Standard_140/L100AL.xml'].include? hpxml_file
    hpxml.hvac_controls.add(id: 'HVACControl',
                            heating_setpoint_temp: 68,
                            cooling_setpoint_temp: 78)
  elsif ['base.xml'].include? hpxml_file
    hpxml.hvac_controls.add(id: 'HVACControl',
                            control_type: HPXML::HVACControlTypeManual,
                            heating_setpoint_temp: 68,
                            cooling_setpoint_temp: 78)
  elsif ['base-hvac-none.xml'].include? hpxml_file
    hpxml.hvac_controls.clear
  elsif ['base-hvac-programmable-thermostat.xml'].include? hpxml_file
    hpxml.hvac_controls[0].control_type = HPXML::HVACControlTypeProgrammable
    hpxml.hvac_controls[0].heating_setback_temp = 66
    hpxml.hvac_controls[0].heating_setback_hours_per_week = 7 * 7
    hpxml.hvac_controls[0].heating_setback_start_hour = 23 # 11pm
    hpxml.hvac_controls[0].cooling_setup_temp = 80
    hpxml.hvac_controls[0].cooling_setup_hours_per_week = 6 * 7
    hpxml.hvac_controls[0].cooling_setup_start_hour = 9 # 9am
  elsif ['base-hvac-setpoints.xml'].include? hpxml_file
    hpxml.hvac_controls[0].heating_setpoint_temp = 60
    hpxml.hvac_controls[0].cooling_setpoint_temp = 80
  elsif ['base-misc-ceiling-fans.xml'].include? hpxml_file
    hpxml.hvac_controls[0].ceiling_fan_cooling_setpoint_temp_offset = 0.5
  end
end

def set_hpxml_hvac_distributions(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.hvac_distributions.add(id: 'HVACDistribution',
                                 distribution_system_type: HPXML::HVACDistributionTypeAir,
                                 conditioned_floor_area_served: 2700)
    hpxml.hvac_distributions[0].duct_leakage_measurements.add(duct_type: HPXML::DuctTypeSupply,
                                                              duct_leakage_units: HPXML::UnitsCFM25,
                                                              duct_leakage_value: 75,
                                                              duct_leakage_total_or_to_outside: HPXML::DuctLeakageToOutside)
    hpxml.hvac_distributions[0].duct_leakage_measurements.add(duct_type: HPXML::DuctTypeReturn,
                                                              duct_leakage_units: HPXML::UnitsCFM25,
                                                              duct_leakage_value: 25,
                                                              duct_leakage_total_or_to_outside: HPXML::DuctLeakageToOutside)
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeSupply,
                                          duct_insulation_r_value: 4,
                                          duct_location: HPXML::LocationAtticUnvented,
                                          duct_surface_area: 150)
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeReturn,
                                          duct_insulation_r_value: 0,
                                          duct_location: HPXML::LocationAtticUnvented,
                                          duct_surface_area: 50)
  elsif ['base-hvac-boiler-elec-only.xml',
         'base-hvac-boiler-gas-only.xml',
         'base-hvac-boiler-oil-only.xml',
         'base-hvac-boiler-propane-only.xml',
         'base-hvac-boiler-wood-only.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].distribution_system_type = HPXML::HVACDistributionTypeHydronic
    hpxml.hvac_distributions[0].duct_leakage_measurements.clear
    hpxml.hvac_distributions[0].ducts.clear
  elsif ['base-hvac-boiler-gas-central-ac-1-speed.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].distribution_system_type = HPXML::HVACDistributionTypeHydronic
    hpxml.hvac_distributions[0].duct_leakage_measurements.clear
    hpxml.hvac_distributions[0].ducts.clear
    hpxml.hvac_distributions.add(id: 'HVACDistribution2',
                                 distribution_system_type: HPXML::HVACDistributionTypeAir,
                                 conditioned_floor_area_served: 2700)
    hpxml.hvac_distributions[-1].duct_leakage_measurements.add(duct_type: HPXML::DuctTypeSupply,
                                                               duct_leakage_units: HPXML::UnitsCFM25,
                                                               duct_leakage_value: 75,
                                                               duct_leakage_total_or_to_outside: HPXML::DuctLeakageToOutside)
    hpxml.hvac_distributions[-1].duct_leakage_measurements.add(duct_type: HPXML::DuctTypeReturn,
                                                               duct_leakage_units: HPXML::UnitsCFM25,
                                                               duct_leakage_value: 25,
                                                               duct_leakage_total_or_to_outside: HPXML::DuctLeakageToOutside)
    hpxml.hvac_distributions[-1].ducts.add(duct_type: HPXML::DuctTypeSupply,
                                           duct_insulation_r_value: 4,
                                           duct_location: HPXML::LocationAtticUnvented,
                                           duct_surface_area: 150)
    hpxml.hvac_distributions[-1].ducts.add(duct_type: HPXML::DuctTypeReturn,
                                           duct_insulation_r_value: 0,
                                           duct_location: HPXML::LocationAtticUnvented,
                                           duct_surface_area: 50)
  elsif ['base-hvac-none.xml',
         'base-hvac-elec-resistance-only.xml',
         'base-hvac-evap-cooler-only.xml',
         'base-hvac-fireplace-wood-only.xml',
         'base-hvac-floor-furnace-propane-only.xml',
         'base-hvac-ideal-air.xml',
         'base-hvac-mini-split-heat-pump-ductless.xml',
         'base-hvac-room-ac-only.xml',
         'base-hvac-stove-oil-only.xml',
         'base-hvac-stove-wood-pellets-only.xml',
         'base-hvac-wall-furnace-elec-only.xml'].include? hpxml_file
    hpxml.hvac_distributions.clear
  elsif ['base-hvac-multiple.xml'].include? hpxml_file
    hpxml.hvac_distributions.clear
    hpxml.hvac_distributions.add(id: 'HVACDistribution',
                                 distribution_system_type: HPXML::HVACDistributionTypeAir,
                                 conditioned_floor_area_served: (2700 / 4))
    hpxml.hvac_distributions[-1].duct_leakage_measurements.add(duct_type: HPXML::DuctTypeSupply,
                                                               duct_leakage_units: HPXML::UnitsCFM25,
                                                               duct_leakage_value: 75,
                                                               duct_leakage_total_or_to_outside: HPXML::DuctLeakageToOutside)
    hpxml.hvac_distributions[-1].duct_leakage_measurements.add(duct_type: HPXML::DuctTypeReturn,
                                                               duct_leakage_units: HPXML::UnitsCFM25,
                                                               duct_leakage_value: 25,
                                                               duct_leakage_total_or_to_outside: HPXML::DuctLeakageToOutside)
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeSupply,
                                          duct_insulation_r_value: 8,
                                          duct_location: HPXML::LocationAtticUnvented,
                                          duct_surface_area: 75)
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeSupply,
                                          duct_insulation_r_value: 8,
                                          duct_location: HPXML::LocationOutside,
                                          duct_surface_area: 75)
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeReturn,
                                          duct_insulation_r_value: 4,
                                          duct_location: HPXML::LocationAtticUnvented,
                                          duct_surface_area: 25)
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeReturn,
                                          duct_insulation_r_value: 4,
                                          duct_location: HPXML::LocationOutside,
                                          duct_surface_area: 25)
    hpxml.hvac_distributions << hpxml.hvac_distributions[0].dup
    hpxml.hvac_distributions[-1].id = 'HVACDistribution2'
    hpxml.hvac_distributions.add(id: 'HVACDistribution3',
                                 distribution_system_type: HPXML::HVACDistributionTypeHydronic)
    hpxml.hvac_distributions.add(id: 'HVACDistribution4',
                                 distribution_system_type: HPXML::HVACDistributionTypeHydronic)
    hpxml.hvac_distributions << hpxml.hvac_distributions[0].dup
    hpxml.hvac_distributions[-1].id = 'HVACDistribution5'
    hpxml.hvac_distributions << hpxml.hvac_distributions[0].dup
    hpxml.hvac_distributions[-1].id = 'HVACDistribution6'
  elsif ['base-hvac-multiple2.xml'].include? hpxml_file
    hpxml.hvac_distributions.clear
    hpxml.hvac_distributions.add(id: 'HVACDistribution',
                                 distribution_system_type: HPXML::HVACDistributionTypeAir,
                                 conditioned_floor_area_served: (2700 / 4))
    hpxml.hvac_distributions[-1].duct_leakage_measurements.add(duct_type: HPXML::DuctTypeSupply,
                                                               duct_leakage_units: HPXML::UnitsCFM25,
                                                               duct_leakage_value: 75,
                                                               duct_leakage_total_or_to_outside: HPXML::DuctLeakageToOutside)
    hpxml.hvac_distributions[-1].duct_leakage_measurements.add(duct_type: HPXML::DuctTypeReturn,
                                                               duct_leakage_units: HPXML::UnitsCFM25,
                                                               duct_leakage_value: 25,
                                                               duct_leakage_total_or_to_outside: HPXML::DuctLeakageToOutside)
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeSupply,
                                          duct_insulation_r_value: 8,
                                          duct_location: HPXML::LocationAtticUnvented,
                                          duct_surface_area: 75)
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeSupply,
                                          duct_insulation_r_value: 8,
                                          duct_location: HPXML::LocationOutside,
                                          duct_surface_area: 75)
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeReturn,
                                          duct_insulation_r_value: 4,
                                          duct_location: HPXML::LocationAtticUnvented,
                                          duct_surface_area: 25)
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeReturn,
                                          duct_insulation_r_value: 4,
                                          duct_location: HPXML::LocationOutside,
                                          duct_surface_area: 25)
    hpxml.hvac_distributions << hpxml.hvac_distributions[0].dup
    hpxml.hvac_distributions[-1].id = 'HVACDistribution2'
    hpxml.hvac_distributions.add(id: 'HVACDistribution3',
                                 distribution_system_type: HPXML::HVACDistributionTypeHydronic)
    hpxml.hvac_distributions << hpxml.hvac_distributions[0].dup
    hpxml.hvac_distributions[-1].id = 'HVACDistribution4'
    hpxml.hvac_distributions << hpxml.hvac_distributions[0].dup
    hpxml.hvac_distributions[-1].id = 'HVACDistribution5'
  elsif ['base-hvac-dse.xml',
         'base-dhw-indirect-dse.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].distribution_system_type = HPXML::HVACDistributionTypeDSE
    hpxml.hvac_distributions[0].annual_heating_dse = 0.8
    hpxml.hvac_distributions[0].annual_cooling_dse = 0.7
  elsif ['base-hvac-furnace-x3-dse.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].distribution_system_type = HPXML::HVACDistributionTypeDSE
    hpxml.hvac_distributions[0].annual_heating_dse = 0.8
    hpxml.hvac_distributions[0].annual_cooling_dse = 0.7
    hpxml.hvac_distributions << hpxml.hvac_distributions[0].dup
    hpxml.hvac_distributions[1].id = 'HVACDistribution2'
    hpxml.hvac_distributions[1].annual_cooling_dse = nil
    hpxml.hvac_distributions << hpxml.hvac_distributions[0].dup
    hpxml.hvac_distributions[2].id = 'HVACDistribution3'
    hpxml.hvac_distributions[2].annual_cooling_dse = nil
  elsif ['base-hvac-mini-split-heat-pump-ducted.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].duct_leakage_measurements[0].duct_leakage_value = 15
    hpxml.hvac_distributions[0].duct_leakage_measurements[1].duct_leakage_value = 5
    hpxml.hvac_distributions[0].ducts[0].duct_insulation_r_value = 0
    hpxml.hvac_distributions[0].ducts[0].duct_surface_area = 30
    hpxml.hvac_distributions[0].ducts[1].duct_surface_area = 10
  elsif ['base-hvac-evap-cooler-only-ducted.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].duct_leakage_measurements.pop
    hpxml.hvac_distributions[0].ducts.pop
  elsif ['base-hvac-ducts-leakage-percent.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].duct_leakage_measurements.clear
    hpxml.hvac_distributions[0].duct_leakage_measurements.add(duct_type: HPXML::DuctTypeSupply,
                                                              duct_leakage_units: HPXML::UnitsPercent,
                                                              duct_leakage_value: 0.1,
                                                              duct_leakage_total_or_to_outside: HPXML::DuctLeakageToOutside)
    hpxml.hvac_distributions[0].duct_leakage_measurements.add(duct_type: HPXML::DuctTypeReturn,
                                                              duct_leakage_units: HPXML::UnitsPercent,
                                                              duct_leakage_value: 0.05,
                                                              duct_leakage_total_or_to_outside: HPXML::DuctLeakageToOutside)
  elsif ['base-hvac-undersized.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].duct_leakage_measurements[0].duct_leakage_value /= 10.0
    hpxml.hvac_distributions[0].duct_leakage_measurements[1].duct_leakage_value /= 10.0
  elsif ['base-foundation-ambient.xml',
         'base-foundation-multiple.xml',
         'base-foundation-slab.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].conditioned_floor_area_served = 1350
    if hpxml_file == 'base-foundation-slab.xml'
      hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationUnderSlab
      hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationUnderSlab
    end
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].conditioned_floor_area_served = 1350
    hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationBasementUnconditioned
    hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationBasementUnconditioned
  elsif ['base-foundation-unvented-crawlspace.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].conditioned_floor_area_served = 1350
    hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationCrawlspaceUnvented
    hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationCrawlspaceUnvented
  elsif ['base-foundation-vented-crawlspace.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].conditioned_floor_area_served = 1350
    hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationCrawlspaceVented
    hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationCrawlspaceVented
  elsif ['base-atticroof-flat.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].duct_leakage_measurements[0].duct_leakage_value = 0.0
    hpxml.hvac_distributions[0].duct_leakage_measurements[1].duct_leakage_value = 0.0
    hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationBasementConditioned
    hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationBasementConditioned
  elsif ['base-atticroof-vented.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationAtticVented
    hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationAtticVented
  elsif ['base-enclosure-garage.xml',
         'invalid_files/duct-location.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationGarage
    hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationGarage
  elsif ['invalid_files/duct-location-unconditioned-space.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].ducts[0].duct_location = 'unconditioned space'
    hpxml.hvac_distributions[0].ducts[1].duct_location = 'unconditioned space'
  elsif ['base-enclosure-attached-multifamily.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationOtherHousingUnit
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeSupply,
                                          duct_insulation_r_value: 4,
                                          duct_location: HPXML::LocationRoofDeck,
                                          duct_surface_area: 150)
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeReturn,
                                          duct_insulation_r_value: 0,
                                          duct_location: HPXML::LocationRoofDeck,
                                          duct_surface_area: 50)
  elsif ['base-enclosure-2stories.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].conditioned_floor_area_served = 4050
  elsif ['base-enclosure-2stories-garage.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].conditioned_floor_area_served -= 400 * 2
    hpxml.hvac_distributions[0].ducts << hpxml.hvac_distributions[0].ducts[0].dup
    hpxml.hvac_distributions[0].ducts << hpxml.hvac_distributions[0].ducts[1].dup
    hpxml.hvac_distributions[0].ducts[0].duct_surface_area *= 0.75
    hpxml.hvac_distributions[0].ducts[1].duct_surface_area *= 0.75
    hpxml.hvac_distributions[0].ducts[2].duct_location = HPXML::LocationExteriorWall
    hpxml.hvac_distributions[0].ducts[2].duct_surface_area *= 0.25
    hpxml.hvac_distributions[0].ducts[3].duct_location = HPXML::LocationLivingSpace
    hpxml.hvac_distributions[0].ducts[3].duct_surface_area *= 0.25
  elsif ['base-atticroof-conditioned.xml',
         'base-atticroof-cathedral.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationLivingSpace
    hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationLivingSpace
    hpxml.hvac_distributions[0].duct_leakage_measurements[0].duct_leakage_value = 0.0
    hpxml.hvac_distributions[0].duct_leakage_measurements[1].duct_leakage_value = 0.0
    if hpxml_file == 'base-atticroof-conditioned.xml'
      # Test leakage to outside when all ducts in conditioned space
      # (e.g., ducts may be in floor cavities which have leaky rims)
      hpxml.hvac_distributions[0].conditioned_floor_area_served = 3600
      hpxml.hvac_distributions[0].duct_leakage_measurements[0].duct_leakage_value = 1.5
      hpxml.hvac_distributions[0].duct_leakage_measurements[1].duct_leakage_value = 1.5
    end
  elsif ['base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml',
         'base-enclosure-other-housing-unit.xml'].include? hpxml_file
    if ['base-enclosure-other-heated-space.xml'].include? hpxml_file
      hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationOtherHeatedSpace
      hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationOtherHeatedSpace
    elsif ['base-enclosure-other-non-freezing-space.xml'].include? hpxml_file
      hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationOtherNonFreezingSpace
      hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationOtherNonFreezingSpace
    elsif ['base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
      hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationOtherMultifamilyBufferSpace
      hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationOtherMultifamilyBufferSpace
    elsif ['base-enclosure-other-housing-unit.xml'].include? hpxml_file
      hpxml.hvac_distributions[0].ducts[0].duct_location = HPXML::LocationOtherHousingUnit
      hpxml.hvac_distributions[0].ducts[1].duct_location = HPXML::LocationOtherHousingUnit
    end
  elsif ['invalid_files/hvac-invalid-distribution-system-type.xml'].include? hpxml_file
    hpxml.hvac_distributions.add(id: 'HVACDistribution2',
                                 distribution_system_type: HPXML::HVACDistributionTypeHydronic)
  elsif ['invalid_files/hvac-distribution-return-duct-leakage-missing.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].ducts.add(duct_type: HPXML::DuctTypeReturn,
                                          duct_insulation_r_value: 0,
                                          duct_location: HPXML::LocationAtticUnvented,
                                          duct_surface_area: 50)
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.hvac_distributions.each do |hvac_distribution|
      next unless hvac_distribution.distribution_system_type == HPXML::HVACDistributionTypeAir

      hvac_distribution.ducts.each do |duct|
        duct.duct_surface_area = nil
        duct.duct_location = nil
      end
    end
  elsif ['invalid_files/missing-duct-location-and-surface-area.xml'].include? hpxml_file
    hpxml.hvac_distributions.each do |hvac_distribution|
      next unless hvac_distribution.distribution_system_type == HPXML::HVACDistributionTypeAir

      hvac_distribution.ducts[1].duct_surface_area = nil
      hvac_distribution.ducts[1].duct_location = nil
    end
  elsif ['invalid_files/missing-duct-location.xml'].include? hpxml_file
    hpxml.hvac_distributions.each do |hvac_distribution|
      next unless hvac_distribution.distribution_system_type == HPXML::HVACDistributionTypeAir

      hvac_distribution.ducts[1].duct_location = nil
    end
  elsif ['invalid_files/invalid-distribution-cfa-served.xml'].include? hpxml_file
    hpxml.hvac_distributions[0].conditioned_floor_area_served = 2700.1
  end
end

def set_hpxml_ventilation_fans(hpxml_file, hpxml)
  if ['base-mechvent-balanced.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'MechanicalVentilation',
                               fan_type: HPXML::MechVentTypeBalanced,
                               tested_flow_rate: 110,
                               hours_in_operation: 24,
                               fan_power: 60,
                               used_for_whole_building_ventilation: true)
  elsif ['invalid_files/unattached-cfis.xml',
         'invalid_files/cfis-with-hydronic-distribution.xml',
         'base-mechvent-cfis.xml',
         'base-mechvent-cfis-dse.xml',
         'base-mechvent-cfis-evap-cooler-only-ducted.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'MechanicalVentilation',
                               fan_type: HPXML::MechVentTypeCFIS,
                               tested_flow_rate: 330,
                               hours_in_operation: 8,
                               fan_power: 300,
                               used_for_whole_building_ventilation: true,
                               distribution_system_idref: 'HVACDistribution')
    if ['invalid_files/unattached-cfis.xml'].include? hpxml_file
      hpxml.ventilation_fans[0].distribution_system_idref = 'foobar'
    end
  elsif ['base-mechvent-erv.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'MechanicalVentilation',
                               fan_type: HPXML::MechVentTypeERV,
                               tested_flow_rate: 110,
                               hours_in_operation: 24,
                               total_recovery_efficiency: 0.48,
                               sensible_recovery_efficiency: 0.72,
                               fan_power: 60,
                               used_for_whole_building_ventilation: true)
  elsif ['base-mechvent-erv-atre-asre.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'MechanicalVentilation',
                               fan_type: HPXML::MechVentTypeERV,
                               tested_flow_rate: 110,
                               hours_in_operation: 24,
                               total_recovery_efficiency_adjusted: 0.526,
                               sensible_recovery_efficiency_adjusted: 0.79,
                               fan_power: 60,
                               used_for_whole_building_ventilation: true)
  elsif ['base-mechvent-exhaust.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'MechanicalVentilation',
                               fan_type: HPXML::MechVentTypeExhaust,
                               tested_flow_rate: 110,
                               hours_in_operation: 24,
                               fan_power: 30,
                               used_for_whole_building_ventilation: true)
  elsif ['base-mechvent-exhaust-rated-flow-rate.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'MechanicalVentilation',
                               fan_type: HPXML::MechVentTypeExhaust,
                               rated_flow_rate: 110,
                               hours_in_operation: 24,
                               fan_power: 30,
                               used_for_whole_building_ventilation: true)
  elsif ['base-mechvent-hrv.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'MechanicalVentilation',
                               fan_type: HPXML::MechVentTypeHRV,
                               tested_flow_rate: 110,
                               hours_in_operation: 24,
                               sensible_recovery_efficiency: 0.72,
                               fan_power: 60,
                               used_for_whole_building_ventilation: true)
  elsif ['base-mechvent-hrv-asre.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'MechanicalVentilation',
                               fan_type: HPXML::MechVentTypeHRV,
                               tested_flow_rate: 110,
                               hours_in_operation: 24,
                               sensible_recovery_efficiency_adjusted: 0.790,
                               fan_power: 60,
                               used_for_whole_building_ventilation: true)
  elsif ['base-mechvent-supply.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'MechanicalVentilation',
                               fan_type: HPXML::MechVentTypeSupply,
                               tested_flow_rate: 110,
                               hours_in_operation: 24,
                               fan_power: 30,
                               used_for_whole_building_ventilation: true)
  elsif ['base-misc-whole-house-fan.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'WholeHouseFan',
                               rated_flow_rate: 4500,
                               fan_power: 300,
                               used_for_seasonal_cooling_load_reduction: true)
  elsif ['base-mechvent-bath-kitchen-fans.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'KitchenRangeFan',
                               fan_location: HPXML::LocationKitchen,
                               rated_flow_rate: 100,
                               fan_power: 30,
                               hours_in_operation: 1.5,
                               start_hour: 18,
                               used_for_local_ventilation: true)
    hpxml.ventilation_fans.add(id: 'BathFans',
                               fan_location: HPXML::LocationBath,
                               quantity: 2,
                               rated_flow_rate: 50,
                               fan_power: 15,
                               hours_in_operation: 1.5,
                               start_hour: 7,
                               used_for_local_ventilation: true)
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.ventilation_fans.add(id: 'KitchenRangeFan',
                               fan_location: HPXML::LocationKitchen,
                               used_for_local_ventilation: true)
    hpxml.ventilation_fans.add(id: 'BathFans',
                               fan_location: HPXML::LocationBath,
                               used_for_local_ventilation: true)
  end
end

def set_hpxml_water_heating_systems(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.water_heating_systems.add(id: 'WaterHeater',
                                    fuel_type: HPXML::FuelTypeElectricity,
                                    water_heater_type: HPXML::WaterHeaterTypeStorage,
                                    location: HPXML::LocationLivingSpace,
                                    tank_volume: 40,
                                    fraction_dhw_load_served: 1,
                                    heating_capacity: 18767,
                                    energy_factor: 0.95,
                                    temperature: Waterheater.get_default_hot_water_temperature(Constants.ERIVersions[-1]))
  elsif ['base-dhw-multiple.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].fraction_dhw_load_served = 0.2
    hpxml.water_heating_systems.add(id: 'WaterHeater2',
                                    fuel_type: HPXML::FuelTypeNaturalGas,
                                    water_heater_type: HPXML::WaterHeaterTypeStorage,
                                    location: HPXML::LocationLivingSpace,
                                    tank_volume: 50,
                                    fraction_dhw_load_served: 0.2,
                                    heating_capacity: 40000,
                                    energy_factor: 0.59,
                                    recovery_efficiency: 0.76,
                                    temperature: Waterheater.get_default_hot_water_temperature(Constants.ERIVersions[-1]))
    hpxml.water_heating_systems.add(id: 'WaterHeater3',
                                    fuel_type: HPXML::FuelTypeElectricity,
                                    water_heater_type: HPXML::WaterHeaterTypeHeatPump,
                                    location: HPXML::LocationLivingSpace,
                                    tank_volume: 80,
                                    fraction_dhw_load_served: 0.2,
                                    energy_factor: 2.3,
                                    temperature: Waterheater.get_default_hot_water_temperature(Constants.ERIVersions[-1]))
    hpxml.water_heating_systems.add(id: 'WaterHeater4',
                                    fuel_type: HPXML::FuelTypeElectricity,
                                    water_heater_type: HPXML::WaterHeaterTypeTankless,
                                    location: HPXML::LocationLivingSpace,
                                    fraction_dhw_load_served: 0.2,
                                    energy_factor: 0.99,
                                    temperature: Waterheater.get_default_hot_water_temperature(Constants.ERIVersions[-1]))
    hpxml.water_heating_systems.add(id: 'WaterHeater5',
                                    fuel_type: HPXML::FuelTypeNaturalGas,
                                    water_heater_type: HPXML::WaterHeaterTypeTankless,
                                    location: HPXML::LocationLivingSpace,
                                    fraction_dhw_load_served: 0.1,
                                    energy_factor: 0.82,
                                    temperature: Waterheater.get_default_hot_water_temperature(Constants.ERIVersions[-1]))
    hpxml.water_heating_systems.add(id: 'WaterHeater6',
                                    water_heater_type: HPXML::WaterHeaterTypeCombiStorage,
                                    location: HPXML::LocationLivingSpace,
                                    tank_volume: 50,
                                    fraction_dhw_load_served: 0.1,
                                    related_hvac_idref: 'HeatingSystem',
                                    temperature: Waterheater.get_default_hot_water_temperature(Constants.ERIVersions[-1]))
  elsif ['invalid_files/dhw-frac-load-served.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].fraction_dhw_load_served += 0.15
  elsif ['base-dhw-tank-gas.xml',
         'base-dhw-tank-gas-outside.xml',
         'base-dhw-tank-oil.xml',
         'base-dhw-tank-wood.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].tank_volume = 50
    hpxml.water_heating_systems[0].heating_capacity = 40000
    hpxml.water_heating_systems[0].energy_factor = 0.59
    hpxml.water_heating_systems[0].recovery_efficiency = 0.76
    if hpxml_file == 'base-dhw-tank-gas-outside.xml'
      hpxml.water_heating_systems[0].location = HPXML::LocationOtherExterior
    end
    if hpxml_file == 'base-dhw-tank-oil.xml'
      hpxml.water_heating_systems[0].fuel_type = HPXML::FuelTypeOil
    elsif hpxml_file == 'base-dhw-tank-wood.xml'
      hpxml.water_heating_systems[0].fuel_type = HPXML::FuelTypeWood
    else
      hpxml.water_heating_systems[0].fuel_type = HPXML::FuelTypeNaturalGas
    end
  elsif ['base-dhw-tank-heat-pump.xml',
         'base-dhw-tank-heat-pump-outside.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].water_heater_type = HPXML::WaterHeaterTypeHeatPump
    hpxml.water_heating_systems[0].tank_volume = 80
    hpxml.water_heating_systems[0].heating_capacity = nil
    hpxml.water_heating_systems[0].energy_factor = 2.3
    if hpxml_file == 'base-dhw-tank-heat-pump-outside.xml'
      hpxml.water_heating_systems[0].location = HPXML::LocationOtherExterior
    end
  elsif ['base-dhw-tankless-electric.xml',
         'base-dhw-tankless-electric-outside.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].water_heater_type = HPXML::WaterHeaterTypeTankless
    hpxml.water_heating_systems[0].tank_volume = nil
    hpxml.water_heating_systems[0].heating_capacity = nil
    hpxml.water_heating_systems[0].energy_factor = 0.99
    if hpxml_file == 'base-dhw-tankless-electric-outside.xml'
      hpxml.water_heating_systems[0].location = HPXML::LocationOtherExterior
    end
  elsif ['base-dhw-tankless-gas.xml',
         'base-dhw-tankless-propane.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].water_heater_type = HPXML::WaterHeaterTypeTankless
    hpxml.water_heating_systems[0].tank_volume = nil
    hpxml.water_heating_systems[0].heating_capacity = nil
    hpxml.water_heating_systems[0].energy_factor = 0.82
    if hpxml_file == 'base-dhw-tankless-gas.xml'
      hpxml.water_heating_systems[0].fuel_type = HPXML::FuelTypeNaturalGas
    elsif hpxml_file == 'base-dhw-tankless-propane.xml'
      hpxml.water_heating_systems[0].fuel_type = HPXML::FuelTypePropane
    end
  elsif ['base-dhw-uef.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].energy_factor = nil
    hpxml.water_heating_systems[0].uniform_energy_factor = 0.93
  elsif ['base-dhw-desuperheater.xml',
         'base-dhw-desuperheater-2-speed.xml',
         'base-dhw-desuperheater-var-speed.xml',
         'base-dhw-desuperheater-hpwh.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].uses_desuperheater = true
    hpxml.water_heating_systems[0].related_hvac_idref = 'CoolingSystem'
  elsif ['base-dhw-desuperheater-tankless.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].water_heater_type = HPXML::WaterHeaterTypeTankless
    hpxml.water_heating_systems[0].tank_volume = nil
    hpxml.water_heating_systems[0].heating_capacity = nil
    hpxml.water_heating_systems[0].energy_factor = 0.99
    hpxml.water_heating_systems[0].uses_desuperheater = true
    hpxml.water_heating_systems[0].related_hvac_idref = 'CoolingSystem'
  elsif ['base-dhw-desuperheater-gshp.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].uses_desuperheater = true
    hpxml.water_heating_systems[0].related_hvac_idref = 'HeatPump'
  elsif ['base-dhw-jacket-electric.xml',
         'base-dhw-jacket-indirect.xml',
         'base-dhw-jacket-gas.xml',
         'base-dhw-jacket-hpwh.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].jacket_r_value = 10.0
  elsif ['base-dhw-indirect.xml',
         'base-dhw-indirect-outside.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].water_heater_type = HPXML::WaterHeaterTypeCombiStorage
    hpxml.water_heating_systems[0].tank_volume = 50
    hpxml.water_heating_systems[0].heating_capacity = nil
    hpxml.water_heating_systems[0].energy_factor = nil
    hpxml.water_heating_systems[0].fuel_type = nil
    hpxml.water_heating_systems[0].related_hvac_idref = 'HeatingSystem'
    if hpxml_file == 'base-dhw-indirect-outside.xml'
      hpxml.water_heating_systems[0].location = HPXML::LocationOtherExterior
    end
  elsif ['base-dhw-indirect-standbyloss.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].standby_loss = 1.0
  elsif ['base-dhw-combi-tankless.xml',
         'base-dhw-combi-tankless-outside.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].water_heater_type = HPXML::WaterHeaterTypeCombiTankless
    hpxml.water_heating_systems[0].tank_volume = nil
    if hpxml_file == 'base-dhw-combi-tankless-outside.xml'
      hpxml.water_heating_systems[0].location = HPXML::LocationOtherExterior
    end
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].location = HPXML::LocationBasementUnconditioned
  elsif ['base-foundation-unvented-crawlspace.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].location = HPXML::LocationCrawlspaceUnvented
  elsif ['base-foundation-vented-crawlspace.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].location = HPXML::LocationCrawlspaceVented
  elsif ['base-foundation-slab.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].location = HPXML::LocationLivingSpace
  elsif ['base-atticroof-vented.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].location = HPXML::LocationAtticVented
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].location = HPXML::LocationBasementConditioned
  elsif ['invalid_files/water-heater-location.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].location = HPXML::LocationCrawlspaceVented
  elsif ['invalid_files/water-heater-location-other.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].location = 'unconditioned space'
  elsif ['invalid_files/invalid-relatedhvac-desuperheater.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].uses_desuperheater = true
    hpxml.water_heating_systems[0].related_hvac_idref = 'CoolingSystem_bad'
  elsif ['invalid_files/repeated-relatedhvac-desuperheater.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].fraction_dhw_load_served = 0.5
    hpxml.water_heating_systems[0].uses_desuperheater = true
    hpxml.water_heating_systems[0].related_hvac_idref = 'CoolingSystem'
    hpxml.water_heating_systems << hpxml.water_heating_systems[0].dup
    hpxml.water_heating_systems[1].id = 'WaterHeater2'
  elsif ['invalid_files/invalid-relatedhvac-dhw-indirect.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].related_hvac_idref = 'HeatingSystem_bad'
  elsif ['invalid_files/repeated-relatedhvac-dhw-indirect.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].fraction_dhw_load_served = 0.5
    hpxml.water_heating_systems << hpxml.water_heating_systems[0].dup
    hpxml.water_heating_systems[1].id = 'WaterHeater2'
  elsif ['base-enclosure-garage.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].location = HPXML::LocationGarage
  elsif ['base-enclosure-attached-multifamily.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].location = HPXML::LocationOtherMultifamilyBufferSpace
  elsif ['base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    if ['base-enclosure-other-housing-unit.xml'].include? hpxml_file
      hpxml.water_heating_systems[0].location = HPXML::LocationOtherHousingUnit
    elsif ['base-enclosure-other-heated-space.xml'].include? hpxml_file
      hpxml.water_heating_systems[0].location = HPXML::LocationOtherHeatedSpace
    elsif ['base-enclosure-other-non-freezing-space.xml'].include? hpxml_file
      hpxml.water_heating_systems[0].location = HPXML::LocationOtherNonFreezingSpace
    elsif ['base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
      hpxml.water_heating_systems[0].location = HPXML::LocationOtherMultifamilyBufferSpace
    end
  elsif ['base-dhw-none.xml'].include? hpxml_file
    hpxml.water_heating_systems.clear
  elsif ['base-misc-defaults.xml',
         'base-misc-defaults2.xml'].include? hpxml_file
    hpxml.water_heating_systems[0].temperature = nil
    hpxml.water_heating_systems[0].location = nil
    hpxml.water_heating_systems[0].heating_capacity = nil
    hpxml.water_heating_systems[0].tank_volume = nil
    hpxml.water_heating_systems[0].recovery_efficiency = nil
    if hpxml_file == 'base-misc-defaults2.xml'
      hpxml.water_heating_systems[0].energy_factor = nil
      hpxml.water_heating_systems[0].uniform_energy_factor = 0.93
    end
  end
end

def set_hpxml_hot_water_distribution(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.hot_water_distributions.add(id: 'HotWaterDstribution',
                                      system_type: HPXML::DHWDistTypeStandard,
                                      standard_piping_length: 50, # Chosen to test a negative EC_adj
                                      pipe_r_value: 0.0)
  elsif ['base-dhw-dwhr.xml'].include? hpxml_file
    hpxml.hot_water_distributions[0].dwhr_facilities_connected = HPXML::DWHRFacilitiesConnectedAll
    hpxml.hot_water_distributions[0].dwhr_equal_flow = true
    hpxml.hot_water_distributions[0].dwhr_efficiency = 0.55
  elsif ['base-dhw-recirc-demand.xml'].include? hpxml_file
    hpxml.hot_water_distributions[0].system_type = HPXML::DHWDistTypeRecirc
    hpxml.hot_water_distributions[0].recirculation_control_type = HPXML::DHWRecirControlTypeSensor
    hpxml.hot_water_distributions[0].recirculation_piping_length = 50
    hpxml.hot_water_distributions[0].recirculation_branch_piping_length = 50
    hpxml.hot_water_distributions[0].recirculation_pump_power = 50
    hpxml.hot_water_distributions[0].pipe_r_value = 3
  elsif ['base-dhw-recirc-manual.xml'].include? hpxml_file
    hpxml.hot_water_distributions[0].system_type = HPXML::DHWDistTypeRecirc
    hpxml.hot_water_distributions[0].recirculation_control_type = HPXML::DHWRecirControlTypeManual
    hpxml.hot_water_distributions[0].recirculation_piping_length = 50
    hpxml.hot_water_distributions[0].recirculation_branch_piping_length = 50
    hpxml.hot_water_distributions[0].recirculation_pump_power = 50
    hpxml.hot_water_distributions[0].pipe_r_value = 3
  elsif ['base-dhw-recirc-nocontrol.xml'].include? hpxml_file
    hpxml.hot_water_distributions[0].system_type = HPXML::DHWDistTypeRecirc
    hpxml.hot_water_distributions[0].recirculation_control_type = HPXML::DHWRecirControlTypeNone
    hpxml.hot_water_distributions[0].recirculation_piping_length = 50
    hpxml.hot_water_distributions[0].recirculation_branch_piping_length = 50
    hpxml.hot_water_distributions[0].recirculation_pump_power = 50
  elsif ['base-dhw-recirc-temperature.xml'].include? hpxml_file
    hpxml.hot_water_distributions[0].system_type = HPXML::DHWDistTypeRecirc
    hpxml.hot_water_distributions[0].recirculation_control_type = HPXML::DHWRecirControlTypeTemperature
    hpxml.hot_water_distributions[0].recirculation_piping_length = 50
    hpxml.hot_water_distributions[0].recirculation_branch_piping_length = 50
    hpxml.hot_water_distributions[0].recirculation_pump_power = 50
  elsif ['base-dhw-recirc-timer.xml'].include? hpxml_file
    hpxml.hot_water_distributions[0].system_type = HPXML::DHWDistTypeRecirc
    hpxml.hot_water_distributions[0].recirculation_control_type = HPXML::DHWRecirControlTypeTimer
    hpxml.hot_water_distributions[0].recirculation_piping_length = 50
    hpxml.hot_water_distributions[0].recirculation_branch_piping_length = 50
    hpxml.hot_water_distributions[0].recirculation_pump_power = 50
  elsif ['base-dhw-none.xml'].include? hpxml_file
    hpxml.hot_water_distributions.clear
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.hot_water_distributions[0].standard_piping_length = nil
  elsif ['base-misc-defaults2.xml'].include? hpxml_file
    hpxml.hot_water_distributions[0].recirculation_piping_length = nil
    hpxml.hot_water_distributions[0].recirculation_branch_piping_length = nil
    hpxml.hot_water_distributions[0].recirculation_pump_power = nil
  end
end

def set_hpxml_water_fixtures(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.water_fixtures.add(id: 'WaterFixture',
                             water_fixture_type: HPXML::WaterFixtureTypeShowerhead,
                             low_flow: true)
    hpxml.water_fixtures.add(id: 'WaterFixture2',
                             water_fixture_type: HPXML::WaterFixtureTypeFaucet,
                             low_flow: false)
  elsif ['base-dhw-low-flow-fixtures.xml'].include? hpxml_file
    hpxml.water_fixtures[1].low_flow = true
  elsif ['base-dhw-none.xml'].include? hpxml_file
    hpxml.water_fixtures.clear
  elsif ['base-misc-usage-multiplier.xml'].include? hpxml_file
    hpxml.water_heating.water_fixtures_usage_multiplier = 0.9
  end
end

def set_hpxml_solar_thermal_system(hpxml_file, hpxml)
  if ['base-dhw-solar-fraction.xml',
      'base-dhw-indirect-with-solar-fraction.xml',
      'base-dhw-tank-heat-pump-with-solar-fraction.xml',
      'base-dhw-tankless-gas-with-solar-fraction.xml'].include? hpxml_file
    hpxml.solar_thermal_systems.add(id: 'SolarThermalSystem',
                                    system_type: 'hot water',
                                    water_heating_system_idref: 'WaterHeater',
                                    solar_fraction: 0.65)
  elsif ['base-dhw-multiple.xml'].include? hpxml_file
    hpxml.solar_thermal_systems.add(id: 'SolarThermalSystem',
                                    system_type: 'hot water',
                                    water_heating_system_idref: nil, # Apply to all water heaters
                                    solar_fraction: 0.65)
  elsif ['base-dhw-solar-direct-flat-plate.xml',
         'base-dhw-solar-indirect-flat-plate.xml',
         'base-dhw-solar-thermosyphon-flat-plate.xml',
         'base-dhw-tank-heat-pump-with-solar.xml',
         'base-dhw-tankless-gas-with-solar.xml',
         'base-misc-defaults.xml',
         'invalid_files/solar-thermal-system-with-combi-tankless.xml',
         'invalid_files/solar-thermal-system-with-desuperheater.xml',
         'invalid_files/solar-thermal-system-with-dhw-indirect.xml'].include? hpxml_file
    hpxml.solar_thermal_systems.add(id: 'SolarThermalSystem',
                                    system_type: 'hot water',
                                    collector_area: 40,
                                    collector_type: HPXML::SolarThermalTypeSingleGlazing,
                                    collector_azimuth: 180,
                                    collector_tilt: 20,
                                    collector_frta: 0.77,
                                    collector_frul: 0.793,
                                    storage_volume: 60,
                                    water_heating_system_idref: 'WaterHeater')
    if hpxml_file == 'base-dhw-solar-direct-flat-plate.xml'
      hpxml.solar_thermal_systems[0].collector_loop_type = HPXML::SolarThermalLoopTypeDirect
    elsif hpxml_file == 'base-dhw-solar-thermosyphon-flat-plate.xml'
      hpxml.solar_thermal_systems[0].collector_loop_type = HPXML::SolarThermalLoopTypeThermosyphon
    elsif hpxml_file == 'base-misc-defaults.xml'
      hpxml.solar_thermal_systems[0].collector_loop_type = HPXML::SolarThermalLoopTypeDirect
      hpxml.solar_thermal_systems[0].storage_volume = nil
    else
      hpxml.solar_thermal_systems[0].collector_loop_type = HPXML::SolarThermalLoopTypeIndirect
    end
  elsif ['base-dhw-solar-direct-evacuated-tube.xml'].include? hpxml_file
    hpxml.solar_thermal_systems.add(id: 'SolarThermalSystem',
                                    system_type: 'hot water',
                                    collector_area: 40,
                                    collector_type: HPXML::SolarThermalTypeEvacuatedTube,
                                    collector_azimuth: 180,
                                    collector_tilt: 20,
                                    collector_frta: 0.50,
                                    collector_frul: 0.2799,
                                    storage_volume: 60,
                                    water_heating_system_idref: 'WaterHeater')
    if hpxml_file == 'base-dhw-solar-direct-evacuated-tube.xml'
      hpxml.solar_thermal_systems[0].collector_loop_type = HPXML::SolarThermalLoopTypeDirect
    else
      hpxml.solar_thermal_systems[0].collector_loop_type = HPXML::SolarThermalLoopTypeIndirect
    end
  elsif ['base-dhw-solar-direct-ics.xml'].include? hpxml_file
    hpxml.solar_thermal_systems.add(id: 'SolarThermalSystem',
                                    system_type: 'hot water',
                                    collector_area: 40,
                                    collector_loop_type: HPXML::SolarThermalLoopTypeDirect,
                                    collector_type: HPXML::SolarThermalTypeICS,
                                    collector_azimuth: 180,
                                    collector_tilt: 20,
                                    collector_frta: 0.77,
                                    collector_frul: 0.793,
                                    storage_volume: 60,
                                    water_heating_system_idref: 'WaterHeater')
  elsif ['invalid_files/unattached-solar-thermal-system.xml'].include? hpxml_file
    hpxml.solar_thermal_systems[0].water_heating_system_idref = 'foobar'
  end
end

def set_hpxml_pv_systems(hpxml_file, hpxml)
  if ['base-pv.xml'].include? hpxml_file
    hpxml.pv_systems.add(id: 'PVSystem',
                         module_type: HPXML::PVModuleTypeStandard,
                         location: HPXML::LocationRoof,
                         tracking: HPXML::PVTrackingTypeFixed,
                         array_azimuth: 180,
                         array_tilt: 20,
                         max_power_output: 4000,
                         inverter_efficiency: 0.96,
                         system_losses_fraction: 0.14)
    hpxml.pv_systems.add(id: 'PVSystem2',
                         module_type: HPXML::PVModuleTypePremium,
                         location: HPXML::LocationRoof,
                         tracking: HPXML::PVTrackingTypeFixed,
                         array_azimuth: 90,
                         array_tilt: 20,
                         max_power_output: 1500,
                         inverter_efficiency: 0.96,
                         system_losses_fraction: 0.14)
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.pv_systems.add(id: 'PVSystem',
                         module_type: HPXML::PVModuleTypeStandard,
                         location: HPXML::LocationRoof,
                         tracking: HPXML::PVTrackingTypeFixed,
                         array_azimuth: 180,
                         array_tilt: 20,
                         max_power_output: 4000,
                         inverter_efficiency: nil,
                         system_losses_fraction: nil,
                         year_modules_manufactured: 2015)
  end
end

def set_hpxml_clothes_washer(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.clothes_washers.add(id: 'ClothesWasher',
                              location: HPXML::LocationLivingSpace,
                              integrated_modified_energy_factor: 1.21,
                              rated_annual_kwh: 380,
                              label_electric_rate: 0.12,
                              label_gas_rate: 1.09,
                              label_annual_gas_cost: 27,
                              capacity: 3.2,
                              label_usage: 6)
  elsif ['base-appliances-none.xml'].include? hpxml_file
    hpxml.clothes_washers.clear
  elsif ['base-enclosure-attached-multifamily.xml',
         'base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.clothes_washers[0].location = HPXML::LocationOther
  elsif ['base-appliances-modified.xml'].include? hpxml_file
    imef = hpxml.clothes_washers[0].integrated_modified_energy_factor
    hpxml.clothes_washers[0].integrated_modified_energy_factor = nil
    hpxml.clothes_washers[0].modified_energy_factor = HotWaterAndAppliances.calc_clothes_washer_mef_from_imef(imef).round(2)
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    hpxml.clothes_washers[0].location = HPXML::LocationBasementUnconditioned
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.clothes_washers[0].location = HPXML::LocationBasementConditioned
  elsif ['base-enclosure-garage.xml',
         'invalid_files/clothes-washer-location.xml'].include? hpxml_file
    hpxml.clothes_washers[0].location = HPXML::LocationGarage
  elsif ['invalid_files/appliances-location-unconditioned-space.xml'].include? hpxml_file
    hpxml.clothes_washers[0].location = 'unconditioned space'
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.clothes_washers[0].location = nil
    hpxml.clothes_washers[0].modified_energy_factor = nil
    hpxml.clothes_washers[0].integrated_modified_energy_factor = nil
    hpxml.clothes_washers[0].rated_annual_kwh = nil
    hpxml.clothes_washers[0].label_electric_rate = nil
    hpxml.clothes_washers[0].label_gas_rate = nil
    hpxml.clothes_washers[0].label_annual_gas_cost = nil
    hpxml.clothes_washers[0].capacity = nil
    hpxml.clothes_washers[0].label_usage = nil
  elsif ['base-misc-usage-multiplier.xml'].include? hpxml_file
    hpxml.clothes_washers[0].usage_multiplier = 0.9
  end
end

def set_hpxml_clothes_dryer(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.clothes_dryers.add(id: 'ClothesDryer',
                             location: HPXML::LocationLivingSpace,
                             fuel_type: HPXML::FuelTypeElectricity,
                             combined_energy_factor: 3.73,
                             control_type: HPXML::ClothesDryerControlTypeTimer)
  elsif ['base-appliances-none.xml'].include? hpxml_file
    hpxml.clothes_dryers.clear
  elsif ['base-enclosure-attached-multifamily.xml',
         'base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.clothes_dryers[0].location = HPXML::LocationOther
  elsif ['base-appliances-modified.xml'].include? hpxml_file
    cef = hpxml.clothes_dryers[-1].combined_energy_factor
    hpxml.clothes_dryers.clear
    hpxml.clothes_dryers.add(id: 'ClothesDryer',
                             location: HPXML::LocationLivingSpace,
                             fuel_type: HPXML::FuelTypeElectricity,
                             energy_factor: HotWaterAndAppliances.calc_clothes_dryer_ef_from_cef(cef).round(2),
                             control_type: HPXML::ClothesDryerControlTypeMoisture)
  elsif ['base-appliances-gas.xml',
         'base-appliances-propane.xml',
         'base-appliances-oil.xml'].include? hpxml_file
    hpxml.clothes_dryers.clear
    hpxml.clothes_dryers.add(id: 'ClothesDryer',
                             location: HPXML::LocationLivingSpace,
                             combined_energy_factor: 3.30,
                             control_type: HPXML::ClothesDryerControlTypeMoisture)
    if hpxml_file == 'base-appliances-gas.xml'
      hpxml.clothes_dryers[0].fuel_type = HPXML::FuelTypeNaturalGas
    elsif hpxml_file == 'base-appliances-propane.xml'
      hpxml.clothes_dryers[0].fuel_type = HPXML::FuelTypePropane
    elsif hpxml_file == 'base-appliances-oil.xml'
      hpxml.clothes_dryers[0].fuel_type = HPXML::FuelTypeOil
    end
  elsif ['base-appliances-wood.xml'].include? hpxml_file
    hpxml.clothes_dryers.clear
    hpxml.clothes_dryers.add(id: 'ClothesDryer',
                             location: HPXML::LocationLivingSpace,
                             fuel_type: HPXML::FuelTypeWood,
                             combined_energy_factor: 3.30,
                             control_type: HPXML::ClothesDryerControlTypeMoisture)
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    hpxml.clothes_dryers[0].location = HPXML::LocationBasementUnconditioned
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.clothes_dryers[0].location = HPXML::LocationBasementConditioned
  elsif ['base-enclosure-garage.xml',
         'invalid_files/clothes-dryer-location.xml'].include? hpxml_file
    hpxml.clothes_dryers[0].location = HPXML::LocationGarage
  elsif ['invalid_files/appliances-location-unconditioned-space.xml'].include? hpxml_file
    hpxml.clothes_dryers[0].location = 'unconditioned space'
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.clothes_dryers[0].location = nil
    hpxml.clothes_dryers[0].energy_factor = nil
    hpxml.clothes_dryers[0].combined_energy_factor = nil
    hpxml.clothes_dryers[0].control_type = nil
  elsif ['base-misc-usage-multiplier.xml'].include? hpxml_file
    hpxml.clothes_dryers[0].usage_multiplier = 0.9
  end
end

def set_hpxml_dishwasher(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.dishwashers.add(id: 'Dishwasher',
                          location: HPXML::LocationLivingSpace,
                          rated_annual_kwh: 307,
                          label_electric_rate: 0.12,
                          label_gas_rate: 1.09,
                          label_annual_gas_cost: 22.32,
                          label_usage: 4,
                          place_setting_capacity: 12)
  elsif ['base-appliances-modified.xml'].include? hpxml_file
    rated_annual_kwh = hpxml.dishwashers[0].rated_annual_kwh
    hpxml.dishwashers[0].rated_annual_kwh = nil
    hpxml.dishwashers[0].energy_factor = HotWaterAndAppliances.calc_dishwasher_ef_from_annual_kwh(rated_annual_kwh).round(2)
  elsif ['base-enclosure-attached-multifamily.xml',
         'base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.dishwashers[0].location = HPXML::LocationOther
  elsif ['base-appliances-none.xml'].include? hpxml_file
    hpxml.dishwashers.clear
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    hpxml.dishwashers[0].location = HPXML::LocationBasementUnconditioned
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.dishwashers[0].location = HPXML::LocationBasementConditioned
  elsif ['base-enclosure-garage.xml',
         'invalid_files/dishwasher-location.xml'].include? hpxml_file
    hpxml.dishwashers[0].location = HPXML::LocationGarage
  elsif ['invalid_files/appliances-location-unconditioned-space.xml'].include? hpxml_file
    hpxml.dishwashers[0].location = 'unconditioned space'
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.dishwashers[0].rated_annual_kwh = nil
    hpxml.dishwashers[0].label_electric_rate = nil
    hpxml.dishwashers[0].label_gas_rate = nil
    hpxml.dishwashers[0].label_annual_gas_cost = nil
    hpxml.dishwashers[0].place_setting_capacity = nil
    hpxml.dishwashers[0].label_usage = nil
  elsif ['base-misc-usage-multiplier.xml'].include? hpxml_file
    hpxml.dishwashers[0].usage_multiplier = 0.9
  end
end

def set_hpxml_refrigerator(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.refrigerators.add(id: 'Refrigerator',
                            location: HPXML::LocationLivingSpace,
                            rated_annual_kwh: 650)
  elsif ['base-appliances-modified.xml'].include? hpxml_file
    hpxml.refrigerators[0].adjusted_annual_kwh = 600
  elsif ['base-appliances-none.xml'].include? hpxml_file
    hpxml.refrigerators.clear
  elsif ['base-enclosure-attached-multifamily.xml',
         'base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.refrigerators[0].location = HPXML::LocationOther
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    hpxml.refrigerators[0].location = HPXML::LocationBasementUnconditioned
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.refrigerators[0].location = HPXML::LocationBasementConditioned
  elsif ['base-enclosure-garage.xml',
         'invalid_files/refrigerator-location.xml'].include? hpxml_file
    hpxml.refrigerators[0].location = HPXML::LocationGarage
  elsif ['invalid_files/appliances-location-unconditioned-space.xml'].include? hpxml_file
    hpxml.refrigerators[0].location = 'unconditioned space'
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.refrigerators[0].location = nil
    hpxml.refrigerators[0].rated_annual_kwh = nil
    hpxml.refrigerators[0].adjusted_annual_kwh = nil
  elsif ['base-misc-usage-multiplier.xml'].include? hpxml_file
    hpxml.refrigerators[0].usage_multiplier = 0.9
  end
end

def set_hpxml_dehumidifier(hpxml_file, hpxml)
  if ['base-appliances-dehumidifier.xml'].include? hpxml_file
    hpxml.dehumidifiers.add(id: 'Dehumidifier',
                            capacity: 40,
                            energy_factor: 1.8,
                            rh_setpoint: 0.5,
                            fraction_served: 1.0)
  elsif ['base-appliances-dehumidifier-ief.xml'].include? hpxml_file
    hpxml.dehumidifiers[0].energy_factor = nil
    hpxml.dehumidifiers[0].integrated_energy_factor = 1.5
  elsif ['base-appliances-dehumidifier-50percent.xml'].include? hpxml_file
    hpxml.dehumidifiers[0].fraction_served = 0.5
  end
end

def set_hpxml_cooking_range(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.cooking_ranges.add(id: 'Range',
                             location: HPXML::LocationLivingSpace,
                             fuel_type: HPXML::FuelTypeElectricity,
                             is_induction: false)
  elsif ['base-appliances-none.xml'].include? hpxml_file
    hpxml.cooking_ranges.clear
  elsif ['base-enclosure-attached-multifamily.xml',
         'base-enclosure-other-housing-unit.xml',
         'base-enclosure-other-heated-space.xml',
         'base-enclosure-other-non-freezing-space.xml',
         'base-enclosure-other-multifamily-buffer-space.xml'].include? hpxml_file
    hpxml.cooking_ranges[0].location = HPXML::LocationOther
  elsif ['base-appliances-gas.xml'].include? hpxml_file
    hpxml.cooking_ranges[0].fuel_type = HPXML::FuelTypeNaturalGas
    hpxml.cooking_ranges[0].is_induction = false
  elsif ['base-appliances-propane.xml'].include? hpxml_file
    hpxml.cooking_ranges[0].fuel_type = HPXML::FuelTypePropane
    hpxml.cooking_ranges[0].is_induction = false
  elsif ['base-appliances-oil.xml'].include? hpxml_file
    hpxml.cooking_ranges[0].fuel_type = HPXML::FuelTypeOil
  elsif ['base-appliances-wood.xml'].include? hpxml_file
    hpxml.cooking_ranges[0].fuel_type = HPXML::FuelTypeWood
    hpxml.cooking_ranges[0].is_induction = false
  elsif ['base-foundation-unconditioned-basement.xml'].include? hpxml_file
    hpxml.cooking_ranges[0].location = HPXML::LocationBasementUnconditioned
  elsif ['base-atticroof-conditioned.xml'].include? hpxml_file
    hpxml.cooking_ranges[0].location = HPXML::LocationBasementConditioned
  elsif ['base-enclosure-garage.xml',
         'invalid_files/cooking-range-location.xml'].include? hpxml_file
    hpxml.cooking_ranges[0].location = HPXML::LocationGarage
  elsif ['invalid_files/appliances-location-unconditioned-space.xml'].include? hpxml_file
    hpxml.cooking_ranges[0].location = 'unconditioned space'
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.cooking_ranges[0].is_induction = nil
  elsif ['base-misc-usage-multiplier.xml'].include? hpxml_file
    hpxml.cooking_ranges[0].usage_multiplier = 0.9
  end
end

def set_hpxml_oven(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.ovens.add(id: 'Oven',
                    is_convection: false)
  elsif ['base-appliances-none.xml'].include? hpxml_file
    hpxml.ovens.clear
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.ovens[0].is_convection = nil
  end
end

def set_hpxml_lighting(hpxml_file, hpxml)
  if ['base.xml'].include? hpxml_file
    hpxml.lighting_groups.add(id: 'Lighting_CFL_Interior',
                              location: HPXML::LocationInterior,
                              fraction_of_units_in_location: 0.4,
                              lighting_type: HPXML::LightingTypeCFL)
    hpxml.lighting_groups.add(id: 'Lighting_CFL_Exterior',
                              location: HPXML::LocationExterior,
                              fraction_of_units_in_location: 0.4,
                              lighting_type: HPXML::LightingTypeCFL)
    hpxml.lighting_groups.add(id: 'Lighting_CFL_Garage',
                              location: HPXML::LocationGarage,
                              fraction_of_units_in_location: 0.4,
                              lighting_type: HPXML::LightingTypeCFL)
    hpxml.lighting_groups.add(id: 'Lighting_LFL_Interior',
                              location: HPXML::LocationInterior,
                              fraction_of_units_in_location: 0.1,
                              lighting_type: HPXML::LightingTypeLFL)
    hpxml.lighting_groups.add(id: 'Lighting_LFL_Exterior',
                              location: HPXML::LocationExterior,
                              fraction_of_units_in_location: 0.1,
                              lighting_type: HPXML::LightingTypeLFL)
    hpxml.lighting_groups.add(id: 'Lighting_LFL_Garage',
                              location: HPXML::LocationGarage,
                              fraction_of_units_in_location: 0.1,
                              lighting_type: HPXML::LightingTypeLFL)
    hpxml.lighting_groups.add(id: 'Lighting_LED_Interior',
                              location: HPXML::LocationInterior,
                              fraction_of_units_in_location: 0.25,
                              lighting_type: HPXML::LightingTypeLED)
    hpxml.lighting_groups.add(id: 'Lighting_LED_Exterior',
                              location: HPXML::LocationExterior,
                              fraction_of_units_in_location: 0.25,
                              lighting_type: HPXML::LightingTypeLED)
    hpxml.lighting_groups.add(id: 'Lighting_LED_Garage',
                              location: HPXML::LocationGarage,
                              fraction_of_units_in_location: 0.25,
                              lighting_type: HPXML::LightingTypeLED)
  elsif ['invalid_files/lighting-fractions.xml'].include? hpxml_file
    hpxml.lighting_groups[0].fraction_of_units_in_location = 0.8
  elsif ['base-misc-usage-multiplier.xml'].include? hpxml_file
    hpxml.lighting.usage_multiplier = 0.9
  end
end

def set_hpxml_ceiling_fans(hpxml_file, hpxml)
  if ['base-misc-ceiling-fans.xml'].include? hpxml_file
    hpxml.ceiling_fans.add(id: 'CeilingFan',
                           efficiency: 100,
                           quantity: 2)
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.ceiling_fans.add(id: 'CeilingFan',
                           efficiency: nil,
                           quantity: nil)
  end
end

def set_hpxml_plug_loads(hpxml_file, hpxml)
  if ['ASHRAE_Standard_140/L100AC.xml',
      'ASHRAE_Standard_140/L100AL.xml'].include? hpxml_file
    hpxml.plug_loads.add(id: 'PlugLoadMisc',
                         plug_load_type: HPXML::PlugLoadTypeOther,
                         kWh_per_year: 7302,
                         frac_sensible: 0.82,
                         frac_latent: 0.18)
  elsif ['ASHRAE_Standard_140/L170AC.xml',
         'ASHRAE_Standard_140/L170AL.xml'].include? hpxml_file
    hpxml.plug_loads[0].kWh_per_year = 0
  elsif not hpxml_file.include?('ASHRAE_Standard_140')
    if ['base.xml'].include? hpxml_file
      hpxml.plug_loads.add(id: 'PlugLoadMisc',
                           plug_load_type: HPXML::PlugLoadTypeOther)
      hpxml.plug_loads.add(id: 'PlugLoadMisc2',
                           plug_load_type: HPXML::PlugLoadTypeTelevision)
    elsif ['base-misc-usage-multiplier.xml'].include? hpxml_file
      hpxml.plug_loads.each do |plug_load|
        plug_load.usage_multiplier = 0.9
      end
    end
    if ['base-misc-defaults.xml'].include? hpxml_file
      hpxml.plug_loads.each do |plug_load|
        plug_load.kWh_per_year = nil
        plug_load.frac_sensible = nil
        plug_load.frac_latent = nil
      end
    else
      cfa = hpxml.building_construction.conditioned_floor_area
      nbeds = hpxml.building_construction.number_of_bedrooms

      kWh_per_year, frac_sensible, frac_latent = MiscLoads.get_residual_mels_default_values(cfa)
      hpxml.plug_loads[0].kWh_per_year = kWh_per_year
      hpxml.plug_loads[0].frac_sensible = frac_sensible.round(3)
      hpxml.plug_loads[0].frac_latent = frac_latent.round(3)

      kWh_per_year, frac_sensible, frac_latent = MiscLoads.get_televisions_default_values(cfa, nbeds)
      hpxml.plug_loads[1].kWh_per_year = kWh_per_year
      hpxml.plug_loads[1].frac_sensible = frac_sensible.round(3)
      hpxml.plug_loads[1].frac_latent = frac_latent.round(3)
    end
  end
end

def set_hpxml_misc_load_schedule(hpxml_file, hpxml)
  if hpxml_file.include?('ASHRAE_Standard_140')
    hpxml.misc_loads_schedule.weekday_fractions = '0.020, 0.020, 0.020, 0.020, 0.020, 0.034, 0.043, 0.085, 0.050, 0.030, 0.030, 0.041, 0.030, 0.025, 0.026, 0.026, 0.039, 0.042, 0.045, 0.070, 0.070, 0.073, 0.073, 0.066'
    hpxml.misc_loads_schedule.weekend_fractions = '0.020, 0.020, 0.020, 0.020, 0.020, 0.034, 0.043, 0.085, 0.050, 0.030, 0.030, 0.041, 0.030, 0.025, 0.026, 0.026, 0.039, 0.042, 0.045, 0.070, 0.070, 0.073, 0.073, 0.066'
    hpxml.misc_loads_schedule.monthly_multipliers = '1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0'
  elsif ['base.xml'].include? hpxml_file
    hpxml.misc_loads_schedule.weekday_fractions = '0.04, 0.037, 0.037, 0.036, 0.033, 0.036, 0.043, 0.047, 0.034, 0.023, 0.024, 0.025, 0.024, 0.028, 0.031, 0.032, 0.039, 0.053, 0.063, 0.067, 0.071, 0.069, 0.059, 0.05'
    hpxml.misc_loads_schedule.weekend_fractions = '0.04, 0.037, 0.037, 0.036, 0.033, 0.036, 0.043, 0.047, 0.034, 0.023, 0.024, 0.025, 0.024, 0.028, 0.031, 0.032, 0.039, 0.053, 0.063, 0.067, 0.071, 0.069, 0.059, 0.05'
    hpxml.misc_loads_schedule.monthly_multipliers = '1.248, 1.257, 0.993, 0.989, 0.993, 0.827, 0.821, 0.821, 0.827, 0.99, 0.987, 1.248'
  elsif ['base-misc-defaults.xml'].include? hpxml_file
    hpxml.misc_loads_schedule.weekday_fractions = nil
    hpxml.misc_loads_schedule.weekend_fractions = nil
    hpxml.misc_loads_schedule.monthly_multipliers = nil
  end
end

def download_epws
  weather_dir = File.join(File.dirname(__FILE__), 'weather')

  require 'net/http'
  require 'tempfile'

  tmpfile = Tempfile.new('epw')

  url = URI.parse('https://data.nrel.gov/files/128/tmy3s-cache-csv.zip')
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  params = { 'User-Agent' => 'curl/7.43.0', 'Accept-Encoding' => 'identity' }
  request = Net::HTTP::Get.new(url.path, params)
  request.content_type = 'application/zip, application/octet-stream'

  http.request request do |response|
    total = response.header['Content-Length'].to_i
    if total == 0
      fail 'Did not successfully download zip file.'
    end

    size = 0
    progress = 0
    open tmpfile, 'wb' do |io|
      response.read_body do |chunk|
        io.write chunk
        size += chunk.size
        new_progress = (size * 100) / total
        unless new_progress == progress
          puts 'Downloading %s (%3d%%) ' % [url.path, new_progress]
        end
        progress = new_progress
      end
    end
  end

  puts 'Extracting weather files...'
  unzip_file = OpenStudio::UnzipFile.new(tmpfile.path.to_s)
  unzip_file.extractAllFiles(OpenStudio::toPath(weather_dir))

  num_epws_actual = Dir[File.join(weather_dir, '*.epw')].count
  puts "#{num_epws_actual} weather files are available in the weather directory."
  puts 'Completed.'
  exit!
end

command_list = [:update_measures, :cache_weather, :create_release_zips, :update_version, :download_weather]

def display_usage(command_list)
  puts "Usage: openstudio #{File.basename(__FILE__)} [COMMAND]\nCommands:\n  " + command_list.join("\n  ")
end

if ARGV.size == 0
  puts 'ERROR: Missing command.'
  display_usage(command_list)
  exit!
elsif ARGV.size > 1
  puts 'ERROR: Too many commands.'
  display_usage(command_list)
  exit!
elsif not command_list.include? ARGV[0].to_sym
  puts "ERROR: Invalid command '#{ARGV[0]}'."
  display_usage(command_list)
  exit!
end

if ARGV[0].to_sym == :update_measures
  # Prevent NREL error regarding U: drive when not VPNed in
  ENV['HOME'] = 'C:' if !ENV['HOME'].nil? && ENV['HOME'].start_with?('U:')
  ENV['HOMEDRIVE'] = 'C:\\' if !ENV['HOMEDRIVE'].nil? && ENV['HOMEDRIVE'].start_with?('U:')

  # Apply rubocop
  cops = ['Layout',
          'Lint/DeprecatedClassMethods',
          # 'Lint/RedundantStringCoercion', # Enable when rubocop is upgraded
          'Style/AndOr',
          'Style/FrozenStringLiteralComment',
          'Style/HashSyntax',
          'Style/Next',
          'Style/NilComparison',
          'Style/RedundantParentheses',
          'Style/RedundantSelf',
          'Style/ReturnNil',
          'Style/SelfAssignment',
          'Style/StringLiterals',
          'Style/StringLiteralsInInterpolation']
  commands = ["\"require 'rubocop/rake_task'\"",
              "\"RuboCop::RakeTask.new(:rubocop) do |t| t.options = ['--auto-correct', '--format', 'simple', '--only', '#{cops.join(',')}'] end\"",
              '"Rake.application[:rubocop].invoke"']
  command = "#{OpenStudio.getOpenStudioCLI} -e #{commands.join(' -e ')}"
  puts 'Applying rubocop auto-correct to measures...'
  system(command)

  # Update measures XMLs
  command = "#{OpenStudio.getOpenStudioCLI} measure -t '#{File.dirname(__FILE__)}'"
  puts 'Updating measure.xmls...'
  system(command, [:out, :err] => File::NULL)

  create_osws
  create_hpxmls

  puts 'Done.'
end

if ARGV[0].to_sym == :cache_weather
  require_relative 'HPXMLtoOpenStudio/resources/weather'

  OpenStudio::Logger.instance.standardOutLogger.setLogLevel(OpenStudio::Fatal)
  runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)
  puts 'Creating cache *.csv for weather files...'

  Dir['weather/*.epw'].each do |epw|
    next if File.exist? epw.gsub('.epw', '.cache')

    puts "Processing #{epw}..."
    model = OpenStudio::Model::Model.new
    epw_file = OpenStudio::EpwFile.new(epw)
    OpenStudio::Model::WeatherFile.setWeatherFile(model, epw_file).get
    weather = WeatherProcess.new(model, runner)
    File.open(epw.gsub('.epw', '-cache.csv'), 'wb') do |file|
      weather.dump_to_csv(file)
    end
  end
end

if ARGV[0].to_sym == :download_weather
  download_epws
end

if ARGV[0].to_sym == :update_version
  version_change = { from: '0.9.0',
                     to: '0.10.0' }

  file_names = ['workflow/run_simulation.rb']

  file_names.each do |file_name|
    text = File.read(file_name)
    new_contents = text.gsub(version_change[:from], version_change[:to])

    # To write changes to the file, use:
    File.open(file_name, 'w') { |file| file.puts new_contents }
    puts "Updated from version #{version_change[:from]} to version #{version_change[:to]} in #{file_name}."
  end

  puts 'Done. Now check all changed files before committing.'
end

if ARGV[0].to_sym == :create_release_zips
  # Generate documentation
  puts 'Generating documentation...'
  command = 'sphinx-build -b singlehtml docs/source documentation'
  begin
    `#{command}`
    if not File.exist? File.join(File.dirname(__FILE__), 'documentation', 'index.html')
      puts 'Documentation was not successfully generated. Aborting...'
      exit!
    end
  rescue
    puts "Command failed: '#{command}'. Perhaps sphinx needs to be installed?"
    exit!
  end

  files = ['HPXMLtoOpenStudio/measure.*',
           'HPXMLtoOpenStudio/resources/*.*',
           'SimulationOutputReport/measure.*',
           'SimulationOutputReport/resources/*.*',
           'weather/*.*',
           'workflow/*.*',
           'workflow/sample_files/*.xml',
           'documentation/index.html',
           'documentation/_static/**/*.*']

  # Only include files under git version control
  command = 'git ls-files'
  begin
    git_files = `#{command}`
  rescue
    puts "Command failed: '#{command}'. Perhaps git needs to be installed?"
    exit!
  end

  release_map = { File.join(File.dirname(__FILE__), 'release-minimal.zip') => false,
                  File.join(File.dirname(__FILE__), 'release-full.zip') => true }

  release_map.keys.each do |zip_path|
    File.delete(zip_path) if File.exist? zip_path
  end

  # Check if we need to download weather files for the full release zip
  num_epws_expected = File.readlines(File.join('weather', 'data.csv')).size - 1
  num_epws_local = 0
  files.each do |f|
    Dir[f].each do |file|
      next unless file.end_with? '.epw'

      num_epws_local += 1
    end
  end

  # Make sure we have the full set of weather files
  if num_epws_local < num_epws_expected
    puts 'Fetching all weather files...'
    command = "#{OpenStudio.getOpenStudioCLI} #{__FILE__} download_weather"
    log = `#{command}`
  end

  # Create zip files
  release_map.each do |zip_path, include_all_epws|
    puts "Creating #{zip_path}..."
    zip = OpenStudio::ZipFile.new(zip_path, false)
    files.each do |f|
      Dir[f].each do |file|
        if file.start_with? 'documentation'
          # always include
        elsif include_all_epws
          if (not git_files.include? file) && (not file.start_with? 'weather')
            next
          end
        else
          if not git_files.include? file
            next
          end
        end

        zip.addFile(file, File.join('OpenStudio-HPXML', file))
      end
    end
    puts "Wrote file at #{zip_path}."
  end

  # Cleanup
  FileUtils.rm_r(File.join(File.dirname(__FILE__), 'documentation'))

  puts 'Done.'
end
