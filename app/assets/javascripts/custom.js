$(document).ready(function() {
    $(".toast").toast("show");

    $(".toast").on("hidden.bs.toast", function () {
        $(".toast-area").remove()
    })
});

$(document).ready(function() {
    $('#user_avatar').on('change',function(e){
        var fileName = e.target.files[0].name;
        $(this).next('.custom-file-label').html(fileName);
    })
});
