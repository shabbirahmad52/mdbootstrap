<script>
    $(document).ready(function() {
        // Check if 2FA section is shown, then load the QR code
        if ($('#2fa-section').is(':visible')) {
            $.ajax({
                url: '/get_qr_code',
                type: 'GET',
                success: function() {
                    $('#qr-code-image').attr('src', '/get_qr_code').show();
                },
                error: function() {
                    alert('Unable to fetch QR code.');
                }
            });
        }
    });
</script>
