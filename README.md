# LXP Communications Library

This is a Ruby gem to parse and generate data packets from/to a LuxPower inverter. This is tested with my ACS3600 model but may work with others.

Unfortunately LuxPower refuse to release API documentation for this inverter, so this is all reverse engineered. Use with care.

That said, I've managed to work out quite a bit of it. You can parse "input" packets (via `ReadInput`) from the inverter (which are the data sent in 3 packets at 2 minute intervals, concerning energy flows and states), request settings (via `ReadHold`) for a specific register, and then modify and write those settings back (via `WriteSingle`).

There's a `WriteMulti` too but I've not used that yet. It may be used for setting the time, but I'm not interested in that so didn't bother working it out.

When you send the inverter a read/write packet, it sends a reply with the same register you sent it, and in the case of write packets, the updated value. This can be used to check the write has taken effect.

Note that the replies appear to be sent to all connected clients. If you updating a setting then the reply containing the new updated value is sent to all connected clients (including Lux in China, as per the default inverter configuration). They probably just ignore it as being unexpected; but this is partly the reason there's a `read_reply` method below which ignores packets until we get the one we expect.

See the docs in doc/ for a list of registers and my notes on how the packets are constructed. Please remember there may be errors so test carefully before letting any of this loose on your own kit. To repeat, this is all detective work by myself without the assistance of any official docs.

Also note that `lib/lxp/packet/registers.rb` only contains registers I've used, not all of them. I'll happily accept PRs adding new ones.

This library uses semantic versioning, and accordingly I currently make no guarantees about preserving backwards compatibility. Lock your gem version if this might affect you!

## Install

Standard Ruby fare in your Gemfile:

```ruby
gem 'lxp-packet'
```

Then require the base library when you want it:

```ruby
require 'lxp/packet'
```

## Setup

You obviously need the WiFi datalogger module in your inverter to use this. Mine came with it as standard.

The datalogger by default sends information about itself to LuxPower (see Connection 1 below) every 2 minutes. It connects to Lux at the IP shown below. This is how their portal gets information about you, and how they can send your inverter commands over the open channel.

It can optionally be configured with a second network endpoint; I set this to TCP Server with a port of 4346, which means you can connect to the inverter on that port and get the same information sent to you. You can also send it commands. So the "Network Setting" page of my inverter looks like this:

