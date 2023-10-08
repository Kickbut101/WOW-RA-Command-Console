Function Get-Telnet
                                                                                                                                                                                                                                                
            {   Param (
                [Parameter(ValueFromPipeline=$true)]
                [String[]]$Commands = @("username","password"),
                [string]$RemoteHost,
                [string]$Port,
                [int]$WaitTime = 2
            )
                    #Attach to the remote device, setup streaming requirements
                    $Socket = New-Object System.Net.Sockets.TcpClient($RemoteHost, $Port)
                    If ($Socket)
                    {   $Stream = $Socket.GetStream()
                        $Writer = New-Object System.IO.StreamWriter($Stream)
                        $Buffer = New-Object System.Byte[] 1024 
                        $Encoding = New-Object System.Text.AsciiEncoding

                        #Now start issuing the commands
                        ForEach ($Command in $Commands)
                        {   
                            write-host $Command
                            $Writer.WriteLine($Command) 
                            $Writer.Flush()
                            Start-Sleep $WaitTime
                        }
                        #All commands issued, but since the last command is usually going to be
                        #the longest let's wait a little longer for it to finish
                        Start-Sleep $WaitTime
                        $Result = ""
                        #Save all the results
                        While($Stream.DataAvailable) 
                        {   $Read = $Stream.Read($Buffer, 0, 1024) 
                            $Result += ($Encoding.GetString($Buffer, 0, $Read)) + "`n"
                        }
                    }
                    $Result
                    }

                    $cmd = @("Poshbot@","SomePassword","character")
                    cls
                    (Get-Telnet -RemoteHost "192.168.1.183" -Port "3444" -Commands $cmd)