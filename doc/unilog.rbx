#!/usr/bin/env ruby

require 'drb/drb'

# see propharma.rbx (main implementation)
request = Apache.request
begin
  connection = request.connection

  request.server.log_notice("Received Request #{request.request_method}")
  if request.request_method != 'POST'
    request.status = 405 # Method not allowed
    exit
  end
  request.server.log_notice("from #{connection.remote_ip}")

  content_length = request.headers_in['Content-Length'].to_i
  request.server.log_notice("content-length: #{content_length}")
  if content_length <= 0
    request.status = 500 # Server Error
    request.server.log_error("zero length input")
    exit
  end

  xml_src = $stdin.read(content_length)

  DRb.start_service
  xmlconv = DRbObject.new(nil, ENV['DRB_SERVER'])
  destination = XmlConv::Util::Destination.book(ENV['ACCESS_DESTINATION'])

  transaction = XmlConv::Util::Transaction.new
  transaction.domain      = ENV['HTTP_HOST']
  transaction.input       = xml_src
  transaction.reader      = 'SunStoreBdd'
  transaction.writer      = ENV['WRITER']
  transaction.destination = destination
  transaction.partner     = 'Unilog'
  transaction.origin      = \
    "http://#{connection.remote_ip}:#{connection.remote_port}"
  transaction.postprocs.push(['Soap', 'update_partner'])
  transaction.postprocs.push([
    'Bbmb2', 'inject', ENV['ACCESS_BBMB'], 'customer_id'])

  request.content_type = 'text/xml;charset=utf-8'
  print xmlconv.execute_with_response(transaction)
rescue StandardError => err
  request.server.log_error(err.class.to_s)
  request.server.log_error(err.message)
  request.server.log_error(err.backtrace.join("\n"))
  request.status = 500
ensure
  request.send_http_header
end
