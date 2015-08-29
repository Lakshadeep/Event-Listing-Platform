function attend_event(event_id,user_id){
  $.ajax({type: 'post',url: "/event/attend/",data: { event_id: event_id, user_id: user_id} , success: function(result){
        $("#attend_event").hide();
        confirmed_count =  parseInt($("#confirmed").text());
        $("#confirmed").text(confirmed_count+1);
        alert('Success');
    },error: function(){alert('Error: Request could not be completed');}});
}

function accept_invite(event_id){
  $.ajax({type: 'post',url: "/event/accept_invitation/" ,data: { event_id: event_id} , success: function(result){
        $("#accept_invite"+event_id).hide();
        $("#reject_invite"+event_id).hide();
        $("#maybe_invite"+event_id).hide();
        confirmed_count =  parseInt($("#confirmed").text());
        $("#confirmed").text(confirmed_count+1);
        alert('Success');
    },error: function(){alert('Error: Request could not be completed');}});
}


function confirm_event(x){
  $.ajax({type: 'post',url: "/admin/confirm_event/", data: { event_id: x} ,success: function(result){
        $("#confirm"+x).hide();
        $("#reject"+x).hide();
        alert('Success');
    },error: function(){alert('Error: Request could not be completed');}});
}

function delete_event(x){
  $.ajax({type: 'post',url: "/admin/delete_event/", data: { event_id: x} , success: function(result){
        $("#confirm"+x).hide();
        $("#reject"+x).hide();
        alert('Success');
    },error: function(){alert('Error: Request could not be completed');}});
}

function block(x){
    $.ajax({type: 'post',url: "/admin/block_user/", data: { user_id: x}, success: function(result){
          $("#block").hide();
          alert('Success');
      },error: function(){alert('Error: Request could not be completed');}});
}
 
function unblock(x){
    $.ajax({type: 'post',url: "/admin/unblock_user/",data: { user_id: x}, success: function(result){
          $("#unblock").hide();
          alert('Success');
      },error: function(){alert('Error: Request could not be completed');}});
}

function friend_request(sender_id,reciever_id){
    $.ajax({type: 'post',url: "/user/send_request/",data: { sender_id: sender_id,receiver_id: reciever_id}, success: function(result){
          $("#send_request").hide();
          alert('Success');
      },error: function(){alert('Error: Request could not be completed');}});
}

function accept_request(sender_id,reciever_id){
    $.ajax({type: 'post',url: "/user/accept_request/",data: { sender_id: sender_id,receiver_id: reciever_id}, success: function(result){
          $("#accept_request"+sender_id).prop("disabled",true);
          $("#reject_request"+sender_id).prop("disabled",true);
          alert('Success');
    },error: function(){alert('Error: Request could not be completed');}});
}

function reject_request(sender_id,reciever_id){
  $.ajax({type: 'post',url: "/user/reject_request/",data: { sender_id: sender_id,receiver_id: reciever_id}, success: function(result){
        $("#accept_request"+sender_id).prop("disabled",true);
        $("#reject_request"+sender_id).prop("disabled",true);
        alert('Success');
    },error: function(){alert('Error: Request could not be completed');}});
}



function accept_invite(event_id){
  $.ajax({type: 'post',url: "/event/accept_invitation/" ,data: { event_id: event_id} , success: function(result){
        $("#accept_invite"+event_id).prop("disabled",true);
        $("#reject_invite"+event_id).prop("disabled",true);
        $("#maybe_invite"+event_id).prop("disabled",true);
        alert('Success');
    },error: function(){alert('Error: Request could not be completed');}});
}

function reject_invite(event_id){
  $.ajax({type: 'post',url: "/event/reject_invitation/" ,data: { event_id: event_id} , success: function(result){
        $("#accept_invite"+event_id).prop("disabled",true);
        $("#reject_invite"+event_id).prop("disabled",true);
        $("#maybe_invite"+event_id).prop("disabled",true);
        alert('Success');
    },error: function(){alert('Error: Request could not be completed');}});
}

function maybe_invite(event_id){
  $.ajax({type: 'post',url: "/event/maybe_invitation/" ,data: { event_id: event_id} , success: function(result){
        $("#accept_invite"+event_id).prop("disabled",true);
        $("#reject_invite"+event_id).prop("disabled",true);
        $("#maybe_invite"+event_id).prop("disabled",true);
        alert('Success');
    },error: function(){alert('Error: Request could not be completed');}});
}


function send_invite(event_id,user_id){
    $.ajax({type: 'post',url: "/event/invite/",data: { event_id: event_id,user_id: user_id}, success: function(result){
          $("#send_invite").hide();
          alert('Success');
      },error: function(){alert('Error: Request could not be completed');}});
}


function submit_email_invite_form() {
       $("#invite_email").submit();
        alert('Email sent');
}