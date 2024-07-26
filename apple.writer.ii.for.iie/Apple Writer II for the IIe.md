# Apple Writer II for the IIe

## Introduction

This was something of a white whale.  This was the first version of Apple Writer
that I used back in the day.  Much later, for reasons that I forget, I wanted a
text editor that worked under Apple DOS 3.3, had 80 columns, and would run on
the Applewin emulator. The only version of Apple Writer that fits the bill is
[Apple Writer II for the IIe][^1], hereafter referred to as Apple Writer IIe.
Earlier versions don't support the standard Apple 80 column card. Later versions
run under ProDOS.

[^1]: <https://en.wikipedia.org/wiki/Apple_Writer#Apple_Writer_IIe>

This version was hard to find. Searching for "Apple Writer II" or "Applewriter
II" will usually get you either the later ProDOS based versions, or the [4am
crack of Apple Writer II][^2]. Working copies of Apple Writer 1.0 or 1.1 are
reasonably easy to find.

[^2]: <https://archive.org/details/AppleWriterII4amCrack>

For the longest time I could only found one copy, a bare 140k DOS order disk
image that wouldn't run. While I still have this copy, I can no longer find the
link for it.  But there are [one][^3] or [two][^4] very similar images.

[^3]: <https://archive.org/download/d330s1-applewriter2e-dos/d330s1-applewriter2e-dos.dsk>

[^4]: <https://mirrors.apple2.org.za/ftp.apple.asimov.net/images/productivity/word_processing/APPLE_WRITER_DOS33.dsk>

After booting and running the disk drive for a while, the screen fills with
inverse `@` characters and then clears to an Applesoft prompt at the top of the
screen. The orderly stop looks deliberate and it seems like some copy protection
mechanism exiting cleanly.  However I wasn't really motivated to crack it since
I couldn't be sure that it wasn't a corrupted copy rather than just a failed
copy protection check.

