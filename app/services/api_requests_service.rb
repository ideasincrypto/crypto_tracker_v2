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

  def get_coins_data
    res = @conn.get("api/v3/coins/markets") do |req|
      req.headers["Content-Type"] = "application/json"
      req.params["vs_currency"] = "usd"
      req.params["order"] = "market_cap_desc"
      req.params["per_page"] = 100
      req.params["page"] = 1
      req.params["sparkline"] = false
      req.params["locale"] = "en"
      req.params["precision"] = 2
    end

    return JSON.parse(res.body) if res.status == 200
    raise ApiError, "Service Unavailable" if res.status == 503
    raise ApiError, "The API returned an error" if res.status == 500
  end

  private

  def convert_to_string(coins)
    coins.map { |c| c.api_id }.join(",")
  end
end
