class MlLiteBucket
  def initialize
    s3 = Aws::S3::Resource.new
    @bucket = s3.bucket(Rails.application.credentials.dig(:aws, :bucket))
    # bucket.object(args)
  end

  def object(key)
    @bucket.object(key)
  end
end
