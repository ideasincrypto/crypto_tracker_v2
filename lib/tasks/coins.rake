namespace :coins do
  desc "Load coins from top 100 markets to the database"
  task :load => :environment do
    conn = ApiConnectionService.build
    request_service = ApiRequestsService.new(conn)
    Coin.load_coins(request_service)
  end
end
