$(document).on("page:change", function() {
  var validateVanityString = function( validationType, message , classToRemove, classToAdd) {
    var hasRemoveClass = 'has-' + classToRemove,
        hasAddClass = 'has-' + classToAdd,
        formRemoveClass = 'form-control-' + classToRemove,
        formAddClass = 'form-control-' + classToAdd

    $('#' + validationType + '-string-form-group').removeClass(hasRemoveClass).addClass(hasAddClass)
    $('#'+ validationType +'_string').removeClass(formRemoveClass).addClass(formAddClass)
    $('#'+ validationType +'-string-status').text('').text(message)
  }

  $('#vanity-string').keyup(function(e) {
    if (this.value) {
      if (this.value.length < 5) {
        validateVanityString('vanity', 'Your custom url is too short.', 'success', 'danger')
        $('#submit_link').attr('disabled', true)
      } else {
        validateVanityString('vanity', '', 'danger', 'success')
        $('#submit_link').attr('disabled', false)
        $.ajax({
          method: 'GET',
          url: '/search/' + this.value,
          dataType: 'json',
          success: function(data) {
            if (data.exists) {
              validateVanityString('vanity', 'sorry, that url is already taken', 'success', 'warning')
              $('#submit_link').attr('disabled', true)
            } else {
              validateVanityString('vanity', '', 'warning', 'success')
              $('#submit_link').attr('disabled', false)
            }
          },
          error: function(error) {
            console.log('error', error)
          }
        })
      }
    } else {
      $('#vanity-string-form-group').removeClass('has-danger has-success')
      $('#vanity-string').removeClass('form-control-danger form-control-success')
    }
  })

})
