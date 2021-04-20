
Pod::Spec.new do |spec|

  spec.name         = "YDMOfflineOrders"
  spec.version      = "1.1.23"
  spec.summary      = "A short description of YDMOfflineOrders."
  spec.homepage     = "http://yourdev/YDMOfflineOrders"

  spec.license          = "MIT"
  spec.author       = { "Douglas Hennrich" => "douglashennrich@yourdev.com.br" }

  spec.swift_version    = "5.0"
  spec.platform         = :ios, "11.0"
  spec.source           = { :git => "https://github.com/Hennrich-Your-Dev/YDMOfflineOrders.git", :tag => "#{spec.version}" }

  spec.source_files     = "YDMOfflineOrders/**/*.{h,m,swift}"
#  spec.resources        = [
#    "YDMOfflineOrders/**/*.{xib,storyboard,json,xcassets}",
#    "YDMOfflineOrders/*.{xib,storyboard,json,xcassets}"
#  ]

  spec.dependency "Cosmos"

  spec.dependency "YDB2WIntegration", "~> 1.1.0"
  spec.dependency "YDExtensions", "~> 1.0.10"
  spec.dependency "YDUtilities", "~> 1.0.10"
  spec.dependency "YDB2WAssets", "~> 1.0.33"
  spec.dependency "YDB2WServices", "~> 1.1.0"
  spec.dependency "YDB2WModels", "~> 1.1.0"
  spec.dependency "YDB2WComponents", "~> 1.1.0"
  spec.dependency "YDB2WDeepLinks", "~> 1.0.0"
  spec.dependency "YDMFindStore", "~> 1.1.0"
end
