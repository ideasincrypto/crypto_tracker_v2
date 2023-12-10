class ApiRequestsService
  def initialize(conn)
    @conn = conn
  end

  def get_rates(*coins)
    res = @conn.get("api/v3/simple/price") do |req|
      req.headers["Content-Type"] = "application/json"
      req.params["ids"] = convert_to_string(coins.flatten)
      req.params["vs_currencies"] = "usd"
      req.params["precision"] = 2
    end

    return JSON.parse(res.body, symbolize_names: true) if res.status == 200
  end

  private

  def convert_to_string(coins)
    coins.map { |c| c.api_id }.join(",")
  end
end
