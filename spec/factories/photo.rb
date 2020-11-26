FactoryGirl.define do
  factory :photo do
    image {  Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/image/IMG_5297.JPG'), 'image/png') }
    user_id 1
    title "Title"
    camera "Camera"
    lens "Lens"
    shutter_speed "1/80"
    f_value "4"
    iso "64000"
    item "Item"
    comment "Comment"
    favorites_quantity 0
  end
end