Then I stumbled across an [Applesauce flux disk image of Apple Writer IIe in
Antoine Vignau's Applesauce collection][^5] which I assumed to be pristine, or
near enough to it.  After converting the A2R file to the WOZ format it worked
perfectly in Applewin. Now I could be sure that I wasn't going end up on a wild
goose chase.

[^5]: <https://archive.org/download/Antoine_Applesauce_Vignau/Apple%20Writer%20II%20%28Apple%20Computer%2C%20Inc.%29/Apple%20Writer%20II%20-%20Disk%201%2C%20Side%20A%20Backup.a2r>

## Tools of the Trade

I have a real physical enhanced Apple IIe.  Messing about with it fills a need
for nostalgia. But that only goes so far. It's been 40 years, give or take, and
now I have access to some nice stuff that makes nostalgia easier to enjoy.

* [Floppy Emu](https://www.bigmessowires.com/floppy-emu/)

  The physical Apple IIe has physical drives. But 5 1/4 floppy media is
  getting hard to find and what I do have is mostly unreliable.  Floppy Emu
  fills the gap nicely.  Better yet, it can both read and write WOZ images.

* [Applewin](https://github.com/AppleWin/AppleWin/releases)

  This is running on Windows 10.  It's nice to have the real hardware but it's
  downstairs, and Applewin is convenient. Better yet, Applewin has a built in
  debugger. Oh, and it can read WOZ images.

* [Ghidra](https://github.com/NationalSecurityAgency/ghidra/releases)

  A nice tool for reverse engineering machine code. It has language support for
  6502 and 65C02. I have a couple of extension modules to automate finding text
  strings encoded in the Apple II character set (most significant bit set):
  [HiAscii Charset Provider](https://github.com/slapdau/hiascii), and [Charset
  String Analyzer](https://github.com/slapdau/charsetstringanalyzer).

* [Ciderpress](https://a2ciderpress.com/)

  Useful for moving files between disk images and the host operating system.

## The Applesauce Flux Image

Before I can work with it, I need the file in a format that I can work with. A
WOZ bit image file will run in both Applewin and Floppy Emu.  This is the point
where I step out of my usual tool set and locate someone understanding enough to
not only lend me their Macintosh PC but also let me install Applesauce on it.

### Repairing the Damage

When the Applesauce flux image of Apple Writer IIe is opened, the track display
is mostly green, except for track `0x22`, which is yellow.  Looking at the track
in logical sector mode, sector 6 is cannot be read and is highlighted in red.
Looking at the track in physical sector mode, the corresponding physical sector
3 is missing.  Inspecting the nibble stream for the track and it becomes
apparent the the seam of the flux image has fallen in the middle of the prologue
for the physical sector 3 address header, turning what should be `D5 AA 96` into
`D5 AD 96`.

Adjusting the timings for the first few flux transitions fixes this and logical
DOS sector 6 is now readable.  Logical DOS sector 6 is the last sector of the
file `ADDRS`, an example mail merge address file. The contents look consistent
with the other data sector of the file so I am confident that the fix is
correct.  No other files are affected, including the following that would seem
to make up the application proper:

* `OBJ.BOOT`
* `OBJ.APWRT][D`
* `OBJ.APWRT][E`
* `OBJ.APWRT][F`

Included is a copy of [Apple Writer II - Disk 1
Master.woz](Apple%20Writer%20II%20-%20Disk%201%20Master.woz) with the
correction. This runs correctly in Applewin and should be fine with anything
that supports WOZ files.

### Foreshadowing

Applesauce also makes apparent one additional hint about where this crack is
going.  In logical sector mode I can see that the volume number is different for
every sector.

In Apple DOS 3.3, the volume number is a disk identification mechanism that is
very rarely used.  Most software ignores it and simply relies on physical drive
attachment location.  Even when it is used, the volume number conceptually
identifies the entire disk.  However, the number is recorded in the header field
for every sector of the disk meaning that when RWTS is used to read a sector it
can report the volume number of the actual disk in the drive.  This gives
software a chance to detect unexpected disk swaps by the user.  When a standard
copy of the DOS 3.3 RWTS initialises a disk, it writes the same volume number
into every sector header.

It looks like the protection scheme for this disk is going to involve some
shenanigans with these normally unused volume fields in the sector headers.

### Was That Really Necessary?

Slightly annoying, but after creating a fixed WOZ image and bypassing the copy
protection I found [another A2R image of Apple Writer IIe][^6].  This copy is
better in the sense that Applesauce did not see any the tracks as corrupted.
However, it is useful in that the file contents are identical to the one in
Antoine Vignau's collection, giving me some confidence that my flux timing fix
is correct and that the images are unchanged from the original published disks.
In all the bare 140k DOS order disk images, that I found, there are changes.

[^6]: <https://archive.org/download/sdancer_a2rs/AppleWriter--Backup-Disk1SideA.a2r>

## The Crack

At this point I have a working copy of Apple Writer IIe in a WOZ file.  Since it
works in Applewin and with Floppy Emu, in principle I have what I want.  But
there is still that itch to scratch of knowing what the copy protection is and
breaking it. That, and having an unprotected 140k image would be nice.

This is not going to be an example of how a contemporary cracker would have
approached Apple Writer IIe.  As noted above, I have modern tools and I'm going
to take advantage of them.

### Lessons of History

Lets see how the WOZ image file behaves when it is copied on a an Apple IIe as
though it were an original floppy disk.

First `COPYA`. The copy process appears to complete successfully, but when the
copied disk is booted it behaves the same way as the non-working disk.

Next [Passport](https://github.com/a2-4am/passport):

```text
Passport by 4am               2023-07-28
                                        
 ______________________________________ 
                                        
                                        
                                        
Reading from S6,D1                      
T00,S00 Found DOS 3.3 bootloader        
Using disk's own RWTS                   
Writing to S6,D2                        
T02,S02 Volume name is DISK VOLUME 064  
                                        
The disk was copied successfully, but   
Passport did not apply any patches.     
                                        
Possible reasons:                       
- The source disk is not copy protected.
- The target disk works without patches.
- The disk uses an unknown protection,  
  and Passport can not help any further.
                                        
Press any key                           
```

Again, the copied disk fills the screen with inverse `@` characters before
clearing and dropping to the Applesoft prompt. At this point I have to conclude
that Apple Writer IIe is not protected by Apple Special Delivery, which was used
by Apple II. Passport will detect and crack that. For more details refer to the
4am cracks for [Apple Writer II][^2] and [Ernie's Quiz][^7].

In the process I do learn something else interesting. Passport will not boot
from, and work with, a [Yellowstone card from Big Mess 'o Wires][^8].

[^7]: <https://archive.org/details/ErniesQuiz4amCrack>
[^8]: <https://www.bigmessowires.com/yellowstone/>

Using a bit copier, such as Locksmith 6.0B or Copy II Plus 9.1, is a different
matter.  Both of these programs produce a working copy by doing nothing more than
copying tracks 0x00 to 0x22 in one track increments, without the need to
synchronise tracks or preserve track length.

### Begin at the End

So, with that in mind, how to start? With a hunch, and a little bit of luck.
A common technique for cracking Apple II software is a boot trace. Start from
the known entry point of the disk controller card firmware and progressively
capture and analyse successive stages of code until the protection mechanism is
found.  In practice this can take a long time depending on how much code is
between the disk boot and the copy protection. Longer if the code is obfuscated
in any way.  I'm going to see if I can shortcut the process by starting with what
I think I know.

The filling of the screen with inverse `@` characters is suggestive.  A check of
the Apple II character set shows that the character code for an inverse `@` is
`0x00`.  It looks like something is wiping the memory, which is a common
technique for Apple II software after a failed protection check. And I have a
virtual Apple IIe with a debugger.  Perhaps I can find this code and then work
backwards.

First mount the copy made with `COPYA` in the boot drive of Applewin. This is
going to trigger the screen wipe after failing the copy protection check. Before
booting it, set a break point when the top left character of the screen is
written to.

```text
>bpmw 400:400
```

The first time the break point is hit is in the monitor ROM. Obviously not what
we want so we'll continue execution. On the eighth time the break point is hit,
the `PC` register is at `$020F`, which is promising.

The memory region from `$0200` to `$02FF` is used by the monitor ROM keyboard
input routines as a input line buffer. Some copy protection mechanisms will run
code from here that the act of typing commands to inspect the it will destroy it
first.

So let's have a look:

```text
; R/W Lang Card bank 2
0200-   AD 83 C0    LDA   $C083
0203-   AD 83 C0    LDA   $C083
; Start with ($00) pointing to $0300
0206-   A9 03       LDA   #$03
0208-   85 01       STA   $01
020A-   A0 00       LDY   #$00
020C-   84 00       STY   $00
; $00 to the accumulator
020E-   98          TYA   
; Wipe memory up to $BFFF, and then from $D000 to $FFFF
020F-   91 00       STA   ($00),Y
0211-   C8          INY   
0212-   D0 FB       BNE   $220F
0214-   E6 01       INC   $01
0216-   F0 0C       BEQ   $2224
0218-   A6 01       LDX   $01
021A-   E0 C0       CPX   #$C0
021C-   D0 F1       BNE   $220F
021E-   A2 D0       LDX   #$D0
0220-   86 01       STX   $01
0222-   D0 EB       BNE   $220F
; Write prot. Lang Card, Read ROM
0224-   AD 82 C0    LDA   $C082
0227-   AD 82 C0    LDA   $C082
022A-   8D 0C C0    STA   $C00C         ; Clear 80 column
022D-   20 84 FE    JSR   $FE84         ; SETNORM
0230-   20 2F FB    JSR   $FB2F         ; INIT
0233-   20 93 FE    JSR   $FE93         ; SETVID
0236-   20 89 FE    JSR   $FE89         ; SETKBD
0239-   20 58 FC    JSR   $FC58         ; HOME
023C-   4C 00 E0    JMP   $E000         ; BASIC
```

This code corresponds perfectly with what we are seeing. This is our start. Time
to work backwards.

### Where Did We Come From?

There are any number of sneaky ways of transferring control to `$0200`, but
let's start with the simplest. Who knows? We might get lucky.

```text
>sh 300:bfff 4c 00 02                                                           
01:$2CCD                                                                        
Total: 1  (#$0001)                                                              
```

Well, that was easy. Let's take a look at the code:

```text
2CBF-   20 FD 49    JSR $49FD                                             
2CC2-   A0 60       LDY #$60                              
2CC4-   B9 D0 2C    LDA $2CD0,Y                              
2CC7-   99 00 02    STA $0200,Y                              
2CCA-   88          DEY                                              
2CCB-   10 F7       BPL $2CC4                                   
2CCD-   4C 00 02    JMP $0200                                      
```

The code from `$2CD0` onward is the same as the code just seen at `$0200`.
This looks like where we want to be. It's a spring board inside the application
to copy a memory wipe routine and then start it.

This routine seems to be standing alone.  There is no fall through or entry into
it from the code block before it.  Let's see if our luck holds and try to keep
working backwards by searching for references to the entry point. Could be
either `$2CBF` or `$2CC2`.

```text
>sh 300:bfff c2 2c                                                              
Total: 0  (#$0000)                                                              
>sh 300:bfff bf 2c                                                              
01:$3B05                                                                        
Total: 1  (#$0001)                                                              
```

Again, this seems straight forward.

### Non-Standard Disk Reads

We'll look at the code around the address we just found.  It starts with a
subroutine call:

```text
3AD6-   20 64 48    JSR   $4864
```

Before we have a look at the rest of the code that leads to the memory wipe,
let's see what the subroutine at `$4864` does:

```text
; Locate the DOS IOB parameter list
4864-   20 E3 03    JSR   $03E3
; and store a pointer to it at ($80)
4867-   84 80       STY   $80
4869-   85 81       STA   $81
; Make a copy of the IOB at $02E0
486B-   A0 14       LDY   #$14
486D-   B1 80       LDA   ($80),Y
486F-   99 E0 02    STA   $02E0,Y
4872-   88          DEY   
4873-   10 F8       BPL   $486D
; Set Y to 0
4875-   C8          INY   
; Set the IOB volume number to 0 (match any that we read)
4876-   8C E3 02    STY   $02E3
; Set up a pointer to $FE00 at ($F0)
4879-   A9 00       LDA   #$00
487B-   85 F0       STA   $F0
487D-   A9 FE       LDA   #$FE
487F-   85 F1       STA   $F1
; Make a copies of the current track and sector
4881-   AD E4 02    LDA   $02E4
4884-   8D 01 0C    STA   $0C01
4887-   AD E5 02    LDA   $02E5
488A-   8D 02 0C    STA   $0C02
488D-   60          RTS   
```

That is very much getting ready for some low level RWTS calls.  Maybe not low
enough yet for a copy protection scheme, but let's see where this goes.  Back to
the code block that is going to call the memory wipe:

```text
; Store the read command in our IOB
3AD9-   A9 01       LDA   #$01
3ADB-   8D EC 02    STA   $02EC
; Call RTWS
3ADE-   A0 E0       LDY   #$E0
3AE0-   A9 02       LDA   #$02
3AE2-   20 D9 03    JSR   $03D9
; Get the slot in $x0 form, convert to $Bx and store
3AE5-   AD E1 02    LDA   $02E1
3AE8-   4A          LSR   
3AE9-   4A          LSR   
3AEA-   4A          LSR   
3AEB-   4A          LSR   
3AEC-   09 B0       ORA   #$B0
3AEE-   8D 8D 4F    STA   $4F8D
; Something mysterious. Call the routine at $3B08 three times in a row.
; If any of the three values returned in the accumulator is different,
; branch to the routine exit.  Otherwise fall through to the jump that
; ultimately clears memory and drops into BASIC.
3AF1-   20 08 3B    JSR   $3B08
3AF4-   85 82       STA   $82
3AF6-   20 08 3B    JSR   $3B08
3AF9-   C5 82       CMP   $82
3AFB-   D0 0A       BNE   $3B07
3AFD-   20 08 3B    JSR   $3B08
3B00-   C5 82       CMP   $82
3B02-   D0 03       BNE   $3B07
3B04-   4C BF 2C    JMP   $2CBF
3B07-   60          RTS   
```

There's the jump to the memory wipe at the end.  Whatever the routine at `$3B08`
is, it's important.  Its return values determine whether or not to wipe memory
and terminate.

Let's have a look at it:

```text
; Load X with the disk slot in $x0 form.
3B08-   AE E1 02    LDX   $02E1
; Search for a $D5 nibble, reading from the data latch
3B0B-   BD 8C C0    LDA   $C08C,X
3B0E-   10 FB       BPL   $3B0B
3B10-   C9 D5       CMP   #$D5
3B12-   D0 F4       BNE   $3B08
3B14-   EA          NOP   
; Search for a $AA nibble, reading from the data latch
3B15-   BD 8C C0    LDA   $C08C,X
3B18-   10 FB       BPL   $3B15
3B1A-   C9 AA       CMP   #$AA
3B1C-   D0 F2       BNE   $3B10
3B1E-   EA          NOP   
; Search for a $96 nibble, reading from the data latch
3B1F-   BD 8C C0    LDA   $C08C,X
3B22-   10 FB       BPL   $3B1F
3B24-   C9 96       CMP   #$96
3B26-   D0 E8       BNE   $3B10
3B28-   EA          NOP   
3B29-   EA          NOP
; Read the next two nibbles and return the 4+4 encoded byte
3B2A-   BD 8C C0    LDA   $C08C,X
3B2D-   10 FB       BPL   $3B2A
3B2F-   2A          ROL   
3B30-   85 80       STA   $80
3B32-   BD 8C C0    LDA   $C08C,X
3B35-   10 FB       BPL   $3B32
3B37-   25 80       AND   $80
3B39-   60          RTS   
```

Ok, this is interesting.  The direct access to the drive data latch is low level
enough that this is probably the copy protection scheme we are looking for. What
this routine does is wait for the next sector header field to pass under the
drive head and return the first 4+4 encoded byte from that header, which will be
the disk volume number.

There is a slight oddity about this code with respect to ordinary disk access
code that uses the drive controller registers.  The motor isn't being turned on
or off.  That can be explained by looking back at the code at `$3AD9`.  It makes
an RWTS call to read which ever sector was last read and then does nothing with
the data.  The effect of making that call will be to start the drive motor and
wait for it to come up to speed.  RWTS will turn off the motor before it returns
it but Apple II disk drives have a one second delay before the motor is actually
turned off.  If the motor is turned on again before the end of the delay then
the drive will already be up to speed making the next access faster.

But for one second after the motor is last "turned off," the disk is still
spinning and if you're quick you can still get valid nibbles from the disk
controller data latch.

With that knowledge, and the knowledge previously gained about nibble format of
a working disk, we now know what the copy protection mechanism is.  The Apple
Writer IIe disk was formatted in a special way such that the volume number
stored in every sector was different.  Sector based copiers, such as `COPYA`
will initialise a new disk with a single constant volume number in the sector
headers before copying the sector data fields.  When the copy protection check
runs on such a disk, it fails.  And this is also why bit copiers work.  They
copy all the different volume numbers fields as is.

### Removing the Protection

An easy way to disarm the copy protection is to allow the check to be made, but
to avoid wiping memory and exiting when it fails.  This can be achieved by
replacing the three bytes at `$3B04` with `$EA` and create a `NOP` sled.  There
are other ways, but the sequence `4C BF 2C` should be reasonably unique and make
this piece of code easy to find and patch with a sector editor.

So that's what we'll do. Make a 140k DOS ordered disk image from the WOZ file,
either by exporting one from Applesauce or by using `COPYA`, and then patch it.

Searching for `4C BF 2C` produces just the one result at `T07,S0C,$08`. Patch
that to `EA EA EA` and boot.

This time Apple Writer IIe starts up just like it does for the WOZ image. Job
done.

### What Do You Mean There's More?

There are four files on the disk that look like they might contain program code:

* `OBJ.BOOT`
* `OBJ.APWRT][D`
* `OBJ.APWRT][E`
* `OBJ.APWRT][F`

What relationship does `T07,S0C` have to them?  Getting a track and sector map
for `OBJ.APWRT][F`, with either Applesauce or an Apple II sector editor program,
shows that this is file we just patched.  It's a binary file that loads at
`$1900` and is `$30D1` bytes long.

What about the other three files? What do they do?

Well, `OBJ.BOOT` seems self explanatory.  It's the initial program started by
DOS.  We can verify that.  When standard DOS 3.3 boots, it's executes the
program listed in the primary filename buffer.  This is something of a
simplification, but it's enough to be going on with now.

On a normal DOS 3.3 disk, DOS itself is stored on tracks 0 to 2, and the primary
the primary filename buffer is at `T01,S09,$75`.  Whether or not this is a
completely normal version of DOS 3.3 is still up for debate, but looking at
`T01,S09,$75` reveals the string `OBJ.BOOT`.  That's good enough.

The program `OBJ.BOOT` loads at `$1C00`.  Following is a couple relevant
fragments after being analysed with Ghidra.

```text
                     Initialise stack.
1c00 a2 ff           LDX        #0xff
1c02 9a              TXS
1c03 20 58 fc        JSR        HOME
                     **************************************************************
                     * Determine which object file to load next                   *
                     **************************************************************
1c06 ad 0a fb        LDA        offset BOOT_TITLE                                = ??
1c09 c9 f0           CMP        #CHAR_p
1c0b d0 3a           BNE        obj_set
1c0d ce 3d 1d        DEC        IS_IIE
1c10 a9 c5           LDA        #CHAR_E
1c12 8d d9 1d        STA        s_D,A$2300_1dc7+18                               = "D,A$2300\r",00h
1c15 8d 01 c0        STA        80STORE
1c18 8d 55 c0        STA        PAGE2ON
1c1b a9 a5           LDA        #0xa5
1c1d 8d ff 07        STA        DAT_07ff
1c20 4d ff 07        EOR        DAT_07ff
1c23 d0 22           BNE        obj_set
1c25 a9 5a           LDA        #0x5a
1c27 8d ff 07        STA        DAT_07ff
1c2a 4d ff 07        EOR        DAT_07ff
1c2d d0 18           BNE        obj_set
1c2f a9 c0           LDA        #0xc0
1c31 8d 3e 1d        STA        CAPABILITIES
1c34 a9 a5           LDA        #0xa5
1c36 20 3f 1d        JSR        TEST_AUX_RAM                                     bool TEST_AUX_RAM(char testValue)
1c39 b0 0c           BCS        obj_set
1c3b a9 5a           LDA        #0x5a
1c3d 20 3f 1d        JSR        TEST_AUX_RAM                                     bool TEST_AUX_RAM(char testValue)
1c40 b0 05           BCS        obj_set
1c42 a9 c6           LDA        #CHAR_F
1c44 8d d9 1d        STA        s_D,A$2300_1dc7+18                               = "D,A$2300\r",00h
                     obj_set                                         XREF[5]:     1c0b(j), 1c23(j), 1c2d(j), 
                                                                                  1c39(j), 1c40(j)  
1c47 8d 0c c0        STA        80COLOFF
1c4a 8d 54 c0        STA        PAGE2OFF
                     **************************************************************
                     * Load next oject file at $2300                              *
                     **************************************************************
1c4d 20 ea 1d        JSR        INIT_STUFF                                       void INIT_STUFF(void)
1c50 20 b9 1d        JSR        LOAD_NEXT_OBJ
```

```text
                     **************************************************************
                     *                         SUBROUTINE                         *
                     **************************************************************
                     LOAD_NEXT_OBJ                                   XREF[1]:     1c50(c)  
1db9 a0 00           LDY        #0x0
                     next_char                                       XREF[1]:     1dc4(j)  
1dbb b9 c7 1d        LDA        s_NEXT_OBJ,Y                                     = "\r",84h,"BLOADOBJ.APWRT][D,A$
1dbe f0 06           BEQ        exit
1dc0 20 ed fd        JSR        COUT                                             void COUT(char output)
1dc3 c8              INY
1dc4 d0 f5           BNE        next_char
                     exit                                            XREF[1]:     1dbe(j)  
1dc6 60              RTS
                     s_D,A$2300_1dd9                                 XREF[1,3]:   1dbb(R), 1c12(W), 1c44(W), 
                     s_NEXT_OBJ                                                   1cef(R)  
1dc7 8d 84 c2        ds         "\r",84h,"BLOADOBJ.APWRT][D,A$2300\r",00h
     cc cf c1 
     c4 cf c2 
```

The routine `LOAD_NEXT_OBJ` "prints" the string at $1DC7.  Because the string
starts with a `CTRL-D` character and the character output vector is intercepted
by DOS 3.3, the string will be executed as a DOS command.

But before `LOAD_NEXT_OBJ` is called, a number of tests are performed and the
file name is modified depending on the test results. The filename is initially
`OBJ.APWRT][D`.  If the computer is determined to be an Apple IIe, the filename
is updated to `OBJ.APWRT][E`.  If the test for an extended Apple 80 column card
passes then the filename is updated to `OBJ.APWRT][F`.

A text version of the full Ghidra mark up is included as
[OBJ.BOOT.txt](OBJ.BOOT.txt).

A 128k Apple IIe runs `OBJ.APWRT][F`, a 64k Apple IIe will run `OBJ.APWRT][E`,
and an Apple \]\[, or \]\[+, will run `OBJ.APWRT][D`.  To test, I'll reconfigure
Applewin to run as an Apple ][+.  Rebooting with Apple Writer IIe produces the
following output:

```text
  THIS  VERSION OF APPLE WRITER // HAS  
  BEEN  DEVELOPED  TO RUN ON THE APPLE  
  //E COMPUTER ONLY.                    
                                        
  PLEASE  CONTACT  YOUR LOCAL COMPUTER  
  DEALER FOR THE CORRECT VERSION.       
```

This text can be seen in the file `OBJ.APWRT][D` with Ciderpress.

That just leaves `OBJ.APWRT][E`.  Does it perform the same copy protection
check?

The copy protection check as seen so far reads from the disk controller data
latch with an absolute indexed X load of the accumulator, where the X index
register contains the slot I/O memory offset:

```text
3B0B-   BD 8C C0    LDA   $C08C,X
```

This is common. It's how the DOS 3.3 RWTS code reads nibbles from disk.  Perhaps
this can be used to find the same copy protection check in `OBJ.APWRT][E`?

Using a sector editor hex byte search for `BD 8C C0`, we get the following
result:

```text
------------- DISK SEARCH --------------
                                        
$00/$02-$75   $00/$02-$8B   $00/$02-$B4 
$00/$02-$E1   $00/$02-$EB   $00/$02-$F6 
$00/$03-$2F   $00/$03-$39   $00/$03-$4F 
$00/$03-$59   $00/$03-$64   $00/$03-$71 
$00/$03-$79   $00/$03-$8B   $00/$03-$95 
$00/$06-$A4   $00/$06-$C0   $00/$07-$27 
$00/$07-$37   $00/$07-$3C   $04/$0C-$B8 
$04/$0C-$C2   $04/$0C-$CC   $04/$0C-$D7 
$04/$0C-$DF   $07/$0C-$0F   $07/$0C-$19 
$07/$0C-$23   $07/$0C-$2E   $07/$0C-$36 
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
             PRESS [RETURN]             
```

We can discount the search hits on track 0. That will be DOS 3.3 itself.  The
five search hits in `T07,S0C` are accounted for by `OBJ.APWRT][F`.  That just
leaves `T04,S0C`, which a track and sector list shows is part of `OBJ.APWRT][E`.

If we do a disassembly of `T04,S0C` we get:

```text
----------- DISASSEMBLY MODE -----------
00A1:85 82          STA   $82           
00A3:20 B1 39       JSR   $39B1         
00A6:C5 82          CMP   $82           
00A8:D0 0A          BNE   $00B4         
00AA:20 B1 39       JSR   $39B1         
00AD:C5 82          CMP   $82           
00AF:D0 03          BNE   $00B4         
00B1:4C EC 2B       JMP   $2BEC         
00B4:60             RTS                 
00B5:AE E1 02       LDX   $02E1         
00B8:BD 8C C0       LDA   $C08C,X       
00BB:10 FB          BPL   $00B8         
00BD:C9 D5          CMP   #$D5          
00BF:D0 F4          BNE   $00B5         
00C1:EA             NOP                 
00C2:BD 8C C0       LDA   $C08C,X       
00C5:10 FB          BPL   $00C2         
00C7:C9 AA          CMP   #$AA          
00C9:D0 F2          BNE   $00BD         
00CB:EA             NOP                 
00CC:BD 8C C0       LDA   $C08C,X       
00CF:10 FB          BPL   $00CC         
00D1:C9 96          CMP   #$96          
```

That very much looks like the routines in `OBJ.APWRT][F` that read the volume
number and test that they different.  As a check, we'll load `OBJ.APWRT][E` at
`$2300` and list from `$2BEC`.

```text
2BEC-   20 84 48    JSR   $4884         
2BEF-   A0 60       LDY   #$60          
2BF1-   B9 FD 2B    LDA   $2BFD,Y       
2BF4-   99 00 02    STA   $0200,Y       
2BF7-   88          DEY                 
2BF8-   10 F7       BPL   $2BF1         
2BFA-   4C 00 02    JMP   $0200         
```

That is the same code that acts as a spring board to the memory wipe.  Meaning
that all we have to is patch the bytes `4C EC 2B` at `T04,S0C,$B1` to `EA EA
EA`.

The patched 140k DOS order disk image is available as [Apple Writer II for the
IIe.do](Apple%20Writer%20II%20for%20the%20IIe.do)

## More To Discover

Apple Writer IIe was written before the introduction of the Apple IIc, which
introduced Mouse Text.  Mouse Text updated 32 characters of the alternate
character set to be glyphs that could draw a mouse driven user interface.  These
replace one copy of the inverse upper case characters in the alternate character
set; the copy that Apple Writer IIe uses. On an Apple II with Mouse Text (IIc,
enhanced IIe, IIgs) the Apple Writer IIe display appears corrupted because it is
showing Mouse Text instead of inverse upper case letters. This was fixed by
Apple Writer 2.0.

The version of DOS 3.3 on the Apple Writer IIe disk is not standard.  It loads
itself into the language card with bank 2 switched on.  The cold start entry is
at `$D584` and the primary filename buffer, with the boot filename, is at
`$E275`. Compare to a normal 48k image of DOS 3.3 where the addresses are
`$9684` and `$AA75` respectively.  It co-resides in the language card with a
copy of the Apple II monitor.

Here are links to different versions of Apple Writer:

* [Apple Writer 1.0][^9]
* [Apple Writer 1.1][^10]
* [Apple Writer II][^2]
* [Apple Writer IIe](Apple%20Writer%20II%20for%20the%20IIe.do)
* [Apple Writer 2.0][^11]
* [Apple Writer 2.0 Training (40 column)][^12]
* [Apple Writer 2.0 Training (80 column)][^13]
* [Apple Writer 2.1 Update][^14]
* [Apple Writer 2.1][^15]

[^9]: <https://archive.org/details/Apple_Writer_1.0_1979_Paul_Lutus>
[^10]: <https://archive.org/details/apple-writer-a2-v1.1-ph/components/apple%20writer%20-%20manual/>
[^11]: <https://archive.org/details/e2gs_0277_Apple_Writer_2.0>
[^12]: <https://ia800908.us.archive.org/6/items/sdancer_a2rs/AppleWriterIi-Disk1SideA.a2r>
[^13]: <https://ia800908.us.archive.org/6/items/sdancer_a2rs/AppleWriterIi-Disk1SideB.a2r>
[^14]: <https://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Software/Applications/Apple%20Writer%20II/Disk%20Images/>
[^15]: <https://archive.org/details/LOGIC_AppleII_Disk-P8A011>

<!-- cspell:ignoreRegExp /`.*`/-->
<!-- cspell:ignore Vignau Ghidra -->
<!-- cspell:words Applesoft Applewin Ciderpress RWTS -->