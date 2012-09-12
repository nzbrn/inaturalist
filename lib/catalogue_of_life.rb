#
# Wrapper class for the CoL ReSTish web service methods.  This class doesn't 
# do much more than pass along requests to uBio and return Hpricot objects.  
# You have been warned.
#
class CatalogueOfLife
  ENDPOINT = 'http://www.catalogueoflife.org/annual-checklist/2010/webservice'.freeze

  attr_reader :timeout

  def initialize(timeout=5)
    @timeout = timeout
  end
  #
  # Sends a request to a CoL function, and returns an Hpricot object of the 
  # xml response.  There's really only the search method right now.
  #
  # TODO: handle bad responses!
  #
  def request(method, args = {})
    params = args
    url    = ENDPOINT + "?" + 
             params.map {|k,v| "#{k}=#{v}"}.join('&')
    uri    = URI.encode(url)
    response = nil
    begin
      timed_out = Timeout::timeout(@timeout) do
        # puts "DEBUG: requesting " + uri # test
        response  = Net::HTTP.get_response(URI.parse(uri))
        # puts response.body
      end
    rescue Timeout::Error
      raise Timeout::Error, 
            "Catalogue of Life didn't respond within #{timeout} seconds."
    end
    Nokogiri::XML(response.body)
  end

  def method_missing(method, *args)
    params = *args
    unless params.is_a? Hash and not params.empty?
      raise "Catalogue of Life arguments must be a Hash"
    end
    request(method, *args)
  end
end
