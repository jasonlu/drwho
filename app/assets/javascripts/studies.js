//$(document).ajaxStop($.unblockUI); 
$(document).ready(function(){
  var defaultAudioFile = $('.course_item dd').eq(0).data('audio-url');
  var MIMEType = "";
  var ext = "";
  // console.log("Modernizr.audio.ogg " + Modernizr.audio.ogg );
  // console.log("Modernizr.audio.m4a " + Modernizr.audio.m4a );
  // console.log("Modernizr.audio.mp3 " + Modernizr.audio.mp3 );
  
  if(Modernizr.audio.m4a == "maybe") {
    ext = "m4a";
    MIMEType = "audio/mp4";
  } else if(Modernizr.audio.ogg == "probably") {
    ext = "ogg";
    MIMEType = "audio/ogg";
  } else if(Modernizr.audio.mp3 == "probably") {
    ext = "mp3";
    MIMEType = "audio/mpeg";
  } else {
    ext = "wav";
    MIMEType = "audio/wav";
  }

  var player = new Audio(defaultAudioFile + "." + ext);
  player.loop = true;
  player.addEventListener('ended', audioHasEnded);
  
  
  var playing = false;
  var playingAll = false;
  var lastPlayedObj = null;
  var playlist = Array();
  $("dd[data-audio-url]").each(function(){
    playlist.push($(this).data('audio-url'));
  });
  var index = 0;

  function audioHasEnded(ev) {
    // console.log('audio ended index: ' +  index);
    if(index == playlist.length) {
      index = 0;
      $('.btn-play-all').removeClass('btn-success');
      playing = false;
      return true;
    }
    player.src = playlist[index] + "." + ext;
    player.loop = false;
    player.load();
    player.play();
    index++;
  }

  $('.btn-play').click(function(){
    defaultAudioFile = $(this).data('audio-url');
    playingAll = false;
    //$("#audio_player audio source").attr("src", defaultAudioFile);
    player.loop = true;
    player.src = defaultAudioFile + "." + ext;
    player.load();
    $('.btn-success').removeClass('btn-success');
    if(this != lastPlayedObj) {
      player.pause();
      
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
      //$('.btn-play').removeClass('btn-success');
      playing = false;
      lastPlayedObj = null;
    }
  });

  $('.btn-play-all').click(function(){
    playing = false;
    if(playingAll) {
      $(".btn-success").removeClass('btn-success');
      player.pause();
    } else {
      $('.btn-play').removeClass('btn-success');
      $(this).addClass('btn-success');
      player.loop = false;
      player.src = playlist[0] + '.' + ext;
      player.load();
      player.play();
      index++;
      playingAll = true;
    }
  });
  
});

