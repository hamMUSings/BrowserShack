# Linux and Sound Cards
Often the most tricky part of linux.  
> [!WARNING]
> Depending on your radio the sound cards may disconnect when the radio is powered off. This can lead to sound card IDs moving around and causing issues.

To resolve this you can force and order by editing /etc/modprobe.d/alsa.conf and rebooting.

> [!NOTE]
> If you are using a sound card that is either onboard or using audio connectors to the radio this is likely an unnecessary step but still can be used.

This WILL different for each computer AND radio combination.  The example below is for GMKtec Mini PC N97 + Yaesu FT-710

Add the following to /etc/modprobe.d/alsa.conf
```
options snd slots=snd_hda_intel,snd-usb-audio
options snd-usb-audio index=1,2,3 vid=0x0573,0x2997,0x0d8c pid=0x1573,0x0001,0x0013
```

This tells linux to load any sound cards with the driver snd_hda_intel first and then secondly load the cards using the driver snd-usb-audio second.

However, in the case of this setup there are actually 3 USB sound cards:
1) Onboard sound
2) Video capture card sound
3) FT-710 USB sound card

On each boot and or power cycle of the radio the order of these cards can change.  They will always be card 1, 2, & 3 but which one is which did not stay consistent in my testing.

So to second line forces a sub order the cards by their PID and VID.  So in the above example:

1) Onboard sound = card 1
2) Video capture card sound = card 2
3) FT-710 USB sound card = card 3

Which allows me to set the card for the gsteamer container with hw:3,0 and it will consistently work.

> [!TIP]
> To make this work use lsusb, lsusb -t, aplay -l, and aplay -L to determine your card's VID and PID

> [!TIP]
> This is an optional step but a highly recommended one if your sound card is in the radio itself.



