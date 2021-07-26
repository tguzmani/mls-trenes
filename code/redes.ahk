#SingleInstance, Force
SendMode Input

I_Icon = icon.ico
IfExist, %I_Icon%
  Menu, Tray, Icon, %I_Icon%

; Interfaces
::fa00::Fa0/0
::fa10::Fa1/0
::fa11::Fa1/1
::fa01::Fa0/1
::fa40::Fa4/0
::fa50::Fa5/0
::se00::Se0/0
::se01::Se0/1
::se02::Se0/2
::se20::Se2/0
::se30::Se3/0
::se10::Se1/0
::se11::Se1/1
::se020::Se0/2/0
::se030::Se0/3/0

; IPs
:o:.ip::192.38.

; Masks
::.24::255.255.255.0
::.25::255.255.255.128
::.26::255.255.255.192
::.27::255.255.255.224
::.28::255.255.255.240
::.29::255.255.255.248
::.30::255.255.255.252

:o:.d::DCE

F2::
  Send, n
  Sleep 100
  MouseClick, left
  Send, .
Return

F3::
  Send, n
  Sleep 100
  MouseClick, left
  Send, 192.69.
Return

F4::
  Send, n
  Sleep 100
  MouseClick, left
  Send, 171.0.0.
Return