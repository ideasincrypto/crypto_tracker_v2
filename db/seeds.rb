# creates the request service object
request_service = ApiRequestsService.new(ApiConnectionService.build)

# load top 100 coins by market cap to the database
Coin.load_coins(request_service)
