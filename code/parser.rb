require "clipboard"

def copy(array)
  Clipboard.copy array.join("\n")
end

$masks = {
  "16" => "255.255.0.0",
  "20" => "255.255.240.0",
  "21" => "255.255.248.0",
  "22" => "255.255.252.0",
  "23" => "255.255.254.0",
  "24" => "255.255.255.0",
  "25" => "255.255.255.128",
  "26" => "255.255.255.192",
  "27" => "255.255.255.224",
  "28" => "255.255.255.240",
  "29" => "255.255.255.248",
  "30" => "255.255.255.252",
  "32" => "255.255.255.255"
}

$wildcards = {
  "16" => "0.0.255.255",
  "20" => "0.0.15.255",
  "21" => "0.0.7.255",
  "22" => "0.0.3.255",
  "23" => "0.0.1.255",
  "24" => "0.0.0.255",
  "25" => "0.0.0.127",
  "26" => "0.0.0.63",
  "27" => "0.0.0.31",
  "28" => "0.0.0.15",
  "29" => "0.0.0.7",
  "30" => "0.0.0.3",
  "32" => "0.0.0.0",
}

$output = []

def configuration(device_name)
  commands = [
    "ena",
    "config t",
    "host #{device_name}",
    "exit",
    "wr",
    "conf t"
  ] 

  $output += commands
end

def interface(line)
  command_array = line.split(" ")
  interface_name = command_array[1]
  ip = command_array[2]
  mask = command_array[3]
  is_dce = command_array[4] ? "y" : nil

  commands = [
    "int #{interface_name}",
    "ip addr #{ip} #{mask}"
  ]
  
  commands << "clock rate 56000" if (is_dce)
  
  commands += [
    "no sh",
    "exit"
  ] 

  $output += commands
end

def rip
  commands = [
    "router rip",
    "version 2",
    "no auto"
  ] 

  $output += commands
end

def eigrp(line)
  command_array = line.split(" ")
  id = command_array[1]

  $output += ["router eigrp #{id}", "no auto"]
end

def net(line)
  command_array = line.split(" ")
  network_address = command_array[1]
  wildcard = $wildcards[command_array[2]] if command_array[2]
  area = "area #{command_array[3]}" if command_array[3]

  $output << "net #{network_address} #{wildcard} #{area}"
end

def div(line)
  text = line.split(" ")
  text.shift
  $output += [
    "\n-------------------------------------",
    "#{text.join(" ")}",
    "-------------------------------------",

  ]
end

def static(line)
  command_array = line.split(" ")
  destiny = command_array[1]
  mask = command_array[2]
  next_hop = command_array[3]

  $output << "ip route #{destiny} #{$masks[mask]} #{next_hop}"
end

def ospf(line)
  command_array = line.split(" ")
  process_id = command_array[1]

  $output << "router ospf #{process_id}"
end
  
filename = ARGV.first

File.open(filename).readlines.each_with_index do |line, i|
  case line
  when /^name*/
    configuration line.split(" ")[1] 

  when /^int*/
    interface line 

  when /^rip$/
    rip 

  when /^ospf/
    ospf line

  when /^eigrp*/
    eigrp line 

  when /^net/
    net line 

  when /^exit$/
    $output << "exit" 

  when /^div*/
    div line 


  when /^static*/
    static line 

  when /^\n/
  else
    puts "error on line #{i + 1}"
  end
end

File.open("output/#{filename}-output.txt", 'w') { |file| file.write $output.join("\n") }