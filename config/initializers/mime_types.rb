# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
Mime::Type.register "text/plain", :txt
Mime::Type.register "text/richtext", :rtf

Mime::Type.register "application/vnd.ms-fontobject", :eot
Mime::Type.register "font/ttf", :ttf
Mime::Type.register "font/otf", :otf
Mime::Type.register "application/x-font-woff", :woff

Rack::Mime::MIME_TYPES['.ttf'] = 'font/ttf'