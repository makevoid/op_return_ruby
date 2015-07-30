# get generated private key saved in current .private_key file

# get utxo from blockchain.info

# create transaction - add data [env]

# broadcast via blockchain.info

class OpReturn
  PATH = File.expand_path "../", __FILE__
  PRIVATE_KEY_FILE = ".private_key"

  def initialize(message)
    @message     = message
    @private_key = read_private_key
  end

  def self.send
    new(message).send
  end

  private

  def read_private_key
    read_private_key_string
  end

  def read_private_key_string
    File.read("#{PATH}/#{PRIVATE_KEY_FILE}").strip
  end

end


OpReturn.send "OR antani"


#####

# opal-node + bitcore

# ruby
