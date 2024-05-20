json.extract! website, :id, :url, :restricted, :timeout, :created_at, :updated_at
json.url website_url(website, format: :json)
