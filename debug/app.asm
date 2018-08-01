
bin/app.elf:     file format elf32-littlearm


Disassembly of section .text:

c0d00000 <main>:
    // command has been processed, DO NOT reset the current APDU transport
    return 1;
}

/** boot up the app and intialize it */
__attribute__((section(".boot"))) int main(void) {
c0d00000:	b5b0      	push	{r4, r5, r7, lr}
c0d00002:	b08c      	sub	sp, #48	; 0x30
    // exit critical section
    __asm volatile("cpsie i");
c0d00004:	b662      	cpsie	i

    curr_scr_ix = 0;
c0d00006:	4824      	ldr	r0, [pc, #144]	; (c0d00098 <main+0x98>)
c0d00008:	2400      	movs	r4, #0
c0d0000a:	6004      	str	r4, [r0, #0]
    max_scr_ix = 0;
c0d0000c:	4823      	ldr	r0, [pc, #140]	; (c0d0009c <main+0x9c>)
c0d0000e:	6004      	str	r4, [r0, #0]
    raw_tx_ix = 0;
c0d00010:	4823      	ldr	r0, [pc, #140]	; (c0d000a0 <main+0xa0>)
c0d00012:	6004      	str	r4, [r0, #0]
    hashTainted = 1;
c0d00014:	4823      	ldr	r0, [pc, #140]	; (c0d000a4 <main+0xa4>)
c0d00016:	2101      	movs	r1, #1
c0d00018:	7001      	strb	r1, [r0, #0]
    uiState = UI_IDLE;
c0d0001a:	4823      	ldr	r0, [pc, #140]	; (c0d000a8 <main+0xa8>)
c0d0001c:	7001      	strb	r1, [r0, #0]

    // ensure exception will work as planned
    os_boot();
c0d0001e:	f001 f82d 	bl	c0d0107c <os_boot>

    UX_INIT();
c0d00022:	4822      	ldr	r0, [pc, #136]	; (c0d000ac <main+0xac>)
c0d00024:	22b0      	movs	r2, #176	; 0xb0
c0d00026:	4621      	mov	r1, r4
c0d00028:	f001 f8d6 	bl	c0d011d8 <os_memset>
c0d0002c:	ad01      	add	r5, sp, #4

    BEGIN_TRY
    {
        TRY
c0d0002e:	4628      	mov	r0, r5
c0d00030:	f004 fc9e 	bl	c0d04970 <setjmp>
c0d00034:	8528      	strh	r0, [r5, #40]	; 0x28
c0d00036:	491e      	ldr	r1, [pc, #120]	; (c0d000b0 <main+0xb0>)
c0d00038:	4208      	tst	r0, r1
c0d0003a:	d002      	beq.n	c0d00042 <main+0x42>
c0d0003c:	a801      	add	r0, sp, #4
            Timer_Set();

            // run main event loop.
            ont_main();
        }
        CATCH_OTHER(e)
c0d0003e:	8504      	strh	r4, [r0, #40]	; 0x28
c0d00040:	e017      	b.n	c0d00072 <main+0x72>
c0d00042:	a801      	add	r0, sp, #4

    UX_INIT();

    BEGIN_TRY
    {
        TRY
c0d00044:	f001 f81d 	bl	c0d01082 <try_context_set>
        {
            io_seproxyhal_init();
c0d00048:	f001 fab8 	bl	c0d015bc <io_seproxyhal_init>
c0d0004c:	2000      	movs	r0, #0
                // restart IOs
                BLE_power(1, NULL);
            }
#endif

            USB_power(0);
c0d0004e:	f004 f9f3 	bl	c0d04438 <USB_power>
            USB_power(1);
c0d00052:	2001      	movs	r0, #1
c0d00054:	f004 f9f0 	bl	c0d04438 <USB_power>

            // init the public key display to "no public key".
            //display_no_public_key();

            // show idle screen.
            ui_idle();
c0d00058:	f002 fd52 	bl	c0d02b00 <ui_idle>
        Timer_UpdateDescription();
    }
}

static void Timer_Set() {
    exit_timer = MAX_EXIT_TIMER;
c0d0005c:	4815      	ldr	r0, [pc, #84]	; (c0d000b4 <main+0xb4>)
c0d0005e:	4916      	ldr	r1, [pc, #88]	; (c0d000b8 <main+0xb8>)
c0d00060:	6001      	str	r1, [r0, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d00062:	4816      	ldr	r0, [pc, #88]	; (c0d000bc <main+0xbc>)
c0d00064:	2104      	movs	r1, #4
c0d00066:	a216      	add	r2, pc, #88	; (adr r2, c0d000c0 <main+0xc0>)
c0d00068:	2308      	movs	r3, #8
c0d0006a:	f001 fd93 	bl	c0d01b94 <snprintf>

            // set timer
            Timer_Set();

            // run main event loop.
            ont_main();
c0d0006e:	f000 fb81 	bl	c0d00774 <ont_main>
        }
        CATCH_OTHER(e)
        {
        }
        FINALLY
c0d00072:	f001 f973 	bl	c0d0135c <try_context_get>
c0d00076:	a901      	add	r1, sp, #4
c0d00078:	4288      	cmp	r0, r1
c0d0007a:	d103      	bne.n	c0d00084 <main+0x84>
c0d0007c:	f001 f970 	bl	c0d01360 <try_context_get_previous>
c0d00080:	f000 ffff 	bl	c0d01082 <try_context_set>
c0d00084:	a801      	add	r0, sp, #4
        {
        }
    }
    END_TRY;
c0d00086:	8d00      	ldrh	r0, [r0, #40]	; 0x28
c0d00088:	2800      	cmp	r0, #0
c0d0008a:	d102      	bne.n	c0d00092 <main+0x92>
}
c0d0008c:	2000      	movs	r0, #0
c0d0008e:	b00c      	add	sp, #48	; 0x30
c0d00090:	bdb0      	pop	{r4, r5, r7, pc}
        }
        FINALLY
        {
        }
    }
    END_TRY;
c0d00092:	f001 f95e 	bl	c0d01352 <os_longjmp>
c0d00096:	46c0      	nop			; (mov r8, r8)
c0d00098:	20002028 	.word	0x20002028
c0d0009c:	2000202c 	.word	0x2000202c
c0d000a0:	20001f64 	.word	0x20001f64
c0d000a4:	20001f60 	.word	0x20001f60
c0d000a8:	20001f68 	.word	0x20001f68
c0d000ac:	20001f6c 	.word	0x20001f6c
c0d000b0:	0000ffff 	.word	0x0000ffff
c0d000b4:	2000201c 	.word	0x2000201c
c0d000b8:	00001002 	.word	0x00001002
c0d000bc:	20002020 	.word	0x20002020
c0d000c0:	00006425 	.word	0x00006425

c0d000c4 <cx_hash_X>:
}

int cx_hash_X(cx_hash_t *hash ,
              int mode,
              unsigned char WIDE *in , unsigned int len,
              unsigned char *out) {
c0d000c4:	b570      	push	{r4, r5, r6, lr}
c0d000c6:	b082      	sub	sp, #8
c0d000c8:	7805      	ldrb	r5, [r0, #0]
c0d000ca:	2414      	movs	r4, #20
   unsigned int hsz = 0;

    switch (hash->algo) {
c0d000cc:	2d03      	cmp	r5, #3
c0d000ce:	dc07      	bgt.n	c0d000e0 <cx_hash_X+0x1c>
c0d000d0:	2d01      	cmp	r5, #1
c0d000d2:	d013      	beq.n	c0d000fc <cx_hash_X+0x38>
c0d000d4:	2d02      	cmp	r5, #2
c0d000d6:	d00e      	beq.n	c0d000f6 <cx_hash_X+0x32>
c0d000d8:	2d03      	cmp	r5, #3
c0d000da:	d117      	bne.n	c0d0010c <cx_hash_X+0x48>
c0d000dc:	2420      	movs	r4, #32
c0d000de:	e00d      	b.n	c0d000fc <cx_hash_X+0x38>
c0d000e0:	1fac      	subs	r4, r5, #6
c0d000e2:	2c03      	cmp	r4, #3
c0d000e4:	d201      	bcs.n	c0d000ea <cx_hash_X+0x26>
        hsz = 64;
        break;
    case CX_SHA3:
    case CX_KECCAK:
    case CX_SHA3_XOF:
        hsz =   ((cx_sha3_t*)hash)->output_size;
c0d000e6:	6884      	ldr	r4, [r0, #8]
c0d000e8:	e008      	b.n	c0d000fc <cx_hash_X+0x38>
c0d000ea:	2d04      	cmp	r5, #4
c0d000ec:	d005      	beq.n	c0d000fa <cx_hash_X+0x36>
c0d000ee:	2d05      	cmp	r5, #5
c0d000f0:	d10c      	bne.n	c0d0010c <cx_hash_X+0x48>
c0d000f2:	2440      	movs	r4, #64	; 0x40
c0d000f4:	e002      	b.n	c0d000fc <cx_hash_X+0x38>
c0d000f6:	241c      	movs	r4, #28
c0d000f8:	e000      	b.n	c0d000fc <cx_hash_X+0x38>
c0d000fa:	2430      	movs	r4, #48	; 0x30
c0d000fc:	9d06      	ldr	r5, [sp, #24]
    default:
        THROW(INVALID_PARAMETER);
        return 0;
    }

    return cx_hash(hash, mode, in, len, out, hsz);
c0d000fe:	466e      	mov	r6, sp
c0d00100:	6035      	str	r5, [r6, #0]
c0d00102:	6074      	str	r4, [r6, #4]
c0d00104:	f001 ffb6 	bl	c0d02074 <cx_hash>
c0d00108:	b002      	add	sp, #8
c0d0010a:	bd70      	pop	{r4, r5, r6, pc}
    case CX_SHA3_XOF:
        hsz =   ((cx_sha3_t*)hash)->output_size;
        break;
    
    default:
        THROW(INVALID_PARAMETER);
c0d0010c:	2002      	movs	r0, #2
c0d0010e:	f001 f920 	bl	c0d01352 <os_longjmp>

c0d00112 <cx_ecfp_get_domain_length>:
    exponent[3] = pub_exponent>>0;

    return cx_rsa_generate_pair(modulus_len, public_key, private_key, exponent, 4, externalPQ);
}

static unsigned int cx_ecfp_get_domain_length(cx_curve_t curve) {
c0d00112:	b580      	push	{r7, lr}
c0d00114:	4601      	mov	r1, r0
c0d00116:	2020      	movs	r0, #32
    switch(curve) {
c0d00118:	2928      	cmp	r1, #40	; 0x28
c0d0011a:	dd0b      	ble.n	c0d00134 <cx_ecfp_get_domain_length+0x22>
c0d0011c:	292c      	cmp	r1, #44	; 0x2c
c0d0011e:	dd15      	ble.n	c0d0014c <cx_ecfp_get_domain_length+0x3a>
c0d00120:	2941      	cmp	r1, #65	; 0x41
c0d00122:	dd24      	ble.n	c0d0016e <cx_ecfp_get_domain_length+0x5c>
c0d00124:	2942      	cmp	r1, #66	; 0x42
c0d00126:	d02d      	beq.n	c0d00184 <cx_ecfp_get_domain_length+0x72>
c0d00128:	2961      	cmp	r1, #97	; 0x61
c0d0012a:	d02c      	beq.n	c0d00186 <cx_ecfp_get_domain_length+0x74>
c0d0012c:	2962      	cmp	r1, #98	; 0x62
c0d0012e:	d12b      	bne.n	c0d00188 <cx_ecfp_get_domain_length+0x76>
c0d00130:	2038      	movs	r0, #56	; 0x38
    default:
        break;
    }
    THROW(INVALID_PARAMETER);
    return 0;
}
c0d00132:	bd80      	pop	{r7, pc}
c0d00134:	460a      	mov	r2, r1
c0d00136:	2924      	cmp	r1, #36	; 0x24
c0d00138:	dc10      	bgt.n	c0d0015c <cx_ecfp_get_domain_length+0x4a>
c0d0013a:	3a21      	subs	r2, #33	; 0x21
c0d0013c:	2a02      	cmp	r2, #2
c0d0013e:	d322      	bcc.n	c0d00186 <cx_ecfp_get_domain_length+0x74>
c0d00140:	2923      	cmp	r1, #35	; 0x23
c0d00142:	d009      	beq.n	c0d00158 <cx_ecfp_get_domain_length+0x46>
c0d00144:	2924      	cmp	r1, #36	; 0x24
c0d00146:	d11f      	bne.n	c0d00188 <cx_ecfp_get_domain_length+0x76>
c0d00148:	2042      	movs	r0, #66	; 0x42
c0d0014a:	bd80      	pop	{r7, pc}
c0d0014c:	292a      	cmp	r1, #42	; 0x2a
c0d0014e:	dc13      	bgt.n	c0d00178 <cx_ecfp_get_domain_length+0x66>
c0d00150:	2929      	cmp	r1, #41	; 0x29
c0d00152:	d001      	beq.n	c0d00158 <cx_ecfp_get_domain_length+0x46>
c0d00154:	292a      	cmp	r1, #42	; 0x2a
c0d00156:	d117      	bne.n	c0d00188 <cx_ecfp_get_domain_length+0x76>
c0d00158:	2030      	movs	r0, #48	; 0x30
c0d0015a:	bd80      	pop	{r7, pc}
c0d0015c:	3a25      	subs	r2, #37	; 0x25
c0d0015e:	2a02      	cmp	r2, #2
c0d00160:	d311      	bcc.n	c0d00186 <cx_ecfp_get_domain_length+0x74>
c0d00162:	2927      	cmp	r1, #39	; 0x27
c0d00164:	d001      	beq.n	c0d0016a <cx_ecfp_get_domain_length+0x58>
c0d00166:	2928      	cmp	r1, #40	; 0x28
c0d00168:	d10e      	bne.n	c0d00188 <cx_ecfp_get_domain_length+0x76>
c0d0016a:	2028      	movs	r0, #40	; 0x28
c0d0016c:	bd80      	pop	{r7, pc}
c0d0016e:	292d      	cmp	r1, #45	; 0x2d
c0d00170:	d009      	beq.n	c0d00186 <cx_ecfp_get_domain_length+0x74>
c0d00172:	2941      	cmp	r1, #65	; 0x41
c0d00174:	d007      	beq.n	c0d00186 <cx_ecfp_get_domain_length+0x74>
c0d00176:	e007      	b.n	c0d00188 <cx_ecfp_get_domain_length+0x76>
c0d00178:	292b      	cmp	r1, #43	; 0x2b
c0d0017a:	d001      	beq.n	c0d00180 <cx_ecfp_get_domain_length+0x6e>
c0d0017c:	292c      	cmp	r1, #44	; 0x2c
c0d0017e:	d103      	bne.n	c0d00188 <cx_ecfp_get_domain_length+0x76>
c0d00180:	2040      	movs	r0, #64	; 0x40
c0d00182:	bd80      	pop	{r7, pc}
c0d00184:	2039      	movs	r0, #57	; 0x39
c0d00186:	bd80      	pop	{r7, pc}
    case CX_CURVE_Curve448:
        return 56;
    default:
        break;
    }
    THROW(INVALID_PARAMETER);
c0d00188:	2002      	movs	r0, #2
c0d0018a:	f001 f8e2 	bl	c0d01352 <os_longjmp>

c0d0018e <cx_ecdsa_sign_X>:
}

int cx_ecdsa_sign_X(cx_ecfp_private_key_t WIDE *pv_key,
                    int mode,  cx_md_t hashID, unsigned char  WIDE *hash, unsigned int hash_len,
                    unsigned char *sig ,
                    unsigned int *info) {
c0d0018e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00190:	b085      	sub	sp, #20
c0d00192:	461c      	mov	r4, r3
c0d00194:	4615      	mov	r5, r2
c0d00196:	460e      	mov	r6, r1
c0d00198:	4607      	mov	r7, r0
    const unsigned int  domain_length =  cx_ecfp_get_domain_length(pv_key->curve);
c0d0019a:	7838      	ldrb	r0, [r7, #0]
c0d0019c:	f7ff ffb9 	bl	c0d00112 <cx_ecfp_get_domain_length>
c0d001a0:	990c      	ldr	r1, [sp, #48]	; 0x30
    return cx_ecdsa_sign(pv_key, mode, hashID, hash, hash_len, sig,  6+2*(domain_length+1), info);
c0d001a2:	466a      	mov	r2, sp
c0d001a4:	60d1      	str	r1, [r2, #12]
c0d001a6:	0040      	lsls	r0, r0, #1
c0d001a8:	3008      	adds	r0, #8
c0d001aa:	6090      	str	r0, [r2, #8]
c0d001ac:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d001ae:	6050      	str	r0, [r2, #4]
c0d001b0:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d001b2:	6010      	str	r0, [r2, #0]
c0d001b4:	4638      	mov	r0, r7
c0d001b6:	4631      	mov	r1, r6
c0d001b8:	462a      	mov	r2, r5
c0d001ba:	4623      	mov	r3, r4
c0d001bc:	f001 ffea 	bl	c0d02194 <cx_ecdsa_sign>
c0d001c0:	b005      	add	sp, #20
c0d001c2:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d001c4 <io_exchange_al>:
#define INS_GET_SIGNED_PUBLIC_KEY 0x08

/** #### instructions end #### */

/** some kind of event loop */
unsigned short io_exchange_al(unsigned char channel, unsigned short tx_len) {
c0d001c4:	b5b0      	push	{r4, r5, r7, lr}
c0d001c6:	4605      	mov	r5, r0
c0d001c8:	200f      	movs	r0, #15
    switch (channel & ~(IO_FLAGS)) {
c0d001ca:	4028      	ands	r0, r5
c0d001cc:	2400      	movs	r4, #0
c0d001ce:	2801      	cmp	r0, #1
c0d001d0:	d013      	beq.n	c0d001fa <io_exchange_al+0x36>
c0d001d2:	2802      	cmp	r0, #2
c0d001d4:	d113      	bne.n	c0d001fe <io_exchange_al+0x3a>
        case CHANNEL_KEYBOARD:
            break;

            // multiplexed io exchange over a SPI channel and TLV encapsulated protocol
        case CHANNEL_SPI:
            if (tx_len) {
c0d001d6:	2900      	cmp	r1, #0
c0d001d8:	d008      	beq.n	c0d001ec <io_exchange_al+0x28>
                io_seproxyhal_spi_send(G_io_apdu_buffer, tx_len);
c0d001da:	480c      	ldr	r0, [pc, #48]	; (c0d0020c <io_exchange_al+0x48>)
c0d001dc:	f002 f854 	bl	c0d02288 <io_seproxyhal_spi_send>

                if (channel & IO_RESET_AFTER_REPLIED) {
c0d001e0:	b268      	sxtb	r0, r5
c0d001e2:	2800      	cmp	r0, #0
c0d001e4:	da09      	bge.n	c0d001fa <io_exchange_al+0x36>
                    reset();
c0d001e6:	f001 ff19 	bl	c0d0201c <reset>
c0d001ea:	e006      	b.n	c0d001fa <io_exchange_al+0x36>
                }
                // nothing received from the master so far
                //(it's a tx transaction)
                return 0;
            } else {
                return io_seproxyhal_spi_recv(G_io_apdu_buffer, sizeof(G_io_apdu_buffer), 0);
c0d001ec:	21ff      	movs	r1, #255	; 0xff
c0d001ee:	3152      	adds	r1, #82	; 0x52
c0d001f0:	4806      	ldr	r0, [pc, #24]	; (c0d0020c <io_exchange_al+0x48>)
c0d001f2:	2200      	movs	r2, #0
c0d001f4:	f002 f874 	bl	c0d022e0 <io_seproxyhal_spi_recv>
c0d001f8:	4604      	mov	r4, r0
        default:
            hashTainted = 1;
            THROW(INVALID_PARAMETER);
    }
    return 0;
}
c0d001fa:	4620      	mov	r0, r4
c0d001fc:	bdb0      	pop	{r4, r5, r7, pc}
            } else {
                return io_seproxyhal_spi_recv(G_io_apdu_buffer, sizeof(G_io_apdu_buffer), 0);
            }

        default:
            hashTainted = 1;
c0d001fe:	4804      	ldr	r0, [pc, #16]	; (c0d00210 <io_exchange_al+0x4c>)
c0d00200:	2101      	movs	r1, #1
c0d00202:	7001      	strb	r1, [r0, #0]
            THROW(INVALID_PARAMETER);
c0d00204:	2002      	movs	r0, #2
c0d00206:	f001 f8a4 	bl	c0d01352 <os_longjmp>
c0d0020a:	46c0      	nop			; (mov r8, r8)
c0d0020c:	200018f8 	.word	0x200018f8
c0d00210:	20001f60 	.word	0x20001f60

c0d00214 <io_seproxyhal_display>:
    return_to_dashboard:
    return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
c0d00214:	b580      	push	{r7, lr}
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d00216:	f001 fb43 	bl	c0d018a0 <io_seproxyhal_display_default>
}
c0d0021a:	bd80      	pop	{r7, pc}

c0d0021c <io_event>:

/* io event loop */
unsigned char io_event(unsigned char channel) {
c0d0021c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0021e:	b085      	sub	sp, #20
    // nothing done with the event, throw an error on the transport layer if
    // needed

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
c0d00220:	4df1      	ldr	r5, [pc, #964]	; (c0d005e8 <io_event+0x3cc>)
c0d00222:	7829      	ldrb	r1, [r5, #0]
c0d00224:	48f1      	ldr	r0, [pc, #964]	; (c0d005ec <io_event+0x3d0>)
c0d00226:	290c      	cmp	r1, #12
c0d00228:	dc34      	bgt.n	c0d00294 <io_event+0x78>
c0d0022a:	2905      	cmp	r1, #5
c0d0022c:	d07b      	beq.n	c0d00326 <io_event+0x10a>
c0d0022e:	290c      	cmp	r1, #12
c0d00230:	d000      	beq.n	c0d00234 <io_event+0x18>
c0d00232:	e0ed      	b.n	c0d00410 <io_event+0x1f4>
    exit_timer = MAX_EXIT_TIMER;
    Timer_UpdateDescription();
}

static void Timer_Restart() {
    if (exit_timer != MAX_EXIT_TIMER) {
c0d00234:	49ee      	ldr	r1, [pc, #952]	; (c0d005f0 <io_event+0x3d4>)
c0d00236:	680a      	ldr	r2, [r1, #0]
c0d00238:	4282      	cmp	r2, r0
c0d0023a:	d006      	beq.n	c0d0024a <io_event+0x2e>
        Timer_UpdateDescription();
    }
}

static void Timer_Set() {
    exit_timer = MAX_EXIT_TIMER;
c0d0023c:	6008      	str	r0, [r1, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d0023e:	48ed      	ldr	r0, [pc, #948]	; (c0d005f4 <io_event+0x3d8>)
c0d00240:	2104      	movs	r1, #4
c0d00242:	a2ed      	add	r2, pc, #948	; (adr r2, c0d005f8 <io_event+0x3dc>)
c0d00244:	2308      	movs	r3, #8
c0d00246:	f001 fca5 	bl	c0d01b94 <snprintf>

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
        case SEPROXYHAL_TAG_FINGER_EVENT:
            Timer_Restart();
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d0024a:	4cec      	ldr	r4, [pc, #944]	; (c0d005fc <io_event+0x3e0>)
c0d0024c:	2001      	movs	r0, #1
c0d0024e:	7620      	strb	r0, [r4, #24]
c0d00250:	2600      	movs	r6, #0
c0d00252:	61e6      	str	r6, [r4, #28]
c0d00254:	4620      	mov	r0, r4
c0d00256:	3018      	adds	r0, #24
c0d00258:	f001 ffea 	bl	c0d02230 <os_ux>
c0d0025c:	61e0      	str	r0, [r4, #28]
c0d0025e:	f001 fc97 	bl	c0d01b90 <ux_check_status_default>
c0d00262:	69e0      	ldr	r0, [r4, #28]
c0d00264:	49e6      	ldr	r1, [pc, #920]	; (c0d00600 <io_event+0x3e4>)
c0d00266:	4288      	cmp	r0, r1
c0d00268:	d100      	bne.n	c0d0026c <io_event+0x50>
c0d0026a:	e274      	b.n	c0d00756 <io_event+0x53a>
c0d0026c:	2800      	cmp	r0, #0
c0d0026e:	d100      	bne.n	c0d00272 <io_event+0x56>
c0d00270:	e271      	b.n	c0d00756 <io_event+0x53a>
c0d00272:	49e4      	ldr	r1, [pc, #912]	; (c0d00604 <io_event+0x3e8>)
c0d00274:	4288      	cmp	r0, r1
c0d00276:	d000      	beq.n	c0d0027a <io_event+0x5e>
c0d00278:	e1c6      	b.n	c0d00608 <io_event+0x3ec>
c0d0027a:	f001 f9cb 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d0027e:	60a6      	str	r6, [r4, #8]
c0d00280:	6820      	ldr	r0, [r4, #0]
c0d00282:	2800      	cmp	r0, #0
c0d00284:	d100      	bne.n	c0d00288 <io_event+0x6c>
c0d00286:	e266      	b.n	c0d00756 <io_event+0x53a>
c0d00288:	69e0      	ldr	r0, [r4, #28]
c0d0028a:	49dd      	ldr	r1, [pc, #884]	; (c0d00600 <io_event+0x3e4>)
c0d0028c:	4288      	cmp	r0, r1
c0d0028e:	d000      	beq.n	c0d00292 <io_event+0x76>
c0d00290:	e11e      	b.n	c0d004d0 <io_event+0x2b4>
c0d00292:	e260      	b.n	c0d00756 <io_event+0x53a>
c0d00294:	290d      	cmp	r1, #13
c0d00296:	d076      	beq.n	c0d00386 <io_event+0x16a>
c0d00298:	290e      	cmp	r1, #14
c0d0029a:	d000      	beq.n	c0d0029e <io_event+0x82>
c0d0029c:	e0b8      	b.n	c0d00410 <io_event+0x1f4>
        UX_REDISPLAY();
    }
}

static void Timer_Tick() {
    if (exit_timer > 0) {
c0d0029e:	4df7      	ldr	r5, [pc, #988]	; (c0d0067c <io_event+0x460>)
c0d002a0:	6828      	ldr	r0, [r5, #0]
c0d002a2:	2801      	cmp	r0, #1
c0d002a4:	db0a      	blt.n	c0d002bc <io_event+0xa0>
        exit_timer--;
c0d002a6:	1e40      	subs	r0, r0, #1
c0d002a8:	6028      	str	r0, [r5, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d002aa:	17c1      	asrs	r1, r0, #31
c0d002ac:	0dc9      	lsrs	r1, r1, #23
c0d002ae:	1840      	adds	r0, r0, r1
c0d002b0:	1243      	asrs	r3, r0, #9
c0d002b2:	48f3      	ldr	r0, [pc, #972]	; (c0d00680 <io_event+0x464>)
c0d002b4:	2104      	movs	r1, #4
c0d002b6:	a2f3      	add	r2, pc, #972	; (adr r2, c0d00684 <io_event+0x468>)
c0d002b8:	f001 fc6c 	bl	c0d01b94 <snprintf>
            break;

        case SEPROXYHAL_TAG_TICKER_EVENT:
//		UX_REDISPLAY();
            Timer_Tick();
            if (publicKeyNeedsRefresh == 1) {
c0d002bc:	4cf4      	ldr	r4, [pc, #976]	; (c0d00690 <io_event+0x474>)
c0d002be:	7820      	ldrb	r0, [r4, #0]
c0d002c0:	2801      	cmp	r0, #1
c0d002c2:	d000      	beq.n	c0d002c6 <io_event+0xaa>
c0d002c4:	e12a      	b.n	c0d0051c <io_event+0x300>
                UX_REDISPLAY();
c0d002c6:	f001 f9a5 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d002ca:	4def      	ldr	r5, [pc, #956]	; (c0d00688 <io_event+0x46c>)
c0d002cc:	2000      	movs	r0, #0
c0d002ce:	60a8      	str	r0, [r5, #8]
c0d002d0:	6829      	ldr	r1, [r5, #0]
c0d002d2:	2900      	cmp	r1, #0
c0d002d4:	d024      	beq.n	c0d00320 <io_event+0x104>
c0d002d6:	69e9      	ldr	r1, [r5, #28]
c0d002d8:	4aec      	ldr	r2, [pc, #944]	; (c0d0068c <io_event+0x470>)
c0d002da:	4291      	cmp	r1, r2
c0d002dc:	d11e      	bne.n	c0d0031c <io_event+0x100>
c0d002de:	e01f      	b.n	c0d00320 <io_event+0x104>
c0d002e0:	6869      	ldr	r1, [r5, #4]
c0d002e2:	4288      	cmp	r0, r1
c0d002e4:	d21c      	bcs.n	c0d00320 <io_event+0x104>
c0d002e6:	f001 ffe5 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d002ea:	2800      	cmp	r0, #0
c0d002ec:	d118      	bne.n	c0d00320 <io_event+0x104>
c0d002ee:	68a8      	ldr	r0, [r5, #8]
c0d002f0:	68e9      	ldr	r1, [r5, #12]
c0d002f2:	2638      	movs	r6, #56	; 0x38
c0d002f4:	4370      	muls	r0, r6
c0d002f6:	682a      	ldr	r2, [r5, #0]
c0d002f8:	1810      	adds	r0, r2, r0
c0d002fa:	2900      	cmp	r1, #0
c0d002fc:	d002      	beq.n	c0d00304 <io_event+0xe8>
c0d002fe:	4788      	blx	r1
c0d00300:	2800      	cmp	r0, #0
c0d00302:	d007      	beq.n	c0d00314 <io_event+0xf8>
c0d00304:	2801      	cmp	r0, #1
c0d00306:	d103      	bne.n	c0d00310 <io_event+0xf4>
c0d00308:	68a8      	ldr	r0, [r5, #8]
c0d0030a:	4346      	muls	r6, r0
c0d0030c:	6828      	ldr	r0, [r5, #0]
c0d0030e:	1980      	adds	r0, r0, r6
    return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d00310:	f001 fac6 	bl	c0d018a0 <io_seproxyhal_display_default>

        case SEPROXYHAL_TAG_TICKER_EVENT:
//		UX_REDISPLAY();
            Timer_Tick();
            if (publicKeyNeedsRefresh == 1) {
                UX_REDISPLAY();
c0d00314:	68a8      	ldr	r0, [r5, #8]
c0d00316:	1c40      	adds	r0, r0, #1
c0d00318:	60a8      	str	r0, [r5, #8]
c0d0031a:	6829      	ldr	r1, [r5, #0]
c0d0031c:	2900      	cmp	r1, #0
c0d0031e:	d1df      	bne.n	c0d002e0 <io_event+0xc4>
                publicKeyNeedsRefresh = 0;
c0d00320:	2000      	movs	r0, #0
c0d00322:	7020      	strb	r0, [r4, #0]
c0d00324:	e217      	b.n	c0d00756 <io_event+0x53a>
    exit_timer = MAX_EXIT_TIMER;
    Timer_UpdateDescription();
}

static void Timer_Restart() {
    if (exit_timer != MAX_EXIT_TIMER) {
c0d00326:	49d5      	ldr	r1, [pc, #852]	; (c0d0067c <io_event+0x460>)
c0d00328:	680a      	ldr	r2, [r1, #0]
c0d0032a:	4282      	cmp	r2, r0
c0d0032c:	d006      	beq.n	c0d0033c <io_event+0x120>
        Timer_UpdateDescription();
    }
}

static void Timer_Set() {
    exit_timer = MAX_EXIT_TIMER;
c0d0032e:	6008      	str	r0, [r1, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d00330:	48d3      	ldr	r0, [pc, #844]	; (c0d00680 <io_event+0x464>)
c0d00332:	2104      	movs	r1, #4
c0d00334:	a2d3      	add	r2, pc, #844	; (adr r2, c0d00684 <io_event+0x468>)
c0d00336:	2308      	movs	r3, #8
c0d00338:	f001 fc2c 	bl	c0d01b94 <snprintf>
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
            break;

        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
            Timer_Restart();
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d0033c:	4cd2      	ldr	r4, [pc, #840]	; (c0d00688 <io_event+0x46c>)
c0d0033e:	2001      	movs	r0, #1
c0d00340:	7620      	strb	r0, [r4, #24]
c0d00342:	2600      	movs	r6, #0
c0d00344:	61e6      	str	r6, [r4, #28]
c0d00346:	4620      	mov	r0, r4
c0d00348:	3018      	adds	r0, #24
c0d0034a:	f001 ff71 	bl	c0d02230 <os_ux>
c0d0034e:	61e0      	str	r0, [r4, #28]
c0d00350:	f001 fc1e 	bl	c0d01b90 <ux_check_status_default>
c0d00354:	69e0      	ldr	r0, [r4, #28]
c0d00356:	49cd      	ldr	r1, [pc, #820]	; (c0d0068c <io_event+0x470>)
c0d00358:	4288      	cmp	r0, r1
c0d0035a:	d100      	bne.n	c0d0035e <io_event+0x142>
c0d0035c:	e1fb      	b.n	c0d00756 <io_event+0x53a>
c0d0035e:	2800      	cmp	r0, #0
c0d00360:	d100      	bne.n	c0d00364 <io_event+0x148>
c0d00362:	e1f8      	b.n	c0d00756 <io_event+0x53a>
c0d00364:	49a7      	ldr	r1, [pc, #668]	; (c0d00604 <io_event+0x3e8>)
c0d00366:	4288      	cmp	r0, r1
c0d00368:	d000      	beq.n	c0d0036c <io_event+0x150>
c0d0036a:	e193      	b.n	c0d00694 <io_event+0x478>
c0d0036c:	f001 f952 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d00370:	60a6      	str	r6, [r4, #8]
c0d00372:	6820      	ldr	r0, [r4, #0]
c0d00374:	2800      	cmp	r0, #0
c0d00376:	d100      	bne.n	c0d0037a <io_event+0x15e>
c0d00378:	e1ed      	b.n	c0d00756 <io_event+0x53a>
c0d0037a:	69e0      	ldr	r0, [r4, #28]
c0d0037c:	49fb      	ldr	r1, [pc, #1004]	; (c0d0076c <io_event+0x550>)
c0d0037e:	4288      	cmp	r0, r1
c0d00380:	d000      	beq.n	c0d00384 <io_event+0x168>
c0d00382:	e0c8      	b.n	c0d00516 <io_event+0x2fa>
c0d00384:	e1e7      	b.n	c0d00756 <io_event+0x53a>
            break;

        case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
            //Timer_Restart();
            if (UX_DISPLAYED()) {
c0d00386:	4cf8      	ldr	r4, [pc, #992]	; (c0d00768 <io_event+0x54c>)
c0d00388:	6860      	ldr	r0, [r4, #4]
c0d0038a:	68a1      	ldr	r1, [r4, #8]
c0d0038c:	4281      	cmp	r1, r0
c0d0038e:	d300      	bcc.n	c0d00392 <io_event+0x176>
c0d00390:	e1e1      	b.n	c0d00756 <io_event+0x53a>
                // perform actions after all screen elements have been displayed
            } else {
                UX_DISPLAYED_EVENT();
c0d00392:	2001      	movs	r0, #1
c0d00394:	7620      	strb	r0, [r4, #24]
c0d00396:	2500      	movs	r5, #0
c0d00398:	61e5      	str	r5, [r4, #28]
c0d0039a:	4620      	mov	r0, r4
c0d0039c:	3018      	adds	r0, #24
c0d0039e:	f001 ff47 	bl	c0d02230 <os_ux>
c0d003a2:	61e0      	str	r0, [r4, #28]
c0d003a4:	f001 fbf4 	bl	c0d01b90 <ux_check_status_default>
c0d003a8:	69e0      	ldr	r0, [r4, #28]
c0d003aa:	49f0      	ldr	r1, [pc, #960]	; (c0d0076c <io_event+0x550>)
c0d003ac:	4288      	cmp	r0, r1
c0d003ae:	d100      	bne.n	c0d003b2 <io_event+0x196>
c0d003b0:	e1d1      	b.n	c0d00756 <io_event+0x53a>
c0d003b2:	49ef      	ldr	r1, [pc, #956]	; (c0d00770 <io_event+0x554>)
c0d003b4:	4288      	cmp	r0, r1
c0d003b6:	d100      	bne.n	c0d003ba <io_event+0x19e>
c0d003b8:	e1a2      	b.n	c0d00700 <io_event+0x4e4>
c0d003ba:	2800      	cmp	r0, #0
c0d003bc:	d100      	bne.n	c0d003c0 <io_event+0x1a4>
c0d003be:	e1ca      	b.n	c0d00756 <io_event+0x53a>
c0d003c0:	6820      	ldr	r0, [r4, #0]
c0d003c2:	2800      	cmp	r0, #0
c0d003c4:	d100      	bne.n	c0d003c8 <io_event+0x1ac>
c0d003c6:	e190      	b.n	c0d006ea <io_event+0x4ce>
c0d003c8:	68a0      	ldr	r0, [r4, #8]
c0d003ca:	6861      	ldr	r1, [r4, #4]
c0d003cc:	4288      	cmp	r0, r1
c0d003ce:	d300      	bcc.n	c0d003d2 <io_event+0x1b6>
c0d003d0:	e18b      	b.n	c0d006ea <io_event+0x4ce>
c0d003d2:	f001 ff6f 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d003d6:	2800      	cmp	r0, #0
c0d003d8:	d000      	beq.n	c0d003dc <io_event+0x1c0>
c0d003da:	e186      	b.n	c0d006ea <io_event+0x4ce>
c0d003dc:	68a0      	ldr	r0, [r4, #8]
c0d003de:	68e1      	ldr	r1, [r4, #12]
c0d003e0:	2538      	movs	r5, #56	; 0x38
c0d003e2:	4368      	muls	r0, r5
c0d003e4:	6822      	ldr	r2, [r4, #0]
c0d003e6:	1810      	adds	r0, r2, r0
c0d003e8:	2900      	cmp	r1, #0
c0d003ea:	d002      	beq.n	c0d003f2 <io_event+0x1d6>
c0d003ec:	4788      	blx	r1
c0d003ee:	2800      	cmp	r0, #0
c0d003f0:	d007      	beq.n	c0d00402 <io_event+0x1e6>
c0d003f2:	2801      	cmp	r0, #1
c0d003f4:	d103      	bne.n	c0d003fe <io_event+0x1e2>
c0d003f6:	68a0      	ldr	r0, [r4, #8]
c0d003f8:	4345      	muls	r5, r0
c0d003fa:	6820      	ldr	r0, [r4, #0]
c0d003fc:	1940      	adds	r0, r0, r5
    return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d003fe:	f001 fa4f 	bl	c0d018a0 <io_seproxyhal_display_default>
        case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
            //Timer_Restart();
            if (UX_DISPLAYED()) {
                // perform actions after all screen elements have been displayed
            } else {
                UX_DISPLAYED_EVENT();
c0d00402:	68a0      	ldr	r0, [r4, #8]
c0d00404:	1c40      	adds	r0, r0, #1
c0d00406:	60a0      	str	r0, [r4, #8]
c0d00408:	6821      	ldr	r1, [r4, #0]
c0d0040a:	2900      	cmp	r1, #0
c0d0040c:	d1dd      	bne.n	c0d003ca <io_event+0x1ae>
c0d0040e:	e16c      	b.n	c0d006ea <io_event+0x4ce>
            }
            break;

            // unknown events are acknowledged
        default:
            UX_DEFAULT_EVENT();
c0d00410:	4cd5      	ldr	r4, [pc, #852]	; (c0d00768 <io_event+0x54c>)
c0d00412:	2001      	movs	r0, #1
c0d00414:	7620      	strb	r0, [r4, #24]
c0d00416:	2500      	movs	r5, #0
c0d00418:	61e5      	str	r5, [r4, #28]
c0d0041a:	4620      	mov	r0, r4
c0d0041c:	3018      	adds	r0, #24
c0d0041e:	f001 ff07 	bl	c0d02230 <os_ux>
c0d00422:	61e0      	str	r0, [r4, #28]
c0d00424:	f001 fbb4 	bl	c0d01b90 <ux_check_status_default>
c0d00428:	69e0      	ldr	r0, [r4, #28]
c0d0042a:	49d1      	ldr	r1, [pc, #836]	; (c0d00770 <io_event+0x554>)
c0d0042c:	4288      	cmp	r0, r1
c0d0042e:	d000      	beq.n	c0d00432 <io_event+0x216>
c0d00430:	e08e      	b.n	c0d00550 <io_event+0x334>
c0d00432:	f001 f8ef 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d00436:	60a5      	str	r5, [r4, #8]
c0d00438:	6820      	ldr	r0, [r4, #0]
c0d0043a:	2800      	cmp	r0, #0
c0d0043c:	d100      	bne.n	c0d00440 <io_event+0x224>
c0d0043e:	e18a      	b.n	c0d00756 <io_event+0x53a>
c0d00440:	69e0      	ldr	r0, [r4, #28]
c0d00442:	49ca      	ldr	r1, [pc, #808]	; (c0d0076c <io_event+0x550>)
c0d00444:	4288      	cmp	r0, r1
c0d00446:	d120      	bne.n	c0d0048a <io_event+0x26e>
c0d00448:	e185      	b.n	c0d00756 <io_event+0x53a>
c0d0044a:	6860      	ldr	r0, [r4, #4]
c0d0044c:	4285      	cmp	r5, r0
c0d0044e:	d300      	bcc.n	c0d00452 <io_event+0x236>
c0d00450:	e181      	b.n	c0d00756 <io_event+0x53a>
c0d00452:	f001 ff2f 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d00456:	2800      	cmp	r0, #0
c0d00458:	d000      	beq.n	c0d0045c <io_event+0x240>
c0d0045a:	e17c      	b.n	c0d00756 <io_event+0x53a>
c0d0045c:	68a0      	ldr	r0, [r4, #8]
c0d0045e:	68e1      	ldr	r1, [r4, #12]
c0d00460:	2538      	movs	r5, #56	; 0x38
c0d00462:	4368      	muls	r0, r5
c0d00464:	6822      	ldr	r2, [r4, #0]
c0d00466:	1810      	adds	r0, r2, r0
c0d00468:	2900      	cmp	r1, #0
c0d0046a:	d002      	beq.n	c0d00472 <io_event+0x256>
c0d0046c:	4788      	blx	r1
c0d0046e:	2800      	cmp	r0, #0
c0d00470:	d007      	beq.n	c0d00482 <io_event+0x266>
c0d00472:	2801      	cmp	r0, #1
c0d00474:	d103      	bne.n	c0d0047e <io_event+0x262>
c0d00476:	68a0      	ldr	r0, [r4, #8]
c0d00478:	4345      	muls	r5, r0
c0d0047a:	6820      	ldr	r0, [r4, #0]
c0d0047c:	1940      	adds	r0, r0, r5
    return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d0047e:	f001 fa0f 	bl	c0d018a0 <io_seproxyhal_display_default>
            }
            break;

            // unknown events are acknowledged
        default:
            UX_DEFAULT_EVENT();
c0d00482:	68a0      	ldr	r0, [r4, #8]
c0d00484:	1c45      	adds	r5, r0, #1
c0d00486:	60a5      	str	r5, [r4, #8]
c0d00488:	6820      	ldr	r0, [r4, #0]
c0d0048a:	2800      	cmp	r0, #0
c0d0048c:	d1dd      	bne.n	c0d0044a <io_event+0x22e>
c0d0048e:	e162      	b.n	c0d00756 <io_event+0x53a>

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
        case SEPROXYHAL_TAG_FINGER_EVENT:
            Timer_Restart();
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d00490:	6860      	ldr	r0, [r4, #4]
c0d00492:	4286      	cmp	r6, r0
c0d00494:	d300      	bcc.n	c0d00498 <io_event+0x27c>
c0d00496:	e15e      	b.n	c0d00756 <io_event+0x53a>
c0d00498:	f001 ff0c 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d0049c:	2800      	cmp	r0, #0
c0d0049e:	d000      	beq.n	c0d004a2 <io_event+0x286>
c0d004a0:	e159      	b.n	c0d00756 <io_event+0x53a>
c0d004a2:	68a0      	ldr	r0, [r4, #8]
c0d004a4:	68e1      	ldr	r1, [r4, #12]
c0d004a6:	2538      	movs	r5, #56	; 0x38
c0d004a8:	4368      	muls	r0, r5
c0d004aa:	6822      	ldr	r2, [r4, #0]
c0d004ac:	1810      	adds	r0, r2, r0
c0d004ae:	2900      	cmp	r1, #0
c0d004b0:	d002      	beq.n	c0d004b8 <io_event+0x29c>
c0d004b2:	4788      	blx	r1
c0d004b4:	2800      	cmp	r0, #0
c0d004b6:	d007      	beq.n	c0d004c8 <io_event+0x2ac>
c0d004b8:	2801      	cmp	r0, #1
c0d004ba:	d103      	bne.n	c0d004c4 <io_event+0x2a8>
c0d004bc:	68a0      	ldr	r0, [r4, #8]
c0d004be:	4345      	muls	r5, r0
c0d004c0:	6820      	ldr	r0, [r4, #0]
c0d004c2:	1940      	adds	r0, r0, r5
    return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d004c4:	f001 f9ec 	bl	c0d018a0 <io_seproxyhal_display_default>

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
        case SEPROXYHAL_TAG_FINGER_EVENT:
            Timer_Restart();
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d004c8:	68a0      	ldr	r0, [r4, #8]
c0d004ca:	1c46      	adds	r6, r0, #1
c0d004cc:	60a6      	str	r6, [r4, #8]
c0d004ce:	6820      	ldr	r0, [r4, #0]
c0d004d0:	2800      	cmp	r0, #0
c0d004d2:	d1dd      	bne.n	c0d00490 <io_event+0x274>
c0d004d4:	e13f      	b.n	c0d00756 <io_event+0x53a>
            break;

        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
            Timer_Restart();
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d004d6:	6860      	ldr	r0, [r4, #4]
c0d004d8:	4286      	cmp	r6, r0
c0d004da:	d300      	bcc.n	c0d004de <io_event+0x2c2>
c0d004dc:	e13b      	b.n	c0d00756 <io_event+0x53a>
c0d004de:	f001 fee9 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d004e2:	2800      	cmp	r0, #0
c0d004e4:	d000      	beq.n	c0d004e8 <io_event+0x2cc>
c0d004e6:	e136      	b.n	c0d00756 <io_event+0x53a>
c0d004e8:	68a0      	ldr	r0, [r4, #8]
c0d004ea:	68e1      	ldr	r1, [r4, #12]
c0d004ec:	2538      	movs	r5, #56	; 0x38
c0d004ee:	4368      	muls	r0, r5
c0d004f0:	6822      	ldr	r2, [r4, #0]
c0d004f2:	1810      	adds	r0, r2, r0
c0d004f4:	2900      	cmp	r1, #0
c0d004f6:	d002      	beq.n	c0d004fe <io_event+0x2e2>
c0d004f8:	4788      	blx	r1
c0d004fa:	2800      	cmp	r0, #0
c0d004fc:	d007      	beq.n	c0d0050e <io_event+0x2f2>
c0d004fe:	2801      	cmp	r0, #1
c0d00500:	d103      	bne.n	c0d0050a <io_event+0x2ee>
c0d00502:	68a0      	ldr	r0, [r4, #8]
c0d00504:	4345      	muls	r5, r0
c0d00506:	6820      	ldr	r0, [r4, #0]
c0d00508:	1940      	adds	r0, r0, r5
    return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d0050a:	f001 f9c9 	bl	c0d018a0 <io_seproxyhal_display_default>
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
            break;

        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
            Timer_Restart();
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d0050e:	68a0      	ldr	r0, [r4, #8]
c0d00510:	1c46      	adds	r6, r0, #1
c0d00512:	60a6      	str	r6, [r4, #8]
c0d00514:	6820      	ldr	r0, [r4, #0]
c0d00516:	2800      	cmp	r0, #0
c0d00518:	d1dd      	bne.n	c0d004d6 <io_event+0x2ba>
c0d0051a:	e11c      	b.n	c0d00756 <io_event+0x53a>
        Timer_Set();
    }
}

static bool Timer_Expired() {
    return exit_timer <= 0;
c0d0051c:	6828      	ldr	r0, [r5, #0]
            Timer_Tick();
            if (publicKeyNeedsRefresh == 1) {
                UX_REDISPLAY();
                publicKeyNeedsRefresh = 0;
            } else {
                if (Timer_Expired()) {
c0d0051e:	2800      	cmp	r0, #0
c0d00520:	dc00      	bgt.n	c0d00524 <io_event+0x308>
c0d00522:	e0e9      	b.n	c0d006f8 <io_event+0x4dc>
c0d00524:	2101      	movs	r1, #1
c0d00526:	0209      	lsls	r1, r1, #8
c0d00528:	460a      	mov	r2, r1
c0d0052a:	32ff      	adds	r2, #255	; 0xff
c0d0052c:	4010      	ands	r0, r2
static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
}

static void Timer_UpdateDisplay() {
    if ((exit_timer % EXIT_TIMER_REFRESH_INTERVAL) == (EXIT_TIMER_REFRESH_INTERVAL / 2)) {
c0d0052e:	4288      	cmp	r0, r1
c0d00530:	d000      	beq.n	c0d00534 <io_event+0x318>
c0d00532:	e110      	b.n	c0d00756 <io_event+0x53a>
        UX_REDISPLAY();
c0d00534:	f001 f86e 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d00538:	4c8b      	ldr	r4, [pc, #556]	; (c0d00768 <io_event+0x54c>)
c0d0053a:	2000      	movs	r0, #0
c0d0053c:	60a0      	str	r0, [r4, #8]
c0d0053e:	6821      	ldr	r1, [r4, #0]
c0d00540:	2900      	cmp	r1, #0
c0d00542:	d100      	bne.n	c0d00546 <io_event+0x32a>
c0d00544:	e107      	b.n	c0d00756 <io_event+0x53a>
c0d00546:	69e1      	ldr	r1, [r4, #28]
c0d00548:	4a88      	ldr	r2, [pc, #544]	; (c0d0076c <io_event+0x550>)
c0d0054a:	4291      	cmp	r1, r2
c0d0054c:	d148      	bne.n	c0d005e0 <io_event+0x3c4>
c0d0054e:	e102      	b.n	c0d00756 <io_event+0x53a>
            }
            break;

            // unknown events are acknowledged
        default:
            UX_DEFAULT_EVENT();
c0d00550:	6820      	ldr	r0, [r4, #0]
c0d00552:	2800      	cmp	r0, #0
c0d00554:	d100      	bne.n	c0d00558 <io_event+0x33c>
c0d00556:	e0c8      	b.n	c0d006ea <io_event+0x4ce>
c0d00558:	68a0      	ldr	r0, [r4, #8]
c0d0055a:	6861      	ldr	r1, [r4, #4]
c0d0055c:	4288      	cmp	r0, r1
c0d0055e:	d300      	bcc.n	c0d00562 <io_event+0x346>
c0d00560:	e0c3      	b.n	c0d006ea <io_event+0x4ce>
c0d00562:	f001 fea7 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d00566:	2800      	cmp	r0, #0
c0d00568:	d000      	beq.n	c0d0056c <io_event+0x350>
c0d0056a:	e0be      	b.n	c0d006ea <io_event+0x4ce>
c0d0056c:	68a0      	ldr	r0, [r4, #8]
c0d0056e:	68e1      	ldr	r1, [r4, #12]
c0d00570:	2538      	movs	r5, #56	; 0x38
c0d00572:	4368      	muls	r0, r5
c0d00574:	6822      	ldr	r2, [r4, #0]
c0d00576:	1810      	adds	r0, r2, r0
c0d00578:	2900      	cmp	r1, #0
c0d0057a:	d002      	beq.n	c0d00582 <io_event+0x366>
c0d0057c:	4788      	blx	r1
c0d0057e:	2800      	cmp	r0, #0
c0d00580:	d007      	beq.n	c0d00592 <io_event+0x376>
c0d00582:	2801      	cmp	r0, #1
c0d00584:	d103      	bne.n	c0d0058e <io_event+0x372>
c0d00586:	68a0      	ldr	r0, [r4, #8]
c0d00588:	4345      	muls	r5, r0
c0d0058a:	6820      	ldr	r0, [r4, #0]
c0d0058c:	1940      	adds	r0, r0, r5
    return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d0058e:	f001 f987 	bl	c0d018a0 <io_seproxyhal_display_default>
            }
            break;

            // unknown events are acknowledged
        default:
            UX_DEFAULT_EVENT();
c0d00592:	68a0      	ldr	r0, [r4, #8]
c0d00594:	1c40      	adds	r0, r0, #1
c0d00596:	60a0      	str	r0, [r4, #8]
c0d00598:	6821      	ldr	r1, [r4, #0]
c0d0059a:	2900      	cmp	r1, #0
c0d0059c:	d1dd      	bne.n	c0d0055a <io_event+0x33e>
c0d0059e:	e0a4      	b.n	c0d006ea <io_event+0x4ce>
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
}

static void Timer_UpdateDisplay() {
    if ((exit_timer % EXIT_TIMER_REFRESH_INTERVAL) == (EXIT_TIMER_REFRESH_INTERVAL / 2)) {
        UX_REDISPLAY();
c0d005a0:	6861      	ldr	r1, [r4, #4]
c0d005a2:	4288      	cmp	r0, r1
c0d005a4:	d300      	bcc.n	c0d005a8 <io_event+0x38c>
c0d005a6:	e0d6      	b.n	c0d00756 <io_event+0x53a>
c0d005a8:	f001 fe84 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d005ac:	2800      	cmp	r0, #0
c0d005ae:	d000      	beq.n	c0d005b2 <io_event+0x396>
c0d005b0:	e0d1      	b.n	c0d00756 <io_event+0x53a>
c0d005b2:	68a0      	ldr	r0, [r4, #8]
c0d005b4:	68e1      	ldr	r1, [r4, #12]
c0d005b6:	2538      	movs	r5, #56	; 0x38
c0d005b8:	4368      	muls	r0, r5
c0d005ba:	6822      	ldr	r2, [r4, #0]
c0d005bc:	1810      	adds	r0, r2, r0
c0d005be:	2900      	cmp	r1, #0
c0d005c0:	d002      	beq.n	c0d005c8 <io_event+0x3ac>
c0d005c2:	4788      	blx	r1
c0d005c4:	2800      	cmp	r0, #0
c0d005c6:	d007      	beq.n	c0d005d8 <io_event+0x3bc>
c0d005c8:	2801      	cmp	r0, #1
c0d005ca:	d103      	bne.n	c0d005d4 <io_event+0x3b8>
c0d005cc:	68a0      	ldr	r0, [r4, #8]
c0d005ce:	4345      	muls	r5, r0
c0d005d0:	6820      	ldr	r0, [r4, #0]
c0d005d2:	1940      	adds	r0, r0, r5
    return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d005d4:	f001 f964 	bl	c0d018a0 <io_seproxyhal_display_default>
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
}

static void Timer_UpdateDisplay() {
    if ((exit_timer % EXIT_TIMER_REFRESH_INTERVAL) == (EXIT_TIMER_REFRESH_INTERVAL / 2)) {
        UX_REDISPLAY();
c0d005d8:	68a0      	ldr	r0, [r4, #8]
c0d005da:	1c40      	adds	r0, r0, #1
c0d005dc:	60a0      	str	r0, [r4, #8]
c0d005de:	6821      	ldr	r1, [r4, #0]
c0d005e0:	2900      	cmp	r1, #0
c0d005e2:	d1dd      	bne.n	c0d005a0 <io_event+0x384>
c0d005e4:	e0b7      	b.n	c0d00756 <io_event+0x53a>
c0d005e6:	46c0      	nop			; (mov r8, r8)
c0d005e8:	20001800 	.word	0x20001800
c0d005ec:	00001002 	.word	0x00001002
c0d005f0:	2000201c 	.word	0x2000201c
c0d005f4:	20002020 	.word	0x20002020
c0d005f8:	00006425 	.word	0x00006425
c0d005fc:	20001f6c 	.word	0x20001f6c
c0d00600:	b0105044 	.word	0xb0105044
c0d00604:	b0105055 	.word	0xb0105055

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
        case SEPROXYHAL_TAG_FINGER_EVENT:
            Timer_Restart();
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d00608:	88a0      	ldrh	r0, [r4, #4]
c0d0060a:	9004      	str	r0, [sp, #16]
c0d0060c:	6820      	ldr	r0, [r4, #0]
c0d0060e:	9003      	str	r0, [sp, #12]
c0d00610:	79ee      	ldrb	r6, [r5, #7]
c0d00612:	79ab      	ldrb	r3, [r5, #6]
c0d00614:	796f      	ldrb	r7, [r5, #5]
c0d00616:	792a      	ldrb	r2, [r5, #4]
c0d00618:	78ed      	ldrb	r5, [r5, #3]
c0d0061a:	68e1      	ldr	r1, [r4, #12]
c0d0061c:	4668      	mov	r0, sp
c0d0061e:	6005      	str	r5, [r0, #0]
c0d00620:	6041      	str	r1, [r0, #4]
c0d00622:	0212      	lsls	r2, r2, #8
c0d00624:	433a      	orrs	r2, r7
c0d00626:	021b      	lsls	r3, r3, #8
c0d00628:	4333      	orrs	r3, r6
c0d0062a:	9803      	ldr	r0, [sp, #12]
c0d0062c:	9904      	ldr	r1, [sp, #16]
c0d0062e:	f001 f869 	bl	c0d01704 <io_seproxyhal_touch_element_callback>
c0d00632:	6820      	ldr	r0, [r4, #0]
c0d00634:	2800      	cmp	r0, #0
c0d00636:	d058      	beq.n	c0d006ea <io_event+0x4ce>
c0d00638:	68a0      	ldr	r0, [r4, #8]
c0d0063a:	6861      	ldr	r1, [r4, #4]
c0d0063c:	4288      	cmp	r0, r1
c0d0063e:	d254      	bcs.n	c0d006ea <io_event+0x4ce>
c0d00640:	f001 fe38 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d00644:	2800      	cmp	r0, #0
c0d00646:	d150      	bne.n	c0d006ea <io_event+0x4ce>
c0d00648:	68a0      	ldr	r0, [r4, #8]
c0d0064a:	68e1      	ldr	r1, [r4, #12]
c0d0064c:	2538      	movs	r5, #56	; 0x38
c0d0064e:	4368      	muls	r0, r5
c0d00650:	6822      	ldr	r2, [r4, #0]
c0d00652:	1810      	adds	r0, r2, r0
c0d00654:	2900      	cmp	r1, #0
c0d00656:	d002      	beq.n	c0d0065e <io_event+0x442>
c0d00658:	4788      	blx	r1
c0d0065a:	2800      	cmp	r0, #0
c0d0065c:	d007      	beq.n	c0d0066e <io_event+0x452>
c0d0065e:	2801      	cmp	r0, #1
c0d00660:	d103      	bne.n	c0d0066a <io_event+0x44e>
c0d00662:	68a0      	ldr	r0, [r4, #8]
c0d00664:	4345      	muls	r5, r0
c0d00666:	6820      	ldr	r0, [r4, #0]
c0d00668:	1940      	adds	r0, r0, r5
    return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d0066a:	f001 f919 	bl	c0d018a0 <io_seproxyhal_display_default>

    // can't have more than one tag in the reply, not supported yet.
    switch (G_io_seproxyhal_spi_buffer[0]) {
        case SEPROXYHAL_TAG_FINGER_EVENT:
            Timer_Restart();
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d0066e:	68a0      	ldr	r0, [r4, #8]
c0d00670:	1c40      	adds	r0, r0, #1
c0d00672:	60a0      	str	r0, [r4, #8]
c0d00674:	6821      	ldr	r1, [r4, #0]
c0d00676:	2900      	cmp	r1, #0
c0d00678:	d1df      	bne.n	c0d0063a <io_event+0x41e>
c0d0067a:	e036      	b.n	c0d006ea <io_event+0x4ce>
c0d0067c:	2000201c 	.word	0x2000201c
c0d00680:	20002020 	.word	0x20002020
c0d00684:	00006425 	.word	0x00006425
c0d00688:	20001f6c 	.word	0x20001f6c
c0d0068c:	b0105044 	.word	0xb0105044
c0d00690:	20002024 	.word	0x20002024
            break;

        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
            Timer_Restart();
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d00694:	6920      	ldr	r0, [r4, #16]
c0d00696:	2800      	cmp	r0, #0
c0d00698:	d003      	beq.n	c0d006a2 <io_event+0x486>
c0d0069a:	78e9      	ldrb	r1, [r5, #3]
c0d0069c:	0849      	lsrs	r1, r1, #1
c0d0069e:	f001 f941 	bl	c0d01924 <io_seproxyhal_button_push>
c0d006a2:	6820      	ldr	r0, [r4, #0]
c0d006a4:	2800      	cmp	r0, #0
c0d006a6:	d020      	beq.n	c0d006ea <io_event+0x4ce>
c0d006a8:	68a0      	ldr	r0, [r4, #8]
c0d006aa:	6861      	ldr	r1, [r4, #4]
c0d006ac:	4288      	cmp	r0, r1
c0d006ae:	d21c      	bcs.n	c0d006ea <io_event+0x4ce>
c0d006b0:	f001 fe00 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d006b4:	2800      	cmp	r0, #0
c0d006b6:	d118      	bne.n	c0d006ea <io_event+0x4ce>
c0d006b8:	68a0      	ldr	r0, [r4, #8]
c0d006ba:	68e1      	ldr	r1, [r4, #12]
c0d006bc:	2538      	movs	r5, #56	; 0x38
c0d006be:	4368      	muls	r0, r5
c0d006c0:	6822      	ldr	r2, [r4, #0]
c0d006c2:	1810      	adds	r0, r2, r0
c0d006c4:	2900      	cmp	r1, #0
c0d006c6:	d002      	beq.n	c0d006ce <io_event+0x4b2>
c0d006c8:	4788      	blx	r1
c0d006ca:	2800      	cmp	r0, #0
c0d006cc:	d007      	beq.n	c0d006de <io_event+0x4c2>
c0d006ce:	2801      	cmp	r0, #1
c0d006d0:	d103      	bne.n	c0d006da <io_event+0x4be>
c0d006d2:	68a0      	ldr	r0, [r4, #8]
c0d006d4:	4345      	muls	r5, r0
c0d006d6:	6820      	ldr	r0, [r4, #0]
c0d006d8:	1940      	adds	r0, r0, r5
    return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d006da:	f001 f8e1 	bl	c0d018a0 <io_seproxyhal_display_default>
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
            break;

        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
            Timer_Restart();
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d006de:	68a0      	ldr	r0, [r4, #8]
c0d006e0:	1c40      	adds	r0, r0, #1
c0d006e2:	60a0      	str	r0, [r4, #8]
c0d006e4:	6821      	ldr	r1, [r4, #0]
c0d006e6:	2900      	cmp	r1, #0
c0d006e8:	d1df      	bne.n	c0d006aa <io_event+0x48e>
c0d006ea:	6860      	ldr	r0, [r4, #4]
c0d006ec:	68a1      	ldr	r1, [r4, #8]
c0d006ee:	4281      	cmp	r1, r0
c0d006f0:	d331      	bcc.n	c0d00756 <io_event+0x53a>
c0d006f2:	f001 fddf 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d006f6:	e02e      	b.n	c0d00756 <io_event+0x53a>
            if (publicKeyNeedsRefresh == 1) {
                UX_REDISPLAY();
                publicKeyNeedsRefresh = 0;
            } else {
                if (Timer_Expired()) {
                    os_sched_exit(0);
c0d006f8:	2000      	movs	r0, #0
c0d006fa:	f001 fd83 	bl	c0d02204 <os_sched_exit>
c0d006fe:	e02a      	b.n	c0d00756 <io_event+0x53a>
        case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
            //Timer_Restart();
            if (UX_DISPLAYED()) {
                // perform actions after all screen elements have been displayed
            } else {
                UX_DISPLAYED_EVENT();
c0d00700:	f000 ff88 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d00704:	60a5      	str	r5, [r4, #8]
c0d00706:	6820      	ldr	r0, [r4, #0]
c0d00708:	2800      	cmp	r0, #0
c0d0070a:	d024      	beq.n	c0d00756 <io_event+0x53a>
c0d0070c:	69e0      	ldr	r0, [r4, #28]
c0d0070e:	4917      	ldr	r1, [pc, #92]	; (c0d0076c <io_event+0x550>)
c0d00710:	4288      	cmp	r0, r1
c0d00712:	d11e      	bne.n	c0d00752 <io_event+0x536>
c0d00714:	e01f      	b.n	c0d00756 <io_event+0x53a>
c0d00716:	6860      	ldr	r0, [r4, #4]
c0d00718:	4285      	cmp	r5, r0
c0d0071a:	d21c      	bcs.n	c0d00756 <io_event+0x53a>
c0d0071c:	f001 fdca 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d00720:	2800      	cmp	r0, #0
c0d00722:	d118      	bne.n	c0d00756 <io_event+0x53a>
c0d00724:	68a0      	ldr	r0, [r4, #8]
c0d00726:	68e1      	ldr	r1, [r4, #12]
c0d00728:	2538      	movs	r5, #56	; 0x38
c0d0072a:	4368      	muls	r0, r5
c0d0072c:	6822      	ldr	r2, [r4, #0]
c0d0072e:	1810      	adds	r0, r2, r0
c0d00730:	2900      	cmp	r1, #0
c0d00732:	d002      	beq.n	c0d0073a <io_event+0x51e>
c0d00734:	4788      	blx	r1
c0d00736:	2800      	cmp	r0, #0
c0d00738:	d007      	beq.n	c0d0074a <io_event+0x52e>
c0d0073a:	2801      	cmp	r0, #1
c0d0073c:	d103      	bne.n	c0d00746 <io_event+0x52a>
c0d0073e:	68a0      	ldr	r0, [r4, #8]
c0d00740:	4345      	muls	r5, r0
c0d00742:	6820      	ldr	r0, [r4, #0]
c0d00744:	1940      	adds	r0, r0, r5
    return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
    io_seproxyhal_display_default((bagl_element_t *) element);
c0d00746:	f001 f8ab 	bl	c0d018a0 <io_seproxyhal_display_default>
        case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
            //Timer_Restart();
            if (UX_DISPLAYED()) {
                // perform actions after all screen elements have been displayed
            } else {
                UX_DISPLAYED_EVENT();
c0d0074a:	68a0      	ldr	r0, [r4, #8]
c0d0074c:	1c45      	adds	r5, r0, #1
c0d0074e:	60a5      	str	r5, [r4, #8]
c0d00750:	6820      	ldr	r0, [r4, #0]
c0d00752:	2800      	cmp	r0, #0
c0d00754:	d1df      	bne.n	c0d00716 <io_event+0x4fa>
            UX_DEFAULT_EVENT();
            break;
    }

    // close the event if not done previously (by a display or whatever)
    if (!io_seproxyhal_spi_is_status_sent()) {
c0d00756:	f001 fdad 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d0075a:	2800      	cmp	r0, #0
c0d0075c:	d101      	bne.n	c0d00762 <io_event+0x546>
        io_seproxyhal_general_status();
c0d0075e:	f000 fe05 	bl	c0d0136c <io_seproxyhal_general_status>
    }

    // command has been processed, DO NOT reset the current APDU transport
    return 1;
c0d00762:	2001      	movs	r0, #1
c0d00764:	b005      	add	sp, #20
c0d00766:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00768:	20001f6c 	.word	0x20001f6c
c0d0076c:	b0105044 	.word	0xb0105044
c0d00770:	b0105055 	.word	0xb0105055

c0d00774 <ont_main>:
        publicKeyNeedsRefresh = 1;
    }
}

/** main loop. */
static void ont_main(void) {
c0d00774:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00776:	b0e5      	sub	sp, #404	; 0x194
c0d00778:	2500      	movs	r5, #0
    volatile unsigned int rx = 0;
c0d0077a:	9564      	str	r5, [sp, #400]	; 0x190
    volatile unsigned int tx = 0;
c0d0077c:	9563      	str	r5, [sp, #396]	; 0x18c
    volatile unsigned int flags = 0;
c0d0077e:	9562      	str	r5, [sp, #392]	; 0x188
c0d00780:	4fe4      	ldr	r7, [pc, #912]	; (c0d00b14 <ont_main+0x3a0>)
c0d00782:	4eee      	ldr	r6, [pc, #952]	; (c0d00b3c <ont_main+0x3c8>)
c0d00784:	a861      	add	r0, sp, #388	; 0x184
    // When APDU are to be fetched from multiple IOs, like NFC+USB+BLE, make
    // sure the io_event is called with a
    // switch event, before the apdu is replied to the bootloader. This avoid
    // APDU injection faults.
    for (;;) {
        volatile unsigned short sw = 0;
c0d00786:	8005      	strh	r5, [r0, #0]
c0d00788:	ac56      	add	r4, sp, #344	; 0x158

        BEGIN_TRY
        {
            TRY
c0d0078a:	4620      	mov	r0, r4
c0d0078c:	f004 f8f0 	bl	c0d04970 <setjmp>
c0d00790:	8520      	strh	r0, [r4, #40]	; 0x28
c0d00792:	49de      	ldr	r1, [pc, #888]	; (c0d00b0c <ont_main+0x398>)
c0d00794:	4208      	tst	r0, r1
c0d00796:	d00f      	beq.n	c0d007b8 <ont_main+0x44>
c0d00798:	a956      	add	r1, sp, #344	; 0x158
                        hashTainted = 1;
                        THROW(0x6D00);
                        break;
                }
            }
            CATCH_OTHER(e)
c0d0079a:	850d      	strh	r5, [r1, #40]	; 0x28
c0d0079c:	210f      	movs	r1, #15
c0d0079e:	0309      	lsls	r1, r1, #12
            {
                switch (e & 0xF000) {
c0d007a0:	4001      	ands	r1, r0
c0d007a2:	2209      	movs	r2, #9
c0d007a4:	0312      	lsls	r2, r2, #12
c0d007a6:	4291      	cmp	r1, r2
c0d007a8:	d003      	beq.n	c0d007b2 <ont_main+0x3e>
c0d007aa:	2203      	movs	r2, #3
c0d007ac:	0352      	lsls	r2, r2, #13
c0d007ae:	4291      	cmp	r1, r2
c0d007b0:	d173      	bne.n	c0d0089a <ont_main+0x126>
c0d007b2:	a961      	add	r1, sp, #388	; 0x184
                    case 0x6000:
                    case 0x9000:
                        sw = e;
c0d007b4:	8008      	strh	r0, [r1, #0]
c0d007b6:	e077      	b.n	c0d008a8 <ont_main+0x134>
c0d007b8:	a856      	add	r0, sp, #344	; 0x158
    for (;;) {
        volatile unsigned short sw = 0;

        BEGIN_TRY
        {
            TRY
c0d007ba:	f000 fc62 	bl	c0d01082 <try_context_set>
            {
                rx = tx;
c0d007be:	9863      	ldr	r0, [sp, #396]	; 0x18c
c0d007c0:	9064      	str	r0, [sp, #400]	; 0x190
c0d007c2:	2400      	movs	r4, #0
                // ensure no race in catch_other if io_exchange throws an error
                tx = 0;
c0d007c4:	9463      	str	r4, [sp, #396]	; 0x18c
                rx = io_exchange(CHANNEL_APDU | flags, rx);
c0d007c6:	9862      	ldr	r0, [sp, #392]	; 0x188
c0d007c8:	9964      	ldr	r1, [sp, #400]	; 0x190
c0d007ca:	b2c0      	uxtb	r0, r0
c0d007cc:	b289      	uxth	r1, r1
c0d007ce:	f001 f8e3 	bl	c0d01998 <io_exchange>
c0d007d2:	9064      	str	r0, [sp, #400]	; 0x190
                flags = 0;
c0d007d4:	9462      	str	r4, [sp, #392]	; 0x188

                // no apdu received, well, reset the session, and reset the
                // bootloader configuration
                if (rx == 0) {
c0d007d6:	9864      	ldr	r0, [sp, #400]	; 0x190
c0d007d8:	2800      	cmp	r0, #0
c0d007da:	d100      	bne.n	c0d007de <ont_main+0x6a>
c0d007dc:	e168      	b.n	c0d00ab0 <ont_main+0x33c>
                    hashTainted = 1;
                    THROW(0x6982);
                }

                // if the buffer doesn't start with the magic byte, return an error.
                if (G_io_apdu_buffer[0] != CLA) {
c0d007de:	7838      	ldrb	r0, [r7, #0]

                        display_public_key(publicKey.W);
                        refresh_public_key_display();

                        G_io_apdu_buffer[tx++] = 0xFF;
                        G_io_apdu_buffer[tx++] = 0xFF;
c0d007e0:	2380      	movs	r3, #128	; 0x80
                    hashTainted = 1;
                    THROW(0x6982);
                }

                // if the buffer doesn't start with the magic byte, return an error.
                if (G_io_apdu_buffer[0] != CLA) {
c0d007e2:	2880      	cmp	r0, #128	; 0x80
c0d007e4:	d000      	beq.n	c0d007e8 <ont_main+0x74>
c0d007e6:	e169      	b.n	c0d00abc <ont_main+0x348>
c0d007e8:	7879      	ldrb	r1, [r7, #1]
c0d007ea:	206d      	movs	r0, #109	; 0x6d
c0d007ec:	0200      	lsls	r0, r0, #8
c0d007ee:	9006      	str	r0, [sp, #24]
c0d007f0:	2009      	movs	r0, #9
c0d007f2:	0302      	lsls	r2, r0, #12
c0d007f4:	48c9      	ldr	r0, [pc, #804]	; (c0d00b1c <ont_main+0x3a8>)
                    hashTainted = 1;
                    THROW(0x6E00);
                }

                // check the second byte (0x01) for the instruction.
                switch (G_io_apdu_buffer[1]) {
c0d007f6:	2907      	cmp	r1, #7
c0d007f8:	dc71      	bgt.n	c0d008de <ont_main+0x16a>
c0d007fa:	2902      	cmp	r1, #2
c0d007fc:	d176      	bne.n	c0d008ec <ont_main+0x178>
    exit_timer = MAX_EXIT_TIMER;
    Timer_UpdateDescription();
}

static void Timer_Restart() {
    if (exit_timer != MAX_EXIT_TIMER) {
c0d007fe:	49c8      	ldr	r1, [pc, #800]	; (c0d00b20 <ont_main+0x3ac>)
c0d00800:	6809      	ldr	r1, [r1, #0]
c0d00802:	4281      	cmp	r1, r0
c0d00804:	4cc4      	ldr	r4, [pc, #784]	; (c0d00b18 <ont_main+0x3a4>)
c0d00806:	d00a      	beq.n	c0d0081e <ont_main+0xaa>
        Timer_UpdateDescription();
    }
}

static void Timer_Set() {
    exit_timer = MAX_EXIT_TIMER;
c0d00808:	49c5      	ldr	r1, [pc, #788]	; (c0d00b20 <ont_main+0x3ac>)
c0d0080a:	6008      	str	r0, [r1, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d0080c:	2104      	movs	r1, #4
c0d0080e:	461c      	mov	r4, r3
c0d00810:	2308      	movs	r3, #8
c0d00812:	48c4      	ldr	r0, [pc, #784]	; (c0d00b24 <ont_main+0x3b0>)
c0d00814:	a2c4      	add	r2, pc, #784	; (adr r2, c0d00b28 <ont_main+0x3b4>)
c0d00816:	f001 f9bd 	bl	c0d01b94 <snprintf>
c0d0081a:	4623      	mov	r3, r4
c0d0081c:	4cbe      	ldr	r4, [pc, #760]	; (c0d00b18 <ont_main+0x3a4>)
c0d0081e:	78b8      	ldrb	r0, [r7, #2]
c0d00820:	9307      	str	r3, [sp, #28]

                    // we're getting a transaction to sign, in parts.
                    case INS_SIGN: {
                        Timer_Restart();
                        // check the third byte (0x02) for the instruction subtype.
                        if ((G_io_apdu_buffer[2] != P1_MORE) && (G_io_apdu_buffer[2] != P1_LAST)) {
c0d00822:	4318      	orrs	r0, r3
c0d00824:	2880      	cmp	r0, #128	; 0x80
c0d00826:	d000      	beq.n	c0d0082a <ont_main+0xb6>
c0d00828:	e155      	b.n	c0d00ad6 <ont_main+0x362>
                            hashTainted = 1;
                            THROW(0x6A86);
                        }

                        // if this is the first transaction part, reset the hash and all the other temporary variables.
                        if (hashTainted) {
c0d0082a:	7820      	ldrb	r0, [r4, #0]
c0d0082c:	2800      	cmp	r0, #0
c0d0082e:	d007      	beq.n	c0d00840 <ont_main+0xcc>
                            cx_sha256_init(&hash);
c0d00830:	48c1      	ldr	r0, [pc, #772]	; (c0d00b38 <ont_main+0x3c4>)
c0d00832:	f001 fc51 	bl	c0d020d8 <cx_sha256_init>
c0d00836:	2000      	movs	r0, #0
                            hashTainted = 0;
c0d00838:	7020      	strb	r0, [r4, #0]
                            raw_tx_ix = 0;
c0d0083a:	6030      	str	r0, [r6, #0]
                            raw_tx_len = 0;
c0d0083c:	49c0      	ldr	r1, [pc, #768]	; (c0d00b40 <ont_main+0x3cc>)
c0d0083e:	6008      	str	r0, [r1, #0]
                        }

                        // move the contents of the buffer into raw_tx, and update raw_tx_ix to the end of the buffer, to be ready for the next part of the tx.
                        unsigned int len = get_apdu_buffer_length();
c0d00840:	f002 fac6 	bl	c0d02dd0 <get_apdu_buffer_length>
c0d00844:	4604      	mov	r4, r0
                        unsigned char *in = G_io_apdu_buffer + APDU_HEADER_LENGTH;
                        unsigned char *out = raw_tx + raw_tx_ix;
c0d00846:	6830      	ldr	r0, [r6, #0]
                        if (raw_tx_ix + len > MAX_TX_RAW_LENGTH) {
c0d00848:	1901      	adds	r1, r0, r4
c0d0084a:	4abe      	ldr	r2, [pc, #760]	; (c0d00b44 <ont_main+0x3d0>)
c0d0084c:	4291      	cmp	r1, r2
c0d0084e:	d300      	bcc.n	c0d00852 <ont_main+0xde>
c0d00850:	e146      	b.n	c0d00ae0 <ont_main+0x36c>
                        }

                        // move the contents of the buffer into raw_tx, and update raw_tx_ix to the end of the buffer, to be ready for the next part of the tx.
                        unsigned int len = get_apdu_buffer_length();
                        unsigned char *in = G_io_apdu_buffer + APDU_HEADER_LENGTH;
                        unsigned char *out = raw_tx + raw_tx_ix;
c0d00852:	49bd      	ldr	r1, [pc, #756]	; (c0d00b48 <ont_main+0x3d4>)
c0d00854:	1808      	adds	r0, r1, r0
                        if (raw_tx_ix + len > MAX_TX_RAW_LENGTH) {
                            hashTainted = 1;
                            THROW(0x6D08);
                        }
                        os_memmove(out, in, len);
c0d00856:	1d79      	adds	r1, r7, #5
c0d00858:	4622      	mov	r2, r4
c0d0085a:	f000 fcc6 	bl	c0d011ea <os_memmove>
                        raw_tx_ix += len;
c0d0085e:	6830      	ldr	r0, [r6, #0]
c0d00860:	1901      	adds	r1, r0, r4
c0d00862:	6031      	str	r1, [r6, #0]
c0d00864:	2200      	movs	r2, #0

                        // set the screen to be the first screen.
                        curr_scr_ix = 0;
c0d00866:	48b9      	ldr	r0, [pc, #740]	; (c0d00b4c <ont_main+0x3d8>)
c0d00868:	6002      	str	r2, [r0, #0]
                        unsigned char *out = raw_tx + raw_tx_ix;
                        if (raw_tx_ix + len > MAX_TX_RAW_LENGTH) {
                            hashTainted = 1;
                            THROW(0x6D08);
                        }
                        os_memmove(out, in, len);
c0d0086a:	1938      	adds	r0, r7, r4

                        // set the screen to be the first screen.
                        curr_scr_ix = 0;

                        // set the buffer to end with a zero.
                        G_io_apdu_buffer[APDU_HEADER_LENGTH + len] = '\0';
c0d0086c:	7142      	strb	r2, [r0, #5]

                        // if this is the last part of the transaction, parse the transaction into human readable text, and display it.
                        if (G_io_apdu_buffer[2] == P1_LAST) {
c0d0086e:	78b8      	ldrb	r0, [r7, #2]
c0d00870:	9b07      	ldr	r3, [sp, #28]
c0d00872:	4298      	cmp	r0, r3
c0d00874:	d107      	bne.n	c0d00886 <ont_main+0x112>
                            raw_tx_len = raw_tx_ix;
c0d00876:	48b2      	ldr	r0, [pc, #712]	; (c0d00b40 <ont_main+0x3cc>)
c0d00878:	6001      	str	r1, [r0, #0]
                            raw_tx_ix = 0;
c0d0087a:	6032      	str	r2, [r6, #0]

                            // parse the transaction into human readable text.
                            display_tx_desc();
c0d0087c:	f000 f96c 	bl	c0d00b58 <display_tx_desc>
                            // display the UI, starting at the top screen which is "Sign Tx Now".
                            ui_top_sign();
c0d00880:	f002 f9ee 	bl	c0d02c60 <ui_top_sign>
c0d00884:	78b8      	ldrb	r0, [r7, #2]
                            //ui_display_tx_desc_1();
                        }

                        flags |= IO_ASYNCH_REPLY;
c0d00886:	2110      	movs	r1, #16
c0d00888:	9a62      	ldr	r2, [sp, #392]	; 0x188
c0d0088a:	430a      	orrs	r2, r1
c0d0088c:	9262      	str	r2, [sp, #392]	; 0x188

                        // if this is not the last part of the transaction, do not display the UI, and approve the partial transaction.
                        // this adds the TX to the hash.
                        if (G_io_apdu_buffer[2] == P1_MORE) {
c0d0088e:	2800      	cmp	r0, #0
c0d00890:	d115      	bne.n	c0d008be <ont_main+0x14a>
                            io_seproxyhal_touch_approve(NULL);
c0d00892:	2000      	movs	r0, #0
c0d00894:	f002 f892 	bl	c0d029bc <io_seproxyhal_touch_approve>
c0d00898:	e011      	b.n	c0d008be <ont_main+0x14a>
                    case 0x6000:
                    case 0x9000:
                        sw = e;
                        break;
                    default:
                        sw = 0x6800 | (e & 0x7FF);
c0d0089a:	499d      	ldr	r1, [pc, #628]	; (c0d00b10 <ont_main+0x39c>)
c0d0089c:	4008      	ands	r0, r1
c0d0089e:	210d      	movs	r1, #13
c0d008a0:	02c9      	lsls	r1, r1, #11
c0d008a2:	4301      	orrs	r1, r0
c0d008a4:	a861      	add	r0, sp, #388	; 0x184
c0d008a6:	8001      	strh	r1, [r0, #0]
                        break;
                }
                // Unexpected exception => report
                G_io_apdu_buffer[tx] = sw >> 8;
c0d008a8:	9861      	ldr	r0, [sp, #388]	; 0x184
c0d008aa:	0a00      	lsrs	r0, r0, #8
c0d008ac:	9963      	ldr	r1, [sp, #396]	; 0x18c
c0d008ae:	5478      	strb	r0, [r7, r1]
                G_io_apdu_buffer[tx + 1] = sw;
c0d008b0:	9861      	ldr	r0, [sp, #388]	; 0x184
c0d008b2:	9963      	ldr	r1, [sp, #396]	; 0x18c
                    default:
                        sw = 0x6800 | (e & 0x7FF);
                        break;
                }
                // Unexpected exception => report
                G_io_apdu_buffer[tx] = sw >> 8;
c0d008b4:	1879      	adds	r1, r7, r1
                G_io_apdu_buffer[tx + 1] = sw;
c0d008b6:	7048      	strb	r0, [r1, #1]
                tx += 2;
c0d008b8:	9863      	ldr	r0, [sp, #396]	; 0x18c
c0d008ba:	1c80      	adds	r0, r0, #2
c0d008bc:	9063      	str	r0, [sp, #396]	; 0x18c
            }
            FINALLY
c0d008be:	f000 fd4d 	bl	c0d0135c <try_context_get>
c0d008c2:	a956      	add	r1, sp, #344	; 0x158
c0d008c4:	4288      	cmp	r0, r1
c0d008c6:	d103      	bne.n	c0d008d0 <ont_main+0x15c>
c0d008c8:	f000 fd4a 	bl	c0d01360 <try_context_get_previous>
c0d008cc:	f000 fbd9 	bl	c0d01082 <try_context_set>
c0d008d0:	a856      	add	r0, sp, #344	; 0x158
            {
            }
        }
        END_TRY;
c0d008d2:	8d00      	ldrh	r0, [r0, #40]	; 0x28
c0d008d4:	2800      	cmp	r0, #0
c0d008d6:	d100      	bne.n	c0d008da <ont_main+0x166>
c0d008d8:	e754      	b.n	c0d00784 <ont_main+0x10>
c0d008da:	f000 fd3a 	bl	c0d01352 <os_longjmp>
c0d008de:	2908      	cmp	r1, #8
c0d008e0:	d060      	beq.n	c0d009a4 <ont_main+0x230>
c0d008e2:	29ff      	cmp	r1, #255	; 0xff
c0d008e4:	d000      	beq.n	c0d008e8 <ont_main+0x174>
c0d008e6:	e0f0      	b.n	c0d00aca <ont_main+0x356>
    }

    return_to_dashboard:
    return;
}
c0d008e8:	b065      	add	sp, #404	; 0x194
c0d008ea:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d008ec:	2904      	cmp	r1, #4
c0d008ee:	d000      	beq.n	c0d008f2 <ont_main+0x17e>
c0d008f0:	e0eb      	b.n	c0d00aca <ont_main+0x356>
c0d008f2:	4b8b      	ldr	r3, [pc, #556]	; (c0d00b20 <ont_main+0x3ac>)
    exit_timer = MAX_EXIT_TIMER;
    Timer_UpdateDescription();
}

static void Timer_Restart() {
    if (exit_timer != MAX_EXIT_TIMER) {
c0d008f4:	6819      	ldr	r1, [r3, #0]
c0d008f6:	4281      	cmp	r1, r0
c0d008f8:	d008      	beq.n	c0d0090c <ont_main+0x198>
        Timer_UpdateDescription();
    }
}

static void Timer_Set() {
    exit_timer = MAX_EXIT_TIMER;
c0d008fa:	6018      	str	r0, [r3, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d008fc:	4889      	ldr	r0, [pc, #548]	; (c0d00b24 <ont_main+0x3b0>)
c0d008fe:	2104      	movs	r1, #4
c0d00900:	4614      	mov	r4, r2
c0d00902:	a289      	add	r2, pc, #548	; (adr r2, c0d00b28 <ont_main+0x3b4>)
c0d00904:	2308      	movs	r3, #8
c0d00906:	f001 f945 	bl	c0d01b94 <snprintf>
c0d0090a:	4622      	mov	r2, r4
                        Timer_Restart();

                        cx_ecfp_public_key_t publicKey;
                        cx_ecfp_private_key_t privateKey;

                        if (rx < APDU_HEADER_LENGTH + BIP44_BYTE_LENGTH) {
c0d0090c:	9864      	ldr	r0, [sp, #400]	; 0x190
c0d0090e:	2818      	cmp	r0, #24
c0d00910:	d800      	bhi.n	c0d00914 <ont_main+0x1a0>
c0d00912:	e0ec      	b.n	c0d00aee <ont_main+0x37a>
c0d00914:	9208      	str	r2, [sp, #32]
c0d00916:	2000      	movs	r0, #0

                        unsigned int bip44_path[BIP44_PATH_LEN];
                        uint32_t i;
                        for (i = 0; i < BIP44_PATH_LEN; i++) {
                            bip44_path[i] =
                                    (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
c0d00918:	0081      	lsls	r1, r0, #2
c0d0091a:	187a      	adds	r2, r7, r1
c0d0091c:	7953      	ldrb	r3, [r2, #5]
c0d0091e:	061b      	lsls	r3, r3, #24
c0d00920:	7994      	ldrb	r4, [r2, #6]
c0d00922:	0424      	lsls	r4, r4, #16
c0d00924:	431c      	orrs	r4, r3
c0d00926:	79d3      	ldrb	r3, [r2, #7]
c0d00928:	021b      	lsls	r3, r3, #8
c0d0092a:	4323      	orrs	r3, r4
c0d0092c:	7a12      	ldrb	r2, [r2, #8]
c0d0092e:	431a      	orrs	r2, r3
c0d00930:	ab2c      	add	r3, sp, #176	; 0xb0
                        unsigned char *bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;

                        unsigned int bip44_path[BIP44_PATH_LEN];
                        uint32_t i;
                        for (i = 0; i < BIP44_PATH_LEN; i++) {
                            bip44_path[i] =
c0d00932:	505a      	str	r2, [r3, r1]
                        /** BIP44 path, used to derive the private key from the mnemonic by calling os_perso_derive_node_bip32. */
                        unsigned char *bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;

                        unsigned int bip44_path[BIP44_PATH_LEN];
                        uint32_t i;
                        for (i = 0; i < BIP44_PATH_LEN; i++) {
c0d00934:	1c40      	adds	r0, r0, #1
c0d00936:	2805      	cmp	r0, #5
c0d00938:	d1ee      	bne.n	c0d00918 <ont_main+0x1a4>
c0d0093a:	2500      	movs	r5, #0
                            bip44_path[i] =
                                    (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
                            bip44_in += 4;
                        }
                        unsigned char privateKeyData[32];
                        os_perso_derive_node_bip32(CX_CURVE_256R1, bip44_path, BIP44_PATH_LEN, privateKeyData, NULL);
c0d0093c:	4668      	mov	r0, sp
c0d0093e:	6005      	str	r5, [r0, #0]
c0d00940:	2622      	movs	r6, #34	; 0x22
c0d00942:	a92c      	add	r1, sp, #176	; 0xb0
c0d00944:	2205      	movs	r2, #5
c0d00946:	af39      	add	r7, sp, #228	; 0xe4
c0d00948:	4630      	mov	r0, r6
c0d0094a:	463b      	mov	r3, r7
c0d0094c:	f001 fc42 	bl	c0d021d4 <os_perso_derive_node_bip32>
                        cx_ecdsa_init_private_key(CX_CURVE_256R1, privateKeyData, 32, &privateKey);
c0d00950:	2220      	movs	r2, #32
c0d00952:	ac43      	add	r4, sp, #268	; 0x10c
c0d00954:	4630      	mov	r0, r6
c0d00956:	4639      	mov	r1, r7
c0d00958:	4623      	mov	r3, r4
c0d0095a:	f001 fbeb 	bl	c0d02134 <cx_ecfp_init_private_key>
c0d0095e:	af09      	add	r7, sp, #36	; 0x24

                        // generate the public key.
                        cx_ecdsa_init_public_key(CX_CURVE_256R1, NULL, 0, &publicKey);
c0d00960:	4630      	mov	r0, r6
c0d00962:	4629      	mov	r1, r5
c0d00964:	462a      	mov	r2, r5
c0d00966:	463b      	mov	r3, r7
c0d00968:	f001 fbcc 	bl	c0d02104 <cx_ecfp_init_public_key>
c0d0096c:	2501      	movs	r5, #1
                        cx_ecfp_generate_pair(CX_CURVE_256R1, &publicKey, &privateKey, 1);
c0d0096e:	4630      	mov	r0, r6
c0d00970:	4639      	mov	r1, r7
c0d00972:	4622      	mov	r2, r4
c0d00974:	462b      	mov	r3, r5
c0d00976:	f001 fbf5 	bl	c0d02164 <cx_ecfp_generate_pair>

                        // push the public key onto the response buffer.
                        os_memmove(G_io_apdu_buffer, publicKey.W, 65);
c0d0097a:	3708      	adds	r7, #8
c0d0097c:	4865      	ldr	r0, [pc, #404]	; (c0d00b14 <ont_main+0x3a0>)
c0d0097e:	2441      	movs	r4, #65	; 0x41
c0d00980:	4639      	mov	r1, r7
c0d00982:	4622      	mov	r2, r4
c0d00984:	f000 fc31 	bl	c0d011ea <os_memmove>
                        tx = 65;
c0d00988:	9463      	str	r4, [sp, #396]	; 0x18c

                        display_public_key(publicKey.W);
c0d0098a:	4638      	mov	r0, r7
c0d0098c:	f000 fa7c 	bl	c0d00e88 <display_public_key>
    return 0;
}

/** refreshes the display if the public key was changed ans we are on the page displaying the public key */
static void refresh_public_key_display(void) {
    if ((uiState == UI_PUBLIC_KEY_1) || (uiState == UI_PUBLIC_KEY_2)) {
c0d00990:	4866      	ldr	r0, [pc, #408]	; (c0d00b2c <ont_main+0x3b8>)
c0d00992:	7800      	ldrb	r0, [r0, #0]
c0d00994:	1fc0      	subs	r0, r0, #7
c0d00996:	b2c0      	uxtb	r0, r0
c0d00998:	2801      	cmp	r0, #1
c0d0099a:	d900      	bls.n	c0d0099e <ont_main+0x22a>
c0d0099c:	e085      	b.n	c0d00aaa <ont_main+0x336>
        publicKeyNeedsRefresh = 1;
c0d0099e:	4864      	ldr	r0, [pc, #400]	; (c0d00b30 <ont_main+0x3bc>)
c0d009a0:	7005      	strb	r5, [r0, #0]
c0d009a2:	e082      	b.n	c0d00aaa <ont_main+0x336>
c0d009a4:	9208      	str	r2, [sp, #32]
c0d009a6:	4a5e      	ldr	r2, [pc, #376]	; (c0d00b20 <ont_main+0x3ac>)
    exit_timer = MAX_EXIT_TIMER;
    Timer_UpdateDescription();
}

static void Timer_Restart() {
    if (exit_timer != MAX_EXIT_TIMER) {
c0d009a8:	6811      	ldr	r1, [r2, #0]
c0d009aa:	4281      	cmp	r1, r0
c0d009ac:	d008      	beq.n	c0d009c0 <ont_main+0x24c>
        Timer_UpdateDescription();
    }
}

static void Timer_Set() {
    exit_timer = MAX_EXIT_TIMER;
c0d009ae:	6010      	str	r0, [r2, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
    snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d009b0:	485c      	ldr	r0, [pc, #368]	; (c0d00b24 <ont_main+0x3b0>)
c0d009b2:	2104      	movs	r1, #4
c0d009b4:	a25c      	add	r2, pc, #368	; (adr r2, c0d00b28 <ont_main+0x3b4>)
c0d009b6:	461d      	mov	r5, r3
c0d009b8:	2308      	movs	r3, #8
c0d009ba:	f001 f8eb 	bl	c0d01b94 <snprintf>
c0d009be:	462b      	mov	r3, r5
                        Timer_Restart();

                        cx_ecfp_public_key_t publicKey;
                        cx_ecfp_private_key_t privateKey;

                        if (rx < APDU_HEADER_LENGTH + BIP44_BYTE_LENGTH) {
c0d009c0:	9864      	ldr	r0, [sp, #400]	; 0x190
c0d009c2:	2818      	cmp	r0, #24
c0d009c4:	d800      	bhi.n	c0d009c8 <ont_main+0x254>
c0d009c6:	e099      	b.n	c0d00afc <ont_main+0x388>
c0d009c8:	9307      	str	r3, [sp, #28]

                        unsigned int bip44_path[BIP44_PATH_LEN];
                        uint32_t i;
                        for (i = 0; i < BIP44_PATH_LEN; i++) {
                            bip44_path[i] =
                                    (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
c0d009ca:	00a0      	lsls	r0, r4, #2
c0d009cc:	1839      	adds	r1, r7, r0
c0d009ce:	794a      	ldrb	r2, [r1, #5]
c0d009d0:	0612      	lsls	r2, r2, #24
c0d009d2:	798b      	ldrb	r3, [r1, #6]
c0d009d4:	041b      	lsls	r3, r3, #16
c0d009d6:	4313      	orrs	r3, r2
c0d009d8:	79ca      	ldrb	r2, [r1, #7]
c0d009da:	0212      	lsls	r2, r2, #8
c0d009dc:	431a      	orrs	r2, r3
c0d009de:	7a09      	ldrb	r1, [r1, #8]
c0d009e0:	4311      	orrs	r1, r2
c0d009e2:	aa34      	add	r2, sp, #208	; 0xd0
                        unsigned char *bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;

                        unsigned int bip44_path[BIP44_PATH_LEN];
                        uint32_t i;
                        for (i = 0; i < BIP44_PATH_LEN; i++) {
                            bip44_path[i] =
c0d009e4:	5011      	str	r1, [r2, r0]
                        /** BIP44 path, used to derive the private key from the mnemonic by calling os_perso_derive_node_bip32. */
                        unsigned char *bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;

                        unsigned int bip44_path[BIP44_PATH_LEN];
                        uint32_t i;
                        for (i = 0; i < BIP44_PATH_LEN; i++) {
c0d009e6:	1c64      	adds	r4, r4, #1
c0d009e8:	2c05      	cmp	r4, #5
c0d009ea:	d1ee      	bne.n	c0d009ca <ont_main+0x256>
c0d009ec:	2400      	movs	r4, #0
                            bip44_path[i] =
                                    (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
                            bip44_in += 4;
                        }
                        unsigned char privateKeyData[32];
                        os_perso_derive_node_bip32(CX_CURVE_256R1, bip44_path, BIP44_PATH_LEN, privateKeyData, NULL);
c0d009ee:	4668      	mov	r0, sp
c0d009f0:	6004      	str	r4, [r0, #0]
c0d009f2:	2522      	movs	r5, #34	; 0x22
c0d009f4:	a934      	add	r1, sp, #208	; 0xd0
c0d009f6:	2205      	movs	r2, #5
c0d009f8:	ae2c      	add	r6, sp, #176	; 0xb0
c0d009fa:	4628      	mov	r0, r5
c0d009fc:	4633      	mov	r3, r6
c0d009fe:	f001 fbe9 	bl	c0d021d4 <os_perso_derive_node_bip32>
                        cx_ecdsa_init_private_key(CX_CURVE_256R1, privateKeyData, 32, &privateKey);
c0d00a02:	2220      	movs	r2, #32
c0d00a04:	ab39      	add	r3, sp, #228	; 0xe4
c0d00a06:	4628      	mov	r0, r5
c0d00a08:	4631      	mov	r1, r6
c0d00a0a:	9204      	str	r2, [sp, #16]
c0d00a0c:	461e      	mov	r6, r3
c0d00a0e:	f001 fb91 	bl	c0d02134 <cx_ecfp_init_private_key>
c0d00a12:	af43      	add	r7, sp, #268	; 0x10c

                        // generate the public key.
                        cx_ecdsa_init_public_key(CX_CURVE_256R1, NULL, 0, &publicKey);
c0d00a14:	4628      	mov	r0, r5
c0d00a16:	4621      	mov	r1, r4
c0d00a18:	9405      	str	r4, [sp, #20]
c0d00a1a:	4622      	mov	r2, r4
c0d00a1c:	463b      	mov	r3, r7
c0d00a1e:	f001 fb71 	bl	c0d02104 <cx_ecfp_init_public_key>
c0d00a22:	2301      	movs	r3, #1
                        cx_ecfp_generate_pair(CX_CURVE_256R1, &publicKey, &privateKey, 1);
c0d00a24:	4628      	mov	r0, r5
c0d00a26:	4639      	mov	r1, r7
c0d00a28:	4632      	mov	r2, r6
c0d00a2a:	461e      	mov	r6, r3
c0d00a2c:	f001 fb9a 	bl	c0d02164 <cx_ecfp_generate_pair>

                        // push the public key onto the response buffer.
                        os_memmove(G_io_apdu_buffer, publicKey.W, 65);
c0d00a30:	3708      	adds	r7, #8
c0d00a32:	4d38      	ldr	r5, [pc, #224]	; (c0d00b14 <ont_main+0x3a0>)
c0d00a34:	2441      	movs	r4, #65	; 0x41
c0d00a36:	4628      	mov	r0, r5
c0d00a38:	4639      	mov	r1, r7
c0d00a3a:	4622      	mov	r2, r4
c0d00a3c:	f000 fbd5 	bl	c0d011ea <os_memmove>
                        tx = 65;
c0d00a40:	9463      	str	r4, [sp, #396]	; 0x18c

                        display_public_key(publicKey.W);
c0d00a42:	4638      	mov	r0, r7
c0d00a44:	f000 fa20 	bl	c0d00e88 <display_public_key>
    return 0;
}

/** refreshes the display if the public key was changed ans we are on the page displaying the public key */
static void refresh_public_key_display(void) {
    if ((uiState == UI_PUBLIC_KEY_1) || (uiState == UI_PUBLIC_KEY_2)) {
c0d00a48:	4838      	ldr	r0, [pc, #224]	; (c0d00b2c <ont_main+0x3b8>)
c0d00a4a:	7800      	ldrb	r0, [r0, #0]
c0d00a4c:	1fc0      	subs	r0, r0, #7
c0d00a4e:	b2c0      	uxtb	r0, r0
c0d00a50:	2801      	cmp	r0, #1
c0d00a52:	d801      	bhi.n	c0d00a58 <ont_main+0x2e4>
        publicKeyNeedsRefresh = 1;
c0d00a54:	4836      	ldr	r0, [pc, #216]	; (c0d00b30 <ont_main+0x3bc>)
c0d00a56:	7006      	strb	r6, [r0, #0]
                        tx = 65;

                        display_public_key(publicKey.W);
                        refresh_public_key_display();

                        G_io_apdu_buffer[tx++] = 0xFF;
c0d00a58:	9863      	ldr	r0, [sp, #396]	; 0x18c
c0d00a5a:	1c41      	adds	r1, r0, #1
c0d00a5c:	9163      	str	r1, [sp, #396]	; 0x18c
c0d00a5e:	9a07      	ldr	r2, [sp, #28]
c0d00a60:	327f      	adds	r2, #127	; 0x7f
c0d00a62:	542a      	strb	r2, [r5, r0]
                        G_io_apdu_buffer[tx++] = 0xFF;
c0d00a64:	9863      	ldr	r0, [sp, #396]	; 0x18c
c0d00a66:	1c41      	adds	r1, r0, #1
c0d00a68:	9163      	str	r1, [sp, #396]	; 0x18c
c0d00a6a:	542a      	strb	r2, [r5, r0]
c0d00a6c:	ac09      	add	r4, sp, #36	; 0x24

                        unsigned char result[32];

                        cx_sha256_t pubKeyHash;
                        cx_sha256_init(&pubKeyHash);
c0d00a6e:	4620      	mov	r0, r4
c0d00a70:	f001 fb32 	bl	c0d020d8 <cx_sha256_init>
c0d00a74:	462e      	mov	r6, r5
c0d00a76:	ad24      	add	r5, sp, #144	; 0x90

                        cx_hash(&pubKeyHash.header, CX_LAST, publicKey.W, 65, result);
c0d00a78:	4668      	mov	r0, sp
c0d00a7a:	6005      	str	r5, [r0, #0]
                        tx = 65;

                        display_public_key(publicKey.W);
                        refresh_public_key_display();

                        G_io_apdu_buffer[tx++] = 0xFF;
c0d00a7c:	2101      	movs	r1, #1
                        unsigned char result[32];

                        cx_sha256_t pubKeyHash;
                        cx_sha256_init(&pubKeyHash);

                        cx_hash(&pubKeyHash.header, CX_LAST, publicKey.W, 65, result);
c0d00a7e:	2341      	movs	r3, #65	; 0x41
c0d00a80:	4620      	mov	r0, r4
c0d00a82:	463a      	mov	r2, r7
c0d00a84:	f7ff fb1e 	bl	c0d000c4 <cx_hash_X>
                        tx += cx_ecdsa_sign((void *) &privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, result,
c0d00a88:	9863      	ldr	r0, [sp, #396]	; 0x18c
c0d00a8a:	4669      	mov	r1, sp
c0d00a8c:	1830      	adds	r0, r6, r0
c0d00a8e:	9a04      	ldr	r2, [sp, #16]
c0d00a90:	600a      	str	r2, [r1, #0]
c0d00a92:	6048      	str	r0, [r1, #4]
c0d00a94:	9805      	ldr	r0, [sp, #20]
c0d00a96:	6088      	str	r0, [r1, #8]
c0d00a98:	a839      	add	r0, sp, #228	; 0xe4
c0d00a9a:	4926      	ldr	r1, [pc, #152]	; (c0d00b34 <ont_main+0x3c0>)
c0d00a9c:	2203      	movs	r2, #3
c0d00a9e:	462b      	mov	r3, r5
c0d00aa0:	f7ff fb75 	bl	c0d0018e <cx_ecdsa_sign_X>
c0d00aa4:	9963      	ldr	r1, [sp, #396]	; 0x18c
c0d00aa6:	1808      	adds	r0, r1, r0
c0d00aa8:	9063      	str	r0, [sp, #396]	; 0x18c
c0d00aaa:	9808      	ldr	r0, [sp, #32]
c0d00aac:	f000 fc51 	bl	c0d01352 <os_longjmp>
                flags = 0;

                // no apdu received, well, reset the session, and reset the
                // bootloader configuration
                if (rx == 0) {
                    hashTainted = 1;
c0d00ab0:	2001      	movs	r0, #1
c0d00ab2:	4919      	ldr	r1, [pc, #100]	; (c0d00b18 <ont_main+0x3a4>)
c0d00ab4:	7008      	strb	r0, [r1, #0]
                    THROW(0x6982);
c0d00ab6:	4827      	ldr	r0, [pc, #156]	; (c0d00b54 <ont_main+0x3e0>)
c0d00ab8:	f000 fc4b 	bl	c0d01352 <os_longjmp>
                }

                // if the buffer doesn't start with the magic byte, return an error.
                if (G_io_apdu_buffer[0] != CLA) {
                    hashTainted = 1;
c0d00abc:	2001      	movs	r0, #1
c0d00abe:	4916      	ldr	r1, [pc, #88]	; (c0d00b18 <ont_main+0x3a4>)
c0d00ac0:	7008      	strb	r0, [r1, #0]
                    THROW(0x6E00);
c0d00ac2:	2037      	movs	r0, #55	; 0x37
c0d00ac4:	0240      	lsls	r0, r0, #9
c0d00ac6:	f000 fc44 	bl	c0d01352 <os_longjmp>
                        goto return_to_dashboard;

                        // we're asked to do an unknown command
                    default:
                        // return an error.
                        hashTainted = 1;
c0d00aca:	2001      	movs	r0, #1
c0d00acc:	4912      	ldr	r1, [pc, #72]	; (c0d00b18 <ont_main+0x3a4>)
c0d00ace:	7008      	strb	r0, [r1, #0]
                        THROW(0x6D00);
c0d00ad0:	9806      	ldr	r0, [sp, #24]
c0d00ad2:	f000 fc3e 	bl	c0d01352 <os_longjmp>
                    // we're getting a transaction to sign, in parts.
                    case INS_SIGN: {
                        Timer_Restart();
                        // check the third byte (0x02) for the instruction subtype.
                        if ((G_io_apdu_buffer[2] != P1_MORE) && (G_io_apdu_buffer[2] != P1_LAST)) {
                            hashTainted = 1;
c0d00ad6:	2001      	movs	r0, #1
c0d00ad8:	7020      	strb	r0, [r4, #0]
                            THROW(0x6A86);
c0d00ada:	481d      	ldr	r0, [pc, #116]	; (c0d00b50 <ont_main+0x3dc>)
c0d00adc:	f000 fc39 	bl	c0d01352 <os_longjmp>
                        // move the contents of the buffer into raw_tx, and update raw_tx_ix to the end of the buffer, to be ready for the next part of the tx.
                        unsigned int len = get_apdu_buffer_length();
                        unsigned char *in = G_io_apdu_buffer + APDU_HEADER_LENGTH;
                        unsigned char *out = raw_tx + raw_tx_ix;
                        if (raw_tx_ix + len > MAX_TX_RAW_LENGTH) {
                            hashTainted = 1;
c0d00ae0:	2001      	movs	r0, #1
c0d00ae2:	490d      	ldr	r1, [pc, #52]	; (c0d00b18 <ont_main+0x3a4>)
c0d00ae4:	7008      	strb	r0, [r1, #0]
c0d00ae6:	9806      	ldr	r0, [sp, #24]
                            THROW(0x6D08);
c0d00ae8:	3008      	adds	r0, #8
c0d00aea:	f000 fc32 	bl	c0d01352 <os_longjmp>

                        cx_ecfp_public_key_t publicKey;
                        cx_ecfp_private_key_t privateKey;

                        if (rx < APDU_HEADER_LENGTH + BIP44_BYTE_LENGTH) {
                            hashTainted = 1;
c0d00aee:	2001      	movs	r0, #1
c0d00af0:	4909      	ldr	r1, [pc, #36]	; (c0d00b18 <ont_main+0x3a4>)
c0d00af2:	7008      	strb	r0, [r1, #0]
c0d00af4:	9806      	ldr	r0, [sp, #24]
                            THROW(0x6D09);
c0d00af6:	3009      	adds	r0, #9
c0d00af8:	f000 fc2b 	bl	c0d01352 <os_longjmp>

                        cx_ecfp_public_key_t publicKey;
                        cx_ecfp_private_key_t privateKey;

                        if (rx < APDU_HEADER_LENGTH + BIP44_BYTE_LENGTH) {
                            hashTainted = 1;
c0d00afc:	2001      	movs	r0, #1
c0d00afe:	4906      	ldr	r1, [pc, #24]	; (c0d00b18 <ont_main+0x3a4>)
c0d00b00:	7008      	strb	r0, [r1, #0]
c0d00b02:	9806      	ldr	r0, [sp, #24]
                            THROW(0x6D10);
c0d00b04:	3010      	adds	r0, #16
c0d00b06:	f000 fc24 	bl	c0d01352 <os_longjmp>
c0d00b0a:	46c0      	nop			; (mov r8, r8)
c0d00b0c:	0000ffff 	.word	0x0000ffff
c0d00b10:	000007ff 	.word	0x000007ff
c0d00b14:	200018f8 	.word	0x200018f8
c0d00b18:	20001f60 	.word	0x20001f60
c0d00b1c:	00001002 	.word	0x00001002
c0d00b20:	2000201c 	.word	0x2000201c
c0d00b24:	20002020 	.word	0x20002020
c0d00b28:	00006425 	.word	0x00006425
c0d00b2c:	20001f68 	.word	0x20001f68
c0d00b30:	20002024 	.word	0x20002024
c0d00b34:	00000601 	.word	0x00000601
c0d00b38:	20001af4 	.word	0x20001af4
c0d00b3c:	20001f64 	.word	0x20001f64
c0d00b40:	20001af0 	.word	0x20001af0
c0d00b44:	00000401 	.word	0x00000401
c0d00b48:	20001b60 	.word	0x20001b60
c0d00b4c:	20002028 	.word	0x20002028
c0d00b50:	00006a86 	.word	0x00006a86
c0d00b54:	00006982 	.word	0x00006982

c0d00b58 <display_tx_desc>:
        THROW(0x6D05);
        return 0;
    }
}

void display_tx_desc() {
c0d00b58:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00b5a:	b0a7      	sub	sp, #156	; 0x9c
c0d00b5c:	2001      	movs	r0, #1
c0d00b5e:	43c6      	mvns	r6, r0
c0d00b60:	2000      	movs	r0, #0
c0d00b62:	4c96      	ldr	r4, [pc, #600]	; (c0d00dbc <display_tx_desc+0x264>)
c0d00b64:	4b98      	ldr	r3, [pc, #608]	; (c0d00dc8 <display_tx_desc+0x270>)
c0d00b66:	447b      	add	r3, pc
c0d00b68:	9304      	str	r3, [sp, #16]
    for (unsigned int src_ix = 0, dest_ix = 0; dest_ix < dest_len; src_ix++, dest_ix += 2) {
        unsigned char src_c = *(src + src_ix);
        unsigned char nibble0 = (src_c >> 4) & 0xF;
        unsigned char nibble1 = src_c & 0xF;

        *(dest + dest_ix + 0) = HEX_CAP[nibble0];
c0d00b6a:	4631      	mov	r1, r6
c0d00b6c:	4341      	muls	r1, r0
}

/** converts a byte array in src to a hex array in dest, using only dest_len bytes of dest before stopping. */
static void to_hex(char *dest, const unsigned char *src, const unsigned int dest_len) {
    for (unsigned int src_ix = 0, dest_ix = 0; dest_ix < dest_len; src_ix++, dest_ix += 2) {
        unsigned char src_c = *(src + src_ix);
c0d00b6e:	1c77      	adds	r7, r6, #1
c0d00b70:	463a      	mov	r2, r7
c0d00b72:	4342      	muls	r2, r0
c0d00b74:	18a2      	adds	r2, r4, r2
c0d00b76:	235e      	movs	r3, #94	; 0x5e
c0d00b78:	5cd2      	ldrb	r2, [r2, r3]
        unsigned char nibble0 = (src_c >> 4) & 0xF;
c0d00b7a:	0913      	lsrs	r3, r2, #4
        unsigned char nibble1 = src_c & 0xF;

        *(dest + dest_ix + 0) = HEX_CAP[nibble0];
c0d00b7c:	9c04      	ldr	r4, [sp, #16]
c0d00b7e:	5ce3      	ldrb	r3, [r4, r3]
c0d00b80:	ac22      	add	r4, sp, #136	; 0x88
c0d00b82:	5463      	strb	r3, [r4, r1]
c0d00b84:	9b04      	ldr	r3, [sp, #16]
c0d00b86:	1861      	adds	r1, r4, r1
c0d00b88:	4c8c      	ldr	r4, [pc, #560]	; (c0d00dbc <display_tx_desc+0x264>)
c0d00b8a:	250f      	movs	r5, #15
        *(dest + dest_ix + 1) = HEX_CAP[nibble1];
c0d00b8c:	402a      	ands	r2, r5
c0d00b8e:	5c9a      	ldrb	r2, [r3, r2]
c0d00b90:	704a      	strb	r2, [r1, #1]
    encode_base_58(address, ADDRESS_LEN, dest, dest_len);
}

/** converts a byte array in src to a hex array in dest, using only dest_len bytes of dest before stopping. */
static void to_hex(char *dest, const unsigned char *src, const unsigned int dest_len) {
    for (unsigned int src_ix = 0, dest_ix = 0; dest_ix < dest_len; src_ix++, dest_ix += 2) {
c0d00b92:	1e40      	subs	r0, r0, #1
c0d00b94:	4601      	mov	r1, r0
c0d00b96:	3109      	adds	r1, #9
c0d00b98:	d1e7      	bne.n	c0d00b6a <display_tx_desc+0x12>
c0d00b9a:	9702      	str	r7, [sp, #8]
c0d00b9c:	9503      	str	r5, [sp, #12]
c0d00b9e:	a822      	add	r0, sp, #136	; 0x88

    to_hex(amount_buf, &raw_tx[94], 18);


    char amountChar[MAX_TX_TEXT_WIDTH];
    if (amount_buf[0] == '5') {
c0d00ba0:	7800      	ldrb	r0, [r0, #0]
c0d00ba2:	2836      	cmp	r0, #54	; 0x36
c0d00ba4:	d00e      	beq.n	c0d00bc4 <display_tx_desc+0x6c>
c0d00ba6:	2835      	cmp	r0, #53	; 0x35
c0d00ba8:	d11e      	bne.n	c0d00be8 <display_tx_desc+0x90>
c0d00baa:	a822      	add	r0, sp, #136	; 0x88
        if (amount_buf[1] >= 'A') {
c0d00bac:	7840      	ldrb	r0, [r0, #1]
c0d00bae:	2841      	cmp	r0, #65	; 0x41
c0d00bb0:	d200      	bcs.n	c0d00bb4 <display_tx_desc+0x5c>
c0d00bb2:	e08c      	b.n	c0d00cce <display_tx_desc+0x176>
c0d00bb4:	a91d      	add	r1, sp, #116	; 0x74
            amountChar[4] = '1';
c0d00bb6:	2231      	movs	r2, #49	; 0x31
c0d00bb8:	710a      	strb	r2, [r1, #4]
            amountChar[5] = amount_buf[1] - 'A' + '0';
c0d00bba:	30ef      	adds	r0, #239	; 0xef
c0d00bbc:	7148      	strb	r0, [r1, #5]
            amountChar[3] = ':';
            amountChar[2] = 'm';
            amountChar[1] = 'u';
            amountChar[0] = 'N';
c0d00bbe:	4881      	ldr	r0, [pc, #516]	; (c0d00dc4 <display_tx_desc+0x26c>)
c0d00bc0:	901d      	str	r0, [sp, #116]	; 0x74
c0d00bc2:	e00c      	b.n	c0d00bde <display_tx_desc+0x86>
c0d00bc4:	a91d      	add	r1, sp, #116	; 0x74
            amountChar[1] = 'u';
            amountChar[0] = 'N';
            os_memmove(curr_tx_desc[0], amountChar, 5);
        }
    } else if (amount_buf[0] == '6') {
        amountChar[4] = '1';
c0d00bc6:	2031      	movs	r0, #49	; 0x31
c0d00bc8:	7108      	strb	r0, [r1, #4]
        amountChar[5] = '6';
c0d00bca:	2036      	movs	r0, #54	; 0x36
c0d00bcc:	7148      	strb	r0, [r1, #5]
        amountChar[3] = ':';
c0d00bce:	203a      	movs	r0, #58	; 0x3a
c0d00bd0:	70c8      	strb	r0, [r1, #3]
        amountChar[2] = 'm';
c0d00bd2:	206d      	movs	r0, #109	; 0x6d
c0d00bd4:	7088      	strb	r0, [r1, #2]
        amountChar[1] = 'u';
c0d00bd6:	2075      	movs	r0, #117	; 0x75
c0d00bd8:	7048      	strb	r0, [r1, #1]
        amountChar[0] = 'N';
c0d00bda:	204e      	movs	r0, #78	; 0x4e
c0d00bdc:	7008      	strb	r0, [r1, #0]
c0d00bde:	4878      	ldr	r0, [pc, #480]	; (c0d00dc0 <display_tx_desc+0x268>)
c0d00be0:	2206      	movs	r2, #6
c0d00be2:	f000 fb02 	bl	c0d011ea <os_memmove>
c0d00be6:	e096      	b.n	c0d00d16 <display_tx_desc+0x1be>
c0d00be8:	a922      	add	r1, sp, #136	; 0x88
        os_memmove(curr_tx_desc[0], amountChar, 6);
    } else if (amount_buf[1] == '8' || (amount_buf[0] == '1' && amount_buf[1] == '4')) {
c0d00bea:	7849      	ldrb	r1, [r1, #1]
c0d00bec:	2938      	cmp	r1, #56	; 0x38
c0d00bee:	9d02      	ldr	r5, [sp, #8]
c0d00bf0:	d01d      	beq.n	c0d00c2e <display_tx_desc+0xd6>
c0d00bf2:	2831      	cmp	r0, #49	; 0x31
c0d00bf4:	d000      	beq.n	c0d00bf8 <display_tx_desc+0xa0>
c0d00bf6:	e08e      	b.n	c0d00d16 <display_tx_desc+0x1be>
c0d00bf8:	2934      	cmp	r1, #52	; 0x34
c0d00bfa:	d000      	beq.n	c0d00bfe <display_tx_desc+0xa6>
c0d00bfc:	e08b      	b.n	c0d00d16 <display_tx_desc+0x1be>
c0d00bfe:	2000      	movs	r0, #0
c0d00c00:	9f04      	ldr	r7, [sp, #16]
c0d00c02:	9d02      	ldr	r5, [sp, #8]
    for (unsigned int src_ix = 0, dest_ix = 0; dest_ix < dest_len; src_ix++, dest_ix += 2) {
        unsigned char src_c = *(src + src_ix);
        unsigned char nibble0 = (src_c >> 4) & 0xF;
        unsigned char nibble1 = src_c & 0xF;

        *(dest + dest_ix + 0) = HEX_CAP[nibble0];
c0d00c04:	4631      	mov	r1, r6
c0d00c06:	4341      	muls	r1, r0
}

/** converts a byte array in src to a hex array in dest, using only dest_len bytes of dest before stopping. */
static void to_hex(char *dest, const unsigned char *src, const unsigned int dest_len) {
    for (unsigned int src_ix = 0, dest_ix = 0; dest_ix < dest_len; src_ix++, dest_ix += 2) {
        unsigned char src_c = *(src + src_ix);
c0d00c08:	462a      	mov	r2, r5
c0d00c0a:	4342      	muls	r2, r0
c0d00c0c:	18a2      	adds	r2, r4, r2
c0d00c0e:	2376      	movs	r3, #118	; 0x76
c0d00c10:	5cd2      	ldrb	r2, [r2, r3]
        unsigned char nibble0 = (src_c >> 4) & 0xF;
c0d00c12:	0913      	lsrs	r3, r2, #4
        unsigned char nibble1 = src_c & 0xF;

        *(dest + dest_ix + 0) = HEX_CAP[nibble0];
c0d00c14:	5cfb      	ldrb	r3, [r7, r3]
c0d00c16:	ac22      	add	r4, sp, #136	; 0x88
c0d00c18:	5463      	strb	r3, [r4, r1]
c0d00c1a:	1861      	adds	r1, r4, r1
c0d00c1c:	4c67      	ldr	r4, [pc, #412]	; (c0d00dbc <display_tx_desc+0x264>)
        *(dest + dest_ix + 1) = HEX_CAP[nibble1];
c0d00c1e:	9b03      	ldr	r3, [sp, #12]
c0d00c20:	401a      	ands	r2, r3
c0d00c22:	5cba      	ldrb	r2, [r7, r2]
c0d00c24:	704a      	strb	r2, [r1, #1]
    encode_base_58(address, ADDRESS_LEN, dest, dest_len);
}

/** converts a byte array in src to a hex array in dest, using only dest_len bytes of dest before stopping. */
static void to_hex(char *dest, const unsigned char *src, const unsigned int dest_len) {
    for (unsigned int src_ix = 0, dest_ix = 0; dest_ix < dest_len; src_ix++, dest_ix += 2) {
c0d00c26:	1e40      	subs	r0, r0, #1
c0d00c28:	4601      	mov	r1, r0
c0d00c2a:	3109      	adds	r1, #9
c0d00c2c:	d1ea      	bne.n	c0d00c04 <display_tx_desc+0xac>
c0d00c2e:	9601      	str	r6, [sp, #4]
c0d00c30:	2000      	movs	r0, #0
    } else if (amount_buf[1] == '8' || (amount_buf[0] == '1' && amount_buf[1] == '4')) {
        if (amount_buf[0] == '1' && amount_buf[1] == '4') {
            to_hex(amount_buf, &raw_tx[94 + 24], 18);
        }
        for (int i = 0; i < 16; i = i + 2) {
            amountChar[i] = amount_buf[2 + 16 - i - 2];
c0d00c32:	4629      	mov	r1, r5
c0d00c34:	4341      	muls	r1, r0
c0d00c36:	aa22      	add	r2, sp, #136	; 0x88
c0d00c38:	1851      	adds	r1, r2, r1
c0d00c3a:	7c0a      	ldrb	r2, [r1, #16]
c0d00c3c:	ab1d      	add	r3, sp, #116	; 0x74
c0d00c3e:	541a      	strb	r2, [r3, r0]
c0d00c40:	181a      	adds	r2, r3, r0
            amountChar[i + 1] = amount_buf[2 + 16 - i - 1];
c0d00c42:	7c49      	ldrb	r1, [r1, #17]
c0d00c44:	7051      	strb	r1, [r2, #1]
        os_memmove(curr_tx_desc[0], amountChar, 6);
    } else if (amount_buf[1] == '8' || (amount_buf[0] == '1' && amount_buf[1] == '4')) {
        if (amount_buf[0] == '1' && amount_buf[1] == '4') {
            to_hex(amount_buf, &raw_tx[94 + 24], 18);
        }
        for (int i = 0; i < 16; i = i + 2) {
c0d00c46:	1c80      	adds	r0, r0, #2
c0d00c48:	2810      	cmp	r0, #16
c0d00c4a:	dbf2      	blt.n	c0d00c32 <display_tx_desc+0xda>
c0d00c4c:	2400      	movs	r4, #0
c0d00c4e:	4620      	mov	r0, r4
c0d00c50:	ab1d      	add	r3, sp, #116	; 0x74
        int amount = 0;
        for (int i = 0; i < 16; i = i + 2) {
            unsigned char high = '0';
            unsigned char low = '0';

            high = amountChar[i] >= 'A' ? amountChar[i] - 'A' + 10 : amountChar[i] - '0';
c0d00c52:	5c1e      	ldrb	r6, [r3, r0]
c0d00c54:	22c9      	movs	r2, #201	; 0xc9
c0d00c56:	25d0      	movs	r5, #208	; 0xd0
c0d00c58:	2e40      	cmp	r6, #64	; 0x40
c0d00c5a:	4611      	mov	r1, r2
c0d00c5c:	d800      	bhi.n	c0d00c60 <display_tx_desc+0x108>
c0d00c5e:	4629      	mov	r1, r5
c0d00c60:	1989      	adds	r1, r1, r6
            low = amountChar[i + 1] >= 'A' ? amountChar[i + 1] - 'A' + 10 : amountChar[i + 1] - '0';
            amount += (high * 16 + low) << ((7 - i / 2) * 8);
c0d00c62:	0109      	lsls	r1, r1, #4
c0d00c64:	26ff      	movs	r6, #255	; 0xff
c0d00c66:	0136      	lsls	r6, r6, #4
c0d00c68:	400e      	ands	r6, r1
        int amount = 0;
        for (int i = 0; i < 16; i = i + 2) {
            unsigned char high = '0';
            unsigned char low = '0';

            high = amountChar[i] >= 'A' ? amountChar[i] - 'A' + 10 : amountChar[i] - '0';
c0d00c6a:	1819      	adds	r1, r3, r0
            low = amountChar[i + 1] >= 'A' ? amountChar[i + 1] - 'A' + 10 : amountChar[i + 1] - '0';
c0d00c6c:	784b      	ldrb	r3, [r1, #1]
c0d00c6e:	2b40      	cmp	r3, #64	; 0x40
c0d00c70:	d800      	bhi.n	c0d00c74 <display_tx_desc+0x11c>
c0d00c72:	462a      	mov	r2, r5
c0d00c74:	18d1      	adds	r1, r2, r3
            amount += (high * 16 + low) << ((7 - i / 2) * 8);
c0d00c76:	b2c9      	uxtb	r1, r1
c0d00c78:	1871      	adds	r1, r6, r1
c0d00c7a:	0fc2      	lsrs	r2, r0, #31
c0d00c7c:	1882      	adds	r2, r0, r2
c0d00c7e:	0852      	lsrs	r2, r2, #1
c0d00c80:	2307      	movs	r3, #7
c0d00c82:	1a9a      	subs	r2, r3, r2
c0d00c84:	00d2      	lsls	r2, r2, #3
c0d00c86:	4091      	lsls	r1, r2
c0d00c88:	190c      	adds	r4, r1, r4
            amountChar[i] = amount_buf[2 + 16 - i - 2];
            amountChar[i + 1] = amount_buf[2 + 16 - i - 1];
        }

        int amount = 0;
        for (int i = 0; i < 16; i = i + 2) {
c0d00c8a:	1c80      	adds	r0, r0, #2
c0d00c8c:	2810      	cmp	r0, #16
c0d00c8e:	dbdf      	blt.n	c0d00c50 <display_tx_desc+0xf8>
c0d00c90:	250a      	movs	r5, #10

            high = amountChar[i] >= 'A' ? amountChar[i] - 'A' + 10 : amountChar[i] - '0';
            low = amountChar[i + 1] >= 'A' ? amountChar[i + 1] - 'A' + 10 : amountChar[i + 1] - '0';
            amount += (high * 16 + low) << ((7 - i / 2) * 8);
        }
        amountChar[15] = amount % 10 + '0';
c0d00c92:	4620      	mov	r0, r4
c0d00c94:	4629      	mov	r1, r5
c0d00c96:	f003 fdcf 	bl	c0d04838 <__aeabi_idivmod>
c0d00c9a:	3130      	adds	r1, #48	; 0x30
c0d00c9c:	a81d      	add	r0, sp, #116	; 0x74
c0d00c9e:	73c1      	strb	r1, [r0, #15]
c0d00ca0:	210a      	movs	r1, #10
c0d00ca2:	4620      	mov	r0, r4
c0d00ca4:	f003 fce2 	bl	c0d0466c <__aeabi_idiv>
c0d00ca8:	4606      	mov	r6, r0
        amount = amount / 10;
        int index = 0;
        for (int i = 14; i >= 0; i--) {
            if (amount < 10) {
c0d00caa:	2c64      	cmp	r4, #100	; 0x64
c0d00cac:	db18      	blt.n	c0d00ce0 <display_tx_desc+0x188>
                amountChar[i] = amount + '0';
                amount = amount / 10;
                index = i;
                break;
            }
            amountChar[i] = amount % 10 + '0';
c0d00cae:	210a      	movs	r1, #10
c0d00cb0:	4630      	mov	r0, r6
c0d00cb2:	f003 fdc1 	bl	c0d04838 <__aeabi_idivmod>
c0d00cb6:	a81d      	add	r0, sp, #116	; 0x74
c0d00cb8:	1940      	adds	r0, r0, r5
c0d00cba:	3130      	adds	r1, #48	; 0x30
c0d00cbc:	7101      	strb	r1, [r0, #4]
            amount += (high * 16 + low) << ((7 - i / 2) * 8);
        }
        amountChar[15] = amount % 10 + '0';
        amount = amount / 10;
        int index = 0;
        for (int i = 14; i >= 0; i--) {
c0d00cbe:	1e69      	subs	r1, r5, #1
c0d00cc0:	1d2a      	adds	r2, r5, #4
c0d00cc2:	2000      	movs	r0, #0
c0d00cc4:	2a00      	cmp	r2, #0
c0d00cc6:	460d      	mov	r5, r1
c0d00cc8:	4634      	mov	r4, r6
c0d00cca:	dce9      	bgt.n	c0d00ca0 <display_tx_desc+0x148>
c0d00ccc:	e01a      	b.n	c0d00d04 <display_tx_desc+0x1ac>
c0d00cce:	a91d      	add	r1, sp, #116	; 0x74
            amountChar[2] = 'm';
            amountChar[1] = 'u';
            amountChar[0] = 'N';
            os_memmove(curr_tx_desc[0], amountChar, 6);
        } else {
            amountChar[4] = amount_buf[1];
c0d00cd0:	7108      	strb	r0, [r1, #4]
            amountChar[3] = ':';
            amountChar[2] = 'm';
            amountChar[1] = 'u';
            amountChar[0] = 'N';
c0d00cd2:	483c      	ldr	r0, [pc, #240]	; (c0d00dc4 <display_tx_desc+0x26c>)
c0d00cd4:	901d      	str	r0, [sp, #116]	; 0x74
            os_memmove(curr_tx_desc[0], amountChar, 5);
c0d00cd6:	483a      	ldr	r0, [pc, #232]	; (c0d00dc0 <display_tx_desc+0x268>)
c0d00cd8:	2205      	movs	r2, #5
c0d00cda:	f000 fa86 	bl	c0d011ea <os_memmove>
c0d00cde:	e01a      	b.n	c0d00d16 <display_tx_desc+0x1be>
c0d00ce0:	a81d      	add	r0, sp, #116	; 0x74
        amountChar[15] = amount % 10 + '0';
        amount = amount / 10;
        int index = 0;
        for (int i = 14; i >= 0; i--) {
            if (amount < 10) {
                amountChar[i] = amount + '0';
c0d00ce2:	1940      	adds	r0, r0, r5
c0d00ce4:	3630      	adds	r6, #48	; 0x30
c0d00ce6:	7106      	strb	r6, [r0, #4]
                break;
            }
            amountChar[i] = amount % 10 + '0';
            amount = amount / 10;
        }
        if (index >= 4) {
c0d00ce8:	1d28      	adds	r0, r5, #4
c0d00cea:	2804      	cmp	r0, #4
c0d00cec:	db0a      	blt.n	c0d00d04 <display_tx_desc+0x1ac>
c0d00cee:	a81d      	add	r0, sp, #116	; 0x74
            amountChar[index - 1] = ':';
c0d00cf0:	1941      	adds	r1, r0, r5
c0d00cf2:	223a      	movs	r2, #58	; 0x3a
c0d00cf4:	70ca      	strb	r2, [r1, #3]
            amountChar[index - 2] = 'm';
c0d00cf6:	226d      	movs	r2, #109	; 0x6d
c0d00cf8:	708a      	strb	r2, [r1, #2]
            amountChar[index - 3] = 'u';
c0d00cfa:	2275      	movs	r2, #117	; 0x75
c0d00cfc:	704a      	strb	r2, [r1, #1]
            amountChar[index - 4] = 'N';
c0d00cfe:	214e      	movs	r1, #78	; 0x4e
c0d00d00:	5541      	strb	r1, [r0, r5]
c0d00d02:	4628      	mov	r0, r5
c0d00d04:	a91d      	add	r1, sp, #116	; 0x74
            index = index - 4;
        }
        os_memmove(curr_tx_desc[0], &amountChar[index], 16 - index);
c0d00d06:	1809      	adds	r1, r1, r0
c0d00d08:	2210      	movs	r2, #16
c0d00d0a:	1a12      	subs	r2, r2, r0
c0d00d0c:	482c      	ldr	r0, [pc, #176]	; (c0d00dc0 <display_tx_desc+0x268>)
c0d00d0e:	f000 fa6c 	bl	c0d011ea <os_memmove>
c0d00d12:	9e01      	ldr	r6, [sp, #4]
c0d00d14:	4c29      	ldr	r4, [pc, #164]	; (c0d00dbc <display_tx_desc+0x264>)
c0d00d16:	2000      	movs	r0, #0
c0d00d18:	9f04      	ldr	r7, [sp, #16]
c0d00d1a:	9d02      	ldr	r5, [sp, #8]
    for (unsigned int src_ix = 0, dest_ix = 0; dest_ix < dest_len; src_ix++, dest_ix += 2) {
        unsigned char src_c = *(src + src_ix);
        unsigned char nibble0 = (src_c >> 4) & 0xF;
        unsigned char nibble1 = src_c & 0xF;

        *(dest + dest_ix + 0) = HEX_CAP[nibble0];
c0d00d1c:	4631      	mov	r1, r6
c0d00d1e:	4341      	muls	r1, r0
}

/** converts a byte array in src to a hex array in dest, using only dest_len bytes of dest before stopping. */
static void to_hex(char *dest, const unsigned char *src, const unsigned int dest_len) {
    for (unsigned int src_ix = 0, dest_ix = 0; dest_ix < dest_len; src_ix++, dest_ix += 2) {
        unsigned char src_c = *(src + src_ix);
c0d00d20:	462a      	mov	r2, r5
c0d00d22:	4342      	muls	r2, r0
c0d00d24:	18a2      	adds	r2, r4, r2
c0d00d26:	2347      	movs	r3, #71	; 0x47
c0d00d28:	5cd2      	ldrb	r2, [r2, r3]
        unsigned char nibble0 = (src_c >> 4) & 0xF;
c0d00d2a:	0913      	lsrs	r3, r2, #4
        unsigned char nibble1 = src_c & 0xF;

        *(dest + dest_ix + 0) = HEX_CAP[nibble0];
c0d00d2c:	5cfb      	ldrb	r3, [r7, r3]
c0d00d2e:	ac13      	add	r4, sp, #76	; 0x4c
c0d00d30:	5463      	strb	r3, [r4, r1]
c0d00d32:	1861      	adds	r1, r4, r1
c0d00d34:	4c21      	ldr	r4, [pc, #132]	; (c0d00dbc <display_tx_desc+0x264>)
        *(dest + dest_ix + 1) = HEX_CAP[nibble1];
c0d00d36:	9b03      	ldr	r3, [sp, #12]
c0d00d38:	401a      	ands	r2, r3
c0d00d3a:	5cba      	ldrb	r2, [r7, r2]
c0d00d3c:	704a      	strb	r2, [r1, #1]
    encode_base_58(address, ADDRESS_LEN, dest, dest_len);
}

/** converts a byte array in src to a hex array in dest, using only dest_len bytes of dest before stopping. */
static void to_hex(char *dest, const unsigned char *src, const unsigned int dest_len) {
    for (unsigned int src_ix = 0, dest_ix = 0; dest_ix < dest_len; src_ix++, dest_ix += 2) {
c0d00d3e:	1e40      	subs	r0, r0, #1
c0d00d40:	4601      	mov	r1, r0
c0d00d42:	3114      	adds	r1, #20
c0d00d44:	d1ea      	bne.n	c0d00d1c <display_tx_desc+0x1c4>
c0d00d46:	2000      	movs	r0, #0
c0d00d48:	4635      	mov	r5, r6
    unsigned char script_hash[SCRIPT_HASH_LEN];

    for (int i = 0; i < SCRIPT_HASH_LEN; i++) {
        unsigned char high = '0';
        unsigned char low = '0';
        high = script_hash_buf[i * 2] >= 'A' ? script_hash_buf[i * 2] - 'A' + 10 : script_hash_buf[i * 2] - '0';
c0d00d4a:	4632      	mov	r2, r6
c0d00d4c:	4342      	muls	r2, r0
c0d00d4e:	ac13      	add	r4, sp, #76	; 0x4c
c0d00d50:	18a1      	adds	r1, r4, r2
        low = script_hash_buf[i * 2 + 1] >= 'A' ? script_hash_buf[i * 2 + 1] - 'A' + 10 : script_hash_buf[i * 2 + 1] -
c0d00d52:	784e      	ldrb	r6, [r1, #1]
    unsigned char script_hash[SCRIPT_HASH_LEN];

    for (int i = 0; i < SCRIPT_HASH_LEN; i++) {
        unsigned char high = '0';
        unsigned char low = '0';
        high = script_hash_buf[i * 2] >= 'A' ? script_hash_buf[i * 2] - 'A' + 10 : script_hash_buf[i * 2] - '0';
c0d00d54:	21c9      	movs	r1, #201	; 0xc9
c0d00d56:	23d0      	movs	r3, #208	; 0xd0
        low = script_hash_buf[i * 2 + 1] >= 'A' ? script_hash_buf[i * 2 + 1] - 'A' + 10 : script_hash_buf[i * 2 + 1] -
c0d00d58:	2e40      	cmp	r6, #64	; 0x40
c0d00d5a:	460f      	mov	r7, r1
c0d00d5c:	d800      	bhi.n	c0d00d60 <display_tx_desc+0x208>
c0d00d5e:	461f      	mov	r7, r3
c0d00d60:	19be      	adds	r6, r7, r6
    unsigned char script_hash[SCRIPT_HASH_LEN];

    for (int i = 0; i < SCRIPT_HASH_LEN; i++) {
        unsigned char high = '0';
        unsigned char low = '0';
        high = script_hash_buf[i * 2] >= 'A' ? script_hash_buf[i * 2] - 'A' + 10 : script_hash_buf[i * 2] - '0';
c0d00d62:	5ca2      	ldrb	r2, [r4, r2]
c0d00d64:	2a40      	cmp	r2, #64	; 0x40
c0d00d66:	d800      	bhi.n	c0d00d6a <display_tx_desc+0x212>
c0d00d68:	4619      	mov	r1, r3
c0d00d6a:	1889      	adds	r1, r1, r2
        low = script_hash_buf[i * 2 + 1] >= 'A' ? script_hash_buf[i * 2 + 1] - 'A' + 10 : script_hash_buf[i * 2 + 1] -
                                                                                          '0';
        script_hash[i] = high * 16 + low;
c0d00d6c:	0109      	lsls	r1, r1, #4
c0d00d6e:	1871      	adds	r1, r6, r1
c0d00d70:	9a02      	ldr	r2, [sp, #8]
c0d00d72:	4342      	muls	r2, r0
c0d00d74:	ab0e      	add	r3, sp, #56	; 0x38
c0d00d76:	5499      	strb	r1, [r3, r2]

    unsigned char script_hash_buf[SCRIPT_HASH_LEN * 2];
    to_hex(script_hash_buf, &raw_tx[71], SCRIPT_HASH_LEN * 2);
    unsigned char script_hash[SCRIPT_HASH_LEN];

    for (int i = 0; i < SCRIPT_HASH_LEN; i++) {
c0d00d78:	1e40      	subs	r0, r0, #1
c0d00d7a:	4601      	mov	r1, r0
c0d00d7c:	3114      	adds	r1, #20
c0d00d7e:	462e      	mov	r6, r5
c0d00d80:	d1e2      	bne.n	c0d00d48 <display_tx_desc+0x1f0>
c0d00d82:	ac05      	add	r4, sp, #20
c0d00d84:	a90e      	add	r1, sp, #56	; 0x38
    unsigned int address_base58_len_1 = 11;
    unsigned int address_base58_len_2 = 12;
    char *address_base58_0 = address_base58;
    char *address_base58_1 = address_base58 + address_base58_len_0;
    char *address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
    to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);
c0d00d86:	4620      	mov	r0, r4
c0d00d88:	f000 f820 	bl	c0d00dcc <to_address>

    os_memmove(curr_tx_desc[1], address_base58_0, address_base58_len_0);
c0d00d8c:	4d0c      	ldr	r5, [pc, #48]	; (c0d00dc0 <display_tx_desc+0x268>)
c0d00d8e:	4628      	mov	r0, r5
c0d00d90:	3012      	adds	r0, #18
c0d00d92:	260b      	movs	r6, #11
c0d00d94:	4621      	mov	r1, r4
c0d00d96:	4632      	mov	r2, r6
c0d00d98:	f000 fa27 	bl	c0d011ea <os_memmove>
    os_memmove(curr_tx_desc[2], address_base58_1, address_base58_len_1);
c0d00d9c:	4628      	mov	r0, r5
c0d00d9e:	3024      	adds	r0, #36	; 0x24
    char address_base58[ADDRESS_BASE58_LEN];
    unsigned int address_base58_len_0 = 11;
    unsigned int address_base58_len_1 = 11;
    unsigned int address_base58_len_2 = 12;
    char *address_base58_0 = address_base58;
    char *address_base58_1 = address_base58 + address_base58_len_0;
c0d00da0:	4621      	mov	r1, r4
c0d00da2:	310b      	adds	r1, #11
    char *address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
    to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);

    os_memmove(curr_tx_desc[1], address_base58_0, address_base58_len_0);
    os_memmove(curr_tx_desc[2], address_base58_1, address_base58_len_1);
c0d00da4:	4632      	mov	r2, r6
c0d00da6:	f000 fa20 	bl	c0d011ea <os_memmove>
    os_memmove(curr_tx_desc[3], address_base58_2, address_base58_len_2);
c0d00daa:	3536      	adds	r5, #54	; 0x36
    unsigned int address_base58_len_0 = 11;
    unsigned int address_base58_len_1 = 11;
    unsigned int address_base58_len_2 = 12;
    char *address_base58_0 = address_base58;
    char *address_base58_1 = address_base58 + address_base58_len_0;
    char *address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
c0d00dac:	3416      	adds	r4, #22
    to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);

    os_memmove(curr_tx_desc[1], address_base58_0, address_base58_len_0);
    os_memmove(curr_tx_desc[2], address_base58_1, address_base58_len_1);
    os_memmove(curr_tx_desc[3], address_base58_2, address_base58_len_2);
c0d00dae:	220c      	movs	r2, #12
c0d00db0:	4628      	mov	r0, r5
c0d00db2:	4621      	mov	r1, r4
c0d00db4:	f000 fa19 	bl	c0d011ea <os_memmove>
   // os_memmove(curr_tx_desc[0], tx_desc[0], CURR_TX_DESC_LEN);
   // os_memmove(curr_tx_desc[1], tx_desc[1], CURR_TX_DESC_LEN);
   // os_memmove(curr_tx_desc[2], tx_desc[2], CURR_TX_DESC_LEN);
   // os_memmove(curr_tx_desc[3], tx_desc[3], CURR_TX_DESC_LEN);

}
c0d00db8:	b027      	add	sp, #156	; 0x9c
c0d00dba:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00dbc:	20001b60 	.word	0x20001b60
c0d00dc0:	20002030 	.word	0x20002030
c0d00dc4:	3a6d754e 	.word	0x3a6d754e
c0d00dc8:	00003eb4 	.word	0x00003eb4

c0d00dcc <to_address>:
        os_memmove(dest + dec_place_ix + 1, base10_buffer + dec_place_ix, buffer_len - dec_place_ix);
    }
}

/** converts a ONT scripthas to a ONT address by adding a checksum and encoding in base58 */
static void to_address(char *dest, unsigned int dest_len, const unsigned char *script_hash) {
c0d00dcc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00dce:	b09b      	sub	sp, #108	; 0x6c
c0d00dd0:	9003      	str	r0, [sp, #12]
c0d00dd2:	ac04      	add	r4, sp, #16
    unsigned char address_hash_result_0[SHA256_HASH_LEN];
    unsigned char address_hash_result_1[SHA256_HASH_LEN];

    // concatenate the ADDRESS_VERSION and the address.
    unsigned char address[ADDRESS_LEN];
    address[0] = ADDRESS_VERSION;
c0d00dd4:	2017      	movs	r0, #23
c0d00dd6:	7020      	strb	r0, [r4, #0]
    os_memmove(address + 1, script_hash, SCRIPT_HASH_LEN);
c0d00dd8:	1c60      	adds	r0, r4, #1
c0d00dda:	2214      	movs	r2, #20
c0d00ddc:	f000 fa05 	bl	c0d011ea <os_memmove>

    // do a sha256 hash of the address twice.
    cx_sha256_init(&address_hash);
c0d00de0:	4e16      	ldr	r6, [pc, #88]	; (c0d00e3c <to_address+0x70>)
c0d00de2:	4630      	mov	r0, r6
c0d00de4:	f001 f978 	bl	c0d020d8 <cx_sha256_init>
c0d00de8:	af13      	add	r7, sp, #76	; 0x4c
    cx_hash(&address_hash.header, CX_LAST, address, SCRIPT_HASH_LEN + 1, address_hash_result_0);
c0d00dea:	4668      	mov	r0, sp
c0d00dec:	6007      	str	r7, [r0, #0]
c0d00dee:	2501      	movs	r5, #1
c0d00df0:	2315      	movs	r3, #21
c0d00df2:	4630      	mov	r0, r6
c0d00df4:	4629      	mov	r1, r5
c0d00df6:	4622      	mov	r2, r4
c0d00df8:	f7ff f964 	bl	c0d000c4 <cx_hash_X>
    cx_sha256_init(&address_hash);
c0d00dfc:	4630      	mov	r0, r6
c0d00dfe:	f001 f96b 	bl	c0d020d8 <cx_sha256_init>
c0d00e02:	ae0b      	add	r6, sp, #44	; 0x2c
    cx_hash(&address_hash.header, CX_LAST, address_hash_result_0, SHA256_HASH_LEN, address_hash_result_1);
c0d00e04:	4668      	mov	r0, sp
c0d00e06:	6006      	str	r6, [r0, #0]
c0d00e08:	2320      	movs	r3, #32
c0d00e0a:	480c      	ldr	r0, [pc, #48]	; (c0d00e3c <to_address+0x70>)
c0d00e0c:	4629      	mov	r1, r5
c0d00e0e:	463a      	mov	r2, r7
c0d00e10:	f7ff f958 	bl	c0d000c4 <cx_hash_X>

    // add the first bytes of the hash as a checksum at the end of the address.
    os_memmove(address + 1 + SCRIPT_HASH_LEN, address_hash_result_1, SCRIPT_HASH_CHECKSUM_LEN);
c0d00e14:	4620      	mov	r0, r4
c0d00e16:	3015      	adds	r0, #21
c0d00e18:	2204      	movs	r2, #4
c0d00e1a:	4631      	mov	r1, r6
c0d00e1c:	f000 f9e5 	bl	c0d011ea <os_memmove>
    return encode_base_x(BASE_10_ALPHABET, sizeof(BASE_10_ALPHABET), in, in_length, out, out_length);
}

/** encodes in_length bytes from in into base-58, writes the converted bytes to out, stopping when it converts out_length bytes.  */
static unsigned int encode_base_58(const void *in, const unsigned int in_len, char *out, const unsigned int out_len) {
    return encode_base_x(BASE_58_ALPHABET, sizeof(BASE_58_ALPHABET), in, in_len, out, out_len);
c0d00e20:	2022      	movs	r0, #34	; 0x22
c0d00e22:	4669      	mov	r1, sp
c0d00e24:	9a03      	ldr	r2, [sp, #12]
c0d00e26:	600a      	str	r2, [r1, #0]
c0d00e28:	6048      	str	r0, [r1, #4]
c0d00e2a:	4805      	ldr	r0, [pc, #20]	; (c0d00e40 <to_address+0x74>)
c0d00e2c:	4478      	add	r0, pc
c0d00e2e:	213a      	movs	r1, #58	; 0x3a
c0d00e30:	2319      	movs	r3, #25
c0d00e32:	4622      	mov	r2, r4
c0d00e34:	f000 f880 	bl	c0d00f38 <encode_base_x>
    // add the first bytes of the hash as a checksum at the end of the address.
    os_memmove(address + 1 + SCRIPT_HASH_LEN, address_hash_result_1, SCRIPT_HASH_CHECKSUM_LEN);

    // encode the version + address + checksum in base58
    encode_base_58(address, ADDRESS_LEN, dest, dest_len);
}
c0d00e38:	b01b      	add	sp, #108	; 0x6c
c0d00e3a:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00e3c:	20001880 	.word	0x20001880
c0d00e40:	00003bfe 	.word	0x00003bfe

c0d00e44 <public_key_hash160>:
    os_memmove(current_public_key[0], NO_PUBLIC_KEY_0, sizeof(NO_PUBLIC_KEY_0));
    os_memmove(current_public_key[1], NO_PUBLIC_KEY_1, sizeof(NO_PUBLIC_KEY_1));
    publicKeyNeedsRefresh = 0;
}

void public_key_hash160(unsigned char *in, unsigned short inlen, unsigned char *out) {
c0d00e44:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00e46:	b0a7      	sub	sp, #156	; 0x9c
c0d00e48:	9203      	str	r2, [sp, #12]
c0d00e4a:	9102      	str	r1, [sp, #8]
c0d00e4c:	4604      	mov	r4, r0
c0d00e4e:	ad0c      	add	r5, sp, #48	; 0x30
        cx_sha256_t shasha;
        cx_ripemd160_t riprip;
    } u;
    unsigned char buffer[32];

    cx_sha256_init(&u.shasha);
c0d00e50:	4628      	mov	r0, r5
c0d00e52:	f001 f941 	bl	c0d020d8 <cx_sha256_init>
c0d00e56:	ae04      	add	r6, sp, #16
    cx_hash(&u.shasha.header, CX_LAST, in, inlen, buffer);
c0d00e58:	4668      	mov	r0, sp
c0d00e5a:	6006      	str	r6, [r0, #0]
c0d00e5c:	2701      	movs	r7, #1
c0d00e5e:	4628      	mov	r0, r5
c0d00e60:	4639      	mov	r1, r7
c0d00e62:	4622      	mov	r2, r4
c0d00e64:	9b02      	ldr	r3, [sp, #8]
c0d00e66:	f7ff f92d 	bl	c0d000c4 <cx_hash_X>
    cx_ripemd160_init(&u.riprip);
c0d00e6a:	4628      	mov	r0, r5
c0d00e6c:	f001 f91e 	bl	c0d020ac <cx_ripemd160_init>
    cx_hash(&u.riprip.header, CX_LAST, buffer, 32, out);
c0d00e70:	4668      	mov	r0, sp
c0d00e72:	9903      	ldr	r1, [sp, #12]
c0d00e74:	6001      	str	r1, [r0, #0]
c0d00e76:	2320      	movs	r3, #32
c0d00e78:	4628      	mov	r0, r5
c0d00e7a:	4639      	mov	r1, r7
c0d00e7c:	4632      	mov	r2, r6
c0d00e7e:	f7ff f921 	bl	c0d000c4 <cx_hash_X>
}
c0d00e82:	b027      	add	sp, #156	; 0x9c
c0d00e84:	bdf0      	pop	{r4, r5, r6, r7, pc}
	...

c0d00e88 <display_public_key>:

void display_public_key(const unsigned char *public_key) {
c0d00e88:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00e8a:	b0a1      	sub	sp, #132	; 0x84
c0d00e8c:	9000      	str	r0, [sp, #0]
    os_memmove(current_public_key[0], TXT_BLANK, sizeof(TXT_BLANK));
c0d00e8e:	4e28      	ldr	r6, [pc, #160]	; (c0d00f30 <display_public_key+0xa8>)
c0d00e90:	4c28      	ldr	r4, [pc, #160]	; (c0d00f34 <display_public_key+0xac>)
c0d00e92:	447c      	add	r4, pc
c0d00e94:	2712      	movs	r7, #18
c0d00e96:	4630      	mov	r0, r6
c0d00e98:	4621      	mov	r1, r4
c0d00e9a:	463a      	mov	r2, r7
c0d00e9c:	f000 f9a5 	bl	c0d011ea <os_memmove>
    os_memmove(current_public_key[1], TXT_BLANK, sizeof(TXT_BLANK));
c0d00ea0:	3612      	adds	r6, #18
c0d00ea2:	4630      	mov	r0, r6
c0d00ea4:	4621      	mov	r1, r4
c0d00ea6:	463a      	mov	r2, r7
c0d00ea8:	f000 f99f 	bl	c0d011ea <os_memmove>
    os_memmove(current_public_key[2], TXT_BLANK, sizeof(TXT_BLANK));
c0d00eac:	4d20      	ldr	r5, [pc, #128]	; (c0d00f30 <display_public_key+0xa8>)
c0d00eae:	3524      	adds	r5, #36	; 0x24
c0d00eb0:	4628      	mov	r0, r5
c0d00eb2:	4621      	mov	r1, r4
c0d00eb4:	463a      	mov	r2, r7
c0d00eb6:	f000 f998 	bl	c0d011ea <os_memmove>

    unsigned char public_key_encoded[33];
    public_key_encoded[0] = ((public_key[64] & 1) ? 0x03 : 0x02);
c0d00eba:	2040      	movs	r0, #64	; 0x40
c0d00ebc:	9a00      	ldr	r2, [sp, #0]
c0d00ebe:	5c10      	ldrb	r0, [r2, r0]
c0d00ec0:	2101      	movs	r1, #1
c0d00ec2:	4001      	ands	r1, r0
c0d00ec4:	2002      	movs	r0, #2
c0d00ec6:	4308      	orrs	r0, r1
c0d00ec8:	ac18      	add	r4, sp, #96	; 0x60
c0d00eca:	7020      	strb	r0, [r4, #0]
    os_memmove(public_key_encoded + 1, public_key + 1, 32);
c0d00ecc:	1c60      	adds	r0, r4, #1
c0d00ece:	1c51      	adds	r1, r2, #1
c0d00ed0:	2220      	movs	r2, #32
c0d00ed2:	f000 f98a 	bl	c0d011ea <os_memmove>
c0d00ed6:	af0f      	add	r7, sp, #60	; 0x3c
c0d00ed8:	2221      	movs	r2, #33	; 0x21

    unsigned char verification_script[35];
    verification_script[0] = 0x21;
c0d00eda:	703a      	strb	r2, [r7, #0]
    os_memmove(verification_script + 1, public_key_encoded, sizeof(public_key_encoded));
c0d00edc:	1c78      	adds	r0, r7, #1
c0d00ede:	4621      	mov	r1, r4
c0d00ee0:	f000 f983 	bl	c0d011ea <os_memmove>
    verification_script[sizeof(verification_script) - 1] = 0xAC;
c0d00ee4:	2022      	movs	r0, #34	; 0x22
c0d00ee6:	21ac      	movs	r1, #172	; 0xac
c0d00ee8:	5439      	strb	r1, [r7, r0]
c0d00eea:	ac0a      	add	r4, sp, #40	; 0x28

    unsigned char script_hash[SCRIPT_HASH_LEN];
    for (int i = 0; i < SCRIPT_HASH_LEN; i++) {
        script_hash[i] = 0x00;
c0d00eec:	2114      	movs	r1, #20
c0d00eee:	4620      	mov	r0, r4
c0d00ef0:	f003 fca8 	bl	c0d04844 <__aeabi_memclr>
    }

    public_key_hash160(verification_script, sizeof(verification_script), script_hash);
c0d00ef4:	2123      	movs	r1, #35	; 0x23
c0d00ef6:	4638      	mov	r0, r7
c0d00ef8:	4622      	mov	r2, r4
c0d00efa:	f7ff ffa3 	bl	c0d00e44 <public_key_hash160>
c0d00efe:	af01      	add	r7, sp, #4
    unsigned int address_base58_len_1 = 11;
    unsigned int address_base58_len_2 = 12;
    char *address_base58_0 = address_base58;
    char *address_base58_1 = address_base58 + address_base58_len_0;
    char *address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
    to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);
c0d00f00:	4638      	mov	r0, r7
c0d00f02:	4621      	mov	r1, r4
c0d00f04:	f7ff ff62 	bl	c0d00dcc <to_address>
c0d00f08:	240b      	movs	r4, #11

    os_memmove(current_public_key[0], address_base58_0, address_base58_len_0);
c0d00f0a:	4809      	ldr	r0, [pc, #36]	; (c0d00f30 <display_public_key+0xa8>)
c0d00f0c:	4639      	mov	r1, r7
c0d00f0e:	4622      	mov	r2, r4
c0d00f10:	f000 f96b 	bl	c0d011ea <os_memmove>
    char address_base58[ADDRESS_BASE58_LEN];
    unsigned int address_base58_len_0 = 11;
    unsigned int address_base58_len_1 = 11;
    unsigned int address_base58_len_2 = 12;
    char *address_base58_0 = address_base58;
    char *address_base58_1 = address_base58 + address_base58_len_0;
c0d00f14:	4639      	mov	r1, r7
c0d00f16:	310b      	adds	r1, #11
    char *address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
    to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);

    os_memmove(current_public_key[0], address_base58_0, address_base58_len_0);
    os_memmove(current_public_key[1], address_base58_1, address_base58_len_1);
c0d00f18:	4630      	mov	r0, r6
c0d00f1a:	4622      	mov	r2, r4
c0d00f1c:	f000 f965 	bl	c0d011ea <os_memmove>
    unsigned int address_base58_len_0 = 11;
    unsigned int address_base58_len_1 = 11;
    unsigned int address_base58_len_2 = 12;
    char *address_base58_0 = address_base58;
    char *address_base58_1 = address_base58 + address_base58_len_0;
    char *address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
c0d00f20:	3716      	adds	r7, #22
    to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);

    os_memmove(current_public_key[0], address_base58_0, address_base58_len_0);
    os_memmove(current_public_key[1], address_base58_1, address_base58_len_1);
    os_memmove(current_public_key[2], address_base58_2, address_base58_len_2);
c0d00f22:	220c      	movs	r2, #12
c0d00f24:	4628      	mov	r0, r5
c0d00f26:	4639      	mov	r1, r7
c0d00f28:	f000 f95f 	bl	c0d011ea <os_memmove>
}
c0d00f2c:	b021      	add	sp, #132	; 0x84
c0d00f2e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00f30:	20002078 	.word	0x20002078
c0d00f34:	00003b76 	.word	0x00003b76

c0d00f38 <encode_base_x>:

/** encodes in_length bytes from in into the given base, using the given alphabet. writes the converted bytes to out, stopping when it converts out_length bytes. */
static unsigned int
encode_base_x(const char *alphabet, const unsigned int alphabet_len, const void *in, const unsigned int in_length,
              char *out,
              const unsigned int out_length) {
c0d00f38:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00f3a:	b0b9      	sub	sp, #228	; 0xe4
c0d00f3c:	461e      	mov	r6, r3
c0d00f3e:	460d      	mov	r5, r1
c0d00f40:	9003      	str	r0, [sp, #12]
c0d00f42:	4c4c      	ldr	r4, [pc, #304]	; (c0d01074 <encode_base_x+0x13c>)
    char tmp[64];
    char buffer[128];
    unsigned char buffer_ix;
    unsigned char startAt;
    unsigned char zeroCount = 0;
    if (in_length > sizeof(tmp)) {
c0d00f44:	2e41      	cmp	r6, #65	; 0x41
c0d00f46:	d300      	bcc.n	c0d00f4a <encode_base_x+0x12>
c0d00f48:	e089      	b.n	c0d0105e <encode_base_x+0x126>
c0d00f4a:	a829      	add	r0, sp, #164	; 0xa4
        hashTainted = 1;
        THROW(0x6D11);
    }
    os_memmove(tmp, in, in_length);
c0d00f4c:	4611      	mov	r1, r2
c0d00f4e:	4632      	mov	r2, r6
c0d00f50:	f000 f94b 	bl	c0d011ea <os_memmove>
c0d00f54:	2100      	movs	r1, #0
    while ((zeroCount < in_length) && (tmp[zeroCount] == 0)) {
c0d00f56:	2e00      	cmp	r6, #0
c0d00f58:	9507      	str	r5, [sp, #28]
c0d00f5a:	9400      	str	r4, [sp, #0]
c0d00f5c:	d014      	beq.n	c0d00f88 <encode_base_x+0x50>
c0d00f5e:	2000      	movs	r0, #0
c0d00f60:	4602      	mov	r2, r0
c0d00f62:	a929      	add	r1, sp, #164	; 0xa4
c0d00f64:	5c08      	ldrb	r0, [r1, r0]
c0d00f66:	2800      	cmp	r0, #0
c0d00f68:	d103      	bne.n	c0d00f72 <encode_base_x+0x3a>
        ++zeroCount;
c0d00f6a:	1c52      	adds	r2, r2, #1
    if (in_length > sizeof(tmp)) {
        hashTainted = 1;
        THROW(0x6D11);
    }
    os_memmove(tmp, in, in_length);
    while ((zeroCount < in_length) && (tmp[zeroCount] == 0)) {
c0d00f6c:	b2d0      	uxtb	r0, r2
c0d00f6e:	42b0      	cmp	r0, r6
c0d00f70:	d3f7      	bcc.n	c0d00f62 <encode_base_x+0x2a>
        ++zeroCount;
    }
    buffer_ix = 2 * in_length;
c0d00f72:	0071      	lsls	r1, r6, #1
    if (buffer_ix > sizeof(buffer)) {
c0d00f74:	b2c8      	uxtb	r0, r1
c0d00f76:	2881      	cmp	r0, #129	; 0x81
c0d00f78:	d307      	bcc.n	c0d00f8a <encode_base_x+0x52>
        hashTainted = 1;
c0d00f7a:	483f      	ldr	r0, [pc, #252]	; (c0d01078 <encode_base_x+0x140>)
c0d00f7c:	2101      	movs	r1, #1
c0d00f7e:	7001      	strb	r1, [r0, #0]
        THROW(0x6D12);
c0d00f80:	9800      	ldr	r0, [sp, #0]
c0d00f82:	1c40      	adds	r0, r0, #1
c0d00f84:	f000 f9e5 	bl	c0d01352 <os_longjmp>
c0d00f88:	460a      	mov	r2, r1
c0d00f8a:	9202      	str	r2, [sp, #8]
    }

    startAt = zeroCount;
    while (startAt < in_length) {
c0d00f8c:	b2d2      	uxtb	r2, r2
c0d00f8e:	42b2      	cmp	r2, r6
c0d00f90:	9101      	str	r1, [sp, #4]
c0d00f92:	460c      	mov	r4, r1
c0d00f94:	d233      	bcs.n	c0d00ffe <encode_base_x+0xc6>
c0d00f96:	20ff      	movs	r0, #255	; 0xff
c0d00f98:	0203      	lsls	r3, r0, #8
c0d00f9a:	9c01      	ldr	r4, [sp, #4]
c0d00f9c:	9802      	ldr	r0, [sp, #8]
c0d00f9e:	9308      	str	r3, [sp, #32]
c0d00fa0:	9204      	str	r2, [sp, #16]
c0d00fa2:	9405      	str	r4, [sp, #20]
c0d00fa4:	9006      	str	r0, [sp, #24]
        unsigned short remainder = 0;
        unsigned char divLoop;
        for (divLoop = startAt; divLoop < in_length; divLoop++) {
c0d00fa6:	b2c5      	uxtb	r5, r0
c0d00fa8:	2100      	movs	r1, #0
c0d00faa:	42b5      	cmp	r5, r6
c0d00fac:	d211      	bcs.n	c0d00fd2 <encode_base_x+0x9a>
c0d00fae:	2100      	movs	r1, #0
c0d00fb0:	9f06      	ldr	r7, [sp, #24]
c0d00fb2:	4634      	mov	r4, r6
c0d00fb4:	ae29      	add	r6, sp, #164	; 0xa4
            unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
            unsigned short tmpDiv = remainder * 256 + digit256;
c0d00fb6:	5d72      	ldrb	r2, [r6, r5]
c0d00fb8:	0208      	lsls	r0, r1, #8
            tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
c0d00fba:	4018      	ands	r0, r3
c0d00fbc:	4310      	orrs	r0, r2
            remainder = (tmpDiv % alphabet_len);
c0d00fbe:	9907      	ldr	r1, [sp, #28]
c0d00fc0:	f003 fb50 	bl	c0d04664 <__aeabi_uidivmod>
c0d00fc4:	9b08      	ldr	r3, [sp, #32]
        unsigned short remainder = 0;
        unsigned char divLoop;
        for (divLoop = startAt; divLoop < in_length; divLoop++) {
            unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
            unsigned short tmpDiv = remainder * 256 + digit256;
            tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
c0d00fc6:	5570      	strb	r0, [r6, r5]
c0d00fc8:	4626      	mov	r6, r4

    startAt = zeroCount;
    while (startAt < in_length) {
        unsigned short remainder = 0;
        unsigned char divLoop;
        for (divLoop = startAt; divLoop < in_length; divLoop++) {
c0d00fca:	1c7f      	adds	r7, r7, #1
c0d00fcc:	b2fd      	uxtb	r5, r7
c0d00fce:	42b5      	cmp	r5, r6
c0d00fd0:	d3ef      	bcc.n	c0d00fb2 <encode_base_x+0x7a>
c0d00fd2:	a829      	add	r0, sp, #164	; 0xa4
            unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
            unsigned short tmpDiv = remainder * 256 + digit256;
            tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
            remainder = (tmpDiv % alphabet_len);
        }
        if (tmp[startAt] == 0) {
c0d00fd4:	9a04      	ldr	r2, [sp, #16]
c0d00fd6:	5c82      	ldrb	r2, [r0, r2]
            ++startAt;
        }
        buffer[--buffer_ix] = *(alphabet + remainder);
c0d00fd8:	4618      	mov	r0, r3
c0d00fda:	30ff      	adds	r0, #255	; 0xff
c0d00fdc:	4008      	ands	r0, r1
c0d00fde:	9903      	ldr	r1, [sp, #12]
c0d00fe0:	5c08      	ldrb	r0, [r1, r0]
c0d00fe2:	9c05      	ldr	r4, [sp, #20]
c0d00fe4:	1e64      	subs	r4, r4, #1
c0d00fe6:	b2e1      	uxtb	r1, r4
c0d00fe8:	ab09      	add	r3, sp, #36	; 0x24
c0d00fea:	5458      	strb	r0, [r3, r1]
c0d00fec:	9906      	ldr	r1, [sp, #24]
            unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
            unsigned short tmpDiv = remainder * 256 + digit256;
            tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
            remainder = (tmpDiv % alphabet_len);
        }
        if (tmp[startAt] == 0) {
c0d00fee:	1c48      	adds	r0, r1, #1
c0d00ff0:	2a00      	cmp	r2, #0
c0d00ff2:	d000      	beq.n	c0d00ff6 <encode_base_x+0xbe>
c0d00ff4:	4608      	mov	r0, r1
        hashTainted = 1;
        THROW(0x6D12);
    }

    startAt = zeroCount;
    while (startAt < in_length) {
c0d00ff6:	b2c2      	uxtb	r2, r0
c0d00ff8:	42b2      	cmp	r2, r6
c0d00ffa:	9b08      	ldr	r3, [sp, #32]
c0d00ffc:	d3d0      	bcc.n	c0d00fa0 <encode_base_x+0x68>
        if (tmp[startAt] == 0) {
            ++startAt;
        }
        buffer[--buffer_ix] = *(alphabet + remainder);
    }
    while ((buffer_ix < (2 * in_length)) && (buffer[buffer_ix] == *(alphabet + 0))) {
c0d00ffe:	b2e1      	uxtb	r1, r4
c0d01000:	9f01      	ldr	r7, [sp, #4]
c0d01002:	42b9      	cmp	r1, r7
c0d01004:	d20b      	bcs.n	c0d0101e <encode_base_x+0xe6>
c0d01006:	9803      	ldr	r0, [sp, #12]
c0d01008:	7800      	ldrb	r0, [r0, #0]
c0d0100a:	9e02      	ldr	r6, [sp, #8]
c0d0100c:	aa09      	add	r2, sp, #36	; 0x24
c0d0100e:	5c51      	ldrb	r1, [r2, r1]
c0d01010:	4281      	cmp	r1, r0
c0d01012:	d105      	bne.n	c0d01020 <encode_base_x+0xe8>
        ++buffer_ix;
c0d01014:	1c64      	adds	r4, r4, #1
        if (tmp[startAt] == 0) {
            ++startAt;
        }
        buffer[--buffer_ix] = *(alphabet + remainder);
    }
    while ((buffer_ix < (2 * in_length)) && (buffer[buffer_ix] == *(alphabet + 0))) {
c0d01016:	b2e1      	uxtb	r1, r4
c0d01018:	42b9      	cmp	r1, r7
c0d0101a:	d3f7      	bcc.n	c0d0100c <encode_base_x+0xd4>
c0d0101c:	e000      	b.n	c0d01020 <encode_base_x+0xe8>
c0d0101e:	9e02      	ldr	r6, [sp, #8]
c0d01020:	983f      	ldr	r0, [sp, #252]	; 0xfc
        ++buffer_ix;
    }
    while (zeroCount-- > 0) {
c0d01022:	0631      	lsls	r1, r6, #24
c0d01024:	d00e      	beq.n	c0d01044 <encode_base_x+0x10c>
c0d01026:	9903      	ldr	r1, [sp, #12]
c0d01028:	7809      	ldrb	r1, [r1, #0]
c0d0102a:	9405      	str	r4, [sp, #20]
c0d0102c:	4622      	mov	r2, r4
c0d0102e:	4633      	mov	r3, r6
        buffer[--buffer_ix] = *(alphabet + 0);
c0d01030:	1e52      	subs	r2, r2, #1
c0d01032:	b2d4      	uxtb	r4, r2
c0d01034:	ad09      	add	r5, sp, #36	; 0x24
c0d01036:	5529      	strb	r1, [r5, r4]
        buffer[--buffer_ix] = *(alphabet + remainder);
    }
    while ((buffer_ix < (2 * in_length)) && (buffer[buffer_ix] == *(alphabet + 0))) {
        ++buffer_ix;
    }
    while (zeroCount-- > 0) {
c0d01038:	1e5b      	subs	r3, r3, #1
c0d0103a:	24ff      	movs	r4, #255	; 0xff
c0d0103c:	4223      	tst	r3, r4
c0d0103e:	d1f7      	bne.n	c0d01030 <encode_base_x+0xf8>
c0d01040:	9c05      	ldr	r4, [sp, #20]
c0d01042:	1ba4      	subs	r4, r4, r6
        buffer[--buffer_ix] = *(alphabet + 0);
    }
    const unsigned int true_out_length = (2 * in_length) - buffer_ix;
c0d01044:	b2e1      	uxtb	r1, r4
c0d01046:	1a7d      	subs	r5, r7, r1
    if (true_out_length > out_length) {
c0d01048:	4285      	cmp	r5, r0
c0d0104a:	d80e      	bhi.n	c0d0106a <encode_base_x+0x132>
c0d0104c:	983e      	ldr	r0, [sp, #248]	; 0xf8
c0d0104e:	aa09      	add	r2, sp, #36	; 0x24
        THROW(0x6D14);
    }
    os_memmove(out, (buffer + buffer_ix), true_out_length);
c0d01050:	1851      	adds	r1, r2, r1
c0d01052:	462a      	mov	r2, r5
c0d01054:	f000 f8c9 	bl	c0d011ea <os_memmove>
    return true_out_length;
c0d01058:	4628      	mov	r0, r5
c0d0105a:	b039      	add	sp, #228	; 0xe4
c0d0105c:	bdf0      	pop	{r4, r5, r6, r7, pc}
    char buffer[128];
    unsigned char buffer_ix;
    unsigned char startAt;
    unsigned char zeroCount = 0;
    if (in_length > sizeof(tmp)) {
        hashTainted = 1;
c0d0105e:	4806      	ldr	r0, [pc, #24]	; (c0d01078 <encode_base_x+0x140>)
c0d01060:	2101      	movs	r1, #1
c0d01062:	7001      	strb	r1, [r0, #0]
        THROW(0x6D11);
c0d01064:	4620      	mov	r0, r4
c0d01066:	f000 f974 	bl	c0d01352 <os_longjmp>
    while (zeroCount-- > 0) {
        buffer[--buffer_ix] = *(alphabet + 0);
    }
    const unsigned int true_out_length = (2 * in_length) - buffer_ix;
    if (true_out_length > out_length) {
        THROW(0x6D14);
c0d0106a:	9800      	ldr	r0, [sp, #0]
c0d0106c:	1cc0      	adds	r0, r0, #3
c0d0106e:	f000 f970 	bl	c0d01352 <os_longjmp>
c0d01072:	46c0      	nop			; (mov r8, r8)
c0d01074:	00006d11 	.word	0x00006d11
c0d01078:	20001f60 	.word	0x20001f60

c0d0107c <os_boot>:
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d0107c:	2000      	movs	r0, #0
c0d0107e:	4681      	mov	r9, r0
void os_boot(void) {
  // TODO patch entry point when romming (f)

  // set the default try context to nothing
  try_context_set(NULL);
}
c0d01080:	4770      	bx	lr

c0d01082 <try_context_set>:
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d01082:	4681      	mov	r9, r0
}
c0d01084:	4770      	bx	lr
	...

c0d01088 <io_usb_hid_receive>:
volatile unsigned int   G_io_usb_hid_channel;
volatile unsigned int   G_io_usb_hid_remaining_length;
volatile unsigned int   G_io_usb_hid_sequence_number;
volatile unsigned char* G_io_usb_hid_current_buffer;

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
c0d01088:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0108a:	b081      	sub	sp, #4
c0d0108c:	9200      	str	r2, [sp, #0]
c0d0108e:	460f      	mov	r7, r1
c0d01090:	4605      	mov	r5, r0
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
c0d01092:	4b48      	ldr	r3, [pc, #288]	; (c0d011b4 <io_usb_hid_receive+0x12c>)
c0d01094:	429f      	cmp	r7, r3
c0d01096:	d00f      	beq.n	c0d010b8 <io_usb_hid_receive+0x30>
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d01098:	4c46      	ldr	r4, [pc, #280]	; (c0d011b4 <io_usb_hid_receive+0x12c>)
c0d0109a:	2640      	movs	r6, #64	; 0x40
c0d0109c:	4620      	mov	r0, r4
c0d0109e:	4631      	mov	r1, r6
c0d010a0:	f003 fbd0 	bl	c0d04844 <__aeabi_memclr>
c0d010a4:	9800      	ldr	r0, [sp, #0]

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
    os_memset(G_io_usb_ep_buffer, 0, sizeof(G_io_usb_ep_buffer));
    os_memmove(G_io_usb_ep_buffer, buffer, MIN(l, sizeof(G_io_usb_ep_buffer)));
c0d010a6:	2840      	cmp	r0, #64	; 0x40
c0d010a8:	4602      	mov	r2, r0
c0d010aa:	d300      	bcc.n	c0d010ae <io_usb_hid_receive+0x26>
c0d010ac:	4632      	mov	r2, r6
c0d010ae:	4620      	mov	r0, r4
c0d010b0:	4639      	mov	r1, r7
c0d010b2:	f000 f89a 	bl	c0d011ea <os_memmove>
c0d010b6:	4b3f      	ldr	r3, [pc, #252]	; (c0d011b4 <io_usb_hid_receive+0x12c>)
c0d010b8:	7898      	ldrb	r0, [r3, #2]
  }

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
c0d010ba:	2801      	cmp	r0, #1
c0d010bc:	dc0b      	bgt.n	c0d010d6 <io_usb_hid_receive+0x4e>
c0d010be:	2800      	cmp	r0, #0
c0d010c0:	d02b      	beq.n	c0d0111a <io_usb_hid_receive+0x92>
c0d010c2:	2801      	cmp	r0, #1
c0d010c4:	d169      	bne.n	c0d0119a <io_usb_hid_receive+0x112>
    // await for the next chunk
    goto apdu_reset;

  case 0x01: // ALLOCATE CHANNEL
    // do not reset the current apdu reception if any
    cx_rng(G_io_usb_ep_buffer+3, 4);
c0d010c6:	1cd8      	adds	r0, r3, #3
c0d010c8:	2104      	movs	r1, #4
c0d010ca:	461c      	mov	r4, r3
c0d010cc:	f000 ffba 	bl	c0d02044 <cx_rng>
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d010d0:	2140      	movs	r1, #64	; 0x40
c0d010d2:	4620      	mov	r0, r4
c0d010d4:	e02c      	b.n	c0d01130 <io_usb_hid_receive+0xa8>
c0d010d6:	2802      	cmp	r0, #2
c0d010d8:	d028      	beq.n	c0d0112c <io_usb_hid_receive+0xa4>
c0d010da:	2805      	cmp	r0, #5
c0d010dc:	d15d      	bne.n	c0d0119a <io_usb_hid_receive+0x112>

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
  case 0x05:
    // ensure sequence idx is 0 for the first chunk ! 
    if (U2BE(G_io_usb_ep_buffer, 3) != G_io_usb_hid_sequence_number) {
c0d010de:	7918      	ldrb	r0, [r3, #4]
c0d010e0:	78d9      	ldrb	r1, [r3, #3]
c0d010e2:	0209      	lsls	r1, r1, #8
c0d010e4:	4301      	orrs	r1, r0
c0d010e6:	4a34      	ldr	r2, [pc, #208]	; (c0d011b8 <io_usb_hid_receive+0x130>)
c0d010e8:	6810      	ldr	r0, [r2, #0]
c0d010ea:	2400      	movs	r4, #0
c0d010ec:	4281      	cmp	r1, r0
c0d010ee:	d15a      	bne.n	c0d011a6 <io_usb_hid_receive+0x11e>
c0d010f0:	4e32      	ldr	r6, [pc, #200]	; (c0d011bc <io_usb_hid_receive+0x134>)
      // ignore packet
      goto apdu_reset;
    }
    // cid, tag, seq
    l -= 2+1+2;
c0d010f2:	9800      	ldr	r0, [sp, #0]
c0d010f4:	1980      	adds	r0, r0, r6
c0d010f6:	1f07      	subs	r7, r0, #4
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
c0d010f8:	6810      	ldr	r0, [r2, #0]
c0d010fa:	2800      	cmp	r0, #0
c0d010fc:	d01b      	beq.n	c0d01136 <io_usb_hid_receive+0xae>
c0d010fe:	4614      	mov	r4, r2
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
    }
    else {
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (l > G_io_usb_hid_remaining_length) {
c0d01100:	4639      	mov	r1, r7
c0d01102:	4031      	ands	r1, r6
c0d01104:	482e      	ldr	r0, [pc, #184]	; (c0d011c0 <io_usb_hid_receive+0x138>)
c0d01106:	6802      	ldr	r2, [r0, #0]
c0d01108:	4291      	cmp	r1, r2
c0d0110a:	d900      	bls.n	c0d0110e <io_usb_hid_receive+0x86>
        l = G_io_usb_hid_remaining_length;
c0d0110c:	6807      	ldr	r7, [r0, #0]
      }

      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
c0d0110e:	463a      	mov	r2, r7
c0d01110:	4032      	ands	r2, r6
c0d01112:	482c      	ldr	r0, [pc, #176]	; (c0d011c4 <io_usb_hid_receive+0x13c>)
c0d01114:	6800      	ldr	r0, [r0, #0]
c0d01116:	1d59      	adds	r1, r3, #5
c0d01118:	e031      	b.n	c0d0117e <io_usb_hid_receive+0xf6>
c0d0111a:	2400      	movs	r4, #0
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d0111c:	719c      	strb	r4, [r3, #6]
c0d0111e:	715c      	strb	r4, [r3, #5]
c0d01120:	711c      	strb	r4, [r3, #4]
c0d01122:	70dc      	strb	r4, [r3, #3]

  case 0x00: // get version ID
    // do not reset the current apdu reception if any
    os_memset(G_io_usb_ep_buffer+3, 0, 4); // PROTOCOL VERSION is 0
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d01124:	2140      	movs	r1, #64	; 0x40
c0d01126:	4618      	mov	r0, r3
c0d01128:	47a8      	blx	r5
c0d0112a:	e03c      	b.n	c0d011a6 <io_usb_hid_receive+0x11e>
    goto apdu_reset;

  case 0x02: // ECHO|PING
    // do not reset the current apdu reception if any
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d0112c:	4821      	ldr	r0, [pc, #132]	; (c0d011b4 <io_usb_hid_receive+0x12c>)
c0d0112e:	2140      	movs	r1, #64	; 0x40
c0d01130:	47a8      	blx	r5
c0d01132:	2400      	movs	r4, #0
c0d01134:	e037      	b.n	c0d011a6 <io_usb_hid_receive+0x11e>
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
      /// This is the apdu first chunk
      // total apdu size to receive
      G_io_usb_hid_total_length = U2BE(G_io_usb_ep_buffer, 5); //(G_io_usb_ep_buffer[5]<<8)+(G_io_usb_ep_buffer[6]&0xFF);
c0d01136:	7998      	ldrb	r0, [r3, #6]
c0d01138:	7959      	ldrb	r1, [r3, #5]
c0d0113a:	0209      	lsls	r1, r1, #8
c0d0113c:	4301      	orrs	r1, r0
c0d0113e:	4822      	ldr	r0, [pc, #136]	; (c0d011c8 <io_usb_hid_receive+0x140>)
c0d01140:	6001      	str	r1, [r0, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
c0d01142:	6801      	ldr	r1, [r0, #0]
c0d01144:	0849      	lsrs	r1, r1, #1
c0d01146:	29a8      	cmp	r1, #168	; 0xa8
c0d01148:	d82d      	bhi.n	c0d011a6 <io_usb_hid_receive+0x11e>
c0d0114a:	4614      	mov	r4, r2
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
      // compute remaining size to receive
      G_io_usb_hid_remaining_length = G_io_usb_hid_total_length;
c0d0114c:	6801      	ldr	r1, [r0, #0]
c0d0114e:	481c      	ldr	r0, [pc, #112]	; (c0d011c0 <io_usb_hid_receive+0x138>)
c0d01150:	6001      	str	r1, [r0, #0]
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d01152:	491c      	ldr	r1, [pc, #112]	; (c0d011c4 <io_usb_hid_receive+0x13c>)
c0d01154:	4a1d      	ldr	r2, [pc, #116]	; (c0d011cc <io_usb_hid_receive+0x144>)
c0d01156:	600a      	str	r2, [r1, #0]

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);
c0d01158:	7859      	ldrb	r1, [r3, #1]
c0d0115a:	781a      	ldrb	r2, [r3, #0]
c0d0115c:	0212      	lsls	r2, r2, #8
c0d0115e:	430a      	orrs	r2, r1
c0d01160:	491b      	ldr	r1, [pc, #108]	; (c0d011d0 <io_usb_hid_receive+0x148>)
c0d01162:	600a      	str	r2, [r1, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
c0d01164:	491b      	ldr	r1, [pc, #108]	; (c0d011d4 <io_usb_hid_receive+0x14c>)
c0d01166:	9a00      	ldr	r2, [sp, #0]
c0d01168:	1857      	adds	r7, r2, r1
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);

      if (l > G_io_usb_hid_remaining_length) {
c0d0116a:	4639      	mov	r1, r7
c0d0116c:	4031      	ands	r1, r6
c0d0116e:	6802      	ldr	r2, [r0, #0]
c0d01170:	4291      	cmp	r1, r2
c0d01172:	d900      	bls.n	c0d01176 <io_usb_hid_receive+0xee>
        l = G_io_usb_hid_remaining_length;
c0d01174:	6807      	ldr	r7, [r0, #0]
      }
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
c0d01176:	463a      	mov	r2, r7
c0d01178:	4032      	ands	r2, r6
c0d0117a:	1dd9      	adds	r1, r3, #7
c0d0117c:	4813      	ldr	r0, [pc, #76]	; (c0d011cc <io_usb_hid_receive+0x144>)
c0d0117e:	f000 f834 	bl	c0d011ea <os_memmove>
      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
    }
    // factorize (f)
    G_io_usb_hid_current_buffer += l;
c0d01182:	4037      	ands	r7, r6
c0d01184:	480f      	ldr	r0, [pc, #60]	; (c0d011c4 <io_usb_hid_receive+0x13c>)
c0d01186:	6801      	ldr	r1, [r0, #0]
c0d01188:	19c9      	adds	r1, r1, r7
c0d0118a:	6001      	str	r1, [r0, #0]
    G_io_usb_hid_remaining_length -= l;
c0d0118c:	480c      	ldr	r0, [pc, #48]	; (c0d011c0 <io_usb_hid_receive+0x138>)
c0d0118e:	6801      	ldr	r1, [r0, #0]
c0d01190:	1bc9      	subs	r1, r1, r7
c0d01192:	6001      	str	r1, [r0, #0]
    G_io_usb_hid_sequence_number++;
c0d01194:	6820      	ldr	r0, [r4, #0]
c0d01196:	1c40      	adds	r0, r0, #1
c0d01198:	6020      	str	r0, [r4, #0]
    // await for the next chunk
    goto apdu_reset;
  }

  // if more data to be received, notify it
  if (G_io_usb_hid_remaining_length) {
c0d0119a:	4809      	ldr	r0, [pc, #36]	; (c0d011c0 <io_usb_hid_receive+0x138>)
c0d0119c:	6801      	ldr	r1, [r0, #0]
c0d0119e:	2001      	movs	r0, #1
c0d011a0:	2402      	movs	r4, #2
c0d011a2:	2900      	cmp	r1, #0
c0d011a4:	d103      	bne.n	c0d011ae <io_usb_hid_receive+0x126>
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d011a6:	4804      	ldr	r0, [pc, #16]	; (c0d011b8 <io_usb_hid_receive+0x130>)
c0d011a8:	2100      	movs	r1, #0
c0d011aa:	6001      	str	r1, [r0, #0]
c0d011ac:	4620      	mov	r0, r4
  return IO_USB_APDU_RECEIVED;

apdu_reset:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}
c0d011ae:	b2c0      	uxtb	r0, r0
c0d011b0:	b001      	add	sp, #4
c0d011b2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d011b4:	20001ab0 	.word	0x20001ab0
c0d011b8:	200018ec 	.word	0x200018ec
c0d011bc:	0000ffff 	.word	0x0000ffff
c0d011c0:	200018f4 	.word	0x200018f4
c0d011c4:	20001a4c 	.word	0x20001a4c
c0d011c8:	200018f0 	.word	0x200018f0
c0d011cc:	200018f8 	.word	0x200018f8
c0d011d0:	20001a50 	.word	0x20001a50
c0d011d4:	0001fff9 	.word	0x0001fff9

c0d011d8 <os_memset>:
    }
  }
#undef DSTCHAR
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
c0d011d8:	b580      	push	{r7, lr}
c0d011da:	460b      	mov	r3, r1
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
c0d011dc:	2a00      	cmp	r2, #0
c0d011de:	d003      	beq.n	c0d011e8 <os_memset+0x10>
    DSTCHAR[length] = c;
c0d011e0:	4611      	mov	r1, r2
c0d011e2:	461a      	mov	r2, r3
c0d011e4:	f003 fb38 	bl	c0d04858 <__aeabi_memset>
  }
#undef DSTCHAR
}
c0d011e8:	bd80      	pop	{r7, pc}

c0d011ea <os_memmove>:
    }
  }
}
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
c0d011ea:	b5b0      	push	{r4, r5, r7, lr}
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d011ec:	4288      	cmp	r0, r1
c0d011ee:	d90d      	bls.n	c0d0120c <os_memmove+0x22>
    while(length--) {
c0d011f0:	2a00      	cmp	r2, #0
c0d011f2:	d014      	beq.n	c0d0121e <os_memmove+0x34>
c0d011f4:	1e49      	subs	r1, r1, #1
c0d011f6:	4252      	negs	r2, r2
c0d011f8:	1e40      	subs	r0, r0, #1
c0d011fa:	2300      	movs	r3, #0
c0d011fc:	43db      	mvns	r3, r3
      DSTCHAR[length] = SRCCHAR[length];
c0d011fe:	461c      	mov	r4, r3
c0d01200:	4354      	muls	r4, r2
c0d01202:	5d0d      	ldrb	r5, [r1, r4]
c0d01204:	5505      	strb	r5, [r0, r4]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d01206:	1c52      	adds	r2, r2, #1
c0d01208:	d1f9      	bne.n	c0d011fe <os_memmove+0x14>
c0d0120a:	e008      	b.n	c0d0121e <os_memmove+0x34>
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d0120c:	2a00      	cmp	r2, #0
c0d0120e:	d006      	beq.n	c0d0121e <os_memmove+0x34>
c0d01210:	2300      	movs	r3, #0
      DSTCHAR[l] = SRCCHAR[l];
c0d01212:	b29c      	uxth	r4, r3
c0d01214:	5d0d      	ldrb	r5, [r1, r4]
c0d01216:	5505      	strb	r5, [r0, r4]
      l++;
c0d01218:	1c5b      	adds	r3, r3, #1
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d0121a:	1e52      	subs	r2, r2, #1
c0d0121c:	d1f9      	bne.n	c0d01212 <os_memmove+0x28>
      DSTCHAR[l] = SRCCHAR[l];
      l++;
    }
  }
#undef DSTCHAR
}
c0d0121e:	bdb0      	pop	{r4, r5, r7, pc}

c0d01220 <io_usb_hid_init>:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d01220:	4801      	ldr	r0, [pc, #4]	; (c0d01228 <io_usb_hid_init+0x8>)
c0d01222:	2100      	movs	r1, #0
c0d01224:	6001      	str	r1, [r0, #0]
  //G_io_usb_hid_remaining_length = 0; // not really needed
  //G_io_usb_hid_total_length = 0; // not really needed
  //G_io_usb_hid_current_buffer = G_io_apdu_buffer; // not really needed
}
c0d01226:	4770      	bx	lr
c0d01228:	200018ec 	.word	0x200018ec

c0d0122c <io_usb_hid_exchange>:

unsigned short io_usb_hid_exchange(io_send_t sndfct, unsigned short sndlength,
                                   io_recv_t rcvfct,
                                   unsigned char flags) {
c0d0122c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0122e:	b085      	sub	sp, #20
c0d01230:	9301      	str	r3, [sp, #4]
c0d01232:	9200      	str	r2, [sp, #0]
c0d01234:	460e      	mov	r6, r1
c0d01236:	9003      	str	r0, [sp, #12]
  unsigned char l;

  // perform send
  if (sndlength) {
c0d01238:	2e00      	cmp	r6, #0
c0d0123a:	d047      	beq.n	c0d012cc <io_usb_hid_exchange+0xa0>
    G_io_usb_hid_sequence_number = 0; 
c0d0123c:	4c32      	ldr	r4, [pc, #200]	; (c0d01308 <io_usb_hid_exchange+0xdc>)
c0d0123e:	2000      	movs	r0, #0
c0d01240:	6020      	str	r0, [r4, #0]
    G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d01242:	4932      	ldr	r1, [pc, #200]	; (c0d0130c <io_usb_hid_exchange+0xe0>)
c0d01244:	4832      	ldr	r0, [pc, #200]	; (c0d01310 <io_usb_hid_exchange+0xe4>)
c0d01246:	6008      	str	r0, [r1, #0]
c0d01248:	4f32      	ldr	r7, [pc, #200]	; (c0d01314 <io_usb_hid_exchange+0xe8>)
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d0124a:	1d78      	adds	r0, r7, #5
c0d0124c:	2539      	movs	r5, #57	; 0x39
c0d0124e:	9002      	str	r0, [sp, #8]
c0d01250:	4629      	mov	r1, r5
c0d01252:	f003 faf7 	bl	c0d04844 <__aeabi_memclr>
c0d01256:	4830      	ldr	r0, [pc, #192]	; (c0d01318 <io_usb_hid_exchange+0xec>)
c0d01258:	4601      	mov	r1, r0

    // fill the chunk
    os_memset(G_io_usb_ep_buffer, 0, IO_HID_EP_LENGTH-2);

    // keep the channel identifier
    G_io_usb_ep_buffer[0] = (G_io_usb_hid_channel>>8)&0xFF;
c0d0125a:	6808      	ldr	r0, [r1, #0]
c0d0125c:	0a00      	lsrs	r0, r0, #8
c0d0125e:	7038      	strb	r0, [r7, #0]
    G_io_usb_ep_buffer[1] = G_io_usb_hid_channel&0xFF;
c0d01260:	6808      	ldr	r0, [r1, #0]
c0d01262:	7078      	strb	r0, [r7, #1]
c0d01264:	2005      	movs	r0, #5
    G_io_usb_ep_buffer[2] = 0x05;
c0d01266:	70b8      	strb	r0, [r7, #2]
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
c0d01268:	6820      	ldr	r0, [r4, #0]
c0d0126a:	0a00      	lsrs	r0, r0, #8
c0d0126c:	70f8      	strb	r0, [r7, #3]
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;
c0d0126e:	6820      	ldr	r0, [r4, #0]
c0d01270:	7138      	strb	r0, [r7, #4]
c0d01272:	b2b1      	uxth	r1, r6

    if (G_io_usb_hid_sequence_number == 0) {
c0d01274:	6820      	ldr	r0, [r4, #0]
c0d01276:	2800      	cmp	r0, #0
c0d01278:	9104      	str	r1, [sp, #16]
c0d0127a:	d00a      	beq.n	c0d01292 <io_usb_hid_exchange+0x66>
      G_io_usb_hid_current_buffer += l;
      sndlength -= l;
      l += 7;
    }
    else {
      l = ((sndlength>IO_HID_EP_LENGTH-5) ? IO_HID_EP_LENGTH-5 : sndlength);
c0d0127c:	203b      	movs	r0, #59	; 0x3b
c0d0127e:	293b      	cmp	r1, #59	; 0x3b
c0d01280:	460e      	mov	r6, r1
c0d01282:	d300      	bcc.n	c0d01286 <io_usb_hid_exchange+0x5a>
c0d01284:	4606      	mov	r6, r0
c0d01286:	4821      	ldr	r0, [pc, #132]	; (c0d0130c <io_usb_hid_exchange+0xe0>)
c0d01288:	4602      	mov	r2, r0
      os_memmove(G_io_usb_ep_buffer+5, (const void*)G_io_usb_hid_current_buffer, l);
c0d0128a:	6811      	ldr	r1, [r2, #0]
c0d0128c:	9802      	ldr	r0, [sp, #8]
c0d0128e:	4615      	mov	r5, r2
c0d01290:	e009      	b.n	c0d012a6 <io_usb_hid_exchange+0x7a>
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;

    if (G_io_usb_hid_sequence_number == 0) {
      l = ((sndlength>IO_HID_EP_LENGTH-7) ? IO_HID_EP_LENGTH-7 : sndlength);
      G_io_usb_ep_buffer[5] = sndlength>>8;
c0d01292:	0a30      	lsrs	r0, r6, #8
c0d01294:	7178      	strb	r0, [r7, #5]
      G_io_usb_ep_buffer[6] = sndlength;
c0d01296:	71be      	strb	r6, [r7, #6]
    G_io_usb_ep_buffer[2] = 0x05;
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;

    if (G_io_usb_hid_sequence_number == 0) {
      l = ((sndlength>IO_HID_EP_LENGTH-7) ? IO_HID_EP_LENGTH-7 : sndlength);
c0d01298:	2939      	cmp	r1, #57	; 0x39
c0d0129a:	460e      	mov	r6, r1
c0d0129c:	d300      	bcc.n	c0d012a0 <io_usb_hid_exchange+0x74>
c0d0129e:	462e      	mov	r6, r5
c0d012a0:	4d1a      	ldr	r5, [pc, #104]	; (c0d0130c <io_usb_hid_exchange+0xe0>)
      G_io_usb_ep_buffer[5] = sndlength>>8;
      G_io_usb_ep_buffer[6] = sndlength;
      os_memmove(G_io_usb_ep_buffer+7, (const void*)G_io_usb_hid_current_buffer, l);
c0d012a2:	6829      	ldr	r1, [r5, #0]
c0d012a4:	1df8      	adds	r0, r7, #7
c0d012a6:	4632      	mov	r2, r6
c0d012a8:	f7ff ff9f 	bl	c0d011ea <os_memmove>
c0d012ac:	4c16      	ldr	r4, [pc, #88]	; (c0d01308 <io_usb_hid_exchange+0xdc>)
c0d012ae:	6828      	ldr	r0, [r5, #0]
c0d012b0:	1980      	adds	r0, r0, r6
      G_io_usb_hid_current_buffer += l;
c0d012b2:	6028      	str	r0, [r5, #0]
      G_io_usb_hid_current_buffer += l;
      sndlength -= l;
      l += 5;
    }
    // prepare next chunk numbering
    G_io_usb_hid_sequence_number++;
c0d012b4:	6820      	ldr	r0, [r4, #0]
c0d012b6:	1c40      	adds	r0, r0, #1
c0d012b8:	6020      	str	r0, [r4, #0]
    // send the chunk
    // always pad :)
    sndfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
c0d012ba:	2140      	movs	r1, #64	; 0x40
c0d012bc:	4638      	mov	r0, r7
c0d012be:	9a03      	ldr	r2, [sp, #12]
c0d012c0:	4790      	blx	r2
c0d012c2:	9804      	ldr	r0, [sp, #16]
c0d012c4:	1b86      	subs	r6, r0, r6
c0d012c6:	4815      	ldr	r0, [pc, #84]	; (c0d0131c <io_usb_hid_exchange+0xf0>)
  // perform send
  if (sndlength) {
    G_io_usb_hid_sequence_number = 0; 
    G_io_usb_hid_current_buffer = G_io_apdu_buffer;
  }
  while(sndlength) {
c0d012c8:	4206      	tst	r6, r0
c0d012ca:	d1be      	bne.n	c0d0124a <io_usb_hid_exchange+0x1e>
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d012cc:	480e      	ldr	r0, [pc, #56]	; (c0d01308 <io_usb_hid_exchange+0xdc>)
c0d012ce:	2400      	movs	r4, #0
c0d012d0:	6004      	str	r4, [r0, #0]
  }

  // prepare for next apdu
  io_usb_hid_init();

  if (flags & IO_RESET_AFTER_REPLIED) {
c0d012d2:	2080      	movs	r0, #128	; 0x80
c0d012d4:	9d01      	ldr	r5, [sp, #4]
c0d012d6:	4205      	tst	r5, r0
c0d012d8:	d001      	beq.n	c0d012de <io_usb_hid_exchange+0xb2>
    reset();
c0d012da:	f000 fe9f 	bl	c0d0201c <reset>
  }

  if (flags & IO_RETURN_AFTER_TX ) {
c0d012de:	06a8      	lsls	r0, r5, #26
c0d012e0:	d40f      	bmi.n	c0d01302 <io_usb_hid_exchange+0xd6>
c0d012e2:	4c0c      	ldr	r4, [pc, #48]	; (c0d01314 <io_usb_hid_exchange+0xe8>)
c0d012e4:	9d00      	ldr	r5, [sp, #0]
  }

  // receive the next command
  for(;;) {
    // receive a hid chunk
    l = rcvfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
c0d012e6:	2140      	movs	r1, #64	; 0x40
c0d012e8:	4620      	mov	r0, r4
c0d012ea:	47a8      	blx	r5
    // check for wrongly sized tlvs
    if (l > sizeof(G_io_usb_ep_buffer)) {
c0d012ec:	b2c2      	uxtb	r2, r0
c0d012ee:	2a40      	cmp	r2, #64	; 0x40
c0d012f0:	d8f9      	bhi.n	c0d012e6 <io_usb_hid_exchange+0xba>
      continue;
    }

    // call the chunk reception
    switch(io_usb_hid_receive(sndfct, G_io_usb_ep_buffer, l)) {
c0d012f2:	9803      	ldr	r0, [sp, #12]
c0d012f4:	4621      	mov	r1, r4
c0d012f6:	f7ff fec7 	bl	c0d01088 <io_usb_hid_receive>
c0d012fa:	2802      	cmp	r0, #2
c0d012fc:	d1f3      	bne.n	c0d012e6 <io_usb_hid_exchange+0xba>
      default:
        continue;

      case IO_USB_APDU_RECEIVED:

        return G_io_usb_hid_total_length;
c0d012fe:	4808      	ldr	r0, [pc, #32]	; (c0d01320 <io_usb_hid_exchange+0xf4>)
c0d01300:	6804      	ldr	r4, [r0, #0]
    }
  }
}
c0d01302:	b2a0      	uxth	r0, r4
c0d01304:	b005      	add	sp, #20
c0d01306:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01308:	200018ec 	.word	0x200018ec
c0d0130c:	20001a4c 	.word	0x20001a4c
c0d01310:	200018f8 	.word	0x200018f8
c0d01314:	20001ab0 	.word	0x20001ab0
c0d01318:	20001a50 	.word	0x20001a50
c0d0131c:	0000ffff 	.word	0x0000ffff
c0d01320:	200018f0 	.word	0x200018f0

c0d01324 <os_memcmp>:
    DSTCHAR[length] = c;
  }
#undef DSTCHAR
}

char os_memcmp(const void WIDE * buf1, const void WIDE * buf2, unsigned int length) {
c0d01324:	b570      	push	{r4, r5, r6, lr}
#define BUF1 ((unsigned char const WIDE *)buf1)
#define BUF2 ((unsigned char const WIDE *)buf2)
  while(length--) {
c0d01326:	1e43      	subs	r3, r0, #1
c0d01328:	1e49      	subs	r1, r1, #1
c0d0132a:	4252      	negs	r2, r2
c0d0132c:	2000      	movs	r0, #0
c0d0132e:	43c4      	mvns	r4, r0
c0d01330:	2a00      	cmp	r2, #0
c0d01332:	d00c      	beq.n	c0d0134e <os_memcmp+0x2a>
    if (BUF1[length] != BUF2[length]) {
c0d01334:	4626      	mov	r6, r4
c0d01336:	4356      	muls	r6, r2
c0d01338:	5d8d      	ldrb	r5, [r1, r6]
c0d0133a:	5d9e      	ldrb	r6, [r3, r6]
c0d0133c:	1c52      	adds	r2, r2, #1
c0d0133e:	42ae      	cmp	r6, r5
c0d01340:	d0f6      	beq.n	c0d01330 <os_memcmp+0xc>
      return (BUF1[length] > BUF2[length])? 1:-1;
c0d01342:	2000      	movs	r0, #0
c0d01344:	43c1      	mvns	r1, r0
c0d01346:	2001      	movs	r0, #1
c0d01348:	42ae      	cmp	r6, r5
c0d0134a:	d800      	bhi.n	c0d0134e <os_memcmp+0x2a>
c0d0134c:	4608      	mov	r0, r1
  }
  return 0;
#undef BUF1
#undef BUF2

}
c0d0134e:	b2c0      	uxtb	r0, r0
c0d01350:	bd70      	pop	{r4, r5, r6, pc}

c0d01352 <os_longjmp>:
void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0d01352:	b580      	push	{r7, lr}
c0d01354:	4601      	mov	r1, r0
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d01356:	4648      	mov	r0, r9
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
  longjmp(try_context_get()->jmp_buf, exception);
c0d01358:	f003 fb16 	bl	c0d04988 <longjmp>

c0d0135c <try_context_get>:
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d0135c:	4648      	mov	r0, r9
  return current_ctx;
c0d0135e:	4770      	bx	lr

c0d01360 <try_context_get_previous>:
}

try_context_t* try_context_get_previous(void) {
c0d01360:	2000      	movs	r0, #0
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d01362:	4649      	mov	r1, r9

  // first context reached ?
  if (current_ctx == NULL) {
c0d01364:	2900      	cmp	r1, #0
c0d01366:	d000      	beq.n	c0d0136a <try_context_get_previous+0xa>
  }

  // return r9 content saved on the current context. It links to the previous context.
  // r4 r5 r6 r7 r8 r9 r10 r11 sp lr
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
c0d01368:	6948      	ldr	r0, [r1, #20]
}
c0d0136a:	4770      	bx	lr

c0d0136c <io_seproxyhal_general_status>:
  if (G_io_timeout) {
    G_io_timeout = timeout_ms;
  }
}

void io_seproxyhal_general_status(void) {
c0d0136c:	b580      	push	{r7, lr}
  // avoid troubles
  if (io_seproxyhal_spi_is_status_sent()) {
c0d0136e:	f000 ffa1 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d01372:	2800      	cmp	r0, #0
c0d01374:	d10b      	bne.n	c0d0138e <io_seproxyhal_general_status+0x22>
    return;
  }
  // send the general status
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_GENERAL_STATUS;
c0d01376:	4806      	ldr	r0, [pc, #24]	; (c0d01390 <io_seproxyhal_general_status+0x24>)
c0d01378:	2160      	movs	r1, #96	; 0x60
c0d0137a:	7001      	strb	r1, [r0, #0]
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d0137c:	2100      	movs	r1, #0
c0d0137e:	7041      	strb	r1, [r0, #1]
  G_io_seproxyhal_spi_buffer[2] = 2;
c0d01380:	2202      	movs	r2, #2
c0d01382:	7082      	strb	r2, [r0, #2]
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND>>8;
c0d01384:	70c1      	strb	r1, [r0, #3]
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND;
c0d01386:	7101      	strb	r1, [r0, #4]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
c0d01388:	2105      	movs	r1, #5
c0d0138a:	f000 ff7d 	bl	c0d02288 <io_seproxyhal_spi_send>
}
c0d0138e:	bd80      	pop	{r7, pc}
c0d01390:	20001800 	.word	0x20001800

c0d01394 <io_seproxyhal_handle_usb_event>:
static volatile unsigned char G_io_usb_ep_xfer_len[IO_USB_MAX_ENDPOINTS];
#include "usbd_def.h"
#include "usbd_core.h"
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
c0d01394:	b510      	push	{r4, lr}
  switch(G_io_seproxyhal_spi_buffer[3]) {
c0d01396:	4813      	ldr	r0, [pc, #76]	; (c0d013e4 <io_seproxyhal_handle_usb_event+0x50>)
c0d01398:	78c0      	ldrb	r0, [r0, #3]
c0d0139a:	2803      	cmp	r0, #3
c0d0139c:	dc07      	bgt.n	c0d013ae <io_seproxyhal_handle_usb_event+0x1a>
c0d0139e:	2801      	cmp	r0, #1
c0d013a0:	d00d      	beq.n	c0d013be <io_seproxyhal_handle_usb_event+0x2a>
c0d013a2:	2802      	cmp	r0, #2
c0d013a4:	d11d      	bne.n	c0d013e2 <io_seproxyhal_handle_usb_event+0x4e>
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
        THROW(EXCEPTION_IO_RESET);
      }
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
c0d013a6:	4810      	ldr	r0, [pc, #64]	; (c0d013e8 <io_seproxyhal_handle_usb_event+0x54>)
c0d013a8:	f002 fc6d 	bl	c0d03c86 <USBD_LL_SOF>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d013ac:	bd10      	pop	{r4, pc}
c0d013ae:	2804      	cmp	r0, #4
c0d013b0:	d014      	beq.n	c0d013dc <io_seproxyhal_handle_usb_event+0x48>
c0d013b2:	2808      	cmp	r0, #8
c0d013b4:	d115      	bne.n	c0d013e2 <io_seproxyhal_handle_usb_event+0x4e>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
c0d013b6:	480c      	ldr	r0, [pc, #48]	; (c0d013e8 <io_seproxyhal_handle_usb_event+0x54>)
c0d013b8:	f002 fc63 	bl	c0d03c82 <USBD_LL_Resume>
      break;
  }
}
c0d013bc:	bd10      	pop	{r4, pc}
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
  switch(G_io_seproxyhal_spi_buffer[3]) {
    case SEPROXYHAL_TAG_USB_EVENT_RESET:
      USBD_LL_SetSpeed(&USBD_Device, USBD_SPEED_FULL);  
c0d013be:	4c0a      	ldr	r4, [pc, #40]	; (c0d013e8 <io_seproxyhal_handle_usb_event+0x54>)
c0d013c0:	2101      	movs	r1, #1
c0d013c2:	4620      	mov	r0, r4
c0d013c4:	f002 fc58 	bl	c0d03c78 <USBD_LL_SetSpeed>
      USBD_LL_Reset(&USBD_Device);
c0d013c8:	4620      	mov	r0, r4
c0d013ca:	f002 fc34 	bl	c0d03c36 <USBD_LL_Reset>
      // ongoing APDU detected, throw a reset, even if not the media. to avoid potential troubles.
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
c0d013ce:	4807      	ldr	r0, [pc, #28]	; (c0d013ec <io_seproxyhal_handle_usb_event+0x58>)
c0d013d0:	7800      	ldrb	r0, [r0, #0]
c0d013d2:	2800      	cmp	r0, #0
c0d013d4:	d005      	beq.n	c0d013e2 <io_seproxyhal_handle_usb_event+0x4e>
        THROW(EXCEPTION_IO_RESET);
c0d013d6:	2010      	movs	r0, #16
c0d013d8:	f7ff ffbb 	bl	c0d01352 <os_longjmp>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
c0d013dc:	4802      	ldr	r0, [pc, #8]	; (c0d013e8 <io_seproxyhal_handle_usb_event+0x54>)
c0d013de:	f002 fc4e 	bl	c0d03c7e <USBD_LL_Suspend>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d013e2:	bd10      	pop	{r4, pc}
c0d013e4:	20001800 	.word	0x20001800
c0d013e8:	200020b8 	.word	0x200020b8
c0d013ec:	20001a5c 	.word	0x20001a5c

c0d013f0 <io_seproxyhal_get_ep_rx_size>:

uint16_t io_seproxyhal_get_ep_rx_size(uint8_t epnum) {
  return G_io_usb_ep_xfer_len[epnum&0x7F];
c0d013f0:	217f      	movs	r1, #127	; 0x7f
c0d013f2:	4001      	ands	r1, r0
c0d013f4:	4801      	ldr	r0, [pc, #4]	; (c0d013fc <io_seproxyhal_get_ep_rx_size+0xc>)
c0d013f6:	5c40      	ldrb	r0, [r0, r1]
c0d013f8:	4770      	bx	lr
c0d013fa:	46c0      	nop			; (mov r8, r8)
c0d013fc:	20001a5d 	.word	0x20001a5d

c0d01400 <io_seproxyhal_handle_usb_ep_xfer_event>:
}

void io_seproxyhal_handle_usb_ep_xfer_event(void) {
c0d01400:	b580      	push	{r7, lr}
  switch(G_io_seproxyhal_spi_buffer[4]) {
c0d01402:	4810      	ldr	r0, [pc, #64]	; (c0d01444 <io_seproxyhal_handle_usb_ep_xfer_event+0x44>)
c0d01404:	7901      	ldrb	r1, [r0, #4]
c0d01406:	2904      	cmp	r1, #4
c0d01408:	d008      	beq.n	c0d0141c <io_seproxyhal_handle_usb_ep_xfer_event+0x1c>
c0d0140a:	2902      	cmp	r1, #2
c0d0140c:	d011      	beq.n	c0d01432 <io_seproxyhal_handle_usb_ep_xfer_event+0x32>
c0d0140e:	2901      	cmp	r1, #1
c0d01410:	d10e      	bne.n	c0d01430 <io_seproxyhal_handle_usb_ep_xfer_event+0x30>
    /* This event is received when a new SETUP token had been received on a control endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_SETUP:
      // assume length of setup packet, and that it is on endpoint 0
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
c0d01412:	1d81      	adds	r1, r0, #6
c0d01414:	480d      	ldr	r0, [pc, #52]	; (c0d0144c <io_seproxyhal_handle_usb_ep_xfer_event+0x4c>)
c0d01416:	f002 fb07 	bl	c0d03a28 <USBD_LL_SetupStage>
      // saved just in case it is needed ...
      G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
      USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      break;
  }
}
c0d0141a:	bd80      	pop	{r7, pc}
      break;

    /* This event is received when a new DATA token is received on an endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_OUT:
      // saved just in case it is needed ...
      G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
c0d0141c:	78c2      	ldrb	r2, [r0, #3]
c0d0141e:	217f      	movs	r1, #127	; 0x7f
c0d01420:	4011      	ands	r1, r2
c0d01422:	7942      	ldrb	r2, [r0, #5]
c0d01424:	4b08      	ldr	r3, [pc, #32]	; (c0d01448 <io_seproxyhal_handle_usb_ep_xfer_event+0x48>)
c0d01426:	545a      	strb	r2, [r3, r1]
      USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d01428:	1d82      	adds	r2, r0, #6
c0d0142a:	4808      	ldr	r0, [pc, #32]	; (c0d0144c <io_seproxyhal_handle_usb_ep_xfer_event+0x4c>)
c0d0142c:	f002 fb2b 	bl	c0d03a86 <USBD_LL_DataOutStage>
      break;
  }
}
c0d01430:	bd80      	pop	{r7, pc}
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
      break;

    /* This event is received after the prepare data packet has been flushed to the usb host */
    case SEPROXYHAL_TAG_USB_EP_XFER_IN:
      USBD_LL_DataInStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d01432:	78c2      	ldrb	r2, [r0, #3]
c0d01434:	217f      	movs	r1, #127	; 0x7f
c0d01436:	4011      	ands	r1, r2
c0d01438:	1d82      	adds	r2, r0, #6
c0d0143a:	4804      	ldr	r0, [pc, #16]	; (c0d0144c <io_seproxyhal_handle_usb_ep_xfer_event+0x4c>)
c0d0143c:	f002 fb82 	bl	c0d03b44 <USBD_LL_DataInStage>
      // saved just in case it is needed ...
      G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
      USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      break;
  }
}
c0d01440:	bd80      	pop	{r7, pc}
c0d01442:	46c0      	nop			; (mov r8, r8)
c0d01444:	20001800 	.word	0x20001800
c0d01448:	20001a5d 	.word	0x20001a5d
c0d0144c:	200020b8 	.word	0x200020b8

c0d01450 <io_usb_send_ep>:
}

#endif // HAVE_L4_USBLIB

// TODO, refactor this using the USB DataIn event like for the U2F tunnel
void io_usb_send_ep(unsigned int ep, unsigned char* buffer, unsigned short length, unsigned int timeout) {
c0d01450:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01452:	b081      	sub	sp, #4
c0d01454:	4614      	mov	r4, r2
c0d01456:	4605      	mov	r5, r0
  if (timeout) {
    timeout++;
  }

  // won't send if overflowing seproxyhal buffer format
  if (length > 255) {
c0d01458:	2cff      	cmp	r4, #255	; 0xff
c0d0145a:	d83a      	bhi.n	c0d014d2 <io_usb_send_ep+0x82>
    return;
  }
  
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d0145c:	4e1f      	ldr	r6, [pc, #124]	; (c0d014dc <io_usb_send_ep+0x8c>)
c0d0145e:	2050      	movs	r0, #80	; 0x50
c0d01460:	7030      	strb	r0, [r6, #0]
  G_io_seproxyhal_spi_buffer[1] = (3+length)>>8;
c0d01462:	1ce0      	adds	r0, r4, #3
c0d01464:	9100      	str	r1, [sp, #0]
c0d01466:	0a01      	lsrs	r1, r0, #8
c0d01468:	7071      	strb	r1, [r6, #1]
  G_io_seproxyhal_spi_buffer[2] = (3+length);
c0d0146a:	70b0      	strb	r0, [r6, #2]
  G_io_seproxyhal_spi_buffer[3] = ep|0x80;
c0d0146c:	2080      	movs	r0, #128	; 0x80
c0d0146e:	4305      	orrs	r5, r0
c0d01470:	70f5      	strb	r5, [r6, #3]
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d01472:	2020      	movs	r0, #32
c0d01474:	7130      	strb	r0, [r6, #4]
  G_io_seproxyhal_spi_buffer[5] = length;
c0d01476:	7174      	strb	r4, [r6, #5]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 6);
c0d01478:	2106      	movs	r1, #6
c0d0147a:	4630      	mov	r0, r6
c0d0147c:	461f      	mov	r7, r3
c0d0147e:	f000 ff03 	bl	c0d02288 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(buffer, length);
c0d01482:	9800      	ldr	r0, [sp, #0]
c0d01484:	4621      	mov	r1, r4
c0d01486:	f000 feff 	bl	c0d02288 <io_seproxyhal_spi_send>

  // if timeout is requested
  if(timeout) {
c0d0148a:	1c78      	adds	r0, r7, #1
c0d0148c:	2802      	cmp	r0, #2
c0d0148e:	d320      	bcc.n	c0d014d2 <io_usb_send_ep+0x82>
c0d01490:	e006      	b.n	c0d014a0 <io_usb_send_ep+0x50>
          THROW(EXCEPTION_IO_RESET);
        }
        */

        // link disconnected ?
        if(G_io_seproxyhal_spi_buffer[0] == SEPROXYHAL_TAG_STATUS_EVENT) {
c0d01492:	2915      	cmp	r1, #21
c0d01494:	d102      	bne.n	c0d0149c <io_usb_send_ep+0x4c>
          if (!(U4BE(G_io_seproxyhal_spi_buffer, 3) & SEPROXYHAL_TAG_STATUS_EVENT_FLAG_USB_POWERED)) {
c0d01496:	79b0      	ldrb	r0, [r6, #6]
c0d01498:	0700      	lsls	r0, r0, #28
c0d0149a:	d51c      	bpl.n	c0d014d6 <io_usb_send_ep+0x86>
        
        // usb reset ?
        //io_seproxyhal_handle_usb_event();
        // also process other transfer requests if any (useful for HID keyboard while playing with CAPS lock key, side effect on LED status)
        // also handle IO timeout in a centralized and configurable way
        io_seproxyhal_handle_event();
c0d0149c:	f000 f820 	bl	c0d014e0 <io_seproxyhal_handle_event>
  io_seproxyhal_spi_send(buffer, length);

  // if timeout is requested
  if(timeout) {
    for (;;) {
      if (!io_seproxyhal_spi_is_status_sent()) {
c0d014a0:	f000 ff08 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d014a4:	2800      	cmp	r0, #0
c0d014a6:	d101      	bne.n	c0d014ac <io_usb_send_ep+0x5c>
        io_seproxyhal_general_status();
c0d014a8:	f7ff ff60 	bl	c0d0136c <io_seproxyhal_general_status>
      }

      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d014ac:	2180      	movs	r1, #128	; 0x80
c0d014ae:	2200      	movs	r2, #0
c0d014b0:	4630      	mov	r0, r6
c0d014b2:	f000 ff15 	bl	c0d022e0 <io_seproxyhal_spi_recv>

      // wait for ack of the seproxyhal
      // discard if not an acknowledgment
      if (G_io_seproxyhal_spi_buffer[0] != SEPROXYHAL_TAG_USB_EP_XFER_EVENT
c0d014b6:	7831      	ldrb	r1, [r6, #0]
        || rx_len != 6 
c0d014b8:	2806      	cmp	r0, #6
c0d014ba:	d1ea      	bne.n	c0d01492 <io_usb_send_ep+0x42>
c0d014bc:	2910      	cmp	r1, #16
c0d014be:	d1e8      	bne.n	c0d01492 <io_usb_send_ep+0x42>
        || G_io_seproxyhal_spi_buffer[3] != (ep|0x80)
c0d014c0:	78f0      	ldrb	r0, [r6, #3]
        || G_io_seproxyhal_spi_buffer[4] != SEPROXYHAL_TAG_USB_EP_XFER_IN
c0d014c2:	42a8      	cmp	r0, r5
c0d014c4:	d1e5      	bne.n	c0d01492 <io_usb_send_ep+0x42>
c0d014c6:	7930      	ldrb	r0, [r6, #4]
c0d014c8:	2802      	cmp	r0, #2
c0d014ca:	d1e2      	bne.n	c0d01492 <io_usb_send_ep+0x42>
        || G_io_seproxyhal_spi_buffer[5] != length) {
c0d014cc:	7970      	ldrb	r0, [r6, #5]

      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);

      // wait for ack of the seproxyhal
      // discard if not an acknowledgment
      if (G_io_seproxyhal_spi_buffer[0] != SEPROXYHAL_TAG_USB_EP_XFER_EVENT
c0d014ce:	42a0      	cmp	r0, r4
c0d014d0:	d1df      	bne.n	c0d01492 <io_usb_send_ep+0x42>

      // chunk sending succeeded
      break;
    }
  }
}
c0d014d2:	b001      	add	sp, #4
c0d014d4:	bdf0      	pop	{r4, r5, r6, r7, pc}
        */

        // link disconnected ?
        if(G_io_seproxyhal_spi_buffer[0] == SEPROXYHAL_TAG_STATUS_EVENT) {
          if (!(U4BE(G_io_seproxyhal_spi_buffer, 3) & SEPROXYHAL_TAG_STATUS_EVENT_FLAG_USB_POWERED)) {
           THROW(EXCEPTION_IO_RESET);
c0d014d6:	2010      	movs	r0, #16
c0d014d8:	f7ff ff3b 	bl	c0d01352 <os_longjmp>
c0d014dc:	20001800 	.word	0x20001800

c0d014e0 <io_seproxyhal_handle_event>:
    // copy apdu to apdu buffer
    os_memmove(G_io_apdu_buffer, G_io_seproxyhal_spi_buffer+3, G_io_apdu_length);
  }
}

unsigned int io_seproxyhal_handle_event(void) {
c0d014e0:	b580      	push	{r7, lr}
  unsigned int rx_len = U2BE(G_io_seproxyhal_spi_buffer, 1);
c0d014e2:	481e      	ldr	r0, [pc, #120]	; (c0d0155c <io_seproxyhal_handle_event+0x7c>)
c0d014e4:	7882      	ldrb	r2, [r0, #2]
c0d014e6:	7841      	ldrb	r1, [r0, #1]
c0d014e8:	0209      	lsls	r1, r1, #8
c0d014ea:	4311      	orrs	r1, r2
c0d014ec:	7800      	ldrb	r0, [r0, #0]

  switch(G_io_seproxyhal_spi_buffer[0]) {
c0d014ee:	280f      	cmp	r0, #15
c0d014f0:	dc0a      	bgt.n	c0d01508 <io_seproxyhal_handle_event+0x28>
c0d014f2:	280e      	cmp	r0, #14
c0d014f4:	d010      	beq.n	c0d01518 <io_seproxyhal_handle_event+0x38>
c0d014f6:	280f      	cmp	r0, #15
c0d014f8:	d11d      	bne.n	c0d01536 <io_seproxyhal_handle_event+0x56>
c0d014fa:	2000      	movs	r0, #0
  #ifdef HAVE_IO_USB
    case SEPROXYHAL_TAG_USB_EVENT:
      if (rx_len != 3+1) {
c0d014fc:	2904      	cmp	r1, #4
c0d014fe:	d121      	bne.n	c0d01544 <io_seproxyhal_handle_event+0x64>
        return 0;
      }
      io_seproxyhal_handle_usb_event();
c0d01500:	f7ff ff48 	bl	c0d01394 <io_seproxyhal_handle_usb_event>
c0d01504:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaulty return as not processed
  return 0;
}
c0d01506:	bd80      	pop	{r7, pc}
c0d01508:	2810      	cmp	r0, #16
c0d0150a:	d018      	beq.n	c0d0153e <io_seproxyhal_handle_event+0x5e>
c0d0150c:	2816      	cmp	r0, #22
c0d0150e:	d112      	bne.n	c0d01536 <io_seproxyhal_handle_event+0x56>
      io_seproxyhal_handle_bluenrg_event();
      return 1;
  #endif // HAVE_BLE

    case SEPROXYHAL_TAG_CAPDU_EVENT:
      io_seproxyhal_handle_capdu_event();
c0d01510:	f000 f832 	bl	c0d01578 <io_seproxyhal_handle_capdu_event>
c0d01514:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaulty return as not processed
  return 0;
}
c0d01516:	bd80      	pop	{r7, pc}
      return 1;

      // ask the user if not processed here
    case SEPROXYHAL_TAG_TICKER_EVENT:
      // process ticker events to timeout the IO transfers, and forward to the user io_event function too
      if(G_io_timeout) {
c0d01518:	4811      	ldr	r0, [pc, #68]	; (c0d01560 <io_seproxyhal_handle_event+0x80>)
c0d0151a:	6801      	ldr	r1, [r0, #0]
c0d0151c:	2900      	cmp	r1, #0
c0d0151e:	d00a      	beq.n	c0d01536 <io_seproxyhal_handle_event+0x56>
        G_io_timeout-=MIN(G_io_timeout, 100);
c0d01520:	6802      	ldr	r2, [r0, #0]
c0d01522:	2164      	movs	r1, #100	; 0x64
c0d01524:	2a63      	cmp	r2, #99	; 0x63
c0d01526:	d800      	bhi.n	c0d0152a <io_seproxyhal_handle_event+0x4a>
c0d01528:	6801      	ldr	r1, [r0, #0]
c0d0152a:	6802      	ldr	r2, [r0, #0]
c0d0152c:	1a51      	subs	r1, r2, r1
c0d0152e:	6001      	str	r1, [r0, #0]
        #warning TODO use real ticker event interval here instead of the x100ms multiplier
        if (!G_io_timeout) {
c0d01530:	6800      	ldr	r0, [r0, #0]
c0d01532:	2800      	cmp	r0, #0
c0d01534:	d00b      	beq.n	c0d0154e <io_seproxyhal_handle_event+0x6e>
          G_io_apdu_state = APDU_IDLE;
          THROW(EXCEPTION_IO_RESET);
        }
      }
    default:
      return io_event(CHANNEL_SPI);
c0d01536:	2002      	movs	r0, #2
c0d01538:	f7fe fe70 	bl	c0d0021c <io_event>
  }
  // defaulty return as not processed
  return 0;
}
c0d0153c:	bd80      	pop	{r7, pc}
c0d0153e:	2000      	movs	r0, #0
      }
      io_seproxyhal_handle_usb_event();
      return 1;

    case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
      if (rx_len < 3+3) {
c0d01540:	2906      	cmp	r1, #6
c0d01542:	d200      	bcs.n	c0d01546 <io_seproxyhal_handle_event+0x66>
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaulty return as not processed
  return 0;
}
c0d01544:	bd80      	pop	{r7, pc}
    case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
      if (rx_len < 3+3) {
        // error !
        return 0;
      }
      io_seproxyhal_handle_usb_ep_xfer_event();
c0d01546:	f7ff ff5b 	bl	c0d01400 <io_seproxyhal_handle_usb_ep_xfer_event>
c0d0154a:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaulty return as not processed
  return 0;
}
c0d0154c:	bd80      	pop	{r7, pc}
      if(G_io_timeout) {
        G_io_timeout-=MIN(G_io_timeout, 100);
        #warning TODO use real ticker event interval here instead of the x100ms multiplier
        if (!G_io_timeout) {
          // timeout !
          G_io_apdu_state = APDU_IDLE;
c0d0154e:	4805      	ldr	r0, [pc, #20]	; (c0d01564 <io_seproxyhal_handle_event+0x84>)
c0d01550:	2100      	movs	r1, #0
c0d01552:	7001      	strb	r1, [r0, #0]
          THROW(EXCEPTION_IO_RESET);
c0d01554:	2010      	movs	r0, #16
c0d01556:	f7ff fefc 	bl	c0d01352 <os_longjmp>
c0d0155a:	46c0      	nop			; (mov r8, r8)
c0d0155c:	20001800 	.word	0x20001800
c0d01560:	20001a58 	.word	0x20001a58
c0d01564:	20001a64 	.word	0x20001a64

c0d01568 <io_usb_send_apdu_data>:
      break;
    }
  }
}

void io_usb_send_apdu_data(unsigned char* buffer, unsigned short length) {
c0d01568:	b580      	push	{r7, lr}
c0d0156a:	460a      	mov	r2, r1
c0d0156c:	4601      	mov	r1, r0
  // wait for 20 events before hanging up and timeout (~2 seconds of timeout)
  io_usb_send_ep(0x82, buffer, length, 20);
c0d0156e:	2082      	movs	r0, #130	; 0x82
c0d01570:	2314      	movs	r3, #20
c0d01572:	f7ff ff6d 	bl	c0d01450 <io_usb_send_ep>
}
c0d01576:	bd80      	pop	{r7, pc}

c0d01578 <io_seproxyhal_handle_capdu_event>:

}
#endif


void io_seproxyhal_handle_capdu_event(void) {
c0d01578:	b580      	push	{r7, lr}
  if(G_io_apdu_state == APDU_IDLE) 
c0d0157a:	480b      	ldr	r0, [pc, #44]	; (c0d015a8 <io_seproxyhal_handle_capdu_event+0x30>)
c0d0157c:	7801      	ldrb	r1, [r0, #0]
c0d0157e:	2900      	cmp	r1, #0
c0d01580:	d110      	bne.n	c0d015a4 <io_seproxyhal_handle_capdu_event+0x2c>
  {
    G_io_apdu_media = IO_APDU_MEDIA_RAW; // for application code
c0d01582:	490a      	ldr	r1, [pc, #40]	; (c0d015ac <io_seproxyhal_handle_capdu_event+0x34>)
c0d01584:	2205      	movs	r2, #5
c0d01586:	700a      	strb	r2, [r1, #0]
    G_io_apdu_state = APDU_RAW; // for next call to io_exchange
c0d01588:	210a      	movs	r1, #10
c0d0158a:	7001      	strb	r1, [r0, #0]
    G_io_apdu_length = U2BE(G_io_seproxyhal_spi_buffer, 1);
c0d0158c:	4808      	ldr	r0, [pc, #32]	; (c0d015b0 <io_seproxyhal_handle_capdu_event+0x38>)
c0d0158e:	7881      	ldrb	r1, [r0, #2]
c0d01590:	7842      	ldrb	r2, [r0, #1]
c0d01592:	0212      	lsls	r2, r2, #8
c0d01594:	430a      	orrs	r2, r1
c0d01596:	4907      	ldr	r1, [pc, #28]	; (c0d015b4 <io_seproxyhal_handle_capdu_event+0x3c>)
c0d01598:	800a      	strh	r2, [r1, #0]
    // copy apdu to apdu buffer
    os_memmove(G_io_apdu_buffer, G_io_seproxyhal_spi_buffer+3, G_io_apdu_length);
c0d0159a:	880a      	ldrh	r2, [r1, #0]
c0d0159c:	1cc1      	adds	r1, r0, #3
c0d0159e:	4806      	ldr	r0, [pc, #24]	; (c0d015b8 <io_seproxyhal_handle_capdu_event+0x40>)
c0d015a0:	f7ff fe23 	bl	c0d011ea <os_memmove>
  }
}
c0d015a4:	bd80      	pop	{r7, pc}
c0d015a6:	46c0      	nop			; (mov r8, r8)
c0d015a8:	20001a64 	.word	0x20001a64
c0d015ac:	20001a5c 	.word	0x20001a5c
c0d015b0:	20001800 	.word	0x20001800
c0d015b4:	20001a66 	.word	0x20001a66
c0d015b8:	200018f8 	.word	0x200018f8

c0d015bc <io_seproxyhal_init>:
#ifdef HAVE_BOLOS_APP_STACK_CANARY
#define APP_STACK_CANARY_MAGIC 0xDEAD0031
extern unsigned int app_stack_canary;
#endif // HAVE_BOLOS_APP_STACK_CANARY

void io_seproxyhal_init(void) {
c0d015bc:	b510      	push	{r4, lr}
  // Enforce OS compatibility
  check_api_level(CX_COMPAT_APILEVEL);
c0d015be:	2008      	movs	r0, #8
c0d015c0:	f000 fd16 	bl	c0d01ff0 <check_api_level>

#ifdef HAVE_BOLOS_APP_STACK_CANARY
  app_stack_canary = APP_STACK_CANARY_MAGIC;
#endif // HAVE_BOLOS_APP_STACK_CANARY  

  G_io_apdu_state = APDU_IDLE;
c0d015c4:	480a      	ldr	r0, [pc, #40]	; (c0d015f0 <io_seproxyhal_init+0x34>)
c0d015c6:	2400      	movs	r4, #0
c0d015c8:	7004      	strb	r4, [r0, #0]
  G_io_apdu_offset = 0;
c0d015ca:	480a      	ldr	r0, [pc, #40]	; (c0d015f4 <io_seproxyhal_init+0x38>)
c0d015cc:	8004      	strh	r4, [r0, #0]
  G_io_apdu_length = 0;
c0d015ce:	480a      	ldr	r0, [pc, #40]	; (c0d015f8 <io_seproxyhal_init+0x3c>)
c0d015d0:	8004      	strh	r4, [r0, #0]
  G_io_apdu_seq = 0;
c0d015d2:	480a      	ldr	r0, [pc, #40]	; (c0d015fc <io_seproxyhal_init+0x40>)
c0d015d4:	8004      	strh	r4, [r0, #0]
  G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d015d6:	480a      	ldr	r0, [pc, #40]	; (c0d01600 <io_seproxyhal_init+0x44>)
c0d015d8:	7004      	strb	r4, [r0, #0]
  G_io_timeout_limit = NO_TIMEOUT;
c0d015da:	480a      	ldr	r0, [pc, #40]	; (c0d01604 <io_seproxyhal_init+0x48>)
c0d015dc:	6004      	str	r4, [r0, #0]
  debug_apdus_offset = 0;
  #endif // DEBUG_APDU


  #ifdef HAVE_USB_APDU
  io_usb_hid_init();
c0d015de:	f7ff fe1f 	bl	c0d01220 <io_usb_hid_init>
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d015e2:	4809      	ldr	r0, [pc, #36]	; (c0d01608 <io_seproxyhal_init+0x4c>)
c0d015e4:	6004      	str	r4, [r0, #0]

}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d015e6:	4809      	ldr	r0, [pc, #36]	; (c0d0160c <io_seproxyhal_init+0x50>)
c0d015e8:	6004      	str	r4, [r0, #0]
  G_button_same_mask_counter = 0;
c0d015ea:	4809      	ldr	r0, [pc, #36]	; (c0d01610 <io_seproxyhal_init+0x54>)
c0d015ec:	6004      	str	r4, [r0, #0]
  io_usb_hid_init();
  #endif // HAVE_USB_APDU

  io_seproxyhal_init_ux();
  io_seproxyhal_init_button();
}
c0d015ee:	bd10      	pop	{r4, pc}
c0d015f0:	20001a64 	.word	0x20001a64
c0d015f4:	20001a68 	.word	0x20001a68
c0d015f8:	20001a66 	.word	0x20001a66
c0d015fc:	20001a6a 	.word	0x20001a6a
c0d01600:	20001a5c 	.word	0x20001a5c
c0d01604:	20001a54 	.word	0x20001a54
c0d01608:	20001a6c 	.word	0x20001a6c
c0d0160c:	20001a70 	.word	0x20001a70
c0d01610:	20001a74 	.word	0x20001a74

c0d01614 <io_seproxyhal_init_ux>:

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d01614:	4801      	ldr	r0, [pc, #4]	; (c0d0161c <io_seproxyhal_init_ux+0x8>)
c0d01616:	2100      	movs	r1, #0
c0d01618:	6001      	str	r1, [r0, #0]

}
c0d0161a:	4770      	bx	lr
c0d0161c:	20001a6c 	.word	0x20001a6c

c0d01620 <io_seproxyhal_touch_out>:
  G_button_same_mask_counter = 0;
}

#ifdef HAVE_BAGL

unsigned int io_seproxyhal_touch_out(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d01620:	b5b0      	push	{r4, r5, r7, lr}
c0d01622:	460d      	mov	r5, r1
c0d01624:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->out != NULL) {
c0d01626:	6b20      	ldr	r0, [r4, #48]	; 0x30
c0d01628:	2800      	cmp	r0, #0
c0d0162a:	d00c      	beq.n	c0d01646 <io_seproxyhal_touch_out+0x26>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->out))(element));
c0d0162c:	f000 fcc8 	bl	c0d01fc0 <pic>
c0d01630:	4601      	mov	r1, r0
c0d01632:	4620      	mov	r0, r4
c0d01634:	4788      	blx	r1
c0d01636:	f000 fcc3 	bl	c0d01fc0 <pic>
c0d0163a:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (! el) {
c0d0163c:	2800      	cmp	r0, #0
c0d0163e:	d010      	beq.n	c0d01662 <io_seproxyhal_touch_out+0x42>
c0d01640:	2801      	cmp	r0, #1
c0d01642:	d000      	beq.n	c0d01646 <io_seproxyhal_touch_out+0x26>
c0d01644:	4604      	mov	r4, r0
      element = el;
    }
  }

  // out function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d01646:	2d00      	cmp	r5, #0
c0d01648:	d007      	beq.n	c0d0165a <io_seproxyhal_touch_out+0x3a>
    el = before_display(element);
c0d0164a:	4620      	mov	r0, r4
c0d0164c:	47a8      	blx	r5
c0d0164e:	2100      	movs	r1, #0
    if (!el) {
c0d01650:	2800      	cmp	r0, #0
c0d01652:	d006      	beq.n	c0d01662 <io_seproxyhal_touch_out+0x42>
c0d01654:	2801      	cmp	r0, #1
c0d01656:	d000      	beq.n	c0d0165a <io_seproxyhal_touch_out+0x3a>
c0d01658:	4604      	mov	r4, r0
    if ((unsigned int)el != 1) {
      element = el;
    }
  }

  io_seproxyhal_display(element);
c0d0165a:	4620      	mov	r0, r4
c0d0165c:	f7fe fdda 	bl	c0d00214 <io_seproxyhal_display>
c0d01660:	2101      	movs	r1, #1
  return 1;
}
c0d01662:	4608      	mov	r0, r1
c0d01664:	bdb0      	pop	{r4, r5, r7, pc}

c0d01666 <io_seproxyhal_touch_over>:

unsigned int io_seproxyhal_touch_over(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d01666:	b5b0      	push	{r4, r5, r7, lr}
c0d01668:	b08e      	sub	sp, #56	; 0x38
c0d0166a:	460c      	mov	r4, r1
c0d0166c:	4605      	mov	r5, r0
  bagl_element_t e;
  const bagl_element_t* el;
  if (element->over != NULL) {
c0d0166e:	6b68      	ldr	r0, [r5, #52]	; 0x34
c0d01670:	2800      	cmp	r0, #0
c0d01672:	d00c      	beq.n	c0d0168e <io_seproxyhal_touch_over+0x28>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->over))(element));
c0d01674:	f000 fca4 	bl	c0d01fc0 <pic>
c0d01678:	4601      	mov	r1, r0
c0d0167a:	4628      	mov	r0, r5
c0d0167c:	4788      	blx	r1
c0d0167e:	f000 fc9f 	bl	c0d01fc0 <pic>
c0d01682:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (!el) {
c0d01684:	2800      	cmp	r0, #0
c0d01686:	d016      	beq.n	c0d016b6 <io_seproxyhal_touch_over+0x50>
c0d01688:	2801      	cmp	r0, #1
c0d0168a:	d000      	beq.n	c0d0168e <io_seproxyhal_touch_over+0x28>
c0d0168c:	4605      	mov	r5, r0
c0d0168e:	4668      	mov	r0, sp
      element = el;
    }
  }

  // over function might have triggered a draw of its own during a display callback
  os_memmove(&e, (void*)element, sizeof(bagl_element_t));
c0d01690:	2238      	movs	r2, #56	; 0x38
c0d01692:	4629      	mov	r1, r5
c0d01694:	f7ff fda9 	bl	c0d011ea <os_memmove>
  e.component.fgcolor = element->overfgcolor;
c0d01698:	6a68      	ldr	r0, [r5, #36]	; 0x24
c0d0169a:	9004      	str	r0, [sp, #16]
  e.component.bgcolor = element->overbgcolor;
c0d0169c:	6aa8      	ldr	r0, [r5, #40]	; 0x28
c0d0169e:	9005      	str	r0, [sp, #20]

  //element = &e; // for INARRAY checks, it disturbs a bit. avoid it

  if (before_display) {
c0d016a0:	2c00      	cmp	r4, #0
c0d016a2:	d004      	beq.n	c0d016ae <io_seproxyhal_touch_over+0x48>
    el = before_display(element);
c0d016a4:	4628      	mov	r0, r5
c0d016a6:	47a0      	blx	r4
c0d016a8:	2100      	movs	r1, #0
    element = &e;
    if (!el) {
c0d016aa:	2800      	cmp	r0, #0
c0d016ac:	d003      	beq.n	c0d016b6 <io_seproxyhal_touch_over+0x50>
c0d016ae:	4668      	mov	r0, sp
  //else 
  {
    element = &e;
  }

  io_seproxyhal_display(element);
c0d016b0:	f7fe fdb0 	bl	c0d00214 <io_seproxyhal_display>
c0d016b4:	2101      	movs	r1, #1
  return 1;
}
c0d016b6:	4608      	mov	r0, r1
c0d016b8:	b00e      	add	sp, #56	; 0x38
c0d016ba:	bdb0      	pop	{r4, r5, r7, pc}

c0d016bc <io_seproxyhal_touch_tap>:

unsigned int io_seproxyhal_touch_tap(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d016bc:	b5b0      	push	{r4, r5, r7, lr}
c0d016be:	460d      	mov	r5, r1
c0d016c0:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->tap != NULL) {
c0d016c2:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0d016c4:	2800      	cmp	r0, #0
c0d016c6:	d00c      	beq.n	c0d016e2 <io_seproxyhal_touch_tap+0x26>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->tap))(element));
c0d016c8:	f000 fc7a 	bl	c0d01fc0 <pic>
c0d016cc:	4601      	mov	r1, r0
c0d016ce:	4620      	mov	r0, r4
c0d016d0:	4788      	blx	r1
c0d016d2:	f000 fc75 	bl	c0d01fc0 <pic>
c0d016d6:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (!el) {
c0d016d8:	2800      	cmp	r0, #0
c0d016da:	d010      	beq.n	c0d016fe <io_seproxyhal_touch_tap+0x42>
c0d016dc:	2801      	cmp	r0, #1
c0d016de:	d000      	beq.n	c0d016e2 <io_seproxyhal_touch_tap+0x26>
c0d016e0:	4604      	mov	r4, r0
      element = el;
    }
  }

  // tap function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d016e2:	2d00      	cmp	r5, #0
c0d016e4:	d007      	beq.n	c0d016f6 <io_seproxyhal_touch_tap+0x3a>
    el = before_display(element);
c0d016e6:	4620      	mov	r0, r4
c0d016e8:	47a8      	blx	r5
c0d016ea:	2100      	movs	r1, #0
    if (!el) {
c0d016ec:	2800      	cmp	r0, #0
c0d016ee:	d006      	beq.n	c0d016fe <io_seproxyhal_touch_tap+0x42>
c0d016f0:	2801      	cmp	r0, #1
c0d016f2:	d000      	beq.n	c0d016f6 <io_seproxyhal_touch_tap+0x3a>
c0d016f4:	4604      	mov	r4, r0
    }
    if ((unsigned int)el != 1) {
      element = el;
    }
  }
  io_seproxyhal_display(element);
c0d016f6:	4620      	mov	r0, r4
c0d016f8:	f7fe fd8c 	bl	c0d00214 <io_seproxyhal_display>
c0d016fc:	2101      	movs	r1, #1
  return 1;
}
c0d016fe:	4608      	mov	r0, r1
c0d01700:	bdb0      	pop	{r4, r5, r7, pc}
	...

c0d01704 <io_seproxyhal_touch_element_callback>:
  io_seproxyhal_touch_element_callback(elements, element_count, x, y, event_kind, NULL);  
}

// browse all elements and until an element has changed state, continue browsing
// return if processed or not
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
c0d01704:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01706:	b087      	sub	sp, #28
c0d01708:	9302      	str	r3, [sp, #8]
c0d0170a:	9203      	str	r2, [sp, #12]
c0d0170c:	9105      	str	r1, [sp, #20]
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d0170e:	2900      	cmp	r1, #0
c0d01710:	d077      	beq.n	c0d01802 <io_seproxyhal_touch_element_callback+0xfe>
c0d01712:	9004      	str	r0, [sp, #16]
c0d01714:	980d      	ldr	r0, [sp, #52]	; 0x34
c0d01716:	9001      	str	r0, [sp, #4]
c0d01718:	980c      	ldr	r0, [sp, #48]	; 0x30
c0d0171a:	9000      	str	r0, [sp, #0]
c0d0171c:	2500      	movs	r5, #0
c0d0171e:	4b3c      	ldr	r3, [pc, #240]	; (c0d01810 <io_seproxyhal_touch_element_callback+0x10c>)
c0d01720:	9506      	str	r5, [sp, #24]
c0d01722:	462f      	mov	r7, r5
c0d01724:	461e      	mov	r6, r3
    // process all components matching the x/y/w/h (no break) => fishy for the released out of zone
    // continue processing only if a status has not been sent
    if (io_seproxyhal_spi_is_status_sent()) {
c0d01726:	f000 fdc5 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d0172a:	2800      	cmp	r0, #0
c0d0172c:	d155      	bne.n	c0d017da <io_seproxyhal_touch_element_callback+0xd6>
      // continue instead of return to process all elemnts and therefore discard last touched element
      break;
    }

    // only perform out callback when element was in the current array, else, leave it be
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
c0d0172e:	2038      	movs	r0, #56	; 0x38
c0d01730:	4368      	muls	r0, r5
c0d01732:	9c04      	ldr	r4, [sp, #16]
c0d01734:	1825      	adds	r5, r4, r0
c0d01736:	4633      	mov	r3, r6
c0d01738:	681a      	ldr	r2, [r3, #0]
c0d0173a:	2101      	movs	r1, #1
c0d0173c:	4295      	cmp	r5, r2
c0d0173e:	d000      	beq.n	c0d01742 <io_seproxyhal_touch_element_callback+0x3e>
c0d01740:	9906      	ldr	r1, [sp, #24]
c0d01742:	9106      	str	r1, [sp, #24]
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d01744:	5620      	ldrsb	r0, [r4, r0]
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
c0d01746:	2800      	cmp	r0, #0
c0d01748:	da41      	bge.n	c0d017ce <io_seproxyhal_touch_element_callback+0xca>
c0d0174a:	2020      	movs	r0, #32
c0d0174c:	5c28      	ldrb	r0, [r5, r0]
c0d0174e:	2102      	movs	r1, #2
c0d01750:	5e69      	ldrsh	r1, [r5, r1]
c0d01752:	1a0a      	subs	r2, r1, r0
c0d01754:	9c03      	ldr	r4, [sp, #12]
c0d01756:	42a2      	cmp	r2, r4
c0d01758:	dc39      	bgt.n	c0d017ce <io_seproxyhal_touch_element_callback+0xca>
c0d0175a:	1841      	adds	r1, r0, r1
c0d0175c:	88ea      	ldrh	r2, [r5, #6]
c0d0175e:	1889      	adds	r1, r1, r2
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {
c0d01760:	9a03      	ldr	r2, [sp, #12]
c0d01762:	428a      	cmp	r2, r1
c0d01764:	da33      	bge.n	c0d017ce <io_seproxyhal_touch_element_callback+0xca>
c0d01766:	2104      	movs	r1, #4
c0d01768:	5e6c      	ldrsh	r4, [r5, r1]
c0d0176a:	1a22      	subs	r2, r4, r0
c0d0176c:	9902      	ldr	r1, [sp, #8]
c0d0176e:	428a      	cmp	r2, r1
c0d01770:	dc2d      	bgt.n	c0d017ce <io_seproxyhal_touch_element_callback+0xca>
c0d01772:	1820      	adds	r0, r4, r0
c0d01774:	8929      	ldrh	r1, [r5, #8]
c0d01776:	1840      	adds	r0, r0, r1
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d01778:	9902      	ldr	r1, [sp, #8]
c0d0177a:	4281      	cmp	r1, r0
c0d0177c:	da27      	bge.n	c0d017ce <io_seproxyhal_touch_element_callback+0xca>
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d0177e:	6818      	ldr	r0, [r3, #0]
              && G_bagl_last_touched_not_released_component != NULL) {
c0d01780:	4285      	cmp	r5, r0
c0d01782:	d010      	beq.n	c0d017a6 <io_seproxyhal_touch_element_callback+0xa2>
c0d01784:	6818      	ldr	r0, [r3, #0]
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d01786:	2800      	cmp	r0, #0
c0d01788:	d00d      	beq.n	c0d017a6 <io_seproxyhal_touch_element_callback+0xa2>
              && G_bagl_last_touched_not_released_component != NULL) {
        // only out the previous element if the newly matching will be displayed 
        if (!before_display || before_display(&elements[comp_idx])) {
c0d0178a:	9801      	ldr	r0, [sp, #4]
c0d0178c:	2800      	cmp	r0, #0
c0d0178e:	d005      	beq.n	c0d0179c <io_seproxyhal_touch_element_callback+0x98>
c0d01790:	4628      	mov	r0, r5
c0d01792:	9901      	ldr	r1, [sp, #4]
c0d01794:	4788      	blx	r1
c0d01796:	4633      	mov	r3, r6
c0d01798:	2800      	cmp	r0, #0
c0d0179a:	d018      	beq.n	c0d017ce <io_seproxyhal_touch_element_callback+0xca>
          if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d0179c:	6818      	ldr	r0, [r3, #0]
c0d0179e:	9901      	ldr	r1, [sp, #4]
c0d017a0:	f7ff ff3e 	bl	c0d01620 <io_seproxyhal_touch_out>
c0d017a4:	e008      	b.n	c0d017b8 <io_seproxyhal_touch_element_callback+0xb4>
c0d017a6:	9800      	ldr	r0, [sp, #0]
        continue;
      }
      */
      
      // callback the hal to notify the component impacted by the user input
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_RELEASE) {
c0d017a8:	2801      	cmp	r0, #1
c0d017aa:	d009      	beq.n	c0d017c0 <io_seproxyhal_touch_element_callback+0xbc>
c0d017ac:	2802      	cmp	r0, #2
c0d017ae:	d10e      	bne.n	c0d017ce <io_seproxyhal_touch_element_callback+0xca>
        if (io_seproxyhal_touch_tap(&elements[comp_idx], before_display)) {
c0d017b0:	4628      	mov	r0, r5
c0d017b2:	9901      	ldr	r1, [sp, #4]
c0d017b4:	f7ff ff82 	bl	c0d016bc <io_seproxyhal_touch_tap>
c0d017b8:	4633      	mov	r3, r6
c0d017ba:	2800      	cmp	r0, #0
c0d017bc:	d007      	beq.n	c0d017ce <io_seproxyhal_touch_element_callback+0xca>
c0d017be:	e022      	b.n	c0d01806 <io_seproxyhal_touch_element_callback+0x102>
          return;
        }
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
c0d017c0:	4628      	mov	r0, r5
c0d017c2:	9901      	ldr	r1, [sp, #4]
c0d017c4:	f7ff ff4f 	bl	c0d01666 <io_seproxyhal_touch_over>
c0d017c8:	4633      	mov	r3, r6
c0d017ca:	2800      	cmp	r0, #0
c0d017cc:	d11e      	bne.n	c0d0180c <io_seproxyhal_touch_element_callback+0x108>
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d017ce:	1c7f      	adds	r7, r7, #1
c0d017d0:	b2fd      	uxtb	r5, r7
c0d017d2:	9805      	ldr	r0, [sp, #20]
c0d017d4:	4285      	cmp	r5, r0
c0d017d6:	d3a5      	bcc.n	c0d01724 <io_seproxyhal_touch_element_callback+0x20>
c0d017d8:	e000      	b.n	c0d017dc <io_seproxyhal_touch_element_callback+0xd8>
c0d017da:	4633      	mov	r3, r6
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
    && G_bagl_last_touched_not_released_component != NULL) {
c0d017dc:	9806      	ldr	r0, [sp, #24]
c0d017de:	0600      	lsls	r0, r0, #24
c0d017e0:	d00f      	beq.n	c0d01802 <io_seproxyhal_touch_element_callback+0xfe>
c0d017e2:	6818      	ldr	r0, [r3, #0]
      }
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
c0d017e4:	2800      	cmp	r0, #0
c0d017e6:	d00c      	beq.n	c0d01802 <io_seproxyhal_touch_element_callback+0xfe>
    && G_bagl_last_touched_not_released_component != NULL) {

    // we won't be able to notify the out, don't do it, in case a diplay refused the dra of the relased element and the position matched another element of the array (in autocomplete for example)
    if (io_seproxyhal_spi_is_status_sent()) {
c0d017e8:	f000 fd64 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d017ec:	4631      	mov	r1, r6
c0d017ee:	2800      	cmp	r0, #0
c0d017f0:	d107      	bne.n	c0d01802 <io_seproxyhal_touch_element_callback+0xfe>
      return;
    }
    
    if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d017f2:	6808      	ldr	r0, [r1, #0]
c0d017f4:	9901      	ldr	r1, [sp, #4]
c0d017f6:	f7ff ff13 	bl	c0d01620 <io_seproxyhal_touch_out>
c0d017fa:	2800      	cmp	r0, #0
c0d017fc:	d001      	beq.n	c0d01802 <io_seproxyhal_touch_element_callback+0xfe>
      // ok component out has been emitted
      G_bagl_last_touched_not_released_component = NULL;
c0d017fe:	2000      	movs	r0, #0
c0d01800:	6030      	str	r0, [r6, #0]
    }
  }

  // not processed
}
c0d01802:	b007      	add	sp, #28
c0d01804:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01806:	2000      	movs	r0, #0
c0d01808:	6018      	str	r0, [r3, #0]
c0d0180a:	e7fa      	b.n	c0d01802 <io_seproxyhal_touch_element_callback+0xfe>
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
          // remember the last touched component
          G_bagl_last_touched_not_released_component = (bagl_element_t*)&elements[comp_idx];
c0d0180c:	601d      	str	r5, [r3, #0]
c0d0180e:	e7f8      	b.n	c0d01802 <io_seproxyhal_touch_element_callback+0xfe>
c0d01810:	20001a6c 	.word	0x20001a6c

c0d01814 <io_seproxyhal_display_icon>:
  // remaining length of bitmap bits to be displayed
  return len;
}
#endif // SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS

void io_seproxyhal_display_icon(bagl_component_t* icon_component, bagl_icon_details_t* icon_details) {
c0d01814:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01816:	b089      	sub	sp, #36	; 0x24
c0d01818:	460c      	mov	r4, r1
c0d0181a:	4601      	mov	r1, r0
c0d0181c:	ad02      	add	r5, sp, #8
c0d0181e:	221c      	movs	r2, #28
  bagl_component_t icon_component_mod;
  // ensure not being out of bounds in the icon component agianst the declared icon real size
  os_memmove(&icon_component_mod, icon_component, sizeof(bagl_component_t));
c0d01820:	4628      	mov	r0, r5
c0d01822:	9201      	str	r2, [sp, #4]
c0d01824:	f7ff fce1 	bl	c0d011ea <os_memmove>
  icon_component_mod.width = icon_details->width;
c0d01828:	6821      	ldr	r1, [r4, #0]
c0d0182a:	80e9      	strh	r1, [r5, #6]
  icon_component_mod.height = icon_details->height;
c0d0182c:	6862      	ldr	r2, [r4, #4]
c0d0182e:	812a      	strh	r2, [r5, #8]
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d01830:	68a0      	ldr	r0, [r4, #8]
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
                          +w; /* image bitmap size */
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d01832:	4f1a      	ldr	r7, [pc, #104]	; (c0d0189c <io_seproxyhal_display_icon+0x88>)
c0d01834:	2365      	movs	r3, #101	; 0x65
c0d01836:	703b      	strb	r3, [r7, #0]


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
c0d01838:	b292      	uxth	r2, r2
c0d0183a:	4342      	muls	r2, r0
c0d0183c:	b28b      	uxth	r3, r1
c0d0183e:	4353      	muls	r3, r2
c0d01840:	08d9      	lsrs	r1, r3, #3
c0d01842:	1c4e      	adds	r6, r1, #1
c0d01844:	2207      	movs	r2, #7
c0d01846:	4213      	tst	r3, r2
c0d01848:	d100      	bne.n	c0d0184c <io_seproxyhal_display_icon+0x38>
c0d0184a:	460e      	mov	r6, r1
c0d0184c:	4631      	mov	r1, r6
c0d0184e:	9100      	str	r1, [sp, #0]
c0d01850:	2604      	movs	r6, #4
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d01852:	4086      	lsls	r6, r0
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
c0d01854:	1870      	adds	r0, r6, r1
                          +w; /* image bitmap size */
c0d01856:	301d      	adds	r0, #29
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
  G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d01858:	0a01      	lsrs	r1, r0, #8
c0d0185a:	7079      	strb	r1, [r7, #1]
  G_io_seproxyhal_spi_buffer[2] = length;
c0d0185c:	70b8      	strb	r0, [r7, #2]
c0d0185e:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d01860:	4638      	mov	r0, r7
c0d01862:	f000 fd11 	bl	c0d02288 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)icon_component, sizeof(bagl_component_t));
c0d01866:	4628      	mov	r0, r5
c0d01868:	9901      	ldr	r1, [sp, #4]
c0d0186a:	f000 fd0d 	bl	c0d02288 <io_seproxyhal_spi_send>
  G_io_seproxyhal_spi_buffer[0] = icon_details->bpp;
c0d0186e:	68a0      	ldr	r0, [r4, #8]
c0d01870:	7038      	strb	r0, [r7, #0]
c0d01872:	2101      	movs	r1, #1
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 1);
c0d01874:	4638      	mov	r0, r7
c0d01876:	f000 fd07 	bl	c0d02288 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->colors), h);
c0d0187a:	68e0      	ldr	r0, [r4, #12]
c0d0187c:	f000 fba0 	bl	c0d01fc0 <pic>
c0d01880:	b2b1      	uxth	r1, r6
c0d01882:	f000 fd01 	bl	c0d02288 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->bitmap), w);
c0d01886:	9800      	ldr	r0, [sp, #0]
c0d01888:	b285      	uxth	r5, r0
c0d0188a:	6920      	ldr	r0, [r4, #16]
c0d0188c:	f000 fb98 	bl	c0d01fc0 <pic>
c0d01890:	4629      	mov	r1, r5
c0d01892:	f000 fcf9 	bl	c0d02288 <io_seproxyhal_spi_send>
#endif // !SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS
}
c0d01896:	b009      	add	sp, #36	; 0x24
c0d01898:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0189a:	46c0      	nop			; (mov r8, r8)
c0d0189c:	20001800 	.word	0x20001800

c0d018a0 <io_seproxyhal_display_default>:

void io_seproxyhal_display_default(const bagl_element_t * element) {
c0d018a0:	b570      	push	{r4, r5, r6, lr}
c0d018a2:	4604      	mov	r4, r0
  // process automagically address from rom and from ram
  unsigned int type = (element->component.type & ~(BAGL_FLAG_TOUCHABLE));
c0d018a4:	7820      	ldrb	r0, [r4, #0]
c0d018a6:	267f      	movs	r6, #127	; 0x7f
c0d018a8:	4006      	ands	r6, r0

  // avoid sending another status :), fixes a lot of bugs in the end
  if (io_seproxyhal_spi_is_status_sent()) {
c0d018aa:	f000 fd03 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d018ae:	2800      	cmp	r0, #0
c0d018b0:	d130      	bne.n	c0d01914 <io_seproxyhal_display_default+0x74>
c0d018b2:	2e00      	cmp	r6, #0
c0d018b4:	d02e      	beq.n	c0d01914 <io_seproxyhal_display_default+0x74>
    return;
  }

  if (type != BAGL_NONE) {
    if (element->text != NULL) {
c0d018b6:	69e0      	ldr	r0, [r4, #28]
c0d018b8:	2800      	cmp	r0, #0
c0d018ba:	d01d      	beq.n	c0d018f8 <io_seproxyhal_display_default+0x58>
      unsigned int text_adr = PIC((unsigned int)element->text);
c0d018bc:	f000 fb80 	bl	c0d01fc0 <pic>
c0d018c0:	4605      	mov	r5, r0
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
c0d018c2:	2e05      	cmp	r6, #5
c0d018c4:	d102      	bne.n	c0d018cc <io_seproxyhal_display_default+0x2c>
c0d018c6:	7ea0      	ldrb	r0, [r4, #26]
c0d018c8:	2800      	cmp	r0, #0
c0d018ca:	d024      	beq.n	c0d01916 <io_seproxyhal_display_default+0x76>
        io_seproxyhal_display_icon(&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d018cc:	4628      	mov	r0, r5
c0d018ce:	f003 f869 	bl	c0d049a4 <strlen>
c0d018d2:	4606      	mov	r6, r0
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d018d4:	4812      	ldr	r0, [pc, #72]	; (c0d01920 <io_seproxyhal_display_default+0x80>)
c0d018d6:	2165      	movs	r1, #101	; 0x65
c0d018d8:	7001      	strb	r1, [r0, #0]
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon(&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d018da:	4631      	mov	r1, r6
c0d018dc:	311c      	adds	r1, #28
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
        G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d018de:	0a0a      	lsrs	r2, r1, #8
c0d018e0:	7042      	strb	r2, [r0, #1]
        G_io_seproxyhal_spi_buffer[2] = length;
c0d018e2:	7081      	strb	r1, [r0, #2]
        io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d018e4:	2103      	movs	r1, #3
c0d018e6:	f000 fccf 	bl	c0d02288 <io_seproxyhal_spi_send>
c0d018ea:	211c      	movs	r1, #28
        io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d018ec:	4620      	mov	r0, r4
c0d018ee:	f000 fccb 	bl	c0d02288 <io_seproxyhal_spi_send>
        io_seproxyhal_spi_send((unsigned char*)text_adr, length-sizeof(bagl_component_t));
c0d018f2:	b2b1      	uxth	r1, r6
c0d018f4:	4628      	mov	r0, r5
c0d018f6:	e00b      	b.n	c0d01910 <io_seproxyhal_display_default+0x70>
      }
    }
    else {
      unsigned short length = sizeof(bagl_component_t);
      G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d018f8:	4809      	ldr	r0, [pc, #36]	; (c0d01920 <io_seproxyhal_display_default+0x80>)
c0d018fa:	2165      	movs	r1, #101	; 0x65
c0d018fc:	7001      	strb	r1, [r0, #0]
      G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d018fe:	2100      	movs	r1, #0
c0d01900:	7041      	strb	r1, [r0, #1]
c0d01902:	251c      	movs	r5, #28
      G_io_seproxyhal_spi_buffer[2] = length;
c0d01904:	7085      	strb	r5, [r0, #2]
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d01906:	2103      	movs	r1, #3
c0d01908:	f000 fcbe 	bl	c0d02288 <io_seproxyhal_spi_send>
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d0190c:	4620      	mov	r0, r4
c0d0190e:	4629      	mov	r1, r5
c0d01910:	f000 fcba 	bl	c0d02288 <io_seproxyhal_spi_send>
    }
  }
}
c0d01914:	bd70      	pop	{r4, r5, r6, pc}
  if (type != BAGL_NONE) {
    if (element->text != NULL) {
      unsigned int text_adr = PIC((unsigned int)element->text);
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon(&element->component, (bagl_icon_details_t*)text_adr);
c0d01916:	4620      	mov	r0, r4
c0d01918:	4629      	mov	r1, r5
c0d0191a:	f7ff ff7b 	bl	c0d01814 <io_seproxyhal_display_icon>
      G_io_seproxyhal_spi_buffer[2] = length;
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
    }
  }
}
c0d0191e:	bd70      	pop	{r4, r5, r6, pc}
c0d01920:	20001800 	.word	0x20001800

c0d01924 <io_seproxyhal_button_push>:
  G_io_seproxyhal_spi_buffer[3] = (backlight_percentage?0x80:0)|(flags & 0x7F); // power on
  G_io_seproxyhal_spi_buffer[4] = backlight_percentage;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
}

void io_seproxyhal_button_push(button_push_callback_t button_callback, unsigned int new_button_mask) {
c0d01924:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01926:	b081      	sub	sp, #4
c0d01928:	4604      	mov	r4, r0
  if (button_callback) {
c0d0192a:	2c00      	cmp	r4, #0
c0d0192c:	d02b      	beq.n	c0d01986 <io_seproxyhal_button_push+0x62>
    unsigned int button_mask;
    unsigned int button_same_mask_counter;
    // enable speeded up long push
    if (new_button_mask == G_button_mask) {
c0d0192e:	4817      	ldr	r0, [pc, #92]	; (c0d0198c <io_seproxyhal_button_push+0x68>)
c0d01930:	6802      	ldr	r2, [r0, #0]
c0d01932:	428a      	cmp	r2, r1
c0d01934:	d103      	bne.n	c0d0193e <io_seproxyhal_button_push+0x1a>
      // each 100ms ~
      G_button_same_mask_counter++;
c0d01936:	4a16      	ldr	r2, [pc, #88]	; (c0d01990 <io_seproxyhal_button_push+0x6c>)
c0d01938:	6813      	ldr	r3, [r2, #0]
c0d0193a:	1c5b      	adds	r3, r3, #1
c0d0193c:	6013      	str	r3, [r2, #0]
    }

    // append the button mask
    button_mask = G_button_mask | new_button_mask;
c0d0193e:	6806      	ldr	r6, [r0, #0]
c0d01940:	430e      	orrs	r6, r1

    // pre reset variable due to os_sched_exit
    button_same_mask_counter = G_button_same_mask_counter;
c0d01942:	4a13      	ldr	r2, [pc, #76]	; (c0d01990 <io_seproxyhal_button_push+0x6c>)
c0d01944:	6815      	ldr	r5, [r2, #0]
c0d01946:	4f13      	ldr	r7, [pc, #76]	; (c0d01994 <io_seproxyhal_button_push+0x70>)

    // reset button mask
    if (new_button_mask == 0) {
c0d01948:	2900      	cmp	r1, #0
c0d0194a:	d001      	beq.n	c0d01950 <io_seproxyhal_button_push+0x2c>

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
    }
    else {
      G_button_mask = button_mask;
c0d0194c:	6006      	str	r6, [r0, #0]
c0d0194e:	e004      	b.n	c0d0195a <io_seproxyhal_button_push+0x36>
c0d01950:	2300      	movs	r3, #0
    button_same_mask_counter = G_button_same_mask_counter;

    // reset button mask
    if (new_button_mask == 0) {
      // reset next state when button are released
      G_button_mask = 0;
c0d01952:	6003      	str	r3, [r0, #0]
      G_button_same_mask_counter=0;
c0d01954:	6013      	str	r3, [r2, #0]

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
c0d01956:	1c7b      	adds	r3, r7, #1
c0d01958:	431e      	orrs	r6, r3
    else {
      G_button_mask = button_mask;
    }

    // reset counter when button mask changes
    if (new_button_mask != G_button_mask) {
c0d0195a:	6800      	ldr	r0, [r0, #0]
c0d0195c:	4288      	cmp	r0, r1
c0d0195e:	d001      	beq.n	c0d01964 <io_seproxyhal_button_push+0x40>
      G_button_same_mask_counter=0;
c0d01960:	2000      	movs	r0, #0
c0d01962:	6010      	str	r0, [r2, #0]
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
c0d01964:	2d08      	cmp	r5, #8
c0d01966:	d30b      	bcc.n	c0d01980 <io_seproxyhal_button_push+0x5c>
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d01968:	2103      	movs	r1, #3
c0d0196a:	4628      	mov	r0, r5
c0d0196c:	f002 fe7a 	bl	c0d04664 <__aeabi_uidivmod>
        button_mask |= BUTTON_EVT_FAST;
c0d01970:	2001      	movs	r0, #1
c0d01972:	0780      	lsls	r0, r0, #30
c0d01974:	4330      	orrs	r0, r6
      G_button_same_mask_counter=0;
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d01976:	2900      	cmp	r1, #0
c0d01978:	d000      	beq.n	c0d0197c <io_seproxyhal_button_push+0x58>
c0d0197a:	4630      	mov	r0, r6
      }
      */

      // discard the release event after a fastskip has been detected, to avoid strange at release behavior
      // and also to enable user to cancel an operation by starting triggering the fast skip
      button_mask &= ~BUTTON_EVT_RELEASED;
c0d0197c:	4038      	ands	r0, r7
c0d0197e:	e000      	b.n	c0d01982 <io_seproxyhal_button_push+0x5e>
c0d01980:	4630      	mov	r0, r6
    }

    // indicate if button have been released
    button_callback(button_mask, button_same_mask_counter);
c0d01982:	4629      	mov	r1, r5
c0d01984:	47a0      	blx	r4
  }
}
c0d01986:	b001      	add	sp, #4
c0d01988:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0198a:	46c0      	nop			; (mov r8, r8)
c0d0198c:	20001a70 	.word	0x20001a70
c0d01990:	20001a74 	.word	0x20001a74
c0d01994:	7fffffff 	.word	0x7fffffff

c0d01998 <io_exchange>:

#ifdef HAVE_IO_U2F
u2f_service_t G_io_u2f;
#endif // HAVE_IO_U2F

unsigned short io_exchange(unsigned char channel, unsigned short tx_len) {
c0d01998:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0199a:	b083      	sub	sp, #12
c0d0199c:	460d      	mov	r5, r1
c0d0199e:	4604      	mov	r4, r0
    }
  }
  after_debug:
#endif // DEBUG_APDU

  switch(channel&~(IO_FLAGS)) {
c0d019a0:	200f      	movs	r0, #15
c0d019a2:	4204      	tst	r4, r0
c0d019a4:	d007      	beq.n	c0d019b6 <io_exchange+0x1e>
      }
    }
    break;

  default:
    return io_exchange_al(channel, tx_len);
c0d019a6:	4620      	mov	r0, r4
c0d019a8:	4629      	mov	r1, r5
c0d019aa:	f7fe fc0b 	bl	c0d001c4 <io_exchange_al>
c0d019ae:	4605      	mov	r5, r0
  }
}
c0d019b0:	b2a8      	uxth	r0, r5
c0d019b2:	b003      	add	sp, #12
c0d019b4:	bdf0      	pop	{r4, r5, r6, r7, pc}

  switch(channel&~(IO_FLAGS)) {
  case CHANNEL_APDU:
    // TODO work up the spi state machine over the HAL proxy until an APDU is available

    if (tx_len && !(channel&IO_ASYNCH_REPLY)) {
c0d019b6:	2610      	movs	r6, #16
c0d019b8:	4026      	ands	r6, r4
c0d019ba:	4f69      	ldr	r7, [pc, #420]	; (c0d01b60 <io_exchange+0x1c8>)
c0d019bc:	2d00      	cmp	r5, #0
c0d019be:	d06f      	beq.n	c0d01aa0 <io_exchange+0x108>
c0d019c0:	2e00      	cmp	r6, #0
c0d019c2:	d16d      	bne.n	c0d01aa0 <io_exchange+0x108>
      // prepare response timeout
      G_io_timeout = IO_RAPDU_TRANSMIT_TIMEOUT_MS;
c0d019c4:	207d      	movs	r0, #125	; 0x7d
c0d019c6:	0100      	lsls	r0, r0, #4
c0d019c8:	4966      	ldr	r1, [pc, #408]	; (c0d01b64 <io_exchange+0x1cc>)
c0d019ca:	6008      	str	r0, [r1, #0]

      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
c0d019cc:	4966      	ldr	r1, [pc, #408]	; (c0d01b68 <io_exchange+0x1d0>)
c0d019ce:	7808      	ldrb	r0, [r1, #0]
c0d019d0:	2808      	cmp	r0, #8
c0d019d2:	9702      	str	r7, [sp, #8]
c0d019d4:	dd17      	ble.n	c0d01a06 <io_exchange+0x6e>
c0d019d6:	2809      	cmp	r0, #9
c0d019d8:	d021      	beq.n	c0d01a1e <io_exchange+0x86>
c0d019da:	280a      	cmp	r0, #10
c0d019dc:	d145      	bne.n	c0d01a6a <io_exchange+0xd2>
c0d019de:	460f      	mov	r7, r1
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
            break;

          case APDU_RAW:
            if (tx_len > sizeof(G_io_apdu_buffer)) {
c0d019e0:	0868      	lsrs	r0, r5, #1
c0d019e2:	28a9      	cmp	r0, #169	; 0xa9
c0d019e4:	d300      	bcc.n	c0d019e8 <io_exchange+0x50>
c0d019e6:	e0b7      	b.n	c0d01b58 <io_exchange+0x1c0>
              THROW(INVALID_PARAMETER);
            }
            // reply the RAW APDU over SEPROXYHAL protocol
            G_io_seproxyhal_spi_buffer[0]  = SEPROXYHAL_TAG_RAPDU;
c0d019e8:	4862      	ldr	r0, [pc, #392]	; (c0d01b74 <io_exchange+0x1dc>)
c0d019ea:	2153      	movs	r1, #83	; 0x53
c0d019ec:	7001      	strb	r1, [r0, #0]
            G_io_seproxyhal_spi_buffer[1]  = (tx_len)>>8;
c0d019ee:	0a29      	lsrs	r1, r5, #8
c0d019f0:	7041      	strb	r1, [r0, #1]
            G_io_seproxyhal_spi_buffer[2]  = (tx_len);
c0d019f2:	7085      	strb	r5, [r0, #2]
            io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d019f4:	2103      	movs	r1, #3
c0d019f6:	f000 fc47 	bl	c0d02288 <io_seproxyhal_spi_send>
            io_seproxyhal_spi_send(G_io_apdu_buffer, tx_len);
c0d019fa:	485c      	ldr	r0, [pc, #368]	; (c0d01b6c <io_exchange+0x1d4>)
c0d019fc:	4629      	mov	r1, r5
c0d019fe:	f000 fc43 	bl	c0d02288 <io_seproxyhal_spi_send>
c0d01a02:	4639      	mov	r1, r7
c0d01a04:	e039      	b.n	c0d01a7a <io_exchange+0xe2>
c0d01a06:	2807      	cmp	r0, #7
c0d01a08:	d12d      	bne.n	c0d01a66 <io_exchange+0xce>
            goto break_send;

#ifdef HAVE_USB_APDU
          case APDU_USB_HID:
            // only send, don't perform synchronous reception of the next command (will be done later by the seproxyhal packet processing)
            io_usb_hid_exchange(io_usb_send_apdu_data, tx_len, NULL, IO_RETURN_AFTER_TX);
c0d01a0a:	4860      	ldr	r0, [pc, #384]	; (c0d01b8c <io_exchange+0x1f4>)
c0d01a0c:	4478      	add	r0, pc
c0d01a0e:	2200      	movs	r2, #0
c0d01a10:	2320      	movs	r3, #32
c0d01a12:	460f      	mov	r7, r1
c0d01a14:	4629      	mov	r1, r5
c0d01a16:	f7ff fc09 	bl	c0d0122c <io_usb_hid_exchange>
c0d01a1a:	4639      	mov	r1, r7
c0d01a1c:	e02d      	b.n	c0d01a7a <io_exchange+0xe2>
          // case to handle U2F channels. u2f apdu to be dispatched in the upper layers
          case APDU_U2F:
            // prepare reply, the remaining segments will be pumped during USB/BLE events handling while waiting for the next APDU

            // user presence + counter + rapdu + sw must fit the apdu buffer
            if (1+ 4+ tx_len +2 > sizeof(G_io_apdu_buffer)) {
c0d01a1e:	1de8      	adds	r0, r5, #7
c0d01a20:	9001      	str	r0, [sp, #4]
c0d01a22:	0840      	lsrs	r0, r0, #1
c0d01a24:	28a9      	cmp	r0, #169	; 0xa9
c0d01a26:	d300      	bcc.n	c0d01a2a <io_exchange+0x92>
c0d01a28:	e096      	b.n	c0d01b58 <io_exchange+0x1c0>
              THROW(INVALID_PARAMETER);
            }

            // u2F tunnel needs the status words to be included in the signature response BLOB, do it now.
            // always return 9000 in the signature to avoid error @ transport level in u2f layers. 
            G_io_apdu_buffer[tx_len] = 0x90; //G_io_apdu_buffer[tx_len-2];
c0d01a2a:	207c      	movs	r0, #124	; 0x7c
c0d01a2c:	43c0      	mvns	r0, r0
c0d01a2e:	300d      	adds	r0, #13
c0d01a30:	494e      	ldr	r1, [pc, #312]	; (c0d01b6c <io_exchange+0x1d4>)
c0d01a32:	5548      	strb	r0, [r1, r5]
c0d01a34:	1948      	adds	r0, r1, r5
c0d01a36:	2700      	movs	r7, #0
            G_io_apdu_buffer[tx_len+1] = 0x00; //G_io_apdu_buffer[tx_len-1];
c0d01a38:	7047      	strb	r7, [r0, #1]
            tx_len += 2;
            os_memmove(G_io_apdu_buffer+5, G_io_apdu_buffer, tx_len);
c0d01a3a:	9802      	ldr	r0, [sp, #8]
c0d01a3c:	1d00      	adds	r0, r0, #4

            // u2F tunnel needs the status words to be included in the signature response BLOB, do it now.
            // always return 9000 in the signature to avoid error @ transport level in u2f layers. 
            G_io_apdu_buffer[tx_len] = 0x90; //G_io_apdu_buffer[tx_len-2];
            G_io_apdu_buffer[tx_len+1] = 0x00; //G_io_apdu_buffer[tx_len-1];
            tx_len += 2;
c0d01a3e:	1caa      	adds	r2, r5, #2
            os_memmove(G_io_apdu_buffer+5, G_io_apdu_buffer, tx_len);
c0d01a40:	4002      	ands	r2, r0
c0d01a42:	1d48      	adds	r0, r1, #5
c0d01a44:	460d      	mov	r5, r1
c0d01a46:	f7ff fbd0 	bl	c0d011ea <os_memmove>
c0d01a4a:	2205      	movs	r2, #5
            // zeroize user presence and counter
            os_memset(G_io_apdu_buffer, 0, 5);
c0d01a4c:	4628      	mov	r0, r5
c0d01a4e:	4639      	mov	r1, r7
c0d01a50:	f7ff fbc2 	bl	c0d011d8 <os_memset>
            u2f_message_reply(&G_io_u2f, U2F_CMD_MSG, G_io_apdu_buffer, tx_len+5);
c0d01a54:	9801      	ldr	r0, [sp, #4]
c0d01a56:	b283      	uxth	r3, r0
c0d01a58:	4845      	ldr	r0, [pc, #276]	; (c0d01b70 <io_exchange+0x1d8>)
c0d01a5a:	2183      	movs	r1, #131	; 0x83
c0d01a5c:	462a      	mov	r2, r5
c0d01a5e:	f000 ff9f 	bl	c0d029a0 <u2f_message_reply>
c0d01a62:	4941      	ldr	r1, [pc, #260]	; (c0d01b68 <io_exchange+0x1d0>)
c0d01a64:	e009      	b.n	c0d01a7a <io_exchange+0xe2>
c0d01a66:	2800      	cmp	r0, #0
c0d01a68:	d073      	beq.n	c0d01b52 <io_exchange+0x1ba>
      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
          default: 
            // delegate to the hal in case of not generic transport mode (or asynch)
            if (io_exchange_al(channel, tx_len) == 0) {
c0d01a6a:	4620      	mov	r0, r4
c0d01a6c:	460f      	mov	r7, r1
c0d01a6e:	4629      	mov	r1, r5
c0d01a70:	f7fe fba8 	bl	c0d001c4 <io_exchange_al>
c0d01a74:	4639      	mov	r1, r7
c0d01a76:	2800      	cmp	r0, #0
c0d01a78:	d16b      	bne.n	c0d01b52 <io_exchange+0x1ba>
c0d01a7a:	2500      	movs	r5, #0
        }
        continue;

      break_send:
        // reset apdu state
        G_io_apdu_state = APDU_IDLE;
c0d01a7c:	700d      	strb	r5, [r1, #0]
        G_io_apdu_offset = 0;
c0d01a7e:	483e      	ldr	r0, [pc, #248]	; (c0d01b78 <io_exchange+0x1e0>)
c0d01a80:	8005      	strh	r5, [r0, #0]
        G_io_apdu_length = 0;
c0d01a82:	483e      	ldr	r0, [pc, #248]	; (c0d01b7c <io_exchange+0x1e4>)
c0d01a84:	8005      	strh	r5, [r0, #0]
        G_io_apdu_seq = 0;
c0d01a86:	483e      	ldr	r0, [pc, #248]	; (c0d01b80 <io_exchange+0x1e8>)
c0d01a88:	8005      	strh	r5, [r0, #0]
        G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d01a8a:	483e      	ldr	r0, [pc, #248]	; (c0d01b84 <io_exchange+0x1ec>)
c0d01a8c:	7005      	strb	r5, [r0, #0]

        // continue sending commands, don't issue status yet
        if (channel & IO_RETURN_AFTER_TX) {
c0d01a8e:	06a0      	lsls	r0, r4, #26
c0d01a90:	d48e      	bmi.n	c0d019b0 <io_exchange+0x18>
          return 0;
        }
        // acknowledge the write request (general status OK) and no more command to follow (wait until another APDU container is received to continue unwrapping)
        io_seproxyhal_general_status();
c0d01a92:	f7ff fc6b 	bl	c0d0136c <io_seproxyhal_general_status>
        break;
      }

      // perform reset after io exchange
      if (channel & IO_RESET_AFTER_REPLIED) {
c0d01a96:	0620      	lsls	r0, r4, #24
c0d01a98:	9f02      	ldr	r7, [sp, #8]
c0d01a9a:	d501      	bpl.n	c0d01aa0 <io_exchange+0x108>
        reset();
c0d01a9c:	f000 fabe 	bl	c0d0201c <reset>
      }
    }

    if (!(channel&IO_ASYNCH_REPLY)) {
c0d01aa0:	2e00      	cmp	r6, #0
c0d01aa2:	d10c      	bne.n	c0d01abe <io_exchange+0x126>
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
c0d01aa4:	0660      	lsls	r0, r4, #25
c0d01aa6:	d450      	bmi.n	c0d01b4a <io_exchange+0x1b2>
        // return apdu data - header
        return G_io_apdu_length-5;
      }

      // reply has ended, proceed to next apdu reception (reset status only after asynch reply)
      G_io_apdu_state = APDU_IDLE;
c0d01aa8:	482f      	ldr	r0, [pc, #188]	; (c0d01b68 <io_exchange+0x1d0>)
c0d01aaa:	2100      	movs	r1, #0
c0d01aac:	7001      	strb	r1, [r0, #0]
      G_io_apdu_offset = 0;
c0d01aae:	4832      	ldr	r0, [pc, #200]	; (c0d01b78 <io_exchange+0x1e0>)
c0d01ab0:	8001      	strh	r1, [r0, #0]
      G_io_apdu_length = 0;
c0d01ab2:	4832      	ldr	r0, [pc, #200]	; (c0d01b7c <io_exchange+0x1e4>)
c0d01ab4:	8001      	strh	r1, [r0, #0]
      G_io_apdu_seq = 0;
c0d01ab6:	4832      	ldr	r0, [pc, #200]	; (c0d01b80 <io_exchange+0x1e8>)
c0d01ab8:	8001      	strh	r1, [r0, #0]
      G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d01aba:	4832      	ldr	r0, [pc, #200]	; (c0d01b84 <io_exchange+0x1ec>)
c0d01abc:	7001      	strb	r1, [r0, #0]
c0d01abe:	4c2d      	ldr	r4, [pc, #180]	; (c0d01b74 <io_exchange+0x1dc>)
c0d01ac0:	4e2e      	ldr	r6, [pc, #184]	; (c0d01b7c <io_exchange+0x1e4>)
c0d01ac2:	4f2f      	ldr	r7, [pc, #188]	; (c0d01b80 <io_exchange+0x1e8>)
c0d01ac4:	e002      	b.n	c0d01acc <io_exchange+0x134>
          break;
#endif // HAVE_IO_USB

        default:
          // tell the application that a non-apdu packet has been received
          io_event(CHANNEL_SPI);
c0d01ac6:	2002      	movs	r0, #2
c0d01ac8:	f7fe fba8 	bl	c0d0021c <io_event>

    // ensure ready to receive an event (after an apdu processing with asynch flag, it may occur if the channel is not correctly managed)

    // until a new whole CAPDU is received
    for (;;) {
      if (!io_seproxyhal_spi_is_status_sent()) {
c0d01acc:	f000 fbf2 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d01ad0:	2800      	cmp	r0, #0
c0d01ad2:	d101      	bne.n	c0d01ad8 <io_exchange+0x140>
        io_seproxyhal_general_status();
c0d01ad4:	f7ff fc4a 	bl	c0d0136c <io_seproxyhal_general_status>
      }

      // wait until a SPI packet is available
      // NOTE: on ST31, dual wait ISO & RF (ISO instead of SPI)
      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d01ad8:	2180      	movs	r1, #128	; 0x80
c0d01ada:	2500      	movs	r5, #0
c0d01adc:	4620      	mov	r0, r4
c0d01ade:	462a      	mov	r2, r5
c0d01ae0:	f000 fbfe 	bl	c0d022e0 <io_seproxyhal_spi_recv>

      // can't process split TLV, continue
      if (rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
c0d01ae4:	1ec1      	subs	r1, r0, #3
c0d01ae6:	78a2      	ldrb	r2, [r4, #2]
c0d01ae8:	7863      	ldrb	r3, [r4, #1]
c0d01aea:	021b      	lsls	r3, r3, #8
c0d01aec:	4313      	orrs	r3, r2
c0d01aee:	4299      	cmp	r1, r3
c0d01af0:	d115      	bne.n	c0d01b1e <io_exchange+0x186>
      send_last_command:
        continue;
      }

      // if an apdu is already ongoing, then discard packet as a new packet
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
c0d01af2:	4924      	ldr	r1, [pc, #144]	; (c0d01b84 <io_exchange+0x1ec>)
c0d01af4:	7809      	ldrb	r1, [r1, #0]
c0d01af6:	2900      	cmp	r1, #0
c0d01af8:	d002      	beq.n	c0d01b00 <io_exchange+0x168>
        io_seproxyhal_handle_event();
c0d01afa:	f7ff fcf1 	bl	c0d014e0 <io_seproxyhal_handle_event>
c0d01afe:	e7e5      	b.n	c0d01acc <io_exchange+0x134>
        continue;
      }

      // depending on received TAG
      switch(G_io_seproxyhal_spi_buffer[0]) {
c0d01b00:	7821      	ldrb	r1, [r4, #0]
c0d01b02:	290f      	cmp	r1, #15
c0d01b04:	d006      	beq.n	c0d01b14 <io_exchange+0x17c>
c0d01b06:	2910      	cmp	r1, #16
c0d01b08:	d011      	beq.n	c0d01b2e <io_exchange+0x196>
c0d01b0a:	2916      	cmp	r1, #22
c0d01b0c:	d1db      	bne.n	c0d01ac6 <io_exchange+0x12e>

        case SEPROXYHAL_TAG_CAPDU_EVENT:
          io_seproxyhal_handle_capdu_event();
c0d01b0e:	f7ff fd33 	bl	c0d01578 <io_seproxyhal_handle_capdu_event>
c0d01b12:	e011      	b.n	c0d01b38 <io_exchange+0x1a0>
          goto send_last_command;
#endif // HAVE_BLE

#ifdef HAVE_IO_USB
        case SEPROXYHAL_TAG_USB_EVENT:
          if (rx_len != 3+1) {
c0d01b14:	2804      	cmp	r0, #4
c0d01b16:	d102      	bne.n	c0d01b1e <io_exchange+0x186>
            // invalid length, not processable
            goto invalid_apdu_packet;
          }
          io_seproxyhal_handle_usb_event();
c0d01b18:	f7ff fc3c 	bl	c0d01394 <io_seproxyhal_handle_usb_event>
c0d01b1c:	e7d6      	b.n	c0d01acc <io_exchange+0x134>
c0d01b1e:	2000      	movs	r0, #0

      // can't process split TLV, continue
      if (rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
        LOG("invalid TLV format\n");
      invalid_apdu_packet:
        G_io_apdu_state = APDU_IDLE;
c0d01b20:	4911      	ldr	r1, [pc, #68]	; (c0d01b68 <io_exchange+0x1d0>)
c0d01b22:	7008      	strb	r0, [r1, #0]
        G_io_apdu_offset = 0;
c0d01b24:	4914      	ldr	r1, [pc, #80]	; (c0d01b78 <io_exchange+0x1e0>)
c0d01b26:	8008      	strh	r0, [r1, #0]
        G_io_apdu_length = 0;
c0d01b28:	8030      	strh	r0, [r6, #0]
        G_io_apdu_seq = 0;
c0d01b2a:	8038      	strh	r0, [r7, #0]
c0d01b2c:	e7ce      	b.n	c0d01acc <io_exchange+0x134>

          // no state change, we're not dealing with an apdu yet
          goto send_last_command;

        case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
          if (rx_len < 3+3) {
c0d01b2e:	2806      	cmp	r0, #6
c0d01b30:	d200      	bcs.n	c0d01b34 <io_exchange+0x19c>
c0d01b32:	e73d      	b.n	c0d019b0 <io_exchange+0x18>
            // error !
            return 0;
          }
          io_seproxyhal_handle_usb_ep_xfer_event();
c0d01b34:	f7ff fc64 	bl	c0d01400 <io_seproxyhal_handle_usb_ep_xfer_event>
c0d01b38:	8830      	ldrh	r0, [r6, #0]
c0d01b3a:	2800      	cmp	r0, #0
c0d01b3c:	d0c6      	beq.n	c0d01acc <io_exchange+0x134>
c0d01b3e:	4812      	ldr	r0, [pc, #72]	; (c0d01b88 <io_exchange+0x1f0>)
c0d01b40:	6800      	ldr	r0, [r0, #0]
c0d01b42:	4908      	ldr	r1, [pc, #32]	; (c0d01b64 <io_exchange+0x1cc>)
c0d01b44:	6008      	str	r0, [r1, #0]
c0d01b46:	8835      	ldrh	r5, [r6, #0]
c0d01b48:	e732      	b.n	c0d019b0 <io_exchange+0x18>
    if (!(channel&IO_ASYNCH_REPLY)) {
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
        // return apdu data - header
        return G_io_apdu_length-5;
c0d01b4a:	480c      	ldr	r0, [pc, #48]	; (c0d01b7c <io_exchange+0x1e4>)
c0d01b4c:	8800      	ldrh	r0, [r0, #0]
c0d01b4e:	19c5      	adds	r5, r0, r7
c0d01b50:	e72e      	b.n	c0d019b0 <io_exchange+0x18>
            if (io_exchange_al(channel, tx_len) == 0) {
              goto break_send;
            }
          case APDU_IDLE:
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
c0d01b52:	2009      	movs	r0, #9
c0d01b54:	f7ff fbfd 	bl	c0d01352 <os_longjmp>
c0d01b58:	2002      	movs	r0, #2
c0d01b5a:	f7ff fbfa 	bl	c0d01352 <os_longjmp>
c0d01b5e:	46c0      	nop			; (mov r8, r8)
c0d01b60:	0000fffb 	.word	0x0000fffb
c0d01b64:	20001a58 	.word	0x20001a58
c0d01b68:	20001a64 	.word	0x20001a64
c0d01b6c:	200018f8 	.word	0x200018f8
c0d01b70:	20001a78 	.word	0x20001a78
c0d01b74:	20001800 	.word	0x20001800
c0d01b78:	20001a68 	.word	0x20001a68
c0d01b7c:	20001a66 	.word	0x20001a66
c0d01b80:	20001a6a 	.word	0x20001a6a
c0d01b84:	20001a5c 	.word	0x20001a5c
c0d01b88:	20001a54 	.word	0x20001a54
c0d01b8c:	fffffb59 	.word	0xfffffb59

c0d01b90 <ux_check_status_default>:
}

void ux_check_status_default(unsigned int status) {
  // nothing to be done here by default.
  UNUSED(status);
}
c0d01b90:	4770      	bx	lr
	...

c0d01b94 <snprintf>:
#endif // HAVE_PRINTF

#ifdef HAVE_SPRINTF
//unsigned int snprintf(unsigned char * str, unsigned int str_size, const char* format, ...)
int snprintf(char * str, size_t str_size, const char * format, ...)
 {
c0d01b94:	b081      	sub	sp, #4
c0d01b96:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01b98:	b090      	sub	sp, #64	; 0x40
c0d01b9a:	4616      	mov	r6, r2
c0d01b9c:	460c      	mov	r4, r1
c0d01b9e:	900a      	str	r0, [sp, #40]	; 0x28
c0d01ba0:	9315      	str	r3, [sp, #84]	; 0x54
    char cStrlenSet;
    
    //
    // Check the arguments.
    //
    if(format == 0 || str == 0 ||str_size < 2) {
c0d01ba2:	2c02      	cmp	r4, #2
c0d01ba4:	d200      	bcs.n	c0d01ba8 <snprintf+0x14>
c0d01ba6:	e1f0      	b.n	c0d01f8a <snprintf+0x3f6>
c0d01ba8:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01baa:	2800      	cmp	r0, #0
c0d01bac:	d100      	bne.n	c0d01bb0 <snprintf+0x1c>
c0d01bae:	e1ec      	b.n	c0d01f8a <snprintf+0x3f6>
c0d01bb0:	2e00      	cmp	r6, #0
c0d01bb2:	d100      	bne.n	c0d01bb6 <snprintf+0x22>
c0d01bb4:	e1e9      	b.n	c0d01f8a <snprintf+0x3f6>
c0d01bb6:	2100      	movs	r1, #0
      return 0;
    }

    // ensure terminating string with a \0
    os_memset(str, 0, str_size);
c0d01bb8:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01bba:	9107      	str	r1, [sp, #28]
c0d01bbc:	4622      	mov	r2, r4
c0d01bbe:	f7ff fb0b 	bl	c0d011d8 <os_memset>
c0d01bc2:	a815      	add	r0, sp, #84	; 0x54


    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0d01bc4:	900b      	str	r0, [sp, #44]	; 0x2c

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0d01bc6:	7830      	ldrb	r0, [r6, #0]
c0d01bc8:	2800      	cmp	r0, #0
c0d01bca:	d100      	bne.n	c0d01bce <snprintf+0x3a>
c0d01bcc:	e1dd      	b.n	c0d01f8a <snprintf+0x3f6>
c0d01bce:	9907      	ldr	r1, [sp, #28]
c0d01bd0:	43c9      	mvns	r1, r1
      return 0;
    }

    // ensure terminating string with a \0
    os_memset(str, 0, str_size);
    str_size--;
c0d01bd2:	1e65      	subs	r5, r4, #1
c0d01bd4:	9105      	str	r1, [sp, #20]
c0d01bd6:	e1bd      	b.n	c0d01f54 <snprintf+0x3c0>
        }

        //
        // Skip the portion of the string that was written.
        //
        format += ulIdx;
c0d01bd8:	1930      	adds	r0, r6, r4

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0d01bda:	5d31      	ldrb	r1, [r6, r4]
c0d01bdc:	2925      	cmp	r1, #37	; 0x25
c0d01bde:	d10b      	bne.n	c0d01bf8 <snprintf+0x64>
c0d01be0:	9303      	str	r3, [sp, #12]
c0d01be2:	9202      	str	r2, [sp, #8]
        {
            //
            // Skip the %.
            //
            format++;
c0d01be4:	1c43      	adds	r3, r0, #1
c0d01be6:	2000      	movs	r0, #0
c0d01be8:	2120      	movs	r1, #32
c0d01bea:	9108      	str	r1, [sp, #32]
c0d01bec:	210a      	movs	r1, #10
c0d01bee:	9101      	str	r1, [sp, #4]
c0d01bf0:	9000      	str	r0, [sp, #0]
c0d01bf2:	9004      	str	r0, [sp, #16]
c0d01bf4:	9009      	str	r0, [sp, #36]	; 0x24
c0d01bf6:	e056      	b.n	c0d01ca6 <snprintf+0x112>
c0d01bf8:	4606      	mov	r6, r0
c0d01bfa:	920a      	str	r2, [sp, #40]	; 0x28
c0d01bfc:	e11e      	b.n	c0d01e3c <snprintf+0x2a8>
c0d01bfe:	4633      	mov	r3, r6
c0d01c00:	4608      	mov	r0, r1
c0d01c02:	e04b      	b.n	c0d01c9c <snprintf+0x108>
c0d01c04:	2b47      	cmp	r3, #71	; 0x47
c0d01c06:	dc13      	bgt.n	c0d01c30 <snprintf+0x9c>
c0d01c08:	4619      	mov	r1, r3
c0d01c0a:	3930      	subs	r1, #48	; 0x30
c0d01c0c:	290a      	cmp	r1, #10
c0d01c0e:	d234      	bcs.n	c0d01c7a <snprintf+0xe6>
                {
                    //
                    // If this is a zero, and it is the first digit, then the
                    // fill character is a zero instead of a space.
                    //
                    if((format[-1] == '0') && (ulCount == 0))
c0d01c10:	2b30      	cmp	r3, #48	; 0x30
c0d01c12:	9908      	ldr	r1, [sp, #32]
c0d01c14:	d100      	bne.n	c0d01c18 <snprintf+0x84>
c0d01c16:	4619      	mov	r1, r3
c0d01c18:	9d09      	ldr	r5, [sp, #36]	; 0x24
c0d01c1a:	2d00      	cmp	r5, #0
c0d01c1c:	d000      	beq.n	c0d01c20 <snprintf+0x8c>
c0d01c1e:	9908      	ldr	r1, [sp, #32]
                    }

                    //
                    // Update the digit count.
                    //
                    ulCount *= 10;
c0d01c20:	220a      	movs	r2, #10
c0d01c22:	436a      	muls	r2, r5
                    ulCount += format[-1] - '0';
c0d01c24:	18d2      	adds	r2, r2, r3
c0d01c26:	3a30      	subs	r2, #48	; 0x30
c0d01c28:	9209      	str	r2, [sp, #36]	; 0x24
c0d01c2a:	4633      	mov	r3, r6
c0d01c2c:	9108      	str	r1, [sp, #32]
c0d01c2e:	e03a      	b.n	c0d01ca6 <snprintf+0x112>
c0d01c30:	2b67      	cmp	r3, #103	; 0x67
c0d01c32:	dd04      	ble.n	c0d01c3e <snprintf+0xaa>
c0d01c34:	2b72      	cmp	r3, #114	; 0x72
c0d01c36:	dd09      	ble.n	c0d01c4c <snprintf+0xb8>
c0d01c38:	2b73      	cmp	r3, #115	; 0x73
c0d01c3a:	d146      	bne.n	c0d01cca <snprintf+0x136>
c0d01c3c:	e00a      	b.n	c0d01c54 <snprintf+0xc0>
c0d01c3e:	2b62      	cmp	r3, #98	; 0x62
c0d01c40:	dc48      	bgt.n	c0d01cd4 <snprintf+0x140>
c0d01c42:	2b48      	cmp	r3, #72	; 0x48
c0d01c44:	d155      	bne.n	c0d01cf2 <snprintf+0x15e>
c0d01c46:	2201      	movs	r2, #1
c0d01c48:	9204      	str	r2, [sp, #16]
c0d01c4a:	e001      	b.n	c0d01c50 <snprintf+0xbc>
c0d01c4c:	2b68      	cmp	r3, #104	; 0x68
c0d01c4e:	d156      	bne.n	c0d01cfe <snprintf+0x16a>
c0d01c50:	2210      	movs	r2, #16
c0d01c52:	9201      	str	r2, [sp, #4]
                case_s:
                {
                    //
                    // Get the string pointer from the varargs.
                    //
                    pcStr = va_arg(vaArgP, char *);
c0d01c54:	9a0b      	ldr	r2, [sp, #44]	; 0x2c
c0d01c56:	1d13      	adds	r3, r2, #4
c0d01c58:	930b      	str	r3, [sp, #44]	; 0x2c
c0d01c5a:	2303      	movs	r3, #3
c0d01c5c:	4018      	ands	r0, r3
c0d01c5e:	1c4d      	adds	r5, r1, #1
c0d01c60:	6811      	ldr	r1, [r2, #0]

                    //
                    // Determine the length of the string. (if not specified using .*)
                    //
                    switch(cStrlenSet) {
c0d01c62:	2801      	cmp	r0, #1
c0d01c64:	d100      	bne.n	c0d01c68 <snprintf+0xd4>
c0d01c66:	e0ce      	b.n	c0d01e06 <snprintf+0x272>
c0d01c68:	2802      	cmp	r0, #2
c0d01c6a:	d100      	bne.n	c0d01c6e <snprintf+0xda>
c0d01c6c:	e0d0      	b.n	c0d01e10 <snprintf+0x27c>
c0d01c6e:	2803      	cmp	r0, #3
c0d01c70:	4633      	mov	r3, r6
c0d01c72:	4628      	mov	r0, r5
c0d01c74:	9d06      	ldr	r5, [sp, #24]
c0d01c76:	d016      	beq.n	c0d01ca6 <snprintf+0x112>
c0d01c78:	e0e7      	b.n	c0d01e4a <snprintf+0x2b6>
c0d01c7a:	2b2e      	cmp	r3, #46	; 0x2e
c0d01c7c:	d000      	beq.n	c0d01c80 <snprintf+0xec>
c0d01c7e:	e0ca      	b.n	c0d01e16 <snprintf+0x282>
                // special %.*H or %.*h format to print a given length of hex digits (case: H UPPER, h lower)
                //
                case '.':
                {
                  // ensure next char is '*' and next one is 's'/'h'/'H'
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0d01c80:	7830      	ldrb	r0, [r6, #0]
c0d01c82:	282a      	cmp	r0, #42	; 0x2a
c0d01c84:	d000      	beq.n	c0d01c88 <snprintf+0xf4>
c0d01c86:	e0c6      	b.n	c0d01e16 <snprintf+0x282>
c0d01c88:	7871      	ldrb	r1, [r6, #1]
c0d01c8a:	1c73      	adds	r3, r6, #1
c0d01c8c:	2001      	movs	r0, #1
c0d01c8e:	2948      	cmp	r1, #72	; 0x48
c0d01c90:	d004      	beq.n	c0d01c9c <snprintf+0x108>
c0d01c92:	2968      	cmp	r1, #104	; 0x68
c0d01c94:	d002      	beq.n	c0d01c9c <snprintf+0x108>
c0d01c96:	2973      	cmp	r1, #115	; 0x73
c0d01c98:	d000      	beq.n	c0d01c9c <snprintf+0x108>
c0d01c9a:	e0bc      	b.n	c0d01e16 <snprintf+0x282>
c0d01c9c:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d01c9e:	1d0a      	adds	r2, r1, #4
c0d01ca0:	920b      	str	r2, [sp, #44]	; 0x2c
c0d01ca2:	6809      	ldr	r1, [r1, #0]
int snprintf(char * str, size_t str_size, const char * format, ...)
 {
    unsigned int ulIdx, ulValue, ulPos, ulCount, ulBase, ulNeg, ulStrlen, ulCap;
    char *pcStr, pcBuf[16], cFill;
    va_list vaArgP;
    char cStrlenSet;
c0d01ca4:	9100      	str	r1, [sp, #0]
c0d01ca6:	2102      	movs	r1, #2
c0d01ca8:	461e      	mov	r6, r3
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0d01caa:	7833      	ldrb	r3, [r6, #0]
c0d01cac:	1c76      	adds	r6, r6, #1
c0d01cae:	2200      	movs	r2, #0
c0d01cb0:	2b2d      	cmp	r3, #45	; 0x2d
c0d01cb2:	dca7      	bgt.n	c0d01c04 <snprintf+0x70>
c0d01cb4:	4610      	mov	r0, r2
c0d01cb6:	d0f8      	beq.n	c0d01caa <snprintf+0x116>
c0d01cb8:	2b25      	cmp	r3, #37	; 0x25
c0d01cba:	d02a      	beq.n	c0d01d12 <snprintf+0x17e>
c0d01cbc:	2b2a      	cmp	r3, #42	; 0x2a
c0d01cbe:	d000      	beq.n	c0d01cc2 <snprintf+0x12e>
c0d01cc0:	e0a9      	b.n	c0d01e16 <snprintf+0x282>
                  goto error;
                }
                
                case '*':
                {
                  if (*format == 's' ) {                    
c0d01cc2:	7830      	ldrb	r0, [r6, #0]
c0d01cc4:	2873      	cmp	r0, #115	; 0x73
c0d01cc6:	d09a      	beq.n	c0d01bfe <snprintf+0x6a>
c0d01cc8:	e0a5      	b.n	c0d01e16 <snprintf+0x282>
c0d01cca:	2b75      	cmp	r3, #117	; 0x75
c0d01ccc:	d023      	beq.n	c0d01d16 <snprintf+0x182>
c0d01cce:	2b78      	cmp	r3, #120	; 0x78
c0d01cd0:	d018      	beq.n	c0d01d04 <snprintf+0x170>
c0d01cd2:	e0a0      	b.n	c0d01e16 <snprintf+0x282>
c0d01cd4:	2b63      	cmp	r3, #99	; 0x63
c0d01cd6:	d100      	bne.n	c0d01cda <snprintf+0x146>
c0d01cd8:	e08b      	b.n	c0d01df2 <snprintf+0x25e>
c0d01cda:	2b64      	cmp	r3, #100	; 0x64
c0d01cdc:	d000      	beq.n	c0d01ce0 <snprintf+0x14c>
c0d01cde:	e09a      	b.n	c0d01e16 <snprintf+0x282>
                case 'd':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01ce0:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01ce2:	1d01      	adds	r1, r0, #4
c0d01ce4:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01ce6:	6800      	ldr	r0, [r0, #0]
c0d01ce8:	17c1      	asrs	r1, r0, #31
c0d01cea:	1842      	adds	r2, r0, r1
c0d01cec:	404a      	eors	r2, r1

                    //
                    // If the value is negative, make it positive and indicate
                    // that a minus sign is needed.
                    //
                    if((long)ulValue < 0)
c0d01cee:	0fc0      	lsrs	r0, r0, #31
c0d01cf0:	e016      	b.n	c0d01d20 <snprintf+0x18c>
c0d01cf2:	2b58      	cmp	r3, #88	; 0x58
c0d01cf4:	d000      	beq.n	c0d01cf8 <snprintf+0x164>
c0d01cf6:	e08e      	b.n	c0d01e16 <snprintf+0x282>
c0d01cf8:	2001      	movs	r0, #1

#ifdef HAVE_SPRINTF
//unsigned int snprintf(unsigned char * str, unsigned int str_size, const char* format, ...)
int snprintf(char * str, size_t str_size, const char * format, ...)
 {
    unsigned int ulIdx, ulValue, ulPos, ulCount, ulBase, ulNeg, ulStrlen, ulCap;
c0d01cfa:	9004      	str	r0, [sp, #16]
c0d01cfc:	e002      	b.n	c0d01d04 <snprintf+0x170>
c0d01cfe:	2b70      	cmp	r3, #112	; 0x70
c0d01d00:	d000      	beq.n	c0d01d04 <snprintf+0x170>
c0d01d02:	e088      	b.n	c0d01e16 <snprintf+0x282>
                case 'p':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01d04:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01d06:	1d01      	adds	r1, r0, #4
c0d01d08:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01d0a:	6802      	ldr	r2, [r0, #0]
c0d01d0c:	2000      	movs	r0, #0
c0d01d0e:	2510      	movs	r5, #16
c0d01d10:	e007      	b.n	c0d01d22 <snprintf+0x18e>
                case '%':
                {
                    //
                    // Simply write a single %.
                    //
                    str[0] = '%';
c0d01d12:	2025      	movs	r0, #37	; 0x25
c0d01d14:	e071      	b.n	c0d01dfa <snprintf+0x266>
                case 'u':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01d16:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01d18:	1d01      	adds	r1, r0, #4
c0d01d1a:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01d1c:	6802      	ldr	r2, [r0, #0]
c0d01d1e:	2000      	movs	r0, #0
c0d01d20:	250a      	movs	r5, #10
c0d01d22:	9006      	str	r0, [sp, #24]
c0d01d24:	2701      	movs	r7, #1
c0d01d26:	920a      	str	r2, [sp, #40]	; 0x28
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
                        (((ulIdx * ulBase) <= ulValue) &&
c0d01d28:	4295      	cmp	r5, r2
c0d01d2a:	d812      	bhi.n	c0d01d52 <snprintf+0x1be>
c0d01d2c:	2401      	movs	r4, #1
c0d01d2e:	4628      	mov	r0, r5
c0d01d30:	4607      	mov	r7, r0
                         (((ulIdx * ulBase) / ulBase) == ulIdx));
c0d01d32:	4629      	mov	r1, r5
c0d01d34:	f002 fc10 	bl	c0d04558 <__aeabi_uidiv>
                    //
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
c0d01d38:	42a0      	cmp	r0, r4
c0d01d3a:	d109      	bne.n	c0d01d50 <snprintf+0x1bc>
                        (((ulIdx * ulBase) <= ulValue) &&
c0d01d3c:	4628      	mov	r0, r5
c0d01d3e:	4378      	muls	r0, r7
                         (((ulIdx * ulBase) / ulBase) == ulIdx));
                        ulIdx *= ulBase, ulCount--)
c0d01d40:	9909      	ldr	r1, [sp, #36]	; 0x24
c0d01d42:	1e49      	subs	r1, r1, #1
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
                        (((ulIdx * ulBase) <= ulValue) &&
c0d01d44:	9109      	str	r1, [sp, #36]	; 0x24
c0d01d46:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d01d48:	4288      	cmp	r0, r1
c0d01d4a:	463c      	mov	r4, r7
c0d01d4c:	d9f0      	bls.n	c0d01d30 <snprintf+0x19c>
c0d01d4e:	e000      	b.n	c0d01d52 <snprintf+0x1be>
c0d01d50:	4627      	mov	r7, r4

                    //
                    // If the value is negative, reduce the count of padding
                    // characters needed.
                    //
                    if(ulNeg)
c0d01d52:	2400      	movs	r4, #0
c0d01d54:	43e1      	mvns	r1, r4
c0d01d56:	9b06      	ldr	r3, [sp, #24]
c0d01d58:	2b00      	cmp	r3, #0
c0d01d5a:	d100      	bne.n	c0d01d5e <snprintf+0x1ca>
c0d01d5c:	4619      	mov	r1, r3
c0d01d5e:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01d60:	9101      	str	r1, [sp, #4]
c0d01d62:	1840      	adds	r0, r0, r1

                    //
                    // If the value is negative and the value is padded with
                    // zeros, then place the minus sign before the padding.
                    //
                    if(ulNeg && (cFill == '0'))
c0d01d64:	9908      	ldr	r1, [sp, #32]
c0d01d66:	b2ca      	uxtb	r2, r1
c0d01d68:	2a30      	cmp	r2, #48	; 0x30
c0d01d6a:	d106      	bne.n	c0d01d7a <snprintf+0x1e6>
c0d01d6c:	2b00      	cmp	r3, #0
c0d01d6e:	d004      	beq.n	c0d01d7a <snprintf+0x1e6>
c0d01d70:	a90c      	add	r1, sp, #48	; 0x30
                    {
                        //
                        // Place the minus sign in the output buffer.
                        //
                        pcBuf[ulPos++] = '-';
c0d01d72:	232d      	movs	r3, #45	; 0x2d
c0d01d74:	700b      	strb	r3, [r1, #0]
c0d01d76:	2300      	movs	r3, #0
c0d01d78:	2401      	movs	r4, #1

                    //
                    // Provide additional padding at the beginning of the
                    // string conversion if needed.
                    //
                    if((ulCount > 1) && (ulCount < 16))
c0d01d7a:	1e81      	subs	r1, r0, #2
c0d01d7c:	290d      	cmp	r1, #13
c0d01d7e:	d80c      	bhi.n	c0d01d9a <snprintf+0x206>
c0d01d80:	1e41      	subs	r1, r0, #1
c0d01d82:	d00a      	beq.n	c0d01d9a <snprintf+0x206>
c0d01d84:	a80c      	add	r0, sp, #48	; 0x30
                    {
                        for(ulCount--; ulCount; ulCount--)
                        {
                            pcBuf[ulPos++] = cFill;
c0d01d86:	4320      	orrs	r0, r4
c0d01d88:	9306      	str	r3, [sp, #24]
c0d01d8a:	f002 fd65 	bl	c0d04858 <__aeabi_memset>
c0d01d8e:	9b06      	ldr	r3, [sp, #24]
c0d01d90:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01d92:	1900      	adds	r0, r0, r4
c0d01d94:	9901      	ldr	r1, [sp, #4]
c0d01d96:	1840      	adds	r0, r0, r1
c0d01d98:	1e44      	subs	r4, r0, #1

                    //
                    // If the value is negative, then place the minus sign
                    // before the number.
                    //
                    if(ulNeg)
c0d01d9a:	2b00      	cmp	r3, #0
c0d01d9c:	d003      	beq.n	c0d01da6 <snprintf+0x212>
c0d01d9e:	a80c      	add	r0, sp, #48	; 0x30
                    {
                        //
                        // Place the minus sign in the output buffer.
                        //
                        pcBuf[ulPos++] = '-';
c0d01da0:	212d      	movs	r1, #45	; 0x2d
c0d01da2:	5501      	strb	r1, [r0, r4]
c0d01da4:	1c64      	adds	r4, r4, #1
c0d01da6:	9804      	ldr	r0, [sp, #16]
                    }

                    //
                    // Convert the value into a string.
                    //
                    for(; ulIdx; ulIdx /= ulBase)
c0d01da8:	2f00      	cmp	r7, #0
c0d01daa:	d018      	beq.n	c0d01dde <snprintf+0x24a>
c0d01dac:	2800      	cmp	r0, #0
c0d01dae:	d001      	beq.n	c0d01db4 <snprintf+0x220>
c0d01db0:	a079      	add	r0, pc, #484	; (adr r0, c0d01f98 <g_pcHex_cap>)
c0d01db2:	e000      	b.n	c0d01db6 <snprintf+0x222>
c0d01db4:	a07c      	add	r0, pc, #496	; (adr r0, c0d01fa8 <g_pcHex>)
c0d01db6:	9009      	str	r0, [sp, #36]	; 0x24
c0d01db8:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01dba:	4639      	mov	r1, r7
c0d01dbc:	f002 fbcc 	bl	c0d04558 <__aeabi_uidiv>
c0d01dc0:	4629      	mov	r1, r5
c0d01dc2:	f002 fc4f 	bl	c0d04664 <__aeabi_uidivmod>
c0d01dc6:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01dc8:	5c40      	ldrb	r0, [r0, r1]
c0d01dca:	a90c      	add	r1, sp, #48	; 0x30
c0d01dcc:	5508      	strb	r0, [r1, r4]
c0d01dce:	4638      	mov	r0, r7
c0d01dd0:	4629      	mov	r1, r5
c0d01dd2:	f002 fbc1 	bl	c0d04558 <__aeabi_uidiv>
c0d01dd6:	1c64      	adds	r4, r4, #1
c0d01dd8:	42bd      	cmp	r5, r7
c0d01dda:	4607      	mov	r7, r0
c0d01ddc:	d9ec      	bls.n	c0d01db8 <snprintf+0x224>
c0d01dde:	9b03      	ldr	r3, [sp, #12]
                    }

                    //
                    // Write the string.
                    //
                    ulPos = MIN(ulPos, str_size);
c0d01de0:	429c      	cmp	r4, r3
c0d01de2:	d300      	bcc.n	c0d01de6 <snprintf+0x252>
c0d01de4:	461c      	mov	r4, r3
c0d01de6:	a90c      	add	r1, sp, #48	; 0x30
c0d01de8:	9d02      	ldr	r5, [sp, #8]
                    os_memmove(str, pcBuf, ulPos);
c0d01dea:	4628      	mov	r0, r5
c0d01dec:	4622      	mov	r2, r4
c0d01dee:	461f      	mov	r7, r3
c0d01df0:	e01b      	b.n	c0d01e2a <snprintf+0x296>
                case 'c':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01df2:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01df4:	1d01      	adds	r1, r0, #4
c0d01df6:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01df8:	6800      	ldr	r0, [r0, #0]
c0d01dfa:	9902      	ldr	r1, [sp, #8]
c0d01dfc:	7008      	strb	r0, [r1, #0]
c0d01dfe:	9803      	ldr	r0, [sp, #12]
c0d01e00:	1e40      	subs	r0, r0, #1
c0d01e02:	1c49      	adds	r1, r1, #1
c0d01e04:	e015      	b.n	c0d01e32 <snprintf+0x29e>
c0d01e06:	9c00      	ldr	r4, [sp, #0]
c0d01e08:	9a05      	ldr	r2, [sp, #20]
c0d01e0a:	9b03      	ldr	r3, [sp, #12]
c0d01e0c:	9d06      	ldr	r5, [sp, #24]
c0d01e0e:	e024      	b.n	c0d01e5a <snprintf+0x2c6>
                        break;
                        
                      // printout prepad
                      case 2:
                        // if string is empty, then, ' ' padding
                        if (pcStr[0] == '\0') {
c0d01e10:	7808      	ldrb	r0, [r1, #0]
c0d01e12:	2800      	cmp	r0, #0
c0d01e14:	d075      	beq.n	c0d01f02 <snprintf+0x36e>
                default:
                {
                    //
                    // Indicate an error.
                    //
                    ulPos = MIN(strlen("ERROR"), str_size);
c0d01e16:	2005      	movs	r0, #5
c0d01e18:	9f03      	ldr	r7, [sp, #12]
c0d01e1a:	2f05      	cmp	r7, #5
c0d01e1c:	463c      	mov	r4, r7
c0d01e1e:	d300      	bcc.n	c0d01e22 <snprintf+0x28e>
c0d01e20:	4604      	mov	r4, r0
c0d01e22:	9d02      	ldr	r5, [sp, #8]
                    os_memmove(str, "ERROR", ulPos);
c0d01e24:	4628      	mov	r0, r5
c0d01e26:	a164      	add	r1, pc, #400	; (adr r1, c0d01fb8 <g_pcHex+0x10>)
c0d01e28:	4622      	mov	r2, r4
c0d01e2a:	f7ff f9de 	bl	c0d011ea <os_memmove>
c0d01e2e:	1b38      	subs	r0, r7, r4
c0d01e30:	1929      	adds	r1, r5, r4
c0d01e32:	910a      	str	r1, [sp, #40]	; 0x28
c0d01e34:	4603      	mov	r3, r0
c0d01e36:	2800      	cmp	r0, #0
c0d01e38:	d100      	bne.n	c0d01e3c <snprintf+0x2a8>
c0d01e3a:	e0a6      	b.n	c0d01f8a <snprintf+0x3f6>
    va_start(vaArgP, format);

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0d01e3c:	7830      	ldrb	r0, [r6, #0]
c0d01e3e:	2800      	cmp	r0, #0
c0d01e40:	9905      	ldr	r1, [sp, #20]
c0d01e42:	461d      	mov	r5, r3
c0d01e44:	d000      	beq.n	c0d01e48 <snprintf+0x2b4>
c0d01e46:	e085      	b.n	c0d01f54 <snprintf+0x3c0>
c0d01e48:	e09f      	b.n	c0d01f8a <snprintf+0x3f6>
c0d01e4a:	9a05      	ldr	r2, [sp, #20]
c0d01e4c:	4614      	mov	r4, r2
c0d01e4e:	9b03      	ldr	r3, [sp, #12]
                    // Determine the length of the string. (if not specified using .*)
                    //
                    switch(cStrlenSet) {
                      // compute length with strlen
                      case 0:
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0d01e50:	1908      	adds	r0, r1, r4
c0d01e52:	7840      	ldrb	r0, [r0, #1]
c0d01e54:	1c64      	adds	r4, r4, #1
c0d01e56:	2800      	cmp	r0, #0
c0d01e58:	d1fa      	bne.n	c0d01e50 <snprintf+0x2bc>
                    }

                    //
                    // Write the string.
                    //
                    switch(ulBase) {
c0d01e5a:	9801      	ldr	r0, [sp, #4]
c0d01e5c:	2810      	cmp	r0, #16
c0d01e5e:	9802      	ldr	r0, [sp, #8]
c0d01e60:	d144      	bne.n	c0d01eec <snprintf+0x358>
                            return 0;
                        }
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0d01e62:	2c00      	cmp	r4, #0
c0d01e64:	d074      	beq.n	c0d01f50 <snprintf+0x3bc>
c0d01e66:	9108      	str	r1, [sp, #32]
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0d01e68:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01e6a:	1883      	adds	r3, r0, r2
c0d01e6c:	1b50      	subs	r0, r2, r5
c0d01e6e:	4287      	cmp	r7, r0
c0d01e70:	4639      	mov	r1, r7
c0d01e72:	d800      	bhi.n	c0d01e76 <snprintf+0x2e2>
c0d01e74:	4601      	mov	r1, r0
c0d01e76:	9103      	str	r1, [sp, #12]
c0d01e78:	434a      	muls	r2, r1
c0d01e7a:	9202      	str	r2, [sp, #8]
c0d01e7c:	1c50      	adds	r0, r2, #1
c0d01e7e:	9001      	str	r0, [sp, #4]
c0d01e80:	2000      	movs	r0, #0
c0d01e82:	462a      	mov	r2, r5
c0d01e84:	930a      	str	r3, [sp, #40]	; 0x28
c0d01e86:	9902      	ldr	r1, [sp, #8]
c0d01e88:	185b      	adds	r3, r3, r1
c0d01e8a:	9009      	str	r0, [sp, #36]	; 0x24
c0d01e8c:	9908      	ldr	r1, [sp, #32]
c0d01e8e:	5c08      	ldrb	r0, [r1, r0]
                          nibble2 = pcStr[ulCount]&0xF;
c0d01e90:	250f      	movs	r5, #15
c0d01e92:	4005      	ands	r5, r0
                        }
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0d01e94:	0900      	lsrs	r0, r0, #4
c0d01e96:	9903      	ldr	r1, [sp, #12]
c0d01e98:	1889      	adds	r1, r1, r2
c0d01e9a:	1c49      	adds	r1, r1, #1
                          nibble2 = pcStr[ulCount]&0xF;
                          if (str_size < 2) {
c0d01e9c:	2902      	cmp	r1, #2
c0d01e9e:	d374      	bcc.n	c0d01f8a <snprintf+0x3f6>
c0d01ea0:	9904      	ldr	r1, [sp, #16]
                              return 0;
                          }
                          switch(ulCap) {
c0d01ea2:	2901      	cmp	r1, #1
c0d01ea4:	d003      	beq.n	c0d01eae <snprintf+0x31a>
c0d01ea6:	2900      	cmp	r1, #0
c0d01ea8:	d108      	bne.n	c0d01ebc <snprintf+0x328>
c0d01eaa:	a13f      	add	r1, pc, #252	; (adr r1, c0d01fa8 <g_pcHex>)
c0d01eac:	e000      	b.n	c0d01eb0 <snprintf+0x31c>
c0d01eae:	a13a      	add	r1, pc, #232	; (adr r1, c0d01f98 <g_pcHex_cap>)
c0d01eb0:	b2c0      	uxtb	r0, r0
c0d01eb2:	5c08      	ldrb	r0, [r1, r0]
c0d01eb4:	7018      	strb	r0, [r3, #0]
c0d01eb6:	b2e8      	uxtb	r0, r5
c0d01eb8:	5c08      	ldrb	r0, [r1, r0]
c0d01eba:	7058      	strb	r0, [r3, #1]
                                str[1] = g_pcHex_cap[nibble2];
                              break;
                          }
                          str+= 2;
                          str_size -= 2;
                          if (str_size == 0) {
c0d01ebc:	9801      	ldr	r0, [sp, #4]
c0d01ebe:	4290      	cmp	r0, r2
c0d01ec0:	d063      	beq.n	c0d01f8a <snprintf+0x3f6>
                            return 0;
                        }
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0d01ec2:	1e92      	subs	r2, r2, #2
c0d01ec4:	9b0a      	ldr	r3, [sp, #40]	; 0x28
c0d01ec6:	1c9b      	adds	r3, r3, #2
c0d01ec8:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01eca:	1c40      	adds	r0, r0, #1
c0d01ecc:	42a0      	cmp	r0, r4
c0d01ece:	d3d9      	bcc.n	c0d01e84 <snprintf+0x2f0>
c0d01ed0:	9009      	str	r0, [sp, #36]	; 0x24
c0d01ed2:	9905      	ldr	r1, [sp, #20]
 
#endif // HAVE_PRINTF

#ifdef HAVE_SPRINTF
//unsigned int snprintf(unsigned char * str, unsigned int str_size, const char* format, ...)
int snprintf(char * str, size_t str_size, const char * format, ...)
c0d01ed4:	9806      	ldr	r0, [sp, #24]
c0d01ed6:	1a08      	subs	r0, r1, r0
c0d01ed8:	4287      	cmp	r7, r0
c0d01eda:	d800      	bhi.n	c0d01ede <snprintf+0x34a>
c0d01edc:	4607      	mov	r7, r0
c0d01ede:	4608      	mov	r0, r1
c0d01ee0:	4378      	muls	r0, r7
c0d01ee2:	1818      	adds	r0, r3, r0
c0d01ee4:	900a      	str	r0, [sp, #40]	; 0x28
c0d01ee6:	18b8      	adds	r0, r7, r2
c0d01ee8:	1c43      	adds	r3, r0, #1
c0d01eea:	e01c      	b.n	c0d01f26 <snprintf+0x392>
                    //
                    // Write the string.
                    //
                    switch(ulBase) {
                      default:
                        ulIdx = MIN(ulIdx, str_size);
c0d01eec:	429c      	cmp	r4, r3
c0d01eee:	d300      	bcc.n	c0d01ef2 <snprintf+0x35e>
c0d01ef0:	461c      	mov	r4, r3
                        os_memmove(str, pcStr, ulIdx);
c0d01ef2:	4622      	mov	r2, r4
c0d01ef4:	4605      	mov	r5, r0
c0d01ef6:	461f      	mov	r7, r3
c0d01ef8:	f7ff f977 	bl	c0d011ea <os_memmove>
                        str+= ulIdx;
                        str_size -= ulIdx;
c0d01efc:	1b38      	subs	r0, r7, r4
                    //
                    switch(ulBase) {
                      default:
                        ulIdx = MIN(ulIdx, str_size);
                        os_memmove(str, pcStr, ulIdx);
                        str+= ulIdx;
c0d01efe:	1929      	adds	r1, r5, r4
c0d01f00:	e00d      	b.n	c0d01f1e <snprintf+0x38a>
c0d01f02:	9b03      	ldr	r3, [sp, #12]
c0d01f04:	9f00      	ldr	r7, [sp, #0]
                      case 2:
                        // if string is empty, then, ' ' padding
                        if (pcStr[0] == '\0') {
                        
                          // padd ulStrlen white space
                          ulStrlen = MIN(ulStrlen, str_size);
c0d01f06:	429f      	cmp	r7, r3
c0d01f08:	d300      	bcc.n	c0d01f0c <snprintf+0x378>
c0d01f0a:	461f      	mov	r7, r3
                          os_memset(str, ' ', ulStrlen);
c0d01f0c:	2120      	movs	r1, #32
c0d01f0e:	9d02      	ldr	r5, [sp, #8]
c0d01f10:	4628      	mov	r0, r5
c0d01f12:	463a      	mov	r2, r7
c0d01f14:	f7ff f960 	bl	c0d011d8 <os_memset>
                          str+= ulStrlen;
                          str_size -= ulStrlen;
c0d01f18:	9803      	ldr	r0, [sp, #12]
c0d01f1a:	1bc0      	subs	r0, r0, r7
                        if (pcStr[0] == '\0') {
                        
                          // padd ulStrlen white space
                          ulStrlen = MIN(ulStrlen, str_size);
                          os_memset(str, ' ', ulStrlen);
                          str+= ulStrlen;
c0d01f1c:	19e9      	adds	r1, r5, r7
c0d01f1e:	910a      	str	r1, [sp, #40]	; 0x28
c0d01f20:	4603      	mov	r3, r0
c0d01f22:	2800      	cmp	r0, #0
c0d01f24:	d031      	beq.n	c0d01f8a <snprintf+0x3f6>
c0d01f26:	9809      	ldr	r0, [sp, #36]	; 0x24

s_pad:
                    //
                    // Write any required padding spaces
                    //
                    if(ulCount > ulIdx)
c0d01f28:	42a0      	cmp	r0, r4
c0d01f2a:	d987      	bls.n	c0d01e3c <snprintf+0x2a8>
                    {
                        ulCount -= ulIdx;
c0d01f2c:	1b04      	subs	r4, r0, r4
c0d01f2e:	461d      	mov	r5, r3
                        ulCount = MIN(ulCount, str_size);
c0d01f30:	42ac      	cmp	r4, r5
c0d01f32:	d300      	bcc.n	c0d01f36 <snprintf+0x3a2>
c0d01f34:	462c      	mov	r4, r5
                        os_memset(str, ' ', ulCount);
c0d01f36:	2120      	movs	r1, #32
c0d01f38:	9f0a      	ldr	r7, [sp, #40]	; 0x28
c0d01f3a:	4638      	mov	r0, r7
c0d01f3c:	4622      	mov	r2, r4
c0d01f3e:	f7ff f94b 	bl	c0d011d8 <os_memset>
                        str+= ulCount;
                        str_size -= ulCount;
c0d01f42:	1b2d      	subs	r5, r5, r4
                    if(ulCount > ulIdx)
                    {
                        ulCount -= ulIdx;
                        ulCount = MIN(ulCount, str_size);
                        os_memset(str, ' ', ulCount);
                        str+= ulCount;
c0d01f44:	193f      	adds	r7, r7, r4
c0d01f46:	970a      	str	r7, [sp, #40]	; 0x28
c0d01f48:	462b      	mov	r3, r5
                        str_size -= ulCount;
                        if (str_size == 0) {
c0d01f4a:	2d00      	cmp	r5, #0
c0d01f4c:	d01d      	beq.n	c0d01f8a <snprintf+0x3f6>
c0d01f4e:	e775      	b.n	c0d01e3c <snprintf+0x2a8>
c0d01f50:	900a      	str	r0, [sp, #40]	; 0x28
c0d01f52:	e773      	b.n	c0d01e3c <snprintf+0x2a8>
    while(*format)
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0d01f54:	460f      	mov	r7, r1
c0d01f56:	9c07      	ldr	r4, [sp, #28]
c0d01f58:	e003      	b.n	c0d01f62 <snprintf+0x3ce>
c0d01f5a:	1930      	adds	r0, r6, r4
c0d01f5c:	7840      	ldrb	r0, [r0, #1]
c0d01f5e:	1e7f      	subs	r7, r7, #1
            ulIdx++)
c0d01f60:	1c64      	adds	r4, r4, #1
c0d01f62:	b2c0      	uxtb	r0, r0
    while(*format)
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0d01f64:	2800      	cmp	r0, #0
c0d01f66:	d001      	beq.n	c0d01f6c <snprintf+0x3d8>
c0d01f68:	2825      	cmp	r0, #37	; 0x25
c0d01f6a:	d1f6      	bne.n	c0d01f5a <snprintf+0x3c6>
        }

        //
        // Write this portion of the string.
        //
        ulIdx = MIN(ulIdx, str_size);
c0d01f6c:	42ac      	cmp	r4, r5
c0d01f6e:	d300      	bcc.n	c0d01f72 <snprintf+0x3de>
c0d01f70:	462c      	mov	r4, r5
        os_memmove(str, format, ulIdx);
c0d01f72:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01f74:	4631      	mov	r1, r6
c0d01f76:	4622      	mov	r2, r4
c0d01f78:	f7ff f937 	bl	c0d011ea <os_memmove>
c0d01f7c:	9506      	str	r5, [sp, #24]
        str+= ulIdx;
        str_size -= ulIdx;
c0d01f7e:	1b2b      	subs	r3, r5, r4
        //
        // Write this portion of the string.
        //
        ulIdx = MIN(ulIdx, str_size);
        os_memmove(str, format, ulIdx);
        str+= ulIdx;
c0d01f80:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01f82:	1902      	adds	r2, r0, r4
        str_size -= ulIdx;
        if (str_size == 0) {
c0d01f84:	2b00      	cmp	r3, #0
c0d01f86:	d000      	beq.n	c0d01f8a <snprintf+0x3f6>
c0d01f88:	e626      	b.n	c0d01bd8 <snprintf+0x44>
    // End the varargs processing.
    //
    va_end(vaArgP);

    return 0;
}
c0d01f8a:	2000      	movs	r0, #0
c0d01f8c:	b010      	add	sp, #64	; 0x40
c0d01f8e:	bcf0      	pop	{r4, r5, r6, r7}
c0d01f90:	bc02      	pop	{r1}
c0d01f92:	b001      	add	sp, #4
c0d01f94:	4708      	bx	r1
c0d01f96:	46c0      	nop			; (mov r8, r8)

c0d01f98 <g_pcHex_cap>:
c0d01f98:	33323130 	.word	0x33323130
c0d01f9c:	37363534 	.word	0x37363534
c0d01fa0:	42413938 	.word	0x42413938
c0d01fa4:	46454443 	.word	0x46454443

c0d01fa8 <g_pcHex>:
c0d01fa8:	33323130 	.word	0x33323130
c0d01fac:	37363534 	.word	0x37363534
c0d01fb0:	62613938 	.word	0x62613938
c0d01fb4:	66656463 	.word	0x66656463
c0d01fb8:	4f525245 	.word	0x4f525245
c0d01fbc:	00000052 	.word	0x00000052

c0d01fc0 <pic>:

// only apply PIC conversion if link_address is in linked code (over 0xC0D00000 in our example)
// this way, PIC call are armless if the address is not meant to be converted
extern unsigned int _nvram;
extern unsigned int _envram;
unsigned int pic(unsigned int link_address) {
c0d01fc0:	b580      	push	{r7, lr}
//  screen_printf(" %08X", link_address);
	if (link_address >= ((unsigned int)&_nvram) && link_address < ((unsigned int)&_envram)) {
c0d01fc2:	4904      	ldr	r1, [pc, #16]	; (c0d01fd4 <pic+0x14>)
c0d01fc4:	4288      	cmp	r0, r1
c0d01fc6:	d304      	bcc.n	c0d01fd2 <pic+0x12>
c0d01fc8:	4903      	ldr	r1, [pc, #12]	; (c0d01fd8 <pic+0x18>)
c0d01fca:	4288      	cmp	r0, r1
c0d01fcc:	d201      	bcs.n	c0d01fd2 <pic+0x12>
		link_address = pic_internal(link_address);
c0d01fce:	f000 f805 	bl	c0d01fdc <pic_internal>
//    screen_printf(" -> %08X\n", link_address);
  }
	return link_address;
c0d01fd2:	bd80      	pop	{r7, pc}
c0d01fd4:	c0d00000 	.word	0xc0d00000
c0d01fd8:	c0d05a80 	.word	0xc0d05a80

c0d01fdc <pic_internal>:

unsigned int pic_internal(unsigned int link_address) __attribute__((naked));
unsigned int pic_internal(unsigned int link_address) 
{
  // compute the delta offset between LinkMemAddr & ExecMemAddr
  __asm volatile ("mov r2, pc\n");          // r2 = 0x109004
c0d01fdc:	467a      	mov	r2, pc
  __asm volatile ("ldr r1, =pic_internal\n");        // r1 = 0xC0D00001
c0d01fde:	4902      	ldr	r1, [pc, #8]	; (c0d01fe8 <pic_internal+0xc>)
  __asm volatile ("adds r1, r1, #3\n");     // r1 = 0xC0D00004
c0d01fe0:	1cc9      	adds	r1, r1, #3
  __asm volatile ("subs r1, r1, r2\n");     // r1 = 0xC0BF7000 (delta between load and exec address)
c0d01fe2:	1a89      	subs	r1, r1, r2

  // adjust value of the given parameter
  __asm volatile ("subs r0, r0, r1\n");     // r0 = 0xC0D0C244 => r0 = 0x115244
c0d01fe4:	1a40      	subs	r0, r0, r1
  __asm volatile ("bx lr\n");
c0d01fe6:	4770      	bx	lr
c0d01fe8:	c0d01fdd 	.word	0xc0d01fdd

c0d01fec <SVC_Call>:
  // avoid a separate asm file, but avoid any intrusion from the compiler
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) __attribute__ ((naked));
  //                    r0                       r1
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) {
    // delegate svc
    asm volatile("svc #1":::"r0","r1");
c0d01fec:	df01      	svc	1
    // directly return R0 value
    asm volatile("bx  lr");
c0d01fee:	4770      	bx	lr

c0d01ff0 <check_api_level>:
  }
  void check_api_level ( unsigned int apiLevel ) 
{
c0d01ff0:	b580      	push	{r7, lr}
c0d01ff2:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
c0d01ff4:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
c0d01ff6:	4807      	ldr	r0, [pc, #28]	; (c0d02014 <check_api_level+0x24>)
c0d01ff8:	4669      	mov	r1, sp
c0d01ffa:	f7ff fff7 	bl	c0d01fec <SVC_Call>
c0d01ffe:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02000:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_check_api_level_ID_OUT) {
c0d02002:	4905      	ldr	r1, [pc, #20]	; (c0d02018 <check_api_level+0x28>)
c0d02004:	4288      	cmp	r0, r1
c0d02006:	d101      	bne.n	c0d0200c <check_api_level+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d02008:	b002      	add	sp, #8
c0d0200a:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_check_api_level_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0200c:	2004      	movs	r0, #4
c0d0200e:	f7ff f9a0 	bl	c0d01352 <os_longjmp>
c0d02012:	46c0      	nop			; (mov r8, r8)
c0d02014:	60000137 	.word	0x60000137
c0d02018:	900001c6 	.word	0x900001c6

c0d0201c <reset>:
  }
}

void reset ( void ) 
{
c0d0201c:	b580      	push	{r7, lr}
c0d0201e:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
c0d02020:	4806      	ldr	r0, [pc, #24]	; (c0d0203c <reset+0x20>)
c0d02022:	a901      	add	r1, sp, #4
c0d02024:	f7ff ffe2 	bl	c0d01fec <SVC_Call>
c0d02028:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0202a:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_reset_ID_OUT) {
c0d0202c:	4904      	ldr	r1, [pc, #16]	; (c0d02040 <reset+0x24>)
c0d0202e:	4288      	cmp	r0, r1
c0d02030:	d101      	bne.n	c0d02036 <reset+0x1a>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d02032:	b002      	add	sp, #8
c0d02034:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_reset_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02036:	2004      	movs	r0, #4
c0d02038:	f7ff f98b 	bl	c0d01352 <os_longjmp>
c0d0203c:	60000200 	.word	0x60000200
c0d02040:	900002f1 	.word	0x900002f1

c0d02044 <cx_rng>:
  }
  return (unsigned char)ret;
}

unsigned char * cx_rng ( unsigned char * buffer, unsigned int len ) 
{
c0d02044:	b580      	push	{r7, lr}
c0d02046:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d02048:	9001      	str	r0, [sp, #4]
  parameters[1] = (unsigned int)len;
c0d0204a:	9102      	str	r1, [sp, #8]
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
c0d0204c:	4807      	ldr	r0, [pc, #28]	; (c0d0206c <cx_rng+0x28>)
c0d0204e:	a901      	add	r1, sp, #4
c0d02050:	f7ff ffcc 	bl	c0d01fec <SVC_Call>
c0d02054:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02056:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_rng_ID_OUT) {
c0d02058:	4905      	ldr	r1, [pc, #20]	; (c0d02070 <cx_rng+0x2c>)
c0d0205a:	4288      	cmp	r0, r1
c0d0205c:	d102      	bne.n	c0d02064 <cx_rng+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned char *)ret;
c0d0205e:	9803      	ldr	r0, [sp, #12]
c0d02060:	b004      	add	sp, #16
c0d02062:	bd80      	pop	{r7, pc}
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_rng_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02064:	2004      	movs	r0, #4
c0d02066:	f7ff f974 	bl	c0d01352 <os_longjmp>
c0d0206a:	46c0      	nop			; (mov r8, r8)
c0d0206c:	6000052c 	.word	0x6000052c
c0d02070:	90000567 	.word	0x90000567

c0d02074 <cx_hash>:
  }
  return (int)ret;
}

int cx_hash ( cx_hash_t * hash, int mode, const unsigned char * in, unsigned int len, unsigned char * out, unsigned int out_len ) 
{
c0d02074:	b580      	push	{r7, lr}
c0d02076:	b088      	sub	sp, #32
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+6];
  parameters[0] = (unsigned int)hash;
c0d02078:	af01      	add	r7, sp, #4
c0d0207a:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d0207c:	980a      	ldr	r0, [sp, #40]	; 0x28
  parameters[1] = (unsigned int)mode;
  parameters[2] = (unsigned int)in;
  parameters[3] = (unsigned int)len;
  parameters[4] = (unsigned int)out;
c0d0207e:	9005      	str	r0, [sp, #20]
c0d02080:	980b      	ldr	r0, [sp, #44]	; 0x2c
  parameters[5] = (unsigned int)out_len;
c0d02082:	9006      	str	r0, [sp, #24]
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
c0d02084:	4807      	ldr	r0, [pc, #28]	; (c0d020a4 <cx_hash+0x30>)
c0d02086:	a901      	add	r1, sp, #4
c0d02088:	f7ff ffb0 	bl	c0d01fec <SVC_Call>
c0d0208c:	aa07      	add	r2, sp, #28
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0208e:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_hash_ID_OUT) {
c0d02090:	4905      	ldr	r1, [pc, #20]	; (c0d020a8 <cx_hash+0x34>)
c0d02092:	4288      	cmp	r0, r1
c0d02094:	d102      	bne.n	c0d0209c <cx_hash+0x28>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d02096:	9807      	ldr	r0, [sp, #28]
c0d02098:	b008      	add	sp, #32
c0d0209a:	bd80      	pop	{r7, pc}
  parameters[4] = (unsigned int)out;
  parameters[5] = (unsigned int)out_len;
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_hash_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0209c:	2004      	movs	r0, #4
c0d0209e:	f7ff f958 	bl	c0d01352 <os_longjmp>
c0d020a2:	46c0      	nop			; (mov r8, r8)
c0d020a4:	6000073b 	.word	0x6000073b
c0d020a8:	900007ad 	.word	0x900007ad

c0d020ac <cx_ripemd160_init>:
  }
  return (int)ret;
}

int cx_ripemd160_init ( cx_ripemd160_t * hash ) 
{
c0d020ac:	b580      	push	{r7, lr}
c0d020ae:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
c0d020b0:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_cx_ripemd160_init_ID_IN, parameters);
c0d020b2:	4807      	ldr	r0, [pc, #28]	; (c0d020d0 <cx_ripemd160_init+0x24>)
c0d020b4:	4669      	mov	r1, sp
c0d020b6:	f7ff ff99 	bl	c0d01fec <SVC_Call>
c0d020ba:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d020bc:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ripemd160_init_ID_OUT) {
c0d020be:	4905      	ldr	r1, [pc, #20]	; (c0d020d4 <cx_ripemd160_init+0x28>)
c0d020c0:	4288      	cmp	r0, r1
c0d020c2:	d102      	bne.n	c0d020ca <cx_ripemd160_init+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d020c4:	9801      	ldr	r0, [sp, #4]
c0d020c6:	b002      	add	sp, #8
c0d020c8:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
  retid = SVC_Call(SYSCALL_cx_ripemd160_init_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ripemd160_init_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d020ca:	2004      	movs	r0, #4
c0d020cc:	f7ff f941 	bl	c0d01352 <os_longjmp>
c0d020d0:	6000087f 	.word	0x6000087f
c0d020d4:	900008f8 	.word	0x900008f8

c0d020d8 <cx_sha256_init>:
  }
  return (int)ret;
}

int cx_sha256_init ( cx_sha256_t * hash ) 
{
c0d020d8:	b580      	push	{r7, lr}
c0d020da:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
c0d020dc:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_cx_sha256_init_ID_IN, parameters);
c0d020de:	4807      	ldr	r0, [pc, #28]	; (c0d020fc <cx_sha256_init+0x24>)
c0d020e0:	4669      	mov	r1, sp
c0d020e2:	f7ff ff83 	bl	c0d01fec <SVC_Call>
c0d020e6:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d020e8:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_sha256_init_ID_OUT) {
c0d020ea:	4905      	ldr	r1, [pc, #20]	; (c0d02100 <cx_sha256_init+0x28>)
c0d020ec:	4288      	cmp	r0, r1
c0d020ee:	d102      	bne.n	c0d020f6 <cx_sha256_init+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d020f0:	9801      	ldr	r0, [sp, #4]
c0d020f2:	b002      	add	sp, #8
c0d020f4:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
  retid = SVC_Call(SYSCALL_cx_sha256_init_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_sha256_init_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d020f6:	2004      	movs	r0, #4
c0d020f8:	f7ff f92b 	bl	c0d01352 <os_longjmp>
c0d020fc:	60000adb 	.word	0x60000adb
c0d02100:	90000a64 	.word	0x90000a64

c0d02104 <cx_ecfp_init_public_key>:
  }
  return (int)ret;
}

int cx_ecfp_init_public_key ( cx_curve_t curve, const unsigned char * rawkey, unsigned int key_len, cx_ecfp_public_key_t * key ) 
{
c0d02104:	b580      	push	{r7, lr}
c0d02106:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d02108:	af01      	add	r7, sp, #4
c0d0210a:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)rawkey;
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_public_key_ID_IN, parameters);
c0d0210c:	4807      	ldr	r0, [pc, #28]	; (c0d0212c <cx_ecfp_init_public_key+0x28>)
c0d0210e:	a901      	add	r1, sp, #4
c0d02110:	f7ff ff6c 	bl	c0d01fec <SVC_Call>
c0d02114:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02116:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_init_public_key_ID_OUT) {
c0d02118:	4905      	ldr	r1, [pc, #20]	; (c0d02130 <cx_ecfp_init_public_key+0x2c>)
c0d0211a:	4288      	cmp	r0, r1
c0d0211c:	d102      	bne.n	c0d02124 <cx_ecfp_init_public_key+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d0211e:	9805      	ldr	r0, [sp, #20]
c0d02120:	b006      	add	sp, #24
c0d02122:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_public_key_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_init_public_key_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02124:	2004      	movs	r0, #4
c0d02126:	f7ff f914 	bl	c0d01352 <os_longjmp>
c0d0212a:	46c0      	nop			; (mov r8, r8)
c0d0212c:	60002aed 	.word	0x60002aed
c0d02130:	90002a49 	.word	0x90002a49

c0d02134 <cx_ecfp_init_private_key>:
  }
  return (int)ret;
}

int cx_ecfp_init_private_key ( cx_curve_t curve, const unsigned char * rawkey, unsigned int key_len, cx_ecfp_private_key_t * pvkey ) 
{
c0d02134:	b580      	push	{r7, lr}
c0d02136:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d02138:	af01      	add	r7, sp, #4
c0d0213a:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)rawkey;
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)pvkey;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_private_key_ID_IN, parameters);
c0d0213c:	4807      	ldr	r0, [pc, #28]	; (c0d0215c <cx_ecfp_init_private_key+0x28>)
c0d0213e:	a901      	add	r1, sp, #4
c0d02140:	f7ff ff54 	bl	c0d01fec <SVC_Call>
c0d02144:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02146:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_init_private_key_ID_OUT) {
c0d02148:	4905      	ldr	r1, [pc, #20]	; (c0d02160 <cx_ecfp_init_private_key+0x2c>)
c0d0214a:	4288      	cmp	r0, r1
c0d0214c:	d102      	bne.n	c0d02154 <cx_ecfp_init_private_key+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d0214e:	9805      	ldr	r0, [sp, #20]
c0d02150:	b006      	add	sp, #24
c0d02152:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)pvkey;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_private_key_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_init_private_key_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02154:	2004      	movs	r0, #4
c0d02156:	f7ff f8fc 	bl	c0d01352 <os_longjmp>
c0d0215a:	46c0      	nop			; (mov r8, r8)
c0d0215c:	60002bea 	.word	0x60002bea
c0d02160:	90002b63 	.word	0x90002b63

c0d02164 <cx_ecfp_generate_pair>:
  }
  return (int)ret;
}

int cx_ecfp_generate_pair ( cx_curve_t curve, cx_ecfp_public_key_t * pubkey, cx_ecfp_private_key_t * privkey, int keepprivate ) 
{
c0d02164:	b580      	push	{r7, lr}
c0d02166:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d02168:	af01      	add	r7, sp, #4
c0d0216a:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)pubkey;
  parameters[2] = (unsigned int)privkey;
  parameters[3] = (unsigned int)keepprivate;
  retid = SVC_Call(SYSCALL_cx_ecfp_generate_pair_ID_IN, parameters);
c0d0216c:	4807      	ldr	r0, [pc, #28]	; (c0d0218c <cx_ecfp_generate_pair+0x28>)
c0d0216e:	a901      	add	r1, sp, #4
c0d02170:	f7ff ff3c 	bl	c0d01fec <SVC_Call>
c0d02174:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02176:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_generate_pair_ID_OUT) {
c0d02178:	4905      	ldr	r1, [pc, #20]	; (c0d02190 <cx_ecfp_generate_pair+0x2c>)
c0d0217a:	4288      	cmp	r0, r1
c0d0217c:	d102      	bne.n	c0d02184 <cx_ecfp_generate_pair+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d0217e:	9805      	ldr	r0, [sp, #20]
c0d02180:	b006      	add	sp, #24
c0d02182:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)privkey;
  parameters[3] = (unsigned int)keepprivate;
  retid = SVC_Call(SYSCALL_cx_ecfp_generate_pair_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_generate_pair_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02184:	2004      	movs	r0, #4
c0d02186:	f7ff f8e4 	bl	c0d01352 <os_longjmp>
c0d0218a:	46c0      	nop			; (mov r8, r8)
c0d0218c:	60002c2e 	.word	0x60002c2e
c0d02190:	90002c74 	.word	0x90002c74

c0d02194 <cx_ecdsa_sign>:
  }
  return (int)ret;
}

int cx_ecdsa_sign ( const cx_ecfp_private_key_t * pvkey, int mode, cx_md_t hashID, const unsigned char * hash, unsigned int hash_len, unsigned char * sig, unsigned int sig_len, unsigned int * info ) 
{
c0d02194:	b580      	push	{r7, lr}
c0d02196:	b08a      	sub	sp, #40	; 0x28
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+8];
  parameters[0] = (unsigned int)pvkey;
c0d02198:	af01      	add	r7, sp, #4
c0d0219a:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d0219c:	980c      	ldr	r0, [sp, #48]	; 0x30
  parameters[1] = (unsigned int)mode;
  parameters[2] = (unsigned int)hashID;
  parameters[3] = (unsigned int)hash;
  parameters[4] = (unsigned int)hash_len;
c0d0219e:	9005      	str	r0, [sp, #20]
c0d021a0:	980d      	ldr	r0, [sp, #52]	; 0x34
  parameters[5] = (unsigned int)sig;
c0d021a2:	9006      	str	r0, [sp, #24]
c0d021a4:	980e      	ldr	r0, [sp, #56]	; 0x38
  parameters[6] = (unsigned int)sig_len;
c0d021a6:	9007      	str	r0, [sp, #28]
c0d021a8:	980f      	ldr	r0, [sp, #60]	; 0x3c
  parameters[7] = (unsigned int)info;
c0d021aa:	9008      	str	r0, [sp, #32]
  retid = SVC_Call(SYSCALL_cx_ecdsa_sign_ID_IN, parameters);
c0d021ac:	4807      	ldr	r0, [pc, #28]	; (c0d021cc <cx_ecdsa_sign+0x38>)
c0d021ae:	a901      	add	r1, sp, #4
c0d021b0:	f7ff ff1c 	bl	c0d01fec <SVC_Call>
c0d021b4:	aa09      	add	r2, sp, #36	; 0x24
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d021b6:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecdsa_sign_ID_OUT) {
c0d021b8:	4905      	ldr	r1, [pc, #20]	; (c0d021d0 <cx_ecdsa_sign+0x3c>)
c0d021ba:	4288      	cmp	r0, r1
c0d021bc:	d102      	bne.n	c0d021c4 <cx_ecdsa_sign+0x30>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d021be:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d021c0:	b00a      	add	sp, #40	; 0x28
c0d021c2:	bd80      	pop	{r7, pc}
  parameters[6] = (unsigned int)sig_len;
  parameters[7] = (unsigned int)info;
  retid = SVC_Call(SYSCALL_cx_ecdsa_sign_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecdsa_sign_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d021c4:	2004      	movs	r0, #4
c0d021c6:	f7ff f8c4 	bl	c0d01352 <os_longjmp>
c0d021ca:	46c0      	nop			; (mov r8, r8)
c0d021cc:	600035f3 	.word	0x600035f3
c0d021d0:	90003576 	.word	0x90003576

c0d021d4 <os_perso_derive_node_bip32>:
  }
  return (unsigned int)ret;
}

void os_perso_derive_node_bip32 ( cx_curve_t curve, const unsigned int * path, unsigned int pathLength, unsigned char * privateKey, unsigned char * chain ) 
{
c0d021d4:	b580      	push	{r7, lr}
c0d021d6:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)curve;
c0d021d8:	af00      	add	r7, sp, #0
c0d021da:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d021dc:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)path;
  parameters[2] = (unsigned int)pathLength;
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
c0d021de:	9004      	str	r0, [sp, #16]
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
c0d021e0:	4806      	ldr	r0, [pc, #24]	; (c0d021fc <os_perso_derive_node_bip32+0x28>)
c0d021e2:	4669      	mov	r1, sp
c0d021e4:	f7ff ff02 	bl	c0d01fec <SVC_Call>
c0d021e8:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d021ea:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
c0d021ec:	4904      	ldr	r1, [pc, #16]	; (c0d02200 <os_perso_derive_node_bip32+0x2c>)
c0d021ee:	4288      	cmp	r0, r1
c0d021f0:	d101      	bne.n	c0d021f6 <os_perso_derive_node_bip32+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d021f2:	b006      	add	sp, #24
c0d021f4:	bd80      	pop	{r7, pc}
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d021f6:	2004      	movs	r0, #4
c0d021f8:	f7ff f8ab 	bl	c0d01352 <os_longjmp>
c0d021fc:	600050ba 	.word	0x600050ba
c0d02200:	9000501e 	.word	0x9000501e

c0d02204 <os_sched_exit>:
  }
  return (unsigned int)ret;
}

void os_sched_exit ( unsigned int exit_code ) 
{
c0d02204:	b580      	push	{r7, lr}
c0d02206:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
c0d02208:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
c0d0220a:	4807      	ldr	r0, [pc, #28]	; (c0d02228 <os_sched_exit+0x24>)
c0d0220c:	4669      	mov	r1, sp
c0d0220e:	f7ff feed 	bl	c0d01fec <SVC_Call>
c0d02212:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02214:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
c0d02216:	4905      	ldr	r1, [pc, #20]	; (c0d0222c <os_sched_exit+0x28>)
c0d02218:	4288      	cmp	r0, r1
c0d0221a:	d101      	bne.n	c0d02220 <os_sched_exit+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d0221c:	b002      	add	sp, #8
c0d0221e:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02220:	2004      	movs	r0, #4
c0d02222:	f7ff f896 	bl	c0d01352 <os_longjmp>
c0d02226:	46c0      	nop			; (mov r8, r8)
c0d02228:	60005fe1 	.word	0x60005fe1
c0d0222c:	90005f6f 	.word	0x90005f6f

c0d02230 <os_ux>:
    THROW(EXCEPTION_SECURITY);
  }
}

unsigned int os_ux ( bolos_ux_params_t * params ) 
{
c0d02230:	b580      	push	{r7, lr}
c0d02232:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
c0d02234:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
c0d02236:	4807      	ldr	r0, [pc, #28]	; (c0d02254 <os_ux+0x24>)
c0d02238:	4669      	mov	r1, sp
c0d0223a:	f7ff fed7 	bl	c0d01fec <SVC_Call>
c0d0223e:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02240:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_ux_ID_OUT) {
c0d02242:	4905      	ldr	r1, [pc, #20]	; (c0d02258 <os_ux+0x28>)
c0d02244:	4288      	cmp	r0, r1
c0d02246:	d102      	bne.n	c0d0224e <os_ux+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d02248:	9801      	ldr	r0, [sp, #4]
c0d0224a:	b002      	add	sp, #8
c0d0224c:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_ux_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0224e:	2004      	movs	r0, #4
c0d02250:	f7ff f87f 	bl	c0d01352 <os_longjmp>
c0d02254:	60006158 	.word	0x60006158
c0d02258:	9000611f 	.word	0x9000611f

c0d0225c <os_seph_features>:
  }
  return (unsigned int)ret;
}

unsigned int os_seph_features ( void ) 
{
c0d0225c:	b580      	push	{r7, lr}
c0d0225e:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_seph_features_ID_IN, parameters);
c0d02260:	4807      	ldr	r0, [pc, #28]	; (c0d02280 <os_seph_features+0x24>)
c0d02262:	a901      	add	r1, sp, #4
c0d02264:	f7ff fec2 	bl	c0d01fec <SVC_Call>
c0d02268:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0226a:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_seph_features_ID_OUT) {
c0d0226c:	4905      	ldr	r1, [pc, #20]	; (c0d02284 <os_seph_features+0x28>)
c0d0226e:	4288      	cmp	r0, r1
c0d02270:	d102      	bne.n	c0d02278 <os_seph_features+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d02272:	9800      	ldr	r0, [sp, #0]
c0d02274:	b002      	add	sp, #8
c0d02276:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_seph_features_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_seph_features_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02278:	2004      	movs	r0, #4
c0d0227a:	f7ff f86a 	bl	c0d01352 <os_longjmp>
c0d0227e:	46c0      	nop			; (mov r8, r8)
c0d02280:	600067d6 	.word	0x600067d6
c0d02284:	90006744 	.word	0x90006744

c0d02288 <io_seproxyhal_spi_send>:
  }
  return (unsigned int)ret;
}

void io_seproxyhal_spi_send ( const unsigned char * buffer, unsigned short length ) 
{
c0d02288:	b580      	push	{r7, lr}
c0d0228a:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d0228c:	9001      	str	r0, [sp, #4]
  parameters[1] = (unsigned int)length;
c0d0228e:	9102      	str	r1, [sp, #8]
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
c0d02290:	4806      	ldr	r0, [pc, #24]	; (c0d022ac <io_seproxyhal_spi_send+0x24>)
c0d02292:	a901      	add	r1, sp, #4
c0d02294:	f7ff feaa 	bl	c0d01fec <SVC_Call>
c0d02298:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0229a:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
c0d0229c:	4904      	ldr	r1, [pc, #16]	; (c0d022b0 <io_seproxyhal_spi_send+0x28>)
c0d0229e:	4288      	cmp	r0, r1
c0d022a0:	d101      	bne.n	c0d022a6 <io_seproxyhal_spi_send+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d022a2:	b004      	add	sp, #16
c0d022a4:	bd80      	pop	{r7, pc}
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d022a6:	2004      	movs	r0, #4
c0d022a8:	f7ff f853 	bl	c0d01352 <os_longjmp>
c0d022ac:	60006e1c 	.word	0x60006e1c
c0d022b0:	90006ef3 	.word	0x90006ef3

c0d022b4 <io_seproxyhal_spi_is_status_sent>:
  }
}

unsigned int io_seproxyhal_spi_is_status_sent ( void ) 
{
c0d022b4:	b580      	push	{r7, lr}
c0d022b6:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
c0d022b8:	4807      	ldr	r0, [pc, #28]	; (c0d022d8 <io_seproxyhal_spi_is_status_sent+0x24>)
c0d022ba:	a901      	add	r1, sp, #4
c0d022bc:	f7ff fe96 	bl	c0d01fec <SVC_Call>
c0d022c0:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d022c2:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
c0d022c4:	4905      	ldr	r1, [pc, #20]	; (c0d022dc <io_seproxyhal_spi_is_status_sent+0x28>)
c0d022c6:	4288      	cmp	r0, r1
c0d022c8:	d102      	bne.n	c0d022d0 <io_seproxyhal_spi_is_status_sent+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d022ca:	9800      	ldr	r0, [sp, #0]
c0d022cc:	b002      	add	sp, #8
c0d022ce:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d022d0:	2004      	movs	r0, #4
c0d022d2:	f7ff f83e 	bl	c0d01352 <os_longjmp>
c0d022d6:	46c0      	nop			; (mov r8, r8)
c0d022d8:	60006fcf 	.word	0x60006fcf
c0d022dc:	90006f7f 	.word	0x90006f7f

c0d022e0 <io_seproxyhal_spi_recv>:
  }
  return (unsigned int)ret;
}

unsigned short io_seproxyhal_spi_recv ( unsigned char * buffer, unsigned short maxlength, unsigned int flags ) 
{
c0d022e0:	b580      	push	{r7, lr}
c0d022e2:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)buffer;
c0d022e4:	ab00      	add	r3, sp, #0
c0d022e6:	c307      	stmia	r3!, {r0, r1, r2}
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
c0d022e8:	4807      	ldr	r0, [pc, #28]	; (c0d02308 <io_seproxyhal_spi_recv+0x28>)
c0d022ea:	4669      	mov	r1, sp
c0d022ec:	f7ff fe7e 	bl	c0d01fec <SVC_Call>
c0d022f0:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d022f2:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
c0d022f4:	4905      	ldr	r1, [pc, #20]	; (c0d0230c <io_seproxyhal_spi_recv+0x2c>)
c0d022f6:	4288      	cmp	r0, r1
c0d022f8:	d103      	bne.n	c0d02302 <io_seproxyhal_spi_recv+0x22>
c0d022fa:	a803      	add	r0, sp, #12
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned short)ret;
c0d022fc:	8800      	ldrh	r0, [r0, #0]
c0d022fe:	b004      	add	sp, #16
c0d02300:	bd80      	pop	{r7, pc}
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02302:	2004      	movs	r0, #4
c0d02304:	f7ff f825 	bl	c0d01352 <os_longjmp>
c0d02308:	600070d1 	.word	0x600070d1
c0d0230c:	9000702b 	.word	0x9000702b

c0d02310 <u2f_apdu_sign>:

    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)SW_INTERNAL, sizeof(SW_INTERNAL));
}

void u2f_apdu_sign(u2f_service_t *service, uint8_t p1, uint8_t p2,
                     uint8_t *buffer, uint16_t length) {
c0d02310:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02312:	b085      	sub	sp, #20
    UNUSED(p2);
    uint8_t keyHandleLength;
    uint8_t i;

    // can't process the apdu if another one is already scheduled in
    if (G_io_apdu_state != APDU_IDLE) {
c0d02314:	4921      	ldr	r1, [pc, #132]	; (c0d0239c <u2f_apdu_sign+0x8c>)
c0d02316:	780a      	ldrb	r2, [r1, #0]
    for (i = 0; i < keyHandleLength; i++) {
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02318:	2183      	movs	r1, #131	; 0x83
    UNUSED(p2);
    uint8_t keyHandleLength;
    uint8_t i;

    // can't process the apdu if another one is already scheduled in
    if (G_io_apdu_state != APDU_IDLE) {
c0d0231a:	2a00      	cmp	r2, #0
c0d0231c:	d002      	beq.n	c0d02324 <u2f_apdu_sign+0x14>
        u2f_message_reply(service, U2F_CMD_MSG,
c0d0231e:	4a24      	ldr	r2, [pc, #144]	; (c0d023b0 <u2f_apdu_sign+0xa0>)
c0d02320:	447a      	add	r2, pc
c0d02322:	e004      	b.n	c0d0232e <u2f_apdu_sign+0x1e>
c0d02324:	9a0a      	ldr	r2, [sp, #40]	; 0x28
                  (uint8_t *)SW_BUSY,
                  sizeof(SW_BUSY));
        return;        
    }

    if (length < U2F_HANDLE_SIGN_HEADER_SIZE + 5 /*at least an apdu header*/) {
c0d02326:	2a45      	cmp	r2, #69	; 0x45
c0d02328:	d806      	bhi.n	c0d02338 <u2f_apdu_sign+0x28>
        u2f_message_reply(service, U2F_CMD_MSG,
c0d0232a:	4a22      	ldr	r2, [pc, #136]	; (c0d023b4 <u2f_apdu_sign+0xa4>)
c0d0232c:	447a      	add	r2, pc
c0d0232e:	2302      	movs	r3, #2
c0d02330:	f000 fb36 	bl	c0d029a0 <u2f_message_reply>
    app_dispatch();
    if ((btchip_context_D.io_flags & IO_ASYNCH_REPLY) == 0) {
        u2f_proxy_response(service, btchip_context_D.outLength);
    }
    */
}
c0d02334:	b005      	add	sp, #20
c0d02336:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02338:	ac01      	add	r4, sp, #4
c0d0233a:	c407      	stmia	r4!, {r0, r1, r2}
                  sizeof(SW_WRONG_LENGTH));
        return;
    }

    // Unwrap magic
    keyHandleLength = buffer[U2F_HANDLE_SIGN_HEADER_SIZE-1];
c0d0233c:	2040      	movs	r0, #64	; 0x40
c0d0233e:	9304      	str	r3, [sp, #16]
c0d02340:	5c1f      	ldrb	r7, [r3, r0]
    for (i = 0; i < keyHandleLength; i++) {
c0d02342:	2f00      	cmp	r7, #0
c0d02344:	d00e      	beq.n	c0d02364 <u2f_apdu_sign+0x54>
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
c0d02346:	9e04      	ldr	r6, [sp, #16]
c0d02348:	3641      	adds	r6, #65	; 0x41
c0d0234a:	2400      	movs	r4, #0
c0d0234c:	a514      	add	r5, pc, #80	; (adr r5, c0d023a0 <u2f_apdu_sign+0x90>)
c0d0234e:	b2e0      	uxtb	r0, r4
c0d02350:	2103      	movs	r1, #3
c0d02352:	f002 f987 	bl	c0d04664 <__aeabi_uidivmod>
c0d02356:	5d30      	ldrb	r0, [r6, r4]
c0d02358:	5c69      	ldrb	r1, [r5, r1]
c0d0235a:	4041      	eors	r1, r0
c0d0235c:	5531      	strb	r1, [r6, r4]
        return;
    }

    // Unwrap magic
    keyHandleLength = buffer[U2F_HANDLE_SIGN_HEADER_SIZE-1];
    for (i = 0; i < keyHandleLength; i++) {
c0d0235e:	1c64      	adds	r4, r4, #1
c0d02360:	42a7      	cmp	r7, r4
c0d02362:	d1f4      	bne.n	c0d0234e <u2f_apdu_sign+0x3e>
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
c0d02364:	2045      	movs	r0, #69	; 0x45
c0d02366:	9904      	ldr	r1, [sp, #16]
c0d02368:	5c08      	ldrb	r0, [r1, r0]
c0d0236a:	3046      	adds	r0, #70	; 0x46
c0d0236c:	9a03      	ldr	r2, [sp, #12]
c0d0236e:	4282      	cmp	r2, r0
c0d02370:	d10d      	bne.n	c0d0238e <u2f_apdu_sign+0x7e>
                  sizeof(SW_BAD_KEY_HANDLE));
        return;
    }

    // make the apdu available to higher layers
    os_memmove(G_io_apdu_buffer, buffer + U2F_HANDLE_SIGN_HEADER_SIZE, keyHandleLength);
c0d02372:	3141      	adds	r1, #65	; 0x41
c0d02374:	480b      	ldr	r0, [pc, #44]	; (c0d023a4 <u2f_apdu_sign+0x94>)
c0d02376:	463a      	mov	r2, r7
c0d02378:	f7fe ff37 	bl	c0d011ea <os_memmove>
    G_io_apdu_length = keyHandleLength;
c0d0237c:	480a      	ldr	r0, [pc, #40]	; (c0d023a8 <u2f_apdu_sign+0x98>)
c0d0237e:	8007      	strh	r7, [r0, #0]
    G_io_apdu_media = IO_APDU_MEDIA_U2F; // the effective transport is managed by the U2F layer
c0d02380:	480a      	ldr	r0, [pc, #40]	; (c0d023ac <u2f_apdu_sign+0x9c>)
c0d02382:	2106      	movs	r1, #6
c0d02384:	7001      	strb	r1, [r0, #0]
    G_io_apdu_state = APDU_U2F;
c0d02386:	2009      	movs	r0, #9
c0d02388:	4904      	ldr	r1, [pc, #16]	; (c0d0239c <u2f_apdu_sign+0x8c>)
c0d0238a:	7008      	strb	r0, [r1, #0]
c0d0238c:	e7d2      	b.n	c0d02334 <u2f_apdu_sign+0x24>
    for (i = 0; i < keyHandleLength; i++) {
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
        u2f_message_reply(service, U2F_CMD_MSG,
c0d0238e:	4a0a      	ldr	r2, [pc, #40]	; (c0d023b8 <u2f_apdu_sign+0xa8>)
c0d02390:	447a      	add	r2, pc
c0d02392:	2302      	movs	r3, #2
c0d02394:	9801      	ldr	r0, [sp, #4]
c0d02396:	9902      	ldr	r1, [sp, #8]
c0d02398:	e7ca      	b.n	c0d02330 <u2f_apdu_sign+0x20>
c0d0239a:	46c0      	nop			; (mov r8, r8)
c0d0239c:	20001a64 	.word	0x20001a64
c0d023a0:	00544e4f 	.word	0x00544e4f
c0d023a4:	200018f8 	.word	0x200018f8
c0d023a8:	20001a66 	.word	0x20001a66
c0d023ac:	20001a5c 	.word	0x20001a5c
c0d023b0:	00002746 	.word	0x00002746
c0d023b4:	0000273c 	.word	0x0000273c
c0d023b8:	000026da 	.word	0x000026da

c0d023bc <u2f_handle_cmd_init>:
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)INFO, sizeof(INFO));
}

void u2f_handle_cmd_init(u2f_service_t *service, uint8_t *buffer,
                         uint16_t length, uint8_t *channelInit) {
c0d023bc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d023be:	b081      	sub	sp, #4
c0d023c0:	461d      	mov	r5, r3
c0d023c2:	460e      	mov	r6, r1
c0d023c4:	4604      	mov	r4, r0
    // screen_printf("U2F init\n");
    uint8_t channel[4];
    (void)length;
    if (u2f_is_channel_broadcast(channelInit)) {
c0d023c6:	4628      	mov	r0, r5
c0d023c8:	f000 fada 	bl	c0d02980 <u2f_is_channel_broadcast>
c0d023cc:	2801      	cmp	r0, #1
c0d023ce:	d104      	bne.n	c0d023da <u2f_handle_cmd_init+0x1e>
c0d023d0:	4668      	mov	r0, sp
        cx_rng(channel, 4);
c0d023d2:	2104      	movs	r1, #4
c0d023d4:	f7ff fe36 	bl	c0d02044 <cx_rng>
c0d023d8:	e004      	b.n	c0d023e4 <u2f_handle_cmd_init+0x28>
c0d023da:	4668      	mov	r0, sp
    } else {
        os_memmove(channel, channelInit, 4);
c0d023dc:	2204      	movs	r2, #4
c0d023de:	4629      	mov	r1, r5
c0d023e0:	f7fe ff03 	bl	c0d011ea <os_memmove>
    }
    os_memmove(G_io_apdu_buffer, buffer, 8);
c0d023e4:	4f17      	ldr	r7, [pc, #92]	; (c0d02444 <u2f_handle_cmd_init+0x88>)
c0d023e6:	2208      	movs	r2, #8
c0d023e8:	4638      	mov	r0, r7
c0d023ea:	4631      	mov	r1, r6
c0d023ec:	f7fe fefd 	bl	c0d011ea <os_memmove>
    os_memmove(G_io_apdu_buffer + 8, channel, 4);
c0d023f0:	4638      	mov	r0, r7
c0d023f2:	3008      	adds	r0, #8
c0d023f4:	4669      	mov	r1, sp
c0d023f6:	2204      	movs	r2, #4
c0d023f8:	f7fe fef7 	bl	c0d011ea <os_memmove>
    G_io_apdu_buffer[12] = INIT_U2F_VERSION;
c0d023fc:	2002      	movs	r0, #2
c0d023fe:	7338      	strb	r0, [r7, #12]
    G_io_apdu_buffer[13] = INIT_DEVICE_VERSION_MAJOR;
c0d02400:	2000      	movs	r0, #0
c0d02402:	7378      	strb	r0, [r7, #13]
c0d02404:	2101      	movs	r1, #1
    G_io_apdu_buffer[14] = INIT_DEVICE_VERSION_MINOR;
c0d02406:	73b9      	strb	r1, [r7, #14]
    G_io_apdu_buffer[15] = INIT_BUILD_VERSION;
c0d02408:	73f8      	strb	r0, [r7, #15]
    G_io_apdu_buffer[16] = INIT_CAPABILITIES;
c0d0240a:	7438      	strb	r0, [r7, #16]

    if (u2f_is_channel_broadcast(channelInit)) {
c0d0240c:	4628      	mov	r0, r5
c0d0240e:	f000 fab7 	bl	c0d02980 <u2f_is_channel_broadcast>
        os_memset(service->channel, 0xff, 4);
c0d02412:	2586      	movs	r5, #134	; 0x86
    G_io_apdu_buffer[13] = INIT_DEVICE_VERSION_MAJOR;
    G_io_apdu_buffer[14] = INIT_DEVICE_VERSION_MINOR;
    G_io_apdu_buffer[15] = INIT_BUILD_VERSION;
    G_io_apdu_buffer[16] = INIT_CAPABILITIES;

    if (u2f_is_channel_broadcast(channelInit)) {
c0d02414:	2801      	cmp	r0, #1
c0d02416:	d107      	bne.n	c0d02428 <u2f_handle_cmd_init+0x6c>
        os_memset(service->channel, 0xff, 4);
c0d02418:	4628      	mov	r0, r5
c0d0241a:	3079      	adds	r0, #121	; 0x79
c0d0241c:	b2c1      	uxtb	r1, r0
c0d0241e:	2204      	movs	r2, #4
c0d02420:	4620      	mov	r0, r4
c0d02422:	f7fe fed9 	bl	c0d011d8 <os_memset>
c0d02426:	e004      	b.n	c0d02432 <u2f_handle_cmd_init+0x76>
c0d02428:	4669      	mov	r1, sp
    } else {
        os_memmove(service->channel, channel, 4);
c0d0242a:	2204      	movs	r2, #4
c0d0242c:	4620      	mov	r0, r4
c0d0242e:	f7fe fedc 	bl	c0d011ea <os_memmove>
    }
    u2f_message_reply(service, U2F_CMD_INIT, G_io_apdu_buffer, 17);
c0d02432:	4a04      	ldr	r2, [pc, #16]	; (c0d02444 <u2f_handle_cmd_init+0x88>)
c0d02434:	2311      	movs	r3, #17
c0d02436:	4620      	mov	r0, r4
c0d02438:	4629      	mov	r1, r5
c0d0243a:	f000 fab1 	bl	c0d029a0 <u2f_message_reply>
}
c0d0243e:	b001      	add	sp, #4
c0d02440:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02442:	46c0      	nop			; (mov r8, r8)
c0d02444:	200018f8 	.word	0x200018f8

c0d02448 <u2f_handle_cmd_msg>:
    // screen_printf("U2F ping\n");
    u2f_message_reply(service, U2F_CMD_PING, buffer, length);
}

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
c0d02448:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0244a:	b083      	sub	sp, #12
c0d0244c:	460b      	mov	r3, r1
c0d0244e:	9002      	str	r0, [sp, #8]
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
c0d02450:	7998      	ldrb	r0, [r3, #6]
c0d02452:	7959      	ldrb	r1, [r3, #5]
c0d02454:	020f      	lsls	r7, r1, #8
c0d02456:	4307      	orrs	r7, r0

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
c0d02458:	7859      	ldrb	r1, [r3, #1]
}

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
c0d0245a:	781e      	ldrb	r6, [r3, #0]
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
c0d0245c:	4615      	mov	r5, r2
c0d0245e:	3d09      	subs	r5, #9
c0d02460:	b2a8      	uxth	r0, r5
        u2f_apdu_get_info(service, p1, p2, buffer + 7, dataLength);
        break;

    default:
        // screen_printf("unsupported\n");
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02462:	2483      	movs	r4, #131	; 0x83
c0d02464:	9401      	str	r4, [sp, #4]
c0d02466:	4c1f      	ldr	r4, [pc, #124]	; (c0d024e4 <u2f_handle_cmd_msg+0x9c>)
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
c0d02468:	4287      	cmp	r7, r0
c0d0246a:	d003      	beq.n	c0d02474 <u2f_handle_cmd_msg+0x2c>
c0d0246c:	1fd2      	subs	r2, r2, #7
c0d0246e:	4014      	ands	r4, r2
c0d02470:	42a7      	cmp	r7, r4
c0d02472:	d11b      	bne.n	c0d024ac <u2f_handle_cmd_msg+0x64>
c0d02474:	463d      	mov	r5, r7
                  (uint8_t *)SW_WRONG_LENGTH,
                  sizeof(SW_WRONG_LENGTH));
        return;
    }

    if (cla != FIDO_CLA) {
c0d02476:	2e00      	cmp	r6, #0
c0d02478:	d008      	beq.n	c0d0248c <u2f_handle_cmd_msg+0x44>
        u2f_message_reply(service, U2F_CMD_MSG,
c0d0247a:	4a1b      	ldr	r2, [pc, #108]	; (c0d024e8 <u2f_handle_cmd_msg+0xa0>)
c0d0247c:	447a      	add	r2, pc
c0d0247e:	2302      	movs	r3, #2
c0d02480:	9802      	ldr	r0, [sp, #8]
c0d02482:	9901      	ldr	r1, [sp, #4]
c0d02484:	f000 fa8c 	bl	c0d029a0 <u2f_message_reply>
        u2f_message_reply(service, U2F_CMD_MSG,
                 (uint8_t *)SW_UNKNOWN_INSTRUCTION,
                 sizeof(SW_UNKNOWN_INSTRUCTION));
        return;
    }
}
c0d02488:	b003      	add	sp, #12
c0d0248a:	bdf0      	pop	{r4, r5, r6, r7, pc}
        u2f_message_reply(service, U2F_CMD_MSG,
                  (uint8_t *)SW_UNKNOWN_CLASS,
                  sizeof(SW_UNKNOWN_CLASS));
        return;
    }
    switch (ins) {
c0d0248c:	2902      	cmp	r1, #2
c0d0248e:	dc17      	bgt.n	c0d024c0 <u2f_handle_cmd_msg+0x78>
c0d02490:	2901      	cmp	r1, #1
c0d02492:	d020      	beq.n	c0d024d6 <u2f_handle_cmd_msg+0x8e>
c0d02494:	2902      	cmp	r1, #2
c0d02496:	d11b      	bne.n	c0d024d0 <u2f_handle_cmd_msg+0x88>
        // screen_printf("enroll\n");
        u2f_apdu_enroll(service, p1, p2, buffer + 7, dataLength);
        break;
    case FIDO_INS_SIGN:
        // screen_printf("sign\n");
        u2f_apdu_sign(service, p1, p2, buffer + 7, dataLength);
c0d02498:	b2a8      	uxth	r0, r5
c0d0249a:	4669      	mov	r1, sp
c0d0249c:	6008      	str	r0, [r1, #0]
c0d0249e:	1ddb      	adds	r3, r3, #7
c0d024a0:	2100      	movs	r1, #0
c0d024a2:	9802      	ldr	r0, [sp, #8]
c0d024a4:	460a      	mov	r2, r1
c0d024a6:	f7ff ff33 	bl	c0d02310 <u2f_apdu_sign>
c0d024aa:	e7ed      	b.n	c0d02488 <u2f_handle_cmd_msg+0x40>
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
        // Le is optional
        // nominal case from the specification
    }
    // circumvent google chrome extended length encoding done on the last byte only (module 256) but all data being transferred
    else if (dataLength == (uint16_t)(length - 9)%256) {
c0d024ac:	b2e8      	uxtb	r0, r5
c0d024ae:	4287      	cmp	r7, r0
c0d024b0:	d0e1      	beq.n	c0d02476 <u2f_handle_cmd_msg+0x2e>
        dataLength = length - 9;
    }
    else if (dataLength == (uint16_t)(length - 7)%256) {
c0d024b2:	b2d0      	uxtb	r0, r2
c0d024b4:	4287      	cmp	r7, r0
c0d024b6:	4615      	mov	r5, r2
c0d024b8:	d0dd      	beq.n	c0d02476 <u2f_handle_cmd_msg+0x2e>
        dataLength = length - 7;
    }    
    else { 
        // invalid size
        u2f_message_reply(service, U2F_CMD_MSG,
c0d024ba:	4a0c      	ldr	r2, [pc, #48]	; (c0d024ec <u2f_handle_cmd_msg+0xa4>)
c0d024bc:	447a      	add	r2, pc
c0d024be:	e7de      	b.n	c0d0247e <u2f_handle_cmd_msg+0x36>
c0d024c0:	2903      	cmp	r1, #3
c0d024c2:	d00b      	beq.n	c0d024dc <u2f_handle_cmd_msg+0x94>
c0d024c4:	29c1      	cmp	r1, #193	; 0xc1
c0d024c6:	d103      	bne.n	c0d024d0 <u2f_handle_cmd_msg+0x88>
                            uint8_t *buffer, uint16_t length) {
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)INFO, sizeof(INFO));
c0d024c8:	4a09      	ldr	r2, [pc, #36]	; (c0d024f0 <u2f_handle_cmd_msg+0xa8>)
c0d024ca:	447a      	add	r2, pc
c0d024cc:	2304      	movs	r3, #4
c0d024ce:	e7d7      	b.n	c0d02480 <u2f_handle_cmd_msg+0x38>
        u2f_apdu_get_info(service, p1, p2, buffer + 7, dataLength);
        break;

    default:
        // screen_printf("unsupported\n");
        u2f_message_reply(service, U2F_CMD_MSG,
c0d024d0:	4a0a      	ldr	r2, [pc, #40]	; (c0d024fc <u2f_handle_cmd_msg+0xb4>)
c0d024d2:	447a      	add	r2, pc
c0d024d4:	e7d3      	b.n	c0d0247e <u2f_handle_cmd_msg+0x36>
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);

    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)SW_INTERNAL, sizeof(SW_INTERNAL));
c0d024d6:	4a07      	ldr	r2, [pc, #28]	; (c0d024f4 <u2f_handle_cmd_msg+0xac>)
c0d024d8:	447a      	add	r2, pc
c0d024da:	e7d0      	b.n	c0d0247e <u2f_handle_cmd_msg+0x36>
    // screen_printf("U2F version\n");
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)U2F_VERSION, sizeof(U2F_VERSION));
c0d024dc:	4a06      	ldr	r2, [pc, #24]	; (c0d024f8 <u2f_handle_cmd_msg+0xb0>)
c0d024de:	447a      	add	r2, pc
c0d024e0:	2308      	movs	r3, #8
c0d024e2:	e7cd      	b.n	c0d02480 <u2f_handle_cmd_msg+0x38>
c0d024e4:	0000ffff 	.word	0x0000ffff
c0d024e8:	000025fc 	.word	0x000025fc
c0d024ec:	000025ac 	.word	0x000025ac
c0d024f0:	000025aa 	.word	0x000025aa
c0d024f4:	0000258c 	.word	0x0000258c
c0d024f8:	0000258e 	.word	0x0000258e
c0d024fc:	000025a8 	.word	0x000025a8

c0d02500 <u2f_message_complete>:
                 sizeof(SW_UNKNOWN_INSTRUCTION));
        return;
    }
}

void u2f_message_complete(u2f_service_t *service) {
c0d02500:	b580      	push	{r7, lr}
    uint8_t cmd = service->transportBuffer[0];
c0d02502:	6981      	ldr	r1, [r0, #24]
    uint16_t length = (service->transportBuffer[1] << 8) | (service->transportBuffer[2]);
c0d02504:	788a      	ldrb	r2, [r1, #2]
c0d02506:	784b      	ldrb	r3, [r1, #1]
c0d02508:	021b      	lsls	r3, r3, #8
c0d0250a:	4313      	orrs	r3, r2
        return;
    }
}

void u2f_message_complete(u2f_service_t *service) {
    uint8_t cmd = service->transportBuffer[0];
c0d0250c:	780a      	ldrb	r2, [r1, #0]
    uint16_t length = (service->transportBuffer[1] << 8) | (service->transportBuffer[2]);
    switch (cmd) {
c0d0250e:	2a81      	cmp	r2, #129	; 0x81
c0d02510:	d009      	beq.n	c0d02526 <u2f_message_complete+0x26>
c0d02512:	2a83      	cmp	r2, #131	; 0x83
c0d02514:	d00c      	beq.n	c0d02530 <u2f_message_complete+0x30>
c0d02516:	2a86      	cmp	r2, #134	; 0x86
c0d02518:	d10e      	bne.n	c0d02538 <u2f_message_complete+0x38>
    case U2F_CMD_INIT:
        u2f_handle_cmd_init(service, service->transportBuffer + 3, length, service->channel);
c0d0251a:	1cc9      	adds	r1, r1, #3
c0d0251c:	2200      	movs	r2, #0
c0d0251e:	4603      	mov	r3, r0
c0d02520:	f7ff ff4c 	bl	c0d023bc <u2f_handle_cmd_init>
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
        break;
    }
}
c0d02524:	bd80      	pop	{r7, pc}
    switch (cmd) {
    case U2F_CMD_INIT:
        u2f_handle_cmd_init(service, service->transportBuffer + 3, length, service->channel);
        break;
    case U2F_CMD_PING:
        u2f_handle_cmd_ping(service, service->transportBuffer + 3, length);
c0d02526:	1cca      	adds	r2, r1, #3
}

void u2f_handle_cmd_ping(u2f_service_t *service, uint8_t *buffer,
                         uint16_t length) {
    // screen_printf("U2F ping\n");
    u2f_message_reply(service, U2F_CMD_PING, buffer, length);
c0d02528:	2181      	movs	r1, #129	; 0x81
c0d0252a:	f000 fa39 	bl	c0d029a0 <u2f_message_reply>
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
        break;
    }
}
c0d0252e:	bd80      	pop	{r7, pc}
        break;
    case U2F_CMD_PING:
        u2f_handle_cmd_ping(service, service->transportBuffer + 3, length);
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
c0d02530:	1cc9      	adds	r1, r1, #3
c0d02532:	461a      	mov	r2, r3
c0d02534:	f7ff ff88 	bl	c0d02448 <u2f_handle_cmd_msg>
        break;
    }
}
c0d02538:	bd80      	pop	{r7, pc}
	...

c0d0253c <u2f_io_send>:
#include "u2f_processing.h"
#include "u2f_impl.h"

#include "os_io_seproxyhal.h"

void u2f_io_send(uint8_t *buffer, uint16_t length, u2f_transport_media_t media) {
c0d0253c:	b570      	push	{r4, r5, r6, lr}
c0d0253e:	460d      	mov	r5, r1
c0d02540:	4601      	mov	r1, r0
    if (media == U2F_MEDIA_USB) {
c0d02542:	2a01      	cmp	r2, #1
c0d02544:	d111      	bne.n	c0d0256a <u2f_io_send+0x2e>
        os_memmove(G_io_usb_ep_buffer, buffer, length);
c0d02546:	4c09      	ldr	r4, [pc, #36]	; (c0d0256c <u2f_io_send+0x30>)
c0d02548:	4620      	mov	r0, r4
c0d0254a:	462a      	mov	r2, r5
c0d0254c:	f7fe fe4d 	bl	c0d011ea <os_memmove>
        // wipe the remaining to avoid :
        // 1/ data leaks
        // 2/ invalid junk
        os_memset(G_io_usb_ep_buffer+length, 0, sizeof(G_io_usb_ep_buffer)-length);
c0d02550:	1960      	adds	r0, r4, r5
c0d02552:	2640      	movs	r6, #64	; 0x40
c0d02554:	1b72      	subs	r2, r6, r5
c0d02556:	2500      	movs	r5, #0
c0d02558:	4629      	mov	r1, r5
c0d0255a:	f7fe fe3d 	bl	c0d011d8 <os_memset>
    }
    switch (media) {
    case U2F_MEDIA_USB:
        io_usb_send_ep(U2F_EPIN_ADDR, G_io_usb_ep_buffer, USB_SEGMENT_SIZE, 0);
c0d0255e:	2081      	movs	r0, #129	; 0x81
c0d02560:	4621      	mov	r1, r4
c0d02562:	4632      	mov	r2, r6
c0d02564:	462b      	mov	r3, r5
c0d02566:	f7fe ff73 	bl	c0d01450 <io_usb_send_ep>
#endif
    default:
        PRINTF("Request to send on unsupported media %d\n", media);
        break;
    }
}
c0d0256a:	bd70      	pop	{r4, r5, r6, pc}
c0d0256c:	20001ab0 	.word	0x20001ab0

c0d02570 <u2f_transport_init>:

/**
 * Initialize the u2f transport and provide the buffer into which to store incoming message
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
c0d02570:	6081      	str	r1, [r0, #8]
    service->transportReceiveBufferLength = message_buffer_length;
c0d02572:	8182      	strh	r2, [r0, #12]
c0d02574:	2200      	movs	r2, #0

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d02576:	7702      	strb	r2, [r0, #28]
    service->transportOffset = 0;
c0d02578:	8242      	strh	r2, [r0, #18]
    service->transportMedia = 0;
c0d0257a:	7742      	strb	r2, [r0, #29]
    service->transportPacketIndex = 0;
c0d0257c:	7582      	strb	r2, [r0, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d0257e:	6181      	str	r1, [r0, #24]
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
    service->transportReceiveBufferLength = message_buffer_length;
    u2f_transport_reset(service);
}
c0d02580:	4770      	bx	lr
	...

c0d02584 <u2f_transport_sent>:

/**
 * Function called when the previously scheduled message to be sent on the media is effectively sent.
 * And a new message can be scheduled.
 */
void u2f_transport_sent(u2f_service_t* service, u2f_transport_media_t media) {
c0d02584:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02586:	b083      	sub	sp, #12
c0d02588:	4604      	mov	r4, r0
    // if idle (possibly after an error), then only await for a transmission 
    if (service->transportState != U2F_SENDING_RESPONSE 
c0d0258a:	7f20      	ldrb	r0, [r4, #28]
        && service->transportState != U2F_SENDING_ERROR) {
c0d0258c:	1ec0      	subs	r0, r0, #3
c0d0258e:	b2c0      	uxtb	r0, r0
c0d02590:	2801      	cmp	r0, #1
c0d02592:	d854      	bhi.n	c0d0263e <u2f_transport_sent+0xba>
        // absorb the error, transport is erroneous but that won't hurt in the end.
        //THROW(INVALID_STATE);
        return;
    }
    if (service->transportOffset < service->transportLength) {
c0d02594:	8aa6      	ldrh	r6, [r4, #20]
c0d02596:	8a62      	ldrh	r2, [r4, #18]
c0d02598:	4296      	cmp	r6, r2
c0d0259a:	d923      	bls.n	c0d025e4 <u2f_transport_sent+0x60>
        uint16_t mtu = (media == U2F_MEDIA_USB) ? USB_SEGMENT_SIZE : BLE_SEGMENT_SIZE;
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
c0d0259c:	2304      	movs	r3, #4
c0d0259e:	2000      	movs	r0, #0
c0d025a0:	9102      	str	r1, [sp, #8]
c0d025a2:	2901      	cmp	r1, #1
c0d025a4:	d000      	beq.n	c0d025a8 <u2f_transport_sent+0x24>
c0d025a6:	4603      	mov	r3, r0
c0d025a8:	9001      	str	r0, [sp, #4]
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
c0d025aa:	7da0      	ldrb	r0, [r4, #22]
c0d025ac:	2703      	movs	r7, #3
c0d025ae:	2501      	movs	r5, #1
c0d025b0:	2800      	cmp	r0, #0
c0d025b2:	d000      	beq.n	c0d025b6 <u2f_transport_sent+0x32>
c0d025b4:	462f      	mov	r7, r5
c0d025b6:	431f      	orrs	r7, r3
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
                                      (mtu - headerSize)
c0d025b8:	2340      	movs	r3, #64	; 0x40
c0d025ba:	1bdd      	subs	r5, r3, r7
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
c0d025bc:	1ab1      	subs	r1, r6, r2
c0d025be:	42a9      	cmp	r1, r5
c0d025c0:	dc00      	bgt.n	c0d025c4 <u2f_transport_sent+0x40>
c0d025c2:	460d      	mov	r5, r1
                                      (mtu - headerSize)
                                  ? (mtu - headerSize)
                                  : service->transportLength - service->transportOffset);
        uint16_t dataSize = blockSize + headerSize;
c0d025c4:	19ee      	adds	r6, r5, r7
        uint16_t offset = 0;
        // Fragment
        if (media == U2F_MEDIA_USB) {
c0d025c6:	9902      	ldr	r1, [sp, #8]
c0d025c8:	2901      	cmp	r1, #1
c0d025ca:	d106      	bne.n	c0d025da <u2f_transport_sent+0x56>
            os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d025cc:	481d      	ldr	r0, [pc, #116]	; (c0d02644 <u2f_transport_sent+0xc0>)
c0d025ce:	2204      	movs	r2, #4
c0d025d0:	4621      	mov	r1, r4
c0d025d2:	9201      	str	r2, [sp, #4]
c0d025d4:	f7fe fe09 	bl	c0d011ea <os_memmove>
c0d025d8:	7da0      	ldrb	r0, [r4, #22]
            offset += 4;
        }
        if (service->transportPacketIndex == 0) {
c0d025da:	2800      	cmp	r0, #0
c0d025dc:	d00b      	beq.n	c0d025f6 <u2f_transport_sent+0x72>
            G_io_usb_ep_buffer[offset++] = service->sendCmd;
            G_io_usb_ep_buffer[offset++] = (service->transportLength >> 8);
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
c0d025de:	30ff      	adds	r0, #255	; 0xff
c0d025e0:	9901      	ldr	r1, [sp, #4]
c0d025e2:	e015      	b.n	c0d02610 <u2f_transport_sent+0x8c>
c0d025e4:	d12b      	bne.n	c0d0263e <u2f_transport_sent+0xba>
c0d025e6:	2000      	movs	r0, #0

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d025e8:	7720      	strb	r0, [r4, #28]
    service->transportOffset = 0;
c0d025ea:	8260      	strh	r0, [r4, #18]
    service->transportMedia = 0;
c0d025ec:	7760      	strb	r0, [r4, #29]
    service->transportPacketIndex = 0;
c0d025ee:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d025f0:	68a0      	ldr	r0, [r4, #8]
c0d025f2:	61a0      	str	r0, [r4, #24]
c0d025f4:	e023      	b.n	c0d0263e <u2f_transport_sent+0xba>
        if (media == U2F_MEDIA_USB) {
            os_memmove(G_io_usb_ep_buffer, service->channel, 4);
            offset += 4;
        }
        if (service->transportPacketIndex == 0) {
            G_io_usb_ep_buffer[offset++] = service->sendCmd;
c0d025f6:	2034      	movs	r0, #52	; 0x34
c0d025f8:	5c20      	ldrb	r0, [r4, r0]
c0d025fa:	9b01      	ldr	r3, [sp, #4]
c0d025fc:	b299      	uxth	r1, r3
c0d025fe:	4a11      	ldr	r2, [pc, #68]	; (c0d02644 <u2f_transport_sent+0xc0>)
c0d02600:	5450      	strb	r0, [r2, r1]
c0d02602:	2001      	movs	r0, #1
c0d02604:	4318      	orrs	r0, r3
            G_io_usb_ep_buffer[offset++] = (service->transportLength >> 8);
c0d02606:	b281      	uxth	r1, r0
c0d02608:	7d63      	ldrb	r3, [r4, #21]
c0d0260a:	5453      	strb	r3, [r2, r1]
c0d0260c:	1c41      	adds	r1, r0, #1
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
c0d0260e:	7d20      	ldrb	r0, [r4, #20]
c0d02610:	b289      	uxth	r1, r1
c0d02612:	4b0c      	ldr	r3, [pc, #48]	; (c0d02644 <u2f_transport_sent+0xc0>)
c0d02614:	5458      	strb	r0, [r3, r1]
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
c0d02616:	69a1      	ldr	r1, [r4, #24]
c0d02618:	2900      	cmp	r1, #0
c0d0261a:	d005      	beq.n	c0d02628 <u2f_transport_sent+0xa4>
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
                                      (mtu - headerSize)
                                  ? (mtu - headerSize)
                                  : service->transportLength - service->transportOffset);
        uint16_t dataSize = blockSize + headerSize;
c0d0261c:	b2aa      	uxth	r2, r5
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
            os_memmove(G_io_usb_ep_buffer + headerSize,
c0d0261e:	19d8      	adds	r0, r3, r7
                       service->transportBuffer + service->transportOffset, blockSize);
c0d02620:	8a63      	ldrh	r3, [r4, #18]
c0d02622:	18c9      	adds	r1, r1, r3
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
            os_memmove(G_io_usb_ep_buffer + headerSize,
c0d02624:	f7fe fde1 	bl	c0d011ea <os_memmove>
                       service->transportBuffer + service->transportOffset, blockSize);
        }
        service->transportOffset += blockSize;
c0d02628:	8a60      	ldrh	r0, [r4, #18]
c0d0262a:	1940      	adds	r0, r0, r5
c0d0262c:	8260      	strh	r0, [r4, #18]
        service->transportPacketIndex++;
c0d0262e:	7da0      	ldrb	r0, [r4, #22]
c0d02630:	1c40      	adds	r0, r0, #1
c0d02632:	75a0      	strb	r0, [r4, #22]
        u2f_io_send(G_io_usb_ep_buffer, dataSize, media);
c0d02634:	b2b1      	uxth	r1, r6
c0d02636:	4803      	ldr	r0, [pc, #12]	; (c0d02644 <u2f_transport_sent+0xc0>)
c0d02638:	9a02      	ldr	r2, [sp, #8]
c0d0263a:	f7ff ff7f 	bl	c0d0253c <u2f_io_send>
    // the first call is meant to setup the first part for sending.
    // cannot be considered as the msg sent event.
    else if (service->transportOffset == service->transportLength) {
        u2f_transport_reset(service);
    }
}
c0d0263e:	b003      	add	sp, #12
c0d02640:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02642:	46c0      	nop			; (mov r8, r8)
c0d02644:	20001ab0 	.word	0x20001ab0

c0d02648 <u2f_transport_received>:
/** 
 * Function that process every message received on a media.
 * Performs message concatenation when message is splitted.
 */
void u2f_transport_received(u2f_service_t *service, uint8_t *buffer,
                          uint16_t size, u2f_transport_media_t media) {
c0d02648:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0264a:	b089      	sub	sp, #36	; 0x24
c0d0264c:	461e      	mov	r6, r3
c0d0264e:	4604      	mov	r4, r0
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
    uint16_t xfer_len;
    service->media = media;
c0d02650:	7126      	strb	r6, [r4, #4]
c0d02652:	7f20      	ldrb	r0, [r4, #28]
    // If busy, answer immediately, avoid reentry
    if ((service->transportState == U2F_PROCESSING_COMMAND) ||
c0d02654:	1e83      	subs	r3, r0, #2
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        // check this is a command, cannot accept continuation without previous command
        if ((buffer[channelHeader+0]&U2F_MASK_COMMAND) == 0) {
c0d02656:	2585      	movs	r5, #133	; 0x85
                          uint16_t size, u2f_transport_media_t media) {
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
    uint16_t xfer_len;
    service->media = media;
    // If busy, answer immediately, avoid reentry
    if ((service->transportState == U2F_PROCESSING_COMMAND) ||
c0d02658:	9508      	str	r5, [sp, #32]
c0d0265a:	2b02      	cmp	r3, #2
c0d0265c:	d210      	bcs.n	c0d02680 <u2f_transport_received+0x38>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0265e:	48c3      	ldr	r0, [pc, #780]	; (c0d0296c <u2f_transport_received+0x324>)
c0d02660:	2106      	movs	r1, #6
c0d02662:	7201      	strb	r1, [r0, #8]
c0d02664:	2104      	movs	r1, #4

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d02666:	7721      	strb	r1, [r4, #28]
c0d02668:	2100      	movs	r1, #0
    service->transportPacketIndex = 0;
c0d0266a:	75a1      	strb	r1, [r4, #22]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0266c:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d0266e:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d02670:	8261      	strh	r1, [r4, #18]
    service->transportLength = 1;
c0d02672:	2001      	movs	r0, #1
c0d02674:	82a0      	strh	r0, [r4, #20]
c0d02676:	9908      	ldr	r1, [sp, #32]
c0d02678:	313a      	adds	r1, #58	; 0x3a
c0d0267a:	2034      	movs	r0, #52	; 0x34
c0d0267c:	5421      	strb	r1, [r4, r0]
c0d0267e:	e063      	b.n	c0d02748 <u2f_transport_received+0x100>
c0d02680:	2804      	cmp	r0, #4
c0d02682:	d106      	bne.n	c0d02692 <u2f_transport_received+0x4a>
c0d02684:	2000      	movs	r0, #0

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d02686:	7720      	strb	r0, [r4, #28]
    service->transportOffset = 0;
c0d02688:	8260      	strh	r0, [r4, #18]
    service->transportMedia = 0;
c0d0268a:	7760      	strb	r0, [r4, #29]
    service->transportPacketIndex = 0;
c0d0268c:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d0268e:	68a0      	ldr	r0, [r4, #8]
c0d02690:	61a0      	str	r0, [r4, #24]
c0d02692:	9107      	str	r1, [sp, #28]
    // SENDING_ERROR is accepted, and triggers a reset => means the host hasn't consumed the error.
    if (service->transportState == U2F_SENDING_ERROR) {
        u2f_transport_reset(service);
    }

    if (size < (1 + channelHeader)) {
c0d02694:	2104      	movs	r1, #4
c0d02696:	2000      	movs	r0, #0
c0d02698:	2e01      	cmp	r6, #1
c0d0269a:	d000      	beq.n	c0d0269e <u2f_transport_received+0x56>
c0d0269c:	4601      	mov	r1, r0
c0d0269e:	2301      	movs	r3, #1
c0d026a0:	460d      	mov	r5, r1
c0d026a2:	431d      	orrs	r5, r3
c0d026a4:	42aa      	cmp	r2, r5
c0d026a6:	d341      	bcc.n	c0d0272c <u2f_transport_received+0xe4>
c0d026a8:	9106      	str	r1, [sp, #24]
        // Message to short, abort
        u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
        goto error;
    }
    if (media == U2F_MEDIA_USB) {
c0d026aa:	2e01      	cmp	r6, #1
c0d026ac:	9205      	str	r2, [sp, #20]
c0d026ae:	d109      	bne.n	c0d026c4 <u2f_transport_received+0x7c>
        // hold the current channel value to reply to, for example, INIT commands within flow of segments.
        os_memmove(service->channel, buffer, 4);
c0d026b0:	2204      	movs	r2, #4
c0d026b2:	4620      	mov	r0, r4
c0d026b4:	9907      	ldr	r1, [sp, #28]
c0d026b6:	9604      	str	r6, [sp, #16]
c0d026b8:	461f      	mov	r7, r3
c0d026ba:	f7fe fd96 	bl	c0d011ea <os_memmove>
c0d026be:	9a05      	ldr	r2, [sp, #20]
c0d026c0:	463b      	mov	r3, r7
c0d026c2:	9e04      	ldr	r6, [sp, #16]
    }

    // no previous chunk processed for the current message
    if (service->transportOffset == 0
c0d026c4:	8a60      	ldrh	r0, [r4, #18]
c0d026c6:	49aa      	ldr	r1, [pc, #680]	; (c0d02970 <u2f_transport_received+0x328>)
        // on USB we could get an INIT within a flow of segments.
        || (media == U2F_MEDIA_USB && os_memcmp(service->transportChannel, service->channel, 4) != 0) ) {
c0d026c8:	2800      	cmp	r0, #0
c0d026ca:	9103      	str	r1, [sp, #12]
c0d026cc:	d00e      	beq.n	c0d026ec <u2f_transport_received+0xa4>
c0d026ce:	2e01      	cmp	r6, #1
c0d026d0:	d127      	bne.n	c0d02722 <u2f_transport_received+0xda>
c0d026d2:	4620      	mov	r0, r4
c0d026d4:	300e      	adds	r0, #14
c0d026d6:	2204      	movs	r2, #4
c0d026d8:	4621      	mov	r1, r4
c0d026da:	9604      	str	r6, [sp, #16]
c0d026dc:	461f      	mov	r7, r3
c0d026de:	f7fe fe21 	bl	c0d01324 <os_memcmp>
c0d026e2:	9a05      	ldr	r2, [sp, #20]
c0d026e4:	463b      	mov	r3, r7
c0d026e6:	9e04      	ldr	r6, [sp, #16]
        // hold the current channel value to reply to, for example, INIT commands within flow of segments.
        os_memmove(service->channel, buffer, 4);
    }

    // no previous chunk processed for the current message
    if (service->transportOffset == 0
c0d026e8:	2800      	cmp	r0, #0
c0d026ea:	d01a      	beq.n	c0d02722 <u2f_transport_received+0xda>
        // on USB we could get an INIT within a flow of segments.
        || (media == U2F_MEDIA_USB && os_memcmp(service->transportChannel, service->channel, 4) != 0) ) {
        if (size < (channelHeader + 3)) {
c0d026ec:	2703      	movs	r7, #3
c0d026ee:	9906      	ldr	r1, [sp, #24]
c0d026f0:	4608      	mov	r0, r1
c0d026f2:	4338      	orrs	r0, r7
c0d026f4:	4282      	cmp	r2, r0
c0d026f6:	d319      	bcc.n	c0d0272c <u2f_transport_received+0xe4>
c0d026f8:	9704      	str	r7, [sp, #16]
c0d026fa:	9807      	ldr	r0, [sp, #28]
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        // check this is a command, cannot accept continuation without previous command
        if ((buffer[channelHeader+0]&U2F_MASK_COMMAND) == 0) {
c0d026fc:	1847      	adds	r7, r0, r1
c0d026fe:	9702      	str	r7, [sp, #8]
c0d02700:	5640      	ldrsb	r0, [r0, r1]
c0d02702:	9908      	ldr	r1, [sp, #32]
c0d02704:	317a      	adds	r1, #122	; 0x7a
c0d02706:	b249      	sxtb	r1, r1
c0d02708:	4288      	cmp	r0, r1
c0d0270a:	dd3c      	ble.n	c0d02786 <u2f_transport_received+0x13e>
c0d0270c:	4897      	ldr	r0, [pc, #604]	; (c0d0296c <u2f_transport_received+0x324>)
c0d0270e:	2104      	movs	r1, #4
c0d02710:	7201      	strb	r1, [r0, #8]
c0d02712:	7721      	strb	r1, [r4, #28]
c0d02714:	2100      	movs	r1, #0
c0d02716:	75a1      	strb	r1, [r4, #22]
c0d02718:	3008      	adds	r0, #8
c0d0271a:	61a0      	str	r0, [r4, #24]
c0d0271c:	8261      	strh	r1, [r4, #18]
c0d0271e:	82a3      	strh	r3, [r4, #20]
c0d02720:	e7a9      	b.n	c0d02676 <u2f_transport_received+0x2e>
c0d02722:	2002      	movs	r0, #2
        }
    } else {


        // Continuation
        if (size < (channelHeader + 2)) {
c0d02724:	9906      	ldr	r1, [sp, #24]
c0d02726:	4308      	orrs	r0, r1
c0d02728:	4282      	cmp	r2, r0
c0d0272a:	d213      	bcs.n	c0d02754 <u2f_transport_received+0x10c>
c0d0272c:	488f      	ldr	r0, [pc, #572]	; (c0d0296c <u2f_transport_received+0x324>)
c0d0272e:	9a08      	ldr	r2, [sp, #32]
c0d02730:	7202      	strb	r2, [r0, #8]
c0d02732:	2104      	movs	r1, #4
c0d02734:	7721      	strb	r1, [r4, #28]
c0d02736:	2100      	movs	r1, #0
c0d02738:	75a1      	strb	r1, [r4, #22]
c0d0273a:	3008      	adds	r0, #8
c0d0273c:	61a0      	str	r0, [r4, #24]
c0d0273e:	8261      	strh	r1, [r4, #18]
c0d02740:	82a3      	strh	r3, [r4, #20]
c0d02742:	323a      	adds	r2, #58	; 0x3a
c0d02744:	2034      	movs	r0, #52	; 0x34
c0d02746:	5422      	strb	r2, [r4, r0]
c0d02748:	7921      	ldrb	r1, [r4, #4]
c0d0274a:	4620      	mov	r0, r4
c0d0274c:	f7ff ff1a 	bl	c0d02584 <u2f_transport_sent>
        service->seqTimeout = 0;
        service->transportState = U2F_HANDLE_SEGMENTED;
    }
error:
    return;
}
c0d02750:	b009      	add	sp, #36	; 0x24
c0d02752:	bdf0      	pop	{r4, r5, r6, r7, pc}
        if (size < (channelHeader + 2)) {
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        if (media != service->transportMedia) {
c0d02754:	7f60      	ldrb	r0, [r4, #29]
c0d02756:	42b0      	cmp	r0, r6
c0d02758:	d148      	bne.n	c0d027ec <u2f_transport_received+0x1a4>
            // Mixed medias
            u2f_transport_error(service, ERROR_PROP_MEDIA_MIXED);
            goto error;
        }
        if (service->transportState != U2F_HANDLE_SEGMENTED) {
c0d0275a:	7f20      	ldrb	r0, [r4, #28]
c0d0275c:	2801      	cmp	r0, #1
c0d0275e:	d152      	bne.n	c0d02806 <u2f_transport_received+0x1be>
            } else {
                u2f_transport_error(service, ERROR_INVALID_SEQ);
                goto error;
            }
        }
        if (media == U2F_MEDIA_USB) {
c0d02760:	2e01      	cmp	r6, #1
c0d02762:	d175      	bne.n	c0d02850 <u2f_transport_received+0x208>
            // Check the channel
            if (os_memcmp(buffer, service->channel, 4) != 0) {
c0d02764:	2204      	movs	r2, #4
c0d02766:	9807      	ldr	r0, [sp, #28]
c0d02768:	4621      	mov	r1, r4
c0d0276a:	9202      	str	r2, [sp, #8]
c0d0276c:	9604      	str	r6, [sp, #16]
c0d0276e:	461f      	mov	r7, r3
c0d02770:	f7fe fdd8 	bl	c0d01324 <os_memcmp>
c0d02774:	463b      	mov	r3, r7
c0d02776:	9e04      	ldr	r6, [sp, #16]
c0d02778:	2800      	cmp	r0, #0
c0d0277a:	d069      	beq.n	c0d02850 <u2f_transport_received+0x208>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0277c:	487b      	ldr	r0, [pc, #492]	; (c0d0296c <u2f_transport_received+0x324>)
c0d0277e:	2106      	movs	r1, #6
c0d02780:	7201      	strb	r1, [r0, #8]

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d02782:	9902      	ldr	r1, [sp, #8]
c0d02784:	e7c5      	b.n	c0d02712 <u2f_transport_received+0xca>
c0d02786:	9301      	str	r3, [sp, #4]
            goto error;
        }

        // If waiting for a continuation on a different channel, reply BUSY
        // immediately
        if (media == U2F_MEDIA_USB) {
c0d02788:	2e01      	cmp	r6, #1
c0d0278a:	9f04      	ldr	r7, [sp, #16]
c0d0278c:	d112      	bne.n	c0d027b4 <u2f_transport_received+0x16c>
            if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d0278e:	7f20      	ldrb	r0, [r4, #28]
c0d02790:	2801      	cmp	r0, #1
c0d02792:	d11b      	bne.n	c0d027cc <u2f_transport_received+0x184>
                (os_memcmp(service->channel, service->transportChannel, 4) !=
c0d02794:	4621      	mov	r1, r4
c0d02796:	310e      	adds	r1, #14
c0d02798:	2204      	movs	r2, #4
c0d0279a:	4620      	mov	r0, r4
c0d0279c:	f7fe fdc2 	bl	c0d01324 <os_memcmp>
                 0) &&
c0d027a0:	2800      	cmp	r0, #0
c0d027a2:	d007      	beq.n	c0d027b4 <u2f_transport_received+0x16c>
                (buffer[channelHeader] != U2F_CMD_INIT)) {
c0d027a4:	9802      	ldr	r0, [sp, #8]
c0d027a6:	7800      	ldrb	r0, [r0, #0]
c0d027a8:	9908      	ldr	r1, [sp, #32]
c0d027aa:	1c49      	adds	r1, r1, #1
c0d027ac:	b2c9      	uxtb	r1, r1
        }

        // If waiting for a continuation on a different channel, reply BUSY
        // immediately
        if (media == U2F_MEDIA_USB) {
            if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d027ae:	4288      	cmp	r0, r1
c0d027b0:	d000      	beq.n	c0d027b4 <u2f_transport_received+0x16c>
c0d027b2:	e0c1      	b.n	c0d02938 <u2f_transport_received+0x2f0>
                goto error;
            }
        }
        // If a command was already sent, and we are not processing a INIT
        // command, abort
        if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d027b4:	7f20      	ldrb	r0, [r4, #28]
c0d027b6:	2801      	cmp	r0, #1
c0d027b8:	d108      	bne.n	c0d027cc <u2f_transport_received+0x184>
            !((media == U2F_MEDIA_USB) &&
c0d027ba:	2e01      	cmp	r6, #1
c0d027bc:	d167      	bne.n	c0d0288e <u2f_transport_received+0x246>
              (buffer[channelHeader] == U2F_CMD_INIT))) {
c0d027be:	9802      	ldr	r0, [sp, #8]
c0d027c0:	7800      	ldrb	r0, [r0, #0]
c0d027c2:	9908      	ldr	r1, [sp, #32]
c0d027c4:	1c49      	adds	r1, r1, #1
c0d027c6:	b2c9      	uxtb	r1, r1
                goto error;
            }
        }
        // If a command was already sent, and we are not processing a INIT
        // command, abort
        if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d027c8:	4288      	cmp	r0, r1
c0d027ca:	d160      	bne.n	c0d0288e <u2f_transport_received+0x246>
            u2f_transport_error(service, ERROR_INVALID_SEQ);
            goto error;
        }
        // Check the length
        uint16_t commandLength =
            (buffer[channelHeader + 1] << 8) | (buffer[channelHeader + 2]);
c0d027cc:	2002      	movs	r0, #2
c0d027ce:	9906      	ldr	r1, [sp, #24]
c0d027d0:	4308      	orrs	r0, r1
c0d027d2:	9907      	ldr	r1, [sp, #28]
c0d027d4:	5c08      	ldrb	r0, [r1, r0]
c0d027d6:	5d49      	ldrb	r1, [r1, r5]
c0d027d8:	020d      	lsls	r5, r1, #8
c0d027da:	4305      	orrs	r5, r0
        if (commandLength > (service->transportReceiveBufferLength - 3)) {
c0d027dc:	89a0      	ldrh	r0, [r4, #12]
c0d027de:	1ec0      	subs	r0, r0, #3
c0d027e0:	4285      	cmp	r5, r0
c0d027e2:	dd1b      	ble.n	c0d0281c <u2f_transport_received+0x1d4>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d027e4:	4861      	ldr	r0, [pc, #388]	; (c0d0296c <u2f_transport_received+0x324>)
c0d027e6:	7207      	strb	r7, [r0, #8]
c0d027e8:	2104      	movs	r1, #4
c0d027ea:	e053      	b.n	c0d02894 <u2f_transport_received+0x24c>
c0d027ec:	9a08      	ldr	r2, [sp, #32]
c0d027ee:	4610      	mov	r0, r2
c0d027f0:	3008      	adds	r0, #8
c0d027f2:	495e      	ldr	r1, [pc, #376]	; (c0d0296c <u2f_transport_received+0x324>)
c0d027f4:	7208      	strb	r0, [r1, #8]
c0d027f6:	2004      	movs	r0, #4

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d027f8:	7720      	strb	r0, [r4, #28]
c0d027fa:	2000      	movs	r0, #0
    service->transportPacketIndex = 0;
c0d027fc:	75a0      	strb	r0, [r4, #22]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d027fe:	3108      	adds	r1, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d02800:	61a1      	str	r1, [r4, #24]
    service->transportOffset = 0;
c0d02802:	8260      	strh	r0, [r4, #18]
c0d02804:	e79c      	b.n	c0d02740 <u2f_transport_received+0xf8>
            goto error;
        }
        if (service->transportState != U2F_HANDLE_SEGMENTED) {
            // Unexpected continuation at this stage, abort
            // TODO : review the behavior is HID only
            if (media == U2F_MEDIA_USB) {
c0d02806:	2e01      	cmp	r6, #1
c0d02808:	d000      	beq.n	c0d0280c <u2f_transport_received+0x1c4>
c0d0280a:	e77f      	b.n	c0d0270c <u2f_transport_received+0xc4>
c0d0280c:	2000      	movs	r0, #0

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d0280e:	7720      	strb	r0, [r4, #28]
    service->transportOffset = 0;
c0d02810:	8260      	strh	r0, [r4, #18]
    service->transportMedia = 0;
c0d02812:	7760      	strb	r0, [r4, #29]
    service->transportPacketIndex = 0;
c0d02814:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d02816:	68a0      	ldr	r0, [r4, #8]
c0d02818:	61a0      	str	r0, [r4, #24]
c0d0281a:	e799      	b.n	c0d02750 <u2f_transport_received+0x108>
            // Overflow in message size, abort
            u2f_transport_error(service, ERROR_INVALID_LEN);
            goto error;
        }
        // Check if the command is supported
        switch (buffer[channelHeader]) {
c0d0281c:	9802      	ldr	r0, [sp, #8]
c0d0281e:	7800      	ldrb	r0, [r0, #0]
c0d02820:	2881      	cmp	r0, #129	; 0x81
c0d02822:	9a01      	ldr	r2, [sp, #4]
c0d02824:	d003      	beq.n	c0d0282e <u2f_transport_received+0x1e6>
c0d02826:	2886      	cmp	r0, #134	; 0x86
c0d02828:	d03c      	beq.n	c0d028a4 <u2f_transport_received+0x25c>
c0d0282a:	2883      	cmp	r0, #131	; 0x83
c0d0282c:	d173      	bne.n	c0d02916 <u2f_transport_received+0x2ce>
        case U2F_CMD_PING:
        case U2F_CMD_MSG:
            if (media == U2F_MEDIA_USB) {
c0d0282e:	2e01      	cmp	r6, #1
c0d02830:	d143      	bne.n	c0d028ba <u2f_transport_received+0x272>
error:
    return;
}

bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
c0d02832:	4950      	ldr	r1, [pc, #320]	; (c0d02974 <u2f_transport_received+0x32c>)
c0d02834:	4479      	add	r1, pc
c0d02836:	2704      	movs	r7, #4
c0d02838:	4620      	mov	r0, r4
c0d0283a:	463a      	mov	r2, r7
c0d0283c:	f7fe fd72 	bl	c0d01324 <os_memcmp>
        // Check if the command is supported
        switch (buffer[channelHeader]) {
        case U2F_CMD_PING:
        case U2F_CMD_MSG:
            if (media == U2F_MEDIA_USB) {
                if (u2f_is_channel_broadcast(service->channel) ||
c0d02840:	2800      	cmp	r0, #0
c0d02842:	d100      	bne.n	c0d02846 <u2f_transport_received+0x1fe>
c0d02844:	e08c      	b.n	c0d02960 <u2f_transport_received+0x318>
bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
}

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
c0d02846:	494c      	ldr	r1, [pc, #304]	; (c0d02978 <u2f_transport_received+0x330>)
c0d02848:	4479      	add	r1, pc
c0d0284a:	2204      	movs	r2, #4
c0d0284c:	4620      	mov	r0, r4
c0d0284e:	e030      	b.n	c0d028b2 <u2f_transport_received+0x26a>
c0d02850:	9806      	ldr	r0, [sp, #24]
c0d02852:	9a07      	ldr	r2, [sp, #28]
                u2f_transport_error(service, ERROR_CHANNEL_BUSY);
                goto error;
            }
        }
        // also discriminate invalid command sent instead of a continuation
        if (buffer[channelHeader] != service->transportPacketIndex) {
c0d02854:	1811      	adds	r1, r2, r0
c0d02856:	5c10      	ldrb	r0, [r2, r0]
c0d02858:	7da2      	ldrb	r2, [r4, #22]
c0d0285a:	4290      	cmp	r0, r2
c0d0285c:	d000      	beq.n	c0d02860 <u2f_transport_received+0x218>
c0d0285e:	e755      	b.n	c0d0270c <u2f_transport_received+0xc4>
c0d02860:	9301      	str	r3, [sp, #4]
            // Bad continuation packet, abort
            u2f_transport_error(service, ERROR_INVALID_SEQ);
            goto error;
        }
        xfer_len = MIN(size - (channelHeader + 1), service->transportLength - service->transportOffset);
c0d02862:	9805      	ldr	r0, [sp, #20]
c0d02864:	1b45      	subs	r5, r0, r5
c0d02866:	8a60      	ldrh	r0, [r4, #18]
c0d02868:	8aa2      	ldrh	r2, [r4, #20]
c0d0286a:	1a12      	subs	r2, r2, r0
c0d0286c:	4295      	cmp	r5, r2
c0d0286e:	db00      	blt.n	c0d02872 <u2f_transport_received+0x22a>
c0d02870:	4615      	mov	r5, r2
c0d02872:	9a03      	ldr	r2, [sp, #12]
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
c0d02874:	402a      	ands	r2, r5
c0d02876:	69a3      	ldr	r3, [r4, #24]
c0d02878:	1818      	adds	r0, r3, r0
c0d0287a:	1c49      	adds	r1, r1, #1
c0d0287c:	f7fe fcb5 	bl	c0d011ea <os_memmove>
        service->transportOffset += xfer_len;
c0d02880:	8a60      	ldrh	r0, [r4, #18]
c0d02882:	1940      	adds	r0, r0, r5
c0d02884:	8260      	strh	r0, [r4, #18]
        service->transportPacketIndex++;
c0d02886:	7da0      	ldrb	r0, [r4, #22]
c0d02888:	1c40      	adds	r0, r0, #1
c0d0288a:	75a0      	strb	r0, [r4, #22]
c0d0288c:	e02e      	b.n	c0d028ec <u2f_transport_received+0x2a4>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0288e:	4837      	ldr	r0, [pc, #220]	; (c0d0296c <u2f_transport_received+0x324>)
c0d02890:	2104      	movs	r1, #4
c0d02892:	7201      	strb	r1, [r0, #8]
c0d02894:	7721      	strb	r1, [r4, #28]
c0d02896:	2100      	movs	r1, #0
c0d02898:	75a1      	strb	r1, [r4, #22]
c0d0289a:	3008      	adds	r0, #8
c0d0289c:	61a0      	str	r0, [r4, #24]
c0d0289e:	8261      	strh	r1, [r4, #18]
c0d028a0:	9801      	ldr	r0, [sp, #4]
c0d028a2:	e6e7      	b.n	c0d02674 <u2f_transport_received+0x2c>
                }
            }
            // no channel for BLE
            break;
        case U2F_CMD_INIT:
            if (media != U2F_MEDIA_USB) {
c0d028a4:	2e01      	cmp	r6, #1
c0d028a6:	d136      	bne.n	c0d02916 <u2f_transport_received+0x2ce>
bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
}

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
c0d028a8:	4934      	ldr	r1, [pc, #208]	; (c0d0297c <u2f_transport_received+0x334>)
c0d028aa:	4479      	add	r1, pc
c0d028ac:	2704      	movs	r7, #4
c0d028ae:	4620      	mov	r0, r4
c0d028b0:	463a      	mov	r2, r7
c0d028b2:	f7fe fd37 	bl	c0d01324 <os_memcmp>
c0d028b6:	2800      	cmp	r0, #0
c0d028b8:	d052      	beq.n	c0d02960 <u2f_transport_received+0x318>
        }

        // Ok, initialize the buffer
        //if (buffer[channelHeader] != U2F_CMD_INIT) 
        {
            xfer_len = MIN(size - (channelHeader), U2F_COMMAND_HEADER_SIZE+commandLength);
c0d028ba:	9805      	ldr	r0, [sp, #20]
c0d028bc:	9906      	ldr	r1, [sp, #24]
c0d028be:	1a47      	subs	r7, r0, r1
c0d028c0:	1ced      	adds	r5, r5, #3
c0d028c2:	42af      	cmp	r7, r5
c0d028c4:	9903      	ldr	r1, [sp, #12]
c0d028c6:	db00      	blt.n	c0d028ca <u2f_transport_received+0x282>
c0d028c8:	462f      	mov	r7, r5
            os_memmove(service->transportBuffer, buffer + channelHeader, xfer_len);
c0d028ca:	4039      	ands	r1, r7
c0d028cc:	69a0      	ldr	r0, [r4, #24]
c0d028ce:	460a      	mov	r2, r1
c0d028d0:	9902      	ldr	r1, [sp, #8]
c0d028d2:	f7fe fc8a 	bl	c0d011ea <os_memmove>
            service->transportOffset = xfer_len;
c0d028d6:	8267      	strh	r7, [r4, #18]
            service->transportLength = U2F_COMMAND_HEADER_SIZE+commandLength;
c0d028d8:	82a5      	strh	r5, [r4, #20]
            service->transportMedia = media;
c0d028da:	7766      	strb	r6, [r4, #29]
            // initialize the response
            service->transportPacketIndex = 0;
c0d028dc:	2000      	movs	r0, #0
c0d028de:	75a0      	strb	r0, [r4, #22]
            os_memmove(service->transportChannel, service->channel, 4);
c0d028e0:	4620      	mov	r0, r4
c0d028e2:	300e      	adds	r0, #14
c0d028e4:	2204      	movs	r2, #4
c0d028e6:	4621      	mov	r1, r4
c0d028e8:	f7fe fc7f 	bl	c0d011ea <os_memmove>
c0d028ec:	8a60      	ldrh	r0, [r4, #18]
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
        service->transportOffset += xfer_len;
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
c0d028ee:	2e01      	cmp	r6, #1
c0d028f0:	9b01      	ldr	r3, [sp, #4]
c0d028f2:	d101      	bne.n	c0d028f8 <u2f_transport_received+0x2b0>
c0d028f4:	8aa1      	ldrh	r1, [r4, #20]
c0d028f6:	e008      	b.n	c0d0290a <u2f_transport_received+0x2c2>
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
c0d028f8:	8aa1      	ldrh	r1, [r4, #20]
c0d028fa:	1cca      	adds	r2, r1, #3
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
        service->transportOffset += xfer_len;
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
c0d028fc:	4290      	cmp	r0, r2
c0d028fe:	d904      	bls.n	c0d0290a <u2f_transport_received+0x2c2>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d02900:	481a      	ldr	r0, [pc, #104]	; (c0d0296c <u2f_transport_received+0x324>)
c0d02902:	2103      	movs	r1, #3
c0d02904:	7201      	strb	r1, [r0, #8]
c0d02906:	2104      	movs	r1, #4
c0d02908:	e703      	b.n	c0d02712 <u2f_transport_received+0xca>
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
c0d0290a:	4288      	cmp	r0, r1
c0d0290c:	d20e      	bcs.n	c0d0292c <u2f_transport_received+0x2e4>
c0d0290e:	2000      	movs	r0, #0
        service->transportState = U2F_PROCESSING_COMMAND;
        // internal notification of a complete message received
        u2f_message_complete(service);
    } else {
        // new segment received, reset the timeout for the current piece
        service->seqTimeout = 0;
c0d02910:	62a0      	str	r0, [r4, #40]	; 0x28
        service->transportState = U2F_HANDLE_SEGMENTED;
c0d02912:	7723      	strb	r3, [r4, #28]
c0d02914:	e71c      	b.n	c0d02750 <u2f_transport_received+0x108>
c0d02916:	4815      	ldr	r0, [pc, #84]	; (c0d0296c <u2f_transport_received+0x324>)
c0d02918:	7202      	strb	r2, [r0, #8]
c0d0291a:	2104      	movs	r1, #4
c0d0291c:	7721      	strb	r1, [r4, #28]
c0d0291e:	2100      	movs	r1, #0
c0d02920:	75a1      	strb	r1, [r4, #22]
c0d02922:	3008      	adds	r0, #8
c0d02924:	61a0      	str	r0, [r4, #24]
c0d02926:	8261      	strh	r1, [r4, #18]
c0d02928:	82a2      	strh	r2, [r4, #20]
c0d0292a:	e6a4      	b.n	c0d02676 <u2f_transport_received+0x2e>
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
        // switch before the handler gets the opportunity to change it again
        service->transportState = U2F_PROCESSING_COMMAND;
c0d0292c:	2002      	movs	r0, #2
c0d0292e:	7720      	strb	r0, [r4, #28]
        // internal notification of a complete message received
        u2f_message_complete(service);
c0d02930:	4620      	mov	r0, r4
c0d02932:	f7ff fde5 	bl	c0d02500 <u2f_message_complete>
c0d02936:	e70b      	b.n	c0d02750 <u2f_transport_received+0x108>
                // special error case, we reply but don't change the current state of the transport (ongoing message for example)
                //u2f_transport_error_no_reset(service, ERROR_CHANNEL_BUSY);
                uint16_t offset = 0;
                // Fragment
                if (media == U2F_MEDIA_USB) {
                    os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d02938:	4d0c      	ldr	r5, [pc, #48]	; (c0d0296c <u2f_transport_received+0x324>)
c0d0293a:	2204      	movs	r2, #4
c0d0293c:	4628      	mov	r0, r5
c0d0293e:	4621      	mov	r1, r4
c0d02940:	f7fe fc53 	bl	c0d011ea <os_memmove>
c0d02944:	9808      	ldr	r0, [sp, #32]
                    offset += 4;
                }
                G_io_usb_ep_buffer[offset++] = U2F_STATUS_ERROR;
c0d02946:	303a      	adds	r0, #58	; 0x3a
c0d02948:	7128      	strb	r0, [r5, #4]
                G_io_usb_ep_buffer[offset++] = 0;
c0d0294a:	2000      	movs	r0, #0
c0d0294c:	7168      	strb	r0, [r5, #5]
c0d0294e:	9a01      	ldr	r2, [sp, #4]
                G_io_usb_ep_buffer[offset++] = 1;
c0d02950:	71aa      	strb	r2, [r5, #6]
c0d02952:	2006      	movs	r0, #6
                G_io_usb_ep_buffer[offset++] = ERROR_CHANNEL_BUSY;
c0d02954:	71e8      	strb	r0, [r5, #7]
                u2f_io_send(G_io_usb_ep_buffer, offset, media);
c0d02956:	2108      	movs	r1, #8
c0d02958:	4628      	mov	r0, r5
c0d0295a:	f7ff fdef 	bl	c0d0253c <u2f_io_send>
c0d0295e:	e6f7      	b.n	c0d02750 <u2f_transport_received+0x108>
c0d02960:	4802      	ldr	r0, [pc, #8]	; (c0d0296c <u2f_transport_received+0x324>)
c0d02962:	210b      	movs	r1, #11
c0d02964:	7201      	strb	r1, [r0, #8]
c0d02966:	7727      	strb	r7, [r4, #28]
c0d02968:	e795      	b.n	c0d02896 <u2f_transport_received+0x24e>
c0d0296a:	46c0      	nop			; (mov r8, r8)
c0d0296c:	20001ab0 	.word	0x20001ab0
c0d02970:	0000ffff 	.word	0x0000ffff
c0d02974:	00002248 	.word	0x00002248
c0d02978:	00002238 	.word	0x00002238
c0d0297c:	000021d6 	.word	0x000021d6

c0d02980 <u2f_is_channel_broadcast>:
    }
error:
    return;
}

bool u2f_is_channel_broadcast(uint8_t *channel) {
c0d02980:	b580      	push	{r7, lr}
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
c0d02982:	4906      	ldr	r1, [pc, #24]	; (c0d0299c <u2f_is_channel_broadcast+0x1c>)
c0d02984:	4479      	add	r1, pc
c0d02986:	2204      	movs	r2, #4
c0d02988:	f7fe fccc 	bl	c0d01324 <os_memcmp>
c0d0298c:	4601      	mov	r1, r0
c0d0298e:	2001      	movs	r0, #1
c0d02990:	2200      	movs	r2, #0
c0d02992:	2900      	cmp	r1, #0
c0d02994:	d000      	beq.n	c0d02998 <u2f_is_channel_broadcast+0x18>
c0d02996:	4610      	mov	r0, r2
c0d02998:	bd80      	pop	{r7, pc}
c0d0299a:	46c0      	nop			; (mov r8, r8)
c0d0299c:	000020f8 	.word	0x000020f8

c0d029a0 <u2f_message_reply>:

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
}

void u2f_message_reply(u2f_service_t *service, uint8_t cmd, uint8_t *buffer, uint16_t len) {
c0d029a0:	b510      	push	{r4, lr}
    service->transportState = U2F_SENDING_RESPONSE;
c0d029a2:	2403      	movs	r4, #3
c0d029a4:	7704      	strb	r4, [r0, #28]
c0d029a6:	2400      	movs	r4, #0
    service->transportPacketIndex = 0;
c0d029a8:	7584      	strb	r4, [r0, #22]
    service->transportBuffer = buffer;
c0d029aa:	6182      	str	r2, [r0, #24]
    service->transportOffset = 0;
c0d029ac:	8244      	strh	r4, [r0, #18]
    service->transportLength = len;
c0d029ae:	8283      	strh	r3, [r0, #20]
    service->sendCmd = cmd;
c0d029b0:	2234      	movs	r2, #52	; 0x34
c0d029b2:	5481      	strb	r1, [r0, r2]
    // pump the first message
    u2f_transport_sent(service, service->transportMedia);
c0d029b4:	7f41      	ldrb	r1, [r0, #29]
c0d029b6:	f7ff fde5 	bl	c0d02584 <u2f_transport_sent>
}
c0d029ba:	bd10      	pop	{r4, pc}

c0d029bc <io_seproxyhal_touch_approve>:
    }
    return NULL;
}

/** processes the transaction approval. the UI is only displayed when all of the TX has been sent over for signing. */
const bagl_element_t *io_seproxyhal_touch_approve(const bagl_element_t *e) {
c0d029bc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d029be:	b0b9      	sub	sp, #228	; 0xe4
    unsigned int tx = 0;

    if (G_io_apdu_buffer[2] == P1_LAST) {
c0d029c0:	4f48      	ldr	r7, [pc, #288]	; (c0d02ae4 <io_seproxyhal_touch_approve+0x128>)
c0d029c2:	78b8      	ldrb	r0, [r7, #2]
c0d029c4:	2500      	movs	r5, #0
        raw_tx_ix = 0;
        raw_tx_len = 0;

        // add hash to the response, so we can see where the bug is.
        G_io_apdu_buffer[tx++] = 0xFF;
        G_io_apdu_buffer[tx++] = 0xFF;
c0d029c6:	2180      	movs	r1, #128	; 0x80

/** processes the transaction approval. the UI is only displayed when all of the TX has been sent over for signing. */
const bagl_element_t *io_seproxyhal_touch_approve(const bagl_element_t *e) {
    unsigned int tx = 0;

    if (G_io_apdu_buffer[2] == P1_LAST) {
c0d029c8:	2880      	cmp	r0, #128	; 0x80
c0d029ca:	462c      	mov	r4, r5
c0d029cc:	d17b      	bne.n	c0d02ac6 <io_seproxyhal_touch_approve+0x10a>
c0d029ce:	9107      	str	r1, [sp, #28]
c0d029d0:	9508      	str	r5, [sp, #32]
        unsigned int raw_tx_len_except_bip44 = raw_tx_len - BIP44_BYTE_LENGTH;
c0d029d2:	4845      	ldr	r0, [pc, #276]	; (c0d02ae8 <io_seproxyhal_touch_approve+0x12c>)
c0d029d4:	6805      	ldr	r5, [r0, #0]
c0d029d6:	2400      	movs	r4, #0
        // Update and sign the hash
        cx_hash(&hash.header, 0, raw_tx, raw_tx_len_except_bip44, NULL);
c0d029d8:	4668      	mov	r0, sp
c0d029da:	6004      	str	r4, [r0, #0]
/** processes the transaction approval. the UI is only displayed when all of the TX has been sent over for signing. */
const bagl_element_t *io_seproxyhal_touch_approve(const bagl_element_t *e) {
    unsigned int tx = 0;

    if (G_io_apdu_buffer[2] == P1_LAST) {
        unsigned int raw_tx_len_except_bip44 = raw_tx_len - BIP44_BYTE_LENGTH;
c0d029dc:	3d14      	subs	r5, #20
        // Update and sign the hash
        cx_hash(&hash.header, 0, raw_tx, raw_tx_len_except_bip44, NULL);
c0d029de:	4843      	ldr	r0, [pc, #268]	; (c0d02aec <io_seproxyhal_touch_approve+0x130>)
c0d029e0:	4e43      	ldr	r6, [pc, #268]	; (c0d02af0 <io_seproxyhal_touch_approve+0x134>)
c0d029e2:	4621      	mov	r1, r4
c0d029e4:	4632      	mov	r2, r6
c0d029e6:	462b      	mov	r3, r5
c0d029e8:	f7fd fb6c 	bl	c0d000c4 <cx_hash_X>
        unsigned char *bip44_in = raw_tx + raw_tx_len_except_bip44;

        /** BIP44 path, used to derive the private key from the mnemonic by calling os_perso_derive_node_bip32. */
        unsigned int bip44_path[BIP44_PATH_LEN];
        uint32_t i;
        for (i = 0; i < BIP44_PATH_LEN; i++) {
c0d029ec:	1970      	adds	r0, r6, r5
            bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
c0d029ee:	00a1      	lsls	r1, r4, #2
c0d029f0:	5c42      	ldrb	r2, [r0, r1]
c0d029f2:	0612      	lsls	r2, r2, #24
c0d029f4:	1843      	adds	r3, r0, r1
c0d029f6:	785d      	ldrb	r5, [r3, #1]
c0d029f8:	042d      	lsls	r5, r5, #16
c0d029fa:	4315      	orrs	r5, r2
c0d029fc:	789a      	ldrb	r2, [r3, #2]
c0d029fe:	0212      	lsls	r2, r2, #8
c0d02a00:	432a      	orrs	r2, r5
c0d02a02:	78db      	ldrb	r3, [r3, #3]
c0d02a04:	4313      	orrs	r3, r2
c0d02a06:	aa34      	add	r2, sp, #208	; 0xd0
c0d02a08:	5053      	str	r3, [r2, r1]
        unsigned char *bip44_in = raw_tx + raw_tx_len_except_bip44;

        /** BIP44 path, used to derive the private key from the mnemonic by calling os_perso_derive_node_bip32. */
        unsigned int bip44_path[BIP44_PATH_LEN];
        uint32_t i;
        for (i = 0; i < BIP44_PATH_LEN; i++) {
c0d02a0a:	1c64      	adds	r4, r4, #1
c0d02a0c:	2c05      	cmp	r4, #5
c0d02a0e:	d1ee      	bne.n	c0d029ee <io_seproxyhal_touch_approve+0x32>
c0d02a10:	2100      	movs	r1, #0
            bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
            bip44_in += 4;
        }

        unsigned char privateKeyData[32];
        os_perso_derive_node_bip32(CX_CURVE_256R1, bip44_path, BIP44_PATH_LEN, privateKeyData, NULL);
c0d02a12:	9109      	str	r1, [sp, #36]	; 0x24
c0d02a14:	4668      	mov	r0, sp
c0d02a16:	6001      	str	r1, [r0, #0]
c0d02a18:	2422      	movs	r4, #34	; 0x22
c0d02a1a:	a934      	add	r1, sp, #208	; 0xd0
c0d02a1c:	2205      	movs	r2, #5
c0d02a1e:	af2c      	add	r7, sp, #176	; 0xb0
c0d02a20:	4620      	mov	r0, r4
c0d02a22:	463b      	mov	r3, r7
c0d02a24:	f7ff fbd6 	bl	c0d021d4 <os_perso_derive_node_bip32>

        cx_ecfp_private_key_t privateKey;
        cx_ecdsa_init_private_key(CX_CURVE_256R1, privateKeyData, 32, &privateKey);
c0d02a28:	2520      	movs	r5, #32
c0d02a2a:	ab22      	add	r3, sp, #136	; 0x88
c0d02a2c:	9306      	str	r3, [sp, #24]
c0d02a2e:	4620      	mov	r0, r4
c0d02a30:	4639      	mov	r1, r7
c0d02a32:	462a      	mov	r2, r5
c0d02a34:	9504      	str	r5, [sp, #16]
c0d02a36:	f7ff fb7d 	bl	c0d02134 <cx_ecfp_init_private_key>
c0d02a3a:	ac1a      	add	r4, sp, #104	; 0x68
        // Hash is finalized, send back the signature
        unsigned char tmp[32];
        unsigned char tmp2[32];
        unsigned char result[32];

        cx_hash(&hash.header, CX_LAST, raw_tx, 0, tmp);
c0d02a3c:	4668      	mov	r0, sp
c0d02a3e:	6004      	str	r4, [r0, #0]
c0d02a40:	4f2a      	ldr	r7, [pc, #168]	; (c0d02aec <io_seproxyhal_touch_approve+0x130>)
c0d02a42:	2601      	movs	r6, #1
c0d02a44:	4a2a      	ldr	r2, [pc, #168]	; (c0d02af0 <io_seproxyhal_touch_approve+0x134>)
c0d02a46:	4638      	mov	r0, r7
c0d02a48:	4631      	mov	r1, r6
c0d02a4a:	9b09      	ldr	r3, [sp, #36]	; 0x24
c0d02a4c:	f7fd fb3a 	bl	c0d000c4 <cx_hash_X>

        //cx_sha256_t hashTmp;
        cx_sha256_init(&hash);
c0d02a50:	4638      	mov	r0, r7
c0d02a52:	f7ff fb41 	bl	c0d020d8 <cx_sha256_init>
c0d02a56:	af12      	add	r7, sp, #72	; 0x48
        cx_hash(&hash.header, CX_LAST, tmp, 32, tmp2);
c0d02a58:	4668      	mov	r0, sp
c0d02a5a:	6007      	str	r7, [r0, #0]
c0d02a5c:	9705      	str	r7, [sp, #20]
c0d02a5e:	4823      	ldr	r0, [pc, #140]	; (c0d02aec <io_seproxyhal_touch_approve+0x130>)
c0d02a60:	4631      	mov	r1, r6
c0d02a62:	4622      	mov	r2, r4
c0d02a64:	462b      	mov	r3, r5
c0d02a66:	f7fd fb2d 	bl	c0d000c4 <cx_hash_X>
c0d02a6a:	4820      	ldr	r0, [pc, #128]	; (c0d02aec <io_seproxyhal_touch_approve+0x130>)

        //cx_sha256_t hashTmp2;
        cx_sha256_init(&hash);
c0d02a6c:	f7ff fb34 	bl	c0d020d8 <cx_sha256_init>
c0d02a70:	ac0a      	add	r4, sp, #40	; 0x28
        cx_hash(&hash.header, CX_LAST, tmp2, 32, result);
c0d02a72:	4668      	mov	r0, sp
c0d02a74:	6004      	str	r4, [r0, #0]
c0d02a76:	481d      	ldr	r0, [pc, #116]	; (c0d02aec <io_seproxyhal_touch_approve+0x130>)
c0d02a78:	4631      	mov	r1, r6
c0d02a7a:	463a      	mov	r2, r7
c0d02a7c:	462b      	mov	r3, r5
c0d02a7e:	f7fd fb21 	bl	c0d000c4 <cx_hash_X>
#if CX_APILEVEL >= 8
        tx = cx_ecdsa_sign((void*) &privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, result, sizeof(result), G_io_apdu_buffer, NULL);
c0d02a82:	4668      	mov	r0, sp
c0d02a84:	6005      	str	r5, [r0, #0]
c0d02a86:	4917      	ldr	r1, [pc, #92]	; (c0d02ae4 <io_seproxyhal_touch_approve+0x128>)
c0d02a88:	460f      	mov	r7, r1
c0d02a8a:	6047      	str	r7, [r0, #4]
c0d02a8c:	9d09      	ldr	r5, [sp, #36]	; 0x24
c0d02a8e:	6085      	str	r5, [r0, #8]
c0d02a90:	4918      	ldr	r1, [pc, #96]	; (c0d02af4 <io_seproxyhal_touch_approve+0x138>)
c0d02a92:	2203      	movs	r2, #3
c0d02a94:	9806      	ldr	r0, [sp, #24]
c0d02a96:	4623      	mov	r3, r4
c0d02a98:	f7fd fb79 	bl	c0d0018e <cx_ecdsa_sign_X>
c0d02a9c:	4604      	mov	r4, r0
#else
        tx = cx_ecdsa_sign((void *) &privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, result, sizeof(result),
                           G_io_apdu_buffer);
#endif
        // G_io_apdu_buffer[0] &= 0xF0; // discard the parity information
        hashTainted = 1;
c0d02a9e:	4816      	ldr	r0, [pc, #88]	; (c0d02af8 <io_seproxyhal_touch_approve+0x13c>)
c0d02aa0:	7006      	strb	r6, [r0, #0]
        raw_tx_ix = 0;
c0d02aa2:	4816      	ldr	r0, [pc, #88]	; (c0d02afc <io_seproxyhal_touch_approve+0x140>)
c0d02aa4:	6005      	str	r5, [r0, #0]
        raw_tx_len = 0;
c0d02aa6:	4810      	ldr	r0, [pc, #64]	; (c0d02ae8 <io_seproxyhal_touch_approve+0x12c>)
c0d02aa8:	6005      	str	r5, [r0, #0]
c0d02aaa:	9d07      	ldr	r5, [sp, #28]

        // add hash to the response, so we can see where the bug is.
        G_io_apdu_buffer[tx++] = 0xFF;
c0d02aac:	4628      	mov	r0, r5
c0d02aae:	307f      	adds	r0, #127	; 0x7f
c0d02ab0:	5538      	strb	r0, [r7, r4]

        //cx_sha256_t hashTmp2;
        cx_sha256_init(&hash);
        cx_hash(&hash.header, CX_LAST, tmp2, 32, result);
#if CX_APILEVEL >= 8
        tx = cx_ecdsa_sign((void*) &privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, result, sizeof(result), G_io_apdu_buffer, NULL);
c0d02ab2:	1939      	adds	r1, r7, r4
        raw_tx_ix = 0;
        raw_tx_len = 0;

        // add hash to the response, so we can see where the bug is.
        G_io_apdu_buffer[tx++] = 0xFF;
        G_io_apdu_buffer[tx++] = 0xFF;
c0d02ab4:	7048      	strb	r0, [r1, #1]
        for (int ix = 0; ix < 32; ix++) {
c0d02ab6:	1c88      	adds	r0, r1, #2
            G_io_apdu_buffer[tx++] = tmp2[ix];
c0d02ab8:	9905      	ldr	r1, [sp, #20]
c0d02aba:	9a04      	ldr	r2, [sp, #16]
c0d02abc:	f001 fec8 	bl	c0d04850 <__aeabi_memcpy>
c0d02ac0:	4629      	mov	r1, r5
        raw_tx_len = 0;

        // add hash to the response, so we can see where the bug is.
        G_io_apdu_buffer[tx++] = 0xFF;
        G_io_apdu_buffer[tx++] = 0xFF;
        for (int ix = 0; ix < 32; ix++) {
c0d02ac2:	3422      	adds	r4, #34	; 0x22
c0d02ac4:	9d08      	ldr	r5, [sp, #32]
            G_io_apdu_buffer[tx++] = tmp2[ix];
        }
    }
    G_io_apdu_buffer[tx++] = 0x90;
c0d02ac6:	3110      	adds	r1, #16
c0d02ac8:	5539      	strb	r1, [r7, r4]
c0d02aca:	1938      	adds	r0, r7, r4
    G_io_apdu_buffer[tx++] = 0x00;
c0d02acc:	7045      	strb	r5, [r0, #1]
c0d02ace:	1ca0      	adds	r0, r4, #2
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, tx);
c0d02ad0:	b281      	uxth	r1, r0
c0d02ad2:	2020      	movs	r0, #32
c0d02ad4:	f7fe ff60 	bl	c0d01998 <io_exchange>
    // Display back the original UX
    ui_idle();
c0d02ad8:	f000 f812 	bl	c0d02b00 <ui_idle>
    //fix bug
    //io_seproxyhal_touch_exit(NULL);
    return 0; // do not redraw the widget
c0d02adc:	4628      	mov	r0, r5
c0d02ade:	b039      	add	sp, #228	; 0xe4
c0d02ae0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02ae2:	46c0      	nop			; (mov r8, r8)
c0d02ae4:	200018f8 	.word	0x200018f8
c0d02ae8:	20001af0 	.word	0x20001af0
c0d02aec:	20001af4 	.word	0x20001af4
c0d02af0:	20001b60 	.word	0x20001b60
c0d02af4:	00000601 	.word	0x00000601
c0d02af8:	20001f60 	.word	0x20001f60
c0d02afc:	20001f64 	.word	0x20001f64

c0d02b00 <ui_idle>:
        UX_DISPLAY(bagl_ui_public_key_nanos_2, NULL);
    }
}

/** show the idle screen. */
void ui_idle(void) {
c0d02b00:	b5b0      	push	{r4, r5, r7, lr}
    uiState = UI_IDLE;
c0d02b02:	4845      	ldr	r0, [pc, #276]	; (c0d02c18 <ui_idle+0x118>)
c0d02b04:	2101      	movs	r1, #1
c0d02b06:	7001      	strb	r1, [r0, #0]
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d02b08:	020c      	lsls	r4, r1, #8
c0d02b0a:	f7ff fba7 	bl	c0d0225c <os_seph_features>
c0d02b0e:	4220      	tst	r0, r4
c0d02b10:	d140      	bne.n	c0d02b94 <ui_idle+0x94>
        UX_DISPLAY(bagl_ui_idle_blue, NULL);
    } else {
        UX_DISPLAY(bagl_ui_idle_nanos, NULL);
c0d02b12:	4c42      	ldr	r4, [pc, #264]	; (c0d02c1c <ui_idle+0x11c>)
c0d02b14:	4845      	ldr	r0, [pc, #276]	; (c0d02c2c <ui_idle+0x12c>)
c0d02b16:	4478      	add	r0, pc
c0d02b18:	6020      	str	r0, [r4, #0]
c0d02b1a:	2004      	movs	r0, #4
c0d02b1c:	6060      	str	r0, [r4, #4]
c0d02b1e:	4844      	ldr	r0, [pc, #272]	; (c0d02c30 <ui_idle+0x130>)
c0d02b20:	4478      	add	r0, pc
c0d02b22:	6120      	str	r0, [r4, #16]
c0d02b24:	2500      	movs	r5, #0
c0d02b26:	60e5      	str	r5, [r4, #12]
c0d02b28:	2003      	movs	r0, #3
c0d02b2a:	7620      	strb	r0, [r4, #24]
c0d02b2c:	61e5      	str	r5, [r4, #28]
c0d02b2e:	4620      	mov	r0, r4
c0d02b30:	3018      	adds	r0, #24
c0d02b32:	f7ff fb7d 	bl	c0d02230 <os_ux>
c0d02b36:	61e0      	str	r0, [r4, #28]
c0d02b38:	f7ff f82a 	bl	c0d01b90 <ux_check_status_default>
c0d02b3c:	f7fe fd6a 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d02b40:	60a5      	str	r5, [r4, #8]
c0d02b42:	6820      	ldr	r0, [r4, #0]
c0d02b44:	2800      	cmp	r0, #0
c0d02b46:	d065      	beq.n	c0d02c14 <ui_idle+0x114>
c0d02b48:	69e0      	ldr	r0, [r4, #28]
c0d02b4a:	4935      	ldr	r1, [pc, #212]	; (c0d02c20 <ui_idle+0x120>)
c0d02b4c:	4288      	cmp	r0, r1
c0d02b4e:	d11e      	bne.n	c0d02b8e <ui_idle+0x8e>
c0d02b50:	e060      	b.n	c0d02c14 <ui_idle+0x114>
c0d02b52:	6860      	ldr	r0, [r4, #4]
c0d02b54:	4285      	cmp	r5, r0
c0d02b56:	d25d      	bcs.n	c0d02c14 <ui_idle+0x114>
c0d02b58:	f7ff fbac 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d02b5c:	2800      	cmp	r0, #0
c0d02b5e:	d159      	bne.n	c0d02c14 <ui_idle+0x114>
c0d02b60:	68a0      	ldr	r0, [r4, #8]
c0d02b62:	68e1      	ldr	r1, [r4, #12]
c0d02b64:	2538      	movs	r5, #56	; 0x38
c0d02b66:	4368      	muls	r0, r5
c0d02b68:	6822      	ldr	r2, [r4, #0]
c0d02b6a:	1810      	adds	r0, r2, r0
c0d02b6c:	2900      	cmp	r1, #0
c0d02b6e:	d002      	beq.n	c0d02b76 <ui_idle+0x76>
c0d02b70:	4788      	blx	r1
c0d02b72:	2800      	cmp	r0, #0
c0d02b74:	d007      	beq.n	c0d02b86 <ui_idle+0x86>
c0d02b76:	2801      	cmp	r0, #1
c0d02b78:	d103      	bne.n	c0d02b82 <ui_idle+0x82>
c0d02b7a:	68a0      	ldr	r0, [r4, #8]
c0d02b7c:	4345      	muls	r5, r0
c0d02b7e:	6820      	ldr	r0, [r4, #0]
c0d02b80:	1940      	adds	r0, r0, r5
c0d02b82:	f7fd fb47 	bl	c0d00214 <io_seproxyhal_display>
c0d02b86:	68a0      	ldr	r0, [r4, #8]
c0d02b88:	1c45      	adds	r5, r0, #1
c0d02b8a:	60a5      	str	r5, [r4, #8]
c0d02b8c:	6820      	ldr	r0, [r4, #0]
c0d02b8e:	2800      	cmp	r0, #0
c0d02b90:	d1df      	bne.n	c0d02b52 <ui_idle+0x52>
c0d02b92:	e03f      	b.n	c0d02c14 <ui_idle+0x114>

/** show the idle screen. */
void ui_idle(void) {
    uiState = UI_IDLE;
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
        UX_DISPLAY(bagl_ui_idle_blue, NULL);
c0d02b94:	4c21      	ldr	r4, [pc, #132]	; (c0d02c1c <ui_idle+0x11c>)
c0d02b96:	4823      	ldr	r0, [pc, #140]	; (c0d02c24 <ui_idle+0x124>)
c0d02b98:	4478      	add	r0, pc
c0d02b9a:	6020      	str	r0, [r4, #0]
c0d02b9c:	2005      	movs	r0, #5
c0d02b9e:	6060      	str	r0, [r4, #4]
c0d02ba0:	4821      	ldr	r0, [pc, #132]	; (c0d02c28 <ui_idle+0x128>)
c0d02ba2:	4478      	add	r0, pc
c0d02ba4:	6120      	str	r0, [r4, #16]
c0d02ba6:	2500      	movs	r5, #0
c0d02ba8:	60e5      	str	r5, [r4, #12]
c0d02baa:	2003      	movs	r0, #3
c0d02bac:	7620      	strb	r0, [r4, #24]
c0d02bae:	61e5      	str	r5, [r4, #28]
c0d02bb0:	4620      	mov	r0, r4
c0d02bb2:	3018      	adds	r0, #24
c0d02bb4:	f7ff fb3c 	bl	c0d02230 <os_ux>
c0d02bb8:	61e0      	str	r0, [r4, #28]
c0d02bba:	f7fe ffe9 	bl	c0d01b90 <ux_check_status_default>
c0d02bbe:	f7fe fd29 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d02bc2:	60a5      	str	r5, [r4, #8]
c0d02bc4:	6820      	ldr	r0, [r4, #0]
c0d02bc6:	2800      	cmp	r0, #0
c0d02bc8:	d024      	beq.n	c0d02c14 <ui_idle+0x114>
c0d02bca:	69e0      	ldr	r0, [r4, #28]
c0d02bcc:	4914      	ldr	r1, [pc, #80]	; (c0d02c20 <ui_idle+0x120>)
c0d02bce:	4288      	cmp	r0, r1
c0d02bd0:	d11e      	bne.n	c0d02c10 <ui_idle+0x110>
c0d02bd2:	e01f      	b.n	c0d02c14 <ui_idle+0x114>
c0d02bd4:	6860      	ldr	r0, [r4, #4]
c0d02bd6:	4285      	cmp	r5, r0
c0d02bd8:	d21c      	bcs.n	c0d02c14 <ui_idle+0x114>
c0d02bda:	f7ff fb6b 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d02bde:	2800      	cmp	r0, #0
c0d02be0:	d118      	bne.n	c0d02c14 <ui_idle+0x114>
c0d02be2:	68a0      	ldr	r0, [r4, #8]
c0d02be4:	68e1      	ldr	r1, [r4, #12]
c0d02be6:	2538      	movs	r5, #56	; 0x38
c0d02be8:	4368      	muls	r0, r5
c0d02bea:	6822      	ldr	r2, [r4, #0]
c0d02bec:	1810      	adds	r0, r2, r0
c0d02bee:	2900      	cmp	r1, #0
c0d02bf0:	d002      	beq.n	c0d02bf8 <ui_idle+0xf8>
c0d02bf2:	4788      	blx	r1
c0d02bf4:	2800      	cmp	r0, #0
c0d02bf6:	d007      	beq.n	c0d02c08 <ui_idle+0x108>
c0d02bf8:	2801      	cmp	r0, #1
c0d02bfa:	d103      	bne.n	c0d02c04 <ui_idle+0x104>
c0d02bfc:	68a0      	ldr	r0, [r4, #8]
c0d02bfe:	4345      	muls	r5, r0
c0d02c00:	6820      	ldr	r0, [r4, #0]
c0d02c02:	1940      	adds	r0, r0, r5
c0d02c04:	f7fd fb06 	bl	c0d00214 <io_seproxyhal_display>
c0d02c08:	68a0      	ldr	r0, [r4, #8]
c0d02c0a:	1c45      	adds	r5, r0, #1
c0d02c0c:	60a5      	str	r5, [r4, #8]
c0d02c0e:	6820      	ldr	r0, [r4, #0]
c0d02c10:	2800      	cmp	r0, #0
c0d02c12:	d1df      	bne.n	c0d02bd4 <ui_idle+0xd4>
    } else {
        UX_DISPLAY(bagl_ui_idle_nanos, NULL);
    }
}
c0d02c14:	bdb0      	pop	{r4, r5, r7, pc}
c0d02c16:	46c0      	nop			; (mov r8, r8)
c0d02c18:	20001f68 	.word	0x20001f68
c0d02c1c:	20001f6c 	.word	0x20001f6c
c0d02c20:	b0105044 	.word	0xb0105044
c0d02c24:	00001f28 	.word	0x00001f28
c0d02c28:	0000008f 	.word	0x0000008f
c0d02c2c:	000020c2 	.word	0x000020c2
c0d02c30:	00000115 	.word	0x00000115

c0d02c34 <bagl_ui_idle_blue_button>:
    ui_idle();
    return 0; // do not redraw the widget
}

static unsigned int bagl_ui_idle_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
c0d02c34:	2000      	movs	r0, #0
c0d02c36:	4770      	bx	lr

c0d02c38 <bagl_ui_idle_nanos_button>:
/**
 * buttons for the idle screen
 *
 * exit on Left button, or on Both buttons. Do nothing on Right button only.
 */
static unsigned int bagl_ui_idle_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d02c38:	b580      	push	{r7, lr}
    switch (button_mask) {
c0d02c3a:	4907      	ldr	r1, [pc, #28]	; (c0d02c58 <bagl_ui_idle_nanos_button+0x20>)
c0d02c3c:	4288      	cmp	r0, r1
c0d02c3e:	d005      	beq.n	c0d02c4c <bagl_ui_idle_nanos_button+0x14>
c0d02c40:	4906      	ldr	r1, [pc, #24]	; (c0d02c5c <bagl_ui_idle_nanos_button+0x24>)
c0d02c42:	4288      	cmp	r0, r1
c0d02c44:	d105      	bne.n	c0d02c52 <bagl_ui_idle_nanos_button+0x1a>
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            ui_public_key_1();
c0d02c46:	f000 f8d1 	bl	c0d02dec <ui_public_key_1>
c0d02c4a:	e002      	b.n	c0d02c52 <bagl_ui_idle_nanos_button+0x1a>
}

/** if the user wants to exit go back to the app dashboard. */
static const bagl_element_t *io_seproxyhal_touch_exit(const bagl_element_t *e) {
    // Go back to the dashboard
    os_sched_exit(0);
c0d02c4c:	2000      	movs	r0, #0
c0d02c4e:	f7ff fad9 	bl	c0d02204 <os_sched_exit>
        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            io_seproxyhal_touch_exit(NULL);
            break;
    }

    return 0;
c0d02c52:	2000      	movs	r0, #0
c0d02c54:	bd80      	pop	{r7, pc}
c0d02c56:	46c0      	nop			; (mov r8, r8)
c0d02c58:	80000001 	.word	0x80000001
c0d02c5c:	80000002 	.word	0x80000002

c0d02c60 <ui_top_sign>:
        UX_DISPLAY(bagl_ui_top_sign_nanos, NULL);
    }
}

/** show the top "Sign Transaction" screen. */
void ui_top_sign(void) {
c0d02c60:	b5b0      	push	{r4, r5, r7, lr}
    uiState = UI_TOP_SIGN;
c0d02c62:	4845      	ldr	r0, [pc, #276]	; (c0d02d78 <ui_top_sign+0x118>)
c0d02c64:	2102      	movs	r1, #2
c0d02c66:	7001      	strb	r1, [r0, #0]
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d02c68:	2001      	movs	r0, #1
c0d02c6a:	0204      	lsls	r4, r0, #8
c0d02c6c:	f7ff faf6 	bl	c0d0225c <os_seph_features>
c0d02c70:	4220      	tst	r0, r4
c0d02c72:	d140      	bne.n	c0d02cf6 <ui_top_sign+0x96>
        UX_DISPLAY(bagl_ui_top_sign_blue, NULL);
    } else {
        UX_DISPLAY(bagl_ui_top_sign_nanos, NULL);
c0d02c74:	4c41      	ldr	r4, [pc, #260]	; (c0d02d7c <ui_top_sign+0x11c>)
c0d02c76:	4845      	ldr	r0, [pc, #276]	; (c0d02d8c <ui_top_sign+0x12c>)
c0d02c78:	4478      	add	r0, pc
c0d02c7a:	6020      	str	r0, [r4, #0]
c0d02c7c:	2006      	movs	r0, #6
c0d02c7e:	6060      	str	r0, [r4, #4]
c0d02c80:	4843      	ldr	r0, [pc, #268]	; (c0d02d90 <ui_top_sign+0x130>)
c0d02c82:	4478      	add	r0, pc
c0d02c84:	6120      	str	r0, [r4, #16]
c0d02c86:	2500      	movs	r5, #0
c0d02c88:	60e5      	str	r5, [r4, #12]
c0d02c8a:	2003      	movs	r0, #3
c0d02c8c:	7620      	strb	r0, [r4, #24]
c0d02c8e:	61e5      	str	r5, [r4, #28]
c0d02c90:	4620      	mov	r0, r4
c0d02c92:	3018      	adds	r0, #24
c0d02c94:	f7ff facc 	bl	c0d02230 <os_ux>
c0d02c98:	61e0      	str	r0, [r4, #28]
c0d02c9a:	f7fe ff79 	bl	c0d01b90 <ux_check_status_default>
c0d02c9e:	f7fe fcb9 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d02ca2:	60a5      	str	r5, [r4, #8]
c0d02ca4:	6820      	ldr	r0, [r4, #0]
c0d02ca6:	2800      	cmp	r0, #0
c0d02ca8:	d065      	beq.n	c0d02d76 <ui_top_sign+0x116>
c0d02caa:	69e0      	ldr	r0, [r4, #28]
c0d02cac:	4934      	ldr	r1, [pc, #208]	; (c0d02d80 <ui_top_sign+0x120>)
c0d02cae:	4288      	cmp	r0, r1
c0d02cb0:	d11e      	bne.n	c0d02cf0 <ui_top_sign+0x90>
c0d02cb2:	e060      	b.n	c0d02d76 <ui_top_sign+0x116>
c0d02cb4:	6860      	ldr	r0, [r4, #4]
c0d02cb6:	4285      	cmp	r5, r0
c0d02cb8:	d25d      	bcs.n	c0d02d76 <ui_top_sign+0x116>
c0d02cba:	f7ff fafb 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d02cbe:	2800      	cmp	r0, #0
c0d02cc0:	d159      	bne.n	c0d02d76 <ui_top_sign+0x116>
c0d02cc2:	68a0      	ldr	r0, [r4, #8]
c0d02cc4:	68e1      	ldr	r1, [r4, #12]
c0d02cc6:	2538      	movs	r5, #56	; 0x38
c0d02cc8:	4368      	muls	r0, r5
c0d02cca:	6822      	ldr	r2, [r4, #0]
c0d02ccc:	1810      	adds	r0, r2, r0
c0d02cce:	2900      	cmp	r1, #0
c0d02cd0:	d002      	beq.n	c0d02cd8 <ui_top_sign+0x78>
c0d02cd2:	4788      	blx	r1
c0d02cd4:	2800      	cmp	r0, #0
c0d02cd6:	d007      	beq.n	c0d02ce8 <ui_top_sign+0x88>
c0d02cd8:	2801      	cmp	r0, #1
c0d02cda:	d103      	bne.n	c0d02ce4 <ui_top_sign+0x84>
c0d02cdc:	68a0      	ldr	r0, [r4, #8]
c0d02cde:	4345      	muls	r5, r0
c0d02ce0:	6820      	ldr	r0, [r4, #0]
c0d02ce2:	1940      	adds	r0, r0, r5
c0d02ce4:	f7fd fa96 	bl	c0d00214 <io_seproxyhal_display>
c0d02ce8:	68a0      	ldr	r0, [r4, #8]
c0d02cea:	1c45      	adds	r5, r0, #1
c0d02cec:	60a5      	str	r5, [r4, #8]
c0d02cee:	6820      	ldr	r0, [r4, #0]
c0d02cf0:	2800      	cmp	r0, #0
c0d02cf2:	d1df      	bne.n	c0d02cb4 <ui_top_sign+0x54>
c0d02cf4:	e03f      	b.n	c0d02d76 <ui_top_sign+0x116>

/** show the top "Sign Transaction" screen. */
void ui_top_sign(void) {
    uiState = UI_TOP_SIGN;
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
        UX_DISPLAY(bagl_ui_top_sign_blue, NULL);
c0d02cf6:	4c21      	ldr	r4, [pc, #132]	; (c0d02d7c <ui_top_sign+0x11c>)
c0d02cf8:	4822      	ldr	r0, [pc, #136]	; (c0d02d84 <ui_top_sign+0x124>)
c0d02cfa:	4478      	add	r0, pc
c0d02cfc:	6020      	str	r0, [r4, #0]
c0d02cfe:	2007      	movs	r0, #7
c0d02d00:	6060      	str	r0, [r4, #4]
c0d02d02:	4821      	ldr	r0, [pc, #132]	; (c0d02d88 <ui_top_sign+0x128>)
c0d02d04:	4478      	add	r0, pc
c0d02d06:	6120      	str	r0, [r4, #16]
c0d02d08:	2500      	movs	r5, #0
c0d02d0a:	60e5      	str	r5, [r4, #12]
c0d02d0c:	2003      	movs	r0, #3
c0d02d0e:	7620      	strb	r0, [r4, #24]
c0d02d10:	61e5      	str	r5, [r4, #28]
c0d02d12:	4620      	mov	r0, r4
c0d02d14:	3018      	adds	r0, #24
c0d02d16:	f7ff fa8b 	bl	c0d02230 <os_ux>
c0d02d1a:	61e0      	str	r0, [r4, #28]
c0d02d1c:	f7fe ff38 	bl	c0d01b90 <ux_check_status_default>
c0d02d20:	f7fe fc78 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d02d24:	60a5      	str	r5, [r4, #8]
c0d02d26:	6820      	ldr	r0, [r4, #0]
c0d02d28:	2800      	cmp	r0, #0
c0d02d2a:	d024      	beq.n	c0d02d76 <ui_top_sign+0x116>
c0d02d2c:	69e0      	ldr	r0, [r4, #28]
c0d02d2e:	4914      	ldr	r1, [pc, #80]	; (c0d02d80 <ui_top_sign+0x120>)
c0d02d30:	4288      	cmp	r0, r1
c0d02d32:	d11e      	bne.n	c0d02d72 <ui_top_sign+0x112>
c0d02d34:	e01f      	b.n	c0d02d76 <ui_top_sign+0x116>
c0d02d36:	6860      	ldr	r0, [r4, #4]
c0d02d38:	4285      	cmp	r5, r0
c0d02d3a:	d21c      	bcs.n	c0d02d76 <ui_top_sign+0x116>
c0d02d3c:	f7ff faba 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d02d40:	2800      	cmp	r0, #0
c0d02d42:	d118      	bne.n	c0d02d76 <ui_top_sign+0x116>
c0d02d44:	68a0      	ldr	r0, [r4, #8]
c0d02d46:	68e1      	ldr	r1, [r4, #12]
c0d02d48:	2538      	movs	r5, #56	; 0x38
c0d02d4a:	4368      	muls	r0, r5
c0d02d4c:	6822      	ldr	r2, [r4, #0]
c0d02d4e:	1810      	adds	r0, r2, r0
c0d02d50:	2900      	cmp	r1, #0
c0d02d52:	d002      	beq.n	c0d02d5a <ui_top_sign+0xfa>
c0d02d54:	4788      	blx	r1
c0d02d56:	2800      	cmp	r0, #0
c0d02d58:	d007      	beq.n	c0d02d6a <ui_top_sign+0x10a>
c0d02d5a:	2801      	cmp	r0, #1
c0d02d5c:	d103      	bne.n	c0d02d66 <ui_top_sign+0x106>
c0d02d5e:	68a0      	ldr	r0, [r4, #8]
c0d02d60:	4345      	muls	r5, r0
c0d02d62:	6820      	ldr	r0, [r4, #0]
c0d02d64:	1940      	adds	r0, r0, r5
c0d02d66:	f7fd fa55 	bl	c0d00214 <io_seproxyhal_display>
c0d02d6a:	68a0      	ldr	r0, [r4, #8]
c0d02d6c:	1c45      	adds	r5, r0, #1
c0d02d6e:	60a5      	str	r5, [r4, #8]
c0d02d70:	6820      	ldr	r0, [r4, #0]
c0d02d72:	2800      	cmp	r0, #0
c0d02d74:	d1df      	bne.n	c0d02d36 <ui_top_sign+0xd6>
    } else {
        UX_DISPLAY(bagl_ui_top_sign_nanos, NULL);
    }
}
c0d02d76:	bdb0      	pop	{r4, r5, r7, pc}
c0d02d78:	20001f68 	.word	0x20001f68
c0d02d7c:	20001f6c 	.word	0x20001f6c
c0d02d80:	b0105044 	.word	0xb0105044
c0d02d84:	000021ee 	.word	0x000021ee
c0d02d88:	0000008d 	.word	0x0000008d
c0d02d8c:	00002b30 	.word	0x00002b30
c0d02d90:	00000113 	.word	0x00000113

c0d02d94 <bagl_ui_top_sign_blue_button>:
static unsigned int bagl_ui_sign_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
}

static unsigned int bagl_ui_top_sign_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
c0d02d94:	2000      	movs	r0, #0
c0d02d96:	4770      	bx	lr

c0d02d98 <bagl_ui_top_sign_nanos_button>:
/**
 * buttons for the top "Sign Transaction" screen
 *
 * up on Left button, down on right button, sign on both buttons.
 */
static unsigned int bagl_ui_top_sign_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d02d98:	b580      	push	{r7, lr}
    switch (button_mask) {
c0d02d9a:	490a      	ldr	r1, [pc, #40]	; (c0d02dc4 <bagl_ui_top_sign_nanos_button+0x2c>)
c0d02d9c:	4288      	cmp	r0, r1
c0d02d9e:	d008      	beq.n	c0d02db2 <bagl_ui_top_sign_nanos_button+0x1a>
c0d02da0:	4909      	ldr	r1, [pc, #36]	; (c0d02dc8 <bagl_ui_top_sign_nanos_button+0x30>)
c0d02da2:	4288      	cmp	r0, r1
c0d02da4:	d009      	beq.n	c0d02dba <bagl_ui_top_sign_nanos_button+0x22>
c0d02da6:	4909      	ldr	r1, [pc, #36]	; (c0d02dcc <bagl_ui_top_sign_nanos_button+0x34>)
c0d02da8:	4288      	cmp	r0, r1
c0d02daa:	d109      	bne.n	c0d02dc0 <bagl_ui_top_sign_nanos_button+0x28>
        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT:
            io_seproxyhal_touch_approve(NULL);
c0d02dac:	f7ff fe06 	bl	c0d029bc <io_seproxyhal_touch_approve>
c0d02db0:	e006      	b.n	c0d02dc0 <bagl_ui_top_sign_nanos_button+0x28>
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
c0d02db2:	2000      	movs	r0, #0
c0d02db4:	f000 f954 	bl	c0d03060 <tx_desc_up>
c0d02db8:	e002      	b.n	c0d02dc0 <bagl_ui_top_sign_nanos_button+0x28>
        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT:
            io_seproxyhal_touch_approve(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
c0d02dba:	2000      	movs	r0, #0
c0d02dbc:	f000 f97c 	bl	c0d030b8 <tx_desc_dn>

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
            break;
    }
    return 0;
c0d02dc0:	2000      	movs	r0, #0
c0d02dc2:	bd80      	pop	{r7, pc}
c0d02dc4:	80000001 	.word	0x80000001
c0d02dc8:	80000002 	.word	0x80000002
c0d02dcc:	80000003 	.word	0x80000003

c0d02dd0 <get_apdu_buffer_length>:
    }
}

/** returns the length of the transaction in the buffer. */
unsigned int get_apdu_buffer_length() {
    unsigned int len0 = G_io_apdu_buffer[APDU_BODY_LENGTH_OFFSET];
c0d02dd0:	4801      	ldr	r0, [pc, #4]	; (c0d02dd8 <get_apdu_buffer_length+0x8>)
c0d02dd2:	7900      	ldrb	r0, [r0, #4]
    return len0;
c0d02dd4:	4770      	bx	lr
c0d02dd6:	46c0      	nop			; (mov r8, r8)
c0d02dd8:	200018f8 	.word	0x200018f8

c0d02ddc <io_seproxyhal_touch_exit>:
    }
    return 0;
}

/** if the user wants to exit go back to the app dashboard. */
static const bagl_element_t *io_seproxyhal_touch_exit(const bagl_element_t *e) {
c0d02ddc:	b510      	push	{r4, lr}
c0d02dde:	2400      	movs	r4, #0
    // Go back to the dashboard
    os_sched_exit(0);
c0d02de0:	4620      	mov	r0, r4
c0d02de2:	f7ff fa0f 	bl	c0d02204 <os_sched_exit>
    return NULL; // do not redraw the widget
c0d02de6:	4620      	mov	r0, r4
c0d02de8:	bd10      	pop	{r4, pc}
	...

c0d02dec <ui_public_key_1>:
static unsigned int bagl_ui_deny_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
}

/** show the public key screen */
void ui_public_key_1(void) {
c0d02dec:	b570      	push	{r4, r5, r6, lr}
    uiState = UI_PUBLIC_KEY_1;
c0d02dee:	483a      	ldr	r0, [pc, #232]	; (c0d02ed8 <ui_public_key_1+0xec>)
c0d02df0:	2107      	movs	r1, #7
c0d02df2:	7001      	strb	r1, [r0, #0]
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d02df4:	f7ff fa32 	bl	c0d0225c <os_seph_features>
c0d02df8:	4604      	mov	r4, r0
c0d02dfa:	4d38      	ldr	r5, [pc, #224]	; (c0d02edc <ui_public_key_1+0xf0>)
c0d02dfc:	4839      	ldr	r0, [pc, #228]	; (c0d02ee4 <ui_public_key_1+0xf8>)
c0d02dfe:	4478      	add	r0, pc
c0d02e00:	6028      	str	r0, [r5, #0]
c0d02e02:	2005      	movs	r0, #5
c0d02e04:	6068      	str	r0, [r5, #4]
c0d02e06:	4838      	ldr	r0, [pc, #224]	; (c0d02ee8 <ui_public_key_1+0xfc>)
c0d02e08:	4478      	add	r0, pc
c0d02e0a:	6128      	str	r0, [r5, #16]
c0d02e0c:	2600      	movs	r6, #0
c0d02e0e:	60ee      	str	r6, [r5, #12]
c0d02e10:	2003      	movs	r0, #3
c0d02e12:	7628      	strb	r0, [r5, #24]
c0d02e14:	61ee      	str	r6, [r5, #28]
c0d02e16:	4628      	mov	r0, r5
c0d02e18:	3018      	adds	r0, #24
        // TODO: add screen for the blue.
        UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
c0d02e1a:	f7ff fa09 	bl	c0d02230 <os_ux>
c0d02e1e:	61e8      	str	r0, [r5, #28]
c0d02e20:	f7fe feb6 	bl	c0d01b90 <ux_check_status_default>
c0d02e24:	f7fe fbf6 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d02e28:	60ae      	str	r6, [r5, #8]
c0d02e2a:	6829      	ldr	r1, [r5, #0]
c0d02e2c:	69e8      	ldr	r0, [r5, #28]
}

/** show the public key screen */
void ui_public_key_1(void) {
    uiState = UI_PUBLIC_KEY_1;
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d02e2e:	2201      	movs	r2, #1
c0d02e30:	0212      	lsls	r2, r2, #8
c0d02e32:	4214      	tst	r4, r2
c0d02e34:	d128      	bne.n	c0d02e88 <ui_public_key_1+0x9c>
        // TODO: add screen for the blue.
        UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
    } else {
        UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
c0d02e36:	2900      	cmp	r1, #0
c0d02e38:	d04c      	beq.n	c0d02ed4 <ui_public_key_1+0xe8>
c0d02e3a:	4929      	ldr	r1, [pc, #164]	; (c0d02ee0 <ui_public_key_1+0xf4>)
c0d02e3c:	4288      	cmp	r0, r1
c0d02e3e:	d049      	beq.n	c0d02ed4 <ui_public_key_1+0xe8>
c0d02e40:	2800      	cmp	r0, #0
c0d02e42:	d047      	beq.n	c0d02ed4 <ui_public_key_1+0xe8>
c0d02e44:	2000      	movs	r0, #0
c0d02e46:	6869      	ldr	r1, [r5, #4]
c0d02e48:	4288      	cmp	r0, r1
c0d02e4a:	d243      	bcs.n	c0d02ed4 <ui_public_key_1+0xe8>
c0d02e4c:	f7ff fa32 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d02e50:	2800      	cmp	r0, #0
c0d02e52:	d13f      	bne.n	c0d02ed4 <ui_public_key_1+0xe8>
c0d02e54:	68a8      	ldr	r0, [r5, #8]
c0d02e56:	68e9      	ldr	r1, [r5, #12]
c0d02e58:	2438      	movs	r4, #56	; 0x38
c0d02e5a:	4360      	muls	r0, r4
c0d02e5c:	682a      	ldr	r2, [r5, #0]
c0d02e5e:	1810      	adds	r0, r2, r0
c0d02e60:	2900      	cmp	r1, #0
c0d02e62:	d002      	beq.n	c0d02e6a <ui_public_key_1+0x7e>
c0d02e64:	4788      	blx	r1
c0d02e66:	2800      	cmp	r0, #0
c0d02e68:	d007      	beq.n	c0d02e7a <ui_public_key_1+0x8e>
c0d02e6a:	2801      	cmp	r0, #1
c0d02e6c:	d103      	bne.n	c0d02e76 <ui_public_key_1+0x8a>
c0d02e6e:	68a8      	ldr	r0, [r5, #8]
c0d02e70:	4344      	muls	r4, r0
c0d02e72:	6828      	ldr	r0, [r5, #0]
c0d02e74:	1900      	adds	r0, r0, r4
c0d02e76:	f7fd f9cd 	bl	c0d00214 <io_seproxyhal_display>
c0d02e7a:	68a8      	ldr	r0, [r5, #8]
c0d02e7c:	1c40      	adds	r0, r0, #1
c0d02e7e:	60a8      	str	r0, [r5, #8]
c0d02e80:	6829      	ldr	r1, [r5, #0]
c0d02e82:	2900      	cmp	r1, #0
c0d02e84:	d1df      	bne.n	c0d02e46 <ui_public_key_1+0x5a>
c0d02e86:	e025      	b.n	c0d02ed4 <ui_public_key_1+0xe8>
/** show the public key screen */
void ui_public_key_1(void) {
    uiState = UI_PUBLIC_KEY_1;
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
        // TODO: add screen for the blue.
        UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
c0d02e88:	2900      	cmp	r1, #0
c0d02e8a:	d023      	beq.n	c0d02ed4 <ui_public_key_1+0xe8>
c0d02e8c:	4914      	ldr	r1, [pc, #80]	; (c0d02ee0 <ui_public_key_1+0xf4>)
c0d02e8e:	4288      	cmp	r0, r1
c0d02e90:	d11e      	bne.n	c0d02ed0 <ui_public_key_1+0xe4>
c0d02e92:	e01f      	b.n	c0d02ed4 <ui_public_key_1+0xe8>
c0d02e94:	6868      	ldr	r0, [r5, #4]
c0d02e96:	4286      	cmp	r6, r0
c0d02e98:	d21c      	bcs.n	c0d02ed4 <ui_public_key_1+0xe8>
c0d02e9a:	f7ff fa0b 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d02e9e:	2800      	cmp	r0, #0
c0d02ea0:	d118      	bne.n	c0d02ed4 <ui_public_key_1+0xe8>
c0d02ea2:	68a8      	ldr	r0, [r5, #8]
c0d02ea4:	68e9      	ldr	r1, [r5, #12]
c0d02ea6:	2438      	movs	r4, #56	; 0x38
c0d02ea8:	4360      	muls	r0, r4
c0d02eaa:	682a      	ldr	r2, [r5, #0]
c0d02eac:	1810      	adds	r0, r2, r0
c0d02eae:	2900      	cmp	r1, #0
c0d02eb0:	d002      	beq.n	c0d02eb8 <ui_public_key_1+0xcc>
c0d02eb2:	4788      	blx	r1
c0d02eb4:	2800      	cmp	r0, #0
c0d02eb6:	d007      	beq.n	c0d02ec8 <ui_public_key_1+0xdc>
c0d02eb8:	2801      	cmp	r0, #1
c0d02eba:	d103      	bne.n	c0d02ec4 <ui_public_key_1+0xd8>
c0d02ebc:	68a8      	ldr	r0, [r5, #8]
c0d02ebe:	4344      	muls	r4, r0
c0d02ec0:	6828      	ldr	r0, [r5, #0]
c0d02ec2:	1900      	adds	r0, r0, r4
c0d02ec4:	f7fd f9a6 	bl	c0d00214 <io_seproxyhal_display>
c0d02ec8:	68a8      	ldr	r0, [r5, #8]
c0d02eca:	1c46      	adds	r6, r0, #1
c0d02ecc:	60ae      	str	r6, [r5, #8]
c0d02ece:	6828      	ldr	r0, [r5, #0]
c0d02ed0:	2800      	cmp	r0, #0
c0d02ed2:	d1df      	bne.n	c0d02e94 <ui_public_key_1+0xa8>
    } else {
        UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
    }
}
c0d02ed4:	bd70      	pop	{r4, r5, r6, pc}
c0d02ed6:	46c0      	nop			; (mov r8, r8)
c0d02ed8:	20001f68 	.word	0x20001f68
c0d02edc:	20001f6c 	.word	0x20001f6c
c0d02ee0:	b0105044 	.word	0xb0105044
c0d02ee4:	00001eba 	.word	0x00001eba
c0d02ee8:	000000e1 	.word	0x000000e1

c0d02eec <bagl_ui_public_key_nanos_1_button>:
/**
 * buttons for the idle screen
 *
 * exit on Left button, or on Both buttons. Do nothing on Right button only.
 */
static unsigned int bagl_ui_public_key_nanos_1_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d02eec:	b5b0      	push	{r4, r5, r7, lr}
    switch (button_mask) {
c0d02eee:	494a      	ldr	r1, [pc, #296]	; (c0d03018 <bagl_ui_public_key_nanos_1_button+0x12c>)
c0d02ef0:	4288      	cmp	r0, r1
c0d02ef2:	d006      	beq.n	c0d02f02 <bagl_ui_public_key_nanos_1_button+0x16>
c0d02ef4:	4949      	ldr	r1, [pc, #292]	; (c0d0301c <bagl_ui_public_key_nanos_1_button+0x130>)
c0d02ef6:	4288      	cmp	r0, r1
c0d02ef8:	d101      	bne.n	c0d02efe <bagl_ui_public_key_nanos_1_button+0x12>
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            ui_idle();
c0d02efa:	f7ff fe01 	bl	c0d02b00 <ui_idle>
            ui_public_key_2();
            break;
    }


    return 0;
c0d02efe:	2000      	movs	r0, #0
c0d02f00:	bdb0      	pop	{r4, r5, r7, pc}
    }
}

/** show the public key screen */
void ui_public_key_2(void) {
    uiState = UI_PUBLIC_KEY_2;
c0d02f02:	4847      	ldr	r0, [pc, #284]	; (c0d03020 <bagl_ui_public_key_nanos_1_button+0x134>)
c0d02f04:	2108      	movs	r1, #8
c0d02f06:	7001      	strb	r1, [r0, #0]
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d02f08:	2001      	movs	r0, #1
c0d02f0a:	0204      	lsls	r4, r0, #8
c0d02f0c:	f7ff f9a6 	bl	c0d0225c <os_seph_features>
c0d02f10:	4220      	tst	r0, r4
c0d02f12:	d140      	bne.n	c0d02f96 <bagl_ui_public_key_nanos_1_button+0xaa>
        // TODO: add screen for the blue.
        UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
    } else {
        UX_DISPLAY(bagl_ui_public_key_nanos_2, NULL);
c0d02f14:	4c43      	ldr	r4, [pc, #268]	; (c0d03024 <bagl_ui_public_key_nanos_1_button+0x138>)
c0d02f16:	4847      	ldr	r0, [pc, #284]	; (c0d03034 <bagl_ui_public_key_nanos_1_button+0x148>)
c0d02f18:	4478      	add	r0, pc
c0d02f1a:	6020      	str	r0, [r4, #0]
c0d02f1c:	2005      	movs	r0, #5
c0d02f1e:	6060      	str	r0, [r4, #4]
c0d02f20:	4845      	ldr	r0, [pc, #276]	; (c0d03038 <bagl_ui_public_key_nanos_1_button+0x14c>)
c0d02f22:	4478      	add	r0, pc
c0d02f24:	6120      	str	r0, [r4, #16]
c0d02f26:	2500      	movs	r5, #0
c0d02f28:	60e5      	str	r5, [r4, #12]
c0d02f2a:	2003      	movs	r0, #3
c0d02f2c:	7620      	strb	r0, [r4, #24]
c0d02f2e:	61e5      	str	r5, [r4, #28]
c0d02f30:	4620      	mov	r0, r4
c0d02f32:	3018      	adds	r0, #24
c0d02f34:	f7ff f97c 	bl	c0d02230 <os_ux>
c0d02f38:	61e0      	str	r0, [r4, #28]
c0d02f3a:	f7fe fe29 	bl	c0d01b90 <ux_check_status_default>
c0d02f3e:	f7fe fb69 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d02f42:	60a5      	str	r5, [r4, #8]
c0d02f44:	6820      	ldr	r0, [r4, #0]
c0d02f46:	2800      	cmp	r0, #0
c0d02f48:	d0d9      	beq.n	c0d02efe <bagl_ui_public_key_nanos_1_button+0x12>
c0d02f4a:	69e0      	ldr	r0, [r4, #28]
c0d02f4c:	4936      	ldr	r1, [pc, #216]	; (c0d03028 <bagl_ui_public_key_nanos_1_button+0x13c>)
c0d02f4e:	4288      	cmp	r0, r1
c0d02f50:	d11e      	bne.n	c0d02f90 <bagl_ui_public_key_nanos_1_button+0xa4>
c0d02f52:	e7d4      	b.n	c0d02efe <bagl_ui_public_key_nanos_1_button+0x12>
c0d02f54:	6860      	ldr	r0, [r4, #4]
c0d02f56:	4285      	cmp	r5, r0
c0d02f58:	d2d1      	bcs.n	c0d02efe <bagl_ui_public_key_nanos_1_button+0x12>
c0d02f5a:	f7ff f9ab 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d02f5e:	2800      	cmp	r0, #0
c0d02f60:	d1cd      	bne.n	c0d02efe <bagl_ui_public_key_nanos_1_button+0x12>
c0d02f62:	68a0      	ldr	r0, [r4, #8]
c0d02f64:	68e1      	ldr	r1, [r4, #12]
c0d02f66:	2538      	movs	r5, #56	; 0x38
c0d02f68:	4368      	muls	r0, r5
c0d02f6a:	6822      	ldr	r2, [r4, #0]
c0d02f6c:	1810      	adds	r0, r2, r0
c0d02f6e:	2900      	cmp	r1, #0
c0d02f70:	d002      	beq.n	c0d02f78 <bagl_ui_public_key_nanos_1_button+0x8c>
c0d02f72:	4788      	blx	r1
c0d02f74:	2800      	cmp	r0, #0
c0d02f76:	d007      	beq.n	c0d02f88 <bagl_ui_public_key_nanos_1_button+0x9c>
c0d02f78:	2801      	cmp	r0, #1
c0d02f7a:	d103      	bne.n	c0d02f84 <bagl_ui_public_key_nanos_1_button+0x98>
c0d02f7c:	68a0      	ldr	r0, [r4, #8]
c0d02f7e:	4345      	muls	r5, r0
c0d02f80:	6820      	ldr	r0, [r4, #0]
c0d02f82:	1940      	adds	r0, r0, r5
c0d02f84:	f7fd f946 	bl	c0d00214 <io_seproxyhal_display>
c0d02f88:	68a0      	ldr	r0, [r4, #8]
c0d02f8a:	1c45      	adds	r5, r0, #1
c0d02f8c:	60a5      	str	r5, [r4, #8]
c0d02f8e:	6820      	ldr	r0, [r4, #0]
c0d02f90:	2800      	cmp	r0, #0
c0d02f92:	d1df      	bne.n	c0d02f54 <bagl_ui_public_key_nanos_1_button+0x68>
c0d02f94:	e7b3      	b.n	c0d02efe <bagl_ui_public_key_nanos_1_button+0x12>
/** show the public key screen */
void ui_public_key_2(void) {
    uiState = UI_PUBLIC_KEY_2;
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
        // TODO: add screen for the blue.
        UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
c0d02f96:	4c23      	ldr	r4, [pc, #140]	; (c0d03024 <bagl_ui_public_key_nanos_1_button+0x138>)
c0d02f98:	4824      	ldr	r0, [pc, #144]	; (c0d0302c <bagl_ui_public_key_nanos_1_button+0x140>)
c0d02f9a:	4478      	add	r0, pc
c0d02f9c:	6020      	str	r0, [r4, #0]
c0d02f9e:	2005      	movs	r0, #5
c0d02fa0:	6060      	str	r0, [r4, #4]
c0d02fa2:	4823      	ldr	r0, [pc, #140]	; (c0d03030 <bagl_ui_public_key_nanos_1_button+0x144>)
c0d02fa4:	4478      	add	r0, pc
c0d02fa6:	6120      	str	r0, [r4, #16]
c0d02fa8:	2500      	movs	r5, #0
c0d02faa:	60e5      	str	r5, [r4, #12]
c0d02fac:	2003      	movs	r0, #3
c0d02fae:	7620      	strb	r0, [r4, #24]
c0d02fb0:	61e5      	str	r5, [r4, #28]
c0d02fb2:	4620      	mov	r0, r4
c0d02fb4:	3018      	adds	r0, #24
c0d02fb6:	f7ff f93b 	bl	c0d02230 <os_ux>
c0d02fba:	61e0      	str	r0, [r4, #28]
c0d02fbc:	f7fe fde8 	bl	c0d01b90 <ux_check_status_default>
c0d02fc0:	f7fe fb28 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d02fc4:	60a5      	str	r5, [r4, #8]
c0d02fc6:	6820      	ldr	r0, [r4, #0]
c0d02fc8:	2800      	cmp	r0, #0
c0d02fca:	d098      	beq.n	c0d02efe <bagl_ui_public_key_nanos_1_button+0x12>
c0d02fcc:	69e0      	ldr	r0, [r4, #28]
c0d02fce:	4916      	ldr	r1, [pc, #88]	; (c0d03028 <bagl_ui_public_key_nanos_1_button+0x13c>)
c0d02fd0:	4288      	cmp	r0, r1
c0d02fd2:	d11e      	bne.n	c0d03012 <bagl_ui_public_key_nanos_1_button+0x126>
c0d02fd4:	e793      	b.n	c0d02efe <bagl_ui_public_key_nanos_1_button+0x12>
c0d02fd6:	6860      	ldr	r0, [r4, #4]
c0d02fd8:	4285      	cmp	r5, r0
c0d02fda:	d290      	bcs.n	c0d02efe <bagl_ui_public_key_nanos_1_button+0x12>
c0d02fdc:	f7ff f96a 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d02fe0:	2800      	cmp	r0, #0
c0d02fe2:	d18c      	bne.n	c0d02efe <bagl_ui_public_key_nanos_1_button+0x12>
c0d02fe4:	68a0      	ldr	r0, [r4, #8]
c0d02fe6:	68e1      	ldr	r1, [r4, #12]
c0d02fe8:	2538      	movs	r5, #56	; 0x38
c0d02fea:	4368      	muls	r0, r5
c0d02fec:	6822      	ldr	r2, [r4, #0]
c0d02fee:	1810      	adds	r0, r2, r0
c0d02ff0:	2900      	cmp	r1, #0
c0d02ff2:	d002      	beq.n	c0d02ffa <bagl_ui_public_key_nanos_1_button+0x10e>
c0d02ff4:	4788      	blx	r1
c0d02ff6:	2800      	cmp	r0, #0
c0d02ff8:	d007      	beq.n	c0d0300a <bagl_ui_public_key_nanos_1_button+0x11e>
c0d02ffa:	2801      	cmp	r0, #1
c0d02ffc:	d103      	bne.n	c0d03006 <bagl_ui_public_key_nanos_1_button+0x11a>
c0d02ffe:	68a0      	ldr	r0, [r4, #8]
c0d03000:	4345      	muls	r5, r0
c0d03002:	6820      	ldr	r0, [r4, #0]
c0d03004:	1940      	adds	r0, r0, r5
c0d03006:	f7fd f905 	bl	c0d00214 <io_seproxyhal_display>
c0d0300a:	68a0      	ldr	r0, [r4, #8]
c0d0300c:	1c45      	adds	r5, r0, #1
c0d0300e:	60a5      	str	r5, [r4, #8]
c0d03010:	6820      	ldr	r0, [r4, #0]
c0d03012:	2800      	cmp	r0, #0
c0d03014:	d1df      	bne.n	c0d02fd6 <bagl_ui_public_key_nanos_1_button+0xea>
c0d03016:	e772      	b.n	c0d02efe <bagl_ui_public_key_nanos_1_button+0x12>
c0d03018:	80000001 	.word	0x80000001
c0d0301c:	80000002 	.word	0x80000002
c0d03020:	20001f68 	.word	0x20001f68
c0d03024:	20001f6c 	.word	0x20001f6c
c0d03028:	b0105044 	.word	0xb0105044
c0d0302c:	00001d1e 	.word	0x00001d1e
c0d03030:	ffffff45 	.word	0xffffff45
c0d03034:	00001eb8 	.word	0x00001eb8
c0d03038:	00000117 	.word	0x00000117

c0d0303c <bagl_ui_public_key_nanos_2_button>:
/**
 * buttons for the idle screen
 *
 * exit on Left button, or on Both buttons. Do nothing on Right button only.
 */
static unsigned int bagl_ui_public_key_nanos_2_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d0303c:	b580      	push	{r7, lr}
    switch (button_mask) {
c0d0303e:	4906      	ldr	r1, [pc, #24]	; (c0d03058 <bagl_ui_public_key_nanos_2_button+0x1c>)
c0d03040:	4288      	cmp	r0, r1
c0d03042:	d005      	beq.n	c0d03050 <bagl_ui_public_key_nanos_2_button+0x14>
c0d03044:	4905      	ldr	r1, [pc, #20]	; (c0d0305c <bagl_ui_public_key_nanos_2_button+0x20>)
c0d03046:	4288      	cmp	r0, r1
c0d03048:	d104      	bne.n	c0d03054 <bagl_ui_public_key_nanos_2_button+0x18>
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            ui_idle();
c0d0304a:	f7ff fd59 	bl	c0d02b00 <ui_idle>
c0d0304e:	e001      	b.n	c0d03054 <bagl_ui_public_key_nanos_2_button+0x18>
            break;
        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            ui_public_key_1();
c0d03050:	f7ff fecc 	bl	c0d02dec <ui_public_key_1>
            break;
    }
    return 0;
c0d03054:	2000      	movs	r0, #0
c0d03056:	bd80      	pop	{r7, pc}
c0d03058:	80000001 	.word	0x80000001
c0d0305c:	80000002 	.word	0x80000002

c0d03060 <tx_desc_up>:
    curr_tx_desc[1][MAX_TX_TEXT_WIDTH - 1] = '\0';
    curr_tx_desc[2][MAX_TX_TEXT_WIDTH - 1] = '\0';
}

/** processes the Up button */
static const bagl_element_t *tx_desc_up(const bagl_element_t *e) {
c0d03060:	b580      	push	{r7, lr}
    switch (uiState) {
c0d03062:	4812      	ldr	r0, [pc, #72]	; (c0d030ac <tx_desc_up+0x4c>)
c0d03064:	7800      	ldrb	r0, [r0, #0]
c0d03066:	2803      	cmp	r0, #3
c0d03068:	dd08      	ble.n	c0d0307c <tx_desc_up+0x1c>
c0d0306a:	2804      	cmp	r0, #4
c0d0306c:	d00d      	beq.n	c0d0308a <tx_desc_up+0x2a>
c0d0306e:	2805      	cmp	r0, #5
c0d03070:	d00e      	beq.n	c0d03090 <tx_desc_up+0x30>
c0d03072:	2806      	cmp	r0, #6
c0d03074:	d113      	bne.n	c0d0309e <tx_desc_up+0x3e>
            //curr_scr_ix = max_scr_ix - 1;
            //copy_tx_desc();
            ui_display_tx_desc_2();
            break;
        case UI_DENY:
            ui_sign();
c0d03076:	f000 fa17 	bl	c0d034a8 <ui_sign>
c0d0307a:	e00e      	b.n	c0d0309a <tx_desc_up+0x3a>
c0d0307c:	2802      	cmp	r0, #2
c0d0307e:	d00a      	beq.n	c0d03096 <tx_desc_up+0x36>
c0d03080:	2803      	cmp	r0, #3
c0d03082:	d10c      	bne.n	c0d0309e <tx_desc_up+0x3e>
    switch (uiState) {
        case UI_TOP_SIGN:
            ui_deny();
            break;
        case UI_TX_DESC_1:
            ui_top_sign();
c0d03084:	f7ff fdec 	bl	c0d02c60 <ui_top_sign>
c0d03088:	e007      	b.n	c0d0309a <tx_desc_up+0x3a>
                //ui_display_tx_desc_2();
            }
            break;

        case UI_TX_DESC_2:
            ui_display_tx_desc_1();
c0d0308a:	f000 f8db 	bl	c0d03244 <ui_display_tx_desc_1>
c0d0308e:	e004      	b.n	c0d0309a <tx_desc_up+0x3a>
            break;
        case UI_SIGN:
            //curr_scr_ix = max_scr_ix - 1;
            //copy_tx_desc();
            ui_display_tx_desc_2();
c0d03090:	f000 f970 	bl	c0d03374 <ui_display_tx_desc_2>
c0d03094:	e001      	b.n	c0d0309a <tx_desc_up+0x3a>

/** processes the Up button */
static const bagl_element_t *tx_desc_up(const bagl_element_t *e) {
    switch (uiState) {
        case UI_TOP_SIGN:
            ui_deny();
c0d03096:	f000 f83b 	bl	c0d03110 <ui_deny>
        default:
            hashTainted = 1;
            THROW(0x6D02);
            break;
    }
    return NULL;
c0d0309a:	2000      	movs	r0, #0
c0d0309c:	bd80      	pop	{r7, pc}
        case UI_DENY:
            ui_sign();
            break;

        default:
            hashTainted = 1;
c0d0309e:	4804      	ldr	r0, [pc, #16]	; (c0d030b0 <tx_desc_up+0x50>)
c0d030a0:	2101      	movs	r1, #1
c0d030a2:	7001      	strb	r1, [r0, #0]
            THROW(0x6D02);
c0d030a4:	4803      	ldr	r0, [pc, #12]	; (c0d030b4 <tx_desc_up+0x54>)
c0d030a6:	f7fe f954 	bl	c0d01352 <os_longjmp>
c0d030aa:	46c0      	nop			; (mov r8, r8)
c0d030ac:	20001f68 	.word	0x20001f68
c0d030b0:	20001f60 	.word	0x20001f60
c0d030b4:	00006d02 	.word	0x00006d02

c0d030b8 <tx_desc_dn>:
    }
    return NULL;
}

/** processes the Down button */
static const bagl_element_t *tx_desc_dn(const bagl_element_t *e) {
c0d030b8:	b580      	push	{r7, lr}
    switch (uiState) {
c0d030ba:	4812      	ldr	r0, [pc, #72]	; (c0d03104 <tx_desc_dn+0x4c>)
c0d030bc:	7800      	ldrb	r0, [r0, #0]
c0d030be:	2803      	cmp	r0, #3
c0d030c0:	dd08      	ble.n	c0d030d4 <tx_desc_dn+0x1c>
c0d030c2:	2804      	cmp	r0, #4
c0d030c4:	d00d      	beq.n	c0d030e2 <tx_desc_dn+0x2a>
c0d030c6:	2805      	cmp	r0, #5
c0d030c8:	d00e      	beq.n	c0d030e8 <tx_desc_dn+0x30>
c0d030ca:	2806      	cmp	r0, #6
c0d030cc:	d113      	bne.n	c0d030f6 <tx_desc_dn+0x3e>
        case UI_SIGN:
            ui_deny();
            break;

        case UI_DENY:
            ui_top_sign();
c0d030ce:	f7ff fdc7 	bl	c0d02c60 <ui_top_sign>
c0d030d2:	e00e      	b.n	c0d030f2 <tx_desc_dn+0x3a>
c0d030d4:	2802      	cmp	r0, #2
c0d030d6:	d00a      	beq.n	c0d030ee <tx_desc_dn+0x36>
c0d030d8:	2803      	cmp	r0, #3
c0d030da:	d10c      	bne.n	c0d030f6 <tx_desc_dn+0x3e>

            break;
        case UI_TX_DESC_1:
            ui_display_tx_desc_2();
c0d030dc:	f000 f94a 	bl	c0d03374 <ui_display_tx_desc_2>
c0d030e0:	e007      	b.n	c0d030f2 <tx_desc_dn+0x3a>
            break;
        case UI_TX_DESC_2:
            ui_sign();
c0d030e2:	f000 f9e1 	bl	c0d034a8 <ui_sign>
c0d030e6:	e004      	b.n	c0d030f2 <tx_desc_dn+0x3a>
			//ui_display_tx_desc_1();
		}
		break;
*/
        case UI_SIGN:
            ui_deny();
c0d030e8:	f000 f812 	bl	c0d03110 <ui_deny>
c0d030ec:	e001      	b.n	c0d030f2 <tx_desc_dn+0x3a>
    switch (uiState) {
        case UI_TOP_SIGN:
            //ui_deny();
            //curr_scr_ix = 0;
            //copy_tx_desc();
            ui_display_tx_desc_1();
c0d030ee:	f000 f8a9 	bl	c0d03244 <ui_display_tx_desc_1>
        default:
            hashTainted = 1;
            THROW(0x6D01);
            break;
    }
    return NULL;
c0d030f2:	2000      	movs	r0, #0
c0d030f4:	bd80      	pop	{r7, pc}
        case UI_TX_DESC_2:
            ui_sign();
            break;

        default:
            hashTainted = 1;
c0d030f6:	4804      	ldr	r0, [pc, #16]	; (c0d03108 <tx_desc_dn+0x50>)
c0d030f8:	2101      	movs	r1, #1
c0d030fa:	7001      	strb	r1, [r0, #0]
            THROW(0x6D01);
c0d030fc:	4803      	ldr	r0, [pc, #12]	; (c0d0310c <tx_desc_dn+0x54>)
c0d030fe:	f7fe f928 	bl	c0d01352 <os_longjmp>
c0d03102:	46c0      	nop			; (mov r8, r8)
c0d03104:	20001f68 	.word	0x20001f68
c0d03108:	20001f60 	.word	0x20001f60
c0d0310c:	00006d01 	.word	0x00006d01

c0d03110 <ui_deny>:
        UX_DISPLAY(bagl_ui_top_sign_nanos, NULL);
    }
}

/** show the "deny" screen */
static void ui_deny(void) {
c0d03110:	b5b0      	push	{r4, r5, r7, lr}
    uiState = UI_DENY;
c0d03112:	4845      	ldr	r0, [pc, #276]	; (c0d03228 <ui_deny+0x118>)
c0d03114:	2506      	movs	r5, #6
c0d03116:	7005      	strb	r5, [r0, #0]
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d03118:	2001      	movs	r0, #1
c0d0311a:	0204      	lsls	r4, r0, #8
c0d0311c:	f7ff f89e 	bl	c0d0225c <os_seph_features>
c0d03120:	4220      	tst	r0, r4
c0d03122:	d13f      	bne.n	c0d031a4 <ui_deny+0x94>
        UX_DISPLAY(bagl_ui_deny_blue, NULL);
    } else {
        UX_DISPLAY(bagl_ui_deny_nanos, NULL);
c0d03124:	4c41      	ldr	r4, [pc, #260]	; (c0d0322c <ui_deny+0x11c>)
c0d03126:	4845      	ldr	r0, [pc, #276]	; (c0d0323c <ui_deny+0x12c>)
c0d03128:	4478      	add	r0, pc
c0d0312a:	c421      	stmia	r4!, {r0, r5}
c0d0312c:	4844      	ldr	r0, [pc, #272]	; (c0d03240 <ui_deny+0x130>)
c0d0312e:	4478      	add	r0, pc
c0d03130:	60a0      	str	r0, [r4, #8]
c0d03132:	2500      	movs	r5, #0
c0d03134:	6065      	str	r5, [r4, #4]
c0d03136:	2003      	movs	r0, #3
c0d03138:	7420      	strb	r0, [r4, #16]
c0d0313a:	6165      	str	r5, [r4, #20]
c0d0313c:	3c08      	subs	r4, #8
c0d0313e:	4620      	mov	r0, r4
c0d03140:	3018      	adds	r0, #24
c0d03142:	f7ff f875 	bl	c0d02230 <os_ux>
c0d03146:	61e0      	str	r0, [r4, #28]
c0d03148:	f7fe fd22 	bl	c0d01b90 <ux_check_status_default>
c0d0314c:	f7fe fa62 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d03150:	60a5      	str	r5, [r4, #8]
c0d03152:	6820      	ldr	r0, [r4, #0]
c0d03154:	2800      	cmp	r0, #0
c0d03156:	d065      	beq.n	c0d03224 <ui_deny+0x114>
c0d03158:	69e0      	ldr	r0, [r4, #28]
c0d0315a:	4935      	ldr	r1, [pc, #212]	; (c0d03230 <ui_deny+0x120>)
c0d0315c:	4288      	cmp	r0, r1
c0d0315e:	d11e      	bne.n	c0d0319e <ui_deny+0x8e>
c0d03160:	e060      	b.n	c0d03224 <ui_deny+0x114>
c0d03162:	6860      	ldr	r0, [r4, #4]
c0d03164:	4285      	cmp	r5, r0
c0d03166:	d25d      	bcs.n	c0d03224 <ui_deny+0x114>
c0d03168:	f7ff f8a4 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d0316c:	2800      	cmp	r0, #0
c0d0316e:	d159      	bne.n	c0d03224 <ui_deny+0x114>
c0d03170:	68a0      	ldr	r0, [r4, #8]
c0d03172:	68e1      	ldr	r1, [r4, #12]
c0d03174:	2538      	movs	r5, #56	; 0x38
c0d03176:	4368      	muls	r0, r5
c0d03178:	6822      	ldr	r2, [r4, #0]
c0d0317a:	1810      	adds	r0, r2, r0
c0d0317c:	2900      	cmp	r1, #0
c0d0317e:	d002      	beq.n	c0d03186 <ui_deny+0x76>
c0d03180:	4788      	blx	r1
c0d03182:	2800      	cmp	r0, #0
c0d03184:	d007      	beq.n	c0d03196 <ui_deny+0x86>
c0d03186:	2801      	cmp	r0, #1
c0d03188:	d103      	bne.n	c0d03192 <ui_deny+0x82>
c0d0318a:	68a0      	ldr	r0, [r4, #8]
c0d0318c:	4345      	muls	r5, r0
c0d0318e:	6820      	ldr	r0, [r4, #0]
c0d03190:	1940      	adds	r0, r0, r5
c0d03192:	f7fd f83f 	bl	c0d00214 <io_seproxyhal_display>
c0d03196:	68a0      	ldr	r0, [r4, #8]
c0d03198:	1c45      	adds	r5, r0, #1
c0d0319a:	60a5      	str	r5, [r4, #8]
c0d0319c:	6820      	ldr	r0, [r4, #0]
c0d0319e:	2800      	cmp	r0, #0
c0d031a0:	d1df      	bne.n	c0d03162 <ui_deny+0x52>
c0d031a2:	e03f      	b.n	c0d03224 <ui_deny+0x114>

/** show the "deny" screen */
static void ui_deny(void) {
    uiState = UI_DENY;
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
        UX_DISPLAY(bagl_ui_deny_blue, NULL);
c0d031a4:	4c21      	ldr	r4, [pc, #132]	; (c0d0322c <ui_deny+0x11c>)
c0d031a6:	4823      	ldr	r0, [pc, #140]	; (c0d03234 <ui_deny+0x124>)
c0d031a8:	4478      	add	r0, pc
c0d031aa:	6020      	str	r0, [r4, #0]
c0d031ac:	2007      	movs	r0, #7
c0d031ae:	6060      	str	r0, [r4, #4]
c0d031b0:	4821      	ldr	r0, [pc, #132]	; (c0d03238 <ui_deny+0x128>)
c0d031b2:	4478      	add	r0, pc
c0d031b4:	6120      	str	r0, [r4, #16]
c0d031b6:	2500      	movs	r5, #0
c0d031b8:	60e5      	str	r5, [r4, #12]
c0d031ba:	2003      	movs	r0, #3
c0d031bc:	7620      	strb	r0, [r4, #24]
c0d031be:	61e5      	str	r5, [r4, #28]
c0d031c0:	4620      	mov	r0, r4
c0d031c2:	3018      	adds	r0, #24
c0d031c4:	f7ff f834 	bl	c0d02230 <os_ux>
c0d031c8:	61e0      	str	r0, [r4, #28]
c0d031ca:	f7fe fce1 	bl	c0d01b90 <ux_check_status_default>
c0d031ce:	f7fe fa21 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d031d2:	60a5      	str	r5, [r4, #8]
c0d031d4:	6820      	ldr	r0, [r4, #0]
c0d031d6:	2800      	cmp	r0, #0
c0d031d8:	d024      	beq.n	c0d03224 <ui_deny+0x114>
c0d031da:	69e0      	ldr	r0, [r4, #28]
c0d031dc:	4914      	ldr	r1, [pc, #80]	; (c0d03230 <ui_deny+0x120>)
c0d031de:	4288      	cmp	r0, r1
c0d031e0:	d11e      	bne.n	c0d03220 <ui_deny+0x110>
c0d031e2:	e01f      	b.n	c0d03224 <ui_deny+0x114>
c0d031e4:	6860      	ldr	r0, [r4, #4]
c0d031e6:	4285      	cmp	r5, r0
c0d031e8:	d21c      	bcs.n	c0d03224 <ui_deny+0x114>
c0d031ea:	f7ff f863 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d031ee:	2800      	cmp	r0, #0
c0d031f0:	d118      	bne.n	c0d03224 <ui_deny+0x114>
c0d031f2:	68a0      	ldr	r0, [r4, #8]
c0d031f4:	68e1      	ldr	r1, [r4, #12]
c0d031f6:	2538      	movs	r5, #56	; 0x38
c0d031f8:	4368      	muls	r0, r5
c0d031fa:	6822      	ldr	r2, [r4, #0]
c0d031fc:	1810      	adds	r0, r2, r0
c0d031fe:	2900      	cmp	r1, #0
c0d03200:	d002      	beq.n	c0d03208 <ui_deny+0xf8>
c0d03202:	4788      	blx	r1
c0d03204:	2800      	cmp	r0, #0
c0d03206:	d007      	beq.n	c0d03218 <ui_deny+0x108>
c0d03208:	2801      	cmp	r0, #1
c0d0320a:	d103      	bne.n	c0d03214 <ui_deny+0x104>
c0d0320c:	68a0      	ldr	r0, [r4, #8]
c0d0320e:	4345      	muls	r5, r0
c0d03210:	6820      	ldr	r0, [r4, #0]
c0d03212:	1940      	adds	r0, r0, r5
c0d03214:	f7fc fffe 	bl	c0d00214 <io_seproxyhal_display>
c0d03218:	68a0      	ldr	r0, [r4, #8]
c0d0321a:	1c45      	adds	r5, r0, #1
c0d0321c:	60a5      	str	r5, [r4, #8]
c0d0321e:	6820      	ldr	r0, [r4, #0]
c0d03220:	2800      	cmp	r0, #0
c0d03222:	d1df      	bne.n	c0d031e4 <ui_deny+0xd4>
    } else {
        UX_DISPLAY(bagl_ui_deny_nanos, NULL);
    }
}
c0d03224:	bdb0      	pop	{r4, r5, r7, pc}
c0d03226:	46c0      	nop			; (mov r8, r8)
c0d03228:	20001f68 	.word	0x20001f68
c0d0322c:	20001f6c 	.word	0x20001f6c
c0d03230:	b0105044 	.word	0xb0105044
c0d03234:	00001ec8 	.word	0x00001ec8
c0d03238:	00000427 	.word	0x00000427
c0d0323c:	000020d0 	.word	0x000020d0
c0d03240:	000004af 	.word	0x000004af

c0d03244 <ui_display_tx_desc_1>:
        UX_DISPLAY(bagl_ui_idle_nanos, NULL);
    }
}

/** show the transaction description screen. */
static void ui_display_tx_desc_1(void) {
c0d03244:	b570      	push	{r4, r5, r6, lr}
    uiState = UI_TX_DESC_1;
c0d03246:	4844      	ldr	r0, [pc, #272]	; (c0d03358 <ui_display_tx_desc_1+0x114>)
c0d03248:	2603      	movs	r6, #3
c0d0324a:	7006      	strb	r6, [r0, #0]
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d0324c:	2001      	movs	r0, #1
c0d0324e:	0204      	lsls	r4, r0, #8
c0d03250:	f7ff f804 	bl	c0d0225c <os_seph_features>
c0d03254:	4220      	tst	r0, r4
c0d03256:	d13f      	bne.n	c0d032d8 <ui_display_tx_desc_1+0x94>
        UX_DISPLAY(bagl_ui_tx_desc_blue, NULL);
    } else {
        UX_DISPLAY(bagl_ui_tx_desc_nanos_1, NULL);
c0d03258:	4c40      	ldr	r4, [pc, #256]	; (c0d0335c <ui_display_tx_desc_1+0x118>)
c0d0325a:	4844      	ldr	r0, [pc, #272]	; (c0d0336c <ui_display_tx_desc_1+0x128>)
c0d0325c:	4478      	add	r0, pc
c0d0325e:	6020      	str	r0, [r4, #0]
c0d03260:	2006      	movs	r0, #6
c0d03262:	6060      	str	r0, [r4, #4]
c0d03264:	4842      	ldr	r0, [pc, #264]	; (c0d03370 <ui_display_tx_desc_1+0x12c>)
c0d03266:	4478      	add	r0, pc
c0d03268:	6120      	str	r0, [r4, #16]
c0d0326a:	2500      	movs	r5, #0
c0d0326c:	60e5      	str	r5, [r4, #12]
c0d0326e:	7626      	strb	r6, [r4, #24]
c0d03270:	61e5      	str	r5, [r4, #28]
c0d03272:	4620      	mov	r0, r4
c0d03274:	3018      	adds	r0, #24
c0d03276:	f7fe ffdb 	bl	c0d02230 <os_ux>
c0d0327a:	61e0      	str	r0, [r4, #28]
c0d0327c:	f7fe fc88 	bl	c0d01b90 <ux_check_status_default>
c0d03280:	f7fe f9c8 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d03284:	60a5      	str	r5, [r4, #8]
c0d03286:	6820      	ldr	r0, [r4, #0]
c0d03288:	2800      	cmp	r0, #0
c0d0328a:	d064      	beq.n	c0d03356 <ui_display_tx_desc_1+0x112>
c0d0328c:	69e0      	ldr	r0, [r4, #28]
c0d0328e:	4934      	ldr	r1, [pc, #208]	; (c0d03360 <ui_display_tx_desc_1+0x11c>)
c0d03290:	4288      	cmp	r0, r1
c0d03292:	d11e      	bne.n	c0d032d2 <ui_display_tx_desc_1+0x8e>
c0d03294:	e05f      	b.n	c0d03356 <ui_display_tx_desc_1+0x112>
c0d03296:	6860      	ldr	r0, [r4, #4]
c0d03298:	4285      	cmp	r5, r0
c0d0329a:	d25c      	bcs.n	c0d03356 <ui_display_tx_desc_1+0x112>
c0d0329c:	f7ff f80a 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d032a0:	2800      	cmp	r0, #0
c0d032a2:	d158      	bne.n	c0d03356 <ui_display_tx_desc_1+0x112>
c0d032a4:	68a0      	ldr	r0, [r4, #8]
c0d032a6:	68e1      	ldr	r1, [r4, #12]
c0d032a8:	2538      	movs	r5, #56	; 0x38
c0d032aa:	4368      	muls	r0, r5
c0d032ac:	6822      	ldr	r2, [r4, #0]
c0d032ae:	1810      	adds	r0, r2, r0
c0d032b0:	2900      	cmp	r1, #0
c0d032b2:	d002      	beq.n	c0d032ba <ui_display_tx_desc_1+0x76>
c0d032b4:	4788      	blx	r1
c0d032b6:	2800      	cmp	r0, #0
c0d032b8:	d007      	beq.n	c0d032ca <ui_display_tx_desc_1+0x86>
c0d032ba:	2801      	cmp	r0, #1
c0d032bc:	d103      	bne.n	c0d032c6 <ui_display_tx_desc_1+0x82>
c0d032be:	68a0      	ldr	r0, [r4, #8]
c0d032c0:	4345      	muls	r5, r0
c0d032c2:	6820      	ldr	r0, [r4, #0]
c0d032c4:	1940      	adds	r0, r0, r5
c0d032c6:	f7fc ffa5 	bl	c0d00214 <io_seproxyhal_display>
c0d032ca:	68a0      	ldr	r0, [r4, #8]
c0d032cc:	1c45      	adds	r5, r0, #1
c0d032ce:	60a5      	str	r5, [r4, #8]
c0d032d0:	6820      	ldr	r0, [r4, #0]
c0d032d2:	2800      	cmp	r0, #0
c0d032d4:	d1df      	bne.n	c0d03296 <ui_display_tx_desc_1+0x52>
c0d032d6:	e03e      	b.n	c0d03356 <ui_display_tx_desc_1+0x112>

/** show the transaction description screen. */
static void ui_display_tx_desc_1(void) {
    uiState = UI_TX_DESC_1;
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
        UX_DISPLAY(bagl_ui_tx_desc_blue, NULL);
c0d032d8:	4c20      	ldr	r4, [pc, #128]	; (c0d0335c <ui_display_tx_desc_1+0x118>)
c0d032da:	4822      	ldr	r0, [pc, #136]	; (c0d03364 <ui_display_tx_desc_1+0x120>)
c0d032dc:	4478      	add	r0, pc
c0d032de:	6020      	str	r0, [r4, #0]
c0d032e0:	2008      	movs	r0, #8
c0d032e2:	6060      	str	r0, [r4, #4]
c0d032e4:	4820      	ldr	r0, [pc, #128]	; (c0d03368 <ui_display_tx_desc_1+0x124>)
c0d032e6:	4478      	add	r0, pc
c0d032e8:	6120      	str	r0, [r4, #16]
c0d032ea:	2500      	movs	r5, #0
c0d032ec:	60e5      	str	r5, [r4, #12]
c0d032ee:	7626      	strb	r6, [r4, #24]
c0d032f0:	61e5      	str	r5, [r4, #28]
c0d032f2:	4620      	mov	r0, r4
c0d032f4:	3018      	adds	r0, #24
c0d032f6:	f7fe ff9b 	bl	c0d02230 <os_ux>
c0d032fa:	61e0      	str	r0, [r4, #28]
c0d032fc:	f7fe fc48 	bl	c0d01b90 <ux_check_status_default>
c0d03300:	f7fe f988 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d03304:	60a5      	str	r5, [r4, #8]
c0d03306:	6820      	ldr	r0, [r4, #0]
c0d03308:	2800      	cmp	r0, #0
c0d0330a:	d024      	beq.n	c0d03356 <ui_display_tx_desc_1+0x112>
c0d0330c:	69e0      	ldr	r0, [r4, #28]
c0d0330e:	4914      	ldr	r1, [pc, #80]	; (c0d03360 <ui_display_tx_desc_1+0x11c>)
c0d03310:	4288      	cmp	r0, r1
c0d03312:	d11e      	bne.n	c0d03352 <ui_display_tx_desc_1+0x10e>
c0d03314:	e01f      	b.n	c0d03356 <ui_display_tx_desc_1+0x112>
c0d03316:	6860      	ldr	r0, [r4, #4]
c0d03318:	4285      	cmp	r5, r0
c0d0331a:	d21c      	bcs.n	c0d03356 <ui_display_tx_desc_1+0x112>
c0d0331c:	f7fe ffca 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d03320:	2800      	cmp	r0, #0
c0d03322:	d118      	bne.n	c0d03356 <ui_display_tx_desc_1+0x112>
c0d03324:	68a0      	ldr	r0, [r4, #8]
c0d03326:	68e1      	ldr	r1, [r4, #12]
c0d03328:	2538      	movs	r5, #56	; 0x38
c0d0332a:	4368      	muls	r0, r5
c0d0332c:	6822      	ldr	r2, [r4, #0]
c0d0332e:	1810      	adds	r0, r2, r0
c0d03330:	2900      	cmp	r1, #0
c0d03332:	d002      	beq.n	c0d0333a <ui_display_tx_desc_1+0xf6>
c0d03334:	4788      	blx	r1
c0d03336:	2800      	cmp	r0, #0
c0d03338:	d007      	beq.n	c0d0334a <ui_display_tx_desc_1+0x106>
c0d0333a:	2801      	cmp	r0, #1
c0d0333c:	d103      	bne.n	c0d03346 <ui_display_tx_desc_1+0x102>
c0d0333e:	68a0      	ldr	r0, [r4, #8]
c0d03340:	4345      	muls	r5, r0
c0d03342:	6820      	ldr	r0, [r4, #0]
c0d03344:	1940      	adds	r0, r0, r5
c0d03346:	f7fc ff65 	bl	c0d00214 <io_seproxyhal_display>
c0d0334a:	68a0      	ldr	r0, [r4, #8]
c0d0334c:	1c45      	adds	r5, r0, #1
c0d0334e:	60a5      	str	r5, [r4, #8]
c0d03350:	6820      	ldr	r0, [r4, #0]
c0d03352:	2800      	cmp	r0, #0
c0d03354:	d1df      	bne.n	c0d03316 <ui_display_tx_desc_1+0xd2>
    } else {
        UX_DISPLAY(bagl_ui_tx_desc_nanos_1, NULL);
    }
}
c0d03356:	bd70      	pop	{r4, r5, r6, pc}
c0d03358:	20001f68 	.word	0x20001f68
c0d0335c:	20001f6c 	.word	0x20001f6c
c0d03360:	b0105044 	.word	0xb0105044
c0d03364:	0000206c 	.word	0x0000206c
c0d03368:	0000039f 	.word	0x0000039f
c0d0336c:	000022ac 	.word	0x000022ac
c0d03370:	00000423 	.word	0x00000423

c0d03374 <ui_display_tx_desc_2>:


/** show the transaction description screen. */
static void ui_display_tx_desc_2(void) {
c0d03374:	b5b0      	push	{r4, r5, r7, lr}
    uiState = UI_TX_DESC_2;
c0d03376:	4845      	ldr	r0, [pc, #276]	; (c0d0348c <ui_display_tx_desc_2+0x118>)
c0d03378:	2104      	movs	r1, #4
c0d0337a:	7001      	strb	r1, [r0, #0]
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d0337c:	2001      	movs	r0, #1
c0d0337e:	0204      	lsls	r4, r0, #8
c0d03380:	f7fe ff6c 	bl	c0d0225c <os_seph_features>
c0d03384:	4220      	tst	r0, r4
c0d03386:	d140      	bne.n	c0d0340a <ui_display_tx_desc_2+0x96>
        UX_DISPLAY(bagl_ui_tx_desc_blue, NULL);
    } else {
        UX_DISPLAY(bagl_ui_tx_desc_nanos_2, NULL);
c0d03388:	4c41      	ldr	r4, [pc, #260]	; (c0d03490 <ui_display_tx_desc_2+0x11c>)
c0d0338a:	4845      	ldr	r0, [pc, #276]	; (c0d034a0 <ui_display_tx_desc_2+0x12c>)
c0d0338c:	4478      	add	r0, pc
c0d0338e:	6020      	str	r0, [r4, #0]
c0d03390:	2006      	movs	r0, #6
c0d03392:	6060      	str	r0, [r4, #4]
c0d03394:	4843      	ldr	r0, [pc, #268]	; (c0d034a4 <ui_display_tx_desc_2+0x130>)
c0d03396:	4478      	add	r0, pc
c0d03398:	6120      	str	r0, [r4, #16]
c0d0339a:	2500      	movs	r5, #0
c0d0339c:	60e5      	str	r5, [r4, #12]
c0d0339e:	2003      	movs	r0, #3
c0d033a0:	7620      	strb	r0, [r4, #24]
c0d033a2:	61e5      	str	r5, [r4, #28]
c0d033a4:	4620      	mov	r0, r4
c0d033a6:	3018      	adds	r0, #24
c0d033a8:	f7fe ff42 	bl	c0d02230 <os_ux>
c0d033ac:	61e0      	str	r0, [r4, #28]
c0d033ae:	f7fe fbef 	bl	c0d01b90 <ux_check_status_default>
c0d033b2:	f7fe f92f 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d033b6:	60a5      	str	r5, [r4, #8]
c0d033b8:	6820      	ldr	r0, [r4, #0]
c0d033ba:	2800      	cmp	r0, #0
c0d033bc:	d065      	beq.n	c0d0348a <ui_display_tx_desc_2+0x116>
c0d033be:	69e0      	ldr	r0, [r4, #28]
c0d033c0:	4934      	ldr	r1, [pc, #208]	; (c0d03494 <ui_display_tx_desc_2+0x120>)
c0d033c2:	4288      	cmp	r0, r1
c0d033c4:	d11e      	bne.n	c0d03404 <ui_display_tx_desc_2+0x90>
c0d033c6:	e060      	b.n	c0d0348a <ui_display_tx_desc_2+0x116>
c0d033c8:	6860      	ldr	r0, [r4, #4]
c0d033ca:	4285      	cmp	r5, r0
c0d033cc:	d25d      	bcs.n	c0d0348a <ui_display_tx_desc_2+0x116>
c0d033ce:	f7fe ff71 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d033d2:	2800      	cmp	r0, #0
c0d033d4:	d159      	bne.n	c0d0348a <ui_display_tx_desc_2+0x116>
c0d033d6:	68a0      	ldr	r0, [r4, #8]
c0d033d8:	68e1      	ldr	r1, [r4, #12]
c0d033da:	2538      	movs	r5, #56	; 0x38
c0d033dc:	4368      	muls	r0, r5
c0d033de:	6822      	ldr	r2, [r4, #0]
c0d033e0:	1810      	adds	r0, r2, r0
c0d033e2:	2900      	cmp	r1, #0
c0d033e4:	d002      	beq.n	c0d033ec <ui_display_tx_desc_2+0x78>
c0d033e6:	4788      	blx	r1
c0d033e8:	2800      	cmp	r0, #0
c0d033ea:	d007      	beq.n	c0d033fc <ui_display_tx_desc_2+0x88>
c0d033ec:	2801      	cmp	r0, #1
c0d033ee:	d103      	bne.n	c0d033f8 <ui_display_tx_desc_2+0x84>
c0d033f0:	68a0      	ldr	r0, [r4, #8]
c0d033f2:	4345      	muls	r5, r0
c0d033f4:	6820      	ldr	r0, [r4, #0]
c0d033f6:	1940      	adds	r0, r0, r5
c0d033f8:	f7fc ff0c 	bl	c0d00214 <io_seproxyhal_display>
c0d033fc:	68a0      	ldr	r0, [r4, #8]
c0d033fe:	1c45      	adds	r5, r0, #1
c0d03400:	60a5      	str	r5, [r4, #8]
c0d03402:	6820      	ldr	r0, [r4, #0]
c0d03404:	2800      	cmp	r0, #0
c0d03406:	d1df      	bne.n	c0d033c8 <ui_display_tx_desc_2+0x54>
c0d03408:	e03f      	b.n	c0d0348a <ui_display_tx_desc_2+0x116>

/** show the transaction description screen. */
static void ui_display_tx_desc_2(void) {
    uiState = UI_TX_DESC_2;
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
        UX_DISPLAY(bagl_ui_tx_desc_blue, NULL);
c0d0340a:	4c21      	ldr	r4, [pc, #132]	; (c0d03490 <ui_display_tx_desc_2+0x11c>)
c0d0340c:	4822      	ldr	r0, [pc, #136]	; (c0d03498 <ui_display_tx_desc_2+0x124>)
c0d0340e:	4478      	add	r0, pc
c0d03410:	6020      	str	r0, [r4, #0]
c0d03412:	2008      	movs	r0, #8
c0d03414:	6060      	str	r0, [r4, #4]
c0d03416:	4821      	ldr	r0, [pc, #132]	; (c0d0349c <ui_display_tx_desc_2+0x128>)
c0d03418:	4478      	add	r0, pc
c0d0341a:	6120      	str	r0, [r4, #16]
c0d0341c:	2500      	movs	r5, #0
c0d0341e:	60e5      	str	r5, [r4, #12]
c0d03420:	2003      	movs	r0, #3
c0d03422:	7620      	strb	r0, [r4, #24]
c0d03424:	61e5      	str	r5, [r4, #28]
c0d03426:	4620      	mov	r0, r4
c0d03428:	3018      	adds	r0, #24
c0d0342a:	f7fe ff01 	bl	c0d02230 <os_ux>
c0d0342e:	61e0      	str	r0, [r4, #28]
c0d03430:	f7fe fbae 	bl	c0d01b90 <ux_check_status_default>
c0d03434:	f7fe f8ee 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d03438:	60a5      	str	r5, [r4, #8]
c0d0343a:	6820      	ldr	r0, [r4, #0]
c0d0343c:	2800      	cmp	r0, #0
c0d0343e:	d024      	beq.n	c0d0348a <ui_display_tx_desc_2+0x116>
c0d03440:	69e0      	ldr	r0, [r4, #28]
c0d03442:	4914      	ldr	r1, [pc, #80]	; (c0d03494 <ui_display_tx_desc_2+0x120>)
c0d03444:	4288      	cmp	r0, r1
c0d03446:	d11e      	bne.n	c0d03486 <ui_display_tx_desc_2+0x112>
c0d03448:	e01f      	b.n	c0d0348a <ui_display_tx_desc_2+0x116>
c0d0344a:	6860      	ldr	r0, [r4, #4]
c0d0344c:	4285      	cmp	r5, r0
c0d0344e:	d21c      	bcs.n	c0d0348a <ui_display_tx_desc_2+0x116>
c0d03450:	f7fe ff30 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d03454:	2800      	cmp	r0, #0
c0d03456:	d118      	bne.n	c0d0348a <ui_display_tx_desc_2+0x116>
c0d03458:	68a0      	ldr	r0, [r4, #8]
c0d0345a:	68e1      	ldr	r1, [r4, #12]
c0d0345c:	2538      	movs	r5, #56	; 0x38
c0d0345e:	4368      	muls	r0, r5
c0d03460:	6822      	ldr	r2, [r4, #0]
c0d03462:	1810      	adds	r0, r2, r0
c0d03464:	2900      	cmp	r1, #0
c0d03466:	d002      	beq.n	c0d0346e <ui_display_tx_desc_2+0xfa>
c0d03468:	4788      	blx	r1
c0d0346a:	2800      	cmp	r0, #0
c0d0346c:	d007      	beq.n	c0d0347e <ui_display_tx_desc_2+0x10a>
c0d0346e:	2801      	cmp	r0, #1
c0d03470:	d103      	bne.n	c0d0347a <ui_display_tx_desc_2+0x106>
c0d03472:	68a0      	ldr	r0, [r4, #8]
c0d03474:	4345      	muls	r5, r0
c0d03476:	6820      	ldr	r0, [r4, #0]
c0d03478:	1940      	adds	r0, r0, r5
c0d0347a:	f7fc fecb 	bl	c0d00214 <io_seproxyhal_display>
c0d0347e:	68a0      	ldr	r0, [r4, #8]
c0d03480:	1c45      	adds	r5, r0, #1
c0d03482:	60a5      	str	r5, [r4, #8]
c0d03484:	6820      	ldr	r0, [r4, #0]
c0d03486:	2800      	cmp	r0, #0
c0d03488:	d1df      	bne.n	c0d0344a <ui_display_tx_desc_2+0xd6>
    } else {
        UX_DISPLAY(bagl_ui_tx_desc_nanos_2, NULL);
    }
}
c0d0348a:	bdb0      	pop	{r4, r5, r7, pc}
c0d0348c:	20001f68 	.word	0x20001f68
c0d03490:	20001f6c 	.word	0x20001f6c
c0d03494:	b0105044 	.word	0xb0105044
c0d03498:	00001f3a 	.word	0x00001f3a
c0d0349c:	0000026d 	.word	0x0000026d
c0d034a0:	000022cc 	.word	0x000022cc
c0d034a4:	0000031b 	.word	0x0000031b

c0d034a8 <ui_sign>:

/** show the bottom "Sign Transaction" screen. */
static void ui_sign(void) {
c0d034a8:	b5b0      	push	{r4, r5, r7, lr}
    uiState = UI_SIGN;
c0d034aa:	4845      	ldr	r0, [pc, #276]	; (c0d035c0 <ui_sign+0x118>)
c0d034ac:	2105      	movs	r1, #5
c0d034ae:	7001      	strb	r1, [r0, #0]
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d034b0:	2001      	movs	r0, #1
c0d034b2:	0204      	lsls	r4, r0, #8
c0d034b4:	f7fe fed2 	bl	c0d0225c <os_seph_features>
c0d034b8:	4220      	tst	r0, r4
c0d034ba:	d140      	bne.n	c0d0353e <ui_sign+0x96>
        UX_DISPLAY(bagl_ui_top_sign_blue, NULL);
    } else {
        UX_DISPLAY(bagl_ui_top_sign_nanos, NULL);
c0d034bc:	4c41      	ldr	r4, [pc, #260]	; (c0d035c4 <ui_sign+0x11c>)
c0d034be:	4845      	ldr	r0, [pc, #276]	; (c0d035d4 <ui_sign+0x12c>)
c0d034c0:	4478      	add	r0, pc
c0d034c2:	6020      	str	r0, [r4, #0]
c0d034c4:	2006      	movs	r0, #6
c0d034c6:	6060      	str	r0, [r4, #4]
c0d034c8:	4843      	ldr	r0, [pc, #268]	; (c0d035d8 <ui_sign+0x130>)
c0d034ca:	4478      	add	r0, pc
c0d034cc:	6120      	str	r0, [r4, #16]
c0d034ce:	2500      	movs	r5, #0
c0d034d0:	60e5      	str	r5, [r4, #12]
c0d034d2:	2003      	movs	r0, #3
c0d034d4:	7620      	strb	r0, [r4, #24]
c0d034d6:	61e5      	str	r5, [r4, #28]
c0d034d8:	4620      	mov	r0, r4
c0d034da:	3018      	adds	r0, #24
c0d034dc:	f7fe fea8 	bl	c0d02230 <os_ux>
c0d034e0:	61e0      	str	r0, [r4, #28]
c0d034e2:	f7fe fb55 	bl	c0d01b90 <ux_check_status_default>
c0d034e6:	f7fe f895 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d034ea:	60a5      	str	r5, [r4, #8]
c0d034ec:	6820      	ldr	r0, [r4, #0]
c0d034ee:	2800      	cmp	r0, #0
c0d034f0:	d065      	beq.n	c0d035be <ui_sign+0x116>
c0d034f2:	69e0      	ldr	r0, [r4, #28]
c0d034f4:	4934      	ldr	r1, [pc, #208]	; (c0d035c8 <ui_sign+0x120>)
c0d034f6:	4288      	cmp	r0, r1
c0d034f8:	d11e      	bne.n	c0d03538 <ui_sign+0x90>
c0d034fa:	e060      	b.n	c0d035be <ui_sign+0x116>
c0d034fc:	6860      	ldr	r0, [r4, #4]
c0d034fe:	4285      	cmp	r5, r0
c0d03500:	d25d      	bcs.n	c0d035be <ui_sign+0x116>
c0d03502:	f7fe fed7 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d03506:	2800      	cmp	r0, #0
c0d03508:	d159      	bne.n	c0d035be <ui_sign+0x116>
c0d0350a:	68a0      	ldr	r0, [r4, #8]
c0d0350c:	68e1      	ldr	r1, [r4, #12]
c0d0350e:	2538      	movs	r5, #56	; 0x38
c0d03510:	4368      	muls	r0, r5
c0d03512:	6822      	ldr	r2, [r4, #0]
c0d03514:	1810      	adds	r0, r2, r0
c0d03516:	2900      	cmp	r1, #0
c0d03518:	d002      	beq.n	c0d03520 <ui_sign+0x78>
c0d0351a:	4788      	blx	r1
c0d0351c:	2800      	cmp	r0, #0
c0d0351e:	d007      	beq.n	c0d03530 <ui_sign+0x88>
c0d03520:	2801      	cmp	r0, #1
c0d03522:	d103      	bne.n	c0d0352c <ui_sign+0x84>
c0d03524:	68a0      	ldr	r0, [r4, #8]
c0d03526:	4345      	muls	r5, r0
c0d03528:	6820      	ldr	r0, [r4, #0]
c0d0352a:	1940      	adds	r0, r0, r5
c0d0352c:	f7fc fe72 	bl	c0d00214 <io_seproxyhal_display>
c0d03530:	68a0      	ldr	r0, [r4, #8]
c0d03532:	1c45      	adds	r5, r0, #1
c0d03534:	60a5      	str	r5, [r4, #8]
c0d03536:	6820      	ldr	r0, [r4, #0]
c0d03538:	2800      	cmp	r0, #0
c0d0353a:	d1df      	bne.n	c0d034fc <ui_sign+0x54>
c0d0353c:	e03f      	b.n	c0d035be <ui_sign+0x116>

/** show the bottom "Sign Transaction" screen. */
static void ui_sign(void) {
    uiState = UI_SIGN;
    if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
        UX_DISPLAY(bagl_ui_top_sign_blue, NULL);
c0d0353e:	4c21      	ldr	r4, [pc, #132]	; (c0d035c4 <ui_sign+0x11c>)
c0d03540:	4822      	ldr	r0, [pc, #136]	; (c0d035cc <ui_sign+0x124>)
c0d03542:	4478      	add	r0, pc
c0d03544:	6020      	str	r0, [r4, #0]
c0d03546:	2007      	movs	r0, #7
c0d03548:	6060      	str	r0, [r4, #4]
c0d0354a:	4821      	ldr	r0, [pc, #132]	; (c0d035d0 <ui_sign+0x128>)
c0d0354c:	4478      	add	r0, pc
c0d0354e:	6120      	str	r0, [r4, #16]
c0d03550:	2500      	movs	r5, #0
c0d03552:	60e5      	str	r5, [r4, #12]
c0d03554:	2003      	movs	r0, #3
c0d03556:	7620      	strb	r0, [r4, #24]
c0d03558:	61e5      	str	r5, [r4, #28]
c0d0355a:	4620      	mov	r0, r4
c0d0355c:	3018      	adds	r0, #24
c0d0355e:	f7fe fe67 	bl	c0d02230 <os_ux>
c0d03562:	61e0      	str	r0, [r4, #28]
c0d03564:	f7fe fb14 	bl	c0d01b90 <ux_check_status_default>
c0d03568:	f7fe f854 	bl	c0d01614 <io_seproxyhal_init_ux>
c0d0356c:	60a5      	str	r5, [r4, #8]
c0d0356e:	6820      	ldr	r0, [r4, #0]
c0d03570:	2800      	cmp	r0, #0
c0d03572:	d024      	beq.n	c0d035be <ui_sign+0x116>
c0d03574:	69e0      	ldr	r0, [r4, #28]
c0d03576:	4914      	ldr	r1, [pc, #80]	; (c0d035c8 <ui_sign+0x120>)
c0d03578:	4288      	cmp	r0, r1
c0d0357a:	d11e      	bne.n	c0d035ba <ui_sign+0x112>
c0d0357c:	e01f      	b.n	c0d035be <ui_sign+0x116>
c0d0357e:	6860      	ldr	r0, [r4, #4]
c0d03580:	4285      	cmp	r5, r0
c0d03582:	d21c      	bcs.n	c0d035be <ui_sign+0x116>
c0d03584:	f7fe fe96 	bl	c0d022b4 <io_seproxyhal_spi_is_status_sent>
c0d03588:	2800      	cmp	r0, #0
c0d0358a:	d118      	bne.n	c0d035be <ui_sign+0x116>
c0d0358c:	68a0      	ldr	r0, [r4, #8]
c0d0358e:	68e1      	ldr	r1, [r4, #12]
c0d03590:	2538      	movs	r5, #56	; 0x38
c0d03592:	4368      	muls	r0, r5
c0d03594:	6822      	ldr	r2, [r4, #0]
c0d03596:	1810      	adds	r0, r2, r0
c0d03598:	2900      	cmp	r1, #0
c0d0359a:	d002      	beq.n	c0d035a2 <ui_sign+0xfa>
c0d0359c:	4788      	blx	r1
c0d0359e:	2800      	cmp	r0, #0
c0d035a0:	d007      	beq.n	c0d035b2 <ui_sign+0x10a>
c0d035a2:	2801      	cmp	r0, #1
c0d035a4:	d103      	bne.n	c0d035ae <ui_sign+0x106>
c0d035a6:	68a0      	ldr	r0, [r4, #8]
c0d035a8:	4345      	muls	r5, r0
c0d035aa:	6820      	ldr	r0, [r4, #0]
c0d035ac:	1940      	adds	r0, r0, r5
c0d035ae:	f7fc fe31 	bl	c0d00214 <io_seproxyhal_display>
c0d035b2:	68a0      	ldr	r0, [r4, #8]
c0d035b4:	1c45      	adds	r5, r0, #1
c0d035b6:	60a5      	str	r5, [r4, #8]
c0d035b8:	6820      	ldr	r0, [r4, #0]
c0d035ba:	2800      	cmp	r0, #0
c0d035bc:	d1df      	bne.n	c0d0357e <ui_sign+0xd6>
    } else {
        UX_DISPLAY(bagl_ui_top_sign_nanos, NULL);
    }
}
c0d035be:	bdb0      	pop	{r4, r5, r7, pc}
c0d035c0:	20001f68 	.word	0x20001f68
c0d035c4:	20001f6c 	.word	0x20001f6c
c0d035c8:	b0105044 	.word	0xb0105044
c0d035cc:	000019a6 	.word	0x000019a6
c0d035d0:	fffff845 	.word	0xfffff845
c0d035d4:	000022e8 	.word	0x000022e8
c0d035d8:	fffff8cb 	.word	0xfffff8cb

c0d035dc <bagl_ui_deny_blue_button>:
static unsigned int bagl_ui_top_sign_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
}

static unsigned int bagl_ui_deny_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
c0d035dc:	2000      	movs	r0, #0
c0d035de:	4770      	bx	lr

c0d035e0 <bagl_ui_deny_nanos_button>:
/**
 * buttons for the bottom "Deny Transaction" screen
 *
 * up on Left button, down on right button, deny on both buttons.
 */
static unsigned int bagl_ui_deny_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d035e0:	b580      	push	{r7, lr}
    switch (button_mask) {
c0d035e2:	4913      	ldr	r1, [pc, #76]	; (c0d03630 <bagl_ui_deny_nanos_button+0x50>)
c0d035e4:	4288      	cmp	r0, r1
c0d035e6:	d019      	beq.n	c0d0361c <bagl_ui_deny_nanos_button+0x3c>
c0d035e8:	4912      	ldr	r1, [pc, #72]	; (c0d03634 <bagl_ui_deny_nanos_button+0x54>)
c0d035ea:	4288      	cmp	r0, r1
c0d035ec:	d01a      	beq.n	c0d03624 <bagl_ui_deny_nanos_button+0x44>
c0d035ee:	4912      	ldr	r1, [pc, #72]	; (c0d03638 <bagl_ui_deny_nanos_button+0x58>)
c0d035f0:	4288      	cmp	r0, r1
c0d035f2:	d11a      	bne.n	c0d0362a <bagl_ui_deny_nanos_button+0x4a>
    return 0; // do not redraw the widget
}

/** deny signing. */
static const bagl_element_t *io_seproxyhal_touch_deny(const bagl_element_t *e) {
    hashTainted = 1;
c0d035f4:	4811      	ldr	r0, [pc, #68]	; (c0d0363c <bagl_ui_deny_nanos_button+0x5c>)
c0d035f6:	2101      	movs	r1, #1
c0d035f8:	7001      	strb	r1, [r0, #0]
    raw_tx_ix = 0;
c0d035fa:	4811      	ldr	r0, [pc, #68]	; (c0d03640 <bagl_ui_deny_nanos_button+0x60>)
c0d035fc:	2100      	movs	r1, #0
c0d035fe:	6001      	str	r1, [r0, #0]
    raw_tx_len = 0;
c0d03600:	4810      	ldr	r0, [pc, #64]	; (c0d03644 <bagl_ui_deny_nanos_button+0x64>)
c0d03602:	6001      	str	r1, [r0, #0]
    G_io_apdu_buffer[0] = 0x69;
c0d03604:	4810      	ldr	r0, [pc, #64]	; (c0d03648 <bagl_ui_deny_nanos_button+0x68>)
c0d03606:	2169      	movs	r1, #105	; 0x69
c0d03608:	7001      	strb	r1, [r0, #0]
    G_io_apdu_buffer[1] = 0x85;
c0d0360a:	2185      	movs	r1, #133	; 0x85
c0d0360c:	7041      	strb	r1, [r0, #1]
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
c0d0360e:	2020      	movs	r0, #32
c0d03610:	2102      	movs	r1, #2
c0d03612:	f7fe f9c1 	bl	c0d01998 <io_exchange>
    // Display back the original UX
    ui_idle();
c0d03616:	f7ff fa73 	bl	c0d02b00 <ui_idle>
c0d0361a:	e006      	b.n	c0d0362a <bagl_ui_deny_nanos_button+0x4a>
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
c0d0361c:	2000      	movs	r0, #0
c0d0361e:	f7ff fd1f 	bl	c0d03060 <tx_desc_up>
c0d03622:	e002      	b.n	c0d0362a <bagl_ui_deny_nanos_button+0x4a>
        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT:
            io_seproxyhal_touch_deny(NULL);
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
c0d03624:	2000      	movs	r0, #0
c0d03626:	f7ff fd47 	bl	c0d030b8 <tx_desc_dn>

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
            break;
    }
    return 0;
c0d0362a:	2000      	movs	r0, #0
c0d0362c:	bd80      	pop	{r7, pc}
c0d0362e:	46c0      	nop			; (mov r8, r8)
c0d03630:	80000001 	.word	0x80000001
c0d03634:	80000002 	.word	0x80000002
c0d03638:	80000003 	.word	0x80000003
c0d0363c:	20001f60 	.word	0x20001f60
c0d03640:	20001f64 	.word	0x20001f64
c0d03644:	20001af0 	.word	0x20001af0
c0d03648:	200018f8 	.word	0x200018f8

c0d0364c <io_seproxyhal_touch_deny>:
    //io_seproxyhal_touch_exit(NULL);
    return 0; // do not redraw the widget
}

/** deny signing. */
static const bagl_element_t *io_seproxyhal_touch_deny(const bagl_element_t *e) {
c0d0364c:	b510      	push	{r4, lr}
    hashTainted = 1;
c0d0364e:	480a      	ldr	r0, [pc, #40]	; (c0d03678 <io_seproxyhal_touch_deny+0x2c>)
c0d03650:	2101      	movs	r1, #1
c0d03652:	7001      	strb	r1, [r0, #0]
    raw_tx_ix = 0;
c0d03654:	4809      	ldr	r0, [pc, #36]	; (c0d0367c <io_seproxyhal_touch_deny+0x30>)
c0d03656:	2400      	movs	r4, #0
c0d03658:	6004      	str	r4, [r0, #0]
    raw_tx_len = 0;
c0d0365a:	4809      	ldr	r0, [pc, #36]	; (c0d03680 <io_seproxyhal_touch_deny+0x34>)
c0d0365c:	6004      	str	r4, [r0, #0]
    G_io_apdu_buffer[0] = 0x69;
c0d0365e:	4809      	ldr	r0, [pc, #36]	; (c0d03684 <io_seproxyhal_touch_deny+0x38>)
c0d03660:	2169      	movs	r1, #105	; 0x69
c0d03662:	7001      	strb	r1, [r0, #0]
    G_io_apdu_buffer[1] = 0x85;
c0d03664:	2185      	movs	r1, #133	; 0x85
c0d03666:	7041      	strb	r1, [r0, #1]
    // Send back the response, do not restart the event loop
    io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
c0d03668:	2020      	movs	r0, #32
c0d0366a:	2102      	movs	r1, #2
c0d0366c:	f7fe f994 	bl	c0d01998 <io_exchange>
    // Display back the original UX
    ui_idle();
c0d03670:	f7ff fa46 	bl	c0d02b00 <ui_idle>
    return 0; // do not redraw the widget
c0d03674:	4620      	mov	r0, r4
c0d03676:	bd10      	pop	{r4, pc}
c0d03678:	20001f60 	.word	0x20001f60
c0d0367c:	20001f64 	.word	0x20001f64
c0d03680:	20001af0 	.word	0x20001af0
c0d03684:	200018f8 	.word	0x200018f8

c0d03688 <bagl_ui_tx_desc_blue_button>:
static unsigned int bagl_ui_idle_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
}

static unsigned int bagl_ui_tx_desc_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
    return 0;
c0d03688:	2000      	movs	r0, #0
c0d0368a:	4770      	bx	lr

c0d0368c <bagl_ui_tx_desc_nanos_1_button>:
/**
 * buttons for the transaction description screen
 *
 * up on Left button, down on right button.
 */
static unsigned int bagl_ui_tx_desc_nanos_1_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d0368c:	b580      	push	{r7, lr}
    switch (button_mask) {
c0d0368e:	4907      	ldr	r1, [pc, #28]	; (c0d036ac <bagl_ui_tx_desc_nanos_1_button+0x20>)
c0d03690:	4288      	cmp	r0, r1
c0d03692:	d006      	beq.n	c0d036a2 <bagl_ui_tx_desc_nanos_1_button+0x16>
c0d03694:	4906      	ldr	r1, [pc, #24]	; (c0d036b0 <bagl_ui_tx_desc_nanos_1_button+0x24>)
c0d03696:	4288      	cmp	r0, r1
c0d03698:	d106      	bne.n	c0d036a8 <bagl_ui_tx_desc_nanos_1_button+0x1c>
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
c0d0369a:	2000      	movs	r0, #0
c0d0369c:	f7ff fd0c 	bl	c0d030b8 <tx_desc_dn>
c0d036a0:	e002      	b.n	c0d036a8 <bagl_ui_tx_desc_nanos_1_button+0x1c>
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
c0d036a2:	2000      	movs	r0, #0
c0d036a4:	f7ff fcdc 	bl	c0d03060 <tx_desc_up>
            break;
    }
    return 0;
c0d036a8:	2000      	movs	r0, #0
c0d036aa:	bd80      	pop	{r7, pc}
c0d036ac:	80000001 	.word	0x80000001
c0d036b0:	80000002 	.word	0x80000002

c0d036b4 <bagl_ui_tx_desc_nanos_2_button>:
/**
 * buttons for the transaction description screen
 *
 * up on Left button, down on right button.
 */
static unsigned int bagl_ui_tx_desc_nanos_2_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d036b4:	b580      	push	{r7, lr}
    switch (button_mask) {
c0d036b6:	4907      	ldr	r1, [pc, #28]	; (c0d036d4 <bagl_ui_tx_desc_nanos_2_button+0x20>)
c0d036b8:	4288      	cmp	r0, r1
c0d036ba:	d006      	beq.n	c0d036ca <bagl_ui_tx_desc_nanos_2_button+0x16>
c0d036bc:	4906      	ldr	r1, [pc, #24]	; (c0d036d8 <bagl_ui_tx_desc_nanos_2_button+0x24>)
c0d036be:	4288      	cmp	r0, r1
c0d036c0:	d106      	bne.n	c0d036d0 <bagl_ui_tx_desc_nanos_2_button+0x1c>
        case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
            tx_desc_dn(NULL);
c0d036c2:	2000      	movs	r0, #0
c0d036c4:	f7ff fcf8 	bl	c0d030b8 <tx_desc_dn>
c0d036c8:	e002      	b.n	c0d036d0 <bagl_ui_tx_desc_nanos_2_button+0x1c>
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT:
            tx_desc_up(NULL);
c0d036ca:	2000      	movs	r0, #0
c0d036cc:	f7ff fcc8 	bl	c0d03060 <tx_desc_up>
            break;
    }
    return 0;
c0d036d0:	2000      	movs	r0, #0
c0d036d2:	bd80      	pop	{r7, pc}
c0d036d4:	80000001 	.word	0x80000001
c0d036d8:	80000002 	.word	0x80000002

c0d036dc <USBD_LL_Init>:
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Init (USBD_HandleTypeDef *pdev)
{ 
  UNUSED(pdev);
  ep_in_stall = 0;
c0d036dc:	4902      	ldr	r1, [pc, #8]	; (c0d036e8 <USBD_LL_Init+0xc>)
c0d036de:	2000      	movs	r0, #0
c0d036e0:	6008      	str	r0, [r1, #0]
  ep_out_stall = 0;
c0d036e2:	4902      	ldr	r1, [pc, #8]	; (c0d036ec <USBD_LL_Init+0x10>)
c0d036e4:	6008      	str	r0, [r1, #0]
  return USBD_OK;
c0d036e6:	4770      	bx	lr
c0d036e8:	200020b0 	.word	0x200020b0
c0d036ec:	200020b4 	.word	0x200020b4

c0d036f0 <USBD_LL_DeInit>:
  * @brief  De-Initializes the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_DeInit (USBD_HandleTypeDef *pdev)
{
c0d036f0:	b510      	push	{r4, lr}
  UNUSED(pdev);
  // usb off
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d036f2:	4807      	ldr	r0, [pc, #28]	; (c0d03710 <USBD_LL_DeInit+0x20>)
c0d036f4:	214f      	movs	r1, #79	; 0x4f
c0d036f6:	7001      	strb	r1, [r0, #0]
c0d036f8:	2400      	movs	r4, #0
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d036fa:	7044      	strb	r4, [r0, #1]
c0d036fc:	2101      	movs	r1, #1
  G_io_seproxyhal_spi_buffer[2] = 1;
c0d036fe:	7081      	strb	r1, [r0, #2]
c0d03700:	2102      	movs	r1, #2
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d03702:	70c1      	strb	r1, [r0, #3]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 4);
c0d03704:	2104      	movs	r1, #4
c0d03706:	f7fe fdbf 	bl	c0d02288 <io_seproxyhal_spi_send>

  return USBD_OK; 
c0d0370a:	4620      	mov	r0, r4
c0d0370c:	bd10      	pop	{r4, pc}
c0d0370e:	46c0      	nop			; (mov r8, r8)
c0d03710:	20001800 	.word	0x20001800

c0d03714 <USBD_LL_Start>:
  * @brief  Starts the Low Level portion of the Device driver. 
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Start(USBD_HandleTypeDef *pdev)
{
c0d03714:	b570      	push	{r4, r5, r6, lr}
c0d03716:	b082      	sub	sp, #8
c0d03718:	466d      	mov	r5, sp
  uint8_t buffer[5];
  UNUSED(pdev);

  // reset address
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d0371a:	264f      	movs	r6, #79	; 0x4f
c0d0371c:	702e      	strb	r6, [r5, #0]
c0d0371e:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03720:	706c      	strb	r4, [r5, #1]
c0d03722:	2002      	movs	r0, #2
  buffer[2] = 2;
c0d03724:	70a8      	strb	r0, [r5, #2]
c0d03726:	2003      	movs	r0, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d03728:	70e8      	strb	r0, [r5, #3]
  buffer[4] = 0;
c0d0372a:	712c      	strb	r4, [r5, #4]
  io_seproxyhal_spi_send(buffer, 5);
c0d0372c:	2105      	movs	r1, #5
c0d0372e:	4628      	mov	r0, r5
c0d03730:	f7fe fdaa 	bl	c0d02288 <io_seproxyhal_spi_send>
  
  // start usb operation
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03734:	702e      	strb	r6, [r5, #0]
  buffer[1] = 0;
c0d03736:	706c      	strb	r4, [r5, #1]
c0d03738:	2001      	movs	r0, #1
  buffer[2] = 1;
c0d0373a:	70a8      	strb	r0, [r5, #2]
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_CONNECT;
c0d0373c:	70e8      	strb	r0, [r5, #3]
c0d0373e:	2104      	movs	r1, #4
  io_seproxyhal_spi_send(buffer, 4);
c0d03740:	4628      	mov	r0, r5
c0d03742:	f7fe fda1 	bl	c0d02288 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d03746:	4620      	mov	r0, r4
c0d03748:	b002      	add	sp, #8
c0d0374a:	bd70      	pop	{r4, r5, r6, pc}

c0d0374c <USBD_LL_Stop>:
  * @brief  Stops the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Stop (USBD_HandleTypeDef *pdev)
{
c0d0374c:	b510      	push	{r4, lr}
c0d0374e:	b082      	sub	sp, #8
c0d03750:	a801      	add	r0, sp, #4
  UNUSED(pdev);
  uint8_t buffer[4];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03752:	214f      	movs	r1, #79	; 0x4f
c0d03754:	7001      	strb	r1, [r0, #0]
c0d03756:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03758:	7044      	strb	r4, [r0, #1]
c0d0375a:	2101      	movs	r1, #1
  buffer[2] = 1;
c0d0375c:	7081      	strb	r1, [r0, #2]
c0d0375e:	2102      	movs	r1, #2
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d03760:	70c1      	strb	r1, [r0, #3]
  io_seproxyhal_spi_send(buffer, 4);
c0d03762:	2104      	movs	r1, #4
c0d03764:	f7fe fd90 	bl	c0d02288 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d03768:	4620      	mov	r0, r4
c0d0376a:	b002      	add	sp, #8
c0d0376c:	bd10      	pop	{r4, pc}
	...

c0d03770 <USBD_LL_OpenEP>:
  */
USBD_StatusTypeDef  USBD_LL_OpenEP  (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  ep_type,
                                      uint16_t ep_mps)
{
c0d03770:	b5b0      	push	{r4, r5, r7, lr}
c0d03772:	b082      	sub	sp, #8
  uint8_t buffer[8];
  UNUSED(pdev);

  ep_in_stall = 0;
c0d03774:	480e      	ldr	r0, [pc, #56]	; (c0d037b0 <USBD_LL_OpenEP+0x40>)
c0d03776:	2400      	movs	r4, #0
c0d03778:	6004      	str	r4, [r0, #0]
  ep_out_stall = 0;
c0d0377a:	480e      	ldr	r0, [pc, #56]	; (c0d037b4 <USBD_LL_OpenEP+0x44>)
c0d0377c:	6004      	str	r4, [r0, #0]
c0d0377e:	4668      	mov	r0, sp

  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03780:	254f      	movs	r5, #79	; 0x4f
c0d03782:	7005      	strb	r5, [r0, #0]
  buffer[1] = 0;
c0d03784:	7044      	strb	r4, [r0, #1]
c0d03786:	2505      	movs	r5, #5
  buffer[2] = 5;
c0d03788:	7085      	strb	r5, [r0, #2]
c0d0378a:	2504      	movs	r5, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d0378c:	70c5      	strb	r5, [r0, #3]
c0d0378e:	2501      	movs	r5, #1
  buffer[4] = 1;
c0d03790:	7105      	strb	r5, [r0, #4]
  buffer[5] = ep_addr;
c0d03792:	7141      	strb	r1, [r0, #5]
  buffer[6] = 0;
  switch(ep_type) {
c0d03794:	2a03      	cmp	r2, #3
c0d03796:	d802      	bhi.n	c0d0379e <USBD_LL_OpenEP+0x2e>
c0d03798:	00d0      	lsls	r0, r2, #3
c0d0379a:	4c07      	ldr	r4, [pc, #28]	; (c0d037b8 <USBD_LL_OpenEP+0x48>)
c0d0379c:	40c4      	lsrs	r4, r0
c0d0379e:	4668      	mov	r0, sp
  buffer[1] = 0;
  buffer[2] = 5;
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
  buffer[4] = 1;
  buffer[5] = ep_addr;
  buffer[6] = 0;
c0d037a0:	7184      	strb	r4, [r0, #6]
      break;
    case USBD_EP_TYPE_INTR:
      buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_INTERRUPT;
      break;
  }
  buffer[7] = ep_mps;
c0d037a2:	71c3      	strb	r3, [r0, #7]
  io_seproxyhal_spi_send(buffer, 8);
c0d037a4:	2108      	movs	r1, #8
c0d037a6:	f7fe fd6f 	bl	c0d02288 <io_seproxyhal_spi_send>
c0d037aa:	2000      	movs	r0, #0
  return USBD_OK; 
c0d037ac:	b002      	add	sp, #8
c0d037ae:	bdb0      	pop	{r4, r5, r7, pc}
c0d037b0:	200020b0 	.word	0x200020b0
c0d037b4:	200020b4 	.word	0x200020b4
c0d037b8:	02030401 	.word	0x02030401

c0d037bc <USBD_LL_CloseEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_CloseEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d037bc:	b510      	push	{r4, lr}
c0d037be:	b082      	sub	sp, #8
c0d037c0:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[8];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d037c2:	224f      	movs	r2, #79	; 0x4f
c0d037c4:	7002      	strb	r2, [r0, #0]
c0d037c6:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d037c8:	7044      	strb	r4, [r0, #1]
c0d037ca:	2205      	movs	r2, #5
  buffer[2] = 5;
c0d037cc:	7082      	strb	r2, [r0, #2]
c0d037ce:	2204      	movs	r2, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d037d0:	70c2      	strb	r2, [r0, #3]
c0d037d2:	2201      	movs	r2, #1
  buffer[4] = 1;
c0d037d4:	7102      	strb	r2, [r0, #4]
  buffer[5] = ep_addr;
c0d037d6:	7141      	strb	r1, [r0, #5]
  buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_DISABLED;
c0d037d8:	7184      	strb	r4, [r0, #6]
  buffer[7] = 0;
c0d037da:	71c4      	strb	r4, [r0, #7]
  io_seproxyhal_spi_send(buffer, 8);
c0d037dc:	2108      	movs	r1, #8
c0d037de:	f7fe fd53 	bl	c0d02288 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d037e2:	4620      	mov	r0, r4
c0d037e4:	b002      	add	sp, #8
c0d037e6:	bd10      	pop	{r4, pc}

c0d037e8 <USBD_LL_StallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_StallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{ 
c0d037e8:	b5b0      	push	{r4, r5, r7, lr}
c0d037ea:	b082      	sub	sp, #8
c0d037ec:	460d      	mov	r5, r1
c0d037ee:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d037f0:	2150      	movs	r1, #80	; 0x50
c0d037f2:	7001      	strb	r1, [r0, #0]
c0d037f4:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d037f6:	7044      	strb	r4, [r0, #1]
c0d037f8:	2103      	movs	r1, #3
  buffer[2] = 3;
c0d037fa:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d037fc:	70c5      	strb	r5, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_STALL;
c0d037fe:	2140      	movs	r1, #64	; 0x40
c0d03800:	7101      	strb	r1, [r0, #4]
  buffer[5] = 0;
c0d03802:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03804:	2106      	movs	r1, #6
c0d03806:	f7fe fd3f 	bl	c0d02288 <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d0380a:	2080      	movs	r0, #128	; 0x80
c0d0380c:	4205      	tst	r5, r0
c0d0380e:	d101      	bne.n	c0d03814 <USBD_LL_StallEP+0x2c>
c0d03810:	4807      	ldr	r0, [pc, #28]	; (c0d03830 <USBD_LL_StallEP+0x48>)
c0d03812:	e000      	b.n	c0d03816 <USBD_LL_StallEP+0x2e>
c0d03814:	4805      	ldr	r0, [pc, #20]	; (c0d0382c <USBD_LL_StallEP+0x44>)
c0d03816:	6801      	ldr	r1, [r0, #0]
c0d03818:	227f      	movs	r2, #127	; 0x7f
c0d0381a:	4015      	ands	r5, r2
c0d0381c:	2201      	movs	r2, #1
c0d0381e:	40aa      	lsls	r2, r5
c0d03820:	430a      	orrs	r2, r1
c0d03822:	6002      	str	r2, [r0, #0]
    ep_in_stall |= (1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall |= (1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d03824:	4620      	mov	r0, r4
c0d03826:	b002      	add	sp, #8
c0d03828:	bdb0      	pop	{r4, r5, r7, pc}
c0d0382a:	46c0      	nop			; (mov r8, r8)
c0d0382c:	200020b0 	.word	0x200020b0
c0d03830:	200020b4 	.word	0x200020b4

c0d03834 <USBD_LL_ClearStallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_ClearStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d03834:	b570      	push	{r4, r5, r6, lr}
c0d03836:	b082      	sub	sp, #8
c0d03838:	460d      	mov	r5, r1
c0d0383a:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d0383c:	2150      	movs	r1, #80	; 0x50
c0d0383e:	7001      	strb	r1, [r0, #0]
c0d03840:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03842:	7044      	strb	r4, [r0, #1]
c0d03844:	2103      	movs	r1, #3
  buffer[2] = 3;
c0d03846:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d03848:	70c5      	strb	r5, [r0, #3]
c0d0384a:	2680      	movs	r6, #128	; 0x80
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_UNSTALL;
c0d0384c:	7106      	strb	r6, [r0, #4]
  buffer[5] = 0;
c0d0384e:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03850:	2106      	movs	r1, #6
c0d03852:	f7fe fd19 	bl	c0d02288 <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d03856:	4235      	tst	r5, r6
c0d03858:	d101      	bne.n	c0d0385e <USBD_LL_ClearStallEP+0x2a>
c0d0385a:	4807      	ldr	r0, [pc, #28]	; (c0d03878 <USBD_LL_ClearStallEP+0x44>)
c0d0385c:	e000      	b.n	c0d03860 <USBD_LL_ClearStallEP+0x2c>
c0d0385e:	4805      	ldr	r0, [pc, #20]	; (c0d03874 <USBD_LL_ClearStallEP+0x40>)
c0d03860:	6801      	ldr	r1, [r0, #0]
c0d03862:	227f      	movs	r2, #127	; 0x7f
c0d03864:	4015      	ands	r5, r2
c0d03866:	2201      	movs	r2, #1
c0d03868:	40aa      	lsls	r2, r5
c0d0386a:	4391      	bics	r1, r2
c0d0386c:	6001      	str	r1, [r0, #0]
    ep_in_stall &= ~(1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall &= ~(1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d0386e:	4620      	mov	r0, r4
c0d03870:	b002      	add	sp, #8
c0d03872:	bd70      	pop	{r4, r5, r6, pc}
c0d03874:	200020b0 	.word	0x200020b0
c0d03878:	200020b4 	.word	0x200020b4

c0d0387c <USBD_LL_IsStallEP>:
  * @retval Stall (1: Yes, 0: No)
  */
uint8_t USBD_LL_IsStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  UNUSED(pdev);
  if((ep_addr & 0x80) == 0x80)
c0d0387c:	2080      	movs	r0, #128	; 0x80
c0d0387e:	4201      	tst	r1, r0
c0d03880:	d001      	beq.n	c0d03886 <USBD_LL_IsStallEP+0xa>
c0d03882:	4806      	ldr	r0, [pc, #24]	; (c0d0389c <USBD_LL_IsStallEP+0x20>)
c0d03884:	e000      	b.n	c0d03888 <USBD_LL_IsStallEP+0xc>
c0d03886:	4804      	ldr	r0, [pc, #16]	; (c0d03898 <USBD_LL_IsStallEP+0x1c>)
c0d03888:	6800      	ldr	r0, [r0, #0]
c0d0388a:	227f      	movs	r2, #127	; 0x7f
c0d0388c:	4011      	ands	r1, r2
c0d0388e:	2201      	movs	r2, #1
c0d03890:	408a      	lsls	r2, r1
c0d03892:	4002      	ands	r2, r0
  }
  else
  {
    return ep_out_stall & (1<<(ep_addr&0x7F));
  }
}
c0d03894:	b2d0      	uxtb	r0, r2
c0d03896:	4770      	bx	lr
c0d03898:	200020b4 	.word	0x200020b4
c0d0389c:	200020b0 	.word	0x200020b0

c0d038a0 <USBD_LL_SetUSBAddress>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_SetUSBAddress (USBD_HandleTypeDef *pdev, uint8_t dev_addr)   
{
c0d038a0:	b510      	push	{r4, lr}
c0d038a2:	b082      	sub	sp, #8
c0d038a4:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[5];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d038a6:	224f      	movs	r2, #79	; 0x4f
c0d038a8:	7002      	strb	r2, [r0, #0]
c0d038aa:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d038ac:	7044      	strb	r4, [r0, #1]
c0d038ae:	2202      	movs	r2, #2
  buffer[2] = 2;
c0d038b0:	7082      	strb	r2, [r0, #2]
c0d038b2:	2203      	movs	r2, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d038b4:	70c2      	strb	r2, [r0, #3]
  buffer[4] = dev_addr;
c0d038b6:	7101      	strb	r1, [r0, #4]
  io_seproxyhal_spi_send(buffer, 5);
c0d038b8:	2105      	movs	r1, #5
c0d038ba:	f7fe fce5 	bl	c0d02288 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d038be:	4620      	mov	r0, r4
c0d038c0:	b002      	add	sp, #8
c0d038c2:	bd10      	pop	{r4, pc}

c0d038c4 <USBD_LL_Transmit>:
  */
USBD_StatusTypeDef  USBD_LL_Transmit (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  *pbuf,
                                      uint16_t  size)
{
c0d038c4:	b5b0      	push	{r4, r5, r7, lr}
c0d038c6:	b082      	sub	sp, #8
c0d038c8:	461c      	mov	r4, r3
c0d038ca:	4615      	mov	r5, r2
c0d038cc:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d038ce:	2250      	movs	r2, #80	; 0x50
c0d038d0:	7002      	strb	r2, [r0, #0]
  buffer[1] = (3+size)>>8;
c0d038d2:	1ce2      	adds	r2, r4, #3
c0d038d4:	0a13      	lsrs	r3, r2, #8
c0d038d6:	7043      	strb	r3, [r0, #1]
  buffer[2] = (3+size);
c0d038d8:	7082      	strb	r2, [r0, #2]
  buffer[3] = ep_addr;
c0d038da:	70c1      	strb	r1, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d038dc:	2120      	movs	r1, #32
c0d038de:	7101      	strb	r1, [r0, #4]
  buffer[5] = size;
c0d038e0:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d038e2:	2106      	movs	r1, #6
c0d038e4:	f7fe fcd0 	bl	c0d02288 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(pbuf, size);
c0d038e8:	4628      	mov	r0, r5
c0d038ea:	4621      	mov	r1, r4
c0d038ec:	f7fe fccc 	bl	c0d02288 <io_seproxyhal_spi_send>
c0d038f0:	2000      	movs	r0, #0
  return USBD_OK;   
c0d038f2:	b002      	add	sp, #8
c0d038f4:	bdb0      	pop	{r4, r5, r7, pc}

c0d038f6 <USBD_LL_PrepareReceive>:
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_PrepareReceive(USBD_HandleTypeDef *pdev, 
                                           uint8_t  ep_addr,
                                           uint16_t  size)
{
c0d038f6:	b510      	push	{r4, lr}
c0d038f8:	b082      	sub	sp, #8
c0d038fa:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d038fc:	2350      	movs	r3, #80	; 0x50
c0d038fe:	7003      	strb	r3, [r0, #0]
c0d03900:	2400      	movs	r4, #0
  buffer[1] = (3/*+size*/)>>8;
c0d03902:	7044      	strb	r4, [r0, #1]
c0d03904:	2303      	movs	r3, #3
  buffer[2] = (3/*+size*/);
c0d03906:	7083      	strb	r3, [r0, #2]
  buffer[3] = ep_addr;
c0d03908:	70c1      	strb	r1, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_OUT;
c0d0390a:	2130      	movs	r1, #48	; 0x30
c0d0390c:	7101      	strb	r1, [r0, #4]
  buffer[5] = size; // expected size, not transmitted here !
c0d0390e:	7142      	strb	r2, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03910:	2106      	movs	r1, #6
c0d03912:	f7fe fcb9 	bl	c0d02288 <io_seproxyhal_spi_send>
  return USBD_OK;   
c0d03916:	4620      	mov	r0, r4
c0d03918:	b002      	add	sp, #8
c0d0391a:	bd10      	pop	{r4, pc}

c0d0391c <USBD_Init>:
* @param  pdesc: Descriptor structure address
* @param  id: Low level core index
* @retval None
*/
USBD_StatusTypeDef USBD_Init(USBD_HandleTypeDef *pdev, USBD_DescriptorsTypeDef *pdesc, uint8_t id)
{
c0d0391c:	b570      	push	{r4, r5, r6, lr}
c0d0391e:	4615      	mov	r5, r2
c0d03920:	460e      	mov	r6, r1
c0d03922:	4604      	mov	r4, r0
c0d03924:	2002      	movs	r0, #2
  /* Check whether the USB Host handle is valid */
  if(pdev == NULL)
c0d03926:	2c00      	cmp	r4, #0
c0d03928:	d011      	beq.n	c0d0394e <USBD_Init+0x32>
  {
    USBD_ErrLog("Invalid Device handle");
    return USBD_FAIL; 
  }

  memset(pdev, 0, sizeof(USBD_HandleTypeDef));
c0d0392a:	204d      	movs	r0, #77	; 0x4d
c0d0392c:	0081      	lsls	r1, r0, #2
c0d0392e:	4620      	mov	r0, r4
c0d03930:	f000 ff88 	bl	c0d04844 <__aeabi_memclr>
  
  /* Assign USBD Descriptors */
  if(pdesc != NULL)
c0d03934:	2e00      	cmp	r6, #0
c0d03936:	d002      	beq.n	c0d0393e <USBD_Init+0x22>
  {
    pdev->pDesc = pdesc;
c0d03938:	2011      	movs	r0, #17
c0d0393a:	0100      	lsls	r0, r0, #4
c0d0393c:	5026      	str	r6, [r4, r0]
  }
  
  /* Set Device initial State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d0393e:	20fc      	movs	r0, #252	; 0xfc
c0d03940:	2101      	movs	r1, #1
c0d03942:	5421      	strb	r1, [r4, r0]
  pdev->id = id;
c0d03944:	7025      	strb	r5, [r4, #0]
  /* Initialize low level driver */
  USBD_LL_Init(pdev);
c0d03946:	4620      	mov	r0, r4
c0d03948:	f7ff fec8 	bl	c0d036dc <USBD_LL_Init>
c0d0394c:	2000      	movs	r0, #0
  
  return USBD_OK; 
}
c0d0394e:	b2c0      	uxtb	r0, r0
c0d03950:	bd70      	pop	{r4, r5, r6, pc}

c0d03952 <USBD_DeInit>:
*         Re-Initialize th device library
* @param  pdev: device instance
* @retval status: status
*/
USBD_StatusTypeDef USBD_DeInit(USBD_HandleTypeDef *pdev)
{
c0d03952:	b570      	push	{r4, r5, r6, lr}
c0d03954:	4604      	mov	r4, r0
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d03956:	20fc      	movs	r0, #252	; 0xfc
c0d03958:	2101      	movs	r1, #1
c0d0395a:	5421      	strb	r1, [r4, r0]
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0395c:	2045      	movs	r0, #69	; 0x45
c0d0395e:	0080      	lsls	r0, r0, #2
c0d03960:	1825      	adds	r5, r4, r0
c0d03962:	2600      	movs	r6, #0
    if(pdev->interfacesClass[intf].pClass != NULL) {
c0d03964:	00f0      	lsls	r0, r6, #3
c0d03966:	5828      	ldr	r0, [r5, r0]
c0d03968:	2800      	cmp	r0, #0
c0d0396a:	d006      	beq.n	c0d0397a <USBD_DeInit+0x28>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
c0d0396c:	6840      	ldr	r0, [r0, #4]
c0d0396e:	f7fe fb27 	bl	c0d01fc0 <pic>
c0d03972:	4602      	mov	r2, r0
c0d03974:	7921      	ldrb	r1, [r4, #4]
c0d03976:	4620      	mov	r0, r4
c0d03978:	4790      	blx	r2
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0397a:	1c76      	adds	r6, r6, #1
c0d0397c:	2e03      	cmp	r6, #3
c0d0397e:	d1f1      	bne.n	c0d03964 <USBD_DeInit+0x12>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
    }
  }
  
    /* Stop the low level driver  */
  USBD_LL_Stop(pdev); 
c0d03980:	4620      	mov	r0, r4
c0d03982:	f7ff fee3 	bl	c0d0374c <USBD_LL_Stop>
  
  /* Initialize low level driver */
  USBD_LL_DeInit(pdev);
c0d03986:	4620      	mov	r0, r4
c0d03988:	f7ff feb2 	bl	c0d036f0 <USBD_LL_DeInit>
  
  return USBD_OK;
c0d0398c:	2000      	movs	r0, #0
c0d0398e:	bd70      	pop	{r4, r5, r6, pc}

c0d03990 <USBD_RegisterClassForInterface>:
  * @param  pDevice : Device Handle
  * @param  pclass: Class handle
  * @retval USBD Status
  */
USBD_StatusTypeDef USBD_RegisterClassForInterface(uint8_t interfaceidx, USBD_HandleTypeDef *pdev, USBD_ClassTypeDef *pclass)
{
c0d03990:	2302      	movs	r3, #2
  USBD_StatusTypeDef   status = USBD_OK;
  if(pclass != 0)
c0d03992:	2a00      	cmp	r2, #0
c0d03994:	d007      	beq.n	c0d039a6 <USBD_RegisterClassForInterface+0x16>
c0d03996:	2300      	movs	r3, #0
  {
    if (interfaceidx < USBD_MAX_NUM_INTERFACES) {
c0d03998:	2802      	cmp	r0, #2
c0d0399a:	d804      	bhi.n	c0d039a6 <USBD_RegisterClassForInterface+0x16>
      /* link the class to the USB Device handle */
      pdev->interfacesClass[interfaceidx].pClass = pclass;
c0d0399c:	00c0      	lsls	r0, r0, #3
c0d0399e:	1808      	adds	r0, r1, r0
c0d039a0:	2145      	movs	r1, #69	; 0x45
c0d039a2:	0089      	lsls	r1, r1, #2
c0d039a4:	5042      	str	r2, [r0, r1]
  {
    USBD_ErrLog("Invalid Class handle");
    status = USBD_FAIL; 
  }
  
  return status;
c0d039a6:	b2d8      	uxtb	r0, r3
c0d039a8:	4770      	bx	lr

c0d039aa <USBD_Start>:
  *         Start the USB Device Core.
  * @param  pdev: Device Handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_Start  (USBD_HandleTypeDef *pdev)
{
c0d039aa:	b580      	push	{r7, lr}
  
  /* Start the low level driver  */
  USBD_LL_Start(pdev); 
c0d039ac:	f7ff feb2 	bl	c0d03714 <USBD_LL_Start>
  
  return USBD_OK;  
c0d039b0:	2000      	movs	r0, #0
c0d039b2:	bd80      	pop	{r7, pc}

c0d039b4 <USBD_SetClassConfig>:
* @param  cfgidx: configuration index
* @retval status
*/

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d039b4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d039b6:	b081      	sub	sp, #4
c0d039b8:	460c      	mov	r4, r1
c0d039ba:	4605      	mov	r5, r0
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d039bc:	2045      	movs	r0, #69	; 0x45
c0d039be:	0080      	lsls	r0, r0, #2
c0d039c0:	182f      	adds	r7, r5, r0
c0d039c2:	2600      	movs	r6, #0
    if(usbd_is_valid_intf(pdev, intf)) {
c0d039c4:	4628      	mov	r0, r5
c0d039c6:	4631      	mov	r1, r6
c0d039c8:	f000 f97c 	bl	c0d03cc4 <usbd_is_valid_intf>
c0d039cc:	2800      	cmp	r0, #0
c0d039ce:	d008      	beq.n	c0d039e2 <USBD_SetClassConfig+0x2e>
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
c0d039d0:	00f0      	lsls	r0, r6, #3
c0d039d2:	5838      	ldr	r0, [r7, r0]
c0d039d4:	6800      	ldr	r0, [r0, #0]
c0d039d6:	f7fe faf3 	bl	c0d01fc0 <pic>
c0d039da:	4602      	mov	r2, r0
c0d039dc:	4628      	mov	r0, r5
c0d039de:	4621      	mov	r1, r4
c0d039e0:	4790      	blx	r2

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d039e2:	1c76      	adds	r6, r6, #1
c0d039e4:	2e03      	cmp	r6, #3
c0d039e6:	d1ed      	bne.n	c0d039c4 <USBD_SetClassConfig+0x10>
    if(usbd_is_valid_intf(pdev, intf)) {
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
    }
  }

  return USBD_OK; 
c0d039e8:	2000      	movs	r0, #0
c0d039ea:	b001      	add	sp, #4
c0d039ec:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d039ee <USBD_ClrClassConfig>:
* @param  pdev: device instance
* @param  cfgidx: configuration index
* @retval status: USBD_StatusTypeDef
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d039ee:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d039f0:	b081      	sub	sp, #4
c0d039f2:	460c      	mov	r4, r1
c0d039f4:	4605      	mov	r5, r0
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d039f6:	2045      	movs	r0, #69	; 0x45
c0d039f8:	0080      	lsls	r0, r0, #2
c0d039fa:	182f      	adds	r7, r5, r0
c0d039fc:	2600      	movs	r6, #0
    if(usbd_is_valid_intf(pdev, intf)) {
c0d039fe:	4628      	mov	r0, r5
c0d03a00:	4631      	mov	r1, r6
c0d03a02:	f000 f95f 	bl	c0d03cc4 <usbd_is_valid_intf>
c0d03a06:	2800      	cmp	r0, #0
c0d03a08:	d008      	beq.n	c0d03a1c <USBD_ClrClassConfig+0x2e>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
c0d03a0a:	00f0      	lsls	r0, r6, #3
c0d03a0c:	5838      	ldr	r0, [r7, r0]
c0d03a0e:	6840      	ldr	r0, [r0, #4]
c0d03a10:	f7fe fad6 	bl	c0d01fc0 <pic>
c0d03a14:	4602      	mov	r2, r0
c0d03a16:	4628      	mov	r0, r5
c0d03a18:	4621      	mov	r1, r4
c0d03a1a:	4790      	blx	r2
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03a1c:	1c76      	adds	r6, r6, #1
c0d03a1e:	2e03      	cmp	r6, #3
c0d03a20:	d1ed      	bne.n	c0d039fe <USBD_ClrClassConfig+0x10>
    if(usbd_is_valid_intf(pdev, intf)) {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
    }
  }
  return USBD_OK;
c0d03a22:	2000      	movs	r0, #0
c0d03a24:	b001      	add	sp, #4
c0d03a26:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d03a28 <USBD_LL_SetupStage>:
*         Handle the setup stage
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetupStage(USBD_HandleTypeDef *pdev, uint8_t *psetup)
{
c0d03a28:	b570      	push	{r4, r5, r6, lr}
c0d03a2a:	4604      	mov	r4, r0
c0d03a2c:	2021      	movs	r0, #33	; 0x21
c0d03a2e:	00c6      	lsls	r6, r0, #3
  USBD_ParseSetupRequest(&pdev->request, psetup);
c0d03a30:	19a5      	adds	r5, r4, r6
c0d03a32:	4628      	mov	r0, r5
c0d03a34:	f000 fba7 	bl	c0d04186 <USBD_ParseSetupRequest>
  
  pdev->ep0_state = USBD_EP0_SETUP;
c0d03a38:	20f4      	movs	r0, #244	; 0xf4
c0d03a3a:	2101      	movs	r1, #1
c0d03a3c:	5021      	str	r1, [r4, r0]
  pdev->ep0_data_len = pdev->request.wLength;
c0d03a3e:	2087      	movs	r0, #135	; 0x87
c0d03a40:	0040      	lsls	r0, r0, #1
c0d03a42:	5a20      	ldrh	r0, [r4, r0]
c0d03a44:	21f8      	movs	r1, #248	; 0xf8
c0d03a46:	5060      	str	r0, [r4, r1]
  
  switch (pdev->request.bmRequest & 0x1F) 
c0d03a48:	5da1      	ldrb	r1, [r4, r6]
c0d03a4a:	201f      	movs	r0, #31
c0d03a4c:	4008      	ands	r0, r1
c0d03a4e:	2802      	cmp	r0, #2
c0d03a50:	d008      	beq.n	c0d03a64 <USBD_LL_SetupStage+0x3c>
c0d03a52:	2801      	cmp	r0, #1
c0d03a54:	d00b      	beq.n	c0d03a6e <USBD_LL_SetupStage+0x46>
c0d03a56:	2800      	cmp	r0, #0
c0d03a58:	d10e      	bne.n	c0d03a78 <USBD_LL_SetupStage+0x50>
  {
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
c0d03a5a:	4620      	mov	r0, r4
c0d03a5c:	4629      	mov	r1, r5
c0d03a5e:	f000 f93f 	bl	c0d03ce0 <USBD_StdDevReq>
c0d03a62:	e00e      	b.n	c0d03a82 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
c0d03a64:	4620      	mov	r0, r4
c0d03a66:	4629      	mov	r1, r5
c0d03a68:	f000 fb02 	bl	c0d04070 <USBD_StdEPReq>
c0d03a6c:	e009      	b.n	c0d03a82 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
c0d03a6e:	4620      	mov	r0, r4
c0d03a70:	4629      	mov	r1, r5
c0d03a72:	f000 fad8 	bl	c0d04026 <USBD_StdItfReq>
c0d03a76:	e004      	b.n	c0d03a82 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
    break;
    
  default:           
    USBD_LL_StallEP(pdev , pdev->request.bmRequest & 0x80);
c0d03a78:	2080      	movs	r0, #128	; 0x80
c0d03a7a:	4001      	ands	r1, r0
c0d03a7c:	4620      	mov	r0, r4
c0d03a7e:	f7ff feb3 	bl	c0d037e8 <USBD_LL_StallEP>
    break;
  }  
  return USBD_OK;  
c0d03a82:	2000      	movs	r0, #0
c0d03a84:	bd70      	pop	{r4, r5, r6, pc}

c0d03a86 <USBD_LL_DataOutStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataOutStage(USBD_HandleTypeDef *pdev , uint8_t epnum, uint8_t *pdata)
{
c0d03a86:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03a88:	b083      	sub	sp, #12
c0d03a8a:	9202      	str	r2, [sp, #8]
c0d03a8c:	4604      	mov	r4, r0
c0d03a8e:	9101      	str	r1, [sp, #4]
  USBD_EndpointTypeDef    *pep;
  
  if(epnum == 0) 
c0d03a90:	2900      	cmp	r1, #0
c0d03a92:	d01e      	beq.n	c0d03ad2 <USBD_LL_DataOutStage+0x4c>
    }
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03a94:	2045      	movs	r0, #69	; 0x45
c0d03a96:	0080      	lsls	r0, r0, #2
c0d03a98:	1825      	adds	r5, r4, r0
c0d03a9a:	4626      	mov	r6, r4
c0d03a9c:	36fc      	adds	r6, #252	; 0xfc
c0d03a9e:	2700      	movs	r7, #0
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d03aa0:	4620      	mov	r0, r4
c0d03aa2:	4639      	mov	r1, r7
c0d03aa4:	f000 f90e 	bl	c0d03cc4 <usbd_is_valid_intf>
c0d03aa8:	2800      	cmp	r0, #0
c0d03aaa:	d00e      	beq.n	c0d03aca <USBD_LL_DataOutStage+0x44>
c0d03aac:	00f8      	lsls	r0, r7, #3
c0d03aae:	5828      	ldr	r0, [r5, r0]
c0d03ab0:	6980      	ldr	r0, [r0, #24]
c0d03ab2:	2800      	cmp	r0, #0
c0d03ab4:	d009      	beq.n	c0d03aca <USBD_LL_DataOutStage+0x44>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d03ab6:	7831      	ldrb	r1, [r6, #0]
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d03ab8:	2903      	cmp	r1, #3
c0d03aba:	d106      	bne.n	c0d03aca <USBD_LL_DataOutStage+0x44>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
c0d03abc:	f7fe fa80 	bl	c0d01fc0 <pic>
c0d03ac0:	4603      	mov	r3, r0
c0d03ac2:	4620      	mov	r0, r4
c0d03ac4:	9901      	ldr	r1, [sp, #4]
c0d03ac6:	9a02      	ldr	r2, [sp, #8]
c0d03ac8:	4798      	blx	r3
    }
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03aca:	1c7f      	adds	r7, r7, #1
c0d03acc:	2f03      	cmp	r7, #3
c0d03ace:	d1e7      	bne.n	c0d03aa0 <USBD_LL_DataOutStage+0x1a>
c0d03ad0:	e035      	b.n	c0d03b3e <USBD_LL_DataOutStage+0xb8>
  
  if(epnum == 0) 
  {
    pep = &pdev->ep_out[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_OUT)
c0d03ad2:	20f4      	movs	r0, #244	; 0xf4
c0d03ad4:	5820      	ldr	r0, [r4, r0]
c0d03ad6:	2803      	cmp	r0, #3
c0d03ad8:	d131      	bne.n	c0d03b3e <USBD_LL_DataOutStage+0xb8>
    {
      if(pep->rem_length > pep->maxpacket)
c0d03ada:	2090      	movs	r0, #144	; 0x90
c0d03adc:	5820      	ldr	r0, [r4, r0]
c0d03ade:	218c      	movs	r1, #140	; 0x8c
c0d03ae0:	5861      	ldr	r1, [r4, r1]
c0d03ae2:	4622      	mov	r2, r4
c0d03ae4:	328c      	adds	r2, #140	; 0x8c
c0d03ae6:	4281      	cmp	r1, r0
c0d03ae8:	d90a      	bls.n	c0d03b00 <USBD_LL_DataOutStage+0x7a>
      {
        pep->rem_length -=  pep->maxpacket;
c0d03aea:	1a09      	subs	r1, r1, r0
c0d03aec:	6011      	str	r1, [r2, #0]
c0d03aee:	4281      	cmp	r1, r0
c0d03af0:	d300      	bcc.n	c0d03af4 <USBD_LL_DataOutStage+0x6e>
c0d03af2:	4601      	mov	r1, r0
       
        USBD_CtlContinueRx (pdev, 
c0d03af4:	b28a      	uxth	r2, r1
c0d03af6:	4620      	mov	r0, r4
c0d03af8:	9902      	ldr	r1, [sp, #8]
c0d03afa:	f000 fd0f 	bl	c0d0451c <USBD_CtlContinueRx>
c0d03afe:	e01e      	b.n	c0d03b3e <USBD_LL_DataOutStage+0xb8>
                            MIN(pep->rem_length ,pep->maxpacket));
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03b00:	2045      	movs	r0, #69	; 0x45
c0d03b02:	0080      	lsls	r0, r0, #2
c0d03b04:	1826      	adds	r6, r4, r0
c0d03b06:	4627      	mov	r7, r4
c0d03b08:	37fc      	adds	r7, #252	; 0xfc
c0d03b0a:	2500      	movs	r5, #0
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d03b0c:	4620      	mov	r0, r4
c0d03b0e:	4629      	mov	r1, r5
c0d03b10:	f000 f8d8 	bl	c0d03cc4 <usbd_is_valid_intf>
c0d03b14:	2800      	cmp	r0, #0
c0d03b16:	d00c      	beq.n	c0d03b32 <USBD_LL_DataOutStage+0xac>
c0d03b18:	00e8      	lsls	r0, r5, #3
c0d03b1a:	5830      	ldr	r0, [r6, r0]
c0d03b1c:	6900      	ldr	r0, [r0, #16]
c0d03b1e:	2800      	cmp	r0, #0
c0d03b20:	d007      	beq.n	c0d03b32 <USBD_LL_DataOutStage+0xac>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d03b22:	7839      	ldrb	r1, [r7, #0]
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d03b24:	2903      	cmp	r1, #3
c0d03b26:	d104      	bne.n	c0d03b32 <USBD_LL_DataOutStage+0xac>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
c0d03b28:	f7fe fa4a 	bl	c0d01fc0 <pic>
c0d03b2c:	4601      	mov	r1, r0
c0d03b2e:	4620      	mov	r0, r4
c0d03b30:	4788      	blx	r1
                            MIN(pep->rem_length ,pep->maxpacket));
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03b32:	1c6d      	adds	r5, r5, #1
c0d03b34:	2d03      	cmp	r5, #3
c0d03b36:	d1e9      	bne.n	c0d03b0c <USBD_LL_DataOutStage+0x86>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
          }
        }
        USBD_CtlSendStatus(pdev);
c0d03b38:	4620      	mov	r0, r4
c0d03b3a:	f000 fcf6 	bl	c0d0452a <USBD_CtlSendStatus>
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
      }
    }
  }  
  return USBD_OK;
c0d03b3e:	2000      	movs	r0, #0
c0d03b40:	b003      	add	sp, #12
c0d03b42:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d03b44 <USBD_LL_DataInStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataInStage(USBD_HandleTypeDef *pdev ,uint8_t epnum, uint8_t *pdata)
{
c0d03b44:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03b46:	b081      	sub	sp, #4
c0d03b48:	4604      	mov	r4, r0
c0d03b4a:	9100      	str	r1, [sp, #0]
  USBD_EndpointTypeDef    *pep;
  UNUSED(pdata);
    
  if(epnum == 0) 
c0d03b4c:	2900      	cmp	r1, #0
c0d03b4e:	d01d      	beq.n	c0d03b8c <USBD_LL_DataInStage+0x48>
      pdev->dev_test_mode = 0;
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03b50:	2045      	movs	r0, #69	; 0x45
c0d03b52:	0080      	lsls	r0, r0, #2
c0d03b54:	1827      	adds	r7, r4, r0
c0d03b56:	4625      	mov	r5, r4
c0d03b58:	35fc      	adds	r5, #252	; 0xfc
c0d03b5a:	2600      	movs	r6, #0
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d03b5c:	4620      	mov	r0, r4
c0d03b5e:	4631      	mov	r1, r6
c0d03b60:	f000 f8b0 	bl	c0d03cc4 <usbd_is_valid_intf>
c0d03b64:	2800      	cmp	r0, #0
c0d03b66:	d00d      	beq.n	c0d03b84 <USBD_LL_DataInStage+0x40>
c0d03b68:	00f0      	lsls	r0, r6, #3
c0d03b6a:	5838      	ldr	r0, [r7, r0]
c0d03b6c:	6940      	ldr	r0, [r0, #20]
c0d03b6e:	2800      	cmp	r0, #0
c0d03b70:	d008      	beq.n	c0d03b84 <USBD_LL_DataInStage+0x40>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d03b72:	7829      	ldrb	r1, [r5, #0]
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d03b74:	2903      	cmp	r1, #3
c0d03b76:	d105      	bne.n	c0d03b84 <USBD_LL_DataInStage+0x40>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
c0d03b78:	f7fe fa22 	bl	c0d01fc0 <pic>
c0d03b7c:	4602      	mov	r2, r0
c0d03b7e:	4620      	mov	r0, r4
c0d03b80:	9900      	ldr	r1, [sp, #0]
c0d03b82:	4790      	blx	r2
      pdev->dev_test_mode = 0;
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03b84:	1c76      	adds	r6, r6, #1
c0d03b86:	2e03      	cmp	r6, #3
c0d03b88:	d1e8      	bne.n	c0d03b5c <USBD_LL_DataInStage+0x18>
c0d03b8a:	e051      	b.n	c0d03c30 <USBD_LL_DataInStage+0xec>
    
  if(epnum == 0) 
  {
    pep = &pdev->ep_in[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_IN)
c0d03b8c:	20f4      	movs	r0, #244	; 0xf4
c0d03b8e:	5820      	ldr	r0, [r4, r0]
c0d03b90:	2802      	cmp	r0, #2
c0d03b92:	d145      	bne.n	c0d03c20 <USBD_LL_DataInStage+0xdc>
    {
      if(pep->rem_length > pep->maxpacket)
c0d03b94:	69e0      	ldr	r0, [r4, #28]
c0d03b96:	6a25      	ldr	r5, [r4, #32]
c0d03b98:	42a8      	cmp	r0, r5
c0d03b9a:	d90b      	bls.n	c0d03bb4 <USBD_LL_DataInStage+0x70>
      {
        pep->rem_length -=  pep->maxpacket;
c0d03b9c:	1b40      	subs	r0, r0, r5
c0d03b9e:	61e0      	str	r0, [r4, #28]
        pdev->pData += pep->maxpacket;
c0d03ba0:	2113      	movs	r1, #19
c0d03ba2:	010a      	lsls	r2, r1, #4
c0d03ba4:	58a1      	ldr	r1, [r4, r2]
c0d03ba6:	1949      	adds	r1, r1, r5
c0d03ba8:	50a1      	str	r1, [r4, r2]
        USBD_LL_PrepareReceive (pdev,
                                0,
                                0);  
        */
        
        USBD_CtlContinueSendData (pdev, 
c0d03baa:	b282      	uxth	r2, r0
c0d03bac:	4620      	mov	r0, r4
c0d03bae:	f000 fca7 	bl	c0d04500 <USBD_CtlContinueSendData>
c0d03bb2:	e035      	b.n	c0d03c20 <USBD_LL_DataInStage+0xdc>
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d03bb4:	69a6      	ldr	r6, [r4, #24]
c0d03bb6:	4630      	mov	r0, r6
c0d03bb8:	4629      	mov	r1, r5
c0d03bba:	f000 fd53 	bl	c0d04664 <__aeabi_uidivmod>
c0d03bbe:	42ae      	cmp	r6, r5
c0d03bc0:	d30f      	bcc.n	c0d03be2 <USBD_LL_DataInStage+0x9e>
c0d03bc2:	2900      	cmp	r1, #0
c0d03bc4:	d10d      	bne.n	c0d03be2 <USBD_LL_DataInStage+0x9e>
           (pep->total_length >= pep->maxpacket) &&
             (pep->total_length < pdev->ep0_data_len ))
c0d03bc6:	20f8      	movs	r0, #248	; 0xf8
c0d03bc8:	5820      	ldr	r0, [r4, r0]
c0d03bca:	4627      	mov	r7, r4
c0d03bcc:	37f8      	adds	r7, #248	; 0xf8
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d03bce:	4286      	cmp	r6, r0
c0d03bd0:	d207      	bcs.n	c0d03be2 <USBD_LL_DataInStage+0x9e>
c0d03bd2:	2500      	movs	r5, #0
          USBD_LL_PrepareReceive (pdev,
                                  0,
                                  0);
          */

          USBD_CtlContinueSendData(pdev , NULL, 0);
c0d03bd4:	4620      	mov	r0, r4
c0d03bd6:	4629      	mov	r1, r5
c0d03bd8:	462a      	mov	r2, r5
c0d03bda:	f000 fc91 	bl	c0d04500 <USBD_CtlContinueSendData>
          pdev->ep0_data_len = 0;
c0d03bde:	603d      	str	r5, [r7, #0]
c0d03be0:	e01e      	b.n	c0d03c20 <USBD_LL_DataInStage+0xdc>
          
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03be2:	2045      	movs	r0, #69	; 0x45
c0d03be4:	0080      	lsls	r0, r0, #2
c0d03be6:	1826      	adds	r6, r4, r0
c0d03be8:	4627      	mov	r7, r4
c0d03bea:	37fc      	adds	r7, #252	; 0xfc
c0d03bec:	2500      	movs	r5, #0
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d03bee:	4620      	mov	r0, r4
c0d03bf0:	4629      	mov	r1, r5
c0d03bf2:	f000 f867 	bl	c0d03cc4 <usbd_is_valid_intf>
c0d03bf6:	2800      	cmp	r0, #0
c0d03bf8:	d00c      	beq.n	c0d03c14 <USBD_LL_DataInStage+0xd0>
c0d03bfa:	00e8      	lsls	r0, r5, #3
c0d03bfc:	5830      	ldr	r0, [r6, r0]
c0d03bfe:	68c0      	ldr	r0, [r0, #12]
c0d03c00:	2800      	cmp	r0, #0
c0d03c02:	d007      	beq.n	c0d03c14 <USBD_LL_DataInStage+0xd0>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d03c04:	7839      	ldrb	r1, [r7, #0]
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d03c06:	2903      	cmp	r1, #3
c0d03c08:	d104      	bne.n	c0d03c14 <USBD_LL_DataInStage+0xd0>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
c0d03c0a:	f7fe f9d9 	bl	c0d01fc0 <pic>
c0d03c0e:	4601      	mov	r1, r0
c0d03c10:	4620      	mov	r0, r4
c0d03c12:	4788      	blx	r1
          
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03c14:	1c6d      	adds	r5, r5, #1
c0d03c16:	2d03      	cmp	r5, #3
c0d03c18:	d1e9      	bne.n	c0d03bee <USBD_LL_DataInStage+0xaa>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
            }
          }
          USBD_CtlReceiveStatus(pdev);
c0d03c1a:	4620      	mov	r0, r4
c0d03c1c:	f000 fc91 	bl	c0d04542 <USBD_CtlReceiveStatus>
        }
      }
    }
    if (pdev->dev_test_mode == 1)
c0d03c20:	2001      	movs	r0, #1
c0d03c22:	0201      	lsls	r1, r0, #8
c0d03c24:	1860      	adds	r0, r4, r1
c0d03c26:	5c61      	ldrb	r1, [r4, r1]
c0d03c28:	2901      	cmp	r1, #1
c0d03c2a:	d101      	bne.n	c0d03c30 <USBD_LL_DataInStage+0xec>
    {
      USBD_RunTestMode(pdev); 
      pdev->dev_test_mode = 0;
c0d03c2c:	2100      	movs	r1, #0
c0d03c2e:	7001      	strb	r1, [r0, #0]
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
      }
    }
  }
  return USBD_OK;
c0d03c30:	2000      	movs	r0, #0
c0d03c32:	b001      	add	sp, #4
c0d03c34:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d03c36 <USBD_LL_Reset>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_Reset(USBD_HandleTypeDef  *pdev)
{
c0d03c36:	b570      	push	{r4, r5, r6, lr}
c0d03c38:	4604      	mov	r4, r0
  pdev->ep_out[0].maxpacket = USB_MAX_EP0_SIZE;
c0d03c3a:	2090      	movs	r0, #144	; 0x90
c0d03c3c:	2140      	movs	r1, #64	; 0x40
c0d03c3e:	5021      	str	r1, [r4, r0]
  

  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
c0d03c40:	6221      	str	r1, [r4, #32]
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
c0d03c42:	20fc      	movs	r0, #252	; 0xfc
c0d03c44:	2101      	movs	r1, #1
c0d03c46:	5421      	strb	r1, [r4, r0]
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03c48:	2045      	movs	r0, #69	; 0x45
c0d03c4a:	0080      	lsls	r0, r0, #2
c0d03c4c:	1826      	adds	r6, r4, r0
c0d03c4e:	2500      	movs	r5, #0
    if( usbd_is_valid_intf(pdev, intf))
c0d03c50:	4620      	mov	r0, r4
c0d03c52:	4629      	mov	r1, r5
c0d03c54:	f000 f836 	bl	c0d03cc4 <usbd_is_valid_intf>
c0d03c58:	2800      	cmp	r0, #0
c0d03c5a:	d008      	beq.n	c0d03c6e <USBD_LL_Reset+0x38>
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
c0d03c5c:	00e8      	lsls	r0, r5, #3
c0d03c5e:	5830      	ldr	r0, [r6, r0]
c0d03c60:	6840      	ldr	r0, [r0, #4]
c0d03c62:	f7fe f9ad 	bl	c0d01fc0 <pic>
c0d03c66:	4602      	mov	r2, r0
c0d03c68:	7921      	ldrb	r1, [r4, #4]
c0d03c6a:	4620      	mov	r0, r4
c0d03c6c:	4790      	blx	r2
  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03c6e:	1c6d      	adds	r5, r5, #1
c0d03c70:	2d03      	cmp	r5, #3
c0d03c72:	d1ed      	bne.n	c0d03c50 <USBD_LL_Reset+0x1a>
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
    }
  }
  
  return USBD_OK;
c0d03c74:	2000      	movs	r0, #0
c0d03c76:	bd70      	pop	{r4, r5, r6, pc}

c0d03c78 <USBD_LL_SetSpeed>:
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetSpeed(USBD_HandleTypeDef  *pdev, USBD_SpeedTypeDef speed)
{
  pdev->dev_speed = speed;
c0d03c78:	7401      	strb	r1, [r0, #16]
c0d03c7a:	2000      	movs	r0, #0
  return USBD_OK;
c0d03c7c:	4770      	bx	lr

c0d03c7e <USBD_LL_Suspend>:
{
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_old_state =  pdev->dev_state;
  //pdev->dev_state  = USBD_STATE_SUSPENDED;
  return USBD_OK;
c0d03c7e:	2000      	movs	r0, #0
c0d03c80:	4770      	bx	lr

c0d03c82 <USBD_LL_Resume>:
USBD_StatusTypeDef USBD_LL_Resume(USBD_HandleTypeDef  *pdev)
{
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_state = pdev->dev_old_state;  
  return USBD_OK;
c0d03c82:	2000      	movs	r0, #0
c0d03c84:	4770      	bx	lr

c0d03c86 <USBD_LL_SOF>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
c0d03c86:	b570      	push	{r4, r5, r6, lr}
c0d03c88:	4604      	mov	r4, r0
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
c0d03c8a:	20fc      	movs	r0, #252	; 0xfc
c0d03c8c:	5c20      	ldrb	r0, [r4, r0]
c0d03c8e:	2803      	cmp	r0, #3
c0d03c90:	d116      	bne.n	c0d03cc0 <USBD_LL_SOF+0x3a>
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && pdev->interfacesClass[intf].pClass->SOF != NULL)
c0d03c92:	2045      	movs	r0, #69	; 0x45
c0d03c94:	0080      	lsls	r0, r0, #2
c0d03c96:	1826      	adds	r6, r4, r0
c0d03c98:	2500      	movs	r5, #0
c0d03c9a:	4620      	mov	r0, r4
c0d03c9c:	4629      	mov	r1, r5
c0d03c9e:	f000 f811 	bl	c0d03cc4 <usbd_is_valid_intf>
c0d03ca2:	2800      	cmp	r0, #0
c0d03ca4:	d009      	beq.n	c0d03cba <USBD_LL_SOF+0x34>
c0d03ca6:	00e8      	lsls	r0, r5, #3
c0d03ca8:	5830      	ldr	r0, [r6, r0]
c0d03caa:	69c0      	ldr	r0, [r0, #28]
c0d03cac:	2800      	cmp	r0, #0
c0d03cae:	d004      	beq.n	c0d03cba <USBD_LL_SOF+0x34>
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
c0d03cb0:	f7fe f986 	bl	c0d01fc0 <pic>
c0d03cb4:	4601      	mov	r1, r0
c0d03cb6:	4620      	mov	r0, r4
c0d03cb8:	4788      	blx	r1
USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03cba:	1c6d      	adds	r5, r5, #1
c0d03cbc:	2d03      	cmp	r5, #3
c0d03cbe:	d1ec      	bne.n	c0d03c9a <USBD_LL_SOF+0x14>
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
      }
    }
  }
  return USBD_OK;
c0d03cc0:	2000      	movs	r0, #0
c0d03cc2:	bd70      	pop	{r4, r5, r6, pc}

c0d03cc4 <usbd_is_valid_intf>:

/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
c0d03cc4:	4602      	mov	r2, r0
c0d03cc6:	2000      	movs	r0, #0
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03cc8:	2902      	cmp	r1, #2
c0d03cca:	d808      	bhi.n	c0d03cde <usbd_is_valid_intf+0x1a>
c0d03ccc:	00c8      	lsls	r0, r1, #3
c0d03cce:	1810      	adds	r0, r2, r0
c0d03cd0:	2145      	movs	r1, #69	; 0x45
c0d03cd2:	0089      	lsls	r1, r1, #2
c0d03cd4:	5841      	ldr	r1, [r0, r1]
c0d03cd6:	2001      	movs	r0, #1
c0d03cd8:	2900      	cmp	r1, #0
c0d03cda:	d100      	bne.n	c0d03cde <usbd_is_valid_intf+0x1a>
c0d03cdc:	4608      	mov	r0, r1
c0d03cde:	4770      	bx	lr

c0d03ce0 <USBD_StdDevReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdDevReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d03ce0:	b580      	push	{r7, lr}
c0d03ce2:	784a      	ldrb	r2, [r1, #1]
  USBD_StatusTypeDef ret = USBD_OK;  
  
  switch (req->bRequest) 
c0d03ce4:	2a04      	cmp	r2, #4
c0d03ce6:	dd08      	ble.n	c0d03cfa <USBD_StdDevReq+0x1a>
c0d03ce8:	2a07      	cmp	r2, #7
c0d03cea:	dc0f      	bgt.n	c0d03d0c <USBD_StdDevReq+0x2c>
c0d03cec:	2a05      	cmp	r2, #5
c0d03cee:	d014      	beq.n	c0d03d1a <USBD_StdDevReq+0x3a>
c0d03cf0:	2a06      	cmp	r2, #6
c0d03cf2:	d11b      	bne.n	c0d03d2c <USBD_StdDevReq+0x4c>
  {
  case USB_REQ_GET_DESCRIPTOR: 
    
    USBD_GetDescriptor (pdev, req) ;
c0d03cf4:	f000 f821 	bl	c0d03d3a <USBD_GetDescriptor>
c0d03cf8:	e01d      	b.n	c0d03d36 <USBD_StdDevReq+0x56>
c0d03cfa:	2a00      	cmp	r2, #0
c0d03cfc:	d010      	beq.n	c0d03d20 <USBD_StdDevReq+0x40>
c0d03cfe:	2a01      	cmp	r2, #1
c0d03d00:	d017      	beq.n	c0d03d32 <USBD_StdDevReq+0x52>
c0d03d02:	2a03      	cmp	r2, #3
c0d03d04:	d112      	bne.n	c0d03d2c <USBD_StdDevReq+0x4c>
    USBD_GetStatus (pdev , req);
    break;
    
    
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
c0d03d06:	f000 f93b 	bl	c0d03f80 <USBD_SetFeature>
c0d03d0a:	e014      	b.n	c0d03d36 <USBD_StdDevReq+0x56>
c0d03d0c:	2a08      	cmp	r2, #8
c0d03d0e:	d00a      	beq.n	c0d03d26 <USBD_StdDevReq+0x46>
c0d03d10:	2a09      	cmp	r2, #9
c0d03d12:	d10b      	bne.n	c0d03d2c <USBD_StdDevReq+0x4c>
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
    break;
    
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
c0d03d14:	f000 f8c3 	bl	c0d03e9e <USBD_SetConfig>
c0d03d18:	e00d      	b.n	c0d03d36 <USBD_StdDevReq+0x56>
    
    USBD_GetDescriptor (pdev, req) ;
    break;
    
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
c0d03d1a:	f000 f89b 	bl	c0d03e54 <USBD_SetAddress>
c0d03d1e:	e00a      	b.n	c0d03d36 <USBD_StdDevReq+0x56>
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_STATUS:                                  
    USBD_GetStatus (pdev , req);
c0d03d20:	f000 f90b 	bl	c0d03f3a <USBD_GetStatus>
c0d03d24:	e007      	b.n	c0d03d36 <USBD_StdDevReq+0x56>
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
c0d03d26:	f000 f8f1 	bl	c0d03f0c <USBD_GetConfig>
c0d03d2a:	e004      	b.n	c0d03d36 <USBD_StdDevReq+0x56>
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
    break;
    
  default:  
    USBD_CtlError(pdev , req);
c0d03d2c:	f000 f971 	bl	c0d04012 <USBD_CtlError>
c0d03d30:	e001      	b.n	c0d03d36 <USBD_StdDevReq+0x56>
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
    break;
    
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
c0d03d32:	f000 f944 	bl	c0d03fbe <USBD_ClrFeature>
  default:  
    USBD_CtlError(pdev , req);
    break;
  }
  
  return ret;
c0d03d36:	2000      	movs	r0, #0
c0d03d38:	bd80      	pop	{r7, pc}

c0d03d3a <USBD_GetDescriptor>:
* @param  req: usb request
* @retval status
*/
void USBD_GetDescriptor(USBD_HandleTypeDef *pdev , 
                               USBD_SetupReqTypedef *req)
{
c0d03d3a:	b5b0      	push	{r4, r5, r7, lr}
c0d03d3c:	b082      	sub	sp, #8
c0d03d3e:	460d      	mov	r5, r1
c0d03d40:	4604      	mov	r4, r0
  uint16_t len;
  uint8_t *pbuf;
  
    
  switch (req->wValue >> 8)
c0d03d42:	8869      	ldrh	r1, [r5, #2]
c0d03d44:	0a08      	lsrs	r0, r1, #8
c0d03d46:	2805      	cmp	r0, #5
c0d03d48:	dc13      	bgt.n	c0d03d72 <USBD_GetDescriptor+0x38>
c0d03d4a:	2801      	cmp	r0, #1
c0d03d4c:	d01c      	beq.n	c0d03d88 <USBD_GetDescriptor+0x4e>
c0d03d4e:	2802      	cmp	r0, #2
c0d03d50:	d025      	beq.n	c0d03d9e <USBD_GetDescriptor+0x64>
c0d03d52:	2803      	cmp	r0, #3
c0d03d54:	d13a      	bne.n	c0d03dcc <USBD_GetDescriptor+0x92>
c0d03d56:	b2c8      	uxtb	r0, r1
      }
    }
    break;
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
c0d03d58:	2802      	cmp	r0, #2
c0d03d5a:	dc3c      	bgt.n	c0d03dd6 <USBD_GetDescriptor+0x9c>
c0d03d5c:	2800      	cmp	r0, #0
c0d03d5e:	d065      	beq.n	c0d03e2c <USBD_GetDescriptor+0xf2>
c0d03d60:	2801      	cmp	r0, #1
c0d03d62:	d06d      	beq.n	c0d03e40 <USBD_GetDescriptor+0x106>
c0d03d64:	2802      	cmp	r0, #2
c0d03d66:	d131      	bne.n	c0d03dcc <USBD_GetDescriptor+0x92>
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
c0d03d68:	2011      	movs	r0, #17
c0d03d6a:	0100      	lsls	r0, r0, #4
c0d03d6c:	5820      	ldr	r0, [r4, r0]
c0d03d6e:	68c0      	ldr	r0, [r0, #12]
c0d03d70:	e00e      	b.n	c0d03d90 <USBD_GetDescriptor+0x56>
c0d03d72:	2806      	cmp	r0, #6
c0d03d74:	d01d      	beq.n	c0d03db2 <USBD_GetDescriptor+0x78>
c0d03d76:	2807      	cmp	r0, #7
c0d03d78:	d025      	beq.n	c0d03dc6 <USBD_GetDescriptor+0x8c>
c0d03d7a:	280f      	cmp	r0, #15
c0d03d7c:	d126      	bne.n	c0d03dcc <USBD_GetDescriptor+0x92>
    
  switch (req->wValue >> 8)
  { 
#if (USBD_LPM_ENABLED == 1)
  case USB_DESC_TYPE_BOS:
    pbuf = ((GetBOSDescriptor_t)PIC(pdev->pDesc->GetBOSDescriptor))(pdev->dev_speed, &len);
c0d03d7e:	2011      	movs	r0, #17
c0d03d80:	0100      	lsls	r0, r0, #4
c0d03d82:	5820      	ldr	r0, [r4, r0]
c0d03d84:	69c0      	ldr	r0, [r0, #28]
c0d03d86:	e003      	b.n	c0d03d90 <USBD_GetDescriptor+0x56>
    break;
#endif    
  case USB_DESC_TYPE_DEVICE:
    pbuf = ((GetDeviceDescriptor_t)PIC(pdev->pDesc->GetDeviceDescriptor))(pdev->dev_speed, &len);
c0d03d88:	2011      	movs	r0, #17
c0d03d8a:	0100      	lsls	r0, r0, #4
c0d03d8c:	5820      	ldr	r0, [r4, r0]
c0d03d8e:	6800      	ldr	r0, [r0, #0]
c0d03d90:	f7fe f916 	bl	c0d01fc0 <pic>
c0d03d94:	4602      	mov	r2, r0
c0d03d96:	7c20      	ldrb	r0, [r4, #16]
c0d03d98:	a901      	add	r1, sp, #4
c0d03d9a:	4790      	blx	r2
c0d03d9c:	e034      	b.n	c0d03e08 <USBD_GetDescriptor+0xce>
    break;
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
c0d03d9e:	2045      	movs	r0, #69	; 0x45
c0d03da0:	0080      	lsls	r0, r0, #2
c0d03da2:	5820      	ldr	r0, [r4, r0]
c0d03da4:	2800      	cmp	r0, #0
c0d03da6:	d021      	beq.n	c0d03dec <USBD_GetDescriptor+0xb2>
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
c0d03da8:	7c21      	ldrb	r1, [r4, #16]
c0d03daa:	2900      	cmp	r1, #0
c0d03dac:	d026      	beq.n	c0d03dfc <USBD_GetDescriptor+0xc2>
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
        //pbuf[1] = USB_DESC_TYPE_CONFIGURATION; CONST BUFFER KTHX
      }
      else
      {
        pbuf   = (uint8_t *)((GetFSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetFSConfigDescriptor))(&len);
c0d03dae:	6ac0      	ldr	r0, [r0, #44]	; 0x2c
c0d03db0:	e025      	b.n	c0d03dfe <USBD_GetDescriptor+0xc4>
#endif   
    }
    break;
  case USB_DESC_TYPE_DEVICE_QUALIFIER:                   

    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL )   
c0d03db2:	7c20      	ldrb	r0, [r4, #16]
c0d03db4:	2800      	cmp	r0, #0
c0d03db6:	d109      	bne.n	c0d03dcc <USBD_GetDescriptor+0x92>
c0d03db8:	2045      	movs	r0, #69	; 0x45
c0d03dba:	0080      	lsls	r0, r0, #2
c0d03dbc:	5820      	ldr	r0, [r4, r0]
c0d03dbe:	2800      	cmp	r0, #0
c0d03dc0:	d004      	beq.n	c0d03dcc <USBD_GetDescriptor+0x92>
    {
      pbuf   = (uint8_t *)((GetDeviceQualifierDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetDeviceQualifierDescriptor))(&len);
c0d03dc2:	6b40      	ldr	r0, [r0, #52]	; 0x34
c0d03dc4:	e01b      	b.n	c0d03dfe <USBD_GetDescriptor+0xc4>
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d03dc6:	7c20      	ldrb	r0, [r4, #16]
c0d03dc8:	2800      	cmp	r0, #0
c0d03dca:	d010      	beq.n	c0d03dee <USBD_GetDescriptor+0xb4>
c0d03dcc:	4620      	mov	r0, r4
c0d03dce:	4629      	mov	r1, r5
c0d03dd0:	f000 f91f 	bl	c0d04012 <USBD_CtlError>
c0d03dd4:	e028      	b.n	c0d03e28 <USBD_GetDescriptor+0xee>
c0d03dd6:	2803      	cmp	r0, #3
c0d03dd8:	d02d      	beq.n	c0d03e36 <USBD_GetDescriptor+0xfc>
c0d03dda:	2804      	cmp	r0, #4
c0d03ddc:	d035      	beq.n	c0d03e4a <USBD_GetDescriptor+0x110>
c0d03dde:	2805      	cmp	r0, #5
c0d03de0:	d1f4      	bne.n	c0d03dcc <USBD_GetDescriptor+0x92>
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_INTERFACE_STR:
      pbuf = ((GetInterfaceStrDescriptor_t)PIC(pdev->pDesc->GetInterfaceStrDescriptor))(pdev->dev_speed, &len);
c0d03de2:	2011      	movs	r0, #17
c0d03de4:	0100      	lsls	r0, r0, #4
c0d03de6:	5820      	ldr	r0, [r4, r0]
c0d03de8:	6980      	ldr	r0, [r0, #24]
c0d03dea:	e7d1      	b.n	c0d03d90 <USBD_GetDescriptor+0x56>
c0d03dec:	e00d      	b.n	c0d03e0a <USBD_GetDescriptor+0xd0>
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d03dee:	2045      	movs	r0, #69	; 0x45
c0d03df0:	0080      	lsls	r0, r0, #2
c0d03df2:	5820      	ldr	r0, [r4, r0]
c0d03df4:	2800      	cmp	r0, #0
c0d03df6:	d0e9      	beq.n	c0d03dcc <USBD_GetDescriptor+0x92>
    {
      pbuf   = (uint8_t *)((GetOtherSpeedConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetOtherSpeedConfigDescriptor))(&len);
c0d03df8:	6b00      	ldr	r0, [r0, #48]	; 0x30
c0d03dfa:	e000      	b.n	c0d03dfe <USBD_GetDescriptor+0xc4>
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
      {
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
c0d03dfc:	6a80      	ldr	r0, [r0, #40]	; 0x28
c0d03dfe:	f7fe f8df 	bl	c0d01fc0 <pic>
c0d03e02:	4601      	mov	r1, r0
c0d03e04:	a801      	add	r0, sp, #4
c0d03e06:	4788      	blx	r1
c0d03e08:	4601      	mov	r1, r0
c0d03e0a:	a801      	add	r0, sp, #4
  default: 
     USBD_CtlError(pdev , req);
    return;
  }
  
  if((len != 0)&& (req->wLength != 0))
c0d03e0c:	8802      	ldrh	r2, [r0, #0]
c0d03e0e:	2a00      	cmp	r2, #0
c0d03e10:	d00a      	beq.n	c0d03e28 <USBD_GetDescriptor+0xee>
c0d03e12:	88e8      	ldrh	r0, [r5, #6]
c0d03e14:	2800      	cmp	r0, #0
c0d03e16:	d007      	beq.n	c0d03e28 <USBD_GetDescriptor+0xee>
  {
    
    len = MIN(len , req->wLength);
c0d03e18:	4282      	cmp	r2, r0
c0d03e1a:	d300      	bcc.n	c0d03e1e <USBD_GetDescriptor+0xe4>
c0d03e1c:	4602      	mov	r2, r0
c0d03e1e:	a801      	add	r0, sp, #4
c0d03e20:	8002      	strh	r2, [r0, #0]
    
    // prepare abort if host does not read the whole data
    //USBD_CtlReceiveStatus(pdev);

    // start transfer
    USBD_CtlSendData (pdev, 
c0d03e22:	4620      	mov	r0, r4
c0d03e24:	f000 fb56 	bl	c0d044d4 <USBD_CtlSendData>
                      pbuf,
                      len);
  }
  
}
c0d03e28:	b002      	add	sp, #8
c0d03e2a:	bdb0      	pop	{r4, r5, r7, pc}
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
    {
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
c0d03e2c:	2011      	movs	r0, #17
c0d03e2e:	0100      	lsls	r0, r0, #4
c0d03e30:	5820      	ldr	r0, [r4, r0]
c0d03e32:	6840      	ldr	r0, [r0, #4]
c0d03e34:	e7ac      	b.n	c0d03d90 <USBD_GetDescriptor+0x56>
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
c0d03e36:	2011      	movs	r0, #17
c0d03e38:	0100      	lsls	r0, r0, #4
c0d03e3a:	5820      	ldr	r0, [r4, r0]
c0d03e3c:	6900      	ldr	r0, [r0, #16]
c0d03e3e:	e7a7      	b.n	c0d03d90 <USBD_GetDescriptor+0x56>
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
      break;
      
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
c0d03e40:	2011      	movs	r0, #17
c0d03e42:	0100      	lsls	r0, r0, #4
c0d03e44:	5820      	ldr	r0, [r4, r0]
c0d03e46:	6880      	ldr	r0, [r0, #8]
c0d03e48:	e7a2      	b.n	c0d03d90 <USBD_GetDescriptor+0x56>
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
c0d03e4a:	2011      	movs	r0, #17
c0d03e4c:	0100      	lsls	r0, r0, #4
c0d03e4e:	5820      	ldr	r0, [r4, r0]
c0d03e50:	6940      	ldr	r0, [r0, #20]
c0d03e52:	e79d      	b.n	c0d03d90 <USBD_GetDescriptor+0x56>

c0d03e54 <USBD_SetAddress>:
* @param  req: usb request
* @retval status
*/
void USBD_SetAddress(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d03e54:	b570      	push	{r4, r5, r6, lr}
c0d03e56:	4604      	mov	r4, r0
  uint8_t  dev_addr; 
  
  if ((req->wIndex == 0) && (req->wLength == 0)) 
c0d03e58:	8888      	ldrh	r0, [r1, #4]
c0d03e5a:	2800      	cmp	r0, #0
c0d03e5c:	d10b      	bne.n	c0d03e76 <USBD_SetAddress+0x22>
c0d03e5e:	88c8      	ldrh	r0, [r1, #6]
c0d03e60:	2800      	cmp	r0, #0
c0d03e62:	d108      	bne.n	c0d03e76 <USBD_SetAddress+0x22>
  {
    dev_addr = (uint8_t)(req->wValue) & 0x7F;     
c0d03e64:	8848      	ldrh	r0, [r1, #2]
c0d03e66:	267f      	movs	r6, #127	; 0x7f
c0d03e68:	4006      	ands	r6, r0
    
    if (pdev->dev_state == USBD_STATE_CONFIGURED) 
c0d03e6a:	20fc      	movs	r0, #252	; 0xfc
c0d03e6c:	5c20      	ldrb	r0, [r4, r0]
c0d03e6e:	4625      	mov	r5, r4
c0d03e70:	35fc      	adds	r5, #252	; 0xfc
c0d03e72:	2803      	cmp	r0, #3
c0d03e74:	d103      	bne.n	c0d03e7e <USBD_SetAddress+0x2a>
c0d03e76:	4620      	mov	r0, r4
c0d03e78:	f000 f8cb 	bl	c0d04012 <USBD_CtlError>
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d03e7c:	bd70      	pop	{r4, r5, r6, pc}
    {
      USBD_CtlError(pdev , req);
    } 
    else 
    {
      pdev->dev_address = dev_addr;
c0d03e7e:	20fe      	movs	r0, #254	; 0xfe
c0d03e80:	5426      	strb	r6, [r4, r0]
      USBD_LL_SetUSBAddress(pdev, dev_addr);               
c0d03e82:	b2f1      	uxtb	r1, r6
c0d03e84:	4620      	mov	r0, r4
c0d03e86:	f7ff fd0b 	bl	c0d038a0 <USBD_LL_SetUSBAddress>
      USBD_CtlSendStatus(pdev);                         
c0d03e8a:	4620      	mov	r0, r4
c0d03e8c:	f000 fb4d 	bl	c0d0452a <USBD_CtlSendStatus>
      
      if (dev_addr != 0) 
c0d03e90:	2002      	movs	r0, #2
c0d03e92:	2101      	movs	r1, #1
c0d03e94:	2e00      	cmp	r6, #0
c0d03e96:	d100      	bne.n	c0d03e9a <USBD_SetAddress+0x46>
c0d03e98:	4608      	mov	r0, r1
c0d03e9a:	7028      	strb	r0, [r5, #0]
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d03e9c:	bd70      	pop	{r4, r5, r6, pc}

c0d03e9e <USBD_SetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_SetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d03e9e:	b570      	push	{r4, r5, r6, lr}
c0d03ea0:	460d      	mov	r5, r1
c0d03ea2:	4604      	mov	r4, r0
  
  uint8_t  cfgidx;
  
  cfgidx = (uint8_t)(req->wValue);                 
c0d03ea4:	78ae      	ldrb	r6, [r5, #2]
  
  if (cfgidx > USBD_MAX_NUM_CONFIGURATION ) 
c0d03ea6:	2e02      	cmp	r6, #2
c0d03ea8:	d21d      	bcs.n	c0d03ee6 <USBD_SetConfig+0x48>
  {            
     USBD_CtlError(pdev , req);                              
  } 
  else 
  {
    switch (pdev->dev_state) 
c0d03eaa:	20fc      	movs	r0, #252	; 0xfc
c0d03eac:	5c21      	ldrb	r1, [r4, r0]
c0d03eae:	4620      	mov	r0, r4
c0d03eb0:	30fc      	adds	r0, #252	; 0xfc
c0d03eb2:	2903      	cmp	r1, #3
c0d03eb4:	d007      	beq.n	c0d03ec6 <USBD_SetConfig+0x28>
c0d03eb6:	2902      	cmp	r1, #2
c0d03eb8:	d115      	bne.n	c0d03ee6 <USBD_SetConfig+0x48>
    {
    case USBD_STATE_ADDRESSED:
      if (cfgidx) 
c0d03eba:	2e00      	cmp	r6, #0
c0d03ebc:	d022      	beq.n	c0d03f04 <USBD_SetConfig+0x66>
      {                                			   							   							   				
        pdev->dev_config = cfgidx;
c0d03ebe:	6066      	str	r6, [r4, #4]
        pdev->dev_state = USBD_STATE_CONFIGURED;
c0d03ec0:	2103      	movs	r1, #3
c0d03ec2:	7001      	strb	r1, [r0, #0]
c0d03ec4:	e009      	b.n	c0d03eda <USBD_SetConfig+0x3c>
      }
      USBD_CtlSendStatus(pdev);
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
c0d03ec6:	2e00      	cmp	r6, #0
c0d03ec8:	d012      	beq.n	c0d03ef0 <USBD_SetConfig+0x52>
        pdev->dev_state = USBD_STATE_ADDRESSED;
        pdev->dev_config = cfgidx;          
        USBD_ClrClassConfig(pdev , cfgidx);
        USBD_CtlSendStatus(pdev);
      } 
      else  if (cfgidx != pdev->dev_config) 
c0d03eca:	6860      	ldr	r0, [r4, #4]
c0d03ecc:	4286      	cmp	r6, r0
c0d03ece:	d019      	beq.n	c0d03f04 <USBD_SetConfig+0x66>
      {
        /* Clear old configuration */
        USBD_ClrClassConfig(pdev , pdev->dev_config);
c0d03ed0:	b2c1      	uxtb	r1, r0
c0d03ed2:	4620      	mov	r0, r4
c0d03ed4:	f7ff fd8b 	bl	c0d039ee <USBD_ClrClassConfig>
        
        /* set new configuration */
        pdev->dev_config = cfgidx;
c0d03ed8:	6066      	str	r6, [r4, #4]
c0d03eda:	4620      	mov	r0, r4
c0d03edc:	4631      	mov	r1, r6
c0d03ede:	f7ff fd69 	bl	c0d039b4 <USBD_SetClassConfig>
c0d03ee2:	2802      	cmp	r0, #2
c0d03ee4:	d10e      	bne.n	c0d03f04 <USBD_SetConfig+0x66>
c0d03ee6:	4620      	mov	r0, r4
c0d03ee8:	4629      	mov	r1, r5
c0d03eea:	f000 f892 	bl	c0d04012 <USBD_CtlError>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d03eee:	bd70      	pop	{r4, r5, r6, pc}
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
      {                           
        pdev->dev_state = USBD_STATE_ADDRESSED;
c0d03ef0:	2102      	movs	r1, #2
c0d03ef2:	7001      	strb	r1, [r0, #0]
        pdev->dev_config = cfgidx;          
c0d03ef4:	6066      	str	r6, [r4, #4]
        USBD_ClrClassConfig(pdev , cfgidx);
c0d03ef6:	4620      	mov	r0, r4
c0d03ef8:	4631      	mov	r1, r6
c0d03efa:	f7ff fd78 	bl	c0d039ee <USBD_ClrClassConfig>
        USBD_CtlSendStatus(pdev);
c0d03efe:	4620      	mov	r0, r4
c0d03f00:	f000 fb13 	bl	c0d0452a <USBD_CtlSendStatus>
c0d03f04:	4620      	mov	r0, r4
c0d03f06:	f000 fb10 	bl	c0d0452a <USBD_CtlSendStatus>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d03f0a:	bd70      	pop	{r4, r5, r6, pc}

c0d03f0c <USBD_GetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_GetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d03f0c:	b580      	push	{r7, lr}

  if (req->wLength != 1) 
c0d03f0e:	88ca      	ldrh	r2, [r1, #6]
c0d03f10:	2a01      	cmp	r2, #1
c0d03f12:	d10a      	bne.n	c0d03f2a <USBD_GetConfig+0x1e>
  {                   
     USBD_CtlError(pdev , req);
  }
  else 
  {
    switch (pdev->dev_state )  
c0d03f14:	22fc      	movs	r2, #252	; 0xfc
c0d03f16:	5c82      	ldrb	r2, [r0, r2]
c0d03f18:	2a03      	cmp	r2, #3
c0d03f1a:	d009      	beq.n	c0d03f30 <USBD_GetConfig+0x24>
c0d03f1c:	2a02      	cmp	r2, #2
c0d03f1e:	d104      	bne.n	c0d03f2a <USBD_GetConfig+0x1e>
    {
    case USBD_STATE_ADDRESSED:                     
      pdev->dev_default_config = 0;
c0d03f20:	2100      	movs	r1, #0
c0d03f22:	6081      	str	r1, [r0, #8]
c0d03f24:	4601      	mov	r1, r0
c0d03f26:	3108      	adds	r1, #8
c0d03f28:	e003      	b.n	c0d03f32 <USBD_GetConfig+0x26>
c0d03f2a:	f000 f872 	bl	c0d04012 <USBD_CtlError>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d03f2e:	bd80      	pop	{r7, pc}
                        1);
      break;
      
    case USBD_STATE_CONFIGURED:   
      USBD_CtlSendData (pdev, 
                        (uint8_t *)&pdev->dev_config,
c0d03f30:	1d01      	adds	r1, r0, #4
c0d03f32:	2201      	movs	r2, #1
c0d03f34:	f000 face 	bl	c0d044d4 <USBD_CtlSendData>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d03f38:	bd80      	pop	{r7, pc}

c0d03f3a <USBD_GetStatus>:
* @param  req: usb request
* @retval status
*/
void USBD_GetStatus(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d03f3a:	b5b0      	push	{r4, r5, r7, lr}
c0d03f3c:	4604      	mov	r4, r0
  
    
  switch (pdev->dev_state) 
c0d03f3e:	20fc      	movs	r0, #252	; 0xfc
c0d03f40:	5c20      	ldrb	r0, [r4, r0]
c0d03f42:	22fe      	movs	r2, #254	; 0xfe
c0d03f44:	4002      	ands	r2, r0
c0d03f46:	2a02      	cmp	r2, #2
c0d03f48:	d116      	bne.n	c0d03f78 <USBD_GetStatus+0x3e>
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d03f4a:	2001      	movs	r0, #1
c0d03f4c:	60e0      	str	r0, [r4, #12]
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d03f4e:	2041      	movs	r0, #65	; 0x41
c0d03f50:	0080      	lsls	r0, r0, #2
c0d03f52:	5821      	ldr	r1, [r4, r0]
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d03f54:	4625      	mov	r5, r4
c0d03f56:	350c      	adds	r5, #12
c0d03f58:	2003      	movs	r0, #3
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d03f5a:	2900      	cmp	r1, #0
c0d03f5c:	d005      	beq.n	c0d03f6a <USBD_GetStatus+0x30>
c0d03f5e:	4620      	mov	r0, r4
c0d03f60:	f000 faef 	bl	c0d04542 <USBD_CtlReceiveStatus>
c0d03f64:	68e1      	ldr	r1, [r4, #12]
c0d03f66:	2002      	movs	r0, #2
c0d03f68:	4308      	orrs	r0, r1
    {
       pdev->dev_config_status |= USB_CONFIG_REMOTE_WAKEUP;                                
c0d03f6a:	60e0      	str	r0, [r4, #12]
    }
    
    USBD_CtlSendData (pdev, 
c0d03f6c:	2202      	movs	r2, #2
c0d03f6e:	4620      	mov	r0, r4
c0d03f70:	4629      	mov	r1, r5
c0d03f72:	f000 faaf 	bl	c0d044d4 <USBD_CtlSendData>
    
  default :
    USBD_CtlError(pdev , req);                        
    break;
  }
}
c0d03f76:	bdb0      	pop	{r4, r5, r7, pc}
                      (uint8_t *)& pdev->dev_config_status,
                      2);
    break;
    
  default :
    USBD_CtlError(pdev , req);                        
c0d03f78:	4620      	mov	r0, r4
c0d03f7a:	f000 f84a 	bl	c0d04012 <USBD_CtlError>
    break;
  }
}
c0d03f7e:	bdb0      	pop	{r4, r5, r7, pc}

c0d03f80 <USBD_SetFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_SetFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d03f80:	b5b0      	push	{r4, r5, r7, lr}
c0d03f82:	460d      	mov	r5, r1
c0d03f84:	4604      	mov	r4, r0

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
c0d03f86:	8868      	ldrh	r0, [r5, #2]
c0d03f88:	2801      	cmp	r0, #1
c0d03f8a:	d117      	bne.n	c0d03fbc <USBD_SetFeature+0x3c>
  {
    pdev->dev_remote_wakeup = 1;  
c0d03f8c:	2041      	movs	r0, #65	; 0x41
c0d03f8e:	0080      	lsls	r0, r0, #2
c0d03f90:	2101      	movs	r1, #1
c0d03f92:	5021      	str	r1, [r4, r0]
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03f94:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03f96:	2802      	cmp	r0, #2
c0d03f98:	d80d      	bhi.n	c0d03fb6 <USBD_SetFeature+0x36>
c0d03f9a:	00c0      	lsls	r0, r0, #3
c0d03f9c:	1820      	adds	r0, r4, r0
c0d03f9e:	2145      	movs	r1, #69	; 0x45
c0d03fa0:	0089      	lsls	r1, r1, #2
c0d03fa2:	5840      	ldr	r0, [r0, r1]
{

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
  {
    pdev->dev_remote_wakeup = 1;  
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03fa4:	2800      	cmp	r0, #0
c0d03fa6:	d006      	beq.n	c0d03fb6 <USBD_SetFeature+0x36>
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d03fa8:	6880      	ldr	r0, [r0, #8]
c0d03faa:	f7fe f809 	bl	c0d01fc0 <pic>
c0d03fae:	4602      	mov	r2, r0
c0d03fb0:	4620      	mov	r0, r4
c0d03fb2:	4629      	mov	r1, r5
c0d03fb4:	4790      	blx	r2
    }
    USBD_CtlSendStatus(pdev);
c0d03fb6:	4620      	mov	r0, r4
c0d03fb8:	f000 fab7 	bl	c0d0452a <USBD_CtlSendStatus>
  }

}
c0d03fbc:	bdb0      	pop	{r4, r5, r7, pc}

c0d03fbe <USBD_ClrFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_ClrFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d03fbe:	b5b0      	push	{r4, r5, r7, lr}
c0d03fc0:	460d      	mov	r5, r1
c0d03fc2:	4604      	mov	r4, r0
  switch (pdev->dev_state)
c0d03fc4:	20fc      	movs	r0, #252	; 0xfc
c0d03fc6:	5c20      	ldrb	r0, [r4, r0]
c0d03fc8:	21fe      	movs	r1, #254	; 0xfe
c0d03fca:	4001      	ands	r1, r0
c0d03fcc:	2902      	cmp	r1, #2
c0d03fce:	d11b      	bne.n	c0d04008 <USBD_ClrFeature+0x4a>
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
c0d03fd0:	8868      	ldrh	r0, [r5, #2]
c0d03fd2:	2801      	cmp	r0, #1
c0d03fd4:	d11c      	bne.n	c0d04010 <USBD_ClrFeature+0x52>
    {
      pdev->dev_remote_wakeup = 0; 
c0d03fd6:	2041      	movs	r0, #65	; 0x41
c0d03fd8:	0080      	lsls	r0, r0, #2
c0d03fda:	2100      	movs	r1, #0
c0d03fdc:	5021      	str	r1, [r4, r0]
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03fde:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03fe0:	2802      	cmp	r0, #2
c0d03fe2:	d80d      	bhi.n	c0d04000 <USBD_ClrFeature+0x42>
c0d03fe4:	00c0      	lsls	r0, r0, #3
c0d03fe6:	1820      	adds	r0, r4, r0
c0d03fe8:	2145      	movs	r1, #69	; 0x45
c0d03fea:	0089      	lsls	r1, r1, #2
c0d03fec:	5840      	ldr	r0, [r0, r1]
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
    {
      pdev->dev_remote_wakeup = 0; 
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03fee:	2800      	cmp	r0, #0
c0d03ff0:	d006      	beq.n	c0d04000 <USBD_ClrFeature+0x42>
        ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d03ff2:	6880      	ldr	r0, [r0, #8]
c0d03ff4:	f7fd ffe4 	bl	c0d01fc0 <pic>
c0d03ff8:	4602      	mov	r2, r0
c0d03ffa:	4620      	mov	r0, r4
c0d03ffc:	4629      	mov	r1, r5
c0d03ffe:	4790      	blx	r2
      }
      USBD_CtlSendStatus(pdev);
c0d04000:	4620      	mov	r0, r4
c0d04002:	f000 fa92 	bl	c0d0452a <USBD_CtlSendStatus>
    
  default :
     USBD_CtlError(pdev , req);
    break;
  }
}
c0d04006:	bdb0      	pop	{r4, r5, r7, pc}
      USBD_CtlSendStatus(pdev);
    }
    break;
    
  default :
     USBD_CtlError(pdev , req);
c0d04008:	4620      	mov	r0, r4
c0d0400a:	4629      	mov	r1, r5
c0d0400c:	f000 f801 	bl	c0d04012 <USBD_CtlError>
    break;
  }
}
c0d04010:	bdb0      	pop	{r4, r5, r7, pc}

c0d04012 <USBD_CtlError>:
  USBD_LL_StallEP(pdev , 0);
}

__weak void USBD_CtlError( USBD_HandleTypeDef *pdev ,
                            USBD_SetupReqTypedef *req)
{
c0d04012:	b510      	push	{r4, lr}
c0d04014:	4604      	mov	r4, r0
* @param  req: usb request
* @retval None
*/
void USBD_CtlStall( USBD_HandleTypeDef *pdev)
{
  USBD_LL_StallEP(pdev , 0x80);
c0d04016:	2180      	movs	r1, #128	; 0x80
c0d04018:	f7ff fbe6 	bl	c0d037e8 <USBD_LL_StallEP>
  USBD_LL_StallEP(pdev , 0);
c0d0401c:	2100      	movs	r1, #0
c0d0401e:	4620      	mov	r0, r4
c0d04020:	f7ff fbe2 	bl	c0d037e8 <USBD_LL_StallEP>

__weak void USBD_CtlError( USBD_HandleTypeDef *pdev ,
                            USBD_SetupReqTypedef *req)
{
  USBD_CtlStall(pdev);
}
c0d04024:	bd10      	pop	{r4, pc}

c0d04026 <USBD_StdItfReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdItfReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d04026:	b5b0      	push	{r4, r5, r7, lr}
c0d04028:	460d      	mov	r5, r1
c0d0402a:	4604      	mov	r4, r0
  USBD_StatusTypeDef ret = USBD_OK; 
  
  switch (pdev->dev_state) 
c0d0402c:	20fc      	movs	r0, #252	; 0xfc
c0d0402e:	5c20      	ldrb	r0, [r4, r0]
c0d04030:	2803      	cmp	r0, #3
c0d04032:	d117      	bne.n	c0d04064 <USBD_StdItfReq+0x3e>
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d04034:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d04036:	2802      	cmp	r0, #2
c0d04038:	d814      	bhi.n	c0d04064 <USBD_StdItfReq+0x3e>
c0d0403a:	00c0      	lsls	r0, r0, #3
c0d0403c:	1820      	adds	r0, r4, r0
c0d0403e:	2145      	movs	r1, #69	; 0x45
c0d04040:	0089      	lsls	r1, r1, #2
c0d04042:	5840      	ldr	r0, [r0, r1]
  
  switch (pdev->dev_state) 
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d04044:	2800      	cmp	r0, #0
c0d04046:	d00d      	beq.n	c0d04064 <USBD_StdItfReq+0x3e>
    {
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d04048:	6880      	ldr	r0, [r0, #8]
c0d0404a:	f7fd ffb9 	bl	c0d01fc0 <pic>
c0d0404e:	4602      	mov	r2, r0
c0d04050:	4620      	mov	r0, r4
c0d04052:	4629      	mov	r1, r5
c0d04054:	4790      	blx	r2
      
      if((req->wLength == 0)&& (ret == USBD_OK))
c0d04056:	88e8      	ldrh	r0, [r5, #6]
c0d04058:	2800      	cmp	r0, #0
c0d0405a:	d107      	bne.n	c0d0406c <USBD_StdItfReq+0x46>
      {
         USBD_CtlSendStatus(pdev);
c0d0405c:	4620      	mov	r0, r4
c0d0405e:	f000 fa64 	bl	c0d0452a <USBD_CtlSendStatus>
c0d04062:	e003      	b.n	c0d0406c <USBD_StdItfReq+0x46>
c0d04064:	4620      	mov	r0, r4
c0d04066:	4629      	mov	r1, r5
c0d04068:	f7ff ffd3 	bl	c0d04012 <USBD_CtlError>
    
  default:
     USBD_CtlError(pdev , req);
    break;
  }
  return USBD_OK;
c0d0406c:	2000      	movs	r0, #0
c0d0406e:	bdb0      	pop	{r4, r5, r7, pc}

c0d04070 <USBD_StdEPReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdEPReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d04070:	b570      	push	{r4, r5, r6, lr}
c0d04072:	460d      	mov	r5, r1
c0d04074:	4604      	mov	r4, r0
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d04076:	7828      	ldrb	r0, [r5, #0]
c0d04078:	2160      	movs	r1, #96	; 0x60
c0d0407a:	4001      	ands	r1, r0
{
  
  uint8_t   ep_addr;
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
c0d0407c:	792e      	ldrb	r6, [r5, #4]
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d0407e:	2920      	cmp	r1, #32
c0d04080:	d110      	bne.n	c0d040a4 <USBD_StdEPReq+0x34>
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d04082:	2e02      	cmp	r6, #2
c0d04084:	d80e      	bhi.n	c0d040a4 <USBD_StdEPReq+0x34>
c0d04086:	00f0      	lsls	r0, r6, #3
c0d04088:	1820      	adds	r0, r4, r0
c0d0408a:	2145      	movs	r1, #69	; 0x45
c0d0408c:	0089      	lsls	r1, r1, #2
c0d0408e:	5840      	ldr	r0, [r0, r1]
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d04090:	2800      	cmp	r0, #0
c0d04092:	d007      	beq.n	c0d040a4 <USBD_StdEPReq+0x34>
  {
    ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d04094:	6880      	ldr	r0, [r0, #8]
c0d04096:	f7fd ff93 	bl	c0d01fc0 <pic>
c0d0409a:	4602      	mov	r2, r0
c0d0409c:	4620      	mov	r0, r4
c0d0409e:	4629      	mov	r1, r5
c0d040a0:	4790      	blx	r2
c0d040a2:	e06e      	b.n	c0d04182 <USBD_StdEPReq+0x112>
    
    return USBD_OK;
  }
  
  switch (req->bRequest) 
c0d040a4:	7868      	ldrb	r0, [r5, #1]
c0d040a6:	2800      	cmp	r0, #0
c0d040a8:	d017      	beq.n	c0d040da <USBD_StdEPReq+0x6a>
c0d040aa:	2801      	cmp	r0, #1
c0d040ac:	d01e      	beq.n	c0d040ec <USBD_StdEPReq+0x7c>
c0d040ae:	2803      	cmp	r0, #3
c0d040b0:	d167      	bne.n	c0d04182 <USBD_StdEPReq+0x112>
  {
    
  case USB_REQ_SET_FEATURE :
    
    switch (pdev->dev_state) 
c0d040b2:	20fc      	movs	r0, #252	; 0xfc
c0d040b4:	5c20      	ldrb	r0, [r4, r0]
c0d040b6:	2803      	cmp	r0, #3
c0d040b8:	d11c      	bne.n	c0d040f4 <USBD_StdEPReq+0x84>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d040ba:	8868      	ldrh	r0, [r5, #2]
c0d040bc:	2800      	cmp	r0, #0
c0d040be:	d108      	bne.n	c0d040d2 <USBD_StdEPReq+0x62>
      {
        if ((ep_addr != 0x00) && (ep_addr != 0x80)) 
c0d040c0:	2080      	movs	r0, #128	; 0x80
c0d040c2:	4330      	orrs	r0, r6
c0d040c4:	2880      	cmp	r0, #128	; 0x80
c0d040c6:	d004      	beq.n	c0d040d2 <USBD_StdEPReq+0x62>
        { 
          USBD_LL_StallEP(pdev , ep_addr);
c0d040c8:	4620      	mov	r0, r4
c0d040ca:	4631      	mov	r1, r6
c0d040cc:	f7ff fb8c 	bl	c0d037e8 <USBD_LL_StallEP>
          
        }
c0d040d0:	792e      	ldrb	r6, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d040d2:	2e02      	cmp	r6, #2
c0d040d4:	d852      	bhi.n	c0d0417c <USBD_StdEPReq+0x10c>
c0d040d6:	00f0      	lsls	r0, r6, #3
c0d040d8:	e043      	b.n	c0d04162 <USBD_StdEPReq+0xf2>
      break;    
    }
    break;
    
  case USB_REQ_GET_STATUS:                  
    switch (pdev->dev_state) 
c0d040da:	20fc      	movs	r0, #252	; 0xfc
c0d040dc:	5c20      	ldrb	r0, [r4, r0]
c0d040de:	2803      	cmp	r0, #3
c0d040e0:	d018      	beq.n	c0d04114 <USBD_StdEPReq+0xa4>
c0d040e2:	2802      	cmp	r0, #2
c0d040e4:	d111      	bne.n	c0d0410a <USBD_StdEPReq+0x9a>
    {
    case USBD_STATE_ADDRESSED:          
      if ((ep_addr & 0x7F) != 0x00) 
c0d040e6:	0670      	lsls	r0, r6, #25
c0d040e8:	d10a      	bne.n	c0d04100 <USBD_StdEPReq+0x90>
c0d040ea:	e04a      	b.n	c0d04182 <USBD_StdEPReq+0x112>
    }
    break;
    
  case USB_REQ_CLEAR_FEATURE :
    
    switch (pdev->dev_state) 
c0d040ec:	20fc      	movs	r0, #252	; 0xfc
c0d040ee:	5c20      	ldrb	r0, [r4, r0]
c0d040f0:	2803      	cmp	r0, #3
c0d040f2:	d029      	beq.n	c0d04148 <USBD_StdEPReq+0xd8>
c0d040f4:	2802      	cmp	r0, #2
c0d040f6:	d108      	bne.n	c0d0410a <USBD_StdEPReq+0x9a>
c0d040f8:	2080      	movs	r0, #128	; 0x80
c0d040fa:	4330      	orrs	r0, r6
c0d040fc:	2880      	cmp	r0, #128	; 0x80
c0d040fe:	d040      	beq.n	c0d04182 <USBD_StdEPReq+0x112>
c0d04100:	4620      	mov	r0, r4
c0d04102:	4631      	mov	r1, r6
c0d04104:	f7ff fb70 	bl	c0d037e8 <USBD_LL_StallEP>
c0d04108:	e03b      	b.n	c0d04182 <USBD_StdEPReq+0x112>
c0d0410a:	4620      	mov	r0, r4
c0d0410c:	4629      	mov	r1, r5
c0d0410e:	f7ff ff80 	bl	c0d04012 <USBD_CtlError>
c0d04112:	e036      	b.n	c0d04182 <USBD_StdEPReq+0x112>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d04114:	4625      	mov	r5, r4
c0d04116:	3514      	adds	r5, #20
                                         &pdev->ep_out[ep_addr & 0x7F];
c0d04118:	4620      	mov	r0, r4
c0d0411a:	3084      	adds	r0, #132	; 0x84
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d0411c:	2180      	movs	r1, #128	; 0x80
c0d0411e:	420e      	tst	r6, r1
c0d04120:	d100      	bne.n	c0d04124 <USBD_StdEPReq+0xb4>
c0d04122:	4605      	mov	r5, r0
                                         &pdev->ep_out[ep_addr & 0x7F];
      if(USBD_LL_IsStallEP(pdev, ep_addr))
c0d04124:	4620      	mov	r0, r4
c0d04126:	4631      	mov	r1, r6
c0d04128:	f7ff fba8 	bl	c0d0387c <USBD_LL_IsStallEP>
c0d0412c:	2101      	movs	r1, #1
c0d0412e:	2800      	cmp	r0, #0
c0d04130:	d100      	bne.n	c0d04134 <USBD_StdEPReq+0xc4>
c0d04132:	4601      	mov	r1, r0
c0d04134:	207f      	movs	r0, #127	; 0x7f
c0d04136:	4006      	ands	r6, r0
c0d04138:	0130      	lsls	r0, r6, #4
c0d0413a:	5029      	str	r1, [r5, r0]
c0d0413c:	1829      	adds	r1, r5, r0
      else
      {
        pep->status = 0x0000;  
      }
      
      USBD_CtlSendData (pdev,
c0d0413e:	2202      	movs	r2, #2
c0d04140:	4620      	mov	r0, r4
c0d04142:	f000 f9c7 	bl	c0d044d4 <USBD_CtlSendData>
c0d04146:	e01c      	b.n	c0d04182 <USBD_StdEPReq+0x112>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d04148:	8868      	ldrh	r0, [r5, #2]
c0d0414a:	2800      	cmp	r0, #0
c0d0414c:	d119      	bne.n	c0d04182 <USBD_StdEPReq+0x112>
      {
        if ((ep_addr & 0x7F) != 0x00) 
c0d0414e:	0670      	lsls	r0, r6, #25
c0d04150:	d014      	beq.n	c0d0417c <USBD_StdEPReq+0x10c>
        {        
          USBD_LL_ClearStallEP(pdev , ep_addr);
c0d04152:	4620      	mov	r0, r4
c0d04154:	4631      	mov	r1, r6
c0d04156:	f7ff fb6d 	bl	c0d03834 <USBD_LL_ClearStallEP>
          if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d0415a:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d0415c:	2802      	cmp	r0, #2
c0d0415e:	d80d      	bhi.n	c0d0417c <USBD_StdEPReq+0x10c>
c0d04160:	00c0      	lsls	r0, r0, #3
c0d04162:	1820      	adds	r0, r4, r0
c0d04164:	2145      	movs	r1, #69	; 0x45
c0d04166:	0089      	lsls	r1, r1, #2
c0d04168:	5840      	ldr	r0, [r0, r1]
c0d0416a:	2800      	cmp	r0, #0
c0d0416c:	d006      	beq.n	c0d0417c <USBD_StdEPReq+0x10c>
c0d0416e:	6880      	ldr	r0, [r0, #8]
c0d04170:	f7fd ff26 	bl	c0d01fc0 <pic>
c0d04174:	4602      	mov	r2, r0
c0d04176:	4620      	mov	r0, r4
c0d04178:	4629      	mov	r1, r5
c0d0417a:	4790      	blx	r2
c0d0417c:	4620      	mov	r0, r4
c0d0417e:	f000 f9d4 	bl	c0d0452a <USBD_CtlSendStatus>
    
  default:
    break;
  }
  return ret;
}
c0d04182:	2000      	movs	r0, #0
c0d04184:	bd70      	pop	{r4, r5, r6, pc}

c0d04186 <USBD_ParseSetupRequest>:
* @retval None
*/

void USBD_ParseSetupRequest(USBD_SetupReqTypedef *req, uint8_t *pdata)
{
  req->bmRequest     = *(uint8_t *)  (pdata);
c0d04186:	780a      	ldrb	r2, [r1, #0]
c0d04188:	7002      	strb	r2, [r0, #0]
  req->bRequest      = *(uint8_t *)  (pdata +  1);
c0d0418a:	784a      	ldrb	r2, [r1, #1]
c0d0418c:	7042      	strb	r2, [r0, #1]
  req->wValue        = SWAPBYTE      (pdata +  2);
c0d0418e:	788a      	ldrb	r2, [r1, #2]
c0d04190:	78cb      	ldrb	r3, [r1, #3]
c0d04192:	021b      	lsls	r3, r3, #8
c0d04194:	4313      	orrs	r3, r2
c0d04196:	8043      	strh	r3, [r0, #2]
  req->wIndex        = SWAPBYTE      (pdata +  4);
c0d04198:	790a      	ldrb	r2, [r1, #4]
c0d0419a:	794b      	ldrb	r3, [r1, #5]
c0d0419c:	021b      	lsls	r3, r3, #8
c0d0419e:	4313      	orrs	r3, r2
c0d041a0:	8083      	strh	r3, [r0, #4]
  req->wLength       = SWAPBYTE      (pdata +  6);
c0d041a2:	798a      	ldrb	r2, [r1, #6]
c0d041a4:	79c9      	ldrb	r1, [r1, #7]
c0d041a6:	0209      	lsls	r1, r1, #8
c0d041a8:	4311      	orrs	r1, r2
c0d041aa:	80c1      	strh	r1, [r0, #6]

}
c0d041ac:	4770      	bx	lr

c0d041ae <USBD_HID_Setup>:
  * @param  req: usb requests
  * @retval status
  */
uint8_t  USBD_HID_Setup (USBD_HandleTypeDef *pdev, 
                                USBD_SetupReqTypedef *req)
{
c0d041ae:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d041b0:	b083      	sub	sp, #12
c0d041b2:	460d      	mov	r5, r1
c0d041b4:	4604      	mov	r4, r0
c0d041b6:	a802      	add	r0, sp, #8
c0d041b8:	2700      	movs	r7, #0
  uint16_t len = 0;
c0d041ba:	8007      	strh	r7, [r0, #0]
c0d041bc:	a801      	add	r0, sp, #4
  uint8_t  *pbuf = NULL;

  uint8_t val = 0;
c0d041be:	7007      	strb	r7, [r0, #0]

  switch (req->bmRequest & USB_REQ_TYPE_MASK)
c0d041c0:	7829      	ldrb	r1, [r5, #0]
c0d041c2:	2060      	movs	r0, #96	; 0x60
c0d041c4:	4008      	ands	r0, r1
c0d041c6:	2800      	cmp	r0, #0
c0d041c8:	d010      	beq.n	c0d041ec <USBD_HID_Setup+0x3e>
c0d041ca:	2820      	cmp	r0, #32
c0d041cc:	d138      	bne.n	c0d04240 <USBD_HID_Setup+0x92>
c0d041ce:	7868      	ldrb	r0, [r5, #1]
  {
  case USB_REQ_TYPE_CLASS :  
    switch (req->bRequest)
c0d041d0:	4601      	mov	r1, r0
c0d041d2:	390a      	subs	r1, #10
c0d041d4:	2902      	cmp	r1, #2
c0d041d6:	d333      	bcc.n	c0d04240 <USBD_HID_Setup+0x92>
c0d041d8:	2802      	cmp	r0, #2
c0d041da:	d01c      	beq.n	c0d04216 <USBD_HID_Setup+0x68>
c0d041dc:	2803      	cmp	r0, #3
c0d041de:	d01a      	beq.n	c0d04216 <USBD_HID_Setup+0x68>
                        (uint8_t *)&val,
                        1);      
      break;      
      
    default:
      USBD_CtlError (pdev, req);
c0d041e0:	4620      	mov	r0, r4
c0d041e2:	4629      	mov	r1, r5
c0d041e4:	f7ff ff15 	bl	c0d04012 <USBD_CtlError>
c0d041e8:	2702      	movs	r7, #2
c0d041ea:	e029      	b.n	c0d04240 <USBD_HID_Setup+0x92>
      return USBD_FAIL; 
    }
    break;
    
  case USB_REQ_TYPE_STANDARD:
    switch (req->bRequest)
c0d041ec:	7868      	ldrb	r0, [r5, #1]
c0d041ee:	280b      	cmp	r0, #11
c0d041f0:	d014      	beq.n	c0d0421c <USBD_HID_Setup+0x6e>
c0d041f2:	280a      	cmp	r0, #10
c0d041f4:	d00f      	beq.n	c0d04216 <USBD_HID_Setup+0x68>
c0d041f6:	2806      	cmp	r0, #6
c0d041f8:	d122      	bne.n	c0d04240 <USBD_HID_Setup+0x92>
    {
    case USB_REQ_GET_DESCRIPTOR: 
      // 0x22
      if( req->wValue >> 8 == HID_REPORT_DESC)
c0d041fa:	8868      	ldrh	r0, [r5, #2]
c0d041fc:	0a00      	lsrs	r0, r0, #8
c0d041fe:	2700      	movs	r7, #0
c0d04200:	2821      	cmp	r0, #33	; 0x21
c0d04202:	d00f      	beq.n	c0d04224 <USBD_HID_Setup+0x76>
c0d04204:	2822      	cmp	r0, #34	; 0x22
      
      //USBD_CtlReceiveStatus(pdev);
      
      USBD_CtlSendData (pdev, 
                        pbuf,
                        len);
c0d04206:	463a      	mov	r2, r7
c0d04208:	4639      	mov	r1, r7
c0d0420a:	d116      	bne.n	c0d0423a <USBD_HID_Setup+0x8c>
c0d0420c:	ae02      	add	r6, sp, #8
    {
    case USB_REQ_GET_DESCRIPTOR: 
      // 0x22
      if( req->wValue >> 8 == HID_REPORT_DESC)
      {
        pbuf =  USBD_HID_GetReportDescriptor_impl(&len);
c0d0420e:	4630      	mov	r0, r6
c0d04210:	f000 f858 	bl	c0d042c4 <USBD_HID_GetReportDescriptor_impl>
c0d04214:	e00a      	b.n	c0d0422c <USBD_HID_Setup+0x7e>
c0d04216:	a901      	add	r1, sp, #4
c0d04218:	2201      	movs	r2, #1
c0d0421a:	e00e      	b.n	c0d0423a <USBD_HID_Setup+0x8c>
                        len);
      break;

    case USB_REQ_SET_INTERFACE :
      //hhid->AltSetting = (uint8_t)(req->wValue);
      USBD_CtlSendStatus(pdev);
c0d0421c:	4620      	mov	r0, r4
c0d0421e:	f000 f984 	bl	c0d0452a <USBD_CtlSendStatus>
c0d04222:	e00d      	b.n	c0d04240 <USBD_HID_Setup+0x92>
c0d04224:	ae02      	add	r6, sp, #8
        len = MIN(len , req->wLength);
      }
      // 0x21
      else if( req->wValue >> 8 == HID_DESCRIPTOR_TYPE)
      {
        pbuf = USBD_HID_GetHidDescriptor_impl(&len);
c0d04226:	4630      	mov	r0, r6
c0d04228:	f000 f832 	bl	c0d04290 <USBD_HID_GetHidDescriptor_impl>
c0d0422c:	4601      	mov	r1, r0
c0d0422e:	8832      	ldrh	r2, [r6, #0]
c0d04230:	88e8      	ldrh	r0, [r5, #6]
c0d04232:	4282      	cmp	r2, r0
c0d04234:	d300      	bcc.n	c0d04238 <USBD_HID_Setup+0x8a>
c0d04236:	4602      	mov	r2, r0
c0d04238:	8032      	strh	r2, [r6, #0]
c0d0423a:	4620      	mov	r0, r4
c0d0423c:	f000 f94a 	bl	c0d044d4 <USBD_CtlSendData>
      
    }
  }

  return USBD_OK;
}
c0d04240:	b2f8      	uxtb	r0, r7
c0d04242:	b003      	add	sp, #12
c0d04244:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d04246 <USBD_HID_Init>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_Init (USBD_HandleTypeDef *pdev, 
                               uint8_t cfgidx)
{
c0d04246:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04248:	b081      	sub	sp, #4
c0d0424a:	4604      	mov	r4, r0
  UNUSED(cfgidx);

  /* Open EP IN */
  USBD_LL_OpenEP(pdev,
c0d0424c:	2182      	movs	r1, #130	; 0x82
c0d0424e:	2603      	movs	r6, #3
c0d04250:	2540      	movs	r5, #64	; 0x40
c0d04252:	4632      	mov	r2, r6
c0d04254:	462b      	mov	r3, r5
c0d04256:	f7ff fa8b 	bl	c0d03770 <USBD_LL_OpenEP>
c0d0425a:	2702      	movs	r7, #2
                 HID_EPIN_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPIN_SIZE);
  
  /* Open EP OUT */
  USBD_LL_OpenEP(pdev,
c0d0425c:	4620      	mov	r0, r4
c0d0425e:	4639      	mov	r1, r7
c0d04260:	4632      	mov	r2, r6
c0d04262:	462b      	mov	r3, r5
c0d04264:	f7ff fa84 	bl	c0d03770 <USBD_LL_OpenEP>
                 HID_EPOUT_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPOUT_SIZE);

        /* Prepare Out endpoint to receive 1st packet */ 
  USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR, HID_EPOUT_SIZE);
c0d04268:	4620      	mov	r0, r4
c0d0426a:	4639      	mov	r1, r7
c0d0426c:	462a      	mov	r2, r5
c0d0426e:	f7ff fb42 	bl	c0d038f6 <USBD_LL_PrepareReceive>
  USBD_LL_Transmit (pdev, 
                    HID_EPIN_ADDR,                                      
                    NULL,
                    0);
  */
  return USBD_OK;
c0d04272:	2000      	movs	r0, #0
c0d04274:	b001      	add	sp, #4
c0d04276:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d04278 <USBD_HID_DeInit>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_DeInit (USBD_HandleTypeDef *pdev, 
                                 uint8_t cfgidx)
{
c0d04278:	b510      	push	{r4, lr}
c0d0427a:	4604      	mov	r4, r0
  UNUSED(cfgidx);
  /* Close HID EP IN */
  USBD_LL_CloseEP(pdev,
c0d0427c:	2182      	movs	r1, #130	; 0x82
c0d0427e:	f7ff fa9d 	bl	c0d037bc <USBD_LL_CloseEP>
                  HID_EPIN_ADDR);
  
  /* Close HID EP OUT */
  USBD_LL_CloseEP(pdev,
c0d04282:	2102      	movs	r1, #2
c0d04284:	4620      	mov	r0, r4
c0d04286:	f7ff fa99 	bl	c0d037bc <USBD_LL_CloseEP>
                  HID_EPOUT_ADDR);
  
  return USBD_OK;
c0d0428a:	2000      	movs	r0, #0
c0d0428c:	bd10      	pop	{r4, pc}
	...

c0d04290 <USBD_HID_GetHidDescriptor_impl>:
  *length = sizeof (USBD_CfgDesc);
  return (uint8_t*)USBD_CfgDesc;
}

uint8_t* USBD_HID_GetHidDescriptor_impl(uint16_t* len) {
  switch (USBD_Device.request.wIndex&0xFF) {
c0d04290:	2143      	movs	r1, #67	; 0x43
c0d04292:	0089      	lsls	r1, r1, #2
c0d04294:	4a08      	ldr	r2, [pc, #32]	; (c0d042b8 <USBD_HID_GetHidDescriptor_impl+0x28>)
c0d04296:	5c51      	ldrb	r1, [r2, r1]
c0d04298:	2209      	movs	r2, #9
c0d0429a:	2900      	cmp	r1, #0
c0d0429c:	d004      	beq.n	c0d042a8 <USBD_HID_GetHidDescriptor_impl+0x18>
c0d0429e:	2901      	cmp	r1, #1
c0d042a0:	d105      	bne.n	c0d042ae <USBD_HID_GetHidDescriptor_impl+0x1e>
c0d042a2:	4907      	ldr	r1, [pc, #28]	; (c0d042c0 <USBD_HID_GetHidDescriptor_impl+0x30>)
c0d042a4:	4479      	add	r1, pc
c0d042a6:	e004      	b.n	c0d042b2 <USBD_HID_GetHidDescriptor_impl+0x22>
c0d042a8:	4904      	ldr	r1, [pc, #16]	; (c0d042bc <USBD_HID_GetHidDescriptor_impl+0x2c>)
c0d042aa:	4479      	add	r1, pc
c0d042ac:	e001      	b.n	c0d042b2 <USBD_HID_GetHidDescriptor_impl+0x22>
c0d042ae:	2200      	movs	r2, #0
c0d042b0:	4611      	mov	r1, r2
c0d042b2:	8002      	strh	r2, [r0, #0]
      *len = sizeof(USBD_HID_Desc);
      return (uint8_t*)USBD_HID_Desc; 
  }
  *len = 0;
  return 0;
}
c0d042b4:	4608      	mov	r0, r1
c0d042b6:	4770      	bx	lr
c0d042b8:	200020b8 	.word	0x200020b8
c0d042bc:	0000165a 	.word	0x0000165a
c0d042c0:	00001654 	.word	0x00001654

c0d042c4 <USBD_HID_GetReportDescriptor_impl>:

uint8_t* USBD_HID_GetReportDescriptor_impl(uint16_t* len) {
c0d042c4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d042c6:	b081      	sub	sp, #4
c0d042c8:	4602      	mov	r2, r0
  switch (USBD_Device.request.wIndex&0xFF) {
c0d042ca:	2043      	movs	r0, #67	; 0x43
c0d042cc:	0080      	lsls	r0, r0, #2
c0d042ce:	4914      	ldr	r1, [pc, #80]	; (c0d04320 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d042d0:	5c08      	ldrb	r0, [r1, r0]
c0d042d2:	2422      	movs	r4, #34	; 0x22
c0d042d4:	2800      	cmp	r0, #0
c0d042d6:	d01a      	beq.n	c0d0430e <USBD_HID_GetReportDescriptor_impl+0x4a>
c0d042d8:	2801      	cmp	r0, #1
c0d042da:	d11b      	bne.n	c0d04314 <USBD_HID_GetReportDescriptor_impl+0x50>
#ifdef HAVE_IO_U2F
  case U2F_INTF:

    // very dirty work due to lack of callback when USB_HID_Init is called
    USBD_LL_OpenEP(&USBD_Device,
c0d042dc:	4810      	ldr	r0, [pc, #64]	; (c0d04320 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d042de:	2181      	movs	r1, #129	; 0x81
c0d042e0:	2703      	movs	r7, #3
c0d042e2:	2640      	movs	r6, #64	; 0x40
c0d042e4:	9200      	str	r2, [sp, #0]
c0d042e6:	463a      	mov	r2, r7
c0d042e8:	4633      	mov	r3, r6
c0d042ea:	f7ff fa41 	bl	c0d03770 <USBD_LL_OpenEP>
c0d042ee:	2501      	movs	r5, #1
                   U2F_EPIN_ADDR,
                   USBD_EP_TYPE_INTR,
                   U2F_EPIN_SIZE);
    
    USBD_LL_OpenEP(&USBD_Device,
c0d042f0:	480b      	ldr	r0, [pc, #44]	; (c0d04320 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d042f2:	4629      	mov	r1, r5
c0d042f4:	463a      	mov	r2, r7
c0d042f6:	4633      	mov	r3, r6
c0d042f8:	f7ff fa3a 	bl	c0d03770 <USBD_LL_OpenEP>
                   U2F_EPOUT_ADDR,
                   USBD_EP_TYPE_INTR,
                   U2F_EPOUT_SIZE);

    /* Prepare Out endpoint to receive 1st packet */ 
    USBD_LL_PrepareReceive(&USBD_Device, U2F_EPOUT_ADDR, U2F_EPOUT_SIZE);
c0d042fc:	4808      	ldr	r0, [pc, #32]	; (c0d04320 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d042fe:	4629      	mov	r1, r5
c0d04300:	4632      	mov	r2, r6
c0d04302:	f7ff faf8 	bl	c0d038f6 <USBD_LL_PrepareReceive>
c0d04306:	9a00      	ldr	r2, [sp, #0]
c0d04308:	4807      	ldr	r0, [pc, #28]	; (c0d04328 <USBD_HID_GetReportDescriptor_impl+0x64>)
c0d0430a:	4478      	add	r0, pc
c0d0430c:	e004      	b.n	c0d04318 <USBD_HID_GetReportDescriptor_impl+0x54>
c0d0430e:	4805      	ldr	r0, [pc, #20]	; (c0d04324 <USBD_HID_GetReportDescriptor_impl+0x60>)
c0d04310:	4478      	add	r0, pc
c0d04312:	e001      	b.n	c0d04318 <USBD_HID_GetReportDescriptor_impl+0x54>
c0d04314:	2400      	movs	r4, #0
c0d04316:	4620      	mov	r0, r4
c0d04318:	8014      	strh	r4, [r2, #0]
    *len = sizeof(HID_ReportDesc);
    return (uint8_t*)HID_ReportDesc;
  }
  *len = 0;
  return 0;
}
c0d0431a:	b001      	add	sp, #4
c0d0431c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0431e:	46c0      	nop			; (mov r8, r8)
c0d04320:	200020b8 	.word	0x200020b8
c0d04324:	0000161f 	.word	0x0000161f
c0d04328:	00001603 	.word	0x00001603

c0d0432c <USBD_U2F_DataIn_impl>:
extern volatile unsigned short G_io_apdu_length;

#ifdef HAVE_IO_U2F
uint8_t  USBD_U2F_DataIn_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum)
{
c0d0432c:	b580      	push	{r7, lr}
  UNUSED(pdev);
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d0432e:	2901      	cmp	r1, #1
c0d04330:	d103      	bne.n	c0d0433a <USBD_U2F_DataIn_impl+0xe>
  // FIDO endpoint
  case (U2F_EPIN_ADDR&0x7F):
    // advance the u2f sending machine state
    u2f_transport_sent(&G_io_u2f, U2F_MEDIA_USB);
c0d04332:	4803      	ldr	r0, [pc, #12]	; (c0d04340 <USBD_U2F_DataIn_impl+0x14>)
c0d04334:	2101      	movs	r1, #1
c0d04336:	f7fe f925 	bl	c0d02584 <u2f_transport_sent>
    break;
  } 
  return USBD_OK;
c0d0433a:	2000      	movs	r0, #0
c0d0433c:	bd80      	pop	{r7, pc}
c0d0433e:	46c0      	nop			; (mov r8, r8)
c0d04340:	20001a78 	.word	0x20001a78

c0d04344 <USBD_U2F_DataOut_impl>:
}

uint8_t  USBD_U2F_DataOut_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d04344:	b5b0      	push	{r4, r5, r7, lr}
c0d04346:	4614      	mov	r4, r2
  switch (epnum) {
c0d04348:	2901      	cmp	r1, #1
c0d0434a:	d10d      	bne.n	c0d04368 <USBD_U2F_DataOut_impl+0x24>
c0d0434c:	2501      	movs	r5, #1
  // FIDO endpoint
  case (U2F_EPOUT_ADDR&0x7F):
      USBD_LL_PrepareReceive(pdev, U2F_EPOUT_ADDR , U2F_EPOUT_SIZE);
c0d0434e:	2240      	movs	r2, #64	; 0x40
c0d04350:	4629      	mov	r1, r5
c0d04352:	f7ff fad0 	bl	c0d038f6 <USBD_LL_PrepareReceive>
      u2f_transport_received(&G_io_u2f, buffer, io_seproxyhal_get_ep_rx_size(U2F_EPOUT_ADDR), U2F_MEDIA_USB);
c0d04356:	4628      	mov	r0, r5
c0d04358:	f7fd f84a 	bl	c0d013f0 <io_seproxyhal_get_ep_rx_size>
c0d0435c:	4602      	mov	r2, r0
c0d0435e:	4803      	ldr	r0, [pc, #12]	; (c0d0436c <USBD_U2F_DataOut_impl+0x28>)
c0d04360:	4621      	mov	r1, r4
c0d04362:	462b      	mov	r3, r5
c0d04364:	f7fe f970 	bl	c0d02648 <u2f_transport_received>
    break;
  }

  return USBD_OK;
c0d04368:	2000      	movs	r0, #0
c0d0436a:	bdb0      	pop	{r4, r5, r7, pc}
c0d0436c:	20001a78 	.word	0x20001a78

c0d04370 <USBD_HID_DataOut_impl>:
}
#endif // HAVE_IO_U2F

uint8_t  USBD_HID_DataOut_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d04370:	b5b0      	push	{r4, r5, r7, lr}
c0d04372:	4614      	mov	r4, r2
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d04374:	2902      	cmp	r1, #2
c0d04376:	d11b      	bne.n	c0d043b0 <USBD_HID_DataOut_impl+0x40>

  // HID gen endpoint
  case (HID_EPOUT_ADDR&0x7F):
    // prepare receiving the next chunk (masked time)
    USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR , HID_EPOUT_SIZE);
c0d04378:	2102      	movs	r1, #2
c0d0437a:	2240      	movs	r2, #64	; 0x40
c0d0437c:	f7ff fabb 	bl	c0d038f6 <USBD_LL_PrepareReceive>

    // avoid troubles when an apdu has not been replied yet
    if (G_io_apdu_media == IO_APDU_MEDIA_NONE) {      
c0d04380:	4d0c      	ldr	r5, [pc, #48]	; (c0d043b4 <USBD_HID_DataOut_impl+0x44>)
c0d04382:	7828      	ldrb	r0, [r5, #0]
c0d04384:	2800      	cmp	r0, #0
c0d04386:	d113      	bne.n	c0d043b0 <USBD_HID_DataOut_impl+0x40>
      // add to the hid transport
      switch(io_usb_hid_receive(io_usb_send_apdu_data, buffer, io_seproxyhal_get_ep_rx_size(HID_EPOUT_ADDR))) {
c0d04388:	2002      	movs	r0, #2
c0d0438a:	f7fd f831 	bl	c0d013f0 <io_seproxyhal_get_ep_rx_size>
c0d0438e:	4602      	mov	r2, r0
c0d04390:	480c      	ldr	r0, [pc, #48]	; (c0d043c4 <USBD_HID_DataOut_impl+0x54>)
c0d04392:	4478      	add	r0, pc
c0d04394:	4621      	mov	r1, r4
c0d04396:	f7fc fe77 	bl	c0d01088 <io_usb_hid_receive>
c0d0439a:	2802      	cmp	r0, #2
c0d0439c:	d108      	bne.n	c0d043b0 <USBD_HID_DataOut_impl+0x40>
        default:
          break;

        case IO_USB_APDU_RECEIVED:
          G_io_apdu_media = IO_APDU_MEDIA_USB_HID; // for application code
c0d0439e:	2001      	movs	r0, #1
c0d043a0:	7028      	strb	r0, [r5, #0]
          G_io_apdu_state = APDU_USB_HID; // for next call to io_exchange
c0d043a2:	4805      	ldr	r0, [pc, #20]	; (c0d043b8 <USBD_HID_DataOut_impl+0x48>)
c0d043a4:	2107      	movs	r1, #7
c0d043a6:	7001      	strb	r1, [r0, #0]
          G_io_apdu_length = G_io_usb_hid_total_length;
c0d043a8:	4804      	ldr	r0, [pc, #16]	; (c0d043bc <USBD_HID_DataOut_impl+0x4c>)
c0d043aa:	6800      	ldr	r0, [r0, #0]
c0d043ac:	4904      	ldr	r1, [pc, #16]	; (c0d043c0 <USBD_HID_DataOut_impl+0x50>)
c0d043ae:	8008      	strh	r0, [r1, #0]
      }
    }
    break;
  }

  return USBD_OK;
c0d043b0:	2000      	movs	r0, #0
c0d043b2:	bdb0      	pop	{r4, r5, r7, pc}
c0d043b4:	20001a5c 	.word	0x20001a5c
c0d043b8:	20001a64 	.word	0x20001a64
c0d043bc:	200018f0 	.word	0x200018f0
c0d043c0:	20001a66 	.word	0x20001a66
c0d043c4:	ffffd1d3 	.word	0xffffd1d3

c0d043c8 <USBD_DeviceDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_DeviceDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_DeviceDesc);
c0d043c8:	2012      	movs	r0, #18
c0d043ca:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_DeviceDesc;
c0d043cc:	4801      	ldr	r0, [pc, #4]	; (c0d043d4 <USBD_DeviceDescriptor+0xc>)
c0d043ce:	4478      	add	r0, pc
c0d043d0:	4770      	bx	lr
c0d043d2:	46c0      	nop			; (mov r8, r8)
c0d043d4:	00001616 	.word	0x00001616

c0d043d8 <USBD_LangIDStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_LangIDStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_LangIDDesc);  
c0d043d8:	2004      	movs	r0, #4
c0d043da:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_LangIDDesc;
c0d043dc:	4801      	ldr	r0, [pc, #4]	; (c0d043e4 <USBD_LangIDStrDescriptor+0xc>)
c0d043de:	4478      	add	r0, pc
c0d043e0:	4770      	bx	lr
c0d043e2:	46c0      	nop			; (mov r8, r8)
c0d043e4:	00001618 	.word	0x00001618

c0d043e8 <USBD_ManufacturerStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ManufacturerStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_MANUFACTURER_STRING);
c0d043e8:	200e      	movs	r0, #14
c0d043ea:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_MANUFACTURER_STRING;
c0d043ec:	4801      	ldr	r0, [pc, #4]	; (c0d043f4 <USBD_ManufacturerStrDescriptor+0xc>)
c0d043ee:	4478      	add	r0, pc
c0d043f0:	4770      	bx	lr
c0d043f2:	46c0      	nop			; (mov r8, r8)
c0d043f4:	0000160c 	.word	0x0000160c

c0d043f8 <USBD_ProductStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ProductStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_PRODUCT_FS_STRING);
c0d043f8:	200e      	movs	r0, #14
c0d043fa:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_PRODUCT_FS_STRING;
c0d043fc:	4801      	ldr	r0, [pc, #4]	; (c0d04404 <USBD_ProductStrDescriptor+0xc>)
c0d043fe:	4478      	add	r0, pc
c0d04400:	4770      	bx	lr
c0d04402:	46c0      	nop			; (mov r8, r8)
c0d04404:	0000160a 	.word	0x0000160a

c0d04408 <USBD_SerialStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_SerialStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USB_SERIAL_STRING);
c0d04408:	200a      	movs	r0, #10
c0d0440a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USB_SERIAL_STRING;
c0d0440c:	4801      	ldr	r0, [pc, #4]	; (c0d04414 <USBD_SerialStrDescriptor+0xc>)
c0d0440e:	4478      	add	r0, pc
c0d04410:	4770      	bx	lr
c0d04412:	46c0      	nop			; (mov r8, r8)
c0d04414:	00001608 	.word	0x00001608

c0d04418 <USBD_ConfigStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ConfigStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_CONFIGURATION_FS_STRING);
c0d04418:	200e      	movs	r0, #14
c0d0441a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_CONFIGURATION_FS_STRING;
c0d0441c:	4801      	ldr	r0, [pc, #4]	; (c0d04424 <USBD_ConfigStrDescriptor+0xc>)
c0d0441e:	4478      	add	r0, pc
c0d04420:	4770      	bx	lr
c0d04422:	46c0      	nop			; (mov r8, r8)
c0d04424:	000015ea 	.word	0x000015ea

c0d04428 <USBD_InterfaceStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_InterfaceStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_INTERFACE_FS_STRING);
c0d04428:	200e      	movs	r0, #14
c0d0442a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_INTERFACE_FS_STRING;
c0d0442c:	4801      	ldr	r0, [pc, #4]	; (c0d04434 <USBD_InterfaceStrDescriptor+0xc>)
c0d0442e:	4478      	add	r0, pc
c0d04430:	4770      	bx	lr
c0d04432:	46c0      	nop			; (mov r8, r8)
c0d04434:	000015da 	.word	0x000015da

c0d04438 <USB_power>:
  // nothing to do ?
  return 0;
}
#endif // HAVE_USB_CLASS_CCID

void USB_power(unsigned char enabled) {
c0d04438:	b570      	push	{r4, r5, r6, lr}
c0d0443a:	4604      	mov	r4, r0
c0d0443c:	204d      	movs	r0, #77	; 0x4d
c0d0443e:	0085      	lsls	r5, r0, #2
  os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d04440:	4816      	ldr	r0, [pc, #88]	; (c0d0449c <USB_power+0x64>)
c0d04442:	2100      	movs	r1, #0
c0d04444:	462a      	mov	r2, r5
c0d04446:	f7fc fec7 	bl	c0d011d8 <os_memset>

  if (enabled) {
c0d0444a:	2c00      	cmp	r4, #0
c0d0444c:	d022      	beq.n	c0d04494 <USB_power+0x5c>
    os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d0444e:	4c13      	ldr	r4, [pc, #76]	; (c0d0449c <USB_power+0x64>)
c0d04450:	2600      	movs	r6, #0
c0d04452:	4620      	mov	r0, r4
c0d04454:	4631      	mov	r1, r6
c0d04456:	462a      	mov	r2, r5
c0d04458:	f7fc febe 	bl	c0d011d8 <os_memset>
    /* Init Device Library */
    USBD_Init(&USBD_Device, (USBD_DescriptorsTypeDef*)&HID_Desc, 0);
c0d0445c:	4912      	ldr	r1, [pc, #72]	; (c0d044a8 <USB_power+0x70>)
c0d0445e:	4479      	add	r1, pc
c0d04460:	4620      	mov	r0, r4
c0d04462:	4632      	mov	r2, r6
c0d04464:	f7ff fa5a 	bl	c0d0391c <USBD_Init>
    
    /* Register the HID class */
    USBD_RegisterClassForInterface(HID_INTF,  &USBD_Device, (USBD_ClassTypeDef*)&USBD_HID);
c0d04468:	4a10      	ldr	r2, [pc, #64]	; (c0d044ac <USB_power+0x74>)
c0d0446a:	447a      	add	r2, pc
c0d0446c:	4630      	mov	r0, r6
c0d0446e:	4621      	mov	r1, r4
c0d04470:	f7ff fa8e 	bl	c0d03990 <USBD_RegisterClassForInterface>
#ifdef HAVE_IO_U2F
    USBD_RegisterClassForInterface(U2F_INTF,  &USBD_Device, (USBD_ClassTypeDef*)&USBD_U2F);
c0d04474:	2001      	movs	r0, #1
c0d04476:	4a0e      	ldr	r2, [pc, #56]	; (c0d044b0 <USB_power+0x78>)
c0d04478:	447a      	add	r2, pc
c0d0447a:	4621      	mov	r1, r4
c0d0447c:	f7ff fa88 	bl	c0d03990 <USBD_RegisterClassForInterface>
    // initialize the U2F tunnel transport
    u2f_transport_init(&G_io_u2f, G_io_apdu_buffer, IO_APDU_BUFFER_SIZE);
c0d04480:	22ff      	movs	r2, #255	; 0xff
c0d04482:	3252      	adds	r2, #82	; 0x52
c0d04484:	4806      	ldr	r0, [pc, #24]	; (c0d044a0 <USB_power+0x68>)
c0d04486:	4907      	ldr	r1, [pc, #28]	; (c0d044a4 <USB_power+0x6c>)
c0d04488:	f7fe f872 	bl	c0d02570 <u2f_transport_init>
    USBD_RegisterClassForInterface(CCID_INTF, &USBD_Device, (USBD_ClassTypeDef*)&USBD_CCID);
#endif // HAVE_USB_CLASS_CCID


    /* Start Device Process */
    USBD_Start(&USBD_Device);
c0d0448c:	4620      	mov	r0, r4
c0d0448e:	f7ff fa8c 	bl	c0d039aa <USBD_Start>
  }
  else {
    USBD_DeInit(&USBD_Device);
  }
}
c0d04492:	bd70      	pop	{r4, r5, r6, pc}

    /* Start Device Process */
    USBD_Start(&USBD_Device);
  }
  else {
    USBD_DeInit(&USBD_Device);
c0d04494:	4801      	ldr	r0, [pc, #4]	; (c0d0449c <USB_power+0x64>)
c0d04496:	f7ff fa5c 	bl	c0d03952 <USBD_DeInit>
  }
}
c0d0449a:	bd70      	pop	{r4, r5, r6, pc}
c0d0449c:	200020b8 	.word	0x200020b8
c0d044a0:	20001a78 	.word	0x20001a78
c0d044a4:	200018f8 	.word	0x200018f8
c0d044a8:	000014f6 	.word	0x000014f6
c0d044ac:	0000150a 	.word	0x0000150a
c0d044b0:	00001534 	.word	0x00001534

c0d044b4 <USBD_GetCfgDesc_impl>:
  * @param  length : pointer data length
  * @retval pointer to descriptor buffer
  */
static uint8_t  *USBD_GetCfgDesc_impl (uint16_t *length)
{
  *length = sizeof (USBD_CfgDesc);
c0d044b4:	2149      	movs	r1, #73	; 0x49
c0d044b6:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_CfgDesc;
c0d044b8:	4801      	ldr	r0, [pc, #4]	; (c0d044c0 <USBD_GetCfgDesc_impl+0xc>)
c0d044ba:	4478      	add	r0, pc
c0d044bc:	4770      	bx	lr
c0d044be:	46c0      	nop			; (mov r8, r8)
c0d044c0:	00001566 	.word	0x00001566

c0d044c4 <USBD_GetDeviceQualifierDesc_impl>:
* @param  length : pointer data length
* @retval pointer to descriptor buffer
*/
static uint8_t  *USBD_GetDeviceQualifierDesc_impl (uint16_t *length)
{
  *length = sizeof (USBD_DeviceQualifierDesc);
c0d044c4:	210a      	movs	r1, #10
c0d044c6:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_DeviceQualifierDesc;
c0d044c8:	4801      	ldr	r0, [pc, #4]	; (c0d044d0 <USBD_GetDeviceQualifierDesc_impl+0xc>)
c0d044ca:	4478      	add	r0, pc
c0d044cc:	4770      	bx	lr
c0d044ce:	46c0      	nop			; (mov r8, r8)
c0d044d0:	000015a2 	.word	0x000015a2

c0d044d4 <USBD_CtlSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendData (USBD_HandleTypeDef  *pdev, 
                               uint8_t *pbuf,
                               uint16_t len)
{
c0d044d4:	b5b0      	push	{r4, r5, r7, lr}
c0d044d6:	460c      	mov	r4, r1
  /* Set EP0 State */
  pdev->ep0_state          = USBD_EP0_DATA_IN;                                      
c0d044d8:	21f4      	movs	r1, #244	; 0xf4
c0d044da:	2302      	movs	r3, #2
c0d044dc:	5043      	str	r3, [r0, r1]
  pdev->ep_in[0].total_length = len;
c0d044de:	6182      	str	r2, [r0, #24]
  pdev->ep_in[0].rem_length   = len;
c0d044e0:	61c2      	str	r2, [r0, #28]
  // store the continuation data if needed
  pdev->pData = pbuf;
c0d044e2:	2113      	movs	r1, #19
c0d044e4:	0109      	lsls	r1, r1, #4
c0d044e6:	5044      	str	r4, [r0, r1]
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));  
c0d044e8:	6a01      	ldr	r1, [r0, #32]
c0d044ea:	428a      	cmp	r2, r1
c0d044ec:	d300      	bcc.n	c0d044f0 <USBD_CtlSendData+0x1c>
c0d044ee:	460a      	mov	r2, r1
c0d044f0:	b293      	uxth	r3, r2
c0d044f2:	2500      	movs	r5, #0
c0d044f4:	4629      	mov	r1, r5
c0d044f6:	4622      	mov	r2, r4
c0d044f8:	f7ff f9e4 	bl	c0d038c4 <USBD_LL_Transmit>
  
  return USBD_OK;
c0d044fc:	4628      	mov	r0, r5
c0d044fe:	bdb0      	pop	{r4, r5, r7, pc}

c0d04500 <USBD_CtlContinueSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueSendData (USBD_HandleTypeDef  *pdev, 
                                       uint8_t *pbuf,
                                       uint16_t len)
{
c0d04500:	b5b0      	push	{r4, r5, r7, lr}
c0d04502:	460c      	mov	r4, r1
 /* Start the next transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));   
c0d04504:	6a01      	ldr	r1, [r0, #32]
c0d04506:	428a      	cmp	r2, r1
c0d04508:	d300      	bcc.n	c0d0450c <USBD_CtlContinueSendData+0xc>
c0d0450a:	460a      	mov	r2, r1
c0d0450c:	b293      	uxth	r3, r2
c0d0450e:	2500      	movs	r5, #0
c0d04510:	4629      	mov	r1, r5
c0d04512:	4622      	mov	r2, r4
c0d04514:	f7ff f9d6 	bl	c0d038c4 <USBD_LL_Transmit>
  return USBD_OK;
c0d04518:	4628      	mov	r0, r5
c0d0451a:	bdb0      	pop	{r4, r5, r7, pc}

c0d0451c <USBD_CtlContinueRx>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueRx (USBD_HandleTypeDef  *pdev, 
                                          uint8_t *pbuf,                                          
                                          uint16_t len)
{
c0d0451c:	b510      	push	{r4, lr}
c0d0451e:	2400      	movs	r4, #0
  UNUSED(pbuf);
  USBD_LL_PrepareReceive (pdev,
c0d04520:	4621      	mov	r1, r4
c0d04522:	f7ff f9e8 	bl	c0d038f6 <USBD_LL_PrepareReceive>
                          0,                                            
                          len);
  return USBD_OK;
c0d04526:	4620      	mov	r0, r4
c0d04528:	bd10      	pop	{r4, pc}

c0d0452a <USBD_CtlSendStatus>:
*         send zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendStatus (USBD_HandleTypeDef  *pdev)
{
c0d0452a:	b510      	push	{r4, lr}

  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_IN;
c0d0452c:	21f4      	movs	r1, #244	; 0xf4
c0d0452e:	2204      	movs	r2, #4
c0d04530:	5042      	str	r2, [r0, r1]
c0d04532:	2400      	movs	r4, #0
  
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, NULL, 0);   
c0d04534:	4621      	mov	r1, r4
c0d04536:	4622      	mov	r2, r4
c0d04538:	4623      	mov	r3, r4
c0d0453a:	f7ff f9c3 	bl	c0d038c4 <USBD_LL_Transmit>
  
  return USBD_OK;
c0d0453e:	4620      	mov	r0, r4
c0d04540:	bd10      	pop	{r4, pc}

c0d04542 <USBD_CtlReceiveStatus>:
*         receive zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlReceiveStatus (USBD_HandleTypeDef  *pdev)
{
c0d04542:	b510      	push	{r4, lr}
  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_OUT; 
c0d04544:	21f4      	movs	r1, #244	; 0xf4
c0d04546:	2205      	movs	r2, #5
c0d04548:	5042      	str	r2, [r0, r1]
c0d0454a:	2400      	movs	r4, #0
  
 /* Start the transfer */  
  USBD_LL_PrepareReceive ( pdev,
c0d0454c:	4621      	mov	r1, r4
c0d0454e:	4622      	mov	r2, r4
c0d04550:	f7ff f9d1 	bl	c0d038f6 <USBD_LL_PrepareReceive>
                    0,
                    0);  

  return USBD_OK;
c0d04554:	4620      	mov	r0, r4
c0d04556:	bd10      	pop	{r4, pc}

c0d04558 <__aeabi_uidiv>:
c0d04558:	2200      	movs	r2, #0
c0d0455a:	0843      	lsrs	r3, r0, #1
c0d0455c:	428b      	cmp	r3, r1
c0d0455e:	d374      	bcc.n	c0d0464a <__aeabi_uidiv+0xf2>
c0d04560:	0903      	lsrs	r3, r0, #4
c0d04562:	428b      	cmp	r3, r1
c0d04564:	d35f      	bcc.n	c0d04626 <__aeabi_uidiv+0xce>
c0d04566:	0a03      	lsrs	r3, r0, #8
c0d04568:	428b      	cmp	r3, r1
c0d0456a:	d344      	bcc.n	c0d045f6 <__aeabi_uidiv+0x9e>
c0d0456c:	0b03      	lsrs	r3, r0, #12
c0d0456e:	428b      	cmp	r3, r1
c0d04570:	d328      	bcc.n	c0d045c4 <__aeabi_uidiv+0x6c>
c0d04572:	0c03      	lsrs	r3, r0, #16
c0d04574:	428b      	cmp	r3, r1
c0d04576:	d30d      	bcc.n	c0d04594 <__aeabi_uidiv+0x3c>
c0d04578:	22ff      	movs	r2, #255	; 0xff
c0d0457a:	0209      	lsls	r1, r1, #8
c0d0457c:	ba12      	rev	r2, r2
c0d0457e:	0c03      	lsrs	r3, r0, #16
c0d04580:	428b      	cmp	r3, r1
c0d04582:	d302      	bcc.n	c0d0458a <__aeabi_uidiv+0x32>
c0d04584:	1212      	asrs	r2, r2, #8
c0d04586:	0209      	lsls	r1, r1, #8
c0d04588:	d065      	beq.n	c0d04656 <__aeabi_uidiv+0xfe>
c0d0458a:	0b03      	lsrs	r3, r0, #12
c0d0458c:	428b      	cmp	r3, r1
c0d0458e:	d319      	bcc.n	c0d045c4 <__aeabi_uidiv+0x6c>
c0d04590:	e000      	b.n	c0d04594 <__aeabi_uidiv+0x3c>
c0d04592:	0a09      	lsrs	r1, r1, #8
c0d04594:	0bc3      	lsrs	r3, r0, #15
c0d04596:	428b      	cmp	r3, r1
c0d04598:	d301      	bcc.n	c0d0459e <__aeabi_uidiv+0x46>
c0d0459a:	03cb      	lsls	r3, r1, #15
c0d0459c:	1ac0      	subs	r0, r0, r3
c0d0459e:	4152      	adcs	r2, r2
c0d045a0:	0b83      	lsrs	r3, r0, #14
c0d045a2:	428b      	cmp	r3, r1
c0d045a4:	d301      	bcc.n	c0d045aa <__aeabi_uidiv+0x52>
c0d045a6:	038b      	lsls	r3, r1, #14
c0d045a8:	1ac0      	subs	r0, r0, r3
c0d045aa:	4152      	adcs	r2, r2
c0d045ac:	0b43      	lsrs	r3, r0, #13
c0d045ae:	428b      	cmp	r3, r1
c0d045b0:	d301      	bcc.n	c0d045b6 <__aeabi_uidiv+0x5e>
c0d045b2:	034b      	lsls	r3, r1, #13
c0d045b4:	1ac0      	subs	r0, r0, r3
c0d045b6:	4152      	adcs	r2, r2
c0d045b8:	0b03      	lsrs	r3, r0, #12
c0d045ba:	428b      	cmp	r3, r1
c0d045bc:	d301      	bcc.n	c0d045c2 <__aeabi_uidiv+0x6a>
c0d045be:	030b      	lsls	r3, r1, #12
c0d045c0:	1ac0      	subs	r0, r0, r3
c0d045c2:	4152      	adcs	r2, r2
c0d045c4:	0ac3      	lsrs	r3, r0, #11
c0d045c6:	428b      	cmp	r3, r1
c0d045c8:	d301      	bcc.n	c0d045ce <__aeabi_uidiv+0x76>
c0d045ca:	02cb      	lsls	r3, r1, #11
c0d045cc:	1ac0      	subs	r0, r0, r3
c0d045ce:	4152      	adcs	r2, r2
c0d045d0:	0a83      	lsrs	r3, r0, #10
c0d045d2:	428b      	cmp	r3, r1
c0d045d4:	d301      	bcc.n	c0d045da <__aeabi_uidiv+0x82>
c0d045d6:	028b      	lsls	r3, r1, #10
c0d045d8:	1ac0      	subs	r0, r0, r3
c0d045da:	4152      	adcs	r2, r2
c0d045dc:	0a43      	lsrs	r3, r0, #9
c0d045de:	428b      	cmp	r3, r1
c0d045e0:	d301      	bcc.n	c0d045e6 <__aeabi_uidiv+0x8e>
c0d045e2:	024b      	lsls	r3, r1, #9
c0d045e4:	1ac0      	subs	r0, r0, r3
c0d045e6:	4152      	adcs	r2, r2
c0d045e8:	0a03      	lsrs	r3, r0, #8
c0d045ea:	428b      	cmp	r3, r1
c0d045ec:	d301      	bcc.n	c0d045f2 <__aeabi_uidiv+0x9a>
c0d045ee:	020b      	lsls	r3, r1, #8
c0d045f0:	1ac0      	subs	r0, r0, r3
c0d045f2:	4152      	adcs	r2, r2
c0d045f4:	d2cd      	bcs.n	c0d04592 <__aeabi_uidiv+0x3a>
c0d045f6:	09c3      	lsrs	r3, r0, #7
c0d045f8:	428b      	cmp	r3, r1
c0d045fa:	d301      	bcc.n	c0d04600 <__aeabi_uidiv+0xa8>
c0d045fc:	01cb      	lsls	r3, r1, #7
c0d045fe:	1ac0      	subs	r0, r0, r3
c0d04600:	4152      	adcs	r2, r2
c0d04602:	0983      	lsrs	r3, r0, #6
c0d04604:	428b      	cmp	r3, r1
c0d04606:	d301      	bcc.n	c0d0460c <__aeabi_uidiv+0xb4>
c0d04608:	018b      	lsls	r3, r1, #6
c0d0460a:	1ac0      	subs	r0, r0, r3
c0d0460c:	4152      	adcs	r2, r2
c0d0460e:	0943      	lsrs	r3, r0, #5
c0d04610:	428b      	cmp	r3, r1
c0d04612:	d301      	bcc.n	c0d04618 <__aeabi_uidiv+0xc0>
c0d04614:	014b      	lsls	r3, r1, #5
c0d04616:	1ac0      	subs	r0, r0, r3
c0d04618:	4152      	adcs	r2, r2
c0d0461a:	0903      	lsrs	r3, r0, #4
c0d0461c:	428b      	cmp	r3, r1
c0d0461e:	d301      	bcc.n	c0d04624 <__aeabi_uidiv+0xcc>
c0d04620:	010b      	lsls	r3, r1, #4
c0d04622:	1ac0      	subs	r0, r0, r3
c0d04624:	4152      	adcs	r2, r2
c0d04626:	08c3      	lsrs	r3, r0, #3
c0d04628:	428b      	cmp	r3, r1
c0d0462a:	d301      	bcc.n	c0d04630 <__aeabi_uidiv+0xd8>
c0d0462c:	00cb      	lsls	r3, r1, #3
c0d0462e:	1ac0      	subs	r0, r0, r3
c0d04630:	4152      	adcs	r2, r2
c0d04632:	0883      	lsrs	r3, r0, #2
c0d04634:	428b      	cmp	r3, r1
c0d04636:	d301      	bcc.n	c0d0463c <__aeabi_uidiv+0xe4>
c0d04638:	008b      	lsls	r3, r1, #2
c0d0463a:	1ac0      	subs	r0, r0, r3
c0d0463c:	4152      	adcs	r2, r2
c0d0463e:	0843      	lsrs	r3, r0, #1
c0d04640:	428b      	cmp	r3, r1
c0d04642:	d301      	bcc.n	c0d04648 <__aeabi_uidiv+0xf0>
c0d04644:	004b      	lsls	r3, r1, #1
c0d04646:	1ac0      	subs	r0, r0, r3
c0d04648:	4152      	adcs	r2, r2
c0d0464a:	1a41      	subs	r1, r0, r1
c0d0464c:	d200      	bcs.n	c0d04650 <__aeabi_uidiv+0xf8>
c0d0464e:	4601      	mov	r1, r0
c0d04650:	4152      	adcs	r2, r2
c0d04652:	4610      	mov	r0, r2
c0d04654:	4770      	bx	lr
c0d04656:	e7ff      	b.n	c0d04658 <__aeabi_uidiv+0x100>
c0d04658:	b501      	push	{r0, lr}
c0d0465a:	2000      	movs	r0, #0
c0d0465c:	f000 f8f0 	bl	c0d04840 <__aeabi_idiv0>
c0d04660:	bd02      	pop	{r1, pc}
c0d04662:	46c0      	nop			; (mov r8, r8)

c0d04664 <__aeabi_uidivmod>:
c0d04664:	2900      	cmp	r1, #0
c0d04666:	d0f7      	beq.n	c0d04658 <__aeabi_uidiv+0x100>
c0d04668:	e776      	b.n	c0d04558 <__aeabi_uidiv>
c0d0466a:	4770      	bx	lr

c0d0466c <__aeabi_idiv>:
c0d0466c:	4603      	mov	r3, r0
c0d0466e:	430b      	orrs	r3, r1
c0d04670:	d47f      	bmi.n	c0d04772 <__aeabi_idiv+0x106>
c0d04672:	2200      	movs	r2, #0
c0d04674:	0843      	lsrs	r3, r0, #1
c0d04676:	428b      	cmp	r3, r1
c0d04678:	d374      	bcc.n	c0d04764 <__aeabi_idiv+0xf8>
c0d0467a:	0903      	lsrs	r3, r0, #4
c0d0467c:	428b      	cmp	r3, r1
c0d0467e:	d35f      	bcc.n	c0d04740 <__aeabi_idiv+0xd4>
c0d04680:	0a03      	lsrs	r3, r0, #8
c0d04682:	428b      	cmp	r3, r1
c0d04684:	d344      	bcc.n	c0d04710 <__aeabi_idiv+0xa4>
c0d04686:	0b03      	lsrs	r3, r0, #12
c0d04688:	428b      	cmp	r3, r1
c0d0468a:	d328      	bcc.n	c0d046de <__aeabi_idiv+0x72>
c0d0468c:	0c03      	lsrs	r3, r0, #16
c0d0468e:	428b      	cmp	r3, r1
c0d04690:	d30d      	bcc.n	c0d046ae <__aeabi_idiv+0x42>
c0d04692:	22ff      	movs	r2, #255	; 0xff
c0d04694:	0209      	lsls	r1, r1, #8
c0d04696:	ba12      	rev	r2, r2
c0d04698:	0c03      	lsrs	r3, r0, #16
c0d0469a:	428b      	cmp	r3, r1
c0d0469c:	d302      	bcc.n	c0d046a4 <__aeabi_idiv+0x38>
c0d0469e:	1212      	asrs	r2, r2, #8
c0d046a0:	0209      	lsls	r1, r1, #8
c0d046a2:	d065      	beq.n	c0d04770 <__aeabi_idiv+0x104>
c0d046a4:	0b03      	lsrs	r3, r0, #12
c0d046a6:	428b      	cmp	r3, r1
c0d046a8:	d319      	bcc.n	c0d046de <__aeabi_idiv+0x72>
c0d046aa:	e000      	b.n	c0d046ae <__aeabi_idiv+0x42>
c0d046ac:	0a09      	lsrs	r1, r1, #8
c0d046ae:	0bc3      	lsrs	r3, r0, #15
c0d046b0:	428b      	cmp	r3, r1
c0d046b2:	d301      	bcc.n	c0d046b8 <__aeabi_idiv+0x4c>
c0d046b4:	03cb      	lsls	r3, r1, #15
c0d046b6:	1ac0      	subs	r0, r0, r3
c0d046b8:	4152      	adcs	r2, r2
c0d046ba:	0b83      	lsrs	r3, r0, #14
c0d046bc:	428b      	cmp	r3, r1
c0d046be:	d301      	bcc.n	c0d046c4 <__aeabi_idiv+0x58>
c0d046c0:	038b      	lsls	r3, r1, #14
c0d046c2:	1ac0      	subs	r0, r0, r3
c0d046c4:	4152      	adcs	r2, r2
c0d046c6:	0b43      	lsrs	r3, r0, #13
c0d046c8:	428b      	cmp	r3, r1
c0d046ca:	d301      	bcc.n	c0d046d0 <__aeabi_idiv+0x64>
c0d046cc:	034b      	lsls	r3, r1, #13
c0d046ce:	1ac0      	subs	r0, r0, r3
c0d046d0:	4152      	adcs	r2, r2
c0d046d2:	0b03      	lsrs	r3, r0, #12
c0d046d4:	428b      	cmp	r3, r1
c0d046d6:	d301      	bcc.n	c0d046dc <__aeabi_idiv+0x70>
c0d046d8:	030b      	lsls	r3, r1, #12
c0d046da:	1ac0      	subs	r0, r0, r3
c0d046dc:	4152      	adcs	r2, r2
c0d046de:	0ac3      	lsrs	r3, r0, #11
c0d046e0:	428b      	cmp	r3, r1
c0d046e2:	d301      	bcc.n	c0d046e8 <__aeabi_idiv+0x7c>
c0d046e4:	02cb      	lsls	r3, r1, #11
c0d046e6:	1ac0      	subs	r0, r0, r3
c0d046e8:	4152      	adcs	r2, r2
c0d046ea:	0a83      	lsrs	r3, r0, #10
c0d046ec:	428b      	cmp	r3, r1
c0d046ee:	d301      	bcc.n	c0d046f4 <__aeabi_idiv+0x88>
c0d046f0:	028b      	lsls	r3, r1, #10
c0d046f2:	1ac0      	subs	r0, r0, r3
c0d046f4:	4152      	adcs	r2, r2
c0d046f6:	0a43      	lsrs	r3, r0, #9
c0d046f8:	428b      	cmp	r3, r1
c0d046fa:	d301      	bcc.n	c0d04700 <__aeabi_idiv+0x94>
c0d046fc:	024b      	lsls	r3, r1, #9
c0d046fe:	1ac0      	subs	r0, r0, r3
c0d04700:	4152      	adcs	r2, r2
c0d04702:	0a03      	lsrs	r3, r0, #8
c0d04704:	428b      	cmp	r3, r1
c0d04706:	d301      	bcc.n	c0d0470c <__aeabi_idiv+0xa0>
c0d04708:	020b      	lsls	r3, r1, #8
c0d0470a:	1ac0      	subs	r0, r0, r3
c0d0470c:	4152      	adcs	r2, r2
c0d0470e:	d2cd      	bcs.n	c0d046ac <__aeabi_idiv+0x40>
c0d04710:	09c3      	lsrs	r3, r0, #7
c0d04712:	428b      	cmp	r3, r1
c0d04714:	d301      	bcc.n	c0d0471a <__aeabi_idiv+0xae>
c0d04716:	01cb      	lsls	r3, r1, #7
c0d04718:	1ac0      	subs	r0, r0, r3
c0d0471a:	4152      	adcs	r2, r2
c0d0471c:	0983      	lsrs	r3, r0, #6
c0d0471e:	428b      	cmp	r3, r1
c0d04720:	d301      	bcc.n	c0d04726 <__aeabi_idiv+0xba>
c0d04722:	018b      	lsls	r3, r1, #6
c0d04724:	1ac0      	subs	r0, r0, r3
c0d04726:	4152      	adcs	r2, r2
c0d04728:	0943      	lsrs	r3, r0, #5
c0d0472a:	428b      	cmp	r3, r1
c0d0472c:	d301      	bcc.n	c0d04732 <__aeabi_idiv+0xc6>
c0d0472e:	014b      	lsls	r3, r1, #5
c0d04730:	1ac0      	subs	r0, r0, r3
c0d04732:	4152      	adcs	r2, r2
c0d04734:	0903      	lsrs	r3, r0, #4
c0d04736:	428b      	cmp	r3, r1
c0d04738:	d301      	bcc.n	c0d0473e <__aeabi_idiv+0xd2>
c0d0473a:	010b      	lsls	r3, r1, #4
c0d0473c:	1ac0      	subs	r0, r0, r3
c0d0473e:	4152      	adcs	r2, r2
c0d04740:	08c3      	lsrs	r3, r0, #3
c0d04742:	428b      	cmp	r3, r1
c0d04744:	d301      	bcc.n	c0d0474a <__aeabi_idiv+0xde>
c0d04746:	00cb      	lsls	r3, r1, #3
c0d04748:	1ac0      	subs	r0, r0, r3
c0d0474a:	4152      	adcs	r2, r2
c0d0474c:	0883      	lsrs	r3, r0, #2
c0d0474e:	428b      	cmp	r3, r1
c0d04750:	d301      	bcc.n	c0d04756 <__aeabi_idiv+0xea>
c0d04752:	008b      	lsls	r3, r1, #2
c0d04754:	1ac0      	subs	r0, r0, r3
c0d04756:	4152      	adcs	r2, r2
c0d04758:	0843      	lsrs	r3, r0, #1
c0d0475a:	428b      	cmp	r3, r1
c0d0475c:	d301      	bcc.n	c0d04762 <__aeabi_idiv+0xf6>
c0d0475e:	004b      	lsls	r3, r1, #1
c0d04760:	1ac0      	subs	r0, r0, r3
c0d04762:	4152      	adcs	r2, r2
c0d04764:	1a41      	subs	r1, r0, r1
c0d04766:	d200      	bcs.n	c0d0476a <__aeabi_idiv+0xfe>
c0d04768:	4601      	mov	r1, r0
c0d0476a:	4152      	adcs	r2, r2
c0d0476c:	4610      	mov	r0, r2
c0d0476e:	4770      	bx	lr
c0d04770:	e05d      	b.n	c0d0482e <__aeabi_idiv+0x1c2>
c0d04772:	0fca      	lsrs	r2, r1, #31
c0d04774:	d000      	beq.n	c0d04778 <__aeabi_idiv+0x10c>
c0d04776:	4249      	negs	r1, r1
c0d04778:	1003      	asrs	r3, r0, #32
c0d0477a:	d300      	bcc.n	c0d0477e <__aeabi_idiv+0x112>
c0d0477c:	4240      	negs	r0, r0
c0d0477e:	4053      	eors	r3, r2
c0d04780:	2200      	movs	r2, #0
c0d04782:	469c      	mov	ip, r3
c0d04784:	0903      	lsrs	r3, r0, #4
c0d04786:	428b      	cmp	r3, r1
c0d04788:	d32d      	bcc.n	c0d047e6 <__aeabi_idiv+0x17a>
c0d0478a:	0a03      	lsrs	r3, r0, #8
c0d0478c:	428b      	cmp	r3, r1
c0d0478e:	d312      	bcc.n	c0d047b6 <__aeabi_idiv+0x14a>
c0d04790:	22fc      	movs	r2, #252	; 0xfc
c0d04792:	0189      	lsls	r1, r1, #6
c0d04794:	ba12      	rev	r2, r2
c0d04796:	0a03      	lsrs	r3, r0, #8
c0d04798:	428b      	cmp	r3, r1
c0d0479a:	d30c      	bcc.n	c0d047b6 <__aeabi_idiv+0x14a>
c0d0479c:	0189      	lsls	r1, r1, #6
c0d0479e:	1192      	asrs	r2, r2, #6
c0d047a0:	428b      	cmp	r3, r1
c0d047a2:	d308      	bcc.n	c0d047b6 <__aeabi_idiv+0x14a>
c0d047a4:	0189      	lsls	r1, r1, #6
c0d047a6:	1192      	asrs	r2, r2, #6
c0d047a8:	428b      	cmp	r3, r1
c0d047aa:	d304      	bcc.n	c0d047b6 <__aeabi_idiv+0x14a>
c0d047ac:	0189      	lsls	r1, r1, #6
c0d047ae:	d03a      	beq.n	c0d04826 <__aeabi_idiv+0x1ba>
c0d047b0:	1192      	asrs	r2, r2, #6
c0d047b2:	e000      	b.n	c0d047b6 <__aeabi_idiv+0x14a>
c0d047b4:	0989      	lsrs	r1, r1, #6
c0d047b6:	09c3      	lsrs	r3, r0, #7
c0d047b8:	428b      	cmp	r3, r1
c0d047ba:	d301      	bcc.n	c0d047c0 <__aeabi_idiv+0x154>
c0d047bc:	01cb      	lsls	r3, r1, #7
c0d047be:	1ac0      	subs	r0, r0, r3
c0d047c0:	4152      	adcs	r2, r2
c0d047c2:	0983      	lsrs	r3, r0, #6
c0d047c4:	428b      	cmp	r3, r1
c0d047c6:	d301      	bcc.n	c0d047cc <__aeabi_idiv+0x160>
c0d047c8:	018b      	lsls	r3, r1, #6
c0d047ca:	1ac0      	subs	r0, r0, r3
c0d047cc:	4152      	adcs	r2, r2
c0d047ce:	0943      	lsrs	r3, r0, #5
c0d047d0:	428b      	cmp	r3, r1
c0d047d2:	d301      	bcc.n	c0d047d8 <__aeabi_idiv+0x16c>
c0d047d4:	014b      	lsls	r3, r1, #5
c0d047d6:	1ac0      	subs	r0, r0, r3
c0d047d8:	4152      	adcs	r2, r2
c0d047da:	0903      	lsrs	r3, r0, #4
c0d047dc:	428b      	cmp	r3, r1
c0d047de:	d301      	bcc.n	c0d047e4 <__aeabi_idiv+0x178>
c0d047e0:	010b      	lsls	r3, r1, #4
c0d047e2:	1ac0      	subs	r0, r0, r3
c0d047e4:	4152      	adcs	r2, r2
c0d047e6:	08c3      	lsrs	r3, r0, #3
c0d047e8:	428b      	cmp	r3, r1
c0d047ea:	d301      	bcc.n	c0d047f0 <__aeabi_idiv+0x184>
c0d047ec:	00cb      	lsls	r3, r1, #3
c0d047ee:	1ac0      	subs	r0, r0, r3
c0d047f0:	4152      	adcs	r2, r2
c0d047f2:	0883      	lsrs	r3, r0, #2
c0d047f4:	428b      	cmp	r3, r1
c0d047f6:	d301      	bcc.n	c0d047fc <__aeabi_idiv+0x190>
c0d047f8:	008b      	lsls	r3, r1, #2
c0d047fa:	1ac0      	subs	r0, r0, r3
c0d047fc:	4152      	adcs	r2, r2
c0d047fe:	d2d9      	bcs.n	c0d047b4 <__aeabi_idiv+0x148>
c0d04800:	0843      	lsrs	r3, r0, #1
c0d04802:	428b      	cmp	r3, r1
c0d04804:	d301      	bcc.n	c0d0480a <__aeabi_idiv+0x19e>
c0d04806:	004b      	lsls	r3, r1, #1
c0d04808:	1ac0      	subs	r0, r0, r3
c0d0480a:	4152      	adcs	r2, r2
c0d0480c:	1a41      	subs	r1, r0, r1
c0d0480e:	d200      	bcs.n	c0d04812 <__aeabi_idiv+0x1a6>
c0d04810:	4601      	mov	r1, r0
c0d04812:	4663      	mov	r3, ip
c0d04814:	4152      	adcs	r2, r2
c0d04816:	105b      	asrs	r3, r3, #1
c0d04818:	4610      	mov	r0, r2
c0d0481a:	d301      	bcc.n	c0d04820 <__aeabi_idiv+0x1b4>
c0d0481c:	4240      	negs	r0, r0
c0d0481e:	2b00      	cmp	r3, #0
c0d04820:	d500      	bpl.n	c0d04824 <__aeabi_idiv+0x1b8>
c0d04822:	4249      	negs	r1, r1
c0d04824:	4770      	bx	lr
c0d04826:	4663      	mov	r3, ip
c0d04828:	105b      	asrs	r3, r3, #1
c0d0482a:	d300      	bcc.n	c0d0482e <__aeabi_idiv+0x1c2>
c0d0482c:	4240      	negs	r0, r0
c0d0482e:	b501      	push	{r0, lr}
c0d04830:	2000      	movs	r0, #0
c0d04832:	f000 f805 	bl	c0d04840 <__aeabi_idiv0>
c0d04836:	bd02      	pop	{r1, pc}

c0d04838 <__aeabi_idivmod>:
c0d04838:	2900      	cmp	r1, #0
c0d0483a:	d0f8      	beq.n	c0d0482e <__aeabi_idiv+0x1c2>
c0d0483c:	e716      	b.n	c0d0466c <__aeabi_idiv>
c0d0483e:	4770      	bx	lr

c0d04840 <__aeabi_idiv0>:
c0d04840:	4770      	bx	lr
c0d04842:	46c0      	nop			; (mov r8, r8)

c0d04844 <__aeabi_memclr>:
c0d04844:	b510      	push	{r4, lr}
c0d04846:	2200      	movs	r2, #0
c0d04848:	f000 f806 	bl	c0d04858 <__aeabi_memset>
c0d0484c:	bd10      	pop	{r4, pc}
c0d0484e:	46c0      	nop			; (mov r8, r8)

c0d04850 <__aeabi_memcpy>:
c0d04850:	b510      	push	{r4, lr}
c0d04852:	f000 f809 	bl	c0d04868 <memcpy>
c0d04856:	bd10      	pop	{r4, pc}

c0d04858 <__aeabi_memset>:
c0d04858:	0013      	movs	r3, r2
c0d0485a:	b510      	push	{r4, lr}
c0d0485c:	000a      	movs	r2, r1
c0d0485e:	0019      	movs	r1, r3
c0d04860:	f000 f840 	bl	c0d048e4 <memset>
c0d04864:	bd10      	pop	{r4, pc}
c0d04866:	46c0      	nop			; (mov r8, r8)

c0d04868 <memcpy>:
c0d04868:	b570      	push	{r4, r5, r6, lr}
c0d0486a:	2a0f      	cmp	r2, #15
c0d0486c:	d932      	bls.n	c0d048d4 <memcpy+0x6c>
c0d0486e:	000c      	movs	r4, r1
c0d04870:	4304      	orrs	r4, r0
c0d04872:	000b      	movs	r3, r1
c0d04874:	07a4      	lsls	r4, r4, #30
c0d04876:	d131      	bne.n	c0d048dc <memcpy+0x74>
c0d04878:	0015      	movs	r5, r2
c0d0487a:	0004      	movs	r4, r0
c0d0487c:	3d10      	subs	r5, #16
c0d0487e:	092d      	lsrs	r5, r5, #4
c0d04880:	3501      	adds	r5, #1
c0d04882:	012d      	lsls	r5, r5, #4
c0d04884:	1949      	adds	r1, r1, r5
c0d04886:	681e      	ldr	r6, [r3, #0]
c0d04888:	6026      	str	r6, [r4, #0]
c0d0488a:	685e      	ldr	r6, [r3, #4]
c0d0488c:	6066      	str	r6, [r4, #4]
c0d0488e:	689e      	ldr	r6, [r3, #8]
c0d04890:	60a6      	str	r6, [r4, #8]
c0d04892:	68de      	ldr	r6, [r3, #12]
c0d04894:	3310      	adds	r3, #16
c0d04896:	60e6      	str	r6, [r4, #12]
c0d04898:	3410      	adds	r4, #16
c0d0489a:	4299      	cmp	r1, r3
c0d0489c:	d1f3      	bne.n	c0d04886 <memcpy+0x1e>
c0d0489e:	230f      	movs	r3, #15
c0d048a0:	1945      	adds	r5, r0, r5
c0d048a2:	4013      	ands	r3, r2
c0d048a4:	2b03      	cmp	r3, #3
c0d048a6:	d91b      	bls.n	c0d048e0 <memcpy+0x78>
c0d048a8:	1f1c      	subs	r4, r3, #4
c0d048aa:	2300      	movs	r3, #0
c0d048ac:	08a4      	lsrs	r4, r4, #2
c0d048ae:	3401      	adds	r4, #1
c0d048b0:	00a4      	lsls	r4, r4, #2
c0d048b2:	58ce      	ldr	r6, [r1, r3]
c0d048b4:	50ee      	str	r6, [r5, r3]
c0d048b6:	3304      	adds	r3, #4
c0d048b8:	429c      	cmp	r4, r3
c0d048ba:	d1fa      	bne.n	c0d048b2 <memcpy+0x4a>
c0d048bc:	2303      	movs	r3, #3
c0d048be:	192d      	adds	r5, r5, r4
c0d048c0:	1909      	adds	r1, r1, r4
c0d048c2:	401a      	ands	r2, r3
c0d048c4:	d005      	beq.n	c0d048d2 <memcpy+0x6a>
c0d048c6:	2300      	movs	r3, #0
c0d048c8:	5ccc      	ldrb	r4, [r1, r3]
c0d048ca:	54ec      	strb	r4, [r5, r3]
c0d048cc:	3301      	adds	r3, #1
c0d048ce:	429a      	cmp	r2, r3
c0d048d0:	d1fa      	bne.n	c0d048c8 <memcpy+0x60>
c0d048d2:	bd70      	pop	{r4, r5, r6, pc}
c0d048d4:	0005      	movs	r5, r0
c0d048d6:	2a00      	cmp	r2, #0
c0d048d8:	d1f5      	bne.n	c0d048c6 <memcpy+0x5e>
c0d048da:	e7fa      	b.n	c0d048d2 <memcpy+0x6a>
c0d048dc:	0005      	movs	r5, r0
c0d048de:	e7f2      	b.n	c0d048c6 <memcpy+0x5e>
c0d048e0:	001a      	movs	r2, r3
c0d048e2:	e7f8      	b.n	c0d048d6 <memcpy+0x6e>

c0d048e4 <memset>:
c0d048e4:	b570      	push	{r4, r5, r6, lr}
c0d048e6:	0783      	lsls	r3, r0, #30
c0d048e8:	d03f      	beq.n	c0d0496a <memset+0x86>
c0d048ea:	1e54      	subs	r4, r2, #1
c0d048ec:	2a00      	cmp	r2, #0
c0d048ee:	d03b      	beq.n	c0d04968 <memset+0x84>
c0d048f0:	b2ce      	uxtb	r6, r1
c0d048f2:	0003      	movs	r3, r0
c0d048f4:	2503      	movs	r5, #3
c0d048f6:	e003      	b.n	c0d04900 <memset+0x1c>
c0d048f8:	1e62      	subs	r2, r4, #1
c0d048fa:	2c00      	cmp	r4, #0
c0d048fc:	d034      	beq.n	c0d04968 <memset+0x84>
c0d048fe:	0014      	movs	r4, r2
c0d04900:	3301      	adds	r3, #1
c0d04902:	1e5a      	subs	r2, r3, #1
c0d04904:	7016      	strb	r6, [r2, #0]
c0d04906:	422b      	tst	r3, r5
c0d04908:	d1f6      	bne.n	c0d048f8 <memset+0x14>
c0d0490a:	2c03      	cmp	r4, #3
c0d0490c:	d924      	bls.n	c0d04958 <memset+0x74>
c0d0490e:	25ff      	movs	r5, #255	; 0xff
c0d04910:	400d      	ands	r5, r1
c0d04912:	022a      	lsls	r2, r5, #8
c0d04914:	4315      	orrs	r5, r2
c0d04916:	042a      	lsls	r2, r5, #16
c0d04918:	4315      	orrs	r5, r2
c0d0491a:	2c0f      	cmp	r4, #15
c0d0491c:	d911      	bls.n	c0d04942 <memset+0x5e>
c0d0491e:	0026      	movs	r6, r4
c0d04920:	3e10      	subs	r6, #16
c0d04922:	0936      	lsrs	r6, r6, #4
c0d04924:	3601      	adds	r6, #1
c0d04926:	0136      	lsls	r6, r6, #4
c0d04928:	001a      	movs	r2, r3
c0d0492a:	199b      	adds	r3, r3, r6
c0d0492c:	6015      	str	r5, [r2, #0]
c0d0492e:	6055      	str	r5, [r2, #4]
c0d04930:	6095      	str	r5, [r2, #8]
c0d04932:	60d5      	str	r5, [r2, #12]
c0d04934:	3210      	adds	r2, #16
c0d04936:	4293      	cmp	r3, r2
c0d04938:	d1f8      	bne.n	c0d0492c <memset+0x48>
c0d0493a:	220f      	movs	r2, #15
c0d0493c:	4014      	ands	r4, r2
c0d0493e:	2c03      	cmp	r4, #3
c0d04940:	d90a      	bls.n	c0d04958 <memset+0x74>
c0d04942:	1f26      	subs	r6, r4, #4
c0d04944:	08b6      	lsrs	r6, r6, #2
c0d04946:	3601      	adds	r6, #1
c0d04948:	00b6      	lsls	r6, r6, #2
c0d0494a:	001a      	movs	r2, r3
c0d0494c:	199b      	adds	r3, r3, r6
c0d0494e:	c220      	stmia	r2!, {r5}
c0d04950:	4293      	cmp	r3, r2
c0d04952:	d1fc      	bne.n	c0d0494e <memset+0x6a>
c0d04954:	2203      	movs	r2, #3
c0d04956:	4014      	ands	r4, r2
c0d04958:	2c00      	cmp	r4, #0
c0d0495a:	d005      	beq.n	c0d04968 <memset+0x84>
c0d0495c:	b2c9      	uxtb	r1, r1
c0d0495e:	191c      	adds	r4, r3, r4
c0d04960:	7019      	strb	r1, [r3, #0]
c0d04962:	3301      	adds	r3, #1
c0d04964:	429c      	cmp	r4, r3
c0d04966:	d1fb      	bne.n	c0d04960 <memset+0x7c>
c0d04968:	bd70      	pop	{r4, r5, r6, pc}
c0d0496a:	0014      	movs	r4, r2
c0d0496c:	0003      	movs	r3, r0
c0d0496e:	e7cc      	b.n	c0d0490a <memset+0x26>

c0d04970 <setjmp>:
c0d04970:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0d04972:	4641      	mov	r1, r8
c0d04974:	464a      	mov	r2, r9
c0d04976:	4653      	mov	r3, sl
c0d04978:	465c      	mov	r4, fp
c0d0497a:	466d      	mov	r5, sp
c0d0497c:	4676      	mov	r6, lr
c0d0497e:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0d04980:	3828      	subs	r0, #40	; 0x28
c0d04982:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d04984:	2000      	movs	r0, #0
c0d04986:	4770      	bx	lr

c0d04988 <longjmp>:
c0d04988:	3010      	adds	r0, #16
c0d0498a:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0d0498c:	4690      	mov	r8, r2
c0d0498e:	4699      	mov	r9, r3
c0d04990:	46a2      	mov	sl, r4
c0d04992:	46ab      	mov	fp, r5
c0d04994:	46b5      	mov	sp, r6
c0d04996:	c808      	ldmia	r0!, {r3}
c0d04998:	3828      	subs	r0, #40	; 0x28
c0d0499a:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d0499c:	1c08      	adds	r0, r1, #0
c0d0499e:	d100      	bne.n	c0d049a2 <longjmp+0x1a>
c0d049a0:	2001      	movs	r0, #1
c0d049a2:	4718      	bx	r3

c0d049a4 <strlen>:
c0d049a4:	b510      	push	{r4, lr}
c0d049a6:	0783      	lsls	r3, r0, #30
c0d049a8:	d027      	beq.n	c0d049fa <strlen+0x56>
c0d049aa:	7803      	ldrb	r3, [r0, #0]
c0d049ac:	2b00      	cmp	r3, #0
c0d049ae:	d026      	beq.n	c0d049fe <strlen+0x5a>
c0d049b0:	0003      	movs	r3, r0
c0d049b2:	2103      	movs	r1, #3
c0d049b4:	e002      	b.n	c0d049bc <strlen+0x18>
c0d049b6:	781a      	ldrb	r2, [r3, #0]
c0d049b8:	2a00      	cmp	r2, #0
c0d049ba:	d01c      	beq.n	c0d049f6 <strlen+0x52>
c0d049bc:	3301      	adds	r3, #1
c0d049be:	420b      	tst	r3, r1
c0d049c0:	d1f9      	bne.n	c0d049b6 <strlen+0x12>
c0d049c2:	6819      	ldr	r1, [r3, #0]
c0d049c4:	4a0f      	ldr	r2, [pc, #60]	; (c0d04a04 <strlen+0x60>)
c0d049c6:	4c10      	ldr	r4, [pc, #64]	; (c0d04a08 <strlen+0x64>)
c0d049c8:	188a      	adds	r2, r1, r2
c0d049ca:	438a      	bics	r2, r1
c0d049cc:	4222      	tst	r2, r4
c0d049ce:	d10f      	bne.n	c0d049f0 <strlen+0x4c>
c0d049d0:	3304      	adds	r3, #4
c0d049d2:	6819      	ldr	r1, [r3, #0]
c0d049d4:	4a0b      	ldr	r2, [pc, #44]	; (c0d04a04 <strlen+0x60>)
c0d049d6:	188a      	adds	r2, r1, r2
c0d049d8:	438a      	bics	r2, r1
c0d049da:	4222      	tst	r2, r4
c0d049dc:	d108      	bne.n	c0d049f0 <strlen+0x4c>
c0d049de:	3304      	adds	r3, #4
c0d049e0:	6819      	ldr	r1, [r3, #0]
c0d049e2:	4a08      	ldr	r2, [pc, #32]	; (c0d04a04 <strlen+0x60>)
c0d049e4:	188a      	adds	r2, r1, r2
c0d049e6:	438a      	bics	r2, r1
c0d049e8:	4222      	tst	r2, r4
c0d049ea:	d0f1      	beq.n	c0d049d0 <strlen+0x2c>
c0d049ec:	e000      	b.n	c0d049f0 <strlen+0x4c>
c0d049ee:	3301      	adds	r3, #1
c0d049f0:	781a      	ldrb	r2, [r3, #0]
c0d049f2:	2a00      	cmp	r2, #0
c0d049f4:	d1fb      	bne.n	c0d049ee <strlen+0x4a>
c0d049f6:	1a18      	subs	r0, r3, r0
c0d049f8:	bd10      	pop	{r4, pc}
c0d049fa:	0003      	movs	r3, r0
c0d049fc:	e7e1      	b.n	c0d049c2 <strlen+0x1e>
c0d049fe:	2000      	movs	r0, #0
c0d04a00:	e7fa      	b.n	c0d049f8 <strlen+0x54>
c0d04a02:	46c0      	nop			; (mov r8, r8)
c0d04a04:	fefefeff 	.word	0xfefefeff
c0d04a08:	80808080 	.word	0x80808080

c0d04a0c <TXT_BLANK>:
c0d04a0c:	20202020 20202020 20202020 20202020                     
c0d04a1c:	31300020                                          .

c0d04a1e <HEX_CAP>:
c0d04a1e:	33323130 37363534 42413938 46454443     0123456789ABCDEF

c0d04a2e <BASE_58_ALPHABET>:
c0d04a2e:	34333231 38373635 43424139 47464544     123456789ABCDEFG
c0d04a3e:	4c4b4a48 51504e4d 55545352 59585756     HJKLMNPQRSTUVWXY
c0d04a4e:	6362615a 67666564 6b6a6968 706f6e6d     Zabcdefghijkmnop
c0d04a5e:	74737271 78777675 006f7a79                       qrstuvwxyz

c0d04a68 <SW_INTERNAL>:
c0d04a68:	0190006f                                         o.

c0d04a6a <SW_BUSY>:
c0d04a6a:	00670190                                         ..

c0d04a6c <SW_WRONG_LENGTH>:
c0d04a6c:	806a0067                                         g.

c0d04a6e <SW_BAD_KEY_HANDLE>:
c0d04a6e:	3255806a                                         j.

c0d04a70 <U2F_VERSION>:
c0d04a70:	5f463255 00903256                       U2F_V2..

c0d04a78 <INFO>:
c0d04a78:	00900901                                ....

c0d04a7c <SW_UNKNOWN_CLASS>:
c0d04a7c:	006d006e                                         n.

c0d04a7e <SW_UNKNOWN_INSTRUCTION>:
c0d04a7e:	ffff006d                                         m.

c0d04a80 <BROADCAST_CHANNEL>:
c0d04a80:	ffffffff                                ....

c0d04a84 <FORBIDDEN_CHANNEL>:
c0d04a84:	00000000 6c6c6548 4e4f206f 58450054     ....Hello ONT.EX
c0d04a94:	53005449 206e6769 55007854 69530070     IT.Sign Tx.Up.Si
c0d04aa4:	44006e67 006e776f 796e6544 00785420     gn.Down.Deny Tx.
c0d04ab4:	796e6544 322f3100 322f3200 00000000     Deny.1/2.2/2....

c0d04ac4 <bagl_ui_idle_blue>:
c0d04ac4:	00000003 0140003c 000001a4 00000001     ....<.@.........
	...
c0d04afc:	00000003 01400000 0000003c 00000001     ......@.<.......
c0d04b0c:	00ffffff 00ffffff 00000000 00000000     ................
	...
c0d04b34:	00500002 00a00000 0000003c 00000001     ..P.....<.......
c0d04b44:	00000000 00ffffff 0000a004 c0d04a88     .............J..
	...
c0d04b6c:	006e0081 006400e1 06000028 00000001     ..n...d.(.......
c0d04b7c:	00ffffff 00000000 0000a004 c0d04a92     .............J..
c0d04b8c:	00000000 0037ae99 00f9f9f9 c0d02ddd     ......7......-..
	...
c0d04ba4:	00000002 003c0000 0000003c 00000001     ......<.<.......
c0d04bb4:	00000000 00ffffff 0000a004 20002020     ............  . 
	...

c0d04bdc <bagl_ui_idle_nanos>:
c0d04bdc:	00000003 00800000 00000020 00000001     ........ .......
c0d04bec:	00000000 00ffffff 00000000 00000000     ................
	...
c0d04c14:	00000207 0080000c 0000000b 00000000     ................
c0d04c24:	00ffffff 00000000 00008008 c0d04a88     .............J..
	...
c0d04c4c:	00030005 0007000c 00000007 00000000     ................
c0d04c5c:	00ffffff 00000000 00070000 00000000     ................
	...
c0d04c84:	00750005 0007000b 00000007 00000000     ..u.............
c0d04c94:	00ffffff 00000000 001b0000 00000000     ................
	...

c0d04cbc <bagl_ui_public_key_nanos_1>:
c0d04cbc:	00000003 00800000 00000020 00000001     ........ .......
c0d04ccc:	00000000 00ffffff 00000000 00000000     ................
	...
c0d04cf4:	000a0207 006c000a 008a000b 00000000     ......l.........
c0d04d04:	00ffffff 00000000 0000800a 20002078     ............x . 
	...
c0d04d2c:	000a0207 006c0015 008a000b 00000000     ......l.........
c0d04d3c:	00ffffff 00000000 0000800a 2000208a     ............. . 
	...
c0d04d64:	00710005 0007000c 00000007 00000000     ..q.............
c0d04d74:	00ffffff 00000000 00070000 00000000     ................
	...
c0d04d9c:	00030005 0007000c 00000007 00000000     ................
c0d04dac:	00ffffff 00000000 000c0000 00000000     ................
	...

c0d04dd4 <bagl_ui_public_key_nanos_2>:
c0d04dd4:	00000003 00800000 00000020 00000001     ........ .......
c0d04de4:	00000000 00ffffff 00000000 00000000     ................
	...
c0d04e0c:	000a0207 006c000a 008a000b 00000000     ......l.........
c0d04e1c:	00ffffff 00000000 0000800a 2000208a     ............. . 
	...
c0d04e44:	000a0207 006c0015 008a000b 00000000     ......l.........
c0d04e54:	00ffffff 00000000 0000800a 2000209c     ............. . 
	...
c0d04e7c:	00710005 0007000c 00000007 00000000     ..q.............
c0d04e8c:	00ffffff 00000000 00070000 00000000     ................
	...
c0d04eb4:	00030005 0007000c 00000007 00000000     ................
c0d04ec4:	00ffffff 00000000 000b0000 00000000     ................
	...

c0d04eec <bagl_ui_top_sign_blue>:
c0d04eec:	00000003 0140003c 000001a4 00000001     ....<.@.........
	...
c0d04f24:	00000003 01400000 0000003c 00000001     ......@.<.......
c0d04f34:	00ffffff 00ffffff 00000000 00000000     ................
	...
c0d04f5c:	00140002 01400000 0000003c 00000001     ......@.<.......
c0d04f6c:	00000000 00ffffff 0000a004 c0d04a97     .............J..
	...
c0d04f94:	00000081 006400e1 06000028 00000001     ......d.(.......
c0d04fa4:	00ffffff 00000000 0000a004 c0d04a9f     .............J..
c0d04fb4:	00000000 0037ae99 00f9f9f9 c0d03061     ......7.....a0..
	...
c0d04fcc:	006e0081 006400e1 06000028 00000001     ..n...d.(.......
c0d04fdc:	00ffffff 00000000 0000a004 c0d04aa2     .............J..
c0d04fec:	00000000 0037ae99 00f9f9f9 c0d029bd     ......7......)..
	...
c0d05004:	00dc0081 006400e1 06000028 00000001     ......d.(.......
c0d05014:	00ffffff 00000000 0000a004 c0d04aa7     .............J..
c0d05024:	00000000 0037ae99 00f9f9f9 c0d030b9     ......7......0..
	...
c0d0503c:	00000002 003c0000 0000003c 00000001     ......<.<.......
c0d0504c:	00000000 00ffffff 0000a004 20002020     ............  . 
	...

c0d05074 <bagl_ui_deny_blue>:
c0d05074:	00000003 0140003c 000001a4 00000001     ....<.@.........
	...
c0d050ac:	00000003 01400000 0000003c 00000001     ......@.<.......
c0d050bc:	00ffffff 00ffffff 00000000 00000000     ................
	...
c0d050e4:	00140002 01400000 0000003c 00000001     ......@.<.......
c0d050f4:	00000000 00ffffff 0000a004 c0d04aac     .............J..
	...
c0d0511c:	00000081 006400e1 06000028 00000001     ......d.(.......
c0d0512c:	00ffffff 00000000 0000a004 c0d04a9f     .............J..
c0d0513c:	00000000 0037ae99 00f9f9f9 c0d03061     ......7.....a0..
	...
c0d05154:	006e0081 006400e1 06000028 00000001     ..n...d.(.......
c0d05164:	00ffffff 00000000 0000a004 c0d04ab4     .............J..
c0d05174:	00000000 0037ae99 00f9f9f9 c0d0364d     ......7.....M6..
	...
c0d0518c:	00dc0081 006400e1 06000028 00000001     ......d.(.......
c0d0519c:	00ffffff 00000000 0000a004 c0d04aa7     .............J..
c0d051ac:	00000000 0037ae99 00f9f9f9 c0d030b9     ......7......0..
	...
c0d051c4:	00000002 003c0000 0000003c 00000001     ......<.<.......
c0d051d4:	00000000 00ffffff 0000a004 20002020     ............  . 
	...

c0d051fc <bagl_ui_deny_nanos>:
c0d051fc:	00000003 00800000 00000020 00000001     ........ .......
c0d0520c:	00000000 00ffffff 00000000 00000000     ................
	...
c0d05234:	00030003 000c0001 00000002 00000001     ................
c0d05244:	00ffffff 00000000 00000000 00000000     ................
	...
c0d0526c:	00710003 000c0001 00000002 00000001     ..q.............
c0d0527c:	00ffffff 00000000 00000000 00000000     ................
	...
c0d052a4:	00000207 00800014 0000000b 00000000     ................
c0d052b4:	00ffffff 00000000 00008008 c0d04aac     .............J..
	...
c0d052dc:	00030005 0007000c 00000007 00000000     ................
c0d052ec:	00ffffff 00000000 000b0000 00000000     ................
	...
c0d05314:	00750005 0007000d 00000007 00000000     ..u.............
c0d05324:	00ffffff 00000000 000c0000 00000000     ................
	...

c0d0534c <bagl_ui_tx_desc_blue>:
c0d0534c:	00000003 014000b4 0000012c 00000001     ......@.,.......
	...
c0d05384:	00000003 01400000 000000b4 00000001     ......@.........
c0d05394:	00ffffff 00ffffff 00000000 00000000     ................
	...
c0d053bc:	00140002 01400000 0000003c 00000001     ......@.<.......
c0d053cc:	00000000 00ffffff 0000a004 20002030     ............0 . 
	...
c0d053f4:	00140002 0140003c 0000003c 00000001     ....<.@.<.......
c0d05404:	00000000 00ffffff 0000a004 20002042     ............B . 
	...
c0d0542c:	00140002 01400078 0000003c 00000001     ....x.@.<.......
c0d0543c:	00000000 00ffffff 0000a004 20002054     ............T . 
	...
c0d05464:	00000081 006400e1 06000028 00000001     ......d.(.......
c0d05474:	00ffffff 00000000 0000a004 c0d04a9f     .............J..
c0d05484:	00000000 0037ae99 00f9f9f9 c0d03061     ......7.....a0..
	...
c0d0549c:	00dc0081 006400e1 06000028 00000001     ......d.(.......
c0d054ac:	00ffffff 00000000 0000a004 c0d04aa7     .............J..
c0d054bc:	00000000 0037ae99 00f9f9f9 c0d030b9     ......7......0..
	...
c0d054d4:	00000002 003c0000 0000003c 00000001     ......<.<.......
c0d054e4:	00000000 00ffffff 0000a004 20002020     ............  . 
	...

c0d0550c <bagl_ui_tx_desc_nanos_1>:
c0d0550c:	00000003 00800000 00000020 00000001     ........ .......
c0d0551c:	00000000 00ffffff 00000000 00000000     ................
	...
c0d05544:	00000207 0014000a 008a000b 00000000     ................
c0d05554:	00ffffff 00000000 0000800a c0d04ab9     .............J..
	...
c0d0557c:	000a0207 006c000f 008a000b 00000000     ......l.........
c0d0558c:	00ffffff 00000000 0000800a 20002030     ............0 . 
	...
c0d055b4:	000a0207 006c001a 008a000b 00000000     ......l.........
c0d055c4:	00ffffff 00000000 0000800a 20002042     ............B . 
	...
c0d055ec:	00030005 0007000c 00000007 00000000     ................
c0d055fc:	00ffffff 00000000 000b0000 00000000     ................
	...
c0d05624:	00750005 0008000d 00000006 00000000     ..u.............
c0d05634:	00ffffff 00000000 000c0000 00000000     ................
	...

c0d0565c <bagl_ui_tx_desc_nanos_2>:
c0d0565c:	00000003 00800000 00000020 00000001     ........ .......
c0d0566c:	00000000 00ffffff 00000000 00000000     ................
	...
c0d05694:	00000207 0014000a 008a000b 00000000     ................
c0d056a4:	00ffffff 00000000 0000800a c0d04abd     .............J..
	...
c0d056cc:	000a0207 006c000f 008a000b 00000000     ......l.........
c0d056dc:	00ffffff 00000000 0000800a 20002054     ............T . 
	...
c0d05704:	000a0207 006c001a 008a000b 00000000     ......l.........
c0d05714:	00ffffff 00000000 0000800a 20002066     ............f . 
	...
c0d0573c:	00030005 0007000c 00000007 00000000     ................
c0d0574c:	00ffffff 00000000 000b0000 00000000     ................
	...
c0d05774:	00750005 0008000d 00000006 00000000     ..u.............
c0d05784:	00ffffff 00000000 000c0000 00000000     ................
	...

c0d057ac <bagl_ui_top_sign_nanos>:
c0d057ac:	00000003 00800000 00000020 00000001     ........ .......
c0d057bc:	00000000 00ffffff 00000000 00000000     ................
	...
c0d057e4:	00030003 000c0001 00000002 00000001     ................
c0d057f4:	00ffffff 00000000 00000000 00000000     ................
	...
c0d0581c:	00710003 000c0001 00000002 00000001     ..q.............
c0d0582c:	00ffffff 00000000 00000000 00000000     ................
	...
c0d05854:	00000207 00800014 0000000b 00000000     ................
c0d05864:	00ffffff 00000000 00008008 c0d04a97     .............J..
	...
c0d0588c:	00030005 0007000c 00000007 00000000     ................
c0d0589c:	00ffffff 00000000 000b0000 00000000     ................
	...
c0d058c4:	00750005 0008000d 00000006 00000000     ..u.............
c0d058d4:	00ffffff 00000000 000c0000 00000000     ................
	...

c0d058fc <USBD_HID_Desc_fido>:
c0d058fc:	01112109 22220121 00000000              .!..!.""....

c0d05908 <USBD_HID_Desc>:
c0d05908:	01112109 22220100 f1d00600                       .!...."".

c0d05911 <HID_ReportDesc_fido>:
c0d05911:	09f1d006 0901a101 26001503 087500ff     ...........&..u.
c0d05921:	08814095 00150409 7500ff26 91409508     .@......&..u..@.
c0d05931:	a006c008                                         ..

c0d05933 <HID_ReportDesc>:
c0d05933:	09ffa006 0901a101 26001503 087500ff     ...........&..u.
c0d05943:	08814095 00150409 7500ff26 91409508     .@......&..u..@.
c0d05953:	0000c008 d043c900                                .....

c0d05958 <HID_Desc>:
c0d05958:	c0d043c9 c0d043d9 c0d043e9 c0d043f9     .C...C...C...C..
c0d05968:	c0d04409 c0d04419 c0d04429 00000000     .D...D..)D......

c0d05978 <USBD_HID>:
c0d05978:	c0d04247 c0d04279 c0d041af 00000000     GB..yB...A......
	...
c0d05990:	c0d04371 00000000 00000000 00000000     qC..............
c0d059a0:	c0d044b5 c0d044b5 c0d044b5 c0d044c5     .D...D...D...D..

c0d059b0 <USBD_U2F>:
c0d059b0:	c0d04247 c0d04279 c0d041af 00000000     GB..yB...A......
c0d059c0:	00000000 c0d0432d c0d04345 00000000     ....-C..EC......
	...
c0d059d8:	c0d044b5 c0d044b5 c0d044b5 c0d044c5     .D...D...D...D..

c0d059e8 <USBD_DeviceDesc>:
c0d059e8:	02000112 40000000 00012c97 02010200     .......@.,......
c0d059f8:	03040103                                         ..

c0d059fa <USBD_LangIDDesc>:
c0d059fa:	04090304                                ....

c0d059fe <USBD_MANUFACTURER_STRING>:
c0d059fe:	004c030e 00640065 00650067 030e0072              ..L.e.d.g.e.r.

c0d05a0c <USBD_PRODUCT_FS_STRING>:
c0d05a0c:	004e030e 006e0061 0020006f 030a0053              ..N.a.n.o. .S.

c0d05a1a <USB_SERIAL_STRING>:
c0d05a1a:	0030030a 00300030 02090031                       ..0.0.0.1.

c0d05a24 <USBD_CfgDesc>:
c0d05a24:	00490209 c0020102 00040932 00030200     ..I.....2.......
c0d05a34:	21090200 01000111 07002222 40038205     ...!...."".....@
c0d05a44:	05070100 00400302 01040901 01030200     ......@.........
c0d05a54:	21090201 01210111 07002222 40038105     ...!..!."".....@
c0d05a64:	05070100 00400301 00000001              ......@.....

c0d05a70 <USBD_DeviceQualifierDesc>:
c0d05a70:	0200060a 40000000 00000001              .......@....

c0d05a7c <_etext>:
c0d05a7c:	00000000 	.word	0x00000000
