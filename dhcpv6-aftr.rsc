# ==== CONFIG ====
# Tunnel name
:local tunnelName "<here enter your IPIPv6 tunnel's name"
# Fallback AFTR
:local fallbackAFTR "<here enter your fallback AFTR domain>"
# DNS Server
:local AFTRDNSServer "<here enter any DNS server to check AFTR domain against>"

# ====  MAIN  ====
# Check if DHCPv6 Client got new lease
:if ($"pd-valid" = "1") do={
  # Get DHCPv6 no. 64 option (AFTR Address)
  :local rawAFTR ($options->"64")

  # Dot-formatted DNS domain of AFTR router
  :local AFTRDomain ""

  # Iterator
  :local i 0

  # Decode DNS-encoded AFTR domain
  :while ($i < [:len $rawAFTR]) do={
    # Get first byte (segment length)
    :local len [:pick $rawAFTR $i ($i + 1)]
    :set len [:convert $len to=num]
	
    # If len==0, then we have whole domain
    :if ($len = 0) do={
      # "Break" loop
      :set i [:len $rawAFTR]
    } else={
      # Get single domain segment
      :local segment ""
      :for j from=1 to=$len do={
        # Get char and append to segment
        :local ch [:pick $rawAFTR ($i + $j) ($i + $j + 1)]
        :set segment ($segment . $ch)
      }

      # Append segment to AFTRDomain with dot
      :if ([:len $AFTRDomain] > 0) do={
        :set AFTRDomain ($AFTRDomain . "." . $segment)
      } else={
        :set AFTRDomain $segment
      }

      # Move iterator
      :set i ($i + $len + 1)
    }
  }

  # Log decoded AFTR router domain
  :log info ("DHCPv6 Client: Received AFTR domain address: $AFTRDomain")

  # Test if AFTR router is alive
  :local pingOK [/ping [: resolve type=ipv6 server=$AFTRDNSServer $AFTRDomain] count=2 interval=500ms]

  # Set AFTRDomain or fallback
  :if ($pingOK > 0) do={
    /interface ipipv6 set [find name=$tunnelName] remote-address=$AFTRDomain
  } else={
    :log warning ("DHCPv6 Client: Received AFTR is not alive. Fallbacking to $fallbackAFTR")
    /interface ipipv6 set [find name=$tunnelName] remote-address=$fallbackAFTR
  }
}
