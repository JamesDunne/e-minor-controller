PROCESSOR: 18F442
PATH: E:\work\picscope USB\x001
PROJECT: PICSCOPE USB
Based on: Original


;--------------------------------------------------------------------------------
x016	3/21/06 JD

HID only.  RS232 is gone..  This captures about 200 samples then waits for each
to be gotten individually by getfeature.

Next step is to increase the length of report id 175 to 64 bytes.  Or more likely 
add a new report id...

;--------------------------------------------------------------------------------
x015	3/16/06 JD

We're now actually reporting voltage data via report id 175 on both EP0 and EP1.

;--------------------------------------------------------------------------------
x014	3/16/06 JD

Everything is working properly now via USB.  The getfeature is working right and the
input reports are working correctly.  
This is working with usbhidio2 x004.

;--------------------------------------------------------------------------------
x013	10/22/05 JD

Working on a USB approach..  Some progress with descriptors...

;--------------------------------------------------------------------------------
x012	10/22/05 JD

Now we implement the buffering approach.  Works quite well...

;--------------------------------------------------------------------------------
x011	10/22/05 JD

More work..  Changing channel from AN1 to AN0.

;--------------------------------------------------------------------------------
x010	10/17/05 JD

Put a delay between Tx's  (A/D sampling).

;--------------------------------------------------------------------------------
x009	10/17/05 JD

IT WORKS!!

The value read by ADRESH, L is correct!!

Now I just have to make sure its formatted properly.

Having problems with reading the data properly with CommDll.

;--------------------------------------------------------------------------------
x008	10/17/05 JD

Did some work on the scope setup..
Also integrated USB with production test protocol.

;--------------------------------------------------------------------------------
x007	10/17/05 JD

Figured out that I needed to read PIR1 in order to clear the TXIF flag.


;--------------------------------------------------------------------------------
x006	10/17/05 JD

Trying to send out the data formatted..

;--------------------------------------------------------------------------------
x005	10/07/05 JD

I'm going to give this another go to see if I can figure out whats going on.

This puts out an AA, 55 combo..

;--------------------------------------------------------------------------------
x002	5/24/05 JD


Still doesnt work.

;--------------------------------------------------------------------------------
x001	5/24/05 JD
Based on: Original


Uses the Bootloader code.  The remapped vectors start at 0xA00

Attempted to read an A/D converter input and then output the result to the
RS232 port.  I was having trouble with this though.  The A/D conversion seems
to be working as the data was output to the IO port properly, but not 
transmitted to the RS232 port properly.

;--------------------------------------------------------------------------------
