
Pod::Spec.new do |spec|

  spec.name         = "YDMOfflineOrders"
  spec.version      = "1.3.8"
  spec.summary      = "A short description of YDMOfflineOrders."
  spec.homepage     = "http://yourdev/YDMOfflineOrders"

  spec.license          = "MIT"
  spec.author       = { "Douglas Hennrich" => "douglashennrich@yourdev.com.br" }

  spec.swift_version    = "5.0"
  spec.platform         = :ios, "11.0"
  spec.source           = { :git => "https://github.com/Hennrich-Your-Dev/YDMOfflineOrders.git", :tag => "#{spec.version}" }

  spec.source_files     = "YDMOfflineOrders/**/*.{h,m,swift}"

  spec.dependency "Cosmos"

  spec.dependency "YDB2WIntegration", "~> 1.3.0"
  spec.dependency "YDExtensions", "~> 1.3.0"
  spec.dependency "YDUtilities", "~> 1.3.0"
  spec.dependency "YDB2WAssets", "~> 1.3.0"
  spec.dependency "YDB2WServices", "~> 1.3.0"
  spec.dependency "YDB2WModels", "~> 1.3.0"
  spec.dependency "YDB2WComponents", "~> 1.3.0"
  spec.dependency "YDB2WDeepLinks", "~> 1.3.0"
  spec.dependency "YDMFindStore", "~> 1.3.0"
end
