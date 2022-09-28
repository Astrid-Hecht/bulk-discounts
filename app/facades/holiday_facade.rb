require 'json'
require './app/services/github_service'

class HolidayFacade

  def self.next_3
    response = HolidayService.request

    parsed = JSON.parse(response.body)

    parsed.map { |holiday| "Name: #{holiday['name']} ::  Date: #{holiday['date']}"}[0..2]

  end
end 