![LXP ACS Network Settings](https://i.imgur.com/teygH6h.png)

Alternatively you can probably just change the first setting if you don't care about the official Lux portal or mobile app being updated, though I found it useful to verify I was setting the right values at first. This would also prevent LuxPower sending you firmware updates (for better or for worse), not that I've had any so far.

## Inverter Fundamentals

The inverter has two basic sets of information.

There are 114 registers (0-113), which are also referred to as "holdings". See [doc/LXP_REGISTERS.txt](doc/LXP_REGISTERS.txt) for a list of them. Most of these you can write, and they affect inverter operation. Some pieces of information span several registers, for example the serial number is in registers 2 through 8.

Additionally there are input registers. These are transient information which the inverter broadcasts to any connected client every 2 minutes. These are sent as sets of 3 packets. `ReadInput1` / `ReadInput2` / `ReadInput3` are used to parse these.

## Examples

The inverter requires that your datalog serial and inverter serial are in the packets you send to it for it to respond.

These are set like so; this will not be repeated in all subsequent examples.

```ruby
pkt = LXP::Packet::ReadHold.new
pkt.datalog_serial = 'AB12345678'
pkt.inverter_serial = '1234567890'
```

There's also a commonly-used loop that I'll refer to. This reads input from the socket until it gets a decoded packet which matches the packet register we've previously sent to the inverter, ignoring heartbeats and other data.

This is extremely rudimentary but you get the idea. It should really have a timeout so it doesn't block forever.

```ruby
def read_reply(sock, pkt)
  loop do
    input = sock.recvfrom(2000)[0]
    # puts "IN: #{input.unpack('C*')}"
    r = LXP::Packet::Parser.parse(input)
    return r if r.is_a?(pkt.class) && r.register == pkt.register
  end
end
```

This is necessary because occasionally the inverter will send us state data and heartbeats, as well as replies for other clients (see above) which we need to either process (if you're interested in them) or ignore (which is easier, and done here).

### Reading Holding Registers

This is the simplest use-case; read the value of a holding register from the inverter.

```ruby
pkt = LXP::Packet::ReadHold.new
pkt.datalog_serial = 'AB12345678'
pkt.inverter_serial = '1234567890'
pkt.register = LXP::Packet::Registers::DISCHG_CUT_OFF_SOC_EOD

# pkt.bytes returns an array of integers if you want to inspect what we'll send

# pack the integers into a binary packet to send to a socket
out = pkt.to_bin

# assuming your inverter is at 192.168.0.30
sock = TCPSocket.new('192.168.0.30', 4346)
sock.write(out)

r = read_reply(sock, pkt)
puts "Received: #{r.value}" # should be discharge cut-off value
```

Usually, `ReadHold` instances contain the details of just one register. However, it is possible they can contain multiple. Pressing "Read" on the LuxPower Web Portal provokes the inverter into sending out 5 packets that each contain multiple registers, for example.

To do this yourself, set `#value` in a `ReadHold` you're going to send to the inverter. This tells it how many registers you want in the reply, and they'll start from the number set in `#register`:

```ruby
# get registers 0 through 22 inclusive:
pkt.register = 0
pkt.value = 23
```

To access these in the reply, you can use subscript notation to get a register directly, or call `#to_h` to get a hash of registers/values. For convenience this also works with single register packets, though obviously only one subscript will ever return data, and `to_h` will only have one key.

```ruby
# assuming pkt is a parsed packet with multiple registers/values:
pkt[0] # => 35462 # value of register 0
pkt.to_h # { 0 => 35462, 1 => 1, ... }

# assuming pkt is a parsed packet with only register 21:
pkt[21] # => value of register 21
pkt[22] # => nil
pkt.to_h # { 21 => 62292 }
```

### Reading Input Registers

This is similar to reading holdings. The inverter should send these packets every 2 minutes anyway, but if you want them on demand, you can create a `ReadInput1` (or 2, or 3) and send it.

Each packet type contains a bunch of data, the simplest way to get at these is to call `to_h` on the packet, which returns a Hash of data:

```ruby
pkt = LXP::Packet::ReadInput1.new
pkt.datalog_serial = 'AB12345678'
pkt.inverter_serial = '1234567890'

# assuming your inverter is at 192.168.0.30
sock = TCPSocket.new('192.168.0.30', 4346)
sock.write(out)

r = read_reply(sock, pkt)
# r is a populated ReadInput1, which responds to #to_h:
r.to_h # => {:status=>16, :soc=>79, ... }
```


### Writing

Updating a value on the inverter.

```ruby
pkt = LXP::Packet::WriteSingle.new
# set serials like above..

# set discharge cutoff to 20%
pkt.register = LXP::Packet::Registers::DISCHG_CUT_OFF_SOC_EOD
pkt.value = 20

# pack the integers into a binary packet to send to a socket
out = pkt.to_bin

# assuming your inverter is at 192.168.0.30
sock = TCPSocket.new('192.168.0.30', 4346)
sock.write(out)

r = read_reply(sock, pkt)
puts "Received: #{r.value}" # should be new discharge cut-off value, 20
```

### Updating a bitwise register

The Lux has two registers that contain multiple settings. In `doc/LXP_REGISTERS.txt` you can see them at 21 and 110. They have two bytes.

This library combines them into a 16bit word, so that the constants in `LXP::Packet::RegisterBits` can be applied directly to those values.

First you need to read the previous value, update it with a new bit, then write it back. This is really just a combination of the two above examples.

This example enables AC charge. You need to OR the bit with the previous value so as not to change other settings stored in register 21.

It could be improved not to bother doing the write if it was already enabled.

```ruby
sock = TCPSocket.new('192.168.0.30', 4346)

pkt = LXP::Packet::ReadHold.new
# serials..

pkt.register = 21
sock.write(pkt.to_bin)

r = read_reply(sock, pkt)
# r.value is a 16bit integer

pkt = LXP::Packet::WriteSingle.new
# serials..

pkt.register = 21

# enable AC charge by ORing it with the previous value
pkt.value = r.value | LXP::Packet::RegisterBits::AC_CHARGE_ENABLE

# or maybe you want to disable AC charge
# pkt.value = r.value & ~LXP::Packet::RegisterBits::AC_CHARGE_ENABLE

sock.write(pkt.to_bin)

r = read_reply(sock, pkt)
# now r.value should be the updated 16bit integer
```
