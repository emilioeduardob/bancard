module Bancard
  class Base
    PRIVATE_KEY = ENV["BANCARD_PRIVATE_KEY"]
    PUBLIC_KEY = ENV["BANCARD_PUBLIC_KEY"]
    BASE_HOST = ENV["BANCARD_HOST"]
  end
end