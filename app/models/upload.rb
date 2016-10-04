class Upload < ApplicationRecord
  
  def merge_image_with_audio
    # gem install transloadit
    transloadit = Transloadit.new(
      :key    => 'xxxxxxxxxx',#Transloadit api key
      :secret => 'xxxxxxxxxxx'#Transloadit api secret
    )
    
    imported_audio = transloadit.step 'imported_audio', '/http/import', :url => "https://dl.dropboxusercontent.com/u/11048066/test_audio.m4a"
    
    imported_image = transloadit.step 'imported_image', '/http/import', :url => "https://dl.dropboxusercontent.com/u/11048066/My%20Photo%20Memories/manimaranm_1319901807_1.jpg"

    merger = transloadit.step 'merger', '/video/merge',
      :use => {"steps":[{"name":"imported_audio","as":"audio"},{"name":"imported_image","as":"image"}]},
      :result => true,
      :ffmpeg_stack => "v2.2.3",
      :preset => "ipad-high",
      :resize_strategy => "pad"
      

    assembly = transloadit.assembly(
      :steps => [ imported_audio, imported_image, merger ]
    )

    response = assembly.submit! #open('lolcat.jpg')
    until response.finished?
      sleep 1; response.reload!
    end

    if !response.error?
      puts response
     # handle success
    else
     puts response
    end
    
  end
  
end
