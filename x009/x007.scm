PROCESSOR: 18F4550
PATH: D:\work\midicontroller
PROJECT: MidiController

;--------------------------------------------------------------------------------
x007	4/14/07 JD

Cleaned up a bit more and implemented 2 functions:
READ_BLOCK_FROM_ROM
and
WRITE_BLOCK_INTO_ROM

Before calling either function, TBLPTR must be set to the address of the ROM
block to work on.  Also, FSR0 must be set to the address of the RAM buffer
to write to.  Note that both functions access 64 bytes of ROM.  It will take
approximately 8mS to write 64 bytes, so the processor will stall for that
amount of time before resuming normal operation.  It is recommended to only do 
one write every 10mS or so to prevent the USB connection from hanging.

;--------------------------------------------------------------------------------
x006	4/14/07 JD

Set up the timer to interrupt at a regular interval.. Not sure what its set to.
Cleaned everything up and put Jim's code in.

;--------------------------------------------------------------------------------
x005	4/14/07 JD

First version to actually send midi data out.

;--------------------------------------------------------------------------------
x004	4/14/07 JD

Set up the workspace.. USB functions I believe....

;--------------------------------------------------------------------------------
x001-3	4/14/07 JD

No idea what I did..

