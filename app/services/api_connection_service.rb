class ApiConnectionService
  def self.build
    Faraday.new(
      url: "https://api.coingecko.com/",
      headers: { "Content-type" => "application/json" }
    )
  end
end
