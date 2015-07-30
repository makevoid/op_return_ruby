# You must install bitcoin-ruby
# See https://github.com/lian/bitcoin-ruby
# This code is based off of examples in that project
require 'bitcoin'

# Use the main bitcoin network (as opposed to Testnet)
Bitcoin.network = :bitcoin

# Include the Transaction builder module
include Bitcoin::Builder

# From the Electrum command line: listunspent()
# This is the "prevout_hash" value from your selected output in Electrum
prev_hash = "cb7a8176f350b74bf3cf048358f3caaf323b015249886ebe7470fe4120addec0"

# load in previous Transaction from json file in same directory as this code
prev_tx = Bitcoin::Protocol::Tx.from_json_file('tx.json')

# set this to the value of 'prevout_n' from the output you selected in Electrum
prev_out_index = 0

# set value of new tx (use complete value of prev_tx minus 0.1 mBTC miner fee)
value = prev_tx.outputs[prev_out_index].value - 10_000

# set receiving address of transaction. Should be an address you own
recipient = "1D4H7Q8bz4gFY2jupVySs6aukFNjxFHJMa"


# Private key from Electrum command line: dumpprivkeys(["1AjbRheAoakGauT7epv1G9fVAFxqT2eyH"])
# This key is fake.
key = Bitcoin::Key.from_base58("5JNpCEg8Q4Kh4i8t8pxrX9BZbN67LDhtu7Liw46a8poDQzWWvAB")

# Build the transaction
new_tx = build_tx do |t|
  # Construct the input to the transaction using the previous transaction we loaded from tx.json
  t.input do |i|
    i.prev_out prev_tx
    i.prev_out_index prev_out_index
    i.signature_key key
  end

  # Create first output to define amount of BTC to be sent
  t.output do |o|
    # Specify value of first output (in Satoshis)
    # IMPORTANT!!! ANY DIFFERENCE BETWEEN THE PREVIOUS OUTPUT VALUE AND THIS VALUE WILL
    # BE SENT TO THE MINER.
    o.value value

    # Specify the recipient of this transaction (make it o)
    o.script { |s| s.recipient recipient }
  end

  # Create output with secret message using OP_RETURN
  t.output do |o|
    # specify our "secret message" to encode in the blockchain
    o.to "secret message".unpack("H*"), :op_return
    # specify the value of this output (zero)
    o.value 0
  end
end

# print hex version of new signed transaction
puts "Hex Encoded Transaction:\n\n"
puts new_tx.to_payload.unpack("H*")[0]
puts "\n\n"

# print JSON version of new signed transaction
puts "JSON:\n\n"
puts new_tx.to_json



####

# https://gist.github.com/ryandotsmith/9f6a26c76ad852763d03



# var privateKey = new bitcore.PrivateKey('L1uyy5qTuGrVXrmrsvHWHgVzW9kKdrp27wBC7Vs6nZDTF2BRUVwy');
# var utxo = {
#   "txId" : "115e8f72f39fad874cfab0deed11a80f24f967a84079fb56ddf53ea02e308986",
#   "outputIndex" : 0,
#   "address" : "17XBj6iFEsf8kzDMGQk5ghZipxX49VXuaV",
#   "script" : "76a91447862fe165e6121af80d5dde1ecb478ed170565b88ac",
#   "satoshis" : 50000
# };
#
# var transaction = new bitcore.Transaction()
#     .from(utxo)
#     .addData('bitcore rocks') // Add OP_RETURN data
#     .sign(privateKey);
