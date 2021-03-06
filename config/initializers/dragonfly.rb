# AlchemyCMS Dragonfly configuration.
#
# Consider using some kind of caching solution for image processing.
# For small projects, we have good experience with Rack::Cache.
#
# Larger installations should consider using a CDN, start reading
# http://markevans.github.io/dragonfly/cache/
#
# A complete reference can be found at
# http://markevans.github.io/dragonfly/configuration/
#
# Pictures
#
Dragonfly.app(:alchemy_pictures).configure do
  dragonfly_url nil
  plugin :imagemagick
  plugin :svg
  secret 'b5ff6925d7e6adcb12c947d6534e43fa71ff1a101a506d7249d24c48810e36f6'
  url_format '/pictures/:job/:name.:ext'

  if Rails.env.production?
    datastore :s3,
      bucket_name: ENV.fetch("ALCHEMY_S3_BUCKET_NAME"),
      access_key_id: ENV.fetch("ALCHEMY_S3_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("ALCHEMY_S3_SECRET_ACCESS_KEY"),
      region: ENV.fetch("ALCHEMY_S3_REGION")
  else
    datastore :file,
      root_path: Rails.root.join('uploads/pictures').to_s,
      server_root: Rails.root.join('public'),
      store_meta: false
  end
end

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware, :alchemy_pictures

# Attachments
Dragonfly.app(:alchemy_attachments).configure do
  if Rails.env.production?
    datastore :s3,
      bucket_name: ENV.fetch("ALCHEMY_S3_BUCKET_NAME"),
      access_key_id: ENV.fetch("ALCHEMY_S3_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("ALCHEMY_S3_SECRET_ACCESS_KEY"),
      region: ENV.fetch("ALCHEMY_S3_REGION")
  else
    datastore :file,
      root_path:  Rails.root.join('uploads/attachments').to_s,
      store_meta: false
  end
end
