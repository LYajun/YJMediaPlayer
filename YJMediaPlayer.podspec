

Pod::Spec.new do |s|
  s.name             = 'YJMediaPlayer'
  s.version          = '1.2.0'
  s.summary          = '基于IJK的视频播放器'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/LYajun/YJMediaPlayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LYajun' => 'liuyajun1999@icloud.com' }
  s.source           = { :git => 'https://github.com/LYajun/YJMediaPlayer.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
 
  s.source_files = 'YJMediaPlayer/Classes/YJMediaPlayer.h'

  s.resources = 'YJMediaPlayer/Classes/YJMediaPlayer.bundle'
  
  s.subspec 'Category' do |category|
      category.source_files = 'YJMediaPlayer/Classes/Category/**/*'
  end
  
  s.subspec 'Lrc' do |lrc|
      lrc.source_files = 'YJMediaPlayer/Classes/Lrc/**/*'
      lrc.dependency 'MJExtension'
      lrc.dependency 'Masonry'
  end
  
  s.subspec 'Model' do |model|
      model.source_files = 'YJMediaPlayer/Classes/Model/**/*'
      model.dependency 'YJMediaPlayer/Lrc'
      model.dependency 'YJMediaPlayer/Category'
  end
  
  s.subspec 'View' do |view|
      view.source_files = 'YJMediaPlayer/Classes/View/**/*'
      view.dependency 'YJMediaPlayer/Lrc'
      view.dependency 'YJMediaPlayer/Model'
      view.dependency 'YJMediaPlayer/Category'
      view.dependency 'Masonry'
      view.dependency 'SDWebImage'
  end
  
  s.subspec 'Player' do |player|
      player.source_files = 'YJMediaPlayer/Classes/Player/**/*'
      player.dependency 'YJMediaPlayer/Model'
      player.dependency 'YJMediaPlayer/View'
      player.dependency 'IJKMediaFramework'
  end
  
  s.requires_arc = true
  s.static_framework = true
  
end
