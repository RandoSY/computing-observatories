; ==============================================================
; ★ NUGGET 65C02 MARQUEE APPLICATION — R&G SHOW / 10-BIT ADC ANNUNCIATOR
; ==============================================================
;
; PURPOSE
;   Turn one analog voltage sample into a human-readable ten-bit
;   message using only two LEDs and a buzzer. You do not have to watch
;   the board continuously: the pitch tells you the bit while the LED
;   gives redundant visual evidence.
;
; PROTOCOL — identical to the Forth R&G SHOW
;   1. Sample the ADC ONCE.
;   2. Ready beep: 880 Hz, then a preparation pause.
;   3. Transmit ten bits MSB first (bit 9 ... bit 0):
;        0 = RED   +  440 Hz low tone
;        1 = GREEN + 1100 Hz high tone
;      Each bit has enough dwell time to write it down.
;   4. Finish with two closely spaced 880 Hz beeps.
;   5. As each bit is announced, shift it into the $8000 D7..D0
;      R/G record. After ten bits the bank holds ADC bits 7..0.
;   6. Stop with the sampled 10-bit value preserved in
;      SAMPLE_HI:SAMPLE_LO and its low byte visible at $8000.
;
; HUMAN-TIME NOTE
;   Delay loops are calibrated for the Studio default of 80
;   instructions/sec. Keep the speed slider at 80 for the intended
;   cadence. On physical Nugget hardware the same application would
;   use a millisecond/VIA timer service.
;
; HARDWARE MAP
LAB_LEDS   = $8000
LAB_BUZZER = $8002
ADC_LO     = $8004
ADC_HI     = $8005
TONE_LO    = $8007
TONE_HI    = $8008
VIA_ORB    = $8100
VIA_DDRB   = $8102

LED_RED    = %00000001
LED_GREEN  = %00000100
LED_MASK   = %00000111

SAMPLE_LO  = $20
SAMPLE_HI  = $21
TX_LO      = $22
TX_HI      = $23
LED_RECORD = $24

.org $0200
start:
    SEI
    CLD

    LDA #LED_MASK
    STA VIA_DDRB
    STZ VIA_ORB
    STZ LAB_LEDS
    STZ LED_RECORD
    STZ LAB_BUZZER

    JSR sample_adc10
    JSR ready_signal
    JSR transmit_10_bits
    JSR finish_signal

    STZ VIA_ORB
    STZ LAB_BUZZER
    STP

sample_adc10:
    LDA ADC_LO
    STA TX_LO
    LDA ADC_HI
    AND #$0F
    STA TX_HI

    LSR TX_HI
    ROR TX_LO
    LSR TX_HI
    ROR TX_LO

    LDA TX_LO
    STA SAMPLE_LO
    LDA TX_HI
    STA SAMPLE_HI
    RTS

ready_signal:
    STZ VIA_ORB
    LDA #$70
    STA TONE_LO
    LDA #$03
    STA TONE_HI
    LDA #$01
    STA LAB_BUZZER
    JSR delay_220
    STZ LAB_BUZZER
    JSR delay_800
    RTS

transmit_10_bits:
    LDY #10
next_bit:
    LDA TX_HI
    AND #$02
    BEQ send_zero_bit

    JSR record_one
    JSR send_one
    BRA shift_for_next

send_zero_bit:
    JSR record_zero
    JSR send_zero

shift_for_next:
    ASL TX_LO
    ROL TX_HI
    DEY
    BNE next_bit
    RTS

record_zero:
    LDA LED_RECORD
    ASL A
    STA LED_RECORD
    STA LAB_LEDS
    RTS

record_one:
    LDA LED_RECORD
    ASL A
    ORA #$01
    STA LED_RECORD
    STA LAB_LEDS
    RTS

send_zero:
    LDA #LED_RED
    STA VIA_ORB
    LDA #$B8
    STA TONE_LO
    LDA #$01
    STA TONE_HI
    LDA #$01
    STA LAB_BUZZER
    JSR delay_550
    STZ LAB_BUZZER
    JSR delay_550
    STZ VIA_ORB
    JSR delay_150
    RTS

send_one:
    LDA #LED_GREEN
    STA VIA_ORB
    LDA #$4C
    STA TONE_LO
    LDA #$04
    STA TONE_HI
    LDA #$01
    STA LAB_BUZZER
    JSR delay_550
    STZ LAB_BUZZER
    JSR delay_550
    STZ VIA_ORB
    JSR delay_150
    RTS

finish_signal:
    STZ VIA_ORB
    LDA #$70
    STA TONE_LO
    LDA #$03
    STA TONE_HI

    LDA #$01
    STA LAB_BUZZER
    JSR delay_160
    STZ LAB_BUZZER
    JSR delay_120
    LDA #$01
    STA LAB_BUZZER
    JSR delay_160
    STZ LAB_BUZZER
    RTS

delay_120:
    LDX #3
D120: DEX
    BNE D120
    RTS

delay_150:
    LDX #3
D150: DEX
    BNE D150
    RTS

delay_160:
    LDX #4
D160: DEX
    BNE D160
    RTS

delay_220:
    LDX #6
D220: DEX
    BNE D220
    RTS

delay_550:
    LDX #17
D550: DEX
    BNE D550
    RTS

delay_800:
    LDX #24
D800: DEX
    BNE D800
    RTS
