$(document).ready(function(){
  $.ajax({url: "/api/v1/top100", success: function(result){
    var data = JSON.parse(result);

    for(i = 0; i < data.length; i++)
    {
      var user = data[i]['owner'];
      $("#tweetHolder").append(
        '<div class="media">' +
          '<div class="media-left">' +
            '<a href="#">' +
              '<img class="media-object" src="/pngs/'+(Math.floor(Math.random()*100))+'.png" height="50">' +
            '</a>' +
          '</div>' +
          '<div class="media-body">' +
            '<h4 class="media-heading">' +
              '<a href="/user/' + user + '">'+ user + '</a>' +
              '<small> ' + data[i]['display_date'] + ' </small>' +
            '</h4>' +
            data[i]['text'] +
          '</div>' +
        '</div>')
    }

  },
  error: function(result){
    alert(result);
  }
  });
});
