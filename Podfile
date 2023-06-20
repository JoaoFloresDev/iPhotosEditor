# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iPhotos' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iPhotos
  pod 'CLImageEditor', '~> 0.2'
  pod "Agrume" 
  pod 'Google-Mobile-Ads-SDK', '7.69.0'
  pod 'AlamofireImage', '~> 4.1'
  pod 'ImageScrollView'
  pod 'IQKeyboardManagerSwift'
  pod 'IGColorPicker'
  pod 'SVProgressHUD'
  pod 'OpalImagePicker'
  pod 'ZoomImageView'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end