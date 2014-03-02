//$(document).ajaxStop($.unblockUI); 
$(document).ready(function(){
  defaultAudioFile = $('.course_item dd').eq(0).data('audio-url');
  MIMEType = "";
  console.log("Modernizr.audio.ogg " + Modernizr.audio.ogg );
  console.log("Modernizr.audio.m4a " + Modernizr.audio.m4a );
  console.log("Modernizr.audio.mp3 " + Modernizr.audio.mp3 );

  ext = "";
  if(Modernizr.audio.ogg == "probably") {
    ext = "ogg";
    MIMEType = "audio/ogg";
  } else if(Modernizr.audio.m4a == "probably") {
    ext = "m4a";
    MIMEType = "audio/mp4";
  } else if(Modernizr.audio.mp3 == "probably") {
    ext = "mp3";
    MIMEType = "audio/mpeg";
  } else {
    ext = "wav";
    MIMEType = "audio/wav";
  }

  defaultAudioFile = defaultAudioFile + "." + ext;

  $("#audio_player").html("<audio controls><source src='" + defaultAudioFile + "' type='" + MIMEType + "'></audio>");
  $("#audio_player audio").attr({
    autoplay: false,
    loop: true
  });

  var playing = false;
  var lastPlayedObj = null;
  $('.btn-play').click(function(){
    var player = $("#audio_player audio")[0];
    defaultAudioFile = $(this).data('audio-url');
    $("#audio_player audio source").attr("src", defaultAudioFile);
    
    if(this != lastPlayedObj) {
      player.pause();
      $('.btn-play').removeClass('btn-success');
      playing = false;
      lastPlayedObj = null;
    }
    if(!playing) {
      player.play();
      $(this).addClass('btn-success');
      lastPlayedObj = this;
      playing = true;
    } else {
      player.pause();
      $('.btn-play').removeClass('btn-success');
      playing = false;
      lastPlayedObj = null;
    }
  });


  // defaultAudioFile = $('.course_item dd').eq(0).data('audio-url');
  // jwplayer("audio_player").setup({
  //   file: defaultAudioFile,
  //   flashplayer: 'swfs/jwplayer.flash.swf',
  //   autostart: false,
  //   width: '100%',
  //   height: 30,
  //   repeat: false
  // });
// 
  // jwplayer().onPlaylistComplete(function(){
  //   console.log("onPlaylistComplete");
  // });
// 
  // jwplayer().onPlaylistItem(function(){
  //   console.log("onPlaylistItem");
  // });
// 
  // jwplayer().onPause(function(){
  //   console.log("onPause");
  // });
// 
  // jwplayer().onComplete(function(){
  //   console.log("onComplete");
  // });
  // 
// 
  // var playing = false;
  // var lastPlayedObj = null;
  // $('.btn-play').click(function(){
  //   //console.log(jwplayer().getPlaylist());
  //   defaultAudioFile = $(this).data('audio-url');
  //   jwplayer().load([{file:defaultAudioFile}]);
  //   if(this != lastPlayedObj) {
  //     jwplayer().stop();
  //     $('.btn-play').removeClass('btn-success');
  //     playing = false;
  //     lastPlayedObj = null;
  //   }
  //   if(!playing) {
  //     jwplayer().play();
  //     $(this).addClass('btn-success');
  //     lastPlayedObj = this;
  //     playing = true;
  //   } else {
  //     jwplayer().stop();
  //     $('.btn-play').removeClass('btn-success');
  //     playing = false;
  //     lastPlayedObj = null;
  //   }
  // });

  //$('.course_item').first().fadeIn(1000).addClass('current').find('.btn-previous').addClass('disabled');
  // $('.course_item').last().find('.btn-next').addClass('disabled');
  // $('.btn-next').click(function(){
  //   if($(this).hasClass('disabled')) {
  //     return false;
  //   }
  //   showItem('next');
  // });


  // $('.btn-previous').click(function(){
  //   if($(this).hasClass('disabled')) {
  //     return false;
  //   }
  //   showItem('prev');
  // });

  

  // function showItem(direction) {
  // 
  //   thisElement = $('.current').eq(0);
  // 
  //   if(direction == 'next') {
  //     nextElement = thisElement.next('.course_item').eq(0);
  //   } else {
  //     nextElement = thisElement.prev('.course_item').eq(0);
  //   }
  //   if(nextElement.length == 0) {
  //     return false;
  //   }
  //   
  //   thisElement.removeClass('current').fadeOut(100, function(){
  //     nextElement.fadeIn(1000).addClass('current');
  //     defaultAudioFile = nextElement.find('dd').eq(0).data('audio-url');
  //     jwplayer().load([{file:defaultAudioFile}]);
  //   });
  // }
});

