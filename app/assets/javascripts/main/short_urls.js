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

  $('input#vanity_string').keyup(function(e) {
    if (this.value) {
      if (this.value.length < 5) {
        validateVanityString('vanity', 'Your custom url is too short.', 'success', 'danger')
      } else {
        validateVanityString('vanity', '', 'danger', 'success')
        $.ajax({
          method: 'GET',
          url: '/search/' + this.value,
          dataType: 'json',
          success: function(data) {
            if (data.exists) {
              validateVanityString('vanity', 'sorry, that url is already taken', 'success', 'warning')
            } else {
              validateVanityString('vanity', '', 'warning', 'success')
            }
          },
          error: function(error) {
            console.log('error', error)
          }
        })
      }
    } else {
      $('#vanity-string-form-group').removeClass('has-danger has-success')
      $('#vanity_string').removeClass('form-control-danger form-control-success')
    }
  })

})
