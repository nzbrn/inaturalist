module PlacesHelper
  def place_name_and_type(place, options = {})
    place_name = options[:display] ? place.display_name : place.name
    place_type_name = place_type(place)
    content_tag(:span, :class => "place #{place.place_type_name}") do
      place_name + (place_type_name.blank? ? '' : " #{place_type_name}")
    end
  end
  
  def place_type(place)
    place_type_name = nil
    place_type_name = if place.place_type
      content_tag(:span, :class => 'place_type description') do
        "(#{place.place_type_name})"
      end
    end
    place_type_name
  end
  
  def google_static_map_for_place(place, options = {}, tag_options = {})
    tag_options[:alt] ||= "Google Map for #{place.display_name}"
    tag_options[:width] ||= options[:size] ? options[:size].split('x').first : 200
    tag_options[:height] ||= options[:size] ? options[:size].split('x').last : 200
    image_tag(
      google_static_map_for_place_url(place, options),
      tag_options
    )
  end
  
  def google_static_map_for_place_url(place, options = {})
    url_for_options = {
      :host => 'maps.google.com',
      :controller => 'maps/api/staticmap',
      :center => "#{place.latitude},#{place.longitude}",
      :zoom => 15,
      :size => '200x200',
      :sensor => 'false',
    }.merge(options)
    url_for(url_for_options)
  end
  
  # Returns GMaps zoom level for a place given map dimensions in pixels
  def map_zoom_for_place(place, width, height)
    return 0 if [place.nelat, place.nelng, place.swlat, place.swlng].include?(nil)
    (1..SPHERICAL_MERCATOR.levels).to_a.reverse_each do |zoom_level|
      minx, miny = SPHERICAL_MERCATOR.from_ll_to_pixel([place.swlng, place.swlat], zoom_level)
      maxx, maxy = SPHERICAL_MERCATOR.from_ll_to_pixel([place.nelng, place.nelat], zoom_level)
      return zoom_level if (maxx - minx < width) && (maxy - miny < height)
    end
  end
  
  def google_charts_map_for_places(places, options = {}, tag_options = {})
    countries = places.select {|p| p.place_type == Place::PLACE_TYPE_CODES['Country']}
    states = places.select {|p| p.place_type == Place::PLACE_TYPE_CODES['State'] && p.parent.try(:code) == 'US'}
    geographical_area = 'world'
    labels = countries.map(&:code)
    if states.size > 0 && (countries.empty? || (countries.size == 1 && countries.first.code = 'US'))
      labels = states.map {|s| s.code.gsub('US-', '')}
      geographical_area = 'usa'
    end
    data = "t:#{(['100'] * labels.size).join(',')}"
    url_for_options = {
      :host => 'chart.apis.google.com',
      :controller => 'chart',
      :chs => '440x220',
      :chco => 'EEEEEE,1E90FF,1E90FF',
      :chld => labels.join,
      :chd => labels.empty? ? 's:_' : data,
      :cht => 't',
      :chtm => geographical_area
    }.merge(options)
    
    tag_options[:alt] = "Map of #{geographical_area == 'usa' ? 'US states' : 'countries'}: #{labels.join(', ')}"
    tag_options[:width] ||= url_for_options[:chs].split('x').first
    tag_options[:height] ||= url_for_options[:chs].split('x').last
    
    image_tag(
      url_for(url_for_options),
      tag_options
    )
  end
end
