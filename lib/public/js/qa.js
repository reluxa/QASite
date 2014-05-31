$(document).ready(function(){
   //style all the buttons
    $( "input[type=submit], button" ).button()

    //init tag input uls
    $('#tags').tagit();

    $("abbr.timeago").timeago();

    $(".markup").each(function(){
        var text = $(this).val();
        var html = Markdown_convert(text);
        html = prettify_my_text(html);
        $(this).after("<div>"+html+"</div>");
    });

    initEditors();
});

function q_vote(id, direction) {
    $.ajax({
        type: "GET",
        url: "/vote/question/"+id+"/"+direction
    }).done(function( data ) {
        $("#q_votes"+id).html(data);
    });
}

function a_vote(id, direction) {
    $.ajax({
        type: "GET",
        url: "/vote/answer/"+id+"/"+direction
    }).done(function( data ) {
        $("#a_votes"+id).html(data);
    });
}

function accept_answer(qid, aid) {
    $.ajax({
        type: "GET",
        url: "/accept/question/"+qid+"/"+aid
    }).done(function() {
        location.reload();
    });
}

function prettify_my_text(text) {
    var prettified= text.replace( /<pre>([\s\S]*?)<\/pre>/gm, function(v) {
        return prettyPrintOne(v);
    });
    prettified= prettified.replace( /<pre>/gm, function(v) {
        return "<pre class='prettyprint'>";
    });
    return prettified;
}


function initEditors() {
    var converter = new Markdown.Converter();

    converter.hooks.chain("postConversion", function (text) {
        return prettify_my_text(text);
    });

    var editor = new Markdown.Editor(converter);
    editor.run();
}

function navigate(url) {
    window.location = url;
}

function show(id) {
    $(id).show("blind", 100);
}