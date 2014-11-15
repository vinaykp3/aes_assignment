require "openssl"
require 'digest/sha1'
require 'base64'
require 'uri'
require 'net/http'

module PaymentTransaction
  class Request

    def initialize()
      @request_string = request_string
    end  

    def request_string
      bank_ifsc_code="ICIC0000001|bank_account_number=11111111|amount=10000.00|merchant_transaction_ref=txn001|merchant_transaction_date=2014-11-14|payment_gateway_merchant_reference=merc001"
    end

    def encrypt_request
      alg = "AES-256-CBC"
 
      digest = Digest::SHA256.new
      digest.update("symetric key")
      key = digest.digest
      iv = OpenSSL::Cipher::Cipher.new(alg).random_iv
       
      key64 = [key].pack('m')
      # Now we do the actual setup of the cipher
      aes = OpenSSL::Cipher::Cipher.new(alg)
      aes.encrypt
      aes.key = key
      aes.iv = iv


      cipher = aes.update(sha_string)
      cipher << aes.final
      cipher64 = [cipher].pack('m')
      puts cipher64

      decode_cipher = OpenSSL::Cipher::Cipher.new(alg)
      decode_cipher.decrypt
      decode_cipher.key = key
      decode_cipher.iv = iv
      plain = decode_cipher.update(cipher64.unpack('m')[0])
      plain << decode_cipher.final
      puts "Decrypted data"
      puts plain

      # #encrypt = OpenSSL::Cipher::AES.new("test",:CBC)
      # payload_to_pg = Base64.encode64(sha_string)  
    end

    def sha_string
      sha_string = Digest::SHA1.hexdigest @request_string
      "#{@request_string}|hash=#{sha_string}"
    end

    def send_request

    end  

  end
end

p PaymentTransaction::Request.new.encrypt_request