
Pod::Spec.new do |spec|

  spec.name         = "YDMOfflineOrders"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of YDMOfflineOrders."
  spec.homepage     = "http://yourdev/YDMOfflineOrders"

  spec.license          = "MIT"
  spec.author       = { "Douglas Hennrich" => "douglashennrich@yourdev.com.br" }

  spec.swift_version    = "5.0"
  spec.platform         = :ios, "11.0"
  spec.source           = { :git => "https://github.com/Hennrich-Your-Dev/YDMstoreModeOfflineAccount.git", :tag => "#{spec.version}" }

  spec.source_files     = "YDMOfflineOrders/**/*.{h,m,swift}"
#  spec.resources        = [
#    "YDMOfflineOrders/**/*.{xib,storyboard,json,xcassets}",
#    "YDMOfflineOrders/*.{xib,storyboard,json,xcassets}"
#  ]

  spec.dependency "YDExtensions"
  spec.dependency "YDUtilities"
end
