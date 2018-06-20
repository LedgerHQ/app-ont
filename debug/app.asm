
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
c0d0001e:	f000 fef1 	bl	c0d00e04 <os_boot>

	UX_INIT();
c0d00022:	4822      	ldr	r0, [pc, #136]	; (c0d000ac <main+0xac>)
c0d00024:	22b0      	movs	r2, #176	; 0xb0
c0d00026:	4621      	mov	r1, r4
c0d00028:	f000 ff9a 	bl	c0d00f60 <os_memset>
c0d0002c:	ad01      	add	r5, sp, #4

	BEGIN_TRY
		{
			TRY
c0d0002e:	4628      	mov	r0, r5
c0d00030:	f004 f8f4 	bl	c0d0421c <setjmp>
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
c0d00044:	f000 fee1 	bl	c0d00e0a <try_context_set>
				{
					io_seproxyhal_init();
c0d00048:	f001 f97c 	bl	c0d01344 <io_seproxyhal_init>
c0d0004c:	2000      	movs	r0, #0
						// restart IOs
						BLE_power(1, NULL);
					}
#endif

					USB_power(0);
c0d0004e:	f003 ff33 	bl	c0d03eb8 <USB_power>
					USB_power(1);
c0d00052:	2001      	movs	r0, #1
c0d00054:	f003 ff30 	bl	c0d03eb8 <USB_power>

					// init the public key display to "no public key".
					//display_no_public_key();

					// show idle screen.
					ui_idle();
c0d00058:	f002 fbf8 	bl	c0d0284c <ui_idle>
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
c0d0006a:	f001 fc57 	bl	c0d0191c <snprintf>

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
c0d00072:	f001 f837 	bl	c0d010e4 <try_context_get>
c0d00076:	a901      	add	r1, sp, #4
c0d00078:	4288      	cmp	r0, r1
c0d0007a:	d103      	bne.n	c0d00084 <main+0x84>
c0d0007c:	f001 f834 	bl	c0d010e8 <try_context_get_previous>
c0d00080:	f000 fec3 	bl	c0d00e0a <try_context_set>
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
c0d00092:	f001 f822 	bl	c0d010da <os_longjmp>
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
c0d00104:	f001 fe7a 	bl	c0d01dfc <cx_hash>
c0d00108:	b002      	add	sp, #8
c0d0010a:	bd70      	pop	{r4, r5, r6, pc}
    case CX_SHA3_XOF:
        hsz =   ((cx_sha3_t*)hash)->output_size;
        break;
    
    default:
        THROW(INVALID_PARAMETER);
c0d0010c:	2002      	movs	r0, #2
c0d0010e:	f000 ffe4 	bl	c0d010da <os_longjmp>

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
c0d0018a:	f000 ffa6 	bl	c0d010da <os_longjmp>

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
c0d001bc:	f001 feae 	bl	c0d01f1c <cx_ecdsa_sign>
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
c0d001dc:	f001 ff18 	bl	c0d02010 <io_seproxyhal_spi_send>

			if (channel & IO_RESET_AFTER_REPLIED) {
c0d001e0:	b268      	sxtb	r0, r5
c0d001e2:	2800      	cmp	r0, #0
c0d001e4:	da09      	bge.n	c0d001fa <io_exchange_al+0x36>
				reset();
c0d001e6:	f001 fddd 	bl	c0d01da4 <reset>
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
c0d001f4:	f001 ff38 	bl	c0d02068 <io_seproxyhal_spi_recv>
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
c0d00206:	f000 ff68 	bl	c0d010da <os_longjmp>
c0d0020a:	46c0      	nop			; (mov r8, r8)
c0d0020c:	200018f8 	.word	0x200018f8
c0d00210:	20001f60 	.word	0x20001f60

c0d00214 <io_seproxyhal_display>:

	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
c0d00214:	b580      	push	{r7, lr}
	io_seproxyhal_display_default((bagl_element_t *) element);
c0d00216:	f001 fa07 	bl	c0d01628 <io_seproxyhal_display_default>
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
c0d00246:	f001 fb69 	bl	c0d0191c <snprintf>

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
c0d00258:	f001 feae 	bl	c0d01fb8 <os_ux>
c0d0025c:	61e0      	str	r0, [r4, #28]
c0d0025e:	f001 fb5b 	bl	c0d01918 <ux_check_status_default>
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
c0d0027a:	f001 f88f 	bl	c0d0139c <io_seproxyhal_init_ux>
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
c0d002b8:	f001 fb30 	bl	c0d0191c <snprintf>
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
c0d002c6:	f001 f869 	bl	c0d0139c <io_seproxyhal_init_ux>
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
c0d002e6:	f001 fea9 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
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
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *) element);
c0d00310:	f001 f98a 	bl	c0d01628 <io_seproxyhal_display_default>

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
c0d00338:	f001 faf0 	bl	c0d0191c <snprintf>
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
c0d0034a:	f001 fe35 	bl	c0d01fb8 <os_ux>
c0d0034e:	61e0      	str	r0, [r4, #28]
c0d00350:	f001 fae2 	bl	c0d01918 <ux_check_status_default>
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
c0d0036c:	f001 f816 	bl	c0d0139c <io_seproxyhal_init_ux>
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
c0d0039e:	f001 fe0b 	bl	c0d01fb8 <os_ux>
c0d003a2:	61e0      	str	r0, [r4, #28]
c0d003a4:	f001 fab8 	bl	c0d01918 <ux_check_status_default>
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
c0d003d2:	f001 fe33 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
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
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *) element);
c0d003fe:	f001 f913 	bl	c0d01628 <io_seproxyhal_display_default>
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
c0d0041e:	f001 fdcb 	bl	c0d01fb8 <os_ux>
c0d00422:	61e0      	str	r0, [r4, #28]
c0d00424:	f001 fa78 	bl	c0d01918 <ux_check_status_default>
c0d00428:	69e0      	ldr	r0, [r4, #28]
c0d0042a:	49d1      	ldr	r1, [pc, #836]	; (c0d00770 <io_event+0x554>)
c0d0042c:	4288      	cmp	r0, r1
c0d0042e:	d000      	beq.n	c0d00432 <io_event+0x216>
c0d00430:	e08e      	b.n	c0d00550 <io_event+0x334>
c0d00432:	f000 ffb3 	bl	c0d0139c <io_seproxyhal_init_ux>
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
c0d00452:	f001 fdf3 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
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
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *) element);
c0d0047e:	f001 f8d3 	bl	c0d01628 <io_seproxyhal_display_default>
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
c0d00498:	f001 fdd0 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
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
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *) element);
c0d004c4:	f001 f8b0 	bl	c0d01628 <io_seproxyhal_display_default>

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
c0d004de:	f001 fdad 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
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
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *) element);
c0d0050a:	f001 f88d 	bl	c0d01628 <io_seproxyhal_display_default>
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
c0d00534:	f000 ff32 	bl	c0d0139c <io_seproxyhal_init_ux>
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
c0d00562:	f001 fd6b 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
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
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *) element);
c0d0058e:	f001 f84b 	bl	c0d01628 <io_seproxyhal_display_default>
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
c0d005a8:	f001 fd48 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
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
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *) element);
c0d005d4:	f001 f828 	bl	c0d01628 <io_seproxyhal_display_default>
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
c0d0062e:	f000 ff2d 	bl	c0d0148c <io_seproxyhal_touch_element_callback>
c0d00632:	6820      	ldr	r0, [r4, #0]
c0d00634:	2800      	cmp	r0, #0
c0d00636:	d058      	beq.n	c0d006ea <io_event+0x4ce>
c0d00638:	68a0      	ldr	r0, [r4, #8]
c0d0063a:	6861      	ldr	r1, [r4, #4]
c0d0063c:	4288      	cmp	r0, r1
c0d0063e:	d254      	bcs.n	c0d006ea <io_event+0x4ce>
c0d00640:	f001 fcfc 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
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
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *) element);
c0d0066a:	f000 ffdd 	bl	c0d01628 <io_seproxyhal_display_default>

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
c0d0069e:	f001 f805 	bl	c0d016ac <io_seproxyhal_button_push>
c0d006a2:	6820      	ldr	r0, [r4, #0]
c0d006a4:	2800      	cmp	r0, #0
c0d006a6:	d020      	beq.n	c0d006ea <io_event+0x4ce>
c0d006a8:	68a0      	ldr	r0, [r4, #8]
c0d006aa:	6861      	ldr	r1, [r4, #4]
c0d006ac:	4288      	cmp	r0, r1
c0d006ae:	d21c      	bcs.n	c0d006ea <io_event+0x4ce>
c0d006b0:	f001 fcc4 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
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
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *) element);
c0d006da:	f000 ffa5 	bl	c0d01628 <io_seproxyhal_display_default>
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
c0d006f2:	f001 fca3 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d006f6:	e02e      	b.n	c0d00756 <io_event+0x53a>
		if (publicKeyNeedsRefresh == 1) {
			UX_REDISPLAY();
			publicKeyNeedsRefresh = 0;
		} else {
			if (Timer_Expired()) {
				os_sched_exit(0);
c0d006f8:	2000      	movs	r0, #0
c0d006fa:	f001 fc47 	bl	c0d01f8c <os_sched_exit>
c0d006fe:	e02a      	b.n	c0d00756 <io_event+0x53a>
	case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
		//Timer_Restart();
		if (UX_DISPLAYED()) {
			// perform actions after all screen elements have been displayed
		} else {
			UX_DISPLAYED_EVENT();
c0d00700:	f000 fe4c 	bl	c0d0139c <io_seproxyhal_init_ux>
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
c0d0071c:	f001 fc8e 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
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
	return_to_dashboard: return;
}

/** display function */
void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *) element);
c0d00746:	f000 ff6f 	bl	c0d01628 <io_seproxyhal_display_default>
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
c0d00756:	f001 fc71 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d0075a:	2800      	cmp	r0, #0
c0d0075c:	d101      	bne.n	c0d00762 <io_event+0x546>
		io_seproxyhal_general_status();
c0d0075e:	f000 fcc9 	bl	c0d010f4 <io_seproxyhal_general_status>
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
c0d00780:	4fe3      	ldr	r7, [pc, #908]	; (c0d00b10 <ont_main+0x39c>)
c0d00782:	4eed      	ldr	r6, [pc, #948]	; (c0d00b38 <ont_main+0x3c4>)
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
c0d0078c:	f003 fd46 	bl	c0d0421c <setjmp>
c0d00790:	8520      	strh	r0, [r4, #40]	; 0x28
c0d00792:	49dd      	ldr	r1, [pc, #884]	; (c0d00b08 <ont_main+0x394>)
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
c0d007b0:	d171      	bne.n	c0d00896 <ont_main+0x122>
c0d007b2:	a961      	add	r1, sp, #388	; 0x184
						case 0x6000:
						case 0x9000:
							sw = e;
c0d007b4:	8008      	strh	r0, [r1, #0]
c0d007b6:	e075      	b.n	c0d008a4 <ont_main+0x130>
c0d007b8:	a856      	add	r0, sp, #344	; 0x158
	for (;;) {
		volatile unsigned short sw = 0;

		BEGIN_TRY
			{
				TRY
c0d007ba:	f000 fb26 	bl	c0d00e0a <try_context_set>
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
c0d007ce:	f000 ffa7 	bl	c0d01720 <io_exchange>
c0d007d2:	9064      	str	r0, [sp, #400]	; 0x190
						flags = 0;
c0d007d4:	9462      	str	r4, [sp, #392]	; 0x188

						// no apdu received, well, reset the session, and reset the
						// bootloader configuration
						if (rx == 0) {
c0d007d6:	9864      	ldr	r0, [sp, #400]	; 0x190
c0d007d8:	2800      	cmp	r0, #0
c0d007da:	d100      	bne.n	c0d007de <ont_main+0x6a>
c0d007dc:	e166      	b.n	c0d00aac <ont_main+0x338>
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
c0d007e6:	e167      	b.n	c0d00ab8 <ont_main+0x344>
c0d007e8:	7879      	ldrb	r1, [r7, #1]
c0d007ea:	206d      	movs	r0, #109	; 0x6d
c0d007ec:	0200      	lsls	r0, r0, #8
c0d007ee:	9006      	str	r0, [sp, #24]
c0d007f0:	2009      	movs	r0, #9
c0d007f2:	0302      	lsls	r2, r0, #12
c0d007f4:	48c8      	ldr	r0, [pc, #800]	; (c0d00b18 <ont_main+0x3a4>)
							hashTainted = 1;
							THROW(0x6E00);
						}

						// check the second byte (0x01) for the instruction.
						switch (G_io_apdu_buffer[1]) {
c0d007f6:	2907      	cmp	r1, #7
c0d007f8:	dc6f      	bgt.n	c0d008da <ont_main+0x166>
c0d007fa:	2902      	cmp	r1, #2
c0d007fc:	d174      	bne.n	c0d008e8 <ont_main+0x174>
	exit_timer = MAX_EXIT_TIMER;
	Timer_UpdateDescription();
}

static void Timer_Restart() {
	if (exit_timer != MAX_EXIT_TIMER) {
c0d007fe:	49c7      	ldr	r1, [pc, #796]	; (c0d00b1c <ont_main+0x3a8>)
c0d00800:	6809      	ldr	r1, [r1, #0]
c0d00802:	4281      	cmp	r1, r0
c0d00804:	4cc3      	ldr	r4, [pc, #780]	; (c0d00b14 <ont_main+0x3a0>)
c0d00806:	d00a      	beq.n	c0d0081e <ont_main+0xaa>
		Timer_UpdateDescription();
	}
}

static void Timer_Set() {
	exit_timer = MAX_EXIT_TIMER;
c0d00808:	49c4      	ldr	r1, [pc, #784]	; (c0d00b1c <ont_main+0x3a8>)
c0d0080a:	6008      	str	r0, [r1, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
	snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d0080c:	2104      	movs	r1, #4
c0d0080e:	461c      	mov	r4, r3
c0d00810:	2308      	movs	r3, #8
c0d00812:	48c3      	ldr	r0, [pc, #780]	; (c0d00b20 <ont_main+0x3ac>)
c0d00814:	a2c3      	add	r2, pc, #780	; (adr r2, c0d00b24 <ont_main+0x3b0>)
c0d00816:	f001 f881 	bl	c0d0191c <snprintf>
c0d0081a:	4623      	mov	r3, r4
c0d0081c:	4cbd      	ldr	r4, [pc, #756]	; (c0d00b14 <ont_main+0x3a0>)
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
c0d00828:	e153      	b.n	c0d00ad2 <ont_main+0x35e>
								hashTainted = 1;
								THROW(0x6A86);
							}

							// if this is the first transaction part, reset the hash and all the other temporary variables.
							if (hashTainted) {
c0d0082a:	7820      	ldrb	r0, [r4, #0]
c0d0082c:	2800      	cmp	r0, #0
c0d0082e:	d007      	beq.n	c0d00840 <ont_main+0xcc>
								cx_sha256_init(&hash);
c0d00830:	48c0      	ldr	r0, [pc, #768]	; (c0d00b34 <ont_main+0x3c0>)
c0d00832:	f001 fb15 	bl	c0d01e60 <cx_sha256_init>
c0d00836:	2000      	movs	r0, #0
								hashTainted = 0;
c0d00838:	7020      	strb	r0, [r4, #0]
								raw_tx_ix = 0;
c0d0083a:	6030      	str	r0, [r6, #0]
								raw_tx_len = 0;
c0d0083c:	49bf      	ldr	r1, [pc, #764]	; (c0d00b3c <ont_main+0x3c8>)
c0d0083e:	6008      	str	r0, [r1, #0]
							}

							// move the contents of the buffer into raw_tx, and update raw_tx_ix to the end of the buffer, to be ready for the next part of the tx.
							unsigned int len = get_apdu_buffer_length();
c0d00840:	f002 f96c 	bl	c0d02b1c <get_apdu_buffer_length>
c0d00844:	4604      	mov	r4, r0
							unsigned char * in = G_io_apdu_buffer + APDU_HEADER_LENGTH;
							unsigned char * out = raw_tx + raw_tx_ix;
c0d00846:	6830      	ldr	r0, [r6, #0]
							if (raw_tx_ix + len > MAX_TX_RAW_LENGTH) {
c0d00848:	1901      	adds	r1, r0, r4
c0d0084a:	4abd      	ldr	r2, [pc, #756]	; (c0d00b40 <ont_main+0x3cc>)
c0d0084c:	4291      	cmp	r1, r2
c0d0084e:	d300      	bcc.n	c0d00852 <ont_main+0xde>
c0d00850:	e144      	b.n	c0d00adc <ont_main+0x368>
							}

							// move the contents of the buffer into raw_tx, and update raw_tx_ix to the end of the buffer, to be ready for the next part of the tx.
							unsigned int len = get_apdu_buffer_length();
							unsigned char * in = G_io_apdu_buffer + APDU_HEADER_LENGTH;
							unsigned char * out = raw_tx + raw_tx_ix;
c0d00852:	49bc      	ldr	r1, [pc, #752]	; (c0d00b44 <ont_main+0x3d0>)
c0d00854:	1808      	adds	r0, r1, r0
							if (raw_tx_ix + len > MAX_TX_RAW_LENGTH) {
								hashTainted = 1;
								THROW(0x6D08);
							}
							os_memmove(out, in, len);
c0d00856:	1d79      	adds	r1, r7, #5
c0d00858:	4622      	mov	r2, r4
c0d0085a:	f000 fb8a 	bl	c0d00f72 <os_memmove>
							raw_tx_ix += len;
c0d0085e:	6830      	ldr	r0, [r6, #0]
c0d00860:	1901      	adds	r1, r0, r4
c0d00862:	6031      	str	r1, [r6, #0]
c0d00864:	2200      	movs	r2, #0

							// set the screen to be the first screen.
							curr_scr_ix = 0;
c0d00866:	48b8      	ldr	r0, [pc, #736]	; (c0d00b48 <ont_main+0x3d4>)
c0d00868:	6002      	str	r2, [r0, #0]
							unsigned char * out = raw_tx + raw_tx_ix;
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
c0d00874:	d105      	bne.n	c0d00882 <ont_main+0x10e>
								raw_tx_len = raw_tx_ix;
c0d00876:	48b1      	ldr	r0, [pc, #708]	; (c0d00b3c <ont_main+0x3c8>)
c0d00878:	6001      	str	r1, [r0, #0]
								raw_tx_ix = 0;
c0d0087a:	6032      	str	r2, [r6, #0]

								// parse the transaction into human readable text.
								//display_tx_desc();

								// display the UI, starting at the top screen which is "Sign Tx Now".
								ui_top_sign();
c0d0087c:	f002 f896 	bl	c0d029ac <ui_top_sign>
c0d00880:	78b8      	ldrb	r0, [r7, #2]
							}

							flags |= IO_ASYNCH_REPLY;
c0d00882:	2110      	movs	r1, #16
c0d00884:	9a62      	ldr	r2, [sp, #392]	; 0x188
c0d00886:	430a      	orrs	r2, r1
c0d00888:	9262      	str	r2, [sp, #392]	; 0x188

							// if this is not the last part of the transaction, do not display the UI, and approve the partial transaction.
							// this adds the TX to the hash.
							if (G_io_apdu_buffer[2] == P1_MORE) {
c0d0088a:	2800      	cmp	r0, #0
c0d0088c:	d115      	bne.n	c0d008ba <ont_main+0x146>
								io_seproxyhal_touch_approve(NULL);
c0d0088e:	2000      	movs	r0, #0
c0d00890:	f001 ff58 	bl	c0d02744 <io_seproxyhal_touch_approve>
c0d00894:	e011      	b.n	c0d008ba <ont_main+0x146>
						case 0x6000:
						case 0x9000:
							sw = e;
							break;
						default:
							sw = 0x6800 | (e & 0x7FF);
c0d00896:	499d      	ldr	r1, [pc, #628]	; (c0d00b0c <ont_main+0x398>)
c0d00898:	4008      	ands	r0, r1
c0d0089a:	210d      	movs	r1, #13
c0d0089c:	02c9      	lsls	r1, r1, #11
c0d0089e:	4301      	orrs	r1, r0
c0d008a0:	a861      	add	r0, sp, #388	; 0x184
c0d008a2:	8001      	strh	r1, [r0, #0]
							break;
						}
						// Unexpected exception => report
						G_io_apdu_buffer[tx] = sw >> 8;
c0d008a4:	9861      	ldr	r0, [sp, #388]	; 0x184
c0d008a6:	0a00      	lsrs	r0, r0, #8
c0d008a8:	9963      	ldr	r1, [sp, #396]	; 0x18c
c0d008aa:	5478      	strb	r0, [r7, r1]
						G_io_apdu_buffer[tx + 1] = sw;
c0d008ac:	9861      	ldr	r0, [sp, #388]	; 0x184
c0d008ae:	9963      	ldr	r1, [sp, #396]	; 0x18c
						default:
							sw = 0x6800 | (e & 0x7FF);
							break;
						}
						// Unexpected exception => report
						G_io_apdu_buffer[tx] = sw >> 8;
c0d008b0:	1879      	adds	r1, r7, r1
						G_io_apdu_buffer[tx + 1] = sw;
c0d008b2:	7048      	strb	r0, [r1, #1]
						tx += 2;
c0d008b4:	9863      	ldr	r0, [sp, #396]	; 0x18c
c0d008b6:	1c80      	adds	r0, r0, #2
c0d008b8:	9063      	str	r0, [sp, #396]	; 0x18c
					}
					FINALLY
c0d008ba:	f000 fc13 	bl	c0d010e4 <try_context_get>
c0d008be:	a956      	add	r1, sp, #344	; 0x158
c0d008c0:	4288      	cmp	r0, r1
c0d008c2:	d103      	bne.n	c0d008cc <ont_main+0x158>
c0d008c4:	f000 fc10 	bl	c0d010e8 <try_context_get_previous>
c0d008c8:	f000 fa9f 	bl	c0d00e0a <try_context_set>
c0d008cc:	a856      	add	r0, sp, #344	; 0x158
				{
				}
			}
			END_TRY;
c0d008ce:	8d00      	ldrh	r0, [r0, #40]	; 0x28
c0d008d0:	2800      	cmp	r0, #0
c0d008d2:	d100      	bne.n	c0d008d6 <ont_main+0x162>
c0d008d4:	e756      	b.n	c0d00784 <ont_main+0x10>
c0d008d6:	f000 fc00 	bl	c0d010da <os_longjmp>
c0d008da:	2908      	cmp	r1, #8
c0d008dc:	d060      	beq.n	c0d009a0 <ont_main+0x22c>
c0d008de:	29ff      	cmp	r1, #255	; 0xff
c0d008e0:	d000      	beq.n	c0d008e4 <ont_main+0x170>
c0d008e2:	e0f0      	b.n	c0d00ac6 <ont_main+0x352>
	}

	return_to_dashboard: return;
}
c0d008e4:	b065      	add	sp, #404	; 0x194
c0d008e6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d008e8:	2904      	cmp	r1, #4
c0d008ea:	d000      	beq.n	c0d008ee <ont_main+0x17a>
c0d008ec:	e0eb      	b.n	c0d00ac6 <ont_main+0x352>
c0d008ee:	4b8b      	ldr	r3, [pc, #556]	; (c0d00b1c <ont_main+0x3a8>)
	exit_timer = MAX_EXIT_TIMER;
	Timer_UpdateDescription();
}

static void Timer_Restart() {
	if (exit_timer != MAX_EXIT_TIMER) {
c0d008f0:	6819      	ldr	r1, [r3, #0]
c0d008f2:	4281      	cmp	r1, r0
c0d008f4:	d008      	beq.n	c0d00908 <ont_main+0x194>
		Timer_UpdateDescription();
	}
}

static void Timer_Set() {
	exit_timer = MAX_EXIT_TIMER;
c0d008f6:	6018      	str	r0, [r3, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
	snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d008f8:	4889      	ldr	r0, [pc, #548]	; (c0d00b20 <ont_main+0x3ac>)
c0d008fa:	2104      	movs	r1, #4
c0d008fc:	4614      	mov	r4, r2
c0d008fe:	a289      	add	r2, pc, #548	; (adr r2, c0d00b24 <ont_main+0x3b0>)
c0d00900:	2308      	movs	r3, #8
c0d00902:	f001 f80b 	bl	c0d0191c <snprintf>
c0d00906:	4622      	mov	r2, r4
							Timer_Restart();

							cx_ecfp_public_key_t publicKey;
							cx_ecfp_private_key_t privateKey;

							if (rx < APDU_HEADER_LENGTH + BIP44_BYTE_LENGTH) {
c0d00908:	9864      	ldr	r0, [sp, #400]	; 0x190
c0d0090a:	2818      	cmp	r0, #24
c0d0090c:	d800      	bhi.n	c0d00910 <ont_main+0x19c>
c0d0090e:	e0ec      	b.n	c0d00aea <ont_main+0x376>
c0d00910:	9208      	str	r2, [sp, #32]
c0d00912:	2000      	movs	r0, #0
							unsigned char * bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;

							unsigned int bip44_path[BIP44_PATH_LEN];
							uint32_t i;
							for (i = 0; i < BIP44_PATH_LEN; i++) {
								bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
c0d00914:	0081      	lsls	r1, r0, #2
c0d00916:	187a      	adds	r2, r7, r1
c0d00918:	7953      	ldrb	r3, [r2, #5]
c0d0091a:	061b      	lsls	r3, r3, #24
c0d0091c:	7994      	ldrb	r4, [r2, #6]
c0d0091e:	0424      	lsls	r4, r4, #16
c0d00920:	431c      	orrs	r4, r3
c0d00922:	79d3      	ldrb	r3, [r2, #7]
c0d00924:	021b      	lsls	r3, r3, #8
c0d00926:	4323      	orrs	r3, r4
c0d00928:	7a12      	ldrb	r2, [r2, #8]
c0d0092a:	431a      	orrs	r2, r3
c0d0092c:	ab2c      	add	r3, sp, #176	; 0xb0
c0d0092e:	505a      	str	r2, [r3, r1]
							/** BIP44 path, used to derive the private key from the mnemonic by calling os_perso_derive_node_bip32. */
							unsigned char * bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;

							unsigned int bip44_path[BIP44_PATH_LEN];
							uint32_t i;
							for (i = 0; i < BIP44_PATH_LEN; i++) {
c0d00930:	1c40      	adds	r0, r0, #1
c0d00932:	2805      	cmp	r0, #5
c0d00934:	d1ee      	bne.n	c0d00914 <ont_main+0x1a0>
c0d00936:	2500      	movs	r5, #0
								bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
								bip44_in += 4;
							}
							unsigned char privateKeyData[32];
							os_perso_derive_node_bip32(CX_CURVE_256R1, bip44_path, BIP44_PATH_LEN, privateKeyData, NULL);
c0d00938:	4668      	mov	r0, sp
c0d0093a:	6005      	str	r5, [r0, #0]
c0d0093c:	2622      	movs	r6, #34	; 0x22
c0d0093e:	a92c      	add	r1, sp, #176	; 0xb0
c0d00940:	2205      	movs	r2, #5
c0d00942:	af39      	add	r7, sp, #228	; 0xe4
c0d00944:	4630      	mov	r0, r6
c0d00946:	463b      	mov	r3, r7
c0d00948:	f001 fb08 	bl	c0d01f5c <os_perso_derive_node_bip32>
							cx_ecdsa_init_private_key(CX_CURVE_256R1, privateKeyData, 32, &privateKey);
c0d0094c:	2220      	movs	r2, #32
c0d0094e:	ac43      	add	r4, sp, #268	; 0x10c
c0d00950:	4630      	mov	r0, r6
c0d00952:	4639      	mov	r1, r7
c0d00954:	4623      	mov	r3, r4
c0d00956:	f001 fab1 	bl	c0d01ebc <cx_ecfp_init_private_key>
c0d0095a:	af09      	add	r7, sp, #36	; 0x24

							// generate the public key.
							cx_ecdsa_init_public_key(CX_CURVE_256R1, NULL, 0, &publicKey);
c0d0095c:	4630      	mov	r0, r6
c0d0095e:	4629      	mov	r1, r5
c0d00960:	462a      	mov	r2, r5
c0d00962:	463b      	mov	r3, r7
c0d00964:	f001 fa92 	bl	c0d01e8c <cx_ecfp_init_public_key>
c0d00968:	2501      	movs	r5, #1
							cx_ecfp_generate_pair(CX_CURVE_256R1, &publicKey, &privateKey, 1);
c0d0096a:	4630      	mov	r0, r6
c0d0096c:	4639      	mov	r1, r7
c0d0096e:	4622      	mov	r2, r4
c0d00970:	462b      	mov	r3, r5
c0d00972:	f001 fabb 	bl	c0d01eec <cx_ecfp_generate_pair>

							// push the public key onto the response buffer.
							os_memmove(G_io_apdu_buffer, publicKey.W, 65);
c0d00976:	3708      	adds	r7, #8
c0d00978:	4865      	ldr	r0, [pc, #404]	; (c0d00b10 <ont_main+0x39c>)
c0d0097a:	2441      	movs	r4, #65	; 0x41
c0d0097c:	4639      	mov	r1, r7
c0d0097e:	4622      	mov	r2, r4
c0d00980:	f000 faf7 	bl	c0d00f72 <os_memmove>
							tx = 65;
c0d00984:	9463      	str	r4, [sp, #396]	; 0x18c

							display_public_key(publicKey.W);
c0d00986:	4638      	mov	r0, r7
c0d00988:	f000 f942 	bl	c0d00c10 <display_public_key>
	return 0;
}

/** refreshes the display if the public key was changed ans we are on the page displaying the public key */
static void refresh_public_key_display(void) {
	if ((uiState == UI_PUBLIC_KEY_1)|| (uiState == UI_PUBLIC_KEY_2)) {
c0d0098c:	4866      	ldr	r0, [pc, #408]	; (c0d00b28 <ont_main+0x3b4>)
c0d0098e:	7800      	ldrb	r0, [r0, #0]
c0d00990:	1fc0      	subs	r0, r0, #7
c0d00992:	b2c0      	uxtb	r0, r0
c0d00994:	2801      	cmp	r0, #1
c0d00996:	d900      	bls.n	c0d0099a <ont_main+0x226>
c0d00998:	e085      	b.n	c0d00aa6 <ont_main+0x332>
		publicKeyNeedsRefresh = 1;
c0d0099a:	4864      	ldr	r0, [pc, #400]	; (c0d00b2c <ont_main+0x3b8>)
c0d0099c:	7005      	strb	r5, [r0, #0]
c0d0099e:	e082      	b.n	c0d00aa6 <ont_main+0x332>
c0d009a0:	9208      	str	r2, [sp, #32]
c0d009a2:	4a5e      	ldr	r2, [pc, #376]	; (c0d00b1c <ont_main+0x3a8>)
	exit_timer = MAX_EXIT_TIMER;
	Timer_UpdateDescription();
}

static void Timer_Restart() {
	if (exit_timer != MAX_EXIT_TIMER) {
c0d009a4:	6811      	ldr	r1, [r2, #0]
c0d009a6:	4281      	cmp	r1, r0
c0d009a8:	d008      	beq.n	c0d009bc <ont_main+0x248>
		Timer_UpdateDescription();
	}
}

static void Timer_Set() {
	exit_timer = MAX_EXIT_TIMER;
c0d009aa:	6010      	str	r0, [r2, #0]
#define MAX_EXIT_TIMER 4098

#define EXIT_TIMER_REFRESH_INTERVAL 512

static void Timer_UpdateDescription() {
	snprintf(timer_desc, MAX_TIMER_TEXT_WIDTH, "%d", exit_timer / EXIT_TIMER_REFRESH_INTERVAL);
c0d009ac:	485c      	ldr	r0, [pc, #368]	; (c0d00b20 <ont_main+0x3ac>)
c0d009ae:	2104      	movs	r1, #4
c0d009b0:	a25c      	add	r2, pc, #368	; (adr r2, c0d00b24 <ont_main+0x3b0>)
c0d009b2:	461d      	mov	r5, r3
c0d009b4:	2308      	movs	r3, #8
c0d009b6:	f000 ffb1 	bl	c0d0191c <snprintf>
c0d009ba:	462b      	mov	r3, r5
							Timer_Restart();

							cx_ecfp_public_key_t publicKey;
							cx_ecfp_private_key_t privateKey;

							if (rx < APDU_HEADER_LENGTH + BIP44_BYTE_LENGTH) {
c0d009bc:	9864      	ldr	r0, [sp, #400]	; 0x190
c0d009be:	2818      	cmp	r0, #24
c0d009c0:	d800      	bhi.n	c0d009c4 <ont_main+0x250>
c0d009c2:	e099      	b.n	c0d00af8 <ont_main+0x384>
c0d009c4:	9307      	str	r3, [sp, #28]
							unsigned char * bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;

							unsigned int bip44_path[BIP44_PATH_LEN];
							uint32_t i;
							for (i = 0; i < BIP44_PATH_LEN; i++) {
								bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
c0d009c6:	00a0      	lsls	r0, r4, #2
c0d009c8:	1839      	adds	r1, r7, r0
c0d009ca:	794a      	ldrb	r2, [r1, #5]
c0d009cc:	0612      	lsls	r2, r2, #24
c0d009ce:	798b      	ldrb	r3, [r1, #6]
c0d009d0:	041b      	lsls	r3, r3, #16
c0d009d2:	4313      	orrs	r3, r2
c0d009d4:	79ca      	ldrb	r2, [r1, #7]
c0d009d6:	0212      	lsls	r2, r2, #8
c0d009d8:	431a      	orrs	r2, r3
c0d009da:	7a09      	ldrb	r1, [r1, #8]
c0d009dc:	4311      	orrs	r1, r2
c0d009de:	aa34      	add	r2, sp, #208	; 0xd0
c0d009e0:	5011      	str	r1, [r2, r0]
							/** BIP44 path, used to derive the private key from the mnemonic by calling os_perso_derive_node_bip32. */
							unsigned char * bip44_in = G_io_apdu_buffer + APDU_HEADER_LENGTH;

							unsigned int bip44_path[BIP44_PATH_LEN];
							uint32_t i;
							for (i = 0; i < BIP44_PATH_LEN; i++) {
c0d009e2:	1c64      	adds	r4, r4, #1
c0d009e4:	2c05      	cmp	r4, #5
c0d009e6:	d1ee      	bne.n	c0d009c6 <ont_main+0x252>
c0d009e8:	2400      	movs	r4, #0
								bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
								bip44_in += 4;
							}
							unsigned char privateKeyData[32];
							os_perso_derive_node_bip32(CX_CURVE_256R1, bip44_path, BIP44_PATH_LEN, privateKeyData, NULL);
c0d009ea:	4668      	mov	r0, sp
c0d009ec:	6004      	str	r4, [r0, #0]
c0d009ee:	2522      	movs	r5, #34	; 0x22
c0d009f0:	a934      	add	r1, sp, #208	; 0xd0
c0d009f2:	2205      	movs	r2, #5
c0d009f4:	ae2c      	add	r6, sp, #176	; 0xb0
c0d009f6:	4628      	mov	r0, r5
c0d009f8:	4633      	mov	r3, r6
c0d009fa:	f001 faaf 	bl	c0d01f5c <os_perso_derive_node_bip32>
							cx_ecdsa_init_private_key(CX_CURVE_256R1, privateKeyData, 32, &privateKey);
c0d009fe:	2220      	movs	r2, #32
c0d00a00:	ab39      	add	r3, sp, #228	; 0xe4
c0d00a02:	4628      	mov	r0, r5
c0d00a04:	4631      	mov	r1, r6
c0d00a06:	9204      	str	r2, [sp, #16]
c0d00a08:	461e      	mov	r6, r3
c0d00a0a:	f001 fa57 	bl	c0d01ebc <cx_ecfp_init_private_key>
c0d00a0e:	af43      	add	r7, sp, #268	; 0x10c

							// generate the public key.
							cx_ecdsa_init_public_key(CX_CURVE_256R1, NULL, 0, &publicKey);
c0d00a10:	4628      	mov	r0, r5
c0d00a12:	4621      	mov	r1, r4
c0d00a14:	9405      	str	r4, [sp, #20]
c0d00a16:	4622      	mov	r2, r4
c0d00a18:	463b      	mov	r3, r7
c0d00a1a:	f001 fa37 	bl	c0d01e8c <cx_ecfp_init_public_key>
c0d00a1e:	2301      	movs	r3, #1
							cx_ecfp_generate_pair(CX_CURVE_256R1, &publicKey, &privateKey, 1);
c0d00a20:	4628      	mov	r0, r5
c0d00a22:	4639      	mov	r1, r7
c0d00a24:	4632      	mov	r2, r6
c0d00a26:	461e      	mov	r6, r3
c0d00a28:	f001 fa60 	bl	c0d01eec <cx_ecfp_generate_pair>

							// push the public key onto the response buffer.
							os_memmove(G_io_apdu_buffer, publicKey.W, 65);
c0d00a2c:	3708      	adds	r7, #8
c0d00a2e:	4d38      	ldr	r5, [pc, #224]	; (c0d00b10 <ont_main+0x39c>)
c0d00a30:	2441      	movs	r4, #65	; 0x41
c0d00a32:	4628      	mov	r0, r5
c0d00a34:	4639      	mov	r1, r7
c0d00a36:	4622      	mov	r2, r4
c0d00a38:	f000 fa9b 	bl	c0d00f72 <os_memmove>
							tx = 65;
c0d00a3c:	9463      	str	r4, [sp, #396]	; 0x18c

							display_public_key(publicKey.W);
c0d00a3e:	4638      	mov	r0, r7
c0d00a40:	f000 f8e6 	bl	c0d00c10 <display_public_key>
	return 0;
}

/** refreshes the display if the public key was changed ans we are on the page displaying the public key */
static void refresh_public_key_display(void) {
	if ((uiState == UI_PUBLIC_KEY_1)|| (uiState == UI_PUBLIC_KEY_2)) {
c0d00a44:	4838      	ldr	r0, [pc, #224]	; (c0d00b28 <ont_main+0x3b4>)
c0d00a46:	7800      	ldrb	r0, [r0, #0]
c0d00a48:	1fc0      	subs	r0, r0, #7
c0d00a4a:	b2c0      	uxtb	r0, r0
c0d00a4c:	2801      	cmp	r0, #1
c0d00a4e:	d801      	bhi.n	c0d00a54 <ont_main+0x2e0>
		publicKeyNeedsRefresh = 1;
c0d00a50:	4836      	ldr	r0, [pc, #216]	; (c0d00b2c <ont_main+0x3b8>)
c0d00a52:	7006      	strb	r6, [r0, #0]
							tx = 65;

							display_public_key(publicKey.W);
							refresh_public_key_display();

							G_io_apdu_buffer[tx++] = 0xFF;
c0d00a54:	9863      	ldr	r0, [sp, #396]	; 0x18c
c0d00a56:	1c41      	adds	r1, r0, #1
c0d00a58:	9163      	str	r1, [sp, #396]	; 0x18c
c0d00a5a:	9a07      	ldr	r2, [sp, #28]
c0d00a5c:	327f      	adds	r2, #127	; 0x7f
c0d00a5e:	542a      	strb	r2, [r5, r0]
							G_io_apdu_buffer[tx++] = 0xFF;
c0d00a60:	9863      	ldr	r0, [sp, #396]	; 0x18c
c0d00a62:	1c41      	adds	r1, r0, #1
c0d00a64:	9163      	str	r1, [sp, #396]	; 0x18c
c0d00a66:	542a      	strb	r2, [r5, r0]
c0d00a68:	ac09      	add	r4, sp, #36	; 0x24

							unsigned char result[32];

							cx_sha256_t pubKeyHash;
							cx_sha256_init(&pubKeyHash);
c0d00a6a:	4620      	mov	r0, r4
c0d00a6c:	f001 f9f8 	bl	c0d01e60 <cx_sha256_init>
c0d00a70:	462e      	mov	r6, r5
c0d00a72:	ad24      	add	r5, sp, #144	; 0x90

							cx_hash(&pubKeyHash.header, CX_LAST, publicKey.W, 65, result);
c0d00a74:	4668      	mov	r0, sp
c0d00a76:	6005      	str	r5, [r0, #0]
							tx = 65;

							display_public_key(publicKey.W);
							refresh_public_key_display();

							G_io_apdu_buffer[tx++] = 0xFF;
c0d00a78:	2101      	movs	r1, #1
							unsigned char result[32];

							cx_sha256_t pubKeyHash;
							cx_sha256_init(&pubKeyHash);

							cx_hash(&pubKeyHash.header, CX_LAST, publicKey.W, 65, result);
c0d00a7a:	2341      	movs	r3, #65	; 0x41
c0d00a7c:	4620      	mov	r0, r4
c0d00a7e:	463a      	mov	r2, r7
c0d00a80:	f7ff fb20 	bl	c0d000c4 <cx_hash_X>
							tx += cx_ecdsa_sign((void*) &privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, result, sizeof(result), G_io_apdu_buffer + tx, NULL);
c0d00a84:	9863      	ldr	r0, [sp, #396]	; 0x18c
c0d00a86:	4669      	mov	r1, sp
c0d00a88:	1830      	adds	r0, r6, r0
c0d00a8a:	9a04      	ldr	r2, [sp, #16]
c0d00a8c:	600a      	str	r2, [r1, #0]
c0d00a8e:	6048      	str	r0, [r1, #4]
c0d00a90:	9805      	ldr	r0, [sp, #20]
c0d00a92:	6088      	str	r0, [r1, #8]
c0d00a94:	a839      	add	r0, sp, #228	; 0xe4
c0d00a96:	4926      	ldr	r1, [pc, #152]	; (c0d00b30 <ont_main+0x3bc>)
c0d00a98:	2203      	movs	r2, #3
c0d00a9a:	462b      	mov	r3, r5
c0d00a9c:	f7ff fb77 	bl	c0d0018e <cx_ecdsa_sign_X>
c0d00aa0:	9963      	ldr	r1, [sp, #396]	; 0x18c
c0d00aa2:	1808      	adds	r0, r1, r0
c0d00aa4:	9063      	str	r0, [sp, #396]	; 0x18c
c0d00aa6:	9808      	ldr	r0, [sp, #32]
c0d00aa8:	f000 fb17 	bl	c0d010da <os_longjmp>
						flags = 0;

						// no apdu received, well, reset the session, and reset the
						// bootloader configuration
						if (rx == 0) {
							hashTainted = 1;
c0d00aac:	2001      	movs	r0, #1
c0d00aae:	4919      	ldr	r1, [pc, #100]	; (c0d00b14 <ont_main+0x3a0>)
c0d00ab0:	7008      	strb	r0, [r1, #0]
							THROW(0x6982);
c0d00ab2:	4827      	ldr	r0, [pc, #156]	; (c0d00b50 <ont_main+0x3dc>)
c0d00ab4:	f000 fb11 	bl	c0d010da <os_longjmp>
						}

						// if the buffer doesn't start with the magic byte, return an error.
						if (G_io_apdu_buffer[0] != CLA) {
							hashTainted = 1;
c0d00ab8:	2001      	movs	r0, #1
c0d00aba:	4916      	ldr	r1, [pc, #88]	; (c0d00b14 <ont_main+0x3a0>)
c0d00abc:	7008      	strb	r0, [r1, #0]
							THROW(0x6E00);
c0d00abe:	2037      	movs	r0, #55	; 0x37
c0d00ac0:	0240      	lsls	r0, r0, #9
c0d00ac2:	f000 fb0a 	bl	c0d010da <os_longjmp>
							goto return_to_dashboard;

							// we're asked to do an unknown command
						default:
							// return an error.
							hashTainted = 1;
c0d00ac6:	2001      	movs	r0, #1
c0d00ac8:	4912      	ldr	r1, [pc, #72]	; (c0d00b14 <ont_main+0x3a0>)
c0d00aca:	7008      	strb	r0, [r1, #0]
							THROW(0x6D00);
c0d00acc:	9806      	ldr	r0, [sp, #24]
c0d00ace:	f000 fb04 	bl	c0d010da <os_longjmp>
						// we're getting a transaction to sign, in parts.
						case INS_SIGN: {
							Timer_Restart();
							// check the third byte (0x02) for the instruction subtype.
							if ((G_io_apdu_buffer[2] != P1_MORE) && (G_io_apdu_buffer[2] != P1_LAST)) {
								hashTainted = 1;
c0d00ad2:	2001      	movs	r0, #1
c0d00ad4:	7020      	strb	r0, [r4, #0]
								THROW(0x6A86);
c0d00ad6:	481d      	ldr	r0, [pc, #116]	; (c0d00b4c <ont_main+0x3d8>)
c0d00ad8:	f000 faff 	bl	c0d010da <os_longjmp>
							// move the contents of the buffer into raw_tx, and update raw_tx_ix to the end of the buffer, to be ready for the next part of the tx.
							unsigned int len = get_apdu_buffer_length();
							unsigned char * in = G_io_apdu_buffer + APDU_HEADER_LENGTH;
							unsigned char * out = raw_tx + raw_tx_ix;
							if (raw_tx_ix + len > MAX_TX_RAW_LENGTH) {
								hashTainted = 1;
c0d00adc:	2001      	movs	r0, #1
c0d00ade:	490d      	ldr	r1, [pc, #52]	; (c0d00b14 <ont_main+0x3a0>)
c0d00ae0:	7008      	strb	r0, [r1, #0]
c0d00ae2:	9806      	ldr	r0, [sp, #24]
								THROW(0x6D08);
c0d00ae4:	3008      	adds	r0, #8
c0d00ae6:	f000 faf8 	bl	c0d010da <os_longjmp>

							cx_ecfp_public_key_t publicKey;
							cx_ecfp_private_key_t privateKey;

							if (rx < APDU_HEADER_LENGTH + BIP44_BYTE_LENGTH) {
								hashTainted = 1;
c0d00aea:	2001      	movs	r0, #1
c0d00aec:	4909      	ldr	r1, [pc, #36]	; (c0d00b14 <ont_main+0x3a0>)
c0d00aee:	7008      	strb	r0, [r1, #0]
c0d00af0:	9806      	ldr	r0, [sp, #24]
								THROW(0x6D09);
c0d00af2:	3009      	adds	r0, #9
c0d00af4:	f000 faf1 	bl	c0d010da <os_longjmp>

							cx_ecfp_public_key_t publicKey;
							cx_ecfp_private_key_t privateKey;

							if (rx < APDU_HEADER_LENGTH + BIP44_BYTE_LENGTH) {
								hashTainted = 1;
c0d00af8:	2001      	movs	r0, #1
c0d00afa:	4906      	ldr	r1, [pc, #24]	; (c0d00b14 <ont_main+0x3a0>)
c0d00afc:	7008      	strb	r0, [r1, #0]
c0d00afe:	9806      	ldr	r0, [sp, #24]
								THROW(0x6D10);
c0d00b00:	3010      	adds	r0, #16
c0d00b02:	f000 faea 	bl	c0d010da <os_longjmp>
c0d00b06:	46c0      	nop			; (mov r8, r8)
c0d00b08:	0000ffff 	.word	0x0000ffff
c0d00b0c:	000007ff 	.word	0x000007ff
c0d00b10:	200018f8 	.word	0x200018f8
c0d00b14:	20001f60 	.word	0x20001f60
c0d00b18:	00001002 	.word	0x00001002
c0d00b1c:	2000201c 	.word	0x2000201c
c0d00b20:	20002020 	.word	0x20002020
c0d00b24:	00006425 	.word	0x00006425
c0d00b28:	20001f68 	.word	0x20001f68
c0d00b2c:	20002024 	.word	0x20002024
c0d00b30:	00000601 	.word	0x00000601
c0d00b34:	20001af4 	.word	0x20001af4
c0d00b38:	20001f64 	.word	0x20001f64
c0d00b3c:	20001af0 	.word	0x20001af0
c0d00b40:	00000401 	.word	0x00000401
c0d00b44:	20001b60 	.word	0x20001b60
c0d00b48:	20002028 	.word	0x20002028
c0d00b4c:	00006a86 	.word	0x00006a86
c0d00b50:	00006982 	.word	0x00006982

c0d00b54 <to_address>:
		os_memmove(dest + dec_place_ix + 1, base10_buffer + dec_place_ix, buffer_len - dec_place_ix);
	}
}

/** converts a ONT scripthas to a ONT address by adding a checksum and encoding in base58 */
static void to_address(char * dest, unsigned int dest_len, const unsigned char * script_hash) {
c0d00b54:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00b56:	b09b      	sub	sp, #108	; 0x6c
c0d00b58:	9003      	str	r0, [sp, #12]
c0d00b5a:	ac04      	add	r4, sp, #16
	unsigned char address_hash_result_0[SHA256_HASH_LEN];
	unsigned char address_hash_result_1[SHA256_HASH_LEN];

	// concatenate the ADDRESS_VERSION and the address.
	unsigned char address[ADDRESS_LEN];
	address[0] = ADDRESS_VERSION;
c0d00b5c:	2017      	movs	r0, #23
c0d00b5e:	7020      	strb	r0, [r4, #0]
	os_memmove(address + 1, script_hash, SCRIPT_HASH_LEN);
c0d00b60:	1c60      	adds	r0, r4, #1
c0d00b62:	2214      	movs	r2, #20
c0d00b64:	f000 fa05 	bl	c0d00f72 <os_memmove>

	// do a sha256 hash of the address twice.
	cx_sha256_init(&address_hash);
c0d00b68:	4e16      	ldr	r6, [pc, #88]	; (c0d00bc4 <to_address+0x70>)
c0d00b6a:	4630      	mov	r0, r6
c0d00b6c:	f001 f978 	bl	c0d01e60 <cx_sha256_init>
c0d00b70:	af13      	add	r7, sp, #76	; 0x4c
	cx_hash(&address_hash.header, CX_LAST, address, SCRIPT_HASH_LEN + 1, address_hash_result_0);
c0d00b72:	4668      	mov	r0, sp
c0d00b74:	6007      	str	r7, [r0, #0]
c0d00b76:	2501      	movs	r5, #1
c0d00b78:	2315      	movs	r3, #21
c0d00b7a:	4630      	mov	r0, r6
c0d00b7c:	4629      	mov	r1, r5
c0d00b7e:	4622      	mov	r2, r4
c0d00b80:	f7ff faa0 	bl	c0d000c4 <cx_hash_X>
	cx_sha256_init(&address_hash);
c0d00b84:	4630      	mov	r0, r6
c0d00b86:	f001 f96b 	bl	c0d01e60 <cx_sha256_init>
c0d00b8a:	ae0b      	add	r6, sp, #44	; 0x2c
	cx_hash(&address_hash.header, CX_LAST, address_hash_result_0, SHA256_HASH_LEN, address_hash_result_1);
c0d00b8c:	4668      	mov	r0, sp
c0d00b8e:	6006      	str	r6, [r0, #0]
c0d00b90:	2320      	movs	r3, #32
c0d00b92:	480c      	ldr	r0, [pc, #48]	; (c0d00bc4 <to_address+0x70>)
c0d00b94:	4629      	mov	r1, r5
c0d00b96:	463a      	mov	r2, r7
c0d00b98:	f7ff fa94 	bl	c0d000c4 <cx_hash_X>

	// add the first bytes of the hash as a checksum at the end of the address.
	os_memmove(address + 1 + SCRIPT_HASH_LEN, address_hash_result_1, SCRIPT_HASH_CHECKSUM_LEN);
c0d00b9c:	4620      	mov	r0, r4
c0d00b9e:	3015      	adds	r0, #21
c0d00ba0:	2204      	movs	r2, #4
c0d00ba2:	4631      	mov	r1, r6
c0d00ba4:	f000 f9e5 	bl	c0d00f72 <os_memmove>
	return encode_base_x(BASE_10_ALPHABET, sizeof(BASE_10_ALPHABET), in, in_length, out, out_length);
}

/** encodes in_length bytes from in into base-58, writes the converted bytes to out, stopping when it converts out_length bytes.  */
static unsigned int encode_base_58(const void *in, const unsigned int in_len, char *out, const unsigned int out_len) {
	return encode_base_x(BASE_58_ALPHABET, sizeof(BASE_58_ALPHABET), in, in_len, out, out_len);
c0d00ba8:	2022      	movs	r0, #34	; 0x22
c0d00baa:	4669      	mov	r1, sp
c0d00bac:	9a03      	ldr	r2, [sp, #12]
c0d00bae:	600a      	str	r2, [r1, #0]
c0d00bb0:	6048      	str	r0, [r1, #4]
c0d00bb2:	4805      	ldr	r0, [pc, #20]	; (c0d00bc8 <to_address+0x74>)
c0d00bb4:	4478      	add	r0, pc
c0d00bb6:	213a      	movs	r1, #58	; 0x3a
c0d00bb8:	2319      	movs	r3, #25
c0d00bba:	4622      	mov	r2, r4
c0d00bbc:	f000 f880 	bl	c0d00cc0 <encode_base_x>
	// add the first bytes of the hash as a checksum at the end of the address.
	os_memmove(address + 1 + SCRIPT_HASH_LEN, address_hash_result_1, SCRIPT_HASH_CHECKSUM_LEN);

	// encode the version + address + checksum in base58
	encode_base_58(address, ADDRESS_LEN, dest, dest_len);
}
c0d00bc0:	b01b      	add	sp, #108	; 0x6c
c0d00bc2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00bc4:	20001880 	.word	0x20001880
c0d00bc8:	00003712 	.word	0x00003712

c0d00bcc <public_key_hash160>:
	os_memmove(current_public_key[0], NO_PUBLIC_KEY_0, sizeof(NO_PUBLIC_KEY_0));
	os_memmove(current_public_key[1], NO_PUBLIC_KEY_1, sizeof(NO_PUBLIC_KEY_1));
	publicKeyNeedsRefresh = 0;
}

void public_key_hash160(unsigned char * in, unsigned short inlen, unsigned char *out) {
c0d00bcc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00bce:	b0a7      	sub	sp, #156	; 0x9c
c0d00bd0:	9203      	str	r2, [sp, #12]
c0d00bd2:	9102      	str	r1, [sp, #8]
c0d00bd4:	4604      	mov	r4, r0
c0d00bd6:	ad0c      	add	r5, sp, #48	; 0x30
		cx_sha256_t shasha;
		cx_ripemd160_t riprip;
	} u;
	unsigned char buffer[32];

	cx_sha256_init(&u.shasha);
c0d00bd8:	4628      	mov	r0, r5
c0d00bda:	f001 f941 	bl	c0d01e60 <cx_sha256_init>
c0d00bde:	ae04      	add	r6, sp, #16
	cx_hash(&u.shasha.header, CX_LAST, in, inlen, buffer);
c0d00be0:	4668      	mov	r0, sp
c0d00be2:	6006      	str	r6, [r0, #0]
c0d00be4:	2701      	movs	r7, #1
c0d00be6:	4628      	mov	r0, r5
c0d00be8:	4639      	mov	r1, r7
c0d00bea:	4622      	mov	r2, r4
c0d00bec:	9b02      	ldr	r3, [sp, #8]
c0d00bee:	f7ff fa69 	bl	c0d000c4 <cx_hash_X>
	cx_ripemd160_init(&u.riprip);
c0d00bf2:	4628      	mov	r0, r5
c0d00bf4:	f001 f91e 	bl	c0d01e34 <cx_ripemd160_init>
	cx_hash(&u.riprip.header, CX_LAST, buffer, 32, out);
c0d00bf8:	4668      	mov	r0, sp
c0d00bfa:	9903      	ldr	r1, [sp, #12]
c0d00bfc:	6001      	str	r1, [r0, #0]
c0d00bfe:	2320      	movs	r3, #32
c0d00c00:	4628      	mov	r0, r5
c0d00c02:	4639      	mov	r1, r7
c0d00c04:	4632      	mov	r2, r6
c0d00c06:	f7ff fa5d 	bl	c0d000c4 <cx_hash_X>
}
c0d00c0a:	b027      	add	sp, #156	; 0x9c
c0d00c0c:	bdf0      	pop	{r4, r5, r6, r7, pc}
	...

c0d00c10 <display_public_key>:

void display_public_key(const unsigned char * public_key) {
c0d00c10:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00c12:	b0a1      	sub	sp, #132	; 0x84
c0d00c14:	9000      	str	r0, [sp, #0]
	os_memmove(current_public_key[0], TXT_BLANK, sizeof(TXT_BLANK));
c0d00c16:	4e28      	ldr	r6, [pc, #160]	; (c0d00cb8 <display_public_key+0xa8>)
c0d00c18:	4c28      	ldr	r4, [pc, #160]	; (c0d00cbc <display_public_key+0xac>)
c0d00c1a:	447c      	add	r4, pc
c0d00c1c:	2712      	movs	r7, #18
c0d00c1e:	4630      	mov	r0, r6
c0d00c20:	4621      	mov	r1, r4
c0d00c22:	463a      	mov	r2, r7
c0d00c24:	f000 f9a5 	bl	c0d00f72 <os_memmove>
	os_memmove(current_public_key[1], TXT_BLANK, sizeof(TXT_BLANK));
c0d00c28:	3612      	adds	r6, #18
c0d00c2a:	4630      	mov	r0, r6
c0d00c2c:	4621      	mov	r1, r4
c0d00c2e:	463a      	mov	r2, r7
c0d00c30:	f000 f99f 	bl	c0d00f72 <os_memmove>
	os_memmove(current_public_key[2], TXT_BLANK, sizeof(TXT_BLANK));
c0d00c34:	4d20      	ldr	r5, [pc, #128]	; (c0d00cb8 <display_public_key+0xa8>)
c0d00c36:	3524      	adds	r5, #36	; 0x24
c0d00c38:	4628      	mov	r0, r5
c0d00c3a:	4621      	mov	r1, r4
c0d00c3c:	463a      	mov	r2, r7
c0d00c3e:	f000 f998 	bl	c0d00f72 <os_memmove>

	unsigned char public_key_encoded[33];
	public_key_encoded[0] = ((public_key[64] & 1) ? 0x03 : 0x02);
c0d00c42:	2040      	movs	r0, #64	; 0x40
c0d00c44:	9a00      	ldr	r2, [sp, #0]
c0d00c46:	5c10      	ldrb	r0, [r2, r0]
c0d00c48:	2101      	movs	r1, #1
c0d00c4a:	4001      	ands	r1, r0
c0d00c4c:	2002      	movs	r0, #2
c0d00c4e:	4308      	orrs	r0, r1
c0d00c50:	ac18      	add	r4, sp, #96	; 0x60
c0d00c52:	7020      	strb	r0, [r4, #0]
	os_memmove(public_key_encoded + 1, public_key + 1, 32);
c0d00c54:	1c60      	adds	r0, r4, #1
c0d00c56:	1c51      	adds	r1, r2, #1
c0d00c58:	2220      	movs	r2, #32
c0d00c5a:	f000 f98a 	bl	c0d00f72 <os_memmove>
c0d00c5e:	af0f      	add	r7, sp, #60	; 0x3c
c0d00c60:	2221      	movs	r2, #33	; 0x21

	unsigned char verification_script[35];
	verification_script[0] = 0x21;
c0d00c62:	703a      	strb	r2, [r7, #0]
	os_memmove(verification_script + 1, public_key_encoded, sizeof(public_key_encoded));
c0d00c64:	1c78      	adds	r0, r7, #1
c0d00c66:	4621      	mov	r1, r4
c0d00c68:	f000 f983 	bl	c0d00f72 <os_memmove>
	verification_script[sizeof(verification_script) - 1] = 0xAC;
c0d00c6c:	2022      	movs	r0, #34	; 0x22
c0d00c6e:	21ac      	movs	r1, #172	; 0xac
c0d00c70:	5439      	strb	r1, [r7, r0]
c0d00c72:	ac0a      	add	r4, sp, #40	; 0x28

	unsigned char script_hash[SCRIPT_HASH_LEN];
	for (int i = 0; i < SCRIPT_HASH_LEN; i++) {
		script_hash[i] = 0x00;
c0d00c74:	2114      	movs	r1, #20
c0d00c76:	4620      	mov	r0, r4
c0d00c78:	f003 fa3a 	bl	c0d040f0 <__aeabi_memclr>
	}

	public_key_hash160(verification_script, sizeof(verification_script), script_hash);
c0d00c7c:	2123      	movs	r1, #35	; 0x23
c0d00c7e:	4638      	mov	r0, r7
c0d00c80:	4622      	mov	r2, r4
c0d00c82:	f7ff ffa3 	bl	c0d00bcc <public_key_hash160>
c0d00c86:	af01      	add	r7, sp, #4
	unsigned int address_base58_len_1 = 11;
	unsigned int address_base58_len_2 = 12;
	char * address_base58_0 = address_base58;
	char * address_base58_1 = address_base58 + address_base58_len_0;
	char * address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
	to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);
c0d00c88:	4638      	mov	r0, r7
c0d00c8a:	4621      	mov	r1, r4
c0d00c8c:	f7ff ff62 	bl	c0d00b54 <to_address>
c0d00c90:	240b      	movs	r4, #11

	os_memmove(current_public_key[0], address_base58_0, address_base58_len_0);
c0d00c92:	4809      	ldr	r0, [pc, #36]	; (c0d00cb8 <display_public_key+0xa8>)
c0d00c94:	4639      	mov	r1, r7
c0d00c96:	4622      	mov	r2, r4
c0d00c98:	f000 f96b 	bl	c0d00f72 <os_memmove>
	char address_base58[ADDRESS_BASE58_LEN];
	unsigned int address_base58_len_0 = 11;
	unsigned int address_base58_len_1 = 11;
	unsigned int address_base58_len_2 = 12;
	char * address_base58_0 = address_base58;
	char * address_base58_1 = address_base58 + address_base58_len_0;
c0d00c9c:	4639      	mov	r1, r7
c0d00c9e:	310b      	adds	r1, #11
	char * address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
	to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);

	os_memmove(current_public_key[0], address_base58_0, address_base58_len_0);
	os_memmove(current_public_key[1], address_base58_1, address_base58_len_1);
c0d00ca0:	4630      	mov	r0, r6
c0d00ca2:	4622      	mov	r2, r4
c0d00ca4:	f000 f965 	bl	c0d00f72 <os_memmove>
	unsigned int address_base58_len_0 = 11;
	unsigned int address_base58_len_1 = 11;
	unsigned int address_base58_len_2 = 12;
	char * address_base58_0 = address_base58;
	char * address_base58_1 = address_base58 + address_base58_len_0;
	char * address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
c0d00ca8:	3716      	adds	r7, #22
	to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);

	os_memmove(current_public_key[0], address_base58_0, address_base58_len_0);
	os_memmove(current_public_key[1], address_base58_1, address_base58_len_1);
	os_memmove(current_public_key[2], address_base58_2, address_base58_len_2);
c0d00caa:	220c      	movs	r2, #12
c0d00cac:	4628      	mov	r0, r5
c0d00cae:	4639      	mov	r1, r7
c0d00cb0:	f000 f95f 	bl	c0d00f72 <os_memmove>
}
c0d00cb4:	b021      	add	sp, #132	; 0x84
c0d00cb6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00cb8:	20002030 	.word	0x20002030
c0d00cbc:	0000369a 	.word	0x0000369a

c0d00cc0 <encode_base_x>:
	return encode_base_x(BASE_58_ALPHABET, sizeof(BASE_58_ALPHABET), in, in_len, out, out_len);
}

/** encodes in_length bytes from in into the given base, using the given alphabet. writes the converted bytes to out, stopping when it converts out_length bytes. */
static unsigned int encode_base_x(const char * alphabet, const unsigned int alphabet_len, const void * in, const unsigned int in_length, char * out,
		const unsigned int out_length) {
c0d00cc0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00cc2:	b0b9      	sub	sp, #228	; 0xe4
c0d00cc4:	461e      	mov	r6, r3
c0d00cc6:	460d      	mov	r5, r1
c0d00cc8:	9003      	str	r0, [sp, #12]
c0d00cca:	4c4c      	ldr	r4, [pc, #304]	; (c0d00dfc <encode_base_x+0x13c>)
	char tmp[64];
	char buffer[128];
	unsigned char buffer_ix;
	unsigned char startAt;
	unsigned char zeroCount = 0;
	if (in_length > sizeof(tmp)) {
c0d00ccc:	2e41      	cmp	r6, #65	; 0x41
c0d00cce:	d300      	bcc.n	c0d00cd2 <encode_base_x+0x12>
c0d00cd0:	e089      	b.n	c0d00de6 <encode_base_x+0x126>
c0d00cd2:	a829      	add	r0, sp, #164	; 0xa4
		hashTainted = 1;
		THROW(0x6D11);
	}
	os_memmove(tmp, in, in_length);
c0d00cd4:	4611      	mov	r1, r2
c0d00cd6:	4632      	mov	r2, r6
c0d00cd8:	f000 f94b 	bl	c0d00f72 <os_memmove>
c0d00cdc:	2100      	movs	r1, #0
	while ((zeroCount < in_length) && (tmp[zeroCount] == 0)) {
c0d00cde:	2e00      	cmp	r6, #0
c0d00ce0:	9507      	str	r5, [sp, #28]
c0d00ce2:	9400      	str	r4, [sp, #0]
c0d00ce4:	d014      	beq.n	c0d00d10 <encode_base_x+0x50>
c0d00ce6:	2000      	movs	r0, #0
c0d00ce8:	4602      	mov	r2, r0
c0d00cea:	a929      	add	r1, sp, #164	; 0xa4
c0d00cec:	5c08      	ldrb	r0, [r1, r0]
c0d00cee:	2800      	cmp	r0, #0
c0d00cf0:	d103      	bne.n	c0d00cfa <encode_base_x+0x3a>
		++zeroCount;
c0d00cf2:	1c52      	adds	r2, r2, #1
	if (in_length > sizeof(tmp)) {
		hashTainted = 1;
		THROW(0x6D11);
	}
	os_memmove(tmp, in, in_length);
	while ((zeroCount < in_length) && (tmp[zeroCount] == 0)) {
c0d00cf4:	b2d0      	uxtb	r0, r2
c0d00cf6:	42b0      	cmp	r0, r6
c0d00cf8:	d3f7      	bcc.n	c0d00cea <encode_base_x+0x2a>
		++zeroCount;
	}
	buffer_ix = 2 * in_length;
c0d00cfa:	0071      	lsls	r1, r6, #1
	if (buffer_ix > sizeof(buffer)) {
c0d00cfc:	b2c8      	uxtb	r0, r1
c0d00cfe:	2881      	cmp	r0, #129	; 0x81
c0d00d00:	d307      	bcc.n	c0d00d12 <encode_base_x+0x52>
		hashTainted = 1;
c0d00d02:	483f      	ldr	r0, [pc, #252]	; (c0d00e00 <encode_base_x+0x140>)
c0d00d04:	2101      	movs	r1, #1
c0d00d06:	7001      	strb	r1, [r0, #0]
		THROW(0x6D12);
c0d00d08:	9800      	ldr	r0, [sp, #0]
c0d00d0a:	1c40      	adds	r0, r0, #1
c0d00d0c:	f000 f9e5 	bl	c0d010da <os_longjmp>
c0d00d10:	460a      	mov	r2, r1
c0d00d12:	9202      	str	r2, [sp, #8]
	}

	startAt = zeroCount;
	while (startAt < in_length) {
c0d00d14:	b2d2      	uxtb	r2, r2
c0d00d16:	42b2      	cmp	r2, r6
c0d00d18:	9101      	str	r1, [sp, #4]
c0d00d1a:	460c      	mov	r4, r1
c0d00d1c:	d233      	bcs.n	c0d00d86 <encode_base_x+0xc6>
c0d00d1e:	20ff      	movs	r0, #255	; 0xff
c0d00d20:	0203      	lsls	r3, r0, #8
c0d00d22:	9c01      	ldr	r4, [sp, #4]
c0d00d24:	9802      	ldr	r0, [sp, #8]
c0d00d26:	9308      	str	r3, [sp, #32]
c0d00d28:	9204      	str	r2, [sp, #16]
c0d00d2a:	9405      	str	r4, [sp, #20]
c0d00d2c:	9006      	str	r0, [sp, #24]
		unsigned short remainder = 0;
		unsigned char divLoop;
		for (divLoop = startAt; divLoop < in_length; divLoop++) {
c0d00d2e:	b2c5      	uxtb	r5, r0
c0d00d30:	2100      	movs	r1, #0
c0d00d32:	42b5      	cmp	r5, r6
c0d00d34:	d211      	bcs.n	c0d00d5a <encode_base_x+0x9a>
c0d00d36:	2100      	movs	r1, #0
c0d00d38:	9f06      	ldr	r7, [sp, #24]
c0d00d3a:	4634      	mov	r4, r6
c0d00d3c:	ae29      	add	r6, sp, #164	; 0xa4
			unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
			unsigned short tmpDiv = remainder * 256 + digit256;
c0d00d3e:	5d72      	ldrb	r2, [r6, r5]
c0d00d40:	0208      	lsls	r0, r1, #8
			tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
c0d00d42:	4018      	ands	r0, r3
c0d00d44:	4310      	orrs	r0, r2
			remainder = (tmpDiv % alphabet_len);
c0d00d46:	9907      	ldr	r1, [sp, #28]
c0d00d48:	f003 f9cc 	bl	c0d040e4 <__aeabi_uidivmod>
c0d00d4c:	9b08      	ldr	r3, [sp, #32]
		unsigned short remainder = 0;
		unsigned char divLoop;
		for (divLoop = startAt; divLoop < in_length; divLoop++) {
			unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
			unsigned short tmpDiv = remainder * 256 + digit256;
			tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
c0d00d4e:	5570      	strb	r0, [r6, r5]
c0d00d50:	4626      	mov	r6, r4

	startAt = zeroCount;
	while (startAt < in_length) {
		unsigned short remainder = 0;
		unsigned char divLoop;
		for (divLoop = startAt; divLoop < in_length; divLoop++) {
c0d00d52:	1c7f      	adds	r7, r7, #1
c0d00d54:	b2fd      	uxtb	r5, r7
c0d00d56:	42b5      	cmp	r5, r6
c0d00d58:	d3ef      	bcc.n	c0d00d3a <encode_base_x+0x7a>
c0d00d5a:	a829      	add	r0, sp, #164	; 0xa4
			unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
			unsigned short tmpDiv = remainder * 256 + digit256;
			tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
			remainder = (tmpDiv % alphabet_len);
		}
		if (tmp[startAt] == 0) {
c0d00d5c:	9a04      	ldr	r2, [sp, #16]
c0d00d5e:	5c82      	ldrb	r2, [r0, r2]
			++startAt;
		}
		buffer[--buffer_ix] = *(alphabet + remainder);
c0d00d60:	4618      	mov	r0, r3
c0d00d62:	30ff      	adds	r0, #255	; 0xff
c0d00d64:	4008      	ands	r0, r1
c0d00d66:	9903      	ldr	r1, [sp, #12]
c0d00d68:	5c08      	ldrb	r0, [r1, r0]
c0d00d6a:	9c05      	ldr	r4, [sp, #20]
c0d00d6c:	1e64      	subs	r4, r4, #1
c0d00d6e:	b2e1      	uxtb	r1, r4
c0d00d70:	ab09      	add	r3, sp, #36	; 0x24
c0d00d72:	5458      	strb	r0, [r3, r1]
c0d00d74:	9906      	ldr	r1, [sp, #24]
			unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
			unsigned short tmpDiv = remainder * 256 + digit256;
			tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
			remainder = (tmpDiv % alphabet_len);
		}
		if (tmp[startAt] == 0) {
c0d00d76:	1c48      	adds	r0, r1, #1
c0d00d78:	2a00      	cmp	r2, #0
c0d00d7a:	d000      	beq.n	c0d00d7e <encode_base_x+0xbe>
c0d00d7c:	4608      	mov	r0, r1
		hashTainted = 1;
		THROW(0x6D12);
	}

	startAt = zeroCount;
	while (startAt < in_length) {
c0d00d7e:	b2c2      	uxtb	r2, r0
c0d00d80:	42b2      	cmp	r2, r6
c0d00d82:	9b08      	ldr	r3, [sp, #32]
c0d00d84:	d3d0      	bcc.n	c0d00d28 <encode_base_x+0x68>
		if (tmp[startAt] == 0) {
			++startAt;
		}
		buffer[--buffer_ix] = *(alphabet + remainder);
	}
	while ((buffer_ix < (2 * in_length)) && (buffer[buffer_ix] == *(alphabet + 0))) {
c0d00d86:	b2e1      	uxtb	r1, r4
c0d00d88:	9f01      	ldr	r7, [sp, #4]
c0d00d8a:	42b9      	cmp	r1, r7
c0d00d8c:	d20b      	bcs.n	c0d00da6 <encode_base_x+0xe6>
c0d00d8e:	9803      	ldr	r0, [sp, #12]
c0d00d90:	7800      	ldrb	r0, [r0, #0]
c0d00d92:	9e02      	ldr	r6, [sp, #8]
c0d00d94:	aa09      	add	r2, sp, #36	; 0x24
c0d00d96:	5c51      	ldrb	r1, [r2, r1]
c0d00d98:	4281      	cmp	r1, r0
c0d00d9a:	d105      	bne.n	c0d00da8 <encode_base_x+0xe8>
		++buffer_ix;
c0d00d9c:	1c64      	adds	r4, r4, #1
		if (tmp[startAt] == 0) {
			++startAt;
		}
		buffer[--buffer_ix] = *(alphabet + remainder);
	}
	while ((buffer_ix < (2 * in_length)) && (buffer[buffer_ix] == *(alphabet + 0))) {
c0d00d9e:	b2e1      	uxtb	r1, r4
c0d00da0:	42b9      	cmp	r1, r7
c0d00da2:	d3f7      	bcc.n	c0d00d94 <encode_base_x+0xd4>
c0d00da4:	e000      	b.n	c0d00da8 <encode_base_x+0xe8>
c0d00da6:	9e02      	ldr	r6, [sp, #8]
c0d00da8:	983f      	ldr	r0, [sp, #252]	; 0xfc
		++buffer_ix;
	}
	while (zeroCount-- > 0) {
c0d00daa:	0631      	lsls	r1, r6, #24
c0d00dac:	d00e      	beq.n	c0d00dcc <encode_base_x+0x10c>
c0d00dae:	9903      	ldr	r1, [sp, #12]
c0d00db0:	7809      	ldrb	r1, [r1, #0]
c0d00db2:	9405      	str	r4, [sp, #20]
c0d00db4:	4622      	mov	r2, r4
c0d00db6:	4633      	mov	r3, r6
		buffer[--buffer_ix] = *(alphabet + 0);
c0d00db8:	1e52      	subs	r2, r2, #1
c0d00dba:	b2d4      	uxtb	r4, r2
c0d00dbc:	ad09      	add	r5, sp, #36	; 0x24
c0d00dbe:	5529      	strb	r1, [r5, r4]
		buffer[--buffer_ix] = *(alphabet + remainder);
	}
	while ((buffer_ix < (2 * in_length)) && (buffer[buffer_ix] == *(alphabet + 0))) {
		++buffer_ix;
	}
	while (zeroCount-- > 0) {
c0d00dc0:	1e5b      	subs	r3, r3, #1
c0d00dc2:	24ff      	movs	r4, #255	; 0xff
c0d00dc4:	4223      	tst	r3, r4
c0d00dc6:	d1f7      	bne.n	c0d00db8 <encode_base_x+0xf8>
c0d00dc8:	9c05      	ldr	r4, [sp, #20]
c0d00dca:	1ba4      	subs	r4, r4, r6
		buffer[--buffer_ix] = *(alphabet + 0);
	}
	const unsigned int true_out_length = (2 * in_length) - buffer_ix;
c0d00dcc:	b2e1      	uxtb	r1, r4
c0d00dce:	1a7d      	subs	r5, r7, r1
	if (true_out_length > out_length) {
c0d00dd0:	4285      	cmp	r5, r0
c0d00dd2:	d80e      	bhi.n	c0d00df2 <encode_base_x+0x132>
c0d00dd4:	983e      	ldr	r0, [sp, #248]	; 0xf8
c0d00dd6:	aa09      	add	r2, sp, #36	; 0x24
		THROW(0x6D14);
	}
	os_memmove(out, (buffer + buffer_ix), true_out_length);
c0d00dd8:	1851      	adds	r1, r2, r1
c0d00dda:	462a      	mov	r2, r5
c0d00ddc:	f000 f8c9 	bl	c0d00f72 <os_memmove>
	return true_out_length;
c0d00de0:	4628      	mov	r0, r5
c0d00de2:	b039      	add	sp, #228	; 0xe4
c0d00de4:	bdf0      	pop	{r4, r5, r6, r7, pc}
	char buffer[128];
	unsigned char buffer_ix;
	unsigned char startAt;
	unsigned char zeroCount = 0;
	if (in_length > sizeof(tmp)) {
		hashTainted = 1;
c0d00de6:	4806      	ldr	r0, [pc, #24]	; (c0d00e00 <encode_base_x+0x140>)
c0d00de8:	2101      	movs	r1, #1
c0d00dea:	7001      	strb	r1, [r0, #0]
		THROW(0x6D11);
c0d00dec:	4620      	mov	r0, r4
c0d00dee:	f000 f974 	bl	c0d010da <os_longjmp>
	while (zeroCount-- > 0) {
		buffer[--buffer_ix] = *(alphabet + 0);
	}
	const unsigned int true_out_length = (2 * in_length) - buffer_ix;
	if (true_out_length > out_length) {
		THROW(0x6D14);
c0d00df2:	9800      	ldr	r0, [sp, #0]
c0d00df4:	1cc0      	adds	r0, r0, #3
c0d00df6:	f000 f970 	bl	c0d010da <os_longjmp>
c0d00dfa:	46c0      	nop			; (mov r8, r8)
c0d00dfc:	00006d11 	.word	0x00006d11
c0d00e00:	20001f60 	.word	0x20001f60

c0d00e04 <os_boot>:
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d00e04:	2000      	movs	r0, #0
c0d00e06:	4681      	mov	r9, r0
void os_boot(void) {
  // TODO patch entry point when romming (f)

  // set the default try context to nothing
  try_context_set(NULL);
}
c0d00e08:	4770      	bx	lr

c0d00e0a <try_context_set>:
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d00e0a:	4681      	mov	r9, r0
}
c0d00e0c:	4770      	bx	lr
	...

c0d00e10 <io_usb_hid_receive>:
volatile unsigned int   G_io_usb_hid_channel;
volatile unsigned int   G_io_usb_hid_remaining_length;
volatile unsigned int   G_io_usb_hid_sequence_number;
volatile unsigned char* G_io_usb_hid_current_buffer;

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
c0d00e10:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00e12:	b081      	sub	sp, #4
c0d00e14:	9200      	str	r2, [sp, #0]
c0d00e16:	460f      	mov	r7, r1
c0d00e18:	4605      	mov	r5, r0
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
c0d00e1a:	4b48      	ldr	r3, [pc, #288]	; (c0d00f3c <io_usb_hid_receive+0x12c>)
c0d00e1c:	429f      	cmp	r7, r3
c0d00e1e:	d00f      	beq.n	c0d00e40 <io_usb_hid_receive+0x30>
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d00e20:	4c46      	ldr	r4, [pc, #280]	; (c0d00f3c <io_usb_hid_receive+0x12c>)
c0d00e22:	2640      	movs	r6, #64	; 0x40
c0d00e24:	4620      	mov	r0, r4
c0d00e26:	4631      	mov	r1, r6
c0d00e28:	f003 f962 	bl	c0d040f0 <__aeabi_memclr>
c0d00e2c:	9800      	ldr	r0, [sp, #0]

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
    os_memset(G_io_usb_ep_buffer, 0, sizeof(G_io_usb_ep_buffer));
    os_memmove(G_io_usb_ep_buffer, buffer, MIN(l, sizeof(G_io_usb_ep_buffer)));
c0d00e2e:	2840      	cmp	r0, #64	; 0x40
c0d00e30:	4602      	mov	r2, r0
c0d00e32:	d300      	bcc.n	c0d00e36 <io_usb_hid_receive+0x26>
c0d00e34:	4632      	mov	r2, r6
c0d00e36:	4620      	mov	r0, r4
c0d00e38:	4639      	mov	r1, r7
c0d00e3a:	f000 f89a 	bl	c0d00f72 <os_memmove>
c0d00e3e:	4b3f      	ldr	r3, [pc, #252]	; (c0d00f3c <io_usb_hid_receive+0x12c>)
c0d00e40:	7898      	ldrb	r0, [r3, #2]
  }

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
c0d00e42:	2801      	cmp	r0, #1
c0d00e44:	dc0b      	bgt.n	c0d00e5e <io_usb_hid_receive+0x4e>
c0d00e46:	2800      	cmp	r0, #0
c0d00e48:	d02b      	beq.n	c0d00ea2 <io_usb_hid_receive+0x92>
c0d00e4a:	2801      	cmp	r0, #1
c0d00e4c:	d169      	bne.n	c0d00f22 <io_usb_hid_receive+0x112>
    // await for the next chunk
    goto apdu_reset;

  case 0x01: // ALLOCATE CHANNEL
    // do not reset the current apdu reception if any
    cx_rng(G_io_usb_ep_buffer+3, 4);
c0d00e4e:	1cd8      	adds	r0, r3, #3
c0d00e50:	2104      	movs	r1, #4
c0d00e52:	461c      	mov	r4, r3
c0d00e54:	f000 ffba 	bl	c0d01dcc <cx_rng>
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d00e58:	2140      	movs	r1, #64	; 0x40
c0d00e5a:	4620      	mov	r0, r4
c0d00e5c:	e02c      	b.n	c0d00eb8 <io_usb_hid_receive+0xa8>
c0d00e5e:	2802      	cmp	r0, #2
c0d00e60:	d028      	beq.n	c0d00eb4 <io_usb_hid_receive+0xa4>
c0d00e62:	2805      	cmp	r0, #5
c0d00e64:	d15d      	bne.n	c0d00f22 <io_usb_hid_receive+0x112>

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
  case 0x05:
    // ensure sequence idx is 0 for the first chunk ! 
    if (U2BE(G_io_usb_ep_buffer, 3) != G_io_usb_hid_sequence_number) {
c0d00e66:	7918      	ldrb	r0, [r3, #4]
c0d00e68:	78d9      	ldrb	r1, [r3, #3]
c0d00e6a:	0209      	lsls	r1, r1, #8
c0d00e6c:	4301      	orrs	r1, r0
c0d00e6e:	4a34      	ldr	r2, [pc, #208]	; (c0d00f40 <io_usb_hid_receive+0x130>)
c0d00e70:	6810      	ldr	r0, [r2, #0]
c0d00e72:	2400      	movs	r4, #0
c0d00e74:	4281      	cmp	r1, r0
c0d00e76:	d15a      	bne.n	c0d00f2e <io_usb_hid_receive+0x11e>
c0d00e78:	4e32      	ldr	r6, [pc, #200]	; (c0d00f44 <io_usb_hid_receive+0x134>)
      // ignore packet
      goto apdu_reset;
    }
    // cid, tag, seq
    l -= 2+1+2;
c0d00e7a:	9800      	ldr	r0, [sp, #0]
c0d00e7c:	1980      	adds	r0, r0, r6
c0d00e7e:	1f07      	subs	r7, r0, #4
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
c0d00e80:	6810      	ldr	r0, [r2, #0]
c0d00e82:	2800      	cmp	r0, #0
c0d00e84:	d01b      	beq.n	c0d00ebe <io_usb_hid_receive+0xae>
c0d00e86:	4614      	mov	r4, r2
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
    }
    else {
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (l > G_io_usb_hid_remaining_length) {
c0d00e88:	4639      	mov	r1, r7
c0d00e8a:	4031      	ands	r1, r6
c0d00e8c:	482e      	ldr	r0, [pc, #184]	; (c0d00f48 <io_usb_hid_receive+0x138>)
c0d00e8e:	6802      	ldr	r2, [r0, #0]
c0d00e90:	4291      	cmp	r1, r2
c0d00e92:	d900      	bls.n	c0d00e96 <io_usb_hid_receive+0x86>
        l = G_io_usb_hid_remaining_length;
c0d00e94:	6807      	ldr	r7, [r0, #0]
      }

      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
c0d00e96:	463a      	mov	r2, r7
c0d00e98:	4032      	ands	r2, r6
c0d00e9a:	482c      	ldr	r0, [pc, #176]	; (c0d00f4c <io_usb_hid_receive+0x13c>)
c0d00e9c:	6800      	ldr	r0, [r0, #0]
c0d00e9e:	1d59      	adds	r1, r3, #5
c0d00ea0:	e031      	b.n	c0d00f06 <io_usb_hid_receive+0xf6>
c0d00ea2:	2400      	movs	r4, #0
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d00ea4:	719c      	strb	r4, [r3, #6]
c0d00ea6:	715c      	strb	r4, [r3, #5]
c0d00ea8:	711c      	strb	r4, [r3, #4]
c0d00eaa:	70dc      	strb	r4, [r3, #3]

  case 0x00: // get version ID
    // do not reset the current apdu reception if any
    os_memset(G_io_usb_ep_buffer+3, 0, 4); // PROTOCOL VERSION is 0
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d00eac:	2140      	movs	r1, #64	; 0x40
c0d00eae:	4618      	mov	r0, r3
c0d00eb0:	47a8      	blx	r5
c0d00eb2:	e03c      	b.n	c0d00f2e <io_usb_hid_receive+0x11e>
    goto apdu_reset;

  case 0x02: // ECHO|PING
    // do not reset the current apdu reception if any
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d00eb4:	4821      	ldr	r0, [pc, #132]	; (c0d00f3c <io_usb_hid_receive+0x12c>)
c0d00eb6:	2140      	movs	r1, #64	; 0x40
c0d00eb8:	47a8      	blx	r5
c0d00eba:	2400      	movs	r4, #0
c0d00ebc:	e037      	b.n	c0d00f2e <io_usb_hid_receive+0x11e>
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
      /// This is the apdu first chunk
      // total apdu size to receive
      G_io_usb_hid_total_length = U2BE(G_io_usb_ep_buffer, 5); //(G_io_usb_ep_buffer[5]<<8)+(G_io_usb_ep_buffer[6]&0xFF);
c0d00ebe:	7998      	ldrb	r0, [r3, #6]
c0d00ec0:	7959      	ldrb	r1, [r3, #5]
c0d00ec2:	0209      	lsls	r1, r1, #8
c0d00ec4:	4301      	orrs	r1, r0
c0d00ec6:	4822      	ldr	r0, [pc, #136]	; (c0d00f50 <io_usb_hid_receive+0x140>)
c0d00ec8:	6001      	str	r1, [r0, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
c0d00eca:	6801      	ldr	r1, [r0, #0]
c0d00ecc:	0849      	lsrs	r1, r1, #1
c0d00ece:	29a8      	cmp	r1, #168	; 0xa8
c0d00ed0:	d82d      	bhi.n	c0d00f2e <io_usb_hid_receive+0x11e>
c0d00ed2:	4614      	mov	r4, r2
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
      // compute remaining size to receive
      G_io_usb_hid_remaining_length = G_io_usb_hid_total_length;
c0d00ed4:	6801      	ldr	r1, [r0, #0]
c0d00ed6:	481c      	ldr	r0, [pc, #112]	; (c0d00f48 <io_usb_hid_receive+0x138>)
c0d00ed8:	6001      	str	r1, [r0, #0]
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d00eda:	491c      	ldr	r1, [pc, #112]	; (c0d00f4c <io_usb_hid_receive+0x13c>)
c0d00edc:	4a1d      	ldr	r2, [pc, #116]	; (c0d00f54 <io_usb_hid_receive+0x144>)
c0d00ede:	600a      	str	r2, [r1, #0]

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);
c0d00ee0:	7859      	ldrb	r1, [r3, #1]
c0d00ee2:	781a      	ldrb	r2, [r3, #0]
c0d00ee4:	0212      	lsls	r2, r2, #8
c0d00ee6:	430a      	orrs	r2, r1
c0d00ee8:	491b      	ldr	r1, [pc, #108]	; (c0d00f58 <io_usb_hid_receive+0x148>)
c0d00eea:	600a      	str	r2, [r1, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
c0d00eec:	491b      	ldr	r1, [pc, #108]	; (c0d00f5c <io_usb_hid_receive+0x14c>)
c0d00eee:	9a00      	ldr	r2, [sp, #0]
c0d00ef0:	1857      	adds	r7, r2, r1
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);

      if (l > G_io_usb_hid_remaining_length) {
c0d00ef2:	4639      	mov	r1, r7
c0d00ef4:	4031      	ands	r1, r6
c0d00ef6:	6802      	ldr	r2, [r0, #0]
c0d00ef8:	4291      	cmp	r1, r2
c0d00efa:	d900      	bls.n	c0d00efe <io_usb_hid_receive+0xee>
        l = G_io_usb_hid_remaining_length;
c0d00efc:	6807      	ldr	r7, [r0, #0]
      }
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
c0d00efe:	463a      	mov	r2, r7
c0d00f00:	4032      	ands	r2, r6
c0d00f02:	1dd9      	adds	r1, r3, #7
c0d00f04:	4813      	ldr	r0, [pc, #76]	; (c0d00f54 <io_usb_hid_receive+0x144>)
c0d00f06:	f000 f834 	bl	c0d00f72 <os_memmove>
      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
    }
    // factorize (f)
    G_io_usb_hid_current_buffer += l;
c0d00f0a:	4037      	ands	r7, r6
c0d00f0c:	480f      	ldr	r0, [pc, #60]	; (c0d00f4c <io_usb_hid_receive+0x13c>)
c0d00f0e:	6801      	ldr	r1, [r0, #0]
c0d00f10:	19c9      	adds	r1, r1, r7
c0d00f12:	6001      	str	r1, [r0, #0]
    G_io_usb_hid_remaining_length -= l;
c0d00f14:	480c      	ldr	r0, [pc, #48]	; (c0d00f48 <io_usb_hid_receive+0x138>)
c0d00f16:	6801      	ldr	r1, [r0, #0]
c0d00f18:	1bc9      	subs	r1, r1, r7
c0d00f1a:	6001      	str	r1, [r0, #0]
    G_io_usb_hid_sequence_number++;
c0d00f1c:	6820      	ldr	r0, [r4, #0]
c0d00f1e:	1c40      	adds	r0, r0, #1
c0d00f20:	6020      	str	r0, [r4, #0]
    // await for the next chunk
    goto apdu_reset;
  }

  // if more data to be received, notify it
  if (G_io_usb_hid_remaining_length) {
c0d00f22:	4809      	ldr	r0, [pc, #36]	; (c0d00f48 <io_usb_hid_receive+0x138>)
c0d00f24:	6801      	ldr	r1, [r0, #0]
c0d00f26:	2001      	movs	r0, #1
c0d00f28:	2402      	movs	r4, #2
c0d00f2a:	2900      	cmp	r1, #0
c0d00f2c:	d103      	bne.n	c0d00f36 <io_usb_hid_receive+0x126>
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d00f2e:	4804      	ldr	r0, [pc, #16]	; (c0d00f40 <io_usb_hid_receive+0x130>)
c0d00f30:	2100      	movs	r1, #0
c0d00f32:	6001      	str	r1, [r0, #0]
c0d00f34:	4620      	mov	r0, r4
  return IO_USB_APDU_RECEIVED;

apdu_reset:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}
c0d00f36:	b2c0      	uxtb	r0, r0
c0d00f38:	b001      	add	sp, #4
c0d00f3a:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00f3c:	20001ab0 	.word	0x20001ab0
c0d00f40:	200018ec 	.word	0x200018ec
c0d00f44:	0000ffff 	.word	0x0000ffff
c0d00f48:	200018f4 	.word	0x200018f4
c0d00f4c:	20001a4c 	.word	0x20001a4c
c0d00f50:	200018f0 	.word	0x200018f0
c0d00f54:	200018f8 	.word	0x200018f8
c0d00f58:	20001a50 	.word	0x20001a50
c0d00f5c:	0001fff9 	.word	0x0001fff9

c0d00f60 <os_memset>:
    }
  }
#undef DSTCHAR
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
c0d00f60:	b580      	push	{r7, lr}
c0d00f62:	460b      	mov	r3, r1
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
c0d00f64:	2a00      	cmp	r2, #0
c0d00f66:	d003      	beq.n	c0d00f70 <os_memset+0x10>
    DSTCHAR[length] = c;
c0d00f68:	4611      	mov	r1, r2
c0d00f6a:	461a      	mov	r2, r3
c0d00f6c:	f003 f8ca 	bl	c0d04104 <__aeabi_memset>
  }
#undef DSTCHAR
}
c0d00f70:	bd80      	pop	{r7, pc}

c0d00f72 <os_memmove>:
    }
  }
}
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
c0d00f72:	b5b0      	push	{r4, r5, r7, lr}
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d00f74:	4288      	cmp	r0, r1
c0d00f76:	d90d      	bls.n	c0d00f94 <os_memmove+0x22>
    while(length--) {
c0d00f78:	2a00      	cmp	r2, #0
c0d00f7a:	d014      	beq.n	c0d00fa6 <os_memmove+0x34>
c0d00f7c:	1e49      	subs	r1, r1, #1
c0d00f7e:	4252      	negs	r2, r2
c0d00f80:	1e40      	subs	r0, r0, #1
c0d00f82:	2300      	movs	r3, #0
c0d00f84:	43db      	mvns	r3, r3
      DSTCHAR[length] = SRCCHAR[length];
c0d00f86:	461c      	mov	r4, r3
c0d00f88:	4354      	muls	r4, r2
c0d00f8a:	5d0d      	ldrb	r5, [r1, r4]
c0d00f8c:	5505      	strb	r5, [r0, r4]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d00f8e:	1c52      	adds	r2, r2, #1
c0d00f90:	d1f9      	bne.n	c0d00f86 <os_memmove+0x14>
c0d00f92:	e008      	b.n	c0d00fa6 <os_memmove+0x34>
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d00f94:	2a00      	cmp	r2, #0
c0d00f96:	d006      	beq.n	c0d00fa6 <os_memmove+0x34>
c0d00f98:	2300      	movs	r3, #0
      DSTCHAR[l] = SRCCHAR[l];
c0d00f9a:	b29c      	uxth	r4, r3
c0d00f9c:	5d0d      	ldrb	r5, [r1, r4]
c0d00f9e:	5505      	strb	r5, [r0, r4]
      l++;
c0d00fa0:	1c5b      	adds	r3, r3, #1
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d00fa2:	1e52      	subs	r2, r2, #1
c0d00fa4:	d1f9      	bne.n	c0d00f9a <os_memmove+0x28>
      DSTCHAR[l] = SRCCHAR[l];
      l++;
    }
  }
#undef DSTCHAR
}
c0d00fa6:	bdb0      	pop	{r4, r5, r7, pc}

c0d00fa8 <io_usb_hid_init>:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d00fa8:	4801      	ldr	r0, [pc, #4]	; (c0d00fb0 <io_usb_hid_init+0x8>)
c0d00faa:	2100      	movs	r1, #0
c0d00fac:	6001      	str	r1, [r0, #0]
  //G_io_usb_hid_remaining_length = 0; // not really needed
  //G_io_usb_hid_total_length = 0; // not really needed
  //G_io_usb_hid_current_buffer = G_io_apdu_buffer; // not really needed
}
c0d00fae:	4770      	bx	lr
c0d00fb0:	200018ec 	.word	0x200018ec

c0d00fb4 <io_usb_hid_exchange>:

unsigned short io_usb_hid_exchange(io_send_t sndfct, unsigned short sndlength,
                                   io_recv_t rcvfct,
                                   unsigned char flags) {
c0d00fb4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00fb6:	b085      	sub	sp, #20
c0d00fb8:	9301      	str	r3, [sp, #4]
c0d00fba:	9200      	str	r2, [sp, #0]
c0d00fbc:	460e      	mov	r6, r1
c0d00fbe:	9003      	str	r0, [sp, #12]
  unsigned char l;

  // perform send
  if (sndlength) {
c0d00fc0:	2e00      	cmp	r6, #0
c0d00fc2:	d047      	beq.n	c0d01054 <io_usb_hid_exchange+0xa0>
    G_io_usb_hid_sequence_number = 0; 
c0d00fc4:	4c32      	ldr	r4, [pc, #200]	; (c0d01090 <io_usb_hid_exchange+0xdc>)
c0d00fc6:	2000      	movs	r0, #0
c0d00fc8:	6020      	str	r0, [r4, #0]
    G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d00fca:	4932      	ldr	r1, [pc, #200]	; (c0d01094 <io_usb_hid_exchange+0xe0>)
c0d00fcc:	4832      	ldr	r0, [pc, #200]	; (c0d01098 <io_usb_hid_exchange+0xe4>)
c0d00fce:	6008      	str	r0, [r1, #0]
c0d00fd0:	4f32      	ldr	r7, [pc, #200]	; (c0d0109c <io_usb_hid_exchange+0xe8>)
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d00fd2:	1d78      	adds	r0, r7, #5
c0d00fd4:	2539      	movs	r5, #57	; 0x39
c0d00fd6:	9002      	str	r0, [sp, #8]
c0d00fd8:	4629      	mov	r1, r5
c0d00fda:	f003 f889 	bl	c0d040f0 <__aeabi_memclr>
c0d00fde:	4830      	ldr	r0, [pc, #192]	; (c0d010a0 <io_usb_hid_exchange+0xec>)
c0d00fe0:	4601      	mov	r1, r0

    // fill the chunk
    os_memset(G_io_usb_ep_buffer, 0, IO_HID_EP_LENGTH-2);

    // keep the channel identifier
    G_io_usb_ep_buffer[0] = (G_io_usb_hid_channel>>8)&0xFF;
c0d00fe2:	6808      	ldr	r0, [r1, #0]
c0d00fe4:	0a00      	lsrs	r0, r0, #8
c0d00fe6:	7038      	strb	r0, [r7, #0]
    G_io_usb_ep_buffer[1] = G_io_usb_hid_channel&0xFF;
c0d00fe8:	6808      	ldr	r0, [r1, #0]
c0d00fea:	7078      	strb	r0, [r7, #1]
c0d00fec:	2005      	movs	r0, #5
    G_io_usb_ep_buffer[2] = 0x05;
c0d00fee:	70b8      	strb	r0, [r7, #2]
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
c0d00ff0:	6820      	ldr	r0, [r4, #0]
c0d00ff2:	0a00      	lsrs	r0, r0, #8
c0d00ff4:	70f8      	strb	r0, [r7, #3]
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;
c0d00ff6:	6820      	ldr	r0, [r4, #0]
c0d00ff8:	7138      	strb	r0, [r7, #4]
c0d00ffa:	b2b1      	uxth	r1, r6

    if (G_io_usb_hid_sequence_number == 0) {
c0d00ffc:	6820      	ldr	r0, [r4, #0]
c0d00ffe:	2800      	cmp	r0, #0
c0d01000:	9104      	str	r1, [sp, #16]
c0d01002:	d00a      	beq.n	c0d0101a <io_usb_hid_exchange+0x66>
      G_io_usb_hid_current_buffer += l;
      sndlength -= l;
      l += 7;
    }
    else {
      l = ((sndlength>IO_HID_EP_LENGTH-5) ? IO_HID_EP_LENGTH-5 : sndlength);
c0d01004:	203b      	movs	r0, #59	; 0x3b
c0d01006:	293b      	cmp	r1, #59	; 0x3b
c0d01008:	460e      	mov	r6, r1
c0d0100a:	d300      	bcc.n	c0d0100e <io_usb_hid_exchange+0x5a>
c0d0100c:	4606      	mov	r6, r0
c0d0100e:	4821      	ldr	r0, [pc, #132]	; (c0d01094 <io_usb_hid_exchange+0xe0>)
c0d01010:	4602      	mov	r2, r0
      os_memmove(G_io_usb_ep_buffer+5, (const void*)G_io_usb_hid_current_buffer, l);
c0d01012:	6811      	ldr	r1, [r2, #0]
c0d01014:	9802      	ldr	r0, [sp, #8]
c0d01016:	4615      	mov	r5, r2
c0d01018:	e009      	b.n	c0d0102e <io_usb_hid_exchange+0x7a>
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;

    if (G_io_usb_hid_sequence_number == 0) {
      l = ((sndlength>IO_HID_EP_LENGTH-7) ? IO_HID_EP_LENGTH-7 : sndlength);
      G_io_usb_ep_buffer[5] = sndlength>>8;
c0d0101a:	0a30      	lsrs	r0, r6, #8
c0d0101c:	7178      	strb	r0, [r7, #5]
      G_io_usb_ep_buffer[6] = sndlength;
c0d0101e:	71be      	strb	r6, [r7, #6]
    G_io_usb_ep_buffer[2] = 0x05;
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;

    if (G_io_usb_hid_sequence_number == 0) {
      l = ((sndlength>IO_HID_EP_LENGTH-7) ? IO_HID_EP_LENGTH-7 : sndlength);
c0d01020:	2939      	cmp	r1, #57	; 0x39
c0d01022:	460e      	mov	r6, r1
c0d01024:	d300      	bcc.n	c0d01028 <io_usb_hid_exchange+0x74>
c0d01026:	462e      	mov	r6, r5
c0d01028:	4d1a      	ldr	r5, [pc, #104]	; (c0d01094 <io_usb_hid_exchange+0xe0>)
      G_io_usb_ep_buffer[5] = sndlength>>8;
      G_io_usb_ep_buffer[6] = sndlength;
      os_memmove(G_io_usb_ep_buffer+7, (const void*)G_io_usb_hid_current_buffer, l);
c0d0102a:	6829      	ldr	r1, [r5, #0]
c0d0102c:	1df8      	adds	r0, r7, #7
c0d0102e:	4632      	mov	r2, r6
c0d01030:	f7ff ff9f 	bl	c0d00f72 <os_memmove>
c0d01034:	4c16      	ldr	r4, [pc, #88]	; (c0d01090 <io_usb_hid_exchange+0xdc>)
c0d01036:	6828      	ldr	r0, [r5, #0]
c0d01038:	1980      	adds	r0, r0, r6
      G_io_usb_hid_current_buffer += l;
c0d0103a:	6028      	str	r0, [r5, #0]
      G_io_usb_hid_current_buffer += l;
      sndlength -= l;
      l += 5;
    }
    // prepare next chunk numbering
    G_io_usb_hid_sequence_number++;
c0d0103c:	6820      	ldr	r0, [r4, #0]
c0d0103e:	1c40      	adds	r0, r0, #1
c0d01040:	6020      	str	r0, [r4, #0]
    // send the chunk
    // always pad :)
    sndfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
c0d01042:	2140      	movs	r1, #64	; 0x40
c0d01044:	4638      	mov	r0, r7
c0d01046:	9a03      	ldr	r2, [sp, #12]
c0d01048:	4790      	blx	r2
c0d0104a:	9804      	ldr	r0, [sp, #16]
c0d0104c:	1b86      	subs	r6, r0, r6
c0d0104e:	4815      	ldr	r0, [pc, #84]	; (c0d010a4 <io_usb_hid_exchange+0xf0>)
  // perform send
  if (sndlength) {
    G_io_usb_hid_sequence_number = 0; 
    G_io_usb_hid_current_buffer = G_io_apdu_buffer;
  }
  while(sndlength) {
c0d01050:	4206      	tst	r6, r0
c0d01052:	d1be      	bne.n	c0d00fd2 <io_usb_hid_exchange+0x1e>
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d01054:	480e      	ldr	r0, [pc, #56]	; (c0d01090 <io_usb_hid_exchange+0xdc>)
c0d01056:	2400      	movs	r4, #0
c0d01058:	6004      	str	r4, [r0, #0]
  }

  // prepare for next apdu
  io_usb_hid_init();

  if (flags & IO_RESET_AFTER_REPLIED) {
c0d0105a:	2080      	movs	r0, #128	; 0x80
c0d0105c:	9d01      	ldr	r5, [sp, #4]
c0d0105e:	4205      	tst	r5, r0
c0d01060:	d001      	beq.n	c0d01066 <io_usb_hid_exchange+0xb2>
    reset();
c0d01062:	f000 fe9f 	bl	c0d01da4 <reset>
  }

  if (flags & IO_RETURN_AFTER_TX ) {
c0d01066:	06a8      	lsls	r0, r5, #26
c0d01068:	d40f      	bmi.n	c0d0108a <io_usb_hid_exchange+0xd6>
c0d0106a:	4c0c      	ldr	r4, [pc, #48]	; (c0d0109c <io_usb_hid_exchange+0xe8>)
c0d0106c:	9d00      	ldr	r5, [sp, #0]
  }

  // receive the next command
  for(;;) {
    // receive a hid chunk
    l = rcvfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
c0d0106e:	2140      	movs	r1, #64	; 0x40
c0d01070:	4620      	mov	r0, r4
c0d01072:	47a8      	blx	r5
    // check for wrongly sized tlvs
    if (l > sizeof(G_io_usb_ep_buffer)) {
c0d01074:	b2c2      	uxtb	r2, r0
c0d01076:	2a40      	cmp	r2, #64	; 0x40
c0d01078:	d8f9      	bhi.n	c0d0106e <io_usb_hid_exchange+0xba>
      continue;
    }

    // call the chunk reception
    switch(io_usb_hid_receive(sndfct, G_io_usb_ep_buffer, l)) {
c0d0107a:	9803      	ldr	r0, [sp, #12]
c0d0107c:	4621      	mov	r1, r4
c0d0107e:	f7ff fec7 	bl	c0d00e10 <io_usb_hid_receive>
c0d01082:	2802      	cmp	r0, #2
c0d01084:	d1f3      	bne.n	c0d0106e <io_usb_hid_exchange+0xba>
      default:
        continue;

      case IO_USB_APDU_RECEIVED:

        return G_io_usb_hid_total_length;
c0d01086:	4808      	ldr	r0, [pc, #32]	; (c0d010a8 <io_usb_hid_exchange+0xf4>)
c0d01088:	6804      	ldr	r4, [r0, #0]
    }
  }
}
c0d0108a:	b2a0      	uxth	r0, r4
c0d0108c:	b005      	add	sp, #20
c0d0108e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01090:	200018ec 	.word	0x200018ec
c0d01094:	20001a4c 	.word	0x20001a4c
c0d01098:	200018f8 	.word	0x200018f8
c0d0109c:	20001ab0 	.word	0x20001ab0
c0d010a0:	20001a50 	.word	0x20001a50
c0d010a4:	0000ffff 	.word	0x0000ffff
c0d010a8:	200018f0 	.word	0x200018f0

c0d010ac <os_memcmp>:
    DSTCHAR[length] = c;
  }
#undef DSTCHAR
}

char os_memcmp(const void WIDE * buf1, const void WIDE * buf2, unsigned int length) {
c0d010ac:	b570      	push	{r4, r5, r6, lr}
#define BUF1 ((unsigned char const WIDE *)buf1)
#define BUF2 ((unsigned char const WIDE *)buf2)
  while(length--) {
c0d010ae:	1e43      	subs	r3, r0, #1
c0d010b0:	1e49      	subs	r1, r1, #1
c0d010b2:	4252      	negs	r2, r2
c0d010b4:	2000      	movs	r0, #0
c0d010b6:	43c4      	mvns	r4, r0
c0d010b8:	2a00      	cmp	r2, #0
c0d010ba:	d00c      	beq.n	c0d010d6 <os_memcmp+0x2a>
    if (BUF1[length] != BUF2[length]) {
c0d010bc:	4626      	mov	r6, r4
c0d010be:	4356      	muls	r6, r2
c0d010c0:	5d8d      	ldrb	r5, [r1, r6]
c0d010c2:	5d9e      	ldrb	r6, [r3, r6]
c0d010c4:	1c52      	adds	r2, r2, #1
c0d010c6:	42ae      	cmp	r6, r5
c0d010c8:	d0f6      	beq.n	c0d010b8 <os_memcmp+0xc>
      return (BUF1[length] > BUF2[length])? 1:-1;
c0d010ca:	2000      	movs	r0, #0
c0d010cc:	43c1      	mvns	r1, r0
c0d010ce:	2001      	movs	r0, #1
c0d010d0:	42ae      	cmp	r6, r5
c0d010d2:	d800      	bhi.n	c0d010d6 <os_memcmp+0x2a>
c0d010d4:	4608      	mov	r0, r1
  }
  return 0;
#undef BUF1
#undef BUF2

}
c0d010d6:	b2c0      	uxtb	r0, r0
c0d010d8:	bd70      	pop	{r4, r5, r6, pc}

c0d010da <os_longjmp>:
void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0d010da:	b580      	push	{r7, lr}
c0d010dc:	4601      	mov	r1, r0
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d010de:	4648      	mov	r0, r9
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
  longjmp(try_context_get()->jmp_buf, exception);
c0d010e0:	f003 f8a8 	bl	c0d04234 <longjmp>

c0d010e4 <try_context_get>:
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d010e4:	4648      	mov	r0, r9
  return current_ctx;
c0d010e6:	4770      	bx	lr

c0d010e8 <try_context_get_previous>:
}

try_context_t* try_context_get_previous(void) {
c0d010e8:	2000      	movs	r0, #0
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d010ea:	4649      	mov	r1, r9

  // first context reached ?
  if (current_ctx == NULL) {
c0d010ec:	2900      	cmp	r1, #0
c0d010ee:	d000      	beq.n	c0d010f2 <try_context_get_previous+0xa>
  }

  // return r9 content saved on the current context. It links to the previous context.
  // r4 r5 r6 r7 r8 r9 r10 r11 sp lr
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
c0d010f0:	6948      	ldr	r0, [r1, #20]
}
c0d010f2:	4770      	bx	lr

c0d010f4 <io_seproxyhal_general_status>:
  if (G_io_timeout) {
    G_io_timeout = timeout_ms;
  }
}

void io_seproxyhal_general_status(void) {
c0d010f4:	b580      	push	{r7, lr}
  // avoid troubles
  if (io_seproxyhal_spi_is_status_sent()) {
c0d010f6:	f000 ffa1 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d010fa:	2800      	cmp	r0, #0
c0d010fc:	d10b      	bne.n	c0d01116 <io_seproxyhal_general_status+0x22>
    return;
  }
  // send the general status
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_GENERAL_STATUS;
c0d010fe:	4806      	ldr	r0, [pc, #24]	; (c0d01118 <io_seproxyhal_general_status+0x24>)
c0d01100:	2160      	movs	r1, #96	; 0x60
c0d01102:	7001      	strb	r1, [r0, #0]
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d01104:	2100      	movs	r1, #0
c0d01106:	7041      	strb	r1, [r0, #1]
  G_io_seproxyhal_spi_buffer[2] = 2;
c0d01108:	2202      	movs	r2, #2
c0d0110a:	7082      	strb	r2, [r0, #2]
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND>>8;
c0d0110c:	70c1      	strb	r1, [r0, #3]
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND;
c0d0110e:	7101      	strb	r1, [r0, #4]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
c0d01110:	2105      	movs	r1, #5
c0d01112:	f000 ff7d 	bl	c0d02010 <io_seproxyhal_spi_send>
}
c0d01116:	bd80      	pop	{r7, pc}
c0d01118:	20001800 	.word	0x20001800

c0d0111c <io_seproxyhal_handle_usb_event>:
static volatile unsigned char G_io_usb_ep_xfer_len[IO_USB_MAX_ENDPOINTS];
#include "usbd_def.h"
#include "usbd_core.h"
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
c0d0111c:	b510      	push	{r4, lr}
  switch(G_io_seproxyhal_spi_buffer[3]) {
c0d0111e:	4813      	ldr	r0, [pc, #76]	; (c0d0116c <io_seproxyhal_handle_usb_event+0x50>)
c0d01120:	78c0      	ldrb	r0, [r0, #3]
c0d01122:	2803      	cmp	r0, #3
c0d01124:	dc07      	bgt.n	c0d01136 <io_seproxyhal_handle_usb_event+0x1a>
c0d01126:	2801      	cmp	r0, #1
c0d01128:	d00d      	beq.n	c0d01146 <io_seproxyhal_handle_usb_event+0x2a>
c0d0112a:	2802      	cmp	r0, #2
c0d0112c:	d11d      	bne.n	c0d0116a <io_seproxyhal_handle_usb_event+0x4e>
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
        THROW(EXCEPTION_IO_RESET);
      }
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
c0d0112e:	4810      	ldr	r0, [pc, #64]	; (c0d01170 <io_seproxyhal_handle_usb_event+0x54>)
c0d01130:	f002 fae9 	bl	c0d03706 <USBD_LL_SOF>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d01134:	bd10      	pop	{r4, pc}
c0d01136:	2804      	cmp	r0, #4
c0d01138:	d014      	beq.n	c0d01164 <io_seproxyhal_handle_usb_event+0x48>
c0d0113a:	2808      	cmp	r0, #8
c0d0113c:	d115      	bne.n	c0d0116a <io_seproxyhal_handle_usb_event+0x4e>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
c0d0113e:	480c      	ldr	r0, [pc, #48]	; (c0d01170 <io_seproxyhal_handle_usb_event+0x54>)
c0d01140:	f002 fadf 	bl	c0d03702 <USBD_LL_Resume>
      break;
  }
}
c0d01144:	bd10      	pop	{r4, pc}
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
  switch(G_io_seproxyhal_spi_buffer[3]) {
    case SEPROXYHAL_TAG_USB_EVENT_RESET:
      USBD_LL_SetSpeed(&USBD_Device, USBD_SPEED_FULL);  
c0d01146:	4c0a      	ldr	r4, [pc, #40]	; (c0d01170 <io_seproxyhal_handle_usb_event+0x54>)
c0d01148:	2101      	movs	r1, #1
c0d0114a:	4620      	mov	r0, r4
c0d0114c:	f002 fad4 	bl	c0d036f8 <USBD_LL_SetSpeed>
      USBD_LL_Reset(&USBD_Device);
c0d01150:	4620      	mov	r0, r4
c0d01152:	f002 fab0 	bl	c0d036b6 <USBD_LL_Reset>
      // ongoing APDU detected, throw a reset, even if not the media. to avoid potential troubles.
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
c0d01156:	4807      	ldr	r0, [pc, #28]	; (c0d01174 <io_seproxyhal_handle_usb_event+0x58>)
c0d01158:	7800      	ldrb	r0, [r0, #0]
c0d0115a:	2800      	cmp	r0, #0
c0d0115c:	d005      	beq.n	c0d0116a <io_seproxyhal_handle_usb_event+0x4e>
        THROW(EXCEPTION_IO_RESET);
c0d0115e:	2010      	movs	r0, #16
c0d01160:	f7ff ffbb 	bl	c0d010da <os_longjmp>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
c0d01164:	4802      	ldr	r0, [pc, #8]	; (c0d01170 <io_seproxyhal_handle_usb_event+0x54>)
c0d01166:	f002 faca 	bl	c0d036fe <USBD_LL_Suspend>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d0116a:	bd10      	pop	{r4, pc}
c0d0116c:	20001800 	.word	0x20001800
c0d01170:	20002070 	.word	0x20002070
c0d01174:	20001a5c 	.word	0x20001a5c

c0d01178 <io_seproxyhal_get_ep_rx_size>:

uint16_t io_seproxyhal_get_ep_rx_size(uint8_t epnum) {
  return G_io_usb_ep_xfer_len[epnum&0x7F];
c0d01178:	217f      	movs	r1, #127	; 0x7f
c0d0117a:	4001      	ands	r1, r0
c0d0117c:	4801      	ldr	r0, [pc, #4]	; (c0d01184 <io_seproxyhal_get_ep_rx_size+0xc>)
c0d0117e:	5c40      	ldrb	r0, [r0, r1]
c0d01180:	4770      	bx	lr
c0d01182:	46c0      	nop			; (mov r8, r8)
c0d01184:	20001a5d 	.word	0x20001a5d

c0d01188 <io_seproxyhal_handle_usb_ep_xfer_event>:
}

void io_seproxyhal_handle_usb_ep_xfer_event(void) {
c0d01188:	b580      	push	{r7, lr}
  switch(G_io_seproxyhal_spi_buffer[4]) {
c0d0118a:	4810      	ldr	r0, [pc, #64]	; (c0d011cc <io_seproxyhal_handle_usb_ep_xfer_event+0x44>)
c0d0118c:	7901      	ldrb	r1, [r0, #4]
c0d0118e:	2904      	cmp	r1, #4
c0d01190:	d008      	beq.n	c0d011a4 <io_seproxyhal_handle_usb_ep_xfer_event+0x1c>
c0d01192:	2902      	cmp	r1, #2
c0d01194:	d011      	beq.n	c0d011ba <io_seproxyhal_handle_usb_ep_xfer_event+0x32>
c0d01196:	2901      	cmp	r1, #1
c0d01198:	d10e      	bne.n	c0d011b8 <io_seproxyhal_handle_usb_ep_xfer_event+0x30>
    /* This event is received when a new SETUP token had been received on a control endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_SETUP:
      // assume length of setup packet, and that it is on endpoint 0
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
c0d0119a:	1d81      	adds	r1, r0, #6
c0d0119c:	480d      	ldr	r0, [pc, #52]	; (c0d011d4 <io_seproxyhal_handle_usb_ep_xfer_event+0x4c>)
c0d0119e:	f002 f983 	bl	c0d034a8 <USBD_LL_SetupStage>
      // saved just in case it is needed ...
      G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
      USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      break;
  }
}
c0d011a2:	bd80      	pop	{r7, pc}
      break;

    /* This event is received when a new DATA token is received on an endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_OUT:
      // saved just in case it is needed ...
      G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
c0d011a4:	78c2      	ldrb	r2, [r0, #3]
c0d011a6:	217f      	movs	r1, #127	; 0x7f
c0d011a8:	4011      	ands	r1, r2
c0d011aa:	7942      	ldrb	r2, [r0, #5]
c0d011ac:	4b08      	ldr	r3, [pc, #32]	; (c0d011d0 <io_seproxyhal_handle_usb_ep_xfer_event+0x48>)
c0d011ae:	545a      	strb	r2, [r3, r1]
      USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d011b0:	1d82      	adds	r2, r0, #6
c0d011b2:	4808      	ldr	r0, [pc, #32]	; (c0d011d4 <io_seproxyhal_handle_usb_ep_xfer_event+0x4c>)
c0d011b4:	f002 f9a7 	bl	c0d03506 <USBD_LL_DataOutStage>
      break;
  }
}
c0d011b8:	bd80      	pop	{r7, pc}
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
      break;

    /* This event is received after the prepare data packet has been flushed to the usb host */
    case SEPROXYHAL_TAG_USB_EP_XFER_IN:
      USBD_LL_DataInStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d011ba:	78c2      	ldrb	r2, [r0, #3]
c0d011bc:	217f      	movs	r1, #127	; 0x7f
c0d011be:	4011      	ands	r1, r2
c0d011c0:	1d82      	adds	r2, r0, #6
c0d011c2:	4804      	ldr	r0, [pc, #16]	; (c0d011d4 <io_seproxyhal_handle_usb_ep_xfer_event+0x4c>)
c0d011c4:	f002 f9fe 	bl	c0d035c4 <USBD_LL_DataInStage>
      // saved just in case it is needed ...
      G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
      USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      break;
  }
}
c0d011c8:	bd80      	pop	{r7, pc}
c0d011ca:	46c0      	nop			; (mov r8, r8)
c0d011cc:	20001800 	.word	0x20001800
c0d011d0:	20001a5d 	.word	0x20001a5d
c0d011d4:	20002070 	.word	0x20002070

c0d011d8 <io_usb_send_ep>:
}

#endif // HAVE_L4_USBLIB

// TODO, refactor this using the USB DataIn event like for the U2F tunnel
void io_usb_send_ep(unsigned int ep, unsigned char* buffer, unsigned short length, unsigned int timeout) {
c0d011d8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d011da:	b081      	sub	sp, #4
c0d011dc:	4614      	mov	r4, r2
c0d011de:	4605      	mov	r5, r0
  if (timeout) {
    timeout++;
  }

  // won't send if overflowing seproxyhal buffer format
  if (length > 255) {
c0d011e0:	2cff      	cmp	r4, #255	; 0xff
c0d011e2:	d83a      	bhi.n	c0d0125a <io_usb_send_ep+0x82>
    return;
  }
  
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d011e4:	4e1f      	ldr	r6, [pc, #124]	; (c0d01264 <io_usb_send_ep+0x8c>)
c0d011e6:	2050      	movs	r0, #80	; 0x50
c0d011e8:	7030      	strb	r0, [r6, #0]
  G_io_seproxyhal_spi_buffer[1] = (3+length)>>8;
c0d011ea:	1ce0      	adds	r0, r4, #3
c0d011ec:	9100      	str	r1, [sp, #0]
c0d011ee:	0a01      	lsrs	r1, r0, #8
c0d011f0:	7071      	strb	r1, [r6, #1]
  G_io_seproxyhal_spi_buffer[2] = (3+length);
c0d011f2:	70b0      	strb	r0, [r6, #2]
  G_io_seproxyhal_spi_buffer[3] = ep|0x80;
c0d011f4:	2080      	movs	r0, #128	; 0x80
c0d011f6:	4305      	orrs	r5, r0
c0d011f8:	70f5      	strb	r5, [r6, #3]
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d011fa:	2020      	movs	r0, #32
c0d011fc:	7130      	strb	r0, [r6, #4]
  G_io_seproxyhal_spi_buffer[5] = length;
c0d011fe:	7174      	strb	r4, [r6, #5]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 6);
c0d01200:	2106      	movs	r1, #6
c0d01202:	4630      	mov	r0, r6
c0d01204:	461f      	mov	r7, r3
c0d01206:	f000 ff03 	bl	c0d02010 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(buffer, length);
c0d0120a:	9800      	ldr	r0, [sp, #0]
c0d0120c:	4621      	mov	r1, r4
c0d0120e:	f000 feff 	bl	c0d02010 <io_seproxyhal_spi_send>

  // if timeout is requested
  if(timeout) {
c0d01212:	1c78      	adds	r0, r7, #1
c0d01214:	2802      	cmp	r0, #2
c0d01216:	d320      	bcc.n	c0d0125a <io_usb_send_ep+0x82>
c0d01218:	e006      	b.n	c0d01228 <io_usb_send_ep+0x50>
          THROW(EXCEPTION_IO_RESET);
        }
        */

        // link disconnected ?
        if(G_io_seproxyhal_spi_buffer[0] == SEPROXYHAL_TAG_STATUS_EVENT) {
c0d0121a:	2915      	cmp	r1, #21
c0d0121c:	d102      	bne.n	c0d01224 <io_usb_send_ep+0x4c>
          if (!(U4BE(G_io_seproxyhal_spi_buffer, 3) & SEPROXYHAL_TAG_STATUS_EVENT_FLAG_USB_POWERED)) {
c0d0121e:	79b0      	ldrb	r0, [r6, #6]
c0d01220:	0700      	lsls	r0, r0, #28
c0d01222:	d51c      	bpl.n	c0d0125e <io_usb_send_ep+0x86>
        
        // usb reset ?
        //io_seproxyhal_handle_usb_event();
        // also process other transfer requests if any (useful for HID keyboard while playing with CAPS lock key, side effect on LED status)
        // also handle IO timeout in a centralized and configurable way
        io_seproxyhal_handle_event();
c0d01224:	f000 f820 	bl	c0d01268 <io_seproxyhal_handle_event>
  io_seproxyhal_spi_send(buffer, length);

  // if timeout is requested
  if(timeout) {
    for (;;) {
      if (!io_seproxyhal_spi_is_status_sent()) {
c0d01228:	f000 ff08 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d0122c:	2800      	cmp	r0, #0
c0d0122e:	d101      	bne.n	c0d01234 <io_usb_send_ep+0x5c>
        io_seproxyhal_general_status();
c0d01230:	f7ff ff60 	bl	c0d010f4 <io_seproxyhal_general_status>
      }

      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d01234:	2180      	movs	r1, #128	; 0x80
c0d01236:	2200      	movs	r2, #0
c0d01238:	4630      	mov	r0, r6
c0d0123a:	f000 ff15 	bl	c0d02068 <io_seproxyhal_spi_recv>

      // wait for ack of the seproxyhal
      // discard if not an acknowledgment
      if (G_io_seproxyhal_spi_buffer[0] != SEPROXYHAL_TAG_USB_EP_XFER_EVENT
c0d0123e:	7831      	ldrb	r1, [r6, #0]
        || rx_len != 6 
c0d01240:	2806      	cmp	r0, #6
c0d01242:	d1ea      	bne.n	c0d0121a <io_usb_send_ep+0x42>
c0d01244:	2910      	cmp	r1, #16
c0d01246:	d1e8      	bne.n	c0d0121a <io_usb_send_ep+0x42>
        || G_io_seproxyhal_spi_buffer[3] != (ep|0x80)
c0d01248:	78f0      	ldrb	r0, [r6, #3]
        || G_io_seproxyhal_spi_buffer[4] != SEPROXYHAL_TAG_USB_EP_XFER_IN
c0d0124a:	42a8      	cmp	r0, r5
c0d0124c:	d1e5      	bne.n	c0d0121a <io_usb_send_ep+0x42>
c0d0124e:	7930      	ldrb	r0, [r6, #4]
c0d01250:	2802      	cmp	r0, #2
c0d01252:	d1e2      	bne.n	c0d0121a <io_usb_send_ep+0x42>
        || G_io_seproxyhal_spi_buffer[5] != length) {
c0d01254:	7970      	ldrb	r0, [r6, #5]

      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);

      // wait for ack of the seproxyhal
      // discard if not an acknowledgment
      if (G_io_seproxyhal_spi_buffer[0] != SEPROXYHAL_TAG_USB_EP_XFER_EVENT
c0d01256:	42a0      	cmp	r0, r4
c0d01258:	d1df      	bne.n	c0d0121a <io_usb_send_ep+0x42>

      // chunk sending succeeded
      break;
    }
  }
}
c0d0125a:	b001      	add	sp, #4
c0d0125c:	bdf0      	pop	{r4, r5, r6, r7, pc}
        */

        // link disconnected ?
        if(G_io_seproxyhal_spi_buffer[0] == SEPROXYHAL_TAG_STATUS_EVENT) {
          if (!(U4BE(G_io_seproxyhal_spi_buffer, 3) & SEPROXYHAL_TAG_STATUS_EVENT_FLAG_USB_POWERED)) {
           THROW(EXCEPTION_IO_RESET);
c0d0125e:	2010      	movs	r0, #16
c0d01260:	f7ff ff3b 	bl	c0d010da <os_longjmp>
c0d01264:	20001800 	.word	0x20001800

c0d01268 <io_seproxyhal_handle_event>:
    // copy apdu to apdu buffer
    os_memmove(G_io_apdu_buffer, G_io_seproxyhal_spi_buffer+3, G_io_apdu_length);
  }
}

unsigned int io_seproxyhal_handle_event(void) {
c0d01268:	b580      	push	{r7, lr}
  unsigned int rx_len = U2BE(G_io_seproxyhal_spi_buffer, 1);
c0d0126a:	481e      	ldr	r0, [pc, #120]	; (c0d012e4 <io_seproxyhal_handle_event+0x7c>)
c0d0126c:	7882      	ldrb	r2, [r0, #2]
c0d0126e:	7841      	ldrb	r1, [r0, #1]
c0d01270:	0209      	lsls	r1, r1, #8
c0d01272:	4311      	orrs	r1, r2
c0d01274:	7800      	ldrb	r0, [r0, #0]

  switch(G_io_seproxyhal_spi_buffer[0]) {
c0d01276:	280f      	cmp	r0, #15
c0d01278:	dc0a      	bgt.n	c0d01290 <io_seproxyhal_handle_event+0x28>
c0d0127a:	280e      	cmp	r0, #14
c0d0127c:	d010      	beq.n	c0d012a0 <io_seproxyhal_handle_event+0x38>
c0d0127e:	280f      	cmp	r0, #15
c0d01280:	d11d      	bne.n	c0d012be <io_seproxyhal_handle_event+0x56>
c0d01282:	2000      	movs	r0, #0
  #ifdef HAVE_IO_USB
    case SEPROXYHAL_TAG_USB_EVENT:
      if (rx_len != 3+1) {
c0d01284:	2904      	cmp	r1, #4
c0d01286:	d121      	bne.n	c0d012cc <io_seproxyhal_handle_event+0x64>
        return 0;
      }
      io_seproxyhal_handle_usb_event();
c0d01288:	f7ff ff48 	bl	c0d0111c <io_seproxyhal_handle_usb_event>
c0d0128c:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaulty return as not processed
  return 0;
}
c0d0128e:	bd80      	pop	{r7, pc}
c0d01290:	2810      	cmp	r0, #16
c0d01292:	d018      	beq.n	c0d012c6 <io_seproxyhal_handle_event+0x5e>
c0d01294:	2816      	cmp	r0, #22
c0d01296:	d112      	bne.n	c0d012be <io_seproxyhal_handle_event+0x56>
      io_seproxyhal_handle_bluenrg_event();
      return 1;
  #endif // HAVE_BLE

    case SEPROXYHAL_TAG_CAPDU_EVENT:
      io_seproxyhal_handle_capdu_event();
c0d01298:	f000 f832 	bl	c0d01300 <io_seproxyhal_handle_capdu_event>
c0d0129c:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaulty return as not processed
  return 0;
}
c0d0129e:	bd80      	pop	{r7, pc}
      return 1;

      // ask the user if not processed here
    case SEPROXYHAL_TAG_TICKER_EVENT:
      // process ticker events to timeout the IO transfers, and forward to the user io_event function too
      if(G_io_timeout) {
c0d012a0:	4811      	ldr	r0, [pc, #68]	; (c0d012e8 <io_seproxyhal_handle_event+0x80>)
c0d012a2:	6801      	ldr	r1, [r0, #0]
c0d012a4:	2900      	cmp	r1, #0
c0d012a6:	d00a      	beq.n	c0d012be <io_seproxyhal_handle_event+0x56>
        G_io_timeout-=MIN(G_io_timeout, 100);
c0d012a8:	6802      	ldr	r2, [r0, #0]
c0d012aa:	2164      	movs	r1, #100	; 0x64
c0d012ac:	2a63      	cmp	r2, #99	; 0x63
c0d012ae:	d800      	bhi.n	c0d012b2 <io_seproxyhal_handle_event+0x4a>
c0d012b0:	6801      	ldr	r1, [r0, #0]
c0d012b2:	6802      	ldr	r2, [r0, #0]
c0d012b4:	1a51      	subs	r1, r2, r1
c0d012b6:	6001      	str	r1, [r0, #0]
        #warning TODO use real ticker event interval here instead of the x100ms multiplier
        if (!G_io_timeout) {
c0d012b8:	6800      	ldr	r0, [r0, #0]
c0d012ba:	2800      	cmp	r0, #0
c0d012bc:	d00b      	beq.n	c0d012d6 <io_seproxyhal_handle_event+0x6e>
          G_io_apdu_state = APDU_IDLE;
          THROW(EXCEPTION_IO_RESET);
        }
      }
    default:
      return io_event(CHANNEL_SPI);
c0d012be:	2002      	movs	r0, #2
c0d012c0:	f7fe ffac 	bl	c0d0021c <io_event>
  }
  // defaulty return as not processed
  return 0;
}
c0d012c4:	bd80      	pop	{r7, pc}
c0d012c6:	2000      	movs	r0, #0
      }
      io_seproxyhal_handle_usb_event();
      return 1;

    case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
      if (rx_len < 3+3) {
c0d012c8:	2906      	cmp	r1, #6
c0d012ca:	d200      	bcs.n	c0d012ce <io_seproxyhal_handle_event+0x66>
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaulty return as not processed
  return 0;
}
c0d012cc:	bd80      	pop	{r7, pc}
    case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
      if (rx_len < 3+3) {
        // error !
        return 0;
      }
      io_seproxyhal_handle_usb_ep_xfer_event();
c0d012ce:	f7ff ff5b 	bl	c0d01188 <io_seproxyhal_handle_usb_ep_xfer_event>
c0d012d2:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaulty return as not processed
  return 0;
}
c0d012d4:	bd80      	pop	{r7, pc}
      if(G_io_timeout) {
        G_io_timeout-=MIN(G_io_timeout, 100);
        #warning TODO use real ticker event interval here instead of the x100ms multiplier
        if (!G_io_timeout) {
          // timeout !
          G_io_apdu_state = APDU_IDLE;
c0d012d6:	4805      	ldr	r0, [pc, #20]	; (c0d012ec <io_seproxyhal_handle_event+0x84>)
c0d012d8:	2100      	movs	r1, #0
c0d012da:	7001      	strb	r1, [r0, #0]
          THROW(EXCEPTION_IO_RESET);
c0d012dc:	2010      	movs	r0, #16
c0d012de:	f7ff fefc 	bl	c0d010da <os_longjmp>
c0d012e2:	46c0      	nop			; (mov r8, r8)
c0d012e4:	20001800 	.word	0x20001800
c0d012e8:	20001a58 	.word	0x20001a58
c0d012ec:	20001a64 	.word	0x20001a64

c0d012f0 <io_usb_send_apdu_data>:
      break;
    }
  }
}

void io_usb_send_apdu_data(unsigned char* buffer, unsigned short length) {
c0d012f0:	b580      	push	{r7, lr}
c0d012f2:	460a      	mov	r2, r1
c0d012f4:	4601      	mov	r1, r0
  // wait for 20 events before hanging up and timeout (~2 seconds of timeout)
  io_usb_send_ep(0x82, buffer, length, 20);
c0d012f6:	2082      	movs	r0, #130	; 0x82
c0d012f8:	2314      	movs	r3, #20
c0d012fa:	f7ff ff6d 	bl	c0d011d8 <io_usb_send_ep>
}
c0d012fe:	bd80      	pop	{r7, pc}

c0d01300 <io_seproxyhal_handle_capdu_event>:

}
#endif


void io_seproxyhal_handle_capdu_event(void) {
c0d01300:	b580      	push	{r7, lr}
  if(G_io_apdu_state == APDU_IDLE) 
c0d01302:	480b      	ldr	r0, [pc, #44]	; (c0d01330 <io_seproxyhal_handle_capdu_event+0x30>)
c0d01304:	7801      	ldrb	r1, [r0, #0]
c0d01306:	2900      	cmp	r1, #0
c0d01308:	d110      	bne.n	c0d0132c <io_seproxyhal_handle_capdu_event+0x2c>
  {
    G_io_apdu_media = IO_APDU_MEDIA_RAW; // for application code
c0d0130a:	490a      	ldr	r1, [pc, #40]	; (c0d01334 <io_seproxyhal_handle_capdu_event+0x34>)
c0d0130c:	2205      	movs	r2, #5
c0d0130e:	700a      	strb	r2, [r1, #0]
    G_io_apdu_state = APDU_RAW; // for next call to io_exchange
c0d01310:	210a      	movs	r1, #10
c0d01312:	7001      	strb	r1, [r0, #0]
    G_io_apdu_length = U2BE(G_io_seproxyhal_spi_buffer, 1);
c0d01314:	4808      	ldr	r0, [pc, #32]	; (c0d01338 <io_seproxyhal_handle_capdu_event+0x38>)
c0d01316:	7881      	ldrb	r1, [r0, #2]
c0d01318:	7842      	ldrb	r2, [r0, #1]
c0d0131a:	0212      	lsls	r2, r2, #8
c0d0131c:	430a      	orrs	r2, r1
c0d0131e:	4907      	ldr	r1, [pc, #28]	; (c0d0133c <io_seproxyhal_handle_capdu_event+0x3c>)
c0d01320:	800a      	strh	r2, [r1, #0]
    // copy apdu to apdu buffer
    os_memmove(G_io_apdu_buffer, G_io_seproxyhal_spi_buffer+3, G_io_apdu_length);
c0d01322:	880a      	ldrh	r2, [r1, #0]
c0d01324:	1cc1      	adds	r1, r0, #3
c0d01326:	4806      	ldr	r0, [pc, #24]	; (c0d01340 <io_seproxyhal_handle_capdu_event+0x40>)
c0d01328:	f7ff fe23 	bl	c0d00f72 <os_memmove>
  }
}
c0d0132c:	bd80      	pop	{r7, pc}
c0d0132e:	46c0      	nop			; (mov r8, r8)
c0d01330:	20001a64 	.word	0x20001a64
c0d01334:	20001a5c 	.word	0x20001a5c
c0d01338:	20001800 	.word	0x20001800
c0d0133c:	20001a66 	.word	0x20001a66
c0d01340:	200018f8 	.word	0x200018f8

c0d01344 <io_seproxyhal_init>:
#ifdef HAVE_BOLOS_APP_STACK_CANARY
#define APP_STACK_CANARY_MAGIC 0xDEAD0031
extern unsigned int app_stack_canary;
#endif // HAVE_BOLOS_APP_STACK_CANARY

void io_seproxyhal_init(void) {
c0d01344:	b510      	push	{r4, lr}
  // Enforce OS compatibility
  check_api_level(CX_COMPAT_APILEVEL);
c0d01346:	2008      	movs	r0, #8
c0d01348:	f000 fd16 	bl	c0d01d78 <check_api_level>

#ifdef HAVE_BOLOS_APP_STACK_CANARY
  app_stack_canary = APP_STACK_CANARY_MAGIC;
#endif // HAVE_BOLOS_APP_STACK_CANARY  

  G_io_apdu_state = APDU_IDLE;
c0d0134c:	480a      	ldr	r0, [pc, #40]	; (c0d01378 <io_seproxyhal_init+0x34>)
c0d0134e:	2400      	movs	r4, #0
c0d01350:	7004      	strb	r4, [r0, #0]
  G_io_apdu_offset = 0;
c0d01352:	480a      	ldr	r0, [pc, #40]	; (c0d0137c <io_seproxyhal_init+0x38>)
c0d01354:	8004      	strh	r4, [r0, #0]
  G_io_apdu_length = 0;
c0d01356:	480a      	ldr	r0, [pc, #40]	; (c0d01380 <io_seproxyhal_init+0x3c>)
c0d01358:	8004      	strh	r4, [r0, #0]
  G_io_apdu_seq = 0;
c0d0135a:	480a      	ldr	r0, [pc, #40]	; (c0d01384 <io_seproxyhal_init+0x40>)
c0d0135c:	8004      	strh	r4, [r0, #0]
  G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d0135e:	480a      	ldr	r0, [pc, #40]	; (c0d01388 <io_seproxyhal_init+0x44>)
c0d01360:	7004      	strb	r4, [r0, #0]
  G_io_timeout_limit = NO_TIMEOUT;
c0d01362:	480a      	ldr	r0, [pc, #40]	; (c0d0138c <io_seproxyhal_init+0x48>)
c0d01364:	6004      	str	r4, [r0, #0]
  debug_apdus_offset = 0;
  #endif // DEBUG_APDU


  #ifdef HAVE_USB_APDU
  io_usb_hid_init();
c0d01366:	f7ff fe1f 	bl	c0d00fa8 <io_usb_hid_init>
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d0136a:	4809      	ldr	r0, [pc, #36]	; (c0d01390 <io_seproxyhal_init+0x4c>)
c0d0136c:	6004      	str	r4, [r0, #0]

}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d0136e:	4809      	ldr	r0, [pc, #36]	; (c0d01394 <io_seproxyhal_init+0x50>)
c0d01370:	6004      	str	r4, [r0, #0]
  G_button_same_mask_counter = 0;
c0d01372:	4809      	ldr	r0, [pc, #36]	; (c0d01398 <io_seproxyhal_init+0x54>)
c0d01374:	6004      	str	r4, [r0, #0]
  io_usb_hid_init();
  #endif // HAVE_USB_APDU

  io_seproxyhal_init_ux();
  io_seproxyhal_init_button();
}
c0d01376:	bd10      	pop	{r4, pc}
c0d01378:	20001a64 	.word	0x20001a64
c0d0137c:	20001a68 	.word	0x20001a68
c0d01380:	20001a66 	.word	0x20001a66
c0d01384:	20001a6a 	.word	0x20001a6a
c0d01388:	20001a5c 	.word	0x20001a5c
c0d0138c:	20001a54 	.word	0x20001a54
c0d01390:	20001a6c 	.word	0x20001a6c
c0d01394:	20001a70 	.word	0x20001a70
c0d01398:	20001a74 	.word	0x20001a74

c0d0139c <io_seproxyhal_init_ux>:

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d0139c:	4801      	ldr	r0, [pc, #4]	; (c0d013a4 <io_seproxyhal_init_ux+0x8>)
c0d0139e:	2100      	movs	r1, #0
c0d013a0:	6001      	str	r1, [r0, #0]

}
c0d013a2:	4770      	bx	lr
c0d013a4:	20001a6c 	.word	0x20001a6c

c0d013a8 <io_seproxyhal_touch_out>:
  G_button_same_mask_counter = 0;
}

#ifdef HAVE_BAGL

unsigned int io_seproxyhal_touch_out(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d013a8:	b5b0      	push	{r4, r5, r7, lr}
c0d013aa:	460d      	mov	r5, r1
c0d013ac:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->out != NULL) {
c0d013ae:	6b20      	ldr	r0, [r4, #48]	; 0x30
c0d013b0:	2800      	cmp	r0, #0
c0d013b2:	d00c      	beq.n	c0d013ce <io_seproxyhal_touch_out+0x26>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->out))(element));
c0d013b4:	f000 fcc8 	bl	c0d01d48 <pic>
c0d013b8:	4601      	mov	r1, r0
c0d013ba:	4620      	mov	r0, r4
c0d013bc:	4788      	blx	r1
c0d013be:	f000 fcc3 	bl	c0d01d48 <pic>
c0d013c2:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (! el) {
c0d013c4:	2800      	cmp	r0, #0
c0d013c6:	d010      	beq.n	c0d013ea <io_seproxyhal_touch_out+0x42>
c0d013c8:	2801      	cmp	r0, #1
c0d013ca:	d000      	beq.n	c0d013ce <io_seproxyhal_touch_out+0x26>
c0d013cc:	4604      	mov	r4, r0
      element = el;
    }
  }

  // out function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d013ce:	2d00      	cmp	r5, #0
c0d013d0:	d007      	beq.n	c0d013e2 <io_seproxyhal_touch_out+0x3a>
    el = before_display(element);
c0d013d2:	4620      	mov	r0, r4
c0d013d4:	47a8      	blx	r5
c0d013d6:	2100      	movs	r1, #0
    if (!el) {
c0d013d8:	2800      	cmp	r0, #0
c0d013da:	d006      	beq.n	c0d013ea <io_seproxyhal_touch_out+0x42>
c0d013dc:	2801      	cmp	r0, #1
c0d013de:	d000      	beq.n	c0d013e2 <io_seproxyhal_touch_out+0x3a>
c0d013e0:	4604      	mov	r4, r0
    if ((unsigned int)el != 1) {
      element = el;
    }
  }

  io_seproxyhal_display(element);
c0d013e2:	4620      	mov	r0, r4
c0d013e4:	f7fe ff16 	bl	c0d00214 <io_seproxyhal_display>
c0d013e8:	2101      	movs	r1, #1
  return 1;
}
c0d013ea:	4608      	mov	r0, r1
c0d013ec:	bdb0      	pop	{r4, r5, r7, pc}

c0d013ee <io_seproxyhal_touch_over>:

unsigned int io_seproxyhal_touch_over(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d013ee:	b5b0      	push	{r4, r5, r7, lr}
c0d013f0:	b08e      	sub	sp, #56	; 0x38
c0d013f2:	460c      	mov	r4, r1
c0d013f4:	4605      	mov	r5, r0
  bagl_element_t e;
  const bagl_element_t* el;
  if (element->over != NULL) {
c0d013f6:	6b68      	ldr	r0, [r5, #52]	; 0x34
c0d013f8:	2800      	cmp	r0, #0
c0d013fa:	d00c      	beq.n	c0d01416 <io_seproxyhal_touch_over+0x28>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->over))(element));
c0d013fc:	f000 fca4 	bl	c0d01d48 <pic>
c0d01400:	4601      	mov	r1, r0
c0d01402:	4628      	mov	r0, r5
c0d01404:	4788      	blx	r1
c0d01406:	f000 fc9f 	bl	c0d01d48 <pic>
c0d0140a:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (!el) {
c0d0140c:	2800      	cmp	r0, #0
c0d0140e:	d016      	beq.n	c0d0143e <io_seproxyhal_touch_over+0x50>
c0d01410:	2801      	cmp	r0, #1
c0d01412:	d000      	beq.n	c0d01416 <io_seproxyhal_touch_over+0x28>
c0d01414:	4605      	mov	r5, r0
c0d01416:	4668      	mov	r0, sp
      element = el;
    }
  }

  // over function might have triggered a draw of its own during a display callback
  os_memmove(&e, (void*)element, sizeof(bagl_element_t));
c0d01418:	2238      	movs	r2, #56	; 0x38
c0d0141a:	4629      	mov	r1, r5
c0d0141c:	f7ff fda9 	bl	c0d00f72 <os_memmove>
  e.component.fgcolor = element->overfgcolor;
c0d01420:	6a68      	ldr	r0, [r5, #36]	; 0x24
c0d01422:	9004      	str	r0, [sp, #16]
  e.component.bgcolor = element->overbgcolor;
c0d01424:	6aa8      	ldr	r0, [r5, #40]	; 0x28
c0d01426:	9005      	str	r0, [sp, #20]

  //element = &e; // for INARRAY checks, it disturbs a bit. avoid it

  if (before_display) {
c0d01428:	2c00      	cmp	r4, #0
c0d0142a:	d004      	beq.n	c0d01436 <io_seproxyhal_touch_over+0x48>
    el = before_display(element);
c0d0142c:	4628      	mov	r0, r5
c0d0142e:	47a0      	blx	r4
c0d01430:	2100      	movs	r1, #0
    element = &e;
    if (!el) {
c0d01432:	2800      	cmp	r0, #0
c0d01434:	d003      	beq.n	c0d0143e <io_seproxyhal_touch_over+0x50>
c0d01436:	4668      	mov	r0, sp
  //else 
  {
    element = &e;
  }

  io_seproxyhal_display(element);
c0d01438:	f7fe feec 	bl	c0d00214 <io_seproxyhal_display>
c0d0143c:	2101      	movs	r1, #1
  return 1;
}
c0d0143e:	4608      	mov	r0, r1
c0d01440:	b00e      	add	sp, #56	; 0x38
c0d01442:	bdb0      	pop	{r4, r5, r7, pc}

c0d01444 <io_seproxyhal_touch_tap>:

unsigned int io_seproxyhal_touch_tap(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d01444:	b5b0      	push	{r4, r5, r7, lr}
c0d01446:	460d      	mov	r5, r1
c0d01448:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->tap != NULL) {
c0d0144a:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0d0144c:	2800      	cmp	r0, #0
c0d0144e:	d00c      	beq.n	c0d0146a <io_seproxyhal_touch_tap+0x26>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->tap))(element));
c0d01450:	f000 fc7a 	bl	c0d01d48 <pic>
c0d01454:	4601      	mov	r1, r0
c0d01456:	4620      	mov	r0, r4
c0d01458:	4788      	blx	r1
c0d0145a:	f000 fc75 	bl	c0d01d48 <pic>
c0d0145e:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (!el) {
c0d01460:	2800      	cmp	r0, #0
c0d01462:	d010      	beq.n	c0d01486 <io_seproxyhal_touch_tap+0x42>
c0d01464:	2801      	cmp	r0, #1
c0d01466:	d000      	beq.n	c0d0146a <io_seproxyhal_touch_tap+0x26>
c0d01468:	4604      	mov	r4, r0
      element = el;
    }
  }

  // tap function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d0146a:	2d00      	cmp	r5, #0
c0d0146c:	d007      	beq.n	c0d0147e <io_seproxyhal_touch_tap+0x3a>
    el = before_display(element);
c0d0146e:	4620      	mov	r0, r4
c0d01470:	47a8      	blx	r5
c0d01472:	2100      	movs	r1, #0
    if (!el) {
c0d01474:	2800      	cmp	r0, #0
c0d01476:	d006      	beq.n	c0d01486 <io_seproxyhal_touch_tap+0x42>
c0d01478:	2801      	cmp	r0, #1
c0d0147a:	d000      	beq.n	c0d0147e <io_seproxyhal_touch_tap+0x3a>
c0d0147c:	4604      	mov	r4, r0
    }
    if ((unsigned int)el != 1) {
      element = el;
    }
  }
  io_seproxyhal_display(element);
c0d0147e:	4620      	mov	r0, r4
c0d01480:	f7fe fec8 	bl	c0d00214 <io_seproxyhal_display>
c0d01484:	2101      	movs	r1, #1
  return 1;
}
c0d01486:	4608      	mov	r0, r1
c0d01488:	bdb0      	pop	{r4, r5, r7, pc}
	...

c0d0148c <io_seproxyhal_touch_element_callback>:
  io_seproxyhal_touch_element_callback(elements, element_count, x, y, event_kind, NULL);  
}

// browse all elements and until an element has changed state, continue browsing
// return if processed or not
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
c0d0148c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0148e:	b087      	sub	sp, #28
c0d01490:	9302      	str	r3, [sp, #8]
c0d01492:	9203      	str	r2, [sp, #12]
c0d01494:	9105      	str	r1, [sp, #20]
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d01496:	2900      	cmp	r1, #0
c0d01498:	d077      	beq.n	c0d0158a <io_seproxyhal_touch_element_callback+0xfe>
c0d0149a:	9004      	str	r0, [sp, #16]
c0d0149c:	980d      	ldr	r0, [sp, #52]	; 0x34
c0d0149e:	9001      	str	r0, [sp, #4]
c0d014a0:	980c      	ldr	r0, [sp, #48]	; 0x30
c0d014a2:	9000      	str	r0, [sp, #0]
c0d014a4:	2500      	movs	r5, #0
c0d014a6:	4b3c      	ldr	r3, [pc, #240]	; (c0d01598 <io_seproxyhal_touch_element_callback+0x10c>)
c0d014a8:	9506      	str	r5, [sp, #24]
c0d014aa:	462f      	mov	r7, r5
c0d014ac:	461e      	mov	r6, r3
    // process all components matching the x/y/w/h (no break) => fishy for the released out of zone
    // continue processing only if a status has not been sent
    if (io_seproxyhal_spi_is_status_sent()) {
c0d014ae:	f000 fdc5 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d014b2:	2800      	cmp	r0, #0
c0d014b4:	d155      	bne.n	c0d01562 <io_seproxyhal_touch_element_callback+0xd6>
      // continue instead of return to process all elemnts and therefore discard last touched element
      break;
    }

    // only perform out callback when element was in the current array, else, leave it be
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
c0d014b6:	2038      	movs	r0, #56	; 0x38
c0d014b8:	4368      	muls	r0, r5
c0d014ba:	9c04      	ldr	r4, [sp, #16]
c0d014bc:	1825      	adds	r5, r4, r0
c0d014be:	4633      	mov	r3, r6
c0d014c0:	681a      	ldr	r2, [r3, #0]
c0d014c2:	2101      	movs	r1, #1
c0d014c4:	4295      	cmp	r5, r2
c0d014c6:	d000      	beq.n	c0d014ca <io_seproxyhal_touch_element_callback+0x3e>
c0d014c8:	9906      	ldr	r1, [sp, #24]
c0d014ca:	9106      	str	r1, [sp, #24]
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d014cc:	5620      	ldrsb	r0, [r4, r0]
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
c0d014ce:	2800      	cmp	r0, #0
c0d014d0:	da41      	bge.n	c0d01556 <io_seproxyhal_touch_element_callback+0xca>
c0d014d2:	2020      	movs	r0, #32
c0d014d4:	5c28      	ldrb	r0, [r5, r0]
c0d014d6:	2102      	movs	r1, #2
c0d014d8:	5e69      	ldrsh	r1, [r5, r1]
c0d014da:	1a0a      	subs	r2, r1, r0
c0d014dc:	9c03      	ldr	r4, [sp, #12]
c0d014de:	42a2      	cmp	r2, r4
c0d014e0:	dc39      	bgt.n	c0d01556 <io_seproxyhal_touch_element_callback+0xca>
c0d014e2:	1841      	adds	r1, r0, r1
c0d014e4:	88ea      	ldrh	r2, [r5, #6]
c0d014e6:	1889      	adds	r1, r1, r2
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {
c0d014e8:	9a03      	ldr	r2, [sp, #12]
c0d014ea:	428a      	cmp	r2, r1
c0d014ec:	da33      	bge.n	c0d01556 <io_seproxyhal_touch_element_callback+0xca>
c0d014ee:	2104      	movs	r1, #4
c0d014f0:	5e6c      	ldrsh	r4, [r5, r1]
c0d014f2:	1a22      	subs	r2, r4, r0
c0d014f4:	9902      	ldr	r1, [sp, #8]
c0d014f6:	428a      	cmp	r2, r1
c0d014f8:	dc2d      	bgt.n	c0d01556 <io_seproxyhal_touch_element_callback+0xca>
c0d014fa:	1820      	adds	r0, r4, r0
c0d014fc:	8929      	ldrh	r1, [r5, #8]
c0d014fe:	1840      	adds	r0, r0, r1
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d01500:	9902      	ldr	r1, [sp, #8]
c0d01502:	4281      	cmp	r1, r0
c0d01504:	da27      	bge.n	c0d01556 <io_seproxyhal_touch_element_callback+0xca>
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d01506:	6818      	ldr	r0, [r3, #0]
              && G_bagl_last_touched_not_released_component != NULL) {
c0d01508:	4285      	cmp	r5, r0
c0d0150a:	d010      	beq.n	c0d0152e <io_seproxyhal_touch_element_callback+0xa2>
c0d0150c:	6818      	ldr	r0, [r3, #0]
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d0150e:	2800      	cmp	r0, #0
c0d01510:	d00d      	beq.n	c0d0152e <io_seproxyhal_touch_element_callback+0xa2>
              && G_bagl_last_touched_not_released_component != NULL) {
        // only out the previous element if the newly matching will be displayed 
        if (!before_display || before_display(&elements[comp_idx])) {
c0d01512:	9801      	ldr	r0, [sp, #4]
c0d01514:	2800      	cmp	r0, #0
c0d01516:	d005      	beq.n	c0d01524 <io_seproxyhal_touch_element_callback+0x98>
c0d01518:	4628      	mov	r0, r5
c0d0151a:	9901      	ldr	r1, [sp, #4]
c0d0151c:	4788      	blx	r1
c0d0151e:	4633      	mov	r3, r6
c0d01520:	2800      	cmp	r0, #0
c0d01522:	d018      	beq.n	c0d01556 <io_seproxyhal_touch_element_callback+0xca>
          if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d01524:	6818      	ldr	r0, [r3, #0]
c0d01526:	9901      	ldr	r1, [sp, #4]
c0d01528:	f7ff ff3e 	bl	c0d013a8 <io_seproxyhal_touch_out>
c0d0152c:	e008      	b.n	c0d01540 <io_seproxyhal_touch_element_callback+0xb4>
c0d0152e:	9800      	ldr	r0, [sp, #0]
        continue;
      }
      */
      
      // callback the hal to notify the component impacted by the user input
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_RELEASE) {
c0d01530:	2801      	cmp	r0, #1
c0d01532:	d009      	beq.n	c0d01548 <io_seproxyhal_touch_element_callback+0xbc>
c0d01534:	2802      	cmp	r0, #2
c0d01536:	d10e      	bne.n	c0d01556 <io_seproxyhal_touch_element_callback+0xca>
        if (io_seproxyhal_touch_tap(&elements[comp_idx], before_display)) {
c0d01538:	4628      	mov	r0, r5
c0d0153a:	9901      	ldr	r1, [sp, #4]
c0d0153c:	f7ff ff82 	bl	c0d01444 <io_seproxyhal_touch_tap>
c0d01540:	4633      	mov	r3, r6
c0d01542:	2800      	cmp	r0, #0
c0d01544:	d007      	beq.n	c0d01556 <io_seproxyhal_touch_element_callback+0xca>
c0d01546:	e022      	b.n	c0d0158e <io_seproxyhal_touch_element_callback+0x102>
          return;
        }
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
c0d01548:	4628      	mov	r0, r5
c0d0154a:	9901      	ldr	r1, [sp, #4]
c0d0154c:	f7ff ff4f 	bl	c0d013ee <io_seproxyhal_touch_over>
c0d01550:	4633      	mov	r3, r6
c0d01552:	2800      	cmp	r0, #0
c0d01554:	d11e      	bne.n	c0d01594 <io_seproxyhal_touch_element_callback+0x108>
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d01556:	1c7f      	adds	r7, r7, #1
c0d01558:	b2fd      	uxtb	r5, r7
c0d0155a:	9805      	ldr	r0, [sp, #20]
c0d0155c:	4285      	cmp	r5, r0
c0d0155e:	d3a5      	bcc.n	c0d014ac <io_seproxyhal_touch_element_callback+0x20>
c0d01560:	e000      	b.n	c0d01564 <io_seproxyhal_touch_element_callback+0xd8>
c0d01562:	4633      	mov	r3, r6
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
    && G_bagl_last_touched_not_released_component != NULL) {
c0d01564:	9806      	ldr	r0, [sp, #24]
c0d01566:	0600      	lsls	r0, r0, #24
c0d01568:	d00f      	beq.n	c0d0158a <io_seproxyhal_touch_element_callback+0xfe>
c0d0156a:	6818      	ldr	r0, [r3, #0]
      }
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
c0d0156c:	2800      	cmp	r0, #0
c0d0156e:	d00c      	beq.n	c0d0158a <io_seproxyhal_touch_element_callback+0xfe>
    && G_bagl_last_touched_not_released_component != NULL) {

    // we won't be able to notify the out, don't do it, in case a diplay refused the dra of the relased element and the position matched another element of the array (in autocomplete for example)
    if (io_seproxyhal_spi_is_status_sent()) {
c0d01570:	f000 fd64 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d01574:	4631      	mov	r1, r6
c0d01576:	2800      	cmp	r0, #0
c0d01578:	d107      	bne.n	c0d0158a <io_seproxyhal_touch_element_callback+0xfe>
      return;
    }
    
    if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d0157a:	6808      	ldr	r0, [r1, #0]
c0d0157c:	9901      	ldr	r1, [sp, #4]
c0d0157e:	f7ff ff13 	bl	c0d013a8 <io_seproxyhal_touch_out>
c0d01582:	2800      	cmp	r0, #0
c0d01584:	d001      	beq.n	c0d0158a <io_seproxyhal_touch_element_callback+0xfe>
      // ok component out has been emitted
      G_bagl_last_touched_not_released_component = NULL;
c0d01586:	2000      	movs	r0, #0
c0d01588:	6030      	str	r0, [r6, #0]
    }
  }

  // not processed
}
c0d0158a:	b007      	add	sp, #28
c0d0158c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0158e:	2000      	movs	r0, #0
c0d01590:	6018      	str	r0, [r3, #0]
c0d01592:	e7fa      	b.n	c0d0158a <io_seproxyhal_touch_element_callback+0xfe>
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
          // remember the last touched component
          G_bagl_last_touched_not_released_component = (bagl_element_t*)&elements[comp_idx];
c0d01594:	601d      	str	r5, [r3, #0]
c0d01596:	e7f8      	b.n	c0d0158a <io_seproxyhal_touch_element_callback+0xfe>
c0d01598:	20001a6c 	.word	0x20001a6c

c0d0159c <io_seproxyhal_display_icon>:
  // remaining length of bitmap bits to be displayed
  return len;
}
#endif // SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS

void io_seproxyhal_display_icon(bagl_component_t* icon_component, bagl_icon_details_t* icon_details) {
c0d0159c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0159e:	b089      	sub	sp, #36	; 0x24
c0d015a0:	460c      	mov	r4, r1
c0d015a2:	4601      	mov	r1, r0
c0d015a4:	ad02      	add	r5, sp, #8
c0d015a6:	221c      	movs	r2, #28
  bagl_component_t icon_component_mod;
  // ensure not being out of bounds in the icon component agianst the declared icon real size
  os_memmove(&icon_component_mod, icon_component, sizeof(bagl_component_t));
c0d015a8:	4628      	mov	r0, r5
c0d015aa:	9201      	str	r2, [sp, #4]
c0d015ac:	f7ff fce1 	bl	c0d00f72 <os_memmove>
  icon_component_mod.width = icon_details->width;
c0d015b0:	6821      	ldr	r1, [r4, #0]
c0d015b2:	80e9      	strh	r1, [r5, #6]
  icon_component_mod.height = icon_details->height;
c0d015b4:	6862      	ldr	r2, [r4, #4]
c0d015b6:	812a      	strh	r2, [r5, #8]
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d015b8:	68a0      	ldr	r0, [r4, #8]
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
                          +w; /* image bitmap size */
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d015ba:	4f1a      	ldr	r7, [pc, #104]	; (c0d01624 <io_seproxyhal_display_icon+0x88>)
c0d015bc:	2365      	movs	r3, #101	; 0x65
c0d015be:	703b      	strb	r3, [r7, #0]


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
c0d015c0:	b292      	uxth	r2, r2
c0d015c2:	4342      	muls	r2, r0
c0d015c4:	b28b      	uxth	r3, r1
c0d015c6:	4353      	muls	r3, r2
c0d015c8:	08d9      	lsrs	r1, r3, #3
c0d015ca:	1c4e      	adds	r6, r1, #1
c0d015cc:	2207      	movs	r2, #7
c0d015ce:	4213      	tst	r3, r2
c0d015d0:	d100      	bne.n	c0d015d4 <io_seproxyhal_display_icon+0x38>
c0d015d2:	460e      	mov	r6, r1
c0d015d4:	4631      	mov	r1, r6
c0d015d6:	9100      	str	r1, [sp, #0]
c0d015d8:	2604      	movs	r6, #4
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d015da:	4086      	lsls	r6, r0
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
c0d015dc:	1870      	adds	r0, r6, r1
                          +w; /* image bitmap size */
c0d015de:	301d      	adds	r0, #29
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
  G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d015e0:	0a01      	lsrs	r1, r0, #8
c0d015e2:	7079      	strb	r1, [r7, #1]
  G_io_seproxyhal_spi_buffer[2] = length;
c0d015e4:	70b8      	strb	r0, [r7, #2]
c0d015e6:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d015e8:	4638      	mov	r0, r7
c0d015ea:	f000 fd11 	bl	c0d02010 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)icon_component, sizeof(bagl_component_t));
c0d015ee:	4628      	mov	r0, r5
c0d015f0:	9901      	ldr	r1, [sp, #4]
c0d015f2:	f000 fd0d 	bl	c0d02010 <io_seproxyhal_spi_send>
  G_io_seproxyhal_spi_buffer[0] = icon_details->bpp;
c0d015f6:	68a0      	ldr	r0, [r4, #8]
c0d015f8:	7038      	strb	r0, [r7, #0]
c0d015fa:	2101      	movs	r1, #1
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 1);
c0d015fc:	4638      	mov	r0, r7
c0d015fe:	f000 fd07 	bl	c0d02010 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->colors), h);
c0d01602:	68e0      	ldr	r0, [r4, #12]
c0d01604:	f000 fba0 	bl	c0d01d48 <pic>
c0d01608:	b2b1      	uxth	r1, r6
c0d0160a:	f000 fd01 	bl	c0d02010 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->bitmap), w);
c0d0160e:	9800      	ldr	r0, [sp, #0]
c0d01610:	b285      	uxth	r5, r0
c0d01612:	6920      	ldr	r0, [r4, #16]
c0d01614:	f000 fb98 	bl	c0d01d48 <pic>
c0d01618:	4629      	mov	r1, r5
c0d0161a:	f000 fcf9 	bl	c0d02010 <io_seproxyhal_spi_send>
#endif // !SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS
}
c0d0161e:	b009      	add	sp, #36	; 0x24
c0d01620:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01622:	46c0      	nop			; (mov r8, r8)
c0d01624:	20001800 	.word	0x20001800

c0d01628 <io_seproxyhal_display_default>:

void io_seproxyhal_display_default(const bagl_element_t * element) {
c0d01628:	b570      	push	{r4, r5, r6, lr}
c0d0162a:	4604      	mov	r4, r0
  // process automagically address from rom and from ram
  unsigned int type = (element->component.type & ~(BAGL_FLAG_TOUCHABLE));
c0d0162c:	7820      	ldrb	r0, [r4, #0]
c0d0162e:	267f      	movs	r6, #127	; 0x7f
c0d01630:	4006      	ands	r6, r0

  // avoid sending another status :), fixes a lot of bugs in the end
  if (io_seproxyhal_spi_is_status_sent()) {
c0d01632:	f000 fd03 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d01636:	2800      	cmp	r0, #0
c0d01638:	d130      	bne.n	c0d0169c <io_seproxyhal_display_default+0x74>
c0d0163a:	2e00      	cmp	r6, #0
c0d0163c:	d02e      	beq.n	c0d0169c <io_seproxyhal_display_default+0x74>
    return;
  }

  if (type != BAGL_NONE) {
    if (element->text != NULL) {
c0d0163e:	69e0      	ldr	r0, [r4, #28]
c0d01640:	2800      	cmp	r0, #0
c0d01642:	d01d      	beq.n	c0d01680 <io_seproxyhal_display_default+0x58>
      unsigned int text_adr = PIC((unsigned int)element->text);
c0d01644:	f000 fb80 	bl	c0d01d48 <pic>
c0d01648:	4605      	mov	r5, r0
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
c0d0164a:	2e05      	cmp	r6, #5
c0d0164c:	d102      	bne.n	c0d01654 <io_seproxyhal_display_default+0x2c>
c0d0164e:	7ea0      	ldrb	r0, [r4, #26]
c0d01650:	2800      	cmp	r0, #0
c0d01652:	d024      	beq.n	c0d0169e <io_seproxyhal_display_default+0x76>
        io_seproxyhal_display_icon(&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d01654:	4628      	mov	r0, r5
c0d01656:	f002 fdfb 	bl	c0d04250 <strlen>
c0d0165a:	4606      	mov	r6, r0
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d0165c:	4812      	ldr	r0, [pc, #72]	; (c0d016a8 <io_seproxyhal_display_default+0x80>)
c0d0165e:	2165      	movs	r1, #101	; 0x65
c0d01660:	7001      	strb	r1, [r0, #0]
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon(&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d01662:	4631      	mov	r1, r6
c0d01664:	311c      	adds	r1, #28
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
        G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d01666:	0a0a      	lsrs	r2, r1, #8
c0d01668:	7042      	strb	r2, [r0, #1]
        G_io_seproxyhal_spi_buffer[2] = length;
c0d0166a:	7081      	strb	r1, [r0, #2]
        io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d0166c:	2103      	movs	r1, #3
c0d0166e:	f000 fccf 	bl	c0d02010 <io_seproxyhal_spi_send>
c0d01672:	211c      	movs	r1, #28
        io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d01674:	4620      	mov	r0, r4
c0d01676:	f000 fccb 	bl	c0d02010 <io_seproxyhal_spi_send>
        io_seproxyhal_spi_send((unsigned char*)text_adr, length-sizeof(bagl_component_t));
c0d0167a:	b2b1      	uxth	r1, r6
c0d0167c:	4628      	mov	r0, r5
c0d0167e:	e00b      	b.n	c0d01698 <io_seproxyhal_display_default+0x70>
      }
    }
    else {
      unsigned short length = sizeof(bagl_component_t);
      G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d01680:	4809      	ldr	r0, [pc, #36]	; (c0d016a8 <io_seproxyhal_display_default+0x80>)
c0d01682:	2165      	movs	r1, #101	; 0x65
c0d01684:	7001      	strb	r1, [r0, #0]
      G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d01686:	2100      	movs	r1, #0
c0d01688:	7041      	strb	r1, [r0, #1]
c0d0168a:	251c      	movs	r5, #28
      G_io_seproxyhal_spi_buffer[2] = length;
c0d0168c:	7085      	strb	r5, [r0, #2]
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d0168e:	2103      	movs	r1, #3
c0d01690:	f000 fcbe 	bl	c0d02010 <io_seproxyhal_spi_send>
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d01694:	4620      	mov	r0, r4
c0d01696:	4629      	mov	r1, r5
c0d01698:	f000 fcba 	bl	c0d02010 <io_seproxyhal_spi_send>
    }
  }
}
c0d0169c:	bd70      	pop	{r4, r5, r6, pc}
  if (type != BAGL_NONE) {
    if (element->text != NULL) {
      unsigned int text_adr = PIC((unsigned int)element->text);
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon(&element->component, (bagl_icon_details_t*)text_adr);
c0d0169e:	4620      	mov	r0, r4
c0d016a0:	4629      	mov	r1, r5
c0d016a2:	f7ff ff7b 	bl	c0d0159c <io_seproxyhal_display_icon>
      G_io_seproxyhal_spi_buffer[2] = length;
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
    }
  }
}
c0d016a6:	bd70      	pop	{r4, r5, r6, pc}
c0d016a8:	20001800 	.word	0x20001800

c0d016ac <io_seproxyhal_button_push>:
  G_io_seproxyhal_spi_buffer[3] = (backlight_percentage?0x80:0)|(flags & 0x7F); // power on
  G_io_seproxyhal_spi_buffer[4] = backlight_percentage;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
}

void io_seproxyhal_button_push(button_push_callback_t button_callback, unsigned int new_button_mask) {
c0d016ac:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d016ae:	b081      	sub	sp, #4
c0d016b0:	4604      	mov	r4, r0
  if (button_callback) {
c0d016b2:	2c00      	cmp	r4, #0
c0d016b4:	d02b      	beq.n	c0d0170e <io_seproxyhal_button_push+0x62>
    unsigned int button_mask;
    unsigned int button_same_mask_counter;
    // enable speeded up long push
    if (new_button_mask == G_button_mask) {
c0d016b6:	4817      	ldr	r0, [pc, #92]	; (c0d01714 <io_seproxyhal_button_push+0x68>)
c0d016b8:	6802      	ldr	r2, [r0, #0]
c0d016ba:	428a      	cmp	r2, r1
c0d016bc:	d103      	bne.n	c0d016c6 <io_seproxyhal_button_push+0x1a>
      // each 100ms ~
      G_button_same_mask_counter++;
c0d016be:	4a16      	ldr	r2, [pc, #88]	; (c0d01718 <io_seproxyhal_button_push+0x6c>)
c0d016c0:	6813      	ldr	r3, [r2, #0]
c0d016c2:	1c5b      	adds	r3, r3, #1
c0d016c4:	6013      	str	r3, [r2, #0]
    }

    // append the button mask
    button_mask = G_button_mask | new_button_mask;
c0d016c6:	6806      	ldr	r6, [r0, #0]
c0d016c8:	430e      	orrs	r6, r1

    // pre reset variable due to os_sched_exit
    button_same_mask_counter = G_button_same_mask_counter;
c0d016ca:	4a13      	ldr	r2, [pc, #76]	; (c0d01718 <io_seproxyhal_button_push+0x6c>)
c0d016cc:	6815      	ldr	r5, [r2, #0]
c0d016ce:	4f13      	ldr	r7, [pc, #76]	; (c0d0171c <io_seproxyhal_button_push+0x70>)

    // reset button mask
    if (new_button_mask == 0) {
c0d016d0:	2900      	cmp	r1, #0
c0d016d2:	d001      	beq.n	c0d016d8 <io_seproxyhal_button_push+0x2c>

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
    }
    else {
      G_button_mask = button_mask;
c0d016d4:	6006      	str	r6, [r0, #0]
c0d016d6:	e004      	b.n	c0d016e2 <io_seproxyhal_button_push+0x36>
c0d016d8:	2300      	movs	r3, #0
    button_same_mask_counter = G_button_same_mask_counter;

    // reset button mask
    if (new_button_mask == 0) {
      // reset next state when button are released
      G_button_mask = 0;
c0d016da:	6003      	str	r3, [r0, #0]
      G_button_same_mask_counter=0;
c0d016dc:	6013      	str	r3, [r2, #0]

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
c0d016de:	1c7b      	adds	r3, r7, #1
c0d016e0:	431e      	orrs	r6, r3
    else {
      G_button_mask = button_mask;
    }

    // reset counter when button mask changes
    if (new_button_mask != G_button_mask) {
c0d016e2:	6800      	ldr	r0, [r0, #0]
c0d016e4:	4288      	cmp	r0, r1
c0d016e6:	d001      	beq.n	c0d016ec <io_seproxyhal_button_push+0x40>
      G_button_same_mask_counter=0;
c0d016e8:	2000      	movs	r0, #0
c0d016ea:	6010      	str	r0, [r2, #0]
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
c0d016ec:	2d08      	cmp	r5, #8
c0d016ee:	d30b      	bcc.n	c0d01708 <io_seproxyhal_button_push+0x5c>
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d016f0:	2103      	movs	r1, #3
c0d016f2:	4628      	mov	r0, r5
c0d016f4:	f002 fcf6 	bl	c0d040e4 <__aeabi_uidivmod>
        button_mask |= BUTTON_EVT_FAST;
c0d016f8:	2001      	movs	r0, #1
c0d016fa:	0780      	lsls	r0, r0, #30
c0d016fc:	4330      	orrs	r0, r6
      G_button_same_mask_counter=0;
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d016fe:	2900      	cmp	r1, #0
c0d01700:	d000      	beq.n	c0d01704 <io_seproxyhal_button_push+0x58>
c0d01702:	4630      	mov	r0, r6
      }
      */

      // discard the release event after a fastskip has been detected, to avoid strange at release behavior
      // and also to enable user to cancel an operation by starting triggering the fast skip
      button_mask &= ~BUTTON_EVT_RELEASED;
c0d01704:	4038      	ands	r0, r7
c0d01706:	e000      	b.n	c0d0170a <io_seproxyhal_button_push+0x5e>
c0d01708:	4630      	mov	r0, r6
    }

    // indicate if button have been released
    button_callback(button_mask, button_same_mask_counter);
c0d0170a:	4629      	mov	r1, r5
c0d0170c:	47a0      	blx	r4
  }
}
c0d0170e:	b001      	add	sp, #4
c0d01710:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01712:	46c0      	nop			; (mov r8, r8)
c0d01714:	20001a70 	.word	0x20001a70
c0d01718:	20001a74 	.word	0x20001a74
c0d0171c:	7fffffff 	.word	0x7fffffff

c0d01720 <io_exchange>:

#ifdef HAVE_IO_U2F
u2f_service_t G_io_u2f;
#endif // HAVE_IO_U2F

unsigned short io_exchange(unsigned char channel, unsigned short tx_len) {
c0d01720:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01722:	b083      	sub	sp, #12
c0d01724:	460d      	mov	r5, r1
c0d01726:	4604      	mov	r4, r0
    }
  }
  after_debug:
#endif // DEBUG_APDU

  switch(channel&~(IO_FLAGS)) {
c0d01728:	200f      	movs	r0, #15
c0d0172a:	4204      	tst	r4, r0
c0d0172c:	d007      	beq.n	c0d0173e <io_exchange+0x1e>
      }
    }
    break;

  default:
    return io_exchange_al(channel, tx_len);
c0d0172e:	4620      	mov	r0, r4
c0d01730:	4629      	mov	r1, r5
c0d01732:	f7fe fd47 	bl	c0d001c4 <io_exchange_al>
c0d01736:	4605      	mov	r5, r0
  }
}
c0d01738:	b2a8      	uxth	r0, r5
c0d0173a:	b003      	add	sp, #12
c0d0173c:	bdf0      	pop	{r4, r5, r6, r7, pc}

  switch(channel&~(IO_FLAGS)) {
  case CHANNEL_APDU:
    // TODO work up the spi state machine over the HAL proxy until an APDU is available

    if (tx_len && !(channel&IO_ASYNCH_REPLY)) {
c0d0173e:	2610      	movs	r6, #16
c0d01740:	4026      	ands	r6, r4
c0d01742:	4f69      	ldr	r7, [pc, #420]	; (c0d018e8 <io_exchange+0x1c8>)
c0d01744:	2d00      	cmp	r5, #0
c0d01746:	d06f      	beq.n	c0d01828 <io_exchange+0x108>
c0d01748:	2e00      	cmp	r6, #0
c0d0174a:	d16d      	bne.n	c0d01828 <io_exchange+0x108>
      // prepare response timeout
      G_io_timeout = IO_RAPDU_TRANSMIT_TIMEOUT_MS;
c0d0174c:	207d      	movs	r0, #125	; 0x7d
c0d0174e:	0100      	lsls	r0, r0, #4
c0d01750:	4966      	ldr	r1, [pc, #408]	; (c0d018ec <io_exchange+0x1cc>)
c0d01752:	6008      	str	r0, [r1, #0]

      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
c0d01754:	4966      	ldr	r1, [pc, #408]	; (c0d018f0 <io_exchange+0x1d0>)
c0d01756:	7808      	ldrb	r0, [r1, #0]
c0d01758:	2808      	cmp	r0, #8
c0d0175a:	9702      	str	r7, [sp, #8]
c0d0175c:	dd17      	ble.n	c0d0178e <io_exchange+0x6e>
c0d0175e:	2809      	cmp	r0, #9
c0d01760:	d021      	beq.n	c0d017a6 <io_exchange+0x86>
c0d01762:	280a      	cmp	r0, #10
c0d01764:	d145      	bne.n	c0d017f2 <io_exchange+0xd2>
c0d01766:	460f      	mov	r7, r1
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
            break;

          case APDU_RAW:
            if (tx_len > sizeof(G_io_apdu_buffer)) {
c0d01768:	0868      	lsrs	r0, r5, #1
c0d0176a:	28a9      	cmp	r0, #169	; 0xa9
c0d0176c:	d300      	bcc.n	c0d01770 <io_exchange+0x50>
c0d0176e:	e0b7      	b.n	c0d018e0 <io_exchange+0x1c0>
              THROW(INVALID_PARAMETER);
            }
            // reply the RAW APDU over SEPROXYHAL protocol
            G_io_seproxyhal_spi_buffer[0]  = SEPROXYHAL_TAG_RAPDU;
c0d01770:	4862      	ldr	r0, [pc, #392]	; (c0d018fc <io_exchange+0x1dc>)
c0d01772:	2153      	movs	r1, #83	; 0x53
c0d01774:	7001      	strb	r1, [r0, #0]
            G_io_seproxyhal_spi_buffer[1]  = (tx_len)>>8;
c0d01776:	0a29      	lsrs	r1, r5, #8
c0d01778:	7041      	strb	r1, [r0, #1]
            G_io_seproxyhal_spi_buffer[2]  = (tx_len);
c0d0177a:	7085      	strb	r5, [r0, #2]
            io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d0177c:	2103      	movs	r1, #3
c0d0177e:	f000 fc47 	bl	c0d02010 <io_seproxyhal_spi_send>
            io_seproxyhal_spi_send(G_io_apdu_buffer, tx_len);
c0d01782:	485c      	ldr	r0, [pc, #368]	; (c0d018f4 <io_exchange+0x1d4>)
c0d01784:	4629      	mov	r1, r5
c0d01786:	f000 fc43 	bl	c0d02010 <io_seproxyhal_spi_send>
c0d0178a:	4639      	mov	r1, r7
c0d0178c:	e039      	b.n	c0d01802 <io_exchange+0xe2>
c0d0178e:	2807      	cmp	r0, #7
c0d01790:	d12d      	bne.n	c0d017ee <io_exchange+0xce>
            goto break_send;

#ifdef HAVE_USB_APDU
          case APDU_USB_HID:
            // only send, don't perform synchronous reception of the next command (will be done later by the seproxyhal packet processing)
            io_usb_hid_exchange(io_usb_send_apdu_data, tx_len, NULL, IO_RETURN_AFTER_TX);
c0d01792:	4860      	ldr	r0, [pc, #384]	; (c0d01914 <io_exchange+0x1f4>)
c0d01794:	4478      	add	r0, pc
c0d01796:	2200      	movs	r2, #0
c0d01798:	2320      	movs	r3, #32
c0d0179a:	460f      	mov	r7, r1
c0d0179c:	4629      	mov	r1, r5
c0d0179e:	f7ff fc09 	bl	c0d00fb4 <io_usb_hid_exchange>
c0d017a2:	4639      	mov	r1, r7
c0d017a4:	e02d      	b.n	c0d01802 <io_exchange+0xe2>
          // case to handle U2F channels. u2f apdu to be dispatched in the upper layers
          case APDU_U2F:
            // prepare reply, the remaining segments will be pumped during USB/BLE events handling while waiting for the next APDU

            // user presence + counter + rapdu + sw must fit the apdu buffer
            if (1+ 4+ tx_len +2 > sizeof(G_io_apdu_buffer)) {
c0d017a6:	1de8      	adds	r0, r5, #7
c0d017a8:	9001      	str	r0, [sp, #4]
c0d017aa:	0840      	lsrs	r0, r0, #1
c0d017ac:	28a9      	cmp	r0, #169	; 0xa9
c0d017ae:	d300      	bcc.n	c0d017b2 <io_exchange+0x92>
c0d017b0:	e096      	b.n	c0d018e0 <io_exchange+0x1c0>
              THROW(INVALID_PARAMETER);
            }

            // u2F tunnel needs the status words to be included in the signature response BLOB, do it now.
            // always return 9000 in the signature to avoid error @ transport level in u2f layers. 
            G_io_apdu_buffer[tx_len] = 0x90; //G_io_apdu_buffer[tx_len-2];
c0d017b2:	207c      	movs	r0, #124	; 0x7c
c0d017b4:	43c0      	mvns	r0, r0
c0d017b6:	300d      	adds	r0, #13
c0d017b8:	494e      	ldr	r1, [pc, #312]	; (c0d018f4 <io_exchange+0x1d4>)
c0d017ba:	5548      	strb	r0, [r1, r5]
c0d017bc:	1948      	adds	r0, r1, r5
c0d017be:	2700      	movs	r7, #0
            G_io_apdu_buffer[tx_len+1] = 0x00; //G_io_apdu_buffer[tx_len-1];
c0d017c0:	7047      	strb	r7, [r0, #1]
            tx_len += 2;
            os_memmove(G_io_apdu_buffer+5, G_io_apdu_buffer, tx_len);
c0d017c2:	9802      	ldr	r0, [sp, #8]
c0d017c4:	1d00      	adds	r0, r0, #4

            // u2F tunnel needs the status words to be included in the signature response BLOB, do it now.
            // always return 9000 in the signature to avoid error @ transport level in u2f layers. 
            G_io_apdu_buffer[tx_len] = 0x90; //G_io_apdu_buffer[tx_len-2];
            G_io_apdu_buffer[tx_len+1] = 0x00; //G_io_apdu_buffer[tx_len-1];
            tx_len += 2;
c0d017c6:	1caa      	adds	r2, r5, #2
            os_memmove(G_io_apdu_buffer+5, G_io_apdu_buffer, tx_len);
c0d017c8:	4002      	ands	r2, r0
c0d017ca:	1d48      	adds	r0, r1, #5
c0d017cc:	460d      	mov	r5, r1
c0d017ce:	f7ff fbd0 	bl	c0d00f72 <os_memmove>
c0d017d2:	2205      	movs	r2, #5
            // zeroize user presence and counter
            os_memset(G_io_apdu_buffer, 0, 5);
c0d017d4:	4628      	mov	r0, r5
c0d017d6:	4639      	mov	r1, r7
c0d017d8:	f7ff fbc2 	bl	c0d00f60 <os_memset>
            u2f_message_reply(&G_io_u2f, U2F_CMD_MSG, G_io_apdu_buffer, tx_len+5);
c0d017dc:	9801      	ldr	r0, [sp, #4]
c0d017de:	b283      	uxth	r3, r0
c0d017e0:	4845      	ldr	r0, [pc, #276]	; (c0d018f8 <io_exchange+0x1d8>)
c0d017e2:	2183      	movs	r1, #131	; 0x83
c0d017e4:	462a      	mov	r2, r5
c0d017e6:	f000 ff9f 	bl	c0d02728 <u2f_message_reply>
c0d017ea:	4941      	ldr	r1, [pc, #260]	; (c0d018f0 <io_exchange+0x1d0>)
c0d017ec:	e009      	b.n	c0d01802 <io_exchange+0xe2>
c0d017ee:	2800      	cmp	r0, #0
c0d017f0:	d073      	beq.n	c0d018da <io_exchange+0x1ba>
      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
          default: 
            // delegate to the hal in case of not generic transport mode (or asynch)
            if (io_exchange_al(channel, tx_len) == 0) {
c0d017f2:	4620      	mov	r0, r4
c0d017f4:	460f      	mov	r7, r1
c0d017f6:	4629      	mov	r1, r5
c0d017f8:	f7fe fce4 	bl	c0d001c4 <io_exchange_al>
c0d017fc:	4639      	mov	r1, r7
c0d017fe:	2800      	cmp	r0, #0
c0d01800:	d16b      	bne.n	c0d018da <io_exchange+0x1ba>
c0d01802:	2500      	movs	r5, #0
        }
        continue;

      break_send:
        // reset apdu state
        G_io_apdu_state = APDU_IDLE;
c0d01804:	700d      	strb	r5, [r1, #0]
        G_io_apdu_offset = 0;
c0d01806:	483e      	ldr	r0, [pc, #248]	; (c0d01900 <io_exchange+0x1e0>)
c0d01808:	8005      	strh	r5, [r0, #0]
        G_io_apdu_length = 0;
c0d0180a:	483e      	ldr	r0, [pc, #248]	; (c0d01904 <io_exchange+0x1e4>)
c0d0180c:	8005      	strh	r5, [r0, #0]
        G_io_apdu_seq = 0;
c0d0180e:	483e      	ldr	r0, [pc, #248]	; (c0d01908 <io_exchange+0x1e8>)
c0d01810:	8005      	strh	r5, [r0, #0]
        G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d01812:	483e      	ldr	r0, [pc, #248]	; (c0d0190c <io_exchange+0x1ec>)
c0d01814:	7005      	strb	r5, [r0, #0]

        // continue sending commands, don't issue status yet
        if (channel & IO_RETURN_AFTER_TX) {
c0d01816:	06a0      	lsls	r0, r4, #26
c0d01818:	d48e      	bmi.n	c0d01738 <io_exchange+0x18>
          return 0;
        }
        // acknowledge the write request (general status OK) and no more command to follow (wait until another APDU container is received to continue unwrapping)
        io_seproxyhal_general_status();
c0d0181a:	f7ff fc6b 	bl	c0d010f4 <io_seproxyhal_general_status>
        break;
      }

      // perform reset after io exchange
      if (channel & IO_RESET_AFTER_REPLIED) {
c0d0181e:	0620      	lsls	r0, r4, #24
c0d01820:	9f02      	ldr	r7, [sp, #8]
c0d01822:	d501      	bpl.n	c0d01828 <io_exchange+0x108>
        reset();
c0d01824:	f000 fabe 	bl	c0d01da4 <reset>
      }
    }

    if (!(channel&IO_ASYNCH_REPLY)) {
c0d01828:	2e00      	cmp	r6, #0
c0d0182a:	d10c      	bne.n	c0d01846 <io_exchange+0x126>
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
c0d0182c:	0660      	lsls	r0, r4, #25
c0d0182e:	d450      	bmi.n	c0d018d2 <io_exchange+0x1b2>
        // return apdu data - header
        return G_io_apdu_length-5;
      }

      // reply has ended, proceed to next apdu reception (reset status only after asynch reply)
      G_io_apdu_state = APDU_IDLE;
c0d01830:	482f      	ldr	r0, [pc, #188]	; (c0d018f0 <io_exchange+0x1d0>)
c0d01832:	2100      	movs	r1, #0
c0d01834:	7001      	strb	r1, [r0, #0]
      G_io_apdu_offset = 0;
c0d01836:	4832      	ldr	r0, [pc, #200]	; (c0d01900 <io_exchange+0x1e0>)
c0d01838:	8001      	strh	r1, [r0, #0]
      G_io_apdu_length = 0;
c0d0183a:	4832      	ldr	r0, [pc, #200]	; (c0d01904 <io_exchange+0x1e4>)
c0d0183c:	8001      	strh	r1, [r0, #0]
      G_io_apdu_seq = 0;
c0d0183e:	4832      	ldr	r0, [pc, #200]	; (c0d01908 <io_exchange+0x1e8>)
c0d01840:	8001      	strh	r1, [r0, #0]
      G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d01842:	4832      	ldr	r0, [pc, #200]	; (c0d0190c <io_exchange+0x1ec>)
c0d01844:	7001      	strb	r1, [r0, #0]
c0d01846:	4c2d      	ldr	r4, [pc, #180]	; (c0d018fc <io_exchange+0x1dc>)
c0d01848:	4e2e      	ldr	r6, [pc, #184]	; (c0d01904 <io_exchange+0x1e4>)
c0d0184a:	4f2f      	ldr	r7, [pc, #188]	; (c0d01908 <io_exchange+0x1e8>)
c0d0184c:	e002      	b.n	c0d01854 <io_exchange+0x134>
          break;
#endif // HAVE_IO_USB

        default:
          // tell the application that a non-apdu packet has been received
          io_event(CHANNEL_SPI);
c0d0184e:	2002      	movs	r0, #2
c0d01850:	f7fe fce4 	bl	c0d0021c <io_event>

    // ensure ready to receive an event (after an apdu processing with asynch flag, it may occur if the channel is not correctly managed)

    // until a new whole CAPDU is received
    for (;;) {
      if (!io_seproxyhal_spi_is_status_sent()) {
c0d01854:	f000 fbf2 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d01858:	2800      	cmp	r0, #0
c0d0185a:	d101      	bne.n	c0d01860 <io_exchange+0x140>
        io_seproxyhal_general_status();
c0d0185c:	f7ff fc4a 	bl	c0d010f4 <io_seproxyhal_general_status>
      }

      // wait until a SPI packet is available
      // NOTE: on ST31, dual wait ISO & RF (ISO instead of SPI)
      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d01860:	2180      	movs	r1, #128	; 0x80
c0d01862:	2500      	movs	r5, #0
c0d01864:	4620      	mov	r0, r4
c0d01866:	462a      	mov	r2, r5
c0d01868:	f000 fbfe 	bl	c0d02068 <io_seproxyhal_spi_recv>

      // can't process split TLV, continue
      if (rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
c0d0186c:	1ec1      	subs	r1, r0, #3
c0d0186e:	78a2      	ldrb	r2, [r4, #2]
c0d01870:	7863      	ldrb	r3, [r4, #1]
c0d01872:	021b      	lsls	r3, r3, #8
c0d01874:	4313      	orrs	r3, r2
c0d01876:	4299      	cmp	r1, r3
c0d01878:	d115      	bne.n	c0d018a6 <io_exchange+0x186>
      send_last_command:
        continue;
      }

      // if an apdu is already ongoing, then discard packet as a new packet
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
c0d0187a:	4924      	ldr	r1, [pc, #144]	; (c0d0190c <io_exchange+0x1ec>)
c0d0187c:	7809      	ldrb	r1, [r1, #0]
c0d0187e:	2900      	cmp	r1, #0
c0d01880:	d002      	beq.n	c0d01888 <io_exchange+0x168>
        io_seproxyhal_handle_event();
c0d01882:	f7ff fcf1 	bl	c0d01268 <io_seproxyhal_handle_event>
c0d01886:	e7e5      	b.n	c0d01854 <io_exchange+0x134>
        continue;
      }

      // depending on received TAG
      switch(G_io_seproxyhal_spi_buffer[0]) {
c0d01888:	7821      	ldrb	r1, [r4, #0]
c0d0188a:	290f      	cmp	r1, #15
c0d0188c:	d006      	beq.n	c0d0189c <io_exchange+0x17c>
c0d0188e:	2910      	cmp	r1, #16
c0d01890:	d011      	beq.n	c0d018b6 <io_exchange+0x196>
c0d01892:	2916      	cmp	r1, #22
c0d01894:	d1db      	bne.n	c0d0184e <io_exchange+0x12e>

        case SEPROXYHAL_TAG_CAPDU_EVENT:
          io_seproxyhal_handle_capdu_event();
c0d01896:	f7ff fd33 	bl	c0d01300 <io_seproxyhal_handle_capdu_event>
c0d0189a:	e011      	b.n	c0d018c0 <io_exchange+0x1a0>
          goto send_last_command;
#endif // HAVE_BLE

#ifdef HAVE_IO_USB
        case SEPROXYHAL_TAG_USB_EVENT:
          if (rx_len != 3+1) {
c0d0189c:	2804      	cmp	r0, #4
c0d0189e:	d102      	bne.n	c0d018a6 <io_exchange+0x186>
            // invalid length, not processable
            goto invalid_apdu_packet;
          }
          io_seproxyhal_handle_usb_event();
c0d018a0:	f7ff fc3c 	bl	c0d0111c <io_seproxyhal_handle_usb_event>
c0d018a4:	e7d6      	b.n	c0d01854 <io_exchange+0x134>
c0d018a6:	2000      	movs	r0, #0

      // can't process split TLV, continue
      if (rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
        LOG("invalid TLV format\n");
      invalid_apdu_packet:
        G_io_apdu_state = APDU_IDLE;
c0d018a8:	4911      	ldr	r1, [pc, #68]	; (c0d018f0 <io_exchange+0x1d0>)
c0d018aa:	7008      	strb	r0, [r1, #0]
        G_io_apdu_offset = 0;
c0d018ac:	4914      	ldr	r1, [pc, #80]	; (c0d01900 <io_exchange+0x1e0>)
c0d018ae:	8008      	strh	r0, [r1, #0]
        G_io_apdu_length = 0;
c0d018b0:	8030      	strh	r0, [r6, #0]
        G_io_apdu_seq = 0;
c0d018b2:	8038      	strh	r0, [r7, #0]
c0d018b4:	e7ce      	b.n	c0d01854 <io_exchange+0x134>

          // no state change, we're not dealing with an apdu yet
          goto send_last_command;

        case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
          if (rx_len < 3+3) {
c0d018b6:	2806      	cmp	r0, #6
c0d018b8:	d200      	bcs.n	c0d018bc <io_exchange+0x19c>
c0d018ba:	e73d      	b.n	c0d01738 <io_exchange+0x18>
            // error !
            return 0;
          }
          io_seproxyhal_handle_usb_ep_xfer_event();
c0d018bc:	f7ff fc64 	bl	c0d01188 <io_seproxyhal_handle_usb_ep_xfer_event>
c0d018c0:	8830      	ldrh	r0, [r6, #0]
c0d018c2:	2800      	cmp	r0, #0
c0d018c4:	d0c6      	beq.n	c0d01854 <io_exchange+0x134>
c0d018c6:	4812      	ldr	r0, [pc, #72]	; (c0d01910 <io_exchange+0x1f0>)
c0d018c8:	6800      	ldr	r0, [r0, #0]
c0d018ca:	4908      	ldr	r1, [pc, #32]	; (c0d018ec <io_exchange+0x1cc>)
c0d018cc:	6008      	str	r0, [r1, #0]
c0d018ce:	8835      	ldrh	r5, [r6, #0]
c0d018d0:	e732      	b.n	c0d01738 <io_exchange+0x18>
    if (!(channel&IO_ASYNCH_REPLY)) {
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
        // return apdu data - header
        return G_io_apdu_length-5;
c0d018d2:	480c      	ldr	r0, [pc, #48]	; (c0d01904 <io_exchange+0x1e4>)
c0d018d4:	8800      	ldrh	r0, [r0, #0]
c0d018d6:	19c5      	adds	r5, r0, r7
c0d018d8:	e72e      	b.n	c0d01738 <io_exchange+0x18>
            if (io_exchange_al(channel, tx_len) == 0) {
              goto break_send;
            }
          case APDU_IDLE:
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
c0d018da:	2009      	movs	r0, #9
c0d018dc:	f7ff fbfd 	bl	c0d010da <os_longjmp>
c0d018e0:	2002      	movs	r0, #2
c0d018e2:	f7ff fbfa 	bl	c0d010da <os_longjmp>
c0d018e6:	46c0      	nop			; (mov r8, r8)
c0d018e8:	0000fffb 	.word	0x0000fffb
c0d018ec:	20001a58 	.word	0x20001a58
c0d018f0:	20001a64 	.word	0x20001a64
c0d018f4:	200018f8 	.word	0x200018f8
c0d018f8:	20001a78 	.word	0x20001a78
c0d018fc:	20001800 	.word	0x20001800
c0d01900:	20001a68 	.word	0x20001a68
c0d01904:	20001a66 	.word	0x20001a66
c0d01908:	20001a6a 	.word	0x20001a6a
c0d0190c:	20001a5c 	.word	0x20001a5c
c0d01910:	20001a54 	.word	0x20001a54
c0d01914:	fffffb59 	.word	0xfffffb59

c0d01918 <ux_check_status_default>:
}

void ux_check_status_default(unsigned int status) {
  // nothing to be done here by default.
  UNUSED(status);
}
c0d01918:	4770      	bx	lr
	...

c0d0191c <snprintf>:
#endif // HAVE_PRINTF

#ifdef HAVE_SPRINTF
//unsigned int snprintf(unsigned char * str, unsigned int str_size, const char* format, ...)
int snprintf(char * str, size_t str_size, const char * format, ...)
 {
c0d0191c:	b081      	sub	sp, #4
c0d0191e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01920:	b090      	sub	sp, #64	; 0x40
c0d01922:	4616      	mov	r6, r2
c0d01924:	460c      	mov	r4, r1
c0d01926:	900a      	str	r0, [sp, #40]	; 0x28
c0d01928:	9315      	str	r3, [sp, #84]	; 0x54
    char cStrlenSet;
    
    //
    // Check the arguments.
    //
    if(format == 0 || str == 0 ||str_size < 2) {
c0d0192a:	2c02      	cmp	r4, #2
c0d0192c:	d200      	bcs.n	c0d01930 <snprintf+0x14>
c0d0192e:	e1f0      	b.n	c0d01d12 <snprintf+0x3f6>
c0d01930:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01932:	2800      	cmp	r0, #0
c0d01934:	d100      	bne.n	c0d01938 <snprintf+0x1c>
c0d01936:	e1ec      	b.n	c0d01d12 <snprintf+0x3f6>
c0d01938:	2e00      	cmp	r6, #0
c0d0193a:	d100      	bne.n	c0d0193e <snprintf+0x22>
c0d0193c:	e1e9      	b.n	c0d01d12 <snprintf+0x3f6>
c0d0193e:	2100      	movs	r1, #0
      return 0;
    }

    // ensure terminating string with a \0
    os_memset(str, 0, str_size);
c0d01940:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01942:	9107      	str	r1, [sp, #28]
c0d01944:	4622      	mov	r2, r4
c0d01946:	f7ff fb0b 	bl	c0d00f60 <os_memset>
c0d0194a:	a815      	add	r0, sp, #84	; 0x54


    //
    // Start the varargs processing.
    //
    va_start(vaArgP, format);
c0d0194c:	900b      	str	r0, [sp, #44]	; 0x2c

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0d0194e:	7830      	ldrb	r0, [r6, #0]
c0d01950:	2800      	cmp	r0, #0
c0d01952:	d100      	bne.n	c0d01956 <snprintf+0x3a>
c0d01954:	e1dd      	b.n	c0d01d12 <snprintf+0x3f6>
c0d01956:	9907      	ldr	r1, [sp, #28]
c0d01958:	43c9      	mvns	r1, r1
      return 0;
    }

    // ensure terminating string with a \0
    os_memset(str, 0, str_size);
    str_size--;
c0d0195a:	1e65      	subs	r5, r4, #1
c0d0195c:	9105      	str	r1, [sp, #20]
c0d0195e:	e1bd      	b.n	c0d01cdc <snprintf+0x3c0>
        }

        //
        // Skip the portion of the string that was written.
        //
        format += ulIdx;
c0d01960:	1930      	adds	r0, r6, r4

        //
        // See if the next character is a %.
        //
        if(*format == '%')
c0d01962:	5d31      	ldrb	r1, [r6, r4]
c0d01964:	2925      	cmp	r1, #37	; 0x25
c0d01966:	d10b      	bne.n	c0d01980 <snprintf+0x64>
c0d01968:	9303      	str	r3, [sp, #12]
c0d0196a:	9202      	str	r2, [sp, #8]
        {
            //
            // Skip the %.
            //
            format++;
c0d0196c:	1c43      	adds	r3, r0, #1
c0d0196e:	2000      	movs	r0, #0
c0d01970:	2120      	movs	r1, #32
c0d01972:	9108      	str	r1, [sp, #32]
c0d01974:	210a      	movs	r1, #10
c0d01976:	9101      	str	r1, [sp, #4]
c0d01978:	9000      	str	r0, [sp, #0]
c0d0197a:	9004      	str	r0, [sp, #16]
c0d0197c:	9009      	str	r0, [sp, #36]	; 0x24
c0d0197e:	e056      	b.n	c0d01a2e <snprintf+0x112>
c0d01980:	4606      	mov	r6, r0
c0d01982:	920a      	str	r2, [sp, #40]	; 0x28
c0d01984:	e11e      	b.n	c0d01bc4 <snprintf+0x2a8>
c0d01986:	4633      	mov	r3, r6
c0d01988:	4608      	mov	r0, r1
c0d0198a:	e04b      	b.n	c0d01a24 <snprintf+0x108>
c0d0198c:	2b47      	cmp	r3, #71	; 0x47
c0d0198e:	dc13      	bgt.n	c0d019b8 <snprintf+0x9c>
c0d01990:	4619      	mov	r1, r3
c0d01992:	3930      	subs	r1, #48	; 0x30
c0d01994:	290a      	cmp	r1, #10
c0d01996:	d234      	bcs.n	c0d01a02 <snprintf+0xe6>
                {
                    //
                    // If this is a zero, and it is the first digit, then the
                    // fill character is a zero instead of a space.
                    //
                    if((format[-1] == '0') && (ulCount == 0))
c0d01998:	2b30      	cmp	r3, #48	; 0x30
c0d0199a:	9908      	ldr	r1, [sp, #32]
c0d0199c:	d100      	bne.n	c0d019a0 <snprintf+0x84>
c0d0199e:	4619      	mov	r1, r3
c0d019a0:	9d09      	ldr	r5, [sp, #36]	; 0x24
c0d019a2:	2d00      	cmp	r5, #0
c0d019a4:	d000      	beq.n	c0d019a8 <snprintf+0x8c>
c0d019a6:	9908      	ldr	r1, [sp, #32]
                    }

                    //
                    // Update the digit count.
                    //
                    ulCount *= 10;
c0d019a8:	220a      	movs	r2, #10
c0d019aa:	436a      	muls	r2, r5
                    ulCount += format[-1] - '0';
c0d019ac:	18d2      	adds	r2, r2, r3
c0d019ae:	3a30      	subs	r2, #48	; 0x30
c0d019b0:	9209      	str	r2, [sp, #36]	; 0x24
c0d019b2:	4633      	mov	r3, r6
c0d019b4:	9108      	str	r1, [sp, #32]
c0d019b6:	e03a      	b.n	c0d01a2e <snprintf+0x112>
c0d019b8:	2b67      	cmp	r3, #103	; 0x67
c0d019ba:	dd04      	ble.n	c0d019c6 <snprintf+0xaa>
c0d019bc:	2b72      	cmp	r3, #114	; 0x72
c0d019be:	dd09      	ble.n	c0d019d4 <snprintf+0xb8>
c0d019c0:	2b73      	cmp	r3, #115	; 0x73
c0d019c2:	d146      	bne.n	c0d01a52 <snprintf+0x136>
c0d019c4:	e00a      	b.n	c0d019dc <snprintf+0xc0>
c0d019c6:	2b62      	cmp	r3, #98	; 0x62
c0d019c8:	dc48      	bgt.n	c0d01a5c <snprintf+0x140>
c0d019ca:	2b48      	cmp	r3, #72	; 0x48
c0d019cc:	d155      	bne.n	c0d01a7a <snprintf+0x15e>
c0d019ce:	2201      	movs	r2, #1
c0d019d0:	9204      	str	r2, [sp, #16]
c0d019d2:	e001      	b.n	c0d019d8 <snprintf+0xbc>
c0d019d4:	2b68      	cmp	r3, #104	; 0x68
c0d019d6:	d156      	bne.n	c0d01a86 <snprintf+0x16a>
c0d019d8:	2210      	movs	r2, #16
c0d019da:	9201      	str	r2, [sp, #4]
                case_s:
                {
                    //
                    // Get the string pointer from the varargs.
                    //
                    pcStr = va_arg(vaArgP, char *);
c0d019dc:	9a0b      	ldr	r2, [sp, #44]	; 0x2c
c0d019de:	1d13      	adds	r3, r2, #4
c0d019e0:	930b      	str	r3, [sp, #44]	; 0x2c
c0d019e2:	2303      	movs	r3, #3
c0d019e4:	4018      	ands	r0, r3
c0d019e6:	1c4d      	adds	r5, r1, #1
c0d019e8:	6811      	ldr	r1, [r2, #0]

                    //
                    // Determine the length of the string. (if not specified using .*)
                    //
                    switch(cStrlenSet) {
c0d019ea:	2801      	cmp	r0, #1
c0d019ec:	d100      	bne.n	c0d019f0 <snprintf+0xd4>
c0d019ee:	e0ce      	b.n	c0d01b8e <snprintf+0x272>
c0d019f0:	2802      	cmp	r0, #2
c0d019f2:	d100      	bne.n	c0d019f6 <snprintf+0xda>
c0d019f4:	e0d0      	b.n	c0d01b98 <snprintf+0x27c>
c0d019f6:	2803      	cmp	r0, #3
c0d019f8:	4633      	mov	r3, r6
c0d019fa:	4628      	mov	r0, r5
c0d019fc:	9d06      	ldr	r5, [sp, #24]
c0d019fe:	d016      	beq.n	c0d01a2e <snprintf+0x112>
c0d01a00:	e0e7      	b.n	c0d01bd2 <snprintf+0x2b6>
c0d01a02:	2b2e      	cmp	r3, #46	; 0x2e
c0d01a04:	d000      	beq.n	c0d01a08 <snprintf+0xec>
c0d01a06:	e0ca      	b.n	c0d01b9e <snprintf+0x282>
                // special %.*H or %.*h format to print a given length of hex digits (case: H UPPER, h lower)
                //
                case '.':
                {
                  // ensure next char is '*' and next one is 's'/'h'/'H'
                  if (format[0] == '*' && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0d01a08:	7830      	ldrb	r0, [r6, #0]
c0d01a0a:	282a      	cmp	r0, #42	; 0x2a
c0d01a0c:	d000      	beq.n	c0d01a10 <snprintf+0xf4>
c0d01a0e:	e0c6      	b.n	c0d01b9e <snprintf+0x282>
c0d01a10:	7871      	ldrb	r1, [r6, #1]
c0d01a12:	1c73      	adds	r3, r6, #1
c0d01a14:	2001      	movs	r0, #1
c0d01a16:	2948      	cmp	r1, #72	; 0x48
c0d01a18:	d004      	beq.n	c0d01a24 <snprintf+0x108>
c0d01a1a:	2968      	cmp	r1, #104	; 0x68
c0d01a1c:	d002      	beq.n	c0d01a24 <snprintf+0x108>
c0d01a1e:	2973      	cmp	r1, #115	; 0x73
c0d01a20:	d000      	beq.n	c0d01a24 <snprintf+0x108>
c0d01a22:	e0bc      	b.n	c0d01b9e <snprintf+0x282>
c0d01a24:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d01a26:	1d0a      	adds	r2, r1, #4
c0d01a28:	920b      	str	r2, [sp, #44]	; 0x2c
c0d01a2a:	6809      	ldr	r1, [r1, #0]
int snprintf(char * str, size_t str_size, const char * format, ...)
 {
    unsigned int ulIdx, ulValue, ulPos, ulCount, ulBase, ulNeg, ulStrlen, ulCap;
    char *pcStr, pcBuf[16], cFill;
    va_list vaArgP;
    char cStrlenSet;
c0d01a2c:	9100      	str	r1, [sp, #0]
c0d01a2e:	2102      	movs	r1, #2
c0d01a30:	461e      	mov	r6, r3
again:

            //
            // Determine how to handle the next character.
            //
            switch(*format++)
c0d01a32:	7833      	ldrb	r3, [r6, #0]
c0d01a34:	1c76      	adds	r6, r6, #1
c0d01a36:	2200      	movs	r2, #0
c0d01a38:	2b2d      	cmp	r3, #45	; 0x2d
c0d01a3a:	dca7      	bgt.n	c0d0198c <snprintf+0x70>
c0d01a3c:	4610      	mov	r0, r2
c0d01a3e:	d0f8      	beq.n	c0d01a32 <snprintf+0x116>
c0d01a40:	2b25      	cmp	r3, #37	; 0x25
c0d01a42:	d02a      	beq.n	c0d01a9a <snprintf+0x17e>
c0d01a44:	2b2a      	cmp	r3, #42	; 0x2a
c0d01a46:	d000      	beq.n	c0d01a4a <snprintf+0x12e>
c0d01a48:	e0a9      	b.n	c0d01b9e <snprintf+0x282>
                  goto error;
                }
                
                case '*':
                {
                  if (*format == 's' ) {                    
c0d01a4a:	7830      	ldrb	r0, [r6, #0]
c0d01a4c:	2873      	cmp	r0, #115	; 0x73
c0d01a4e:	d09a      	beq.n	c0d01986 <snprintf+0x6a>
c0d01a50:	e0a5      	b.n	c0d01b9e <snprintf+0x282>
c0d01a52:	2b75      	cmp	r3, #117	; 0x75
c0d01a54:	d023      	beq.n	c0d01a9e <snprintf+0x182>
c0d01a56:	2b78      	cmp	r3, #120	; 0x78
c0d01a58:	d018      	beq.n	c0d01a8c <snprintf+0x170>
c0d01a5a:	e0a0      	b.n	c0d01b9e <snprintf+0x282>
c0d01a5c:	2b63      	cmp	r3, #99	; 0x63
c0d01a5e:	d100      	bne.n	c0d01a62 <snprintf+0x146>
c0d01a60:	e08b      	b.n	c0d01b7a <snprintf+0x25e>
c0d01a62:	2b64      	cmp	r3, #100	; 0x64
c0d01a64:	d000      	beq.n	c0d01a68 <snprintf+0x14c>
c0d01a66:	e09a      	b.n	c0d01b9e <snprintf+0x282>
                case 'd':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01a68:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01a6a:	1d01      	adds	r1, r0, #4
c0d01a6c:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01a6e:	6800      	ldr	r0, [r0, #0]
c0d01a70:	17c1      	asrs	r1, r0, #31
c0d01a72:	1842      	adds	r2, r0, r1
c0d01a74:	404a      	eors	r2, r1

                    //
                    // If the value is negative, make it positive and indicate
                    // that a minus sign is needed.
                    //
                    if((long)ulValue < 0)
c0d01a76:	0fc0      	lsrs	r0, r0, #31
c0d01a78:	e016      	b.n	c0d01aa8 <snprintf+0x18c>
c0d01a7a:	2b58      	cmp	r3, #88	; 0x58
c0d01a7c:	d000      	beq.n	c0d01a80 <snprintf+0x164>
c0d01a7e:	e08e      	b.n	c0d01b9e <snprintf+0x282>
c0d01a80:	2001      	movs	r0, #1

#ifdef HAVE_SPRINTF
//unsigned int snprintf(unsigned char * str, unsigned int str_size, const char* format, ...)
int snprintf(char * str, size_t str_size, const char * format, ...)
 {
    unsigned int ulIdx, ulValue, ulPos, ulCount, ulBase, ulNeg, ulStrlen, ulCap;
c0d01a82:	9004      	str	r0, [sp, #16]
c0d01a84:	e002      	b.n	c0d01a8c <snprintf+0x170>
c0d01a86:	2b70      	cmp	r3, #112	; 0x70
c0d01a88:	d000      	beq.n	c0d01a8c <snprintf+0x170>
c0d01a8a:	e088      	b.n	c0d01b9e <snprintf+0x282>
                case 'p':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01a8c:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01a8e:	1d01      	adds	r1, r0, #4
c0d01a90:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01a92:	6802      	ldr	r2, [r0, #0]
c0d01a94:	2000      	movs	r0, #0
c0d01a96:	2510      	movs	r5, #16
c0d01a98:	e007      	b.n	c0d01aaa <snprintf+0x18e>
                case '%':
                {
                    //
                    // Simply write a single %.
                    //
                    str[0] = '%';
c0d01a9a:	2025      	movs	r0, #37	; 0x25
c0d01a9c:	e071      	b.n	c0d01b82 <snprintf+0x266>
                case 'u':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01a9e:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01aa0:	1d01      	adds	r1, r0, #4
c0d01aa2:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01aa4:	6802      	ldr	r2, [r0, #0]
c0d01aa6:	2000      	movs	r0, #0
c0d01aa8:	250a      	movs	r5, #10
c0d01aaa:	9006      	str	r0, [sp, #24]
c0d01aac:	2701      	movs	r7, #1
c0d01aae:	920a      	str	r2, [sp, #40]	; 0x28
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
                        (((ulIdx * ulBase) <= ulValue) &&
c0d01ab0:	4295      	cmp	r5, r2
c0d01ab2:	d812      	bhi.n	c0d01ada <snprintf+0x1be>
c0d01ab4:	2401      	movs	r4, #1
c0d01ab6:	4628      	mov	r0, r5
c0d01ab8:	4607      	mov	r7, r0
                         (((ulIdx * ulBase) / ulBase) == ulIdx));
c0d01aba:	4629      	mov	r1, r5
c0d01abc:	f002 fa8c 	bl	c0d03fd8 <__aeabi_uidiv>
                    //
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
c0d01ac0:	42a0      	cmp	r0, r4
c0d01ac2:	d109      	bne.n	c0d01ad8 <snprintf+0x1bc>
                        (((ulIdx * ulBase) <= ulValue) &&
c0d01ac4:	4628      	mov	r0, r5
c0d01ac6:	4378      	muls	r0, r7
                         (((ulIdx * ulBase) / ulBase) == ulIdx));
                        ulIdx *= ulBase, ulCount--)
c0d01ac8:	9909      	ldr	r1, [sp, #36]	; 0x24
c0d01aca:	1e49      	subs	r1, r1, #1
                    // Determine the number of digits in the string version of
                    // the value.
                    //
convert:
                    for(ulIdx = 1;
                        (((ulIdx * ulBase) <= ulValue) &&
c0d01acc:	9109      	str	r1, [sp, #36]	; 0x24
c0d01ace:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d01ad0:	4288      	cmp	r0, r1
c0d01ad2:	463c      	mov	r4, r7
c0d01ad4:	d9f0      	bls.n	c0d01ab8 <snprintf+0x19c>
c0d01ad6:	e000      	b.n	c0d01ada <snprintf+0x1be>
c0d01ad8:	4627      	mov	r7, r4

                    //
                    // If the value is negative, reduce the count of padding
                    // characters needed.
                    //
                    if(ulNeg)
c0d01ada:	2400      	movs	r4, #0
c0d01adc:	43e1      	mvns	r1, r4
c0d01ade:	9b06      	ldr	r3, [sp, #24]
c0d01ae0:	2b00      	cmp	r3, #0
c0d01ae2:	d100      	bne.n	c0d01ae6 <snprintf+0x1ca>
c0d01ae4:	4619      	mov	r1, r3
c0d01ae6:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01ae8:	9101      	str	r1, [sp, #4]
c0d01aea:	1840      	adds	r0, r0, r1

                    //
                    // If the value is negative and the value is padded with
                    // zeros, then place the minus sign before the padding.
                    //
                    if(ulNeg && (cFill == '0'))
c0d01aec:	9908      	ldr	r1, [sp, #32]
c0d01aee:	b2ca      	uxtb	r2, r1
c0d01af0:	2a30      	cmp	r2, #48	; 0x30
c0d01af2:	d106      	bne.n	c0d01b02 <snprintf+0x1e6>
c0d01af4:	2b00      	cmp	r3, #0
c0d01af6:	d004      	beq.n	c0d01b02 <snprintf+0x1e6>
c0d01af8:	a90c      	add	r1, sp, #48	; 0x30
                    {
                        //
                        // Place the minus sign in the output buffer.
                        //
                        pcBuf[ulPos++] = '-';
c0d01afa:	232d      	movs	r3, #45	; 0x2d
c0d01afc:	700b      	strb	r3, [r1, #0]
c0d01afe:	2300      	movs	r3, #0
c0d01b00:	2401      	movs	r4, #1

                    //
                    // Provide additional padding at the beginning of the
                    // string conversion if needed.
                    //
                    if((ulCount > 1) && (ulCount < 16))
c0d01b02:	1e81      	subs	r1, r0, #2
c0d01b04:	290d      	cmp	r1, #13
c0d01b06:	d80c      	bhi.n	c0d01b22 <snprintf+0x206>
c0d01b08:	1e41      	subs	r1, r0, #1
c0d01b0a:	d00a      	beq.n	c0d01b22 <snprintf+0x206>
c0d01b0c:	a80c      	add	r0, sp, #48	; 0x30
                    {
                        for(ulCount--; ulCount; ulCount--)
                        {
                            pcBuf[ulPos++] = cFill;
c0d01b0e:	4320      	orrs	r0, r4
c0d01b10:	9306      	str	r3, [sp, #24]
c0d01b12:	f002 faf7 	bl	c0d04104 <__aeabi_memset>
c0d01b16:	9b06      	ldr	r3, [sp, #24]
c0d01b18:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01b1a:	1900      	adds	r0, r0, r4
c0d01b1c:	9901      	ldr	r1, [sp, #4]
c0d01b1e:	1840      	adds	r0, r0, r1
c0d01b20:	1e44      	subs	r4, r0, #1

                    //
                    // If the value is negative, then place the minus sign
                    // before the number.
                    //
                    if(ulNeg)
c0d01b22:	2b00      	cmp	r3, #0
c0d01b24:	d003      	beq.n	c0d01b2e <snprintf+0x212>
c0d01b26:	a80c      	add	r0, sp, #48	; 0x30
                    {
                        //
                        // Place the minus sign in the output buffer.
                        //
                        pcBuf[ulPos++] = '-';
c0d01b28:	212d      	movs	r1, #45	; 0x2d
c0d01b2a:	5501      	strb	r1, [r0, r4]
c0d01b2c:	1c64      	adds	r4, r4, #1
c0d01b2e:	9804      	ldr	r0, [sp, #16]
                    }

                    //
                    // Convert the value into a string.
                    //
                    for(; ulIdx; ulIdx /= ulBase)
c0d01b30:	2f00      	cmp	r7, #0
c0d01b32:	d018      	beq.n	c0d01b66 <snprintf+0x24a>
c0d01b34:	2800      	cmp	r0, #0
c0d01b36:	d001      	beq.n	c0d01b3c <snprintf+0x220>
c0d01b38:	a079      	add	r0, pc, #484	; (adr r0, c0d01d20 <g_pcHex_cap>)
c0d01b3a:	e000      	b.n	c0d01b3e <snprintf+0x222>
c0d01b3c:	a07c      	add	r0, pc, #496	; (adr r0, c0d01d30 <g_pcHex>)
c0d01b3e:	9009      	str	r0, [sp, #36]	; 0x24
c0d01b40:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01b42:	4639      	mov	r1, r7
c0d01b44:	f002 fa48 	bl	c0d03fd8 <__aeabi_uidiv>
c0d01b48:	4629      	mov	r1, r5
c0d01b4a:	f002 facb 	bl	c0d040e4 <__aeabi_uidivmod>
c0d01b4e:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01b50:	5c40      	ldrb	r0, [r0, r1]
c0d01b52:	a90c      	add	r1, sp, #48	; 0x30
c0d01b54:	5508      	strb	r0, [r1, r4]
c0d01b56:	4638      	mov	r0, r7
c0d01b58:	4629      	mov	r1, r5
c0d01b5a:	f002 fa3d 	bl	c0d03fd8 <__aeabi_uidiv>
c0d01b5e:	1c64      	adds	r4, r4, #1
c0d01b60:	42bd      	cmp	r5, r7
c0d01b62:	4607      	mov	r7, r0
c0d01b64:	d9ec      	bls.n	c0d01b40 <snprintf+0x224>
c0d01b66:	9b03      	ldr	r3, [sp, #12]
                    }

                    //
                    // Write the string.
                    //
                    ulPos = MIN(ulPos, str_size);
c0d01b68:	429c      	cmp	r4, r3
c0d01b6a:	d300      	bcc.n	c0d01b6e <snprintf+0x252>
c0d01b6c:	461c      	mov	r4, r3
c0d01b6e:	a90c      	add	r1, sp, #48	; 0x30
c0d01b70:	9d02      	ldr	r5, [sp, #8]
                    os_memmove(str, pcBuf, ulPos);
c0d01b72:	4628      	mov	r0, r5
c0d01b74:	4622      	mov	r2, r4
c0d01b76:	461f      	mov	r7, r3
c0d01b78:	e01b      	b.n	c0d01bb2 <snprintf+0x296>
                case 'c':
                {
                    //
                    // Get the value from the varargs.
                    //
                    ulValue = va_arg(vaArgP, unsigned long);
c0d01b7a:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d01b7c:	1d01      	adds	r1, r0, #4
c0d01b7e:	910b      	str	r1, [sp, #44]	; 0x2c
c0d01b80:	6800      	ldr	r0, [r0, #0]
c0d01b82:	9902      	ldr	r1, [sp, #8]
c0d01b84:	7008      	strb	r0, [r1, #0]
c0d01b86:	9803      	ldr	r0, [sp, #12]
c0d01b88:	1e40      	subs	r0, r0, #1
c0d01b8a:	1c49      	adds	r1, r1, #1
c0d01b8c:	e015      	b.n	c0d01bba <snprintf+0x29e>
c0d01b8e:	9c00      	ldr	r4, [sp, #0]
c0d01b90:	9a05      	ldr	r2, [sp, #20]
c0d01b92:	9b03      	ldr	r3, [sp, #12]
c0d01b94:	9d06      	ldr	r5, [sp, #24]
c0d01b96:	e024      	b.n	c0d01be2 <snprintf+0x2c6>
                        break;
                        
                      // printout prepad
                      case 2:
                        // if string is empty, then, ' ' padding
                        if (pcStr[0] == '\0') {
c0d01b98:	7808      	ldrb	r0, [r1, #0]
c0d01b9a:	2800      	cmp	r0, #0
c0d01b9c:	d075      	beq.n	c0d01c8a <snprintf+0x36e>
                default:
                {
                    //
                    // Indicate an error.
                    //
                    ulPos = MIN(strlen("ERROR"), str_size);
c0d01b9e:	2005      	movs	r0, #5
c0d01ba0:	9f03      	ldr	r7, [sp, #12]
c0d01ba2:	2f05      	cmp	r7, #5
c0d01ba4:	463c      	mov	r4, r7
c0d01ba6:	d300      	bcc.n	c0d01baa <snprintf+0x28e>
c0d01ba8:	4604      	mov	r4, r0
c0d01baa:	9d02      	ldr	r5, [sp, #8]
                    os_memmove(str, "ERROR", ulPos);
c0d01bac:	4628      	mov	r0, r5
c0d01bae:	a164      	add	r1, pc, #400	; (adr r1, c0d01d40 <g_pcHex+0x10>)
c0d01bb0:	4622      	mov	r2, r4
c0d01bb2:	f7ff f9de 	bl	c0d00f72 <os_memmove>
c0d01bb6:	1b38      	subs	r0, r7, r4
c0d01bb8:	1929      	adds	r1, r5, r4
c0d01bba:	910a      	str	r1, [sp, #40]	; 0x28
c0d01bbc:	4603      	mov	r3, r0
c0d01bbe:	2800      	cmp	r0, #0
c0d01bc0:	d100      	bne.n	c0d01bc4 <snprintf+0x2a8>
c0d01bc2:	e0a6      	b.n	c0d01d12 <snprintf+0x3f6>
    va_start(vaArgP, format);

    //
    // Loop while there are more characters in the string.
    //
    while(*format)
c0d01bc4:	7830      	ldrb	r0, [r6, #0]
c0d01bc6:	2800      	cmp	r0, #0
c0d01bc8:	9905      	ldr	r1, [sp, #20]
c0d01bca:	461d      	mov	r5, r3
c0d01bcc:	d000      	beq.n	c0d01bd0 <snprintf+0x2b4>
c0d01bce:	e085      	b.n	c0d01cdc <snprintf+0x3c0>
c0d01bd0:	e09f      	b.n	c0d01d12 <snprintf+0x3f6>
c0d01bd2:	9a05      	ldr	r2, [sp, #20]
c0d01bd4:	4614      	mov	r4, r2
c0d01bd6:	9b03      	ldr	r3, [sp, #12]
                    // Determine the length of the string. (if not specified using .*)
                    //
                    switch(cStrlenSet) {
                      // compute length with strlen
                      case 0:
                        for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
c0d01bd8:	1908      	adds	r0, r1, r4
c0d01bda:	7840      	ldrb	r0, [r0, #1]
c0d01bdc:	1c64      	adds	r4, r4, #1
c0d01bde:	2800      	cmp	r0, #0
c0d01be0:	d1fa      	bne.n	c0d01bd8 <snprintf+0x2bc>
                    }

                    //
                    // Write the string.
                    //
                    switch(ulBase) {
c0d01be2:	9801      	ldr	r0, [sp, #4]
c0d01be4:	2810      	cmp	r0, #16
c0d01be6:	9802      	ldr	r0, [sp, #8]
c0d01be8:	d144      	bne.n	c0d01c74 <snprintf+0x358>
                            return 0;
                        }
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0d01bea:	2c00      	cmp	r4, #0
c0d01bec:	d074      	beq.n	c0d01cd8 <snprintf+0x3bc>
c0d01bee:	9108      	str	r1, [sp, #32]
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0d01bf0:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01bf2:	1883      	adds	r3, r0, r2
c0d01bf4:	1b50      	subs	r0, r2, r5
c0d01bf6:	4287      	cmp	r7, r0
c0d01bf8:	4639      	mov	r1, r7
c0d01bfa:	d800      	bhi.n	c0d01bfe <snprintf+0x2e2>
c0d01bfc:	4601      	mov	r1, r0
c0d01bfe:	9103      	str	r1, [sp, #12]
c0d01c00:	434a      	muls	r2, r1
c0d01c02:	9202      	str	r2, [sp, #8]
c0d01c04:	1c50      	adds	r0, r2, #1
c0d01c06:	9001      	str	r0, [sp, #4]
c0d01c08:	2000      	movs	r0, #0
c0d01c0a:	462a      	mov	r2, r5
c0d01c0c:	930a      	str	r3, [sp, #40]	; 0x28
c0d01c0e:	9902      	ldr	r1, [sp, #8]
c0d01c10:	185b      	adds	r3, r3, r1
c0d01c12:	9009      	str	r0, [sp, #36]	; 0x24
c0d01c14:	9908      	ldr	r1, [sp, #32]
c0d01c16:	5c08      	ldrb	r0, [r1, r0]
                          nibble2 = pcStr[ulCount]&0xF;
c0d01c18:	250f      	movs	r5, #15
c0d01c1a:	4005      	ands	r5, r0
                        }
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
                          nibble1 = (pcStr[ulCount]>>4)&0xF;
c0d01c1c:	0900      	lsrs	r0, r0, #4
c0d01c1e:	9903      	ldr	r1, [sp, #12]
c0d01c20:	1889      	adds	r1, r1, r2
c0d01c22:	1c49      	adds	r1, r1, #1
                          nibble2 = pcStr[ulCount]&0xF;
                          if (str_size < 2) {
c0d01c24:	2902      	cmp	r1, #2
c0d01c26:	d374      	bcc.n	c0d01d12 <snprintf+0x3f6>
c0d01c28:	9904      	ldr	r1, [sp, #16]
                              return 0;
                          }
                          switch(ulCap) {
c0d01c2a:	2901      	cmp	r1, #1
c0d01c2c:	d003      	beq.n	c0d01c36 <snprintf+0x31a>
c0d01c2e:	2900      	cmp	r1, #0
c0d01c30:	d108      	bne.n	c0d01c44 <snprintf+0x328>
c0d01c32:	a13f      	add	r1, pc, #252	; (adr r1, c0d01d30 <g_pcHex>)
c0d01c34:	e000      	b.n	c0d01c38 <snprintf+0x31c>
c0d01c36:	a13a      	add	r1, pc, #232	; (adr r1, c0d01d20 <g_pcHex_cap>)
c0d01c38:	b2c0      	uxtb	r0, r0
c0d01c3a:	5c08      	ldrb	r0, [r1, r0]
c0d01c3c:	7018      	strb	r0, [r3, #0]
c0d01c3e:	b2e8      	uxtb	r0, r5
c0d01c40:	5c08      	ldrb	r0, [r1, r0]
c0d01c42:	7058      	strb	r0, [r3, #1]
                                str[1] = g_pcHex_cap[nibble2];
                              break;
                          }
                          str+= 2;
                          str_size -= 2;
                          if (str_size == 0) {
c0d01c44:	9801      	ldr	r0, [sp, #4]
c0d01c46:	4290      	cmp	r0, r2
c0d01c48:	d063      	beq.n	c0d01d12 <snprintf+0x3f6>
                            return 0;
                        }
                        break;
                      case 16: {
                        unsigned char nibble1, nibble2;
                        for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0d01c4a:	1e92      	subs	r2, r2, #2
c0d01c4c:	9b0a      	ldr	r3, [sp, #40]	; 0x28
c0d01c4e:	1c9b      	adds	r3, r3, #2
c0d01c50:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01c52:	1c40      	adds	r0, r0, #1
c0d01c54:	42a0      	cmp	r0, r4
c0d01c56:	d3d9      	bcc.n	c0d01c0c <snprintf+0x2f0>
c0d01c58:	9009      	str	r0, [sp, #36]	; 0x24
c0d01c5a:	9905      	ldr	r1, [sp, #20]
 
#endif // HAVE_PRINTF

#ifdef HAVE_SPRINTF
//unsigned int snprintf(unsigned char * str, unsigned int str_size, const char* format, ...)
int snprintf(char * str, size_t str_size, const char * format, ...)
c0d01c5c:	9806      	ldr	r0, [sp, #24]
c0d01c5e:	1a08      	subs	r0, r1, r0
c0d01c60:	4287      	cmp	r7, r0
c0d01c62:	d800      	bhi.n	c0d01c66 <snprintf+0x34a>
c0d01c64:	4607      	mov	r7, r0
c0d01c66:	4608      	mov	r0, r1
c0d01c68:	4378      	muls	r0, r7
c0d01c6a:	1818      	adds	r0, r3, r0
c0d01c6c:	900a      	str	r0, [sp, #40]	; 0x28
c0d01c6e:	18b8      	adds	r0, r7, r2
c0d01c70:	1c43      	adds	r3, r0, #1
c0d01c72:	e01c      	b.n	c0d01cae <snprintf+0x392>
                    //
                    // Write the string.
                    //
                    switch(ulBase) {
                      default:
                        ulIdx = MIN(ulIdx, str_size);
c0d01c74:	429c      	cmp	r4, r3
c0d01c76:	d300      	bcc.n	c0d01c7a <snprintf+0x35e>
c0d01c78:	461c      	mov	r4, r3
                        os_memmove(str, pcStr, ulIdx);
c0d01c7a:	4622      	mov	r2, r4
c0d01c7c:	4605      	mov	r5, r0
c0d01c7e:	461f      	mov	r7, r3
c0d01c80:	f7ff f977 	bl	c0d00f72 <os_memmove>
                        str+= ulIdx;
                        str_size -= ulIdx;
c0d01c84:	1b38      	subs	r0, r7, r4
                    //
                    switch(ulBase) {
                      default:
                        ulIdx = MIN(ulIdx, str_size);
                        os_memmove(str, pcStr, ulIdx);
                        str+= ulIdx;
c0d01c86:	1929      	adds	r1, r5, r4
c0d01c88:	e00d      	b.n	c0d01ca6 <snprintf+0x38a>
c0d01c8a:	9b03      	ldr	r3, [sp, #12]
c0d01c8c:	9f00      	ldr	r7, [sp, #0]
                      case 2:
                        // if string is empty, then, ' ' padding
                        if (pcStr[0] == '\0') {
                        
                          // padd ulStrlen white space
                          ulStrlen = MIN(ulStrlen, str_size);
c0d01c8e:	429f      	cmp	r7, r3
c0d01c90:	d300      	bcc.n	c0d01c94 <snprintf+0x378>
c0d01c92:	461f      	mov	r7, r3
                          os_memset(str, ' ', ulStrlen);
c0d01c94:	2120      	movs	r1, #32
c0d01c96:	9d02      	ldr	r5, [sp, #8]
c0d01c98:	4628      	mov	r0, r5
c0d01c9a:	463a      	mov	r2, r7
c0d01c9c:	f7ff f960 	bl	c0d00f60 <os_memset>
                          str+= ulStrlen;
                          str_size -= ulStrlen;
c0d01ca0:	9803      	ldr	r0, [sp, #12]
c0d01ca2:	1bc0      	subs	r0, r0, r7
                        if (pcStr[0] == '\0') {
                        
                          // padd ulStrlen white space
                          ulStrlen = MIN(ulStrlen, str_size);
                          os_memset(str, ' ', ulStrlen);
                          str+= ulStrlen;
c0d01ca4:	19e9      	adds	r1, r5, r7
c0d01ca6:	910a      	str	r1, [sp, #40]	; 0x28
c0d01ca8:	4603      	mov	r3, r0
c0d01caa:	2800      	cmp	r0, #0
c0d01cac:	d031      	beq.n	c0d01d12 <snprintf+0x3f6>
c0d01cae:	9809      	ldr	r0, [sp, #36]	; 0x24

s_pad:
                    //
                    // Write any required padding spaces
                    //
                    if(ulCount > ulIdx)
c0d01cb0:	42a0      	cmp	r0, r4
c0d01cb2:	d987      	bls.n	c0d01bc4 <snprintf+0x2a8>
                    {
                        ulCount -= ulIdx;
c0d01cb4:	1b04      	subs	r4, r0, r4
c0d01cb6:	461d      	mov	r5, r3
                        ulCount = MIN(ulCount, str_size);
c0d01cb8:	42ac      	cmp	r4, r5
c0d01cba:	d300      	bcc.n	c0d01cbe <snprintf+0x3a2>
c0d01cbc:	462c      	mov	r4, r5
                        os_memset(str, ' ', ulCount);
c0d01cbe:	2120      	movs	r1, #32
c0d01cc0:	9f0a      	ldr	r7, [sp, #40]	; 0x28
c0d01cc2:	4638      	mov	r0, r7
c0d01cc4:	4622      	mov	r2, r4
c0d01cc6:	f7ff f94b 	bl	c0d00f60 <os_memset>
                        str+= ulCount;
                        str_size -= ulCount;
c0d01cca:	1b2d      	subs	r5, r5, r4
                    if(ulCount > ulIdx)
                    {
                        ulCount -= ulIdx;
                        ulCount = MIN(ulCount, str_size);
                        os_memset(str, ' ', ulCount);
                        str+= ulCount;
c0d01ccc:	193f      	adds	r7, r7, r4
c0d01cce:	970a      	str	r7, [sp, #40]	; 0x28
c0d01cd0:	462b      	mov	r3, r5
                        str_size -= ulCount;
                        if (str_size == 0) {
c0d01cd2:	2d00      	cmp	r5, #0
c0d01cd4:	d01d      	beq.n	c0d01d12 <snprintf+0x3f6>
c0d01cd6:	e775      	b.n	c0d01bc4 <snprintf+0x2a8>
c0d01cd8:	900a      	str	r0, [sp, #40]	; 0x28
c0d01cda:	e773      	b.n	c0d01bc4 <snprintf+0x2a8>
    while(*format)
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0d01cdc:	460f      	mov	r7, r1
c0d01cde:	9c07      	ldr	r4, [sp, #28]
c0d01ce0:	e003      	b.n	c0d01cea <snprintf+0x3ce>
c0d01ce2:	1930      	adds	r0, r6, r4
c0d01ce4:	7840      	ldrb	r0, [r0, #1]
c0d01ce6:	1e7f      	subs	r7, r7, #1
            ulIdx++)
c0d01ce8:	1c64      	adds	r4, r4, #1
c0d01cea:	b2c0      	uxtb	r0, r0
    while(*format)
    {
        //
        // Find the first non-% character, or the end of the string.
        //
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');
c0d01cec:	2800      	cmp	r0, #0
c0d01cee:	d001      	beq.n	c0d01cf4 <snprintf+0x3d8>
c0d01cf0:	2825      	cmp	r0, #37	; 0x25
c0d01cf2:	d1f6      	bne.n	c0d01ce2 <snprintf+0x3c6>
        }

        //
        // Write this portion of the string.
        //
        ulIdx = MIN(ulIdx, str_size);
c0d01cf4:	42ac      	cmp	r4, r5
c0d01cf6:	d300      	bcc.n	c0d01cfa <snprintf+0x3de>
c0d01cf8:	462c      	mov	r4, r5
        os_memmove(str, format, ulIdx);
c0d01cfa:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01cfc:	4631      	mov	r1, r6
c0d01cfe:	4622      	mov	r2, r4
c0d01d00:	f7ff f937 	bl	c0d00f72 <os_memmove>
c0d01d04:	9506      	str	r5, [sp, #24]
        str+= ulIdx;
        str_size -= ulIdx;
c0d01d06:	1b2b      	subs	r3, r5, r4
        //
        // Write this portion of the string.
        //
        ulIdx = MIN(ulIdx, str_size);
        os_memmove(str, format, ulIdx);
        str+= ulIdx;
c0d01d08:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d01d0a:	1902      	adds	r2, r0, r4
        str_size -= ulIdx;
        if (str_size == 0) {
c0d01d0c:	2b00      	cmp	r3, #0
c0d01d0e:	d000      	beq.n	c0d01d12 <snprintf+0x3f6>
c0d01d10:	e626      	b.n	c0d01960 <snprintf+0x44>
    // End the varargs processing.
    //
    va_end(vaArgP);

    return 0;
}
c0d01d12:	2000      	movs	r0, #0
c0d01d14:	b010      	add	sp, #64	; 0x40
c0d01d16:	bcf0      	pop	{r4, r5, r6, r7}
c0d01d18:	bc02      	pop	{r1}
c0d01d1a:	b001      	add	sp, #4
c0d01d1c:	4708      	bx	r1
c0d01d1e:	46c0      	nop			; (mov r8, r8)

c0d01d20 <g_pcHex_cap>:
c0d01d20:	33323130 	.word	0x33323130
c0d01d24:	37363534 	.word	0x37363534
c0d01d28:	42413938 	.word	0x42413938
c0d01d2c:	46454443 	.word	0x46454443

c0d01d30 <g_pcHex>:
c0d01d30:	33323130 	.word	0x33323130
c0d01d34:	37363534 	.word	0x37363534
c0d01d38:	62613938 	.word	0x62613938
c0d01d3c:	66656463 	.word	0x66656463
c0d01d40:	4f525245 	.word	0x4f525245
c0d01d44:	00000052 	.word	0x00000052

c0d01d48 <pic>:

// only apply PIC conversion if link_address is in linked code (over 0xC0D00000 in our example)
// this way, PIC call are armless if the address is not meant to be converted
extern unsigned int _nvram;
extern unsigned int _envram;
unsigned int pic(unsigned int link_address) {
c0d01d48:	b580      	push	{r7, lr}
//  screen_printf(" %08X", link_address);
	if (link_address >= ((unsigned int)&_nvram) && link_address < ((unsigned int)&_envram)) {
c0d01d4a:	4904      	ldr	r1, [pc, #16]	; (c0d01d5c <pic+0x14>)
c0d01d4c:	4288      	cmp	r0, r1
c0d01d4e:	d304      	bcc.n	c0d01d5a <pic+0x12>
c0d01d50:	4903      	ldr	r1, [pc, #12]	; (c0d01d60 <pic+0x18>)
c0d01d52:	4288      	cmp	r0, r1
c0d01d54:	d201      	bcs.n	c0d01d5a <pic+0x12>
		link_address = pic_internal(link_address);
c0d01d56:	f000 f805 	bl	c0d01d64 <pic_internal>
//    screen_printf(" -> %08X\n", link_address);
  }
	return link_address;
c0d01d5a:	bd80      	pop	{r7, pc}
c0d01d5c:	c0d00000 	.word	0xc0d00000
c0d01d60:	c0d05180 	.word	0xc0d05180

c0d01d64 <pic_internal>:

unsigned int pic_internal(unsigned int link_address) __attribute__((naked));
unsigned int pic_internal(unsigned int link_address) 
{
  // compute the delta offset between LinkMemAddr & ExecMemAddr
  __asm volatile ("mov r2, pc\n");          // r2 = 0x109004
c0d01d64:	467a      	mov	r2, pc
  __asm volatile ("ldr r1, =pic_internal\n");        // r1 = 0xC0D00001
c0d01d66:	4902      	ldr	r1, [pc, #8]	; (c0d01d70 <pic_internal+0xc>)
  __asm volatile ("adds r1, r1, #3\n");     // r1 = 0xC0D00004
c0d01d68:	1cc9      	adds	r1, r1, #3
  __asm volatile ("subs r1, r1, r2\n");     // r1 = 0xC0BF7000 (delta between load and exec address)
c0d01d6a:	1a89      	subs	r1, r1, r2

  // adjust value of the given parameter
  __asm volatile ("subs r0, r0, r1\n");     // r0 = 0xC0D0C244 => r0 = 0x115244
c0d01d6c:	1a40      	subs	r0, r0, r1
  __asm volatile ("bx lr\n");
c0d01d6e:	4770      	bx	lr
c0d01d70:	c0d01d65 	.word	0xc0d01d65

c0d01d74 <SVC_Call>:
  // avoid a separate asm file, but avoid any intrusion from the compiler
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) __attribute__ ((naked));
  //                    r0                       r1
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) {
    // delegate svc
    asm volatile("svc #1":::"r0","r1");
c0d01d74:	df01      	svc	1
    // directly return R0 value
    asm volatile("bx  lr");
c0d01d76:	4770      	bx	lr

c0d01d78 <check_api_level>:
  }
  void check_api_level ( unsigned int apiLevel ) 
{
c0d01d78:	b580      	push	{r7, lr}
c0d01d7a:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
c0d01d7c:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
c0d01d7e:	4807      	ldr	r0, [pc, #28]	; (c0d01d9c <check_api_level+0x24>)
c0d01d80:	4669      	mov	r1, sp
c0d01d82:	f7ff fff7 	bl	c0d01d74 <SVC_Call>
c0d01d86:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01d88:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_check_api_level_ID_OUT) {
c0d01d8a:	4905      	ldr	r1, [pc, #20]	; (c0d01da0 <check_api_level+0x28>)
c0d01d8c:	4288      	cmp	r0, r1
c0d01d8e:	d101      	bne.n	c0d01d94 <check_api_level+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d01d90:	b002      	add	sp, #8
c0d01d92:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_check_api_level_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01d94:	2004      	movs	r0, #4
c0d01d96:	f7ff f9a0 	bl	c0d010da <os_longjmp>
c0d01d9a:	46c0      	nop			; (mov r8, r8)
c0d01d9c:	60000137 	.word	0x60000137
c0d01da0:	900001c6 	.word	0x900001c6

c0d01da4 <reset>:
  }
}

void reset ( void ) 
{
c0d01da4:	b580      	push	{r7, lr}
c0d01da6:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
c0d01da8:	4806      	ldr	r0, [pc, #24]	; (c0d01dc4 <reset+0x20>)
c0d01daa:	a901      	add	r1, sp, #4
c0d01dac:	f7ff ffe2 	bl	c0d01d74 <SVC_Call>
c0d01db0:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01db2:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_reset_ID_OUT) {
c0d01db4:	4904      	ldr	r1, [pc, #16]	; (c0d01dc8 <reset+0x24>)
c0d01db6:	4288      	cmp	r0, r1
c0d01db8:	d101      	bne.n	c0d01dbe <reset+0x1a>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d01dba:	b002      	add	sp, #8
c0d01dbc:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_reset_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01dbe:	2004      	movs	r0, #4
c0d01dc0:	f7ff f98b 	bl	c0d010da <os_longjmp>
c0d01dc4:	60000200 	.word	0x60000200
c0d01dc8:	900002f1 	.word	0x900002f1

c0d01dcc <cx_rng>:
  }
  return (unsigned char)ret;
}

unsigned char * cx_rng ( unsigned char * buffer, unsigned int len ) 
{
c0d01dcc:	b580      	push	{r7, lr}
c0d01dce:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d01dd0:	9001      	str	r0, [sp, #4]
  parameters[1] = (unsigned int)len;
c0d01dd2:	9102      	str	r1, [sp, #8]
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
c0d01dd4:	4807      	ldr	r0, [pc, #28]	; (c0d01df4 <cx_rng+0x28>)
c0d01dd6:	a901      	add	r1, sp, #4
c0d01dd8:	f7ff ffcc 	bl	c0d01d74 <SVC_Call>
c0d01ddc:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01dde:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_rng_ID_OUT) {
c0d01de0:	4905      	ldr	r1, [pc, #20]	; (c0d01df8 <cx_rng+0x2c>)
c0d01de2:	4288      	cmp	r0, r1
c0d01de4:	d102      	bne.n	c0d01dec <cx_rng+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned char *)ret;
c0d01de6:	9803      	ldr	r0, [sp, #12]
c0d01de8:	b004      	add	sp, #16
c0d01dea:	bd80      	pop	{r7, pc}
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_rng_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01dec:	2004      	movs	r0, #4
c0d01dee:	f7ff f974 	bl	c0d010da <os_longjmp>
c0d01df2:	46c0      	nop			; (mov r8, r8)
c0d01df4:	6000052c 	.word	0x6000052c
c0d01df8:	90000567 	.word	0x90000567

c0d01dfc <cx_hash>:
  }
  return (int)ret;
}

int cx_hash ( cx_hash_t * hash, int mode, const unsigned char * in, unsigned int len, unsigned char * out, unsigned int out_len ) 
{
c0d01dfc:	b580      	push	{r7, lr}
c0d01dfe:	b088      	sub	sp, #32
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+6];
  parameters[0] = (unsigned int)hash;
c0d01e00:	af01      	add	r7, sp, #4
c0d01e02:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d01e04:	980a      	ldr	r0, [sp, #40]	; 0x28
  parameters[1] = (unsigned int)mode;
  parameters[2] = (unsigned int)in;
  parameters[3] = (unsigned int)len;
  parameters[4] = (unsigned int)out;
c0d01e06:	9005      	str	r0, [sp, #20]
c0d01e08:	980b      	ldr	r0, [sp, #44]	; 0x2c
  parameters[5] = (unsigned int)out_len;
c0d01e0a:	9006      	str	r0, [sp, #24]
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
c0d01e0c:	4807      	ldr	r0, [pc, #28]	; (c0d01e2c <cx_hash+0x30>)
c0d01e0e:	a901      	add	r1, sp, #4
c0d01e10:	f7ff ffb0 	bl	c0d01d74 <SVC_Call>
c0d01e14:	aa07      	add	r2, sp, #28
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01e16:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_hash_ID_OUT) {
c0d01e18:	4905      	ldr	r1, [pc, #20]	; (c0d01e30 <cx_hash+0x34>)
c0d01e1a:	4288      	cmp	r0, r1
c0d01e1c:	d102      	bne.n	c0d01e24 <cx_hash+0x28>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d01e1e:	9807      	ldr	r0, [sp, #28]
c0d01e20:	b008      	add	sp, #32
c0d01e22:	bd80      	pop	{r7, pc}
  parameters[4] = (unsigned int)out;
  parameters[5] = (unsigned int)out_len;
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_hash_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01e24:	2004      	movs	r0, #4
c0d01e26:	f7ff f958 	bl	c0d010da <os_longjmp>
c0d01e2a:	46c0      	nop			; (mov r8, r8)
c0d01e2c:	6000073b 	.word	0x6000073b
c0d01e30:	900007ad 	.word	0x900007ad

c0d01e34 <cx_ripemd160_init>:
  }
  return (int)ret;
}

int cx_ripemd160_init ( cx_ripemd160_t * hash ) 
{
c0d01e34:	b580      	push	{r7, lr}
c0d01e36:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
c0d01e38:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_cx_ripemd160_init_ID_IN, parameters);
c0d01e3a:	4807      	ldr	r0, [pc, #28]	; (c0d01e58 <cx_ripemd160_init+0x24>)
c0d01e3c:	4669      	mov	r1, sp
c0d01e3e:	f7ff ff99 	bl	c0d01d74 <SVC_Call>
c0d01e42:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01e44:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ripemd160_init_ID_OUT) {
c0d01e46:	4905      	ldr	r1, [pc, #20]	; (c0d01e5c <cx_ripemd160_init+0x28>)
c0d01e48:	4288      	cmp	r0, r1
c0d01e4a:	d102      	bne.n	c0d01e52 <cx_ripemd160_init+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d01e4c:	9801      	ldr	r0, [sp, #4]
c0d01e4e:	b002      	add	sp, #8
c0d01e50:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
  retid = SVC_Call(SYSCALL_cx_ripemd160_init_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ripemd160_init_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01e52:	2004      	movs	r0, #4
c0d01e54:	f7ff f941 	bl	c0d010da <os_longjmp>
c0d01e58:	6000087f 	.word	0x6000087f
c0d01e5c:	900008f8 	.word	0x900008f8

c0d01e60 <cx_sha256_init>:
  }
  return (int)ret;
}

int cx_sha256_init ( cx_sha256_t * hash ) 
{
c0d01e60:	b580      	push	{r7, lr}
c0d01e62:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
c0d01e64:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_cx_sha256_init_ID_IN, parameters);
c0d01e66:	4807      	ldr	r0, [pc, #28]	; (c0d01e84 <cx_sha256_init+0x24>)
c0d01e68:	4669      	mov	r1, sp
c0d01e6a:	f7ff ff83 	bl	c0d01d74 <SVC_Call>
c0d01e6e:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01e70:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_sha256_init_ID_OUT) {
c0d01e72:	4905      	ldr	r1, [pc, #20]	; (c0d01e88 <cx_sha256_init+0x28>)
c0d01e74:	4288      	cmp	r0, r1
c0d01e76:	d102      	bne.n	c0d01e7e <cx_sha256_init+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d01e78:	9801      	ldr	r0, [sp, #4]
c0d01e7a:	b002      	add	sp, #8
c0d01e7c:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
  retid = SVC_Call(SYSCALL_cx_sha256_init_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_sha256_init_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01e7e:	2004      	movs	r0, #4
c0d01e80:	f7ff f92b 	bl	c0d010da <os_longjmp>
c0d01e84:	60000adb 	.word	0x60000adb
c0d01e88:	90000a64 	.word	0x90000a64

c0d01e8c <cx_ecfp_init_public_key>:
  }
  return (int)ret;
}

int cx_ecfp_init_public_key ( cx_curve_t curve, const unsigned char * rawkey, unsigned int key_len, cx_ecfp_public_key_t * key ) 
{
c0d01e8c:	b580      	push	{r7, lr}
c0d01e8e:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d01e90:	af01      	add	r7, sp, #4
c0d01e92:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)rawkey;
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_public_key_ID_IN, parameters);
c0d01e94:	4807      	ldr	r0, [pc, #28]	; (c0d01eb4 <cx_ecfp_init_public_key+0x28>)
c0d01e96:	a901      	add	r1, sp, #4
c0d01e98:	f7ff ff6c 	bl	c0d01d74 <SVC_Call>
c0d01e9c:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01e9e:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_init_public_key_ID_OUT) {
c0d01ea0:	4905      	ldr	r1, [pc, #20]	; (c0d01eb8 <cx_ecfp_init_public_key+0x2c>)
c0d01ea2:	4288      	cmp	r0, r1
c0d01ea4:	d102      	bne.n	c0d01eac <cx_ecfp_init_public_key+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d01ea6:	9805      	ldr	r0, [sp, #20]
c0d01ea8:	b006      	add	sp, #24
c0d01eaa:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_public_key_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_init_public_key_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01eac:	2004      	movs	r0, #4
c0d01eae:	f7ff f914 	bl	c0d010da <os_longjmp>
c0d01eb2:	46c0      	nop			; (mov r8, r8)
c0d01eb4:	60002aed 	.word	0x60002aed
c0d01eb8:	90002a49 	.word	0x90002a49

c0d01ebc <cx_ecfp_init_private_key>:
  }
  return (int)ret;
}

int cx_ecfp_init_private_key ( cx_curve_t curve, const unsigned char * rawkey, unsigned int key_len, cx_ecfp_private_key_t * pvkey ) 
{
c0d01ebc:	b580      	push	{r7, lr}
c0d01ebe:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d01ec0:	af01      	add	r7, sp, #4
c0d01ec2:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)rawkey;
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)pvkey;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_private_key_ID_IN, parameters);
c0d01ec4:	4807      	ldr	r0, [pc, #28]	; (c0d01ee4 <cx_ecfp_init_private_key+0x28>)
c0d01ec6:	a901      	add	r1, sp, #4
c0d01ec8:	f7ff ff54 	bl	c0d01d74 <SVC_Call>
c0d01ecc:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01ece:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_init_private_key_ID_OUT) {
c0d01ed0:	4905      	ldr	r1, [pc, #20]	; (c0d01ee8 <cx_ecfp_init_private_key+0x2c>)
c0d01ed2:	4288      	cmp	r0, r1
c0d01ed4:	d102      	bne.n	c0d01edc <cx_ecfp_init_private_key+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d01ed6:	9805      	ldr	r0, [sp, #20]
c0d01ed8:	b006      	add	sp, #24
c0d01eda:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)pvkey;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_private_key_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_init_private_key_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01edc:	2004      	movs	r0, #4
c0d01ede:	f7ff f8fc 	bl	c0d010da <os_longjmp>
c0d01ee2:	46c0      	nop			; (mov r8, r8)
c0d01ee4:	60002bea 	.word	0x60002bea
c0d01ee8:	90002b63 	.word	0x90002b63

c0d01eec <cx_ecfp_generate_pair>:
  }
  return (int)ret;
}

int cx_ecfp_generate_pair ( cx_curve_t curve, cx_ecfp_public_key_t * pubkey, cx_ecfp_private_key_t * privkey, int keepprivate ) 
{
c0d01eec:	b580      	push	{r7, lr}
c0d01eee:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d01ef0:	af01      	add	r7, sp, #4
c0d01ef2:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)pubkey;
  parameters[2] = (unsigned int)privkey;
  parameters[3] = (unsigned int)keepprivate;
  retid = SVC_Call(SYSCALL_cx_ecfp_generate_pair_ID_IN, parameters);
c0d01ef4:	4807      	ldr	r0, [pc, #28]	; (c0d01f14 <cx_ecfp_generate_pair+0x28>)
c0d01ef6:	a901      	add	r1, sp, #4
c0d01ef8:	f7ff ff3c 	bl	c0d01d74 <SVC_Call>
c0d01efc:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01efe:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_generate_pair_ID_OUT) {
c0d01f00:	4905      	ldr	r1, [pc, #20]	; (c0d01f18 <cx_ecfp_generate_pair+0x2c>)
c0d01f02:	4288      	cmp	r0, r1
c0d01f04:	d102      	bne.n	c0d01f0c <cx_ecfp_generate_pair+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d01f06:	9805      	ldr	r0, [sp, #20]
c0d01f08:	b006      	add	sp, #24
c0d01f0a:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)privkey;
  parameters[3] = (unsigned int)keepprivate;
  retid = SVC_Call(SYSCALL_cx_ecfp_generate_pair_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_generate_pair_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01f0c:	2004      	movs	r0, #4
c0d01f0e:	f7ff f8e4 	bl	c0d010da <os_longjmp>
c0d01f12:	46c0      	nop			; (mov r8, r8)
c0d01f14:	60002c2e 	.word	0x60002c2e
c0d01f18:	90002c74 	.word	0x90002c74

c0d01f1c <cx_ecdsa_sign>:
  }
  return (int)ret;
}

int cx_ecdsa_sign ( const cx_ecfp_private_key_t * pvkey, int mode, cx_md_t hashID, const unsigned char * hash, unsigned int hash_len, unsigned char * sig, unsigned int sig_len, unsigned int * info ) 
{
c0d01f1c:	b580      	push	{r7, lr}
c0d01f1e:	b08a      	sub	sp, #40	; 0x28
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+8];
  parameters[0] = (unsigned int)pvkey;
c0d01f20:	af01      	add	r7, sp, #4
c0d01f22:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d01f24:	980c      	ldr	r0, [sp, #48]	; 0x30
  parameters[1] = (unsigned int)mode;
  parameters[2] = (unsigned int)hashID;
  parameters[3] = (unsigned int)hash;
  parameters[4] = (unsigned int)hash_len;
c0d01f26:	9005      	str	r0, [sp, #20]
c0d01f28:	980d      	ldr	r0, [sp, #52]	; 0x34
  parameters[5] = (unsigned int)sig;
c0d01f2a:	9006      	str	r0, [sp, #24]
c0d01f2c:	980e      	ldr	r0, [sp, #56]	; 0x38
  parameters[6] = (unsigned int)sig_len;
c0d01f2e:	9007      	str	r0, [sp, #28]
c0d01f30:	980f      	ldr	r0, [sp, #60]	; 0x3c
  parameters[7] = (unsigned int)info;
c0d01f32:	9008      	str	r0, [sp, #32]
  retid = SVC_Call(SYSCALL_cx_ecdsa_sign_ID_IN, parameters);
c0d01f34:	4807      	ldr	r0, [pc, #28]	; (c0d01f54 <cx_ecdsa_sign+0x38>)
c0d01f36:	a901      	add	r1, sp, #4
c0d01f38:	f7ff ff1c 	bl	c0d01d74 <SVC_Call>
c0d01f3c:	aa09      	add	r2, sp, #36	; 0x24
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01f3e:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecdsa_sign_ID_OUT) {
c0d01f40:	4905      	ldr	r1, [pc, #20]	; (c0d01f58 <cx_ecdsa_sign+0x3c>)
c0d01f42:	4288      	cmp	r0, r1
c0d01f44:	d102      	bne.n	c0d01f4c <cx_ecdsa_sign+0x30>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d01f46:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d01f48:	b00a      	add	sp, #40	; 0x28
c0d01f4a:	bd80      	pop	{r7, pc}
  parameters[6] = (unsigned int)sig_len;
  parameters[7] = (unsigned int)info;
  retid = SVC_Call(SYSCALL_cx_ecdsa_sign_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecdsa_sign_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01f4c:	2004      	movs	r0, #4
c0d01f4e:	f7ff f8c4 	bl	c0d010da <os_longjmp>
c0d01f52:	46c0      	nop			; (mov r8, r8)
c0d01f54:	600035f3 	.word	0x600035f3
c0d01f58:	90003576 	.word	0x90003576

c0d01f5c <os_perso_derive_node_bip32>:
  }
  return (unsigned int)ret;
}

void os_perso_derive_node_bip32 ( cx_curve_t curve, const unsigned int * path, unsigned int pathLength, unsigned char * privateKey, unsigned char * chain ) 
{
c0d01f5c:	b580      	push	{r7, lr}
c0d01f5e:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)curve;
c0d01f60:	af00      	add	r7, sp, #0
c0d01f62:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d01f64:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)path;
  parameters[2] = (unsigned int)pathLength;
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
c0d01f66:	9004      	str	r0, [sp, #16]
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
c0d01f68:	4806      	ldr	r0, [pc, #24]	; (c0d01f84 <os_perso_derive_node_bip32+0x28>)
c0d01f6a:	4669      	mov	r1, sp
c0d01f6c:	f7ff ff02 	bl	c0d01d74 <SVC_Call>
c0d01f70:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01f72:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
c0d01f74:	4904      	ldr	r1, [pc, #16]	; (c0d01f88 <os_perso_derive_node_bip32+0x2c>)
c0d01f76:	4288      	cmp	r0, r1
c0d01f78:	d101      	bne.n	c0d01f7e <os_perso_derive_node_bip32+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d01f7a:	b006      	add	sp, #24
c0d01f7c:	bd80      	pop	{r7, pc}
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01f7e:	2004      	movs	r0, #4
c0d01f80:	f7ff f8ab 	bl	c0d010da <os_longjmp>
c0d01f84:	600050ba 	.word	0x600050ba
c0d01f88:	9000501e 	.word	0x9000501e

c0d01f8c <os_sched_exit>:
  }
  return (unsigned int)ret;
}

void os_sched_exit ( unsigned int exit_code ) 
{
c0d01f8c:	b580      	push	{r7, lr}
c0d01f8e:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
c0d01f90:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
c0d01f92:	4807      	ldr	r0, [pc, #28]	; (c0d01fb0 <os_sched_exit+0x24>)
c0d01f94:	4669      	mov	r1, sp
c0d01f96:	f7ff feed 	bl	c0d01d74 <SVC_Call>
c0d01f9a:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01f9c:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
c0d01f9e:	4905      	ldr	r1, [pc, #20]	; (c0d01fb4 <os_sched_exit+0x28>)
c0d01fa0:	4288      	cmp	r0, r1
c0d01fa2:	d101      	bne.n	c0d01fa8 <os_sched_exit+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d01fa4:	b002      	add	sp, #8
c0d01fa6:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01fa8:	2004      	movs	r0, #4
c0d01faa:	f7ff f896 	bl	c0d010da <os_longjmp>
c0d01fae:	46c0      	nop			; (mov r8, r8)
c0d01fb0:	60005fe1 	.word	0x60005fe1
c0d01fb4:	90005f6f 	.word	0x90005f6f

c0d01fb8 <os_ux>:
    THROW(EXCEPTION_SECURITY);
  }
}

unsigned int os_ux ( bolos_ux_params_t * params ) 
{
c0d01fb8:	b580      	push	{r7, lr}
c0d01fba:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
c0d01fbc:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
c0d01fbe:	4807      	ldr	r0, [pc, #28]	; (c0d01fdc <os_ux+0x24>)
c0d01fc0:	4669      	mov	r1, sp
c0d01fc2:	f7ff fed7 	bl	c0d01d74 <SVC_Call>
c0d01fc6:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01fc8:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_ux_ID_OUT) {
c0d01fca:	4905      	ldr	r1, [pc, #20]	; (c0d01fe0 <os_ux+0x28>)
c0d01fcc:	4288      	cmp	r0, r1
c0d01fce:	d102      	bne.n	c0d01fd6 <os_ux+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d01fd0:	9801      	ldr	r0, [sp, #4]
c0d01fd2:	b002      	add	sp, #8
c0d01fd4:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_ux_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d01fd6:	2004      	movs	r0, #4
c0d01fd8:	f7ff f87f 	bl	c0d010da <os_longjmp>
c0d01fdc:	60006158 	.word	0x60006158
c0d01fe0:	9000611f 	.word	0x9000611f

c0d01fe4 <os_seph_features>:
  }
  return (unsigned int)ret;
}

unsigned int os_seph_features ( void ) 
{
c0d01fe4:	b580      	push	{r7, lr}
c0d01fe6:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_seph_features_ID_IN, parameters);
c0d01fe8:	4807      	ldr	r0, [pc, #28]	; (c0d02008 <os_seph_features+0x24>)
c0d01fea:	a901      	add	r1, sp, #4
c0d01fec:	f7ff fec2 	bl	c0d01d74 <SVC_Call>
c0d01ff0:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d01ff2:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_seph_features_ID_OUT) {
c0d01ff4:	4905      	ldr	r1, [pc, #20]	; (c0d0200c <os_seph_features+0x28>)
c0d01ff6:	4288      	cmp	r0, r1
c0d01ff8:	d102      	bne.n	c0d02000 <os_seph_features+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d01ffa:	9800      	ldr	r0, [sp, #0]
c0d01ffc:	b002      	add	sp, #8
c0d01ffe:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_seph_features_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_seph_features_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02000:	2004      	movs	r0, #4
c0d02002:	f7ff f86a 	bl	c0d010da <os_longjmp>
c0d02006:	46c0      	nop			; (mov r8, r8)
c0d02008:	600067d6 	.word	0x600067d6
c0d0200c:	90006744 	.word	0x90006744

c0d02010 <io_seproxyhal_spi_send>:
  }
  return (unsigned int)ret;
}

void io_seproxyhal_spi_send ( const unsigned char * buffer, unsigned short length ) 
{
c0d02010:	b580      	push	{r7, lr}
c0d02012:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d02014:	9001      	str	r0, [sp, #4]
  parameters[1] = (unsigned int)length;
c0d02016:	9102      	str	r1, [sp, #8]
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
c0d02018:	4806      	ldr	r0, [pc, #24]	; (c0d02034 <io_seproxyhal_spi_send+0x24>)
c0d0201a:	a901      	add	r1, sp, #4
c0d0201c:	f7ff feaa 	bl	c0d01d74 <SVC_Call>
c0d02020:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02022:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
c0d02024:	4904      	ldr	r1, [pc, #16]	; (c0d02038 <io_seproxyhal_spi_send+0x28>)
c0d02026:	4288      	cmp	r0, r1
c0d02028:	d101      	bne.n	c0d0202e <io_seproxyhal_spi_send+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d0202a:	b004      	add	sp, #16
c0d0202c:	bd80      	pop	{r7, pc}
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0202e:	2004      	movs	r0, #4
c0d02030:	f7ff f853 	bl	c0d010da <os_longjmp>
c0d02034:	60006e1c 	.word	0x60006e1c
c0d02038:	90006ef3 	.word	0x90006ef3

c0d0203c <io_seproxyhal_spi_is_status_sent>:
  }
}

unsigned int io_seproxyhal_spi_is_status_sent ( void ) 
{
c0d0203c:	b580      	push	{r7, lr}
c0d0203e:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
c0d02040:	4807      	ldr	r0, [pc, #28]	; (c0d02060 <io_seproxyhal_spi_is_status_sent+0x24>)
c0d02042:	a901      	add	r1, sp, #4
c0d02044:	f7ff fe96 	bl	c0d01d74 <SVC_Call>
c0d02048:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0204a:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
c0d0204c:	4905      	ldr	r1, [pc, #20]	; (c0d02064 <io_seproxyhal_spi_is_status_sent+0x28>)
c0d0204e:	4288      	cmp	r0, r1
c0d02050:	d102      	bne.n	c0d02058 <io_seproxyhal_spi_is_status_sent+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d02052:	9800      	ldr	r0, [sp, #0]
c0d02054:	b002      	add	sp, #8
c0d02056:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02058:	2004      	movs	r0, #4
c0d0205a:	f7ff f83e 	bl	c0d010da <os_longjmp>
c0d0205e:	46c0      	nop			; (mov r8, r8)
c0d02060:	60006fcf 	.word	0x60006fcf
c0d02064:	90006f7f 	.word	0x90006f7f

c0d02068 <io_seproxyhal_spi_recv>:
  }
  return (unsigned int)ret;
}

unsigned short io_seproxyhal_spi_recv ( unsigned char * buffer, unsigned short maxlength, unsigned int flags ) 
{
c0d02068:	b580      	push	{r7, lr}
c0d0206a:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)buffer;
c0d0206c:	ab00      	add	r3, sp, #0
c0d0206e:	c307      	stmia	r3!, {r0, r1, r2}
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
c0d02070:	4807      	ldr	r0, [pc, #28]	; (c0d02090 <io_seproxyhal_spi_recv+0x28>)
c0d02072:	4669      	mov	r1, sp
c0d02074:	f7ff fe7e 	bl	c0d01d74 <SVC_Call>
c0d02078:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0207a:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
c0d0207c:	4905      	ldr	r1, [pc, #20]	; (c0d02094 <io_seproxyhal_spi_recv+0x2c>)
c0d0207e:	4288      	cmp	r0, r1
c0d02080:	d103      	bne.n	c0d0208a <io_seproxyhal_spi_recv+0x22>
c0d02082:	a803      	add	r0, sp, #12
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned short)ret;
c0d02084:	8800      	ldrh	r0, [r0, #0]
c0d02086:	b004      	add	sp, #16
c0d02088:	bd80      	pop	{r7, pc}
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0208a:	2004      	movs	r0, #4
c0d0208c:	f7ff f825 	bl	c0d010da <os_longjmp>
c0d02090:	600070d1 	.word	0x600070d1
c0d02094:	9000702b 	.word	0x9000702b

c0d02098 <u2f_apdu_sign>:

    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)SW_INTERNAL, sizeof(SW_INTERNAL));
}

void u2f_apdu_sign(u2f_service_t *service, uint8_t p1, uint8_t p2,
                     uint8_t *buffer, uint16_t length) {
c0d02098:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0209a:	b085      	sub	sp, #20
    UNUSED(p2);
    uint8_t keyHandleLength;
    uint8_t i;

    // can't process the apdu if another one is already scheduled in
    if (G_io_apdu_state != APDU_IDLE) {
c0d0209c:	4921      	ldr	r1, [pc, #132]	; (c0d02124 <u2f_apdu_sign+0x8c>)
c0d0209e:	780a      	ldrb	r2, [r1, #0]
    for (i = 0; i < keyHandleLength; i++) {
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
        u2f_message_reply(service, U2F_CMD_MSG,
c0d020a0:	2183      	movs	r1, #131	; 0x83
    UNUSED(p2);
    uint8_t keyHandleLength;
    uint8_t i;

    // can't process the apdu if another one is already scheduled in
    if (G_io_apdu_state != APDU_IDLE) {
c0d020a2:	2a00      	cmp	r2, #0
c0d020a4:	d002      	beq.n	c0d020ac <u2f_apdu_sign+0x14>
        u2f_message_reply(service, U2F_CMD_MSG,
c0d020a6:	4a24      	ldr	r2, [pc, #144]	; (c0d02138 <u2f_apdu_sign+0xa0>)
c0d020a8:	447a      	add	r2, pc
c0d020aa:	e004      	b.n	c0d020b6 <u2f_apdu_sign+0x1e>
c0d020ac:	9a0a      	ldr	r2, [sp, #40]	; 0x28
                  (uint8_t *)SW_BUSY,
                  sizeof(SW_BUSY));
        return;        
    }

    if (length < U2F_HANDLE_SIGN_HEADER_SIZE + 5 /*at least an apdu header*/) {
c0d020ae:	2a45      	cmp	r2, #69	; 0x45
c0d020b0:	d806      	bhi.n	c0d020c0 <u2f_apdu_sign+0x28>
        u2f_message_reply(service, U2F_CMD_MSG,
c0d020b2:	4a22      	ldr	r2, [pc, #136]	; (c0d0213c <u2f_apdu_sign+0xa4>)
c0d020b4:	447a      	add	r2, pc
c0d020b6:	2302      	movs	r3, #2
c0d020b8:	f000 fb36 	bl	c0d02728 <u2f_message_reply>
    app_dispatch();
    if ((btchip_context_D.io_flags & IO_ASYNCH_REPLY) == 0) {
        u2f_proxy_response(service, btchip_context_D.outLength);
    }
    */
}
c0d020bc:	b005      	add	sp, #20
c0d020be:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d020c0:	ac01      	add	r4, sp, #4
c0d020c2:	c407      	stmia	r4!, {r0, r1, r2}
                  sizeof(SW_WRONG_LENGTH));
        return;
    }

    // Unwrap magic
    keyHandleLength = buffer[U2F_HANDLE_SIGN_HEADER_SIZE-1];
c0d020c4:	2040      	movs	r0, #64	; 0x40
c0d020c6:	9304      	str	r3, [sp, #16]
c0d020c8:	5c1f      	ldrb	r7, [r3, r0]
    for (i = 0; i < keyHandleLength; i++) {
c0d020ca:	2f00      	cmp	r7, #0
c0d020cc:	d00e      	beq.n	c0d020ec <u2f_apdu_sign+0x54>
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
c0d020ce:	9e04      	ldr	r6, [sp, #16]
c0d020d0:	3641      	adds	r6, #65	; 0x41
c0d020d2:	2400      	movs	r4, #0
c0d020d4:	a514      	add	r5, pc, #80	; (adr r5, c0d02128 <u2f_apdu_sign+0x90>)
c0d020d6:	b2e0      	uxtb	r0, r4
c0d020d8:	2103      	movs	r1, #3
c0d020da:	f002 f803 	bl	c0d040e4 <__aeabi_uidivmod>
c0d020de:	5d30      	ldrb	r0, [r6, r4]
c0d020e0:	5c69      	ldrb	r1, [r5, r1]
c0d020e2:	4041      	eors	r1, r0
c0d020e4:	5531      	strb	r1, [r6, r4]
        return;
    }

    // Unwrap magic
    keyHandleLength = buffer[U2F_HANDLE_SIGN_HEADER_SIZE-1];
    for (i = 0; i < keyHandleLength; i++) {
c0d020e6:	1c64      	adds	r4, r4, #1
c0d020e8:	42a7      	cmp	r7, r4
c0d020ea:	d1f4      	bne.n	c0d020d6 <u2f_apdu_sign+0x3e>
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
c0d020ec:	2045      	movs	r0, #69	; 0x45
c0d020ee:	9904      	ldr	r1, [sp, #16]
c0d020f0:	5c08      	ldrb	r0, [r1, r0]
c0d020f2:	3046      	adds	r0, #70	; 0x46
c0d020f4:	9a03      	ldr	r2, [sp, #12]
c0d020f6:	4282      	cmp	r2, r0
c0d020f8:	d10d      	bne.n	c0d02116 <u2f_apdu_sign+0x7e>
                  sizeof(SW_BAD_KEY_HANDLE));
        return;
    }

    // make the apdu available to higher layers
    os_memmove(G_io_apdu_buffer, buffer + U2F_HANDLE_SIGN_HEADER_SIZE, keyHandleLength);
c0d020fa:	3141      	adds	r1, #65	; 0x41
c0d020fc:	480b      	ldr	r0, [pc, #44]	; (c0d0212c <u2f_apdu_sign+0x94>)
c0d020fe:	463a      	mov	r2, r7
c0d02100:	f7fe ff37 	bl	c0d00f72 <os_memmove>
    G_io_apdu_length = keyHandleLength;
c0d02104:	480a      	ldr	r0, [pc, #40]	; (c0d02130 <u2f_apdu_sign+0x98>)
c0d02106:	8007      	strh	r7, [r0, #0]
    G_io_apdu_media = IO_APDU_MEDIA_U2F; // the effective transport is managed by the U2F layer
c0d02108:	480a      	ldr	r0, [pc, #40]	; (c0d02134 <u2f_apdu_sign+0x9c>)
c0d0210a:	2106      	movs	r1, #6
c0d0210c:	7001      	strb	r1, [r0, #0]
    G_io_apdu_state = APDU_U2F;
c0d0210e:	2009      	movs	r0, #9
c0d02110:	4904      	ldr	r1, [pc, #16]	; (c0d02124 <u2f_apdu_sign+0x8c>)
c0d02112:	7008      	strb	r0, [r1, #0]
c0d02114:	e7d2      	b.n	c0d020bc <u2f_apdu_sign+0x24>
    for (i = 0; i < keyHandleLength; i++) {
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02116:	4a0a      	ldr	r2, [pc, #40]	; (c0d02140 <u2f_apdu_sign+0xa8>)
c0d02118:	447a      	add	r2, pc
c0d0211a:	2302      	movs	r3, #2
c0d0211c:	9801      	ldr	r0, [sp, #4]
c0d0211e:	9902      	ldr	r1, [sp, #8]
c0d02120:	e7ca      	b.n	c0d020b8 <u2f_apdu_sign+0x20>
c0d02122:	46c0      	nop			; (mov r8, r8)
c0d02124:	20001a64 	.word	0x20001a64
c0d02128:	004f454e 	.word	0x004f454e
c0d0212c:	200018f8 	.word	0x200018f8
c0d02130:	20001a66 	.word	0x20001a66
c0d02134:	20001a5c 	.word	0x20001a5c
c0d02138:	0000225a 	.word	0x0000225a
c0d0213c:	00002250 	.word	0x00002250
c0d02140:	000021ee 	.word	0x000021ee

c0d02144 <u2f_handle_cmd_init>:
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)INFO, sizeof(INFO));
}

void u2f_handle_cmd_init(u2f_service_t *service, uint8_t *buffer,
                         uint16_t length, uint8_t *channelInit) {
c0d02144:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02146:	b081      	sub	sp, #4
c0d02148:	461d      	mov	r5, r3
c0d0214a:	460e      	mov	r6, r1
c0d0214c:	4604      	mov	r4, r0
    // screen_printf("U2F init\n");
    uint8_t channel[4];
    (void)length;
    if (u2f_is_channel_broadcast(channelInit)) {
c0d0214e:	4628      	mov	r0, r5
c0d02150:	f000 fada 	bl	c0d02708 <u2f_is_channel_broadcast>
c0d02154:	2801      	cmp	r0, #1
c0d02156:	d104      	bne.n	c0d02162 <u2f_handle_cmd_init+0x1e>
c0d02158:	4668      	mov	r0, sp
        cx_rng(channel, 4);
c0d0215a:	2104      	movs	r1, #4
c0d0215c:	f7ff fe36 	bl	c0d01dcc <cx_rng>
c0d02160:	e004      	b.n	c0d0216c <u2f_handle_cmd_init+0x28>
c0d02162:	4668      	mov	r0, sp
    } else {
        os_memmove(channel, channelInit, 4);
c0d02164:	2204      	movs	r2, #4
c0d02166:	4629      	mov	r1, r5
c0d02168:	f7fe ff03 	bl	c0d00f72 <os_memmove>
    }
    os_memmove(G_io_apdu_buffer, buffer, 8);
c0d0216c:	4f17      	ldr	r7, [pc, #92]	; (c0d021cc <u2f_handle_cmd_init+0x88>)
c0d0216e:	2208      	movs	r2, #8
c0d02170:	4638      	mov	r0, r7
c0d02172:	4631      	mov	r1, r6
c0d02174:	f7fe fefd 	bl	c0d00f72 <os_memmove>
    os_memmove(G_io_apdu_buffer + 8, channel, 4);
c0d02178:	4638      	mov	r0, r7
c0d0217a:	3008      	adds	r0, #8
c0d0217c:	4669      	mov	r1, sp
c0d0217e:	2204      	movs	r2, #4
c0d02180:	f7fe fef7 	bl	c0d00f72 <os_memmove>
    G_io_apdu_buffer[12] = INIT_U2F_VERSION;
c0d02184:	2002      	movs	r0, #2
c0d02186:	7338      	strb	r0, [r7, #12]
    G_io_apdu_buffer[13] = INIT_DEVICE_VERSION_MAJOR;
c0d02188:	2000      	movs	r0, #0
c0d0218a:	7378      	strb	r0, [r7, #13]
c0d0218c:	2101      	movs	r1, #1
    G_io_apdu_buffer[14] = INIT_DEVICE_VERSION_MINOR;
c0d0218e:	73b9      	strb	r1, [r7, #14]
    G_io_apdu_buffer[15] = INIT_BUILD_VERSION;
c0d02190:	73f8      	strb	r0, [r7, #15]
    G_io_apdu_buffer[16] = INIT_CAPABILITIES;
c0d02192:	7438      	strb	r0, [r7, #16]

    if (u2f_is_channel_broadcast(channelInit)) {
c0d02194:	4628      	mov	r0, r5
c0d02196:	f000 fab7 	bl	c0d02708 <u2f_is_channel_broadcast>
        os_memset(service->channel, 0xff, 4);
c0d0219a:	2586      	movs	r5, #134	; 0x86
    G_io_apdu_buffer[13] = INIT_DEVICE_VERSION_MAJOR;
    G_io_apdu_buffer[14] = INIT_DEVICE_VERSION_MINOR;
    G_io_apdu_buffer[15] = INIT_BUILD_VERSION;
    G_io_apdu_buffer[16] = INIT_CAPABILITIES;

    if (u2f_is_channel_broadcast(channelInit)) {
c0d0219c:	2801      	cmp	r0, #1
c0d0219e:	d107      	bne.n	c0d021b0 <u2f_handle_cmd_init+0x6c>
        os_memset(service->channel, 0xff, 4);
c0d021a0:	4628      	mov	r0, r5
c0d021a2:	3079      	adds	r0, #121	; 0x79
c0d021a4:	b2c1      	uxtb	r1, r0
c0d021a6:	2204      	movs	r2, #4
c0d021a8:	4620      	mov	r0, r4
c0d021aa:	f7fe fed9 	bl	c0d00f60 <os_memset>
c0d021ae:	e004      	b.n	c0d021ba <u2f_handle_cmd_init+0x76>
c0d021b0:	4669      	mov	r1, sp
    } else {
        os_memmove(service->channel, channel, 4);
c0d021b2:	2204      	movs	r2, #4
c0d021b4:	4620      	mov	r0, r4
c0d021b6:	f7fe fedc 	bl	c0d00f72 <os_memmove>
    }
    u2f_message_reply(service, U2F_CMD_INIT, G_io_apdu_buffer, 17);
c0d021ba:	4a04      	ldr	r2, [pc, #16]	; (c0d021cc <u2f_handle_cmd_init+0x88>)
c0d021bc:	2311      	movs	r3, #17
c0d021be:	4620      	mov	r0, r4
c0d021c0:	4629      	mov	r1, r5
c0d021c2:	f000 fab1 	bl	c0d02728 <u2f_message_reply>
}
c0d021c6:	b001      	add	sp, #4
c0d021c8:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d021ca:	46c0      	nop			; (mov r8, r8)
c0d021cc:	200018f8 	.word	0x200018f8

c0d021d0 <u2f_handle_cmd_msg>:
    // screen_printf("U2F ping\n");
    u2f_message_reply(service, U2F_CMD_PING, buffer, length);
}

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
c0d021d0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d021d2:	b083      	sub	sp, #12
c0d021d4:	460b      	mov	r3, r1
c0d021d6:	9002      	str	r0, [sp, #8]
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
c0d021d8:	7998      	ldrb	r0, [r3, #6]
c0d021da:	7959      	ldrb	r1, [r3, #5]
c0d021dc:	020f      	lsls	r7, r1, #8
c0d021de:	4307      	orrs	r7, r0

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
c0d021e0:	7859      	ldrb	r1, [r3, #1]
}

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
c0d021e2:	781e      	ldrb	r6, [r3, #0]
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
c0d021e4:	4615      	mov	r5, r2
c0d021e6:	3d09      	subs	r5, #9
c0d021e8:	b2a8      	uxth	r0, r5
        u2f_apdu_get_info(service, p1, p2, buffer + 7, dataLength);
        break;

    default:
        // screen_printf("unsupported\n");
        u2f_message_reply(service, U2F_CMD_MSG,
c0d021ea:	2483      	movs	r4, #131	; 0x83
c0d021ec:	9401      	str	r4, [sp, #4]
c0d021ee:	4c1f      	ldr	r4, [pc, #124]	; (c0d0226c <u2f_handle_cmd_msg+0x9c>)
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
c0d021f0:	4287      	cmp	r7, r0
c0d021f2:	d003      	beq.n	c0d021fc <u2f_handle_cmd_msg+0x2c>
c0d021f4:	1fd2      	subs	r2, r2, #7
c0d021f6:	4014      	ands	r4, r2
c0d021f8:	42a7      	cmp	r7, r4
c0d021fa:	d11b      	bne.n	c0d02234 <u2f_handle_cmd_msg+0x64>
c0d021fc:	463d      	mov	r5, r7
                  (uint8_t *)SW_WRONG_LENGTH,
                  sizeof(SW_WRONG_LENGTH));
        return;
    }

    if (cla != FIDO_CLA) {
c0d021fe:	2e00      	cmp	r6, #0
c0d02200:	d008      	beq.n	c0d02214 <u2f_handle_cmd_msg+0x44>
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02202:	4a1b      	ldr	r2, [pc, #108]	; (c0d02270 <u2f_handle_cmd_msg+0xa0>)
c0d02204:	447a      	add	r2, pc
c0d02206:	2302      	movs	r3, #2
c0d02208:	9802      	ldr	r0, [sp, #8]
c0d0220a:	9901      	ldr	r1, [sp, #4]
c0d0220c:	f000 fa8c 	bl	c0d02728 <u2f_message_reply>
        u2f_message_reply(service, U2F_CMD_MSG,
                 (uint8_t *)SW_UNKNOWN_INSTRUCTION,
                 sizeof(SW_UNKNOWN_INSTRUCTION));
        return;
    }
}
c0d02210:	b003      	add	sp, #12
c0d02212:	bdf0      	pop	{r4, r5, r6, r7, pc}
        u2f_message_reply(service, U2F_CMD_MSG,
                  (uint8_t *)SW_UNKNOWN_CLASS,
                  sizeof(SW_UNKNOWN_CLASS));
        return;
    }
    switch (ins) {
c0d02214:	2902      	cmp	r1, #2
c0d02216:	dc17      	bgt.n	c0d02248 <u2f_handle_cmd_msg+0x78>
c0d02218:	2901      	cmp	r1, #1
c0d0221a:	d020      	beq.n	c0d0225e <u2f_handle_cmd_msg+0x8e>
c0d0221c:	2902      	cmp	r1, #2
c0d0221e:	d11b      	bne.n	c0d02258 <u2f_handle_cmd_msg+0x88>
        // screen_printf("enroll\n");
        u2f_apdu_enroll(service, p1, p2, buffer + 7, dataLength);
        break;
    case FIDO_INS_SIGN:
        // screen_printf("sign\n");
        u2f_apdu_sign(service, p1, p2, buffer + 7, dataLength);
c0d02220:	b2a8      	uxth	r0, r5
c0d02222:	4669      	mov	r1, sp
c0d02224:	6008      	str	r0, [r1, #0]
c0d02226:	1ddb      	adds	r3, r3, #7
c0d02228:	2100      	movs	r1, #0
c0d0222a:	9802      	ldr	r0, [sp, #8]
c0d0222c:	460a      	mov	r2, r1
c0d0222e:	f7ff ff33 	bl	c0d02098 <u2f_apdu_sign>
c0d02232:	e7ed      	b.n	c0d02210 <u2f_handle_cmd_msg+0x40>
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
        // Le is optional
        // nominal case from the specification
    }
    // circumvent google chrome extended length encoding done on the last byte only (module 256) but all data being transferred
    else if (dataLength == (uint16_t)(length - 9)%256) {
c0d02234:	b2e8      	uxtb	r0, r5
c0d02236:	4287      	cmp	r7, r0
c0d02238:	d0e1      	beq.n	c0d021fe <u2f_handle_cmd_msg+0x2e>
        dataLength = length - 9;
    }
    else if (dataLength == (uint16_t)(length - 7)%256) {
c0d0223a:	b2d0      	uxtb	r0, r2
c0d0223c:	4287      	cmp	r7, r0
c0d0223e:	4615      	mov	r5, r2
c0d02240:	d0dd      	beq.n	c0d021fe <u2f_handle_cmd_msg+0x2e>
        dataLength = length - 7;
    }    
    else { 
        // invalid size
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02242:	4a0c      	ldr	r2, [pc, #48]	; (c0d02274 <u2f_handle_cmd_msg+0xa4>)
c0d02244:	447a      	add	r2, pc
c0d02246:	e7de      	b.n	c0d02206 <u2f_handle_cmd_msg+0x36>
c0d02248:	2903      	cmp	r1, #3
c0d0224a:	d00b      	beq.n	c0d02264 <u2f_handle_cmd_msg+0x94>
c0d0224c:	29c1      	cmp	r1, #193	; 0xc1
c0d0224e:	d103      	bne.n	c0d02258 <u2f_handle_cmd_msg+0x88>
                            uint8_t *buffer, uint16_t length) {
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)INFO, sizeof(INFO));
c0d02250:	4a09      	ldr	r2, [pc, #36]	; (c0d02278 <u2f_handle_cmd_msg+0xa8>)
c0d02252:	447a      	add	r2, pc
c0d02254:	2304      	movs	r3, #4
c0d02256:	e7d7      	b.n	c0d02208 <u2f_handle_cmd_msg+0x38>
        u2f_apdu_get_info(service, p1, p2, buffer + 7, dataLength);
        break;

    default:
        // screen_printf("unsupported\n");
        u2f_message_reply(service, U2F_CMD_MSG,
c0d02258:	4a0a      	ldr	r2, [pc, #40]	; (c0d02284 <u2f_handle_cmd_msg+0xb4>)
c0d0225a:	447a      	add	r2, pc
c0d0225c:	e7d3      	b.n	c0d02206 <u2f_handle_cmd_msg+0x36>
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);

    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)SW_INTERNAL, sizeof(SW_INTERNAL));
c0d0225e:	4a07      	ldr	r2, [pc, #28]	; (c0d0227c <u2f_handle_cmd_msg+0xac>)
c0d02260:	447a      	add	r2, pc
c0d02262:	e7d0      	b.n	c0d02206 <u2f_handle_cmd_msg+0x36>
    // screen_printf("U2F version\n");
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)U2F_VERSION, sizeof(U2F_VERSION));
c0d02264:	4a06      	ldr	r2, [pc, #24]	; (c0d02280 <u2f_handle_cmd_msg+0xb0>)
c0d02266:	447a      	add	r2, pc
c0d02268:	2308      	movs	r3, #8
c0d0226a:	e7cd      	b.n	c0d02208 <u2f_handle_cmd_msg+0x38>
c0d0226c:	0000ffff 	.word	0x0000ffff
c0d02270:	00002110 	.word	0x00002110
c0d02274:	000020c0 	.word	0x000020c0
c0d02278:	000020be 	.word	0x000020be
c0d0227c:	000020a0 	.word	0x000020a0
c0d02280:	000020a2 	.word	0x000020a2
c0d02284:	000020bc 	.word	0x000020bc

c0d02288 <u2f_message_complete>:
                 sizeof(SW_UNKNOWN_INSTRUCTION));
        return;
    }
}

void u2f_message_complete(u2f_service_t *service) {
c0d02288:	b580      	push	{r7, lr}
    uint8_t cmd = service->transportBuffer[0];
c0d0228a:	6981      	ldr	r1, [r0, #24]
    uint16_t length = (service->transportBuffer[1] << 8) | (service->transportBuffer[2]);
c0d0228c:	788a      	ldrb	r2, [r1, #2]
c0d0228e:	784b      	ldrb	r3, [r1, #1]
c0d02290:	021b      	lsls	r3, r3, #8
c0d02292:	4313      	orrs	r3, r2
        return;
    }
}

void u2f_message_complete(u2f_service_t *service) {
    uint8_t cmd = service->transportBuffer[0];
c0d02294:	780a      	ldrb	r2, [r1, #0]
    uint16_t length = (service->transportBuffer[1] << 8) | (service->transportBuffer[2]);
    switch (cmd) {
c0d02296:	2a81      	cmp	r2, #129	; 0x81
c0d02298:	d009      	beq.n	c0d022ae <u2f_message_complete+0x26>
c0d0229a:	2a83      	cmp	r2, #131	; 0x83
c0d0229c:	d00c      	beq.n	c0d022b8 <u2f_message_complete+0x30>
c0d0229e:	2a86      	cmp	r2, #134	; 0x86
c0d022a0:	d10e      	bne.n	c0d022c0 <u2f_message_complete+0x38>
    case U2F_CMD_INIT:
        u2f_handle_cmd_init(service, service->transportBuffer + 3, length, service->channel);
c0d022a2:	1cc9      	adds	r1, r1, #3
c0d022a4:	2200      	movs	r2, #0
c0d022a6:	4603      	mov	r3, r0
c0d022a8:	f7ff ff4c 	bl	c0d02144 <u2f_handle_cmd_init>
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
        break;
    }
}
c0d022ac:	bd80      	pop	{r7, pc}
    switch (cmd) {
    case U2F_CMD_INIT:
        u2f_handle_cmd_init(service, service->transportBuffer + 3, length, service->channel);
        break;
    case U2F_CMD_PING:
        u2f_handle_cmd_ping(service, service->transportBuffer + 3, length);
c0d022ae:	1cca      	adds	r2, r1, #3
}

void u2f_handle_cmd_ping(u2f_service_t *service, uint8_t *buffer,
                         uint16_t length) {
    // screen_printf("U2F ping\n");
    u2f_message_reply(service, U2F_CMD_PING, buffer, length);
c0d022b0:	2181      	movs	r1, #129	; 0x81
c0d022b2:	f000 fa39 	bl	c0d02728 <u2f_message_reply>
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
        break;
    }
}
c0d022b6:	bd80      	pop	{r7, pc}
        break;
    case U2F_CMD_PING:
        u2f_handle_cmd_ping(service, service->transportBuffer + 3, length);
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
c0d022b8:	1cc9      	adds	r1, r1, #3
c0d022ba:	461a      	mov	r2, r3
c0d022bc:	f7ff ff88 	bl	c0d021d0 <u2f_handle_cmd_msg>
        break;
    }
}
c0d022c0:	bd80      	pop	{r7, pc}
	...

c0d022c4 <u2f_io_send>:
#include "u2f_processing.h"
#include "u2f_impl.h"

#include "os_io_seproxyhal.h"

void u2f_io_send(uint8_t *buffer, uint16_t length, u2f_transport_media_t media) {
c0d022c4:	b570      	push	{r4, r5, r6, lr}
c0d022c6:	460d      	mov	r5, r1
c0d022c8:	4601      	mov	r1, r0
    if (media == U2F_MEDIA_USB) {
c0d022ca:	2a01      	cmp	r2, #1
c0d022cc:	d111      	bne.n	c0d022f2 <u2f_io_send+0x2e>
        os_memmove(G_io_usb_ep_buffer, buffer, length);
c0d022ce:	4c09      	ldr	r4, [pc, #36]	; (c0d022f4 <u2f_io_send+0x30>)
c0d022d0:	4620      	mov	r0, r4
c0d022d2:	462a      	mov	r2, r5
c0d022d4:	f7fe fe4d 	bl	c0d00f72 <os_memmove>
        // wipe the remaining to avoid :
        // 1/ data leaks
        // 2/ invalid junk
        os_memset(G_io_usb_ep_buffer+length, 0, sizeof(G_io_usb_ep_buffer)-length);
c0d022d8:	1960      	adds	r0, r4, r5
c0d022da:	2640      	movs	r6, #64	; 0x40
c0d022dc:	1b72      	subs	r2, r6, r5
c0d022de:	2500      	movs	r5, #0
c0d022e0:	4629      	mov	r1, r5
c0d022e2:	f7fe fe3d 	bl	c0d00f60 <os_memset>
    }
    switch (media) {
    case U2F_MEDIA_USB:
        io_usb_send_ep(U2F_EPIN_ADDR, G_io_usb_ep_buffer, USB_SEGMENT_SIZE, 0);
c0d022e6:	2081      	movs	r0, #129	; 0x81
c0d022e8:	4621      	mov	r1, r4
c0d022ea:	4632      	mov	r2, r6
c0d022ec:	462b      	mov	r3, r5
c0d022ee:	f7fe ff73 	bl	c0d011d8 <io_usb_send_ep>
#endif
    default:
        PRINTF("Request to send on unsupported media %d\n", media);
        break;
    }
}
c0d022f2:	bd70      	pop	{r4, r5, r6, pc}
c0d022f4:	20001ab0 	.word	0x20001ab0

c0d022f8 <u2f_transport_init>:

/**
 * Initialize the u2f transport and provide the buffer into which to store incoming message
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
c0d022f8:	6081      	str	r1, [r0, #8]
    service->transportReceiveBufferLength = message_buffer_length;
c0d022fa:	8182      	strh	r2, [r0, #12]
c0d022fc:	2200      	movs	r2, #0

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d022fe:	7702      	strb	r2, [r0, #28]
    service->transportOffset = 0;
c0d02300:	8242      	strh	r2, [r0, #18]
    service->transportMedia = 0;
c0d02302:	7742      	strb	r2, [r0, #29]
    service->transportPacketIndex = 0;
c0d02304:	7582      	strb	r2, [r0, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d02306:	6181      	str	r1, [r0, #24]
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
    service->transportReceiveBufferLength = message_buffer_length;
    u2f_transport_reset(service);
}
c0d02308:	4770      	bx	lr
	...

c0d0230c <u2f_transport_sent>:

/**
 * Function called when the previously scheduled message to be sent on the media is effectively sent.
 * And a new message can be scheduled.
 */
void u2f_transport_sent(u2f_service_t* service, u2f_transport_media_t media) {
c0d0230c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0230e:	b083      	sub	sp, #12
c0d02310:	4604      	mov	r4, r0
    // if idle (possibly after an error), then only await for a transmission 
    if (service->transportState != U2F_SENDING_RESPONSE 
c0d02312:	7f20      	ldrb	r0, [r4, #28]
        && service->transportState != U2F_SENDING_ERROR) {
c0d02314:	1ec0      	subs	r0, r0, #3
c0d02316:	b2c0      	uxtb	r0, r0
c0d02318:	2801      	cmp	r0, #1
c0d0231a:	d854      	bhi.n	c0d023c6 <u2f_transport_sent+0xba>
        // absorb the error, transport is erroneous but that won't hurt in the end.
        //THROW(INVALID_STATE);
        return;
    }
    if (service->transportOffset < service->transportLength) {
c0d0231c:	8aa6      	ldrh	r6, [r4, #20]
c0d0231e:	8a62      	ldrh	r2, [r4, #18]
c0d02320:	4296      	cmp	r6, r2
c0d02322:	d923      	bls.n	c0d0236c <u2f_transport_sent+0x60>
        uint16_t mtu = (media == U2F_MEDIA_USB) ? USB_SEGMENT_SIZE : BLE_SEGMENT_SIZE;
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
c0d02324:	2304      	movs	r3, #4
c0d02326:	2000      	movs	r0, #0
c0d02328:	9102      	str	r1, [sp, #8]
c0d0232a:	2901      	cmp	r1, #1
c0d0232c:	d000      	beq.n	c0d02330 <u2f_transport_sent+0x24>
c0d0232e:	4603      	mov	r3, r0
c0d02330:	9001      	str	r0, [sp, #4]
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
c0d02332:	7da0      	ldrb	r0, [r4, #22]
c0d02334:	2703      	movs	r7, #3
c0d02336:	2501      	movs	r5, #1
c0d02338:	2800      	cmp	r0, #0
c0d0233a:	d000      	beq.n	c0d0233e <u2f_transport_sent+0x32>
c0d0233c:	462f      	mov	r7, r5
c0d0233e:	431f      	orrs	r7, r3
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
                                      (mtu - headerSize)
c0d02340:	2340      	movs	r3, #64	; 0x40
c0d02342:	1bdd      	subs	r5, r3, r7
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
c0d02344:	1ab1      	subs	r1, r6, r2
c0d02346:	42a9      	cmp	r1, r5
c0d02348:	dc00      	bgt.n	c0d0234c <u2f_transport_sent+0x40>
c0d0234a:	460d      	mov	r5, r1
                                      (mtu - headerSize)
                                  ? (mtu - headerSize)
                                  : service->transportLength - service->transportOffset);
        uint16_t dataSize = blockSize + headerSize;
c0d0234c:	19ee      	adds	r6, r5, r7
        uint16_t offset = 0;
        // Fragment
        if (media == U2F_MEDIA_USB) {
c0d0234e:	9902      	ldr	r1, [sp, #8]
c0d02350:	2901      	cmp	r1, #1
c0d02352:	d106      	bne.n	c0d02362 <u2f_transport_sent+0x56>
            os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d02354:	481d      	ldr	r0, [pc, #116]	; (c0d023cc <u2f_transport_sent+0xc0>)
c0d02356:	2204      	movs	r2, #4
c0d02358:	4621      	mov	r1, r4
c0d0235a:	9201      	str	r2, [sp, #4]
c0d0235c:	f7fe fe09 	bl	c0d00f72 <os_memmove>
c0d02360:	7da0      	ldrb	r0, [r4, #22]
            offset += 4;
        }
        if (service->transportPacketIndex == 0) {
c0d02362:	2800      	cmp	r0, #0
c0d02364:	d00b      	beq.n	c0d0237e <u2f_transport_sent+0x72>
            G_io_usb_ep_buffer[offset++] = service->sendCmd;
            G_io_usb_ep_buffer[offset++] = (service->transportLength >> 8);
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
c0d02366:	30ff      	adds	r0, #255	; 0xff
c0d02368:	9901      	ldr	r1, [sp, #4]
c0d0236a:	e015      	b.n	c0d02398 <u2f_transport_sent+0x8c>
c0d0236c:	d12b      	bne.n	c0d023c6 <u2f_transport_sent+0xba>
c0d0236e:	2000      	movs	r0, #0

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d02370:	7720      	strb	r0, [r4, #28]
    service->transportOffset = 0;
c0d02372:	8260      	strh	r0, [r4, #18]
    service->transportMedia = 0;
c0d02374:	7760      	strb	r0, [r4, #29]
    service->transportPacketIndex = 0;
c0d02376:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d02378:	68a0      	ldr	r0, [r4, #8]
c0d0237a:	61a0      	str	r0, [r4, #24]
c0d0237c:	e023      	b.n	c0d023c6 <u2f_transport_sent+0xba>
        if (media == U2F_MEDIA_USB) {
            os_memmove(G_io_usb_ep_buffer, service->channel, 4);
            offset += 4;
        }
        if (service->transportPacketIndex == 0) {
            G_io_usb_ep_buffer[offset++] = service->sendCmd;
c0d0237e:	2034      	movs	r0, #52	; 0x34
c0d02380:	5c20      	ldrb	r0, [r4, r0]
c0d02382:	9b01      	ldr	r3, [sp, #4]
c0d02384:	b299      	uxth	r1, r3
c0d02386:	4a11      	ldr	r2, [pc, #68]	; (c0d023cc <u2f_transport_sent+0xc0>)
c0d02388:	5450      	strb	r0, [r2, r1]
c0d0238a:	2001      	movs	r0, #1
c0d0238c:	4318      	orrs	r0, r3
            G_io_usb_ep_buffer[offset++] = (service->transportLength >> 8);
c0d0238e:	b281      	uxth	r1, r0
c0d02390:	7d63      	ldrb	r3, [r4, #21]
c0d02392:	5453      	strb	r3, [r2, r1]
c0d02394:	1c41      	adds	r1, r0, #1
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
c0d02396:	7d20      	ldrb	r0, [r4, #20]
c0d02398:	b289      	uxth	r1, r1
c0d0239a:	4b0c      	ldr	r3, [pc, #48]	; (c0d023cc <u2f_transport_sent+0xc0>)
c0d0239c:	5458      	strb	r0, [r3, r1]
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
c0d0239e:	69a1      	ldr	r1, [r4, #24]
c0d023a0:	2900      	cmp	r1, #0
c0d023a2:	d005      	beq.n	c0d023b0 <u2f_transport_sent+0xa4>
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
                                      (mtu - headerSize)
                                  ? (mtu - headerSize)
                                  : service->transportLength - service->transportOffset);
        uint16_t dataSize = blockSize + headerSize;
c0d023a4:	b2aa      	uxth	r2, r5
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
            os_memmove(G_io_usb_ep_buffer + headerSize,
c0d023a6:	19d8      	adds	r0, r3, r7
                       service->transportBuffer + service->transportOffset, blockSize);
c0d023a8:	8a63      	ldrh	r3, [r4, #18]
c0d023aa:	18c9      	adds	r1, r1, r3
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
            os_memmove(G_io_usb_ep_buffer + headerSize,
c0d023ac:	f7fe fde1 	bl	c0d00f72 <os_memmove>
                       service->transportBuffer + service->transportOffset, blockSize);
        }
        service->transportOffset += blockSize;
c0d023b0:	8a60      	ldrh	r0, [r4, #18]
c0d023b2:	1940      	adds	r0, r0, r5
c0d023b4:	8260      	strh	r0, [r4, #18]
        service->transportPacketIndex++;
c0d023b6:	7da0      	ldrb	r0, [r4, #22]
c0d023b8:	1c40      	adds	r0, r0, #1
c0d023ba:	75a0      	strb	r0, [r4, #22]
        u2f_io_send(G_io_usb_ep_buffer, dataSize, media);
c0d023bc:	b2b1      	uxth	r1, r6
c0d023be:	4803      	ldr	r0, [pc, #12]	; (c0d023cc <u2f_transport_sent+0xc0>)
c0d023c0:	9a02      	ldr	r2, [sp, #8]
c0d023c2:	f7ff ff7f 	bl	c0d022c4 <u2f_io_send>
    // the first call is meant to setup the first part for sending.
    // cannot be considered as the msg sent event.
    else if (service->transportOffset == service->transportLength) {
        u2f_transport_reset(service);
    }
}
c0d023c6:	b003      	add	sp, #12
c0d023c8:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d023ca:	46c0      	nop			; (mov r8, r8)
c0d023cc:	20001ab0 	.word	0x20001ab0

c0d023d0 <u2f_transport_received>:
/** 
 * Function that process every message received on a media.
 * Performs message concatenation when message is splitted.
 */
void u2f_transport_received(u2f_service_t *service, uint8_t *buffer,
                          uint16_t size, u2f_transport_media_t media) {
c0d023d0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d023d2:	b089      	sub	sp, #36	; 0x24
c0d023d4:	461e      	mov	r6, r3
c0d023d6:	4604      	mov	r4, r0
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
    uint16_t xfer_len;
    service->media = media;
c0d023d8:	7126      	strb	r6, [r4, #4]
c0d023da:	7f20      	ldrb	r0, [r4, #28]
    // If busy, answer immediately, avoid reentry
    if ((service->transportState == U2F_PROCESSING_COMMAND) ||
c0d023dc:	1e83      	subs	r3, r0, #2
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        // check this is a command, cannot accept continuation without previous command
        if ((buffer[channelHeader+0]&U2F_MASK_COMMAND) == 0) {
c0d023de:	2585      	movs	r5, #133	; 0x85
                          uint16_t size, u2f_transport_media_t media) {
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
    uint16_t xfer_len;
    service->media = media;
    // If busy, answer immediately, avoid reentry
    if ((service->transportState == U2F_PROCESSING_COMMAND) ||
c0d023e0:	9508      	str	r5, [sp, #32]
c0d023e2:	2b02      	cmp	r3, #2
c0d023e4:	d210      	bcs.n	c0d02408 <u2f_transport_received+0x38>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d023e6:	48c3      	ldr	r0, [pc, #780]	; (c0d026f4 <u2f_transport_received+0x324>)
c0d023e8:	2106      	movs	r1, #6
c0d023ea:	7201      	strb	r1, [r0, #8]
c0d023ec:	2104      	movs	r1, #4

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d023ee:	7721      	strb	r1, [r4, #28]
c0d023f0:	2100      	movs	r1, #0
    service->transportPacketIndex = 0;
c0d023f2:	75a1      	strb	r1, [r4, #22]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d023f4:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d023f6:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d023f8:	8261      	strh	r1, [r4, #18]
    service->transportLength = 1;
c0d023fa:	2001      	movs	r0, #1
c0d023fc:	82a0      	strh	r0, [r4, #20]
c0d023fe:	9908      	ldr	r1, [sp, #32]
c0d02400:	313a      	adds	r1, #58	; 0x3a
c0d02402:	2034      	movs	r0, #52	; 0x34
c0d02404:	5421      	strb	r1, [r4, r0]
c0d02406:	e063      	b.n	c0d024d0 <u2f_transport_received+0x100>
c0d02408:	2804      	cmp	r0, #4
c0d0240a:	d106      	bne.n	c0d0241a <u2f_transport_received+0x4a>
c0d0240c:	2000      	movs	r0, #0

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d0240e:	7720      	strb	r0, [r4, #28]
    service->transportOffset = 0;
c0d02410:	8260      	strh	r0, [r4, #18]
    service->transportMedia = 0;
c0d02412:	7760      	strb	r0, [r4, #29]
    service->transportPacketIndex = 0;
c0d02414:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d02416:	68a0      	ldr	r0, [r4, #8]
c0d02418:	61a0      	str	r0, [r4, #24]
c0d0241a:	9107      	str	r1, [sp, #28]
    // SENDING_ERROR is accepted, and triggers a reset => means the host hasn't consumed the error.
    if (service->transportState == U2F_SENDING_ERROR) {
        u2f_transport_reset(service);
    }

    if (size < (1 + channelHeader)) {
c0d0241c:	2104      	movs	r1, #4
c0d0241e:	2000      	movs	r0, #0
c0d02420:	2e01      	cmp	r6, #1
c0d02422:	d000      	beq.n	c0d02426 <u2f_transport_received+0x56>
c0d02424:	4601      	mov	r1, r0
c0d02426:	2301      	movs	r3, #1
c0d02428:	460d      	mov	r5, r1
c0d0242a:	431d      	orrs	r5, r3
c0d0242c:	42aa      	cmp	r2, r5
c0d0242e:	d341      	bcc.n	c0d024b4 <u2f_transport_received+0xe4>
c0d02430:	9106      	str	r1, [sp, #24]
        // Message to short, abort
        u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
        goto error;
    }
    if (media == U2F_MEDIA_USB) {
c0d02432:	2e01      	cmp	r6, #1
c0d02434:	9205      	str	r2, [sp, #20]
c0d02436:	d109      	bne.n	c0d0244c <u2f_transport_received+0x7c>
        // hold the current channel value to reply to, for example, INIT commands within flow of segments.
        os_memmove(service->channel, buffer, 4);
c0d02438:	2204      	movs	r2, #4
c0d0243a:	4620      	mov	r0, r4
c0d0243c:	9907      	ldr	r1, [sp, #28]
c0d0243e:	9604      	str	r6, [sp, #16]
c0d02440:	461f      	mov	r7, r3
c0d02442:	f7fe fd96 	bl	c0d00f72 <os_memmove>
c0d02446:	9a05      	ldr	r2, [sp, #20]
c0d02448:	463b      	mov	r3, r7
c0d0244a:	9e04      	ldr	r6, [sp, #16]
    }

    // no previous chunk processed for the current message
    if (service->transportOffset == 0
c0d0244c:	8a60      	ldrh	r0, [r4, #18]
c0d0244e:	49aa      	ldr	r1, [pc, #680]	; (c0d026f8 <u2f_transport_received+0x328>)
        // on USB we could get an INIT within a flow of segments.
        || (media == U2F_MEDIA_USB && os_memcmp(service->transportChannel, service->channel, 4) != 0) ) {
c0d02450:	2800      	cmp	r0, #0
c0d02452:	9103      	str	r1, [sp, #12]
c0d02454:	d00e      	beq.n	c0d02474 <u2f_transport_received+0xa4>
c0d02456:	2e01      	cmp	r6, #1
c0d02458:	d127      	bne.n	c0d024aa <u2f_transport_received+0xda>
c0d0245a:	4620      	mov	r0, r4
c0d0245c:	300e      	adds	r0, #14
c0d0245e:	2204      	movs	r2, #4
c0d02460:	4621      	mov	r1, r4
c0d02462:	9604      	str	r6, [sp, #16]
c0d02464:	461f      	mov	r7, r3
c0d02466:	f7fe fe21 	bl	c0d010ac <os_memcmp>
c0d0246a:	9a05      	ldr	r2, [sp, #20]
c0d0246c:	463b      	mov	r3, r7
c0d0246e:	9e04      	ldr	r6, [sp, #16]
        // hold the current channel value to reply to, for example, INIT commands within flow of segments.
        os_memmove(service->channel, buffer, 4);
    }

    // no previous chunk processed for the current message
    if (service->transportOffset == 0
c0d02470:	2800      	cmp	r0, #0
c0d02472:	d01a      	beq.n	c0d024aa <u2f_transport_received+0xda>
        // on USB we could get an INIT within a flow of segments.
        || (media == U2F_MEDIA_USB && os_memcmp(service->transportChannel, service->channel, 4) != 0) ) {
        if (size < (channelHeader + 3)) {
c0d02474:	2703      	movs	r7, #3
c0d02476:	9906      	ldr	r1, [sp, #24]
c0d02478:	4608      	mov	r0, r1
c0d0247a:	4338      	orrs	r0, r7
c0d0247c:	4282      	cmp	r2, r0
c0d0247e:	d319      	bcc.n	c0d024b4 <u2f_transport_received+0xe4>
c0d02480:	9704      	str	r7, [sp, #16]
c0d02482:	9807      	ldr	r0, [sp, #28]
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        // check this is a command, cannot accept continuation without previous command
        if ((buffer[channelHeader+0]&U2F_MASK_COMMAND) == 0) {
c0d02484:	1847      	adds	r7, r0, r1
c0d02486:	9702      	str	r7, [sp, #8]
c0d02488:	5640      	ldrsb	r0, [r0, r1]
c0d0248a:	9908      	ldr	r1, [sp, #32]
c0d0248c:	317a      	adds	r1, #122	; 0x7a
c0d0248e:	b249      	sxtb	r1, r1
c0d02490:	4288      	cmp	r0, r1
c0d02492:	dd3c      	ble.n	c0d0250e <u2f_transport_received+0x13e>
c0d02494:	4897      	ldr	r0, [pc, #604]	; (c0d026f4 <u2f_transport_received+0x324>)
c0d02496:	2104      	movs	r1, #4
c0d02498:	7201      	strb	r1, [r0, #8]
c0d0249a:	7721      	strb	r1, [r4, #28]
c0d0249c:	2100      	movs	r1, #0
c0d0249e:	75a1      	strb	r1, [r4, #22]
c0d024a0:	3008      	adds	r0, #8
c0d024a2:	61a0      	str	r0, [r4, #24]
c0d024a4:	8261      	strh	r1, [r4, #18]
c0d024a6:	82a3      	strh	r3, [r4, #20]
c0d024a8:	e7a9      	b.n	c0d023fe <u2f_transport_received+0x2e>
c0d024aa:	2002      	movs	r0, #2
        }
    } else {


        // Continuation
        if (size < (channelHeader + 2)) {
c0d024ac:	9906      	ldr	r1, [sp, #24]
c0d024ae:	4308      	orrs	r0, r1
c0d024b0:	4282      	cmp	r2, r0
c0d024b2:	d213      	bcs.n	c0d024dc <u2f_transport_received+0x10c>
c0d024b4:	488f      	ldr	r0, [pc, #572]	; (c0d026f4 <u2f_transport_received+0x324>)
c0d024b6:	9a08      	ldr	r2, [sp, #32]
c0d024b8:	7202      	strb	r2, [r0, #8]
c0d024ba:	2104      	movs	r1, #4
c0d024bc:	7721      	strb	r1, [r4, #28]
c0d024be:	2100      	movs	r1, #0
c0d024c0:	75a1      	strb	r1, [r4, #22]
c0d024c2:	3008      	adds	r0, #8
c0d024c4:	61a0      	str	r0, [r4, #24]
c0d024c6:	8261      	strh	r1, [r4, #18]
c0d024c8:	82a3      	strh	r3, [r4, #20]
c0d024ca:	323a      	adds	r2, #58	; 0x3a
c0d024cc:	2034      	movs	r0, #52	; 0x34
c0d024ce:	5422      	strb	r2, [r4, r0]
c0d024d0:	7921      	ldrb	r1, [r4, #4]
c0d024d2:	4620      	mov	r0, r4
c0d024d4:	f7ff ff1a 	bl	c0d0230c <u2f_transport_sent>
        service->seqTimeout = 0;
        service->transportState = U2F_HANDLE_SEGMENTED;
    }
error:
    return;
}
c0d024d8:	b009      	add	sp, #36	; 0x24
c0d024da:	bdf0      	pop	{r4, r5, r6, r7, pc}
        if (size < (channelHeader + 2)) {
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        if (media != service->transportMedia) {
c0d024dc:	7f60      	ldrb	r0, [r4, #29]
c0d024de:	42b0      	cmp	r0, r6
c0d024e0:	d148      	bne.n	c0d02574 <u2f_transport_received+0x1a4>
            // Mixed medias
            u2f_transport_error(service, ERROR_PROP_MEDIA_MIXED);
            goto error;
        }
        if (service->transportState != U2F_HANDLE_SEGMENTED) {
c0d024e2:	7f20      	ldrb	r0, [r4, #28]
c0d024e4:	2801      	cmp	r0, #1
c0d024e6:	d152      	bne.n	c0d0258e <u2f_transport_received+0x1be>
            } else {
                u2f_transport_error(service, ERROR_INVALID_SEQ);
                goto error;
            }
        }
        if (media == U2F_MEDIA_USB) {
c0d024e8:	2e01      	cmp	r6, #1
c0d024ea:	d175      	bne.n	c0d025d8 <u2f_transport_received+0x208>
            // Check the channel
            if (os_memcmp(buffer, service->channel, 4) != 0) {
c0d024ec:	2204      	movs	r2, #4
c0d024ee:	9807      	ldr	r0, [sp, #28]
c0d024f0:	4621      	mov	r1, r4
c0d024f2:	9202      	str	r2, [sp, #8]
c0d024f4:	9604      	str	r6, [sp, #16]
c0d024f6:	461f      	mov	r7, r3
c0d024f8:	f7fe fdd8 	bl	c0d010ac <os_memcmp>
c0d024fc:	463b      	mov	r3, r7
c0d024fe:	9e04      	ldr	r6, [sp, #16]
c0d02500:	2800      	cmp	r0, #0
c0d02502:	d069      	beq.n	c0d025d8 <u2f_transport_received+0x208>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d02504:	487b      	ldr	r0, [pc, #492]	; (c0d026f4 <u2f_transport_received+0x324>)
c0d02506:	2106      	movs	r1, #6
c0d02508:	7201      	strb	r1, [r0, #8]

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d0250a:	9902      	ldr	r1, [sp, #8]
c0d0250c:	e7c5      	b.n	c0d0249a <u2f_transport_received+0xca>
c0d0250e:	9301      	str	r3, [sp, #4]
            goto error;
        }

        // If waiting for a continuation on a different channel, reply BUSY
        // immediately
        if (media == U2F_MEDIA_USB) {
c0d02510:	2e01      	cmp	r6, #1
c0d02512:	9f04      	ldr	r7, [sp, #16]
c0d02514:	d112      	bne.n	c0d0253c <u2f_transport_received+0x16c>
            if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d02516:	7f20      	ldrb	r0, [r4, #28]
c0d02518:	2801      	cmp	r0, #1
c0d0251a:	d11b      	bne.n	c0d02554 <u2f_transport_received+0x184>
                (os_memcmp(service->channel, service->transportChannel, 4) !=
c0d0251c:	4621      	mov	r1, r4
c0d0251e:	310e      	adds	r1, #14
c0d02520:	2204      	movs	r2, #4
c0d02522:	4620      	mov	r0, r4
c0d02524:	f7fe fdc2 	bl	c0d010ac <os_memcmp>
                 0) &&
c0d02528:	2800      	cmp	r0, #0
c0d0252a:	d007      	beq.n	c0d0253c <u2f_transport_received+0x16c>
                (buffer[channelHeader] != U2F_CMD_INIT)) {
c0d0252c:	9802      	ldr	r0, [sp, #8]
c0d0252e:	7800      	ldrb	r0, [r0, #0]
c0d02530:	9908      	ldr	r1, [sp, #32]
c0d02532:	1c49      	adds	r1, r1, #1
c0d02534:	b2c9      	uxtb	r1, r1
        }

        // If waiting for a continuation on a different channel, reply BUSY
        // immediately
        if (media == U2F_MEDIA_USB) {
            if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d02536:	4288      	cmp	r0, r1
c0d02538:	d000      	beq.n	c0d0253c <u2f_transport_received+0x16c>
c0d0253a:	e0c1      	b.n	c0d026c0 <u2f_transport_received+0x2f0>
                goto error;
            }
        }
        // If a command was already sent, and we are not processing a INIT
        // command, abort
        if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d0253c:	7f20      	ldrb	r0, [r4, #28]
c0d0253e:	2801      	cmp	r0, #1
c0d02540:	d108      	bne.n	c0d02554 <u2f_transport_received+0x184>
            !((media == U2F_MEDIA_USB) &&
c0d02542:	2e01      	cmp	r6, #1
c0d02544:	d167      	bne.n	c0d02616 <u2f_transport_received+0x246>
              (buffer[channelHeader] == U2F_CMD_INIT))) {
c0d02546:	9802      	ldr	r0, [sp, #8]
c0d02548:	7800      	ldrb	r0, [r0, #0]
c0d0254a:	9908      	ldr	r1, [sp, #32]
c0d0254c:	1c49      	adds	r1, r1, #1
c0d0254e:	b2c9      	uxtb	r1, r1
                goto error;
            }
        }
        // If a command was already sent, and we are not processing a INIT
        // command, abort
        if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d02550:	4288      	cmp	r0, r1
c0d02552:	d160      	bne.n	c0d02616 <u2f_transport_received+0x246>
            u2f_transport_error(service, ERROR_INVALID_SEQ);
            goto error;
        }
        // Check the length
        uint16_t commandLength =
            (buffer[channelHeader + 1] << 8) | (buffer[channelHeader + 2]);
c0d02554:	2002      	movs	r0, #2
c0d02556:	9906      	ldr	r1, [sp, #24]
c0d02558:	4308      	orrs	r0, r1
c0d0255a:	9907      	ldr	r1, [sp, #28]
c0d0255c:	5c08      	ldrb	r0, [r1, r0]
c0d0255e:	5d49      	ldrb	r1, [r1, r5]
c0d02560:	020d      	lsls	r5, r1, #8
c0d02562:	4305      	orrs	r5, r0
        if (commandLength > (service->transportReceiveBufferLength - 3)) {
c0d02564:	89a0      	ldrh	r0, [r4, #12]
c0d02566:	1ec0      	subs	r0, r0, #3
c0d02568:	4285      	cmp	r5, r0
c0d0256a:	dd1b      	ble.n	c0d025a4 <u2f_transport_received+0x1d4>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0256c:	4861      	ldr	r0, [pc, #388]	; (c0d026f4 <u2f_transport_received+0x324>)
c0d0256e:	7207      	strb	r7, [r0, #8]
c0d02570:	2104      	movs	r1, #4
c0d02572:	e053      	b.n	c0d0261c <u2f_transport_received+0x24c>
c0d02574:	9a08      	ldr	r2, [sp, #32]
c0d02576:	4610      	mov	r0, r2
c0d02578:	3008      	adds	r0, #8
c0d0257a:	495e      	ldr	r1, [pc, #376]	; (c0d026f4 <u2f_transport_received+0x324>)
c0d0257c:	7208      	strb	r0, [r1, #8]
c0d0257e:	2004      	movs	r0, #4

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d02580:	7720      	strb	r0, [r4, #28]
c0d02582:	2000      	movs	r0, #0
    service->transportPacketIndex = 0;
c0d02584:	75a0      	strb	r0, [r4, #22]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d02586:	3108      	adds	r1, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d02588:	61a1      	str	r1, [r4, #24]
    service->transportOffset = 0;
c0d0258a:	8260      	strh	r0, [r4, #18]
c0d0258c:	e79c      	b.n	c0d024c8 <u2f_transport_received+0xf8>
            goto error;
        }
        if (service->transportState != U2F_HANDLE_SEGMENTED) {
            // Unexpected continuation at this stage, abort
            // TODO : review the behavior is HID only
            if (media == U2F_MEDIA_USB) {
c0d0258e:	2e01      	cmp	r6, #1
c0d02590:	d000      	beq.n	c0d02594 <u2f_transport_received+0x1c4>
c0d02592:	e77f      	b.n	c0d02494 <u2f_transport_received+0xc4>
c0d02594:	2000      	movs	r0, #0

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d02596:	7720      	strb	r0, [r4, #28]
    service->transportOffset = 0;
c0d02598:	8260      	strh	r0, [r4, #18]
    service->transportMedia = 0;
c0d0259a:	7760      	strb	r0, [r4, #29]
    service->transportPacketIndex = 0;
c0d0259c:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d0259e:	68a0      	ldr	r0, [r4, #8]
c0d025a0:	61a0      	str	r0, [r4, #24]
c0d025a2:	e799      	b.n	c0d024d8 <u2f_transport_received+0x108>
            // Overflow in message size, abort
            u2f_transport_error(service, ERROR_INVALID_LEN);
            goto error;
        }
        // Check if the command is supported
        switch (buffer[channelHeader]) {
c0d025a4:	9802      	ldr	r0, [sp, #8]
c0d025a6:	7800      	ldrb	r0, [r0, #0]
c0d025a8:	2881      	cmp	r0, #129	; 0x81
c0d025aa:	9a01      	ldr	r2, [sp, #4]
c0d025ac:	d003      	beq.n	c0d025b6 <u2f_transport_received+0x1e6>
c0d025ae:	2886      	cmp	r0, #134	; 0x86
c0d025b0:	d03c      	beq.n	c0d0262c <u2f_transport_received+0x25c>
c0d025b2:	2883      	cmp	r0, #131	; 0x83
c0d025b4:	d173      	bne.n	c0d0269e <u2f_transport_received+0x2ce>
        case U2F_CMD_PING:
        case U2F_CMD_MSG:
            if (media == U2F_MEDIA_USB) {
c0d025b6:	2e01      	cmp	r6, #1
c0d025b8:	d143      	bne.n	c0d02642 <u2f_transport_received+0x272>
error:
    return;
}

bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
c0d025ba:	4950      	ldr	r1, [pc, #320]	; (c0d026fc <u2f_transport_received+0x32c>)
c0d025bc:	4479      	add	r1, pc
c0d025be:	2704      	movs	r7, #4
c0d025c0:	4620      	mov	r0, r4
c0d025c2:	463a      	mov	r2, r7
c0d025c4:	f7fe fd72 	bl	c0d010ac <os_memcmp>
        // Check if the command is supported
        switch (buffer[channelHeader]) {
        case U2F_CMD_PING:
        case U2F_CMD_MSG:
            if (media == U2F_MEDIA_USB) {
                if (u2f_is_channel_broadcast(service->channel) ||
c0d025c8:	2800      	cmp	r0, #0
c0d025ca:	d100      	bne.n	c0d025ce <u2f_transport_received+0x1fe>
c0d025cc:	e08c      	b.n	c0d026e8 <u2f_transport_received+0x318>
bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
}

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
c0d025ce:	494c      	ldr	r1, [pc, #304]	; (c0d02700 <u2f_transport_received+0x330>)
c0d025d0:	4479      	add	r1, pc
c0d025d2:	2204      	movs	r2, #4
c0d025d4:	4620      	mov	r0, r4
c0d025d6:	e030      	b.n	c0d0263a <u2f_transport_received+0x26a>
c0d025d8:	9806      	ldr	r0, [sp, #24]
c0d025da:	9a07      	ldr	r2, [sp, #28]
                u2f_transport_error(service, ERROR_CHANNEL_BUSY);
                goto error;
            }
        }
        // also discriminate invalid command sent instead of a continuation
        if (buffer[channelHeader] != service->transportPacketIndex) {
c0d025dc:	1811      	adds	r1, r2, r0
c0d025de:	5c10      	ldrb	r0, [r2, r0]
c0d025e0:	7da2      	ldrb	r2, [r4, #22]
c0d025e2:	4290      	cmp	r0, r2
c0d025e4:	d000      	beq.n	c0d025e8 <u2f_transport_received+0x218>
c0d025e6:	e755      	b.n	c0d02494 <u2f_transport_received+0xc4>
c0d025e8:	9301      	str	r3, [sp, #4]
            // Bad continuation packet, abort
            u2f_transport_error(service, ERROR_INVALID_SEQ);
            goto error;
        }
        xfer_len = MIN(size - (channelHeader + 1), service->transportLength - service->transportOffset);
c0d025ea:	9805      	ldr	r0, [sp, #20]
c0d025ec:	1b45      	subs	r5, r0, r5
c0d025ee:	8a60      	ldrh	r0, [r4, #18]
c0d025f0:	8aa2      	ldrh	r2, [r4, #20]
c0d025f2:	1a12      	subs	r2, r2, r0
c0d025f4:	4295      	cmp	r5, r2
c0d025f6:	db00      	blt.n	c0d025fa <u2f_transport_received+0x22a>
c0d025f8:	4615      	mov	r5, r2
c0d025fa:	9a03      	ldr	r2, [sp, #12]
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
c0d025fc:	402a      	ands	r2, r5
c0d025fe:	69a3      	ldr	r3, [r4, #24]
c0d02600:	1818      	adds	r0, r3, r0
c0d02602:	1c49      	adds	r1, r1, #1
c0d02604:	f7fe fcb5 	bl	c0d00f72 <os_memmove>
        service->transportOffset += xfer_len;
c0d02608:	8a60      	ldrh	r0, [r4, #18]
c0d0260a:	1940      	adds	r0, r0, r5
c0d0260c:	8260      	strh	r0, [r4, #18]
        service->transportPacketIndex++;
c0d0260e:	7da0      	ldrb	r0, [r4, #22]
c0d02610:	1c40      	adds	r0, r0, #1
c0d02612:	75a0      	strb	r0, [r4, #22]
c0d02614:	e02e      	b.n	c0d02674 <u2f_transport_received+0x2a4>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d02616:	4837      	ldr	r0, [pc, #220]	; (c0d026f4 <u2f_transport_received+0x324>)
c0d02618:	2104      	movs	r1, #4
c0d0261a:	7201      	strb	r1, [r0, #8]
c0d0261c:	7721      	strb	r1, [r4, #28]
c0d0261e:	2100      	movs	r1, #0
c0d02620:	75a1      	strb	r1, [r4, #22]
c0d02622:	3008      	adds	r0, #8
c0d02624:	61a0      	str	r0, [r4, #24]
c0d02626:	8261      	strh	r1, [r4, #18]
c0d02628:	9801      	ldr	r0, [sp, #4]
c0d0262a:	e6e7      	b.n	c0d023fc <u2f_transport_received+0x2c>
                }
            }
            // no channel for BLE
            break;
        case U2F_CMD_INIT:
            if (media != U2F_MEDIA_USB) {
c0d0262c:	2e01      	cmp	r6, #1
c0d0262e:	d136      	bne.n	c0d0269e <u2f_transport_received+0x2ce>
bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
}

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
c0d02630:	4934      	ldr	r1, [pc, #208]	; (c0d02704 <u2f_transport_received+0x334>)
c0d02632:	4479      	add	r1, pc
c0d02634:	2704      	movs	r7, #4
c0d02636:	4620      	mov	r0, r4
c0d02638:	463a      	mov	r2, r7
c0d0263a:	f7fe fd37 	bl	c0d010ac <os_memcmp>
c0d0263e:	2800      	cmp	r0, #0
c0d02640:	d052      	beq.n	c0d026e8 <u2f_transport_received+0x318>
        }

        // Ok, initialize the buffer
        //if (buffer[channelHeader] != U2F_CMD_INIT) 
        {
            xfer_len = MIN(size - (channelHeader), U2F_COMMAND_HEADER_SIZE+commandLength);
c0d02642:	9805      	ldr	r0, [sp, #20]
c0d02644:	9906      	ldr	r1, [sp, #24]
c0d02646:	1a47      	subs	r7, r0, r1
c0d02648:	1ced      	adds	r5, r5, #3
c0d0264a:	42af      	cmp	r7, r5
c0d0264c:	9903      	ldr	r1, [sp, #12]
c0d0264e:	db00      	blt.n	c0d02652 <u2f_transport_received+0x282>
c0d02650:	462f      	mov	r7, r5
            os_memmove(service->transportBuffer, buffer + channelHeader, xfer_len);
c0d02652:	4039      	ands	r1, r7
c0d02654:	69a0      	ldr	r0, [r4, #24]
c0d02656:	460a      	mov	r2, r1
c0d02658:	9902      	ldr	r1, [sp, #8]
c0d0265a:	f7fe fc8a 	bl	c0d00f72 <os_memmove>
            service->transportOffset = xfer_len;
c0d0265e:	8267      	strh	r7, [r4, #18]
            service->transportLength = U2F_COMMAND_HEADER_SIZE+commandLength;
c0d02660:	82a5      	strh	r5, [r4, #20]
            service->transportMedia = media;
c0d02662:	7766      	strb	r6, [r4, #29]
            // initialize the response
            service->transportPacketIndex = 0;
c0d02664:	2000      	movs	r0, #0
c0d02666:	75a0      	strb	r0, [r4, #22]
            os_memmove(service->transportChannel, service->channel, 4);
c0d02668:	4620      	mov	r0, r4
c0d0266a:	300e      	adds	r0, #14
c0d0266c:	2204      	movs	r2, #4
c0d0266e:	4621      	mov	r1, r4
c0d02670:	f7fe fc7f 	bl	c0d00f72 <os_memmove>
c0d02674:	8a60      	ldrh	r0, [r4, #18]
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
        service->transportOffset += xfer_len;
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
c0d02676:	2e01      	cmp	r6, #1
c0d02678:	9b01      	ldr	r3, [sp, #4]
c0d0267a:	d101      	bne.n	c0d02680 <u2f_transport_received+0x2b0>
c0d0267c:	8aa1      	ldrh	r1, [r4, #20]
c0d0267e:	e008      	b.n	c0d02692 <u2f_transport_received+0x2c2>
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
c0d02680:	8aa1      	ldrh	r1, [r4, #20]
c0d02682:	1cca      	adds	r2, r1, #3
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
        service->transportOffset += xfer_len;
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
c0d02684:	4290      	cmp	r0, r2
c0d02686:	d904      	bls.n	c0d02692 <u2f_transport_received+0x2c2>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d02688:	481a      	ldr	r0, [pc, #104]	; (c0d026f4 <u2f_transport_received+0x324>)
c0d0268a:	2103      	movs	r1, #3
c0d0268c:	7201      	strb	r1, [r0, #8]
c0d0268e:	2104      	movs	r1, #4
c0d02690:	e703      	b.n	c0d0249a <u2f_transport_received+0xca>
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
c0d02692:	4288      	cmp	r0, r1
c0d02694:	d20e      	bcs.n	c0d026b4 <u2f_transport_received+0x2e4>
c0d02696:	2000      	movs	r0, #0
        service->transportState = U2F_PROCESSING_COMMAND;
        // internal notification of a complete message received
        u2f_message_complete(service);
    } else {
        // new segment received, reset the timeout for the current piece
        service->seqTimeout = 0;
c0d02698:	62a0      	str	r0, [r4, #40]	; 0x28
        service->transportState = U2F_HANDLE_SEGMENTED;
c0d0269a:	7723      	strb	r3, [r4, #28]
c0d0269c:	e71c      	b.n	c0d024d8 <u2f_transport_received+0x108>
c0d0269e:	4815      	ldr	r0, [pc, #84]	; (c0d026f4 <u2f_transport_received+0x324>)
c0d026a0:	7202      	strb	r2, [r0, #8]
c0d026a2:	2104      	movs	r1, #4
c0d026a4:	7721      	strb	r1, [r4, #28]
c0d026a6:	2100      	movs	r1, #0
c0d026a8:	75a1      	strb	r1, [r4, #22]
c0d026aa:	3008      	adds	r0, #8
c0d026ac:	61a0      	str	r0, [r4, #24]
c0d026ae:	8261      	strh	r1, [r4, #18]
c0d026b0:	82a2      	strh	r2, [r4, #20]
c0d026b2:	e6a4      	b.n	c0d023fe <u2f_transport_received+0x2e>
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
        // switch before the handler gets the opportunity to change it again
        service->transportState = U2F_PROCESSING_COMMAND;
c0d026b4:	2002      	movs	r0, #2
c0d026b6:	7720      	strb	r0, [r4, #28]
        // internal notification of a complete message received
        u2f_message_complete(service);
c0d026b8:	4620      	mov	r0, r4
c0d026ba:	f7ff fde5 	bl	c0d02288 <u2f_message_complete>
c0d026be:	e70b      	b.n	c0d024d8 <u2f_transport_received+0x108>
                // special error case, we reply but don't change the current state of the transport (ongoing message for example)
                //u2f_transport_error_no_reset(service, ERROR_CHANNEL_BUSY);
                uint16_t offset = 0;
                // Fragment
                if (media == U2F_MEDIA_USB) {
                    os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d026c0:	4d0c      	ldr	r5, [pc, #48]	; (c0d026f4 <u2f_transport_received+0x324>)
c0d026c2:	2204      	movs	r2, #4
c0d026c4:	4628      	mov	r0, r5
c0d026c6:	4621      	mov	r1, r4
c0d026c8:	f7fe fc53 	bl	c0d00f72 <os_memmove>
c0d026cc:	9808      	ldr	r0, [sp, #32]
                    offset += 4;
                }
                G_io_usb_ep_buffer[offset++] = U2F_STATUS_ERROR;
c0d026ce:	303a      	adds	r0, #58	; 0x3a
c0d026d0:	7128      	strb	r0, [r5, #4]
                G_io_usb_ep_buffer[offset++] = 0;
c0d026d2:	2000      	movs	r0, #0
c0d026d4:	7168      	strb	r0, [r5, #5]
c0d026d6:	9a01      	ldr	r2, [sp, #4]
                G_io_usb_ep_buffer[offset++] = 1;
c0d026d8:	71aa      	strb	r2, [r5, #6]
c0d026da:	2006      	movs	r0, #6
                G_io_usb_ep_buffer[offset++] = ERROR_CHANNEL_BUSY;
c0d026dc:	71e8      	strb	r0, [r5, #7]
                u2f_io_send(G_io_usb_ep_buffer, offset, media);
c0d026de:	2108      	movs	r1, #8
c0d026e0:	4628      	mov	r0, r5
c0d026e2:	f7ff fdef 	bl	c0d022c4 <u2f_io_send>
c0d026e6:	e6f7      	b.n	c0d024d8 <u2f_transport_received+0x108>
c0d026e8:	4802      	ldr	r0, [pc, #8]	; (c0d026f4 <u2f_transport_received+0x324>)
c0d026ea:	210b      	movs	r1, #11
c0d026ec:	7201      	strb	r1, [r0, #8]
c0d026ee:	7727      	strb	r7, [r4, #28]
c0d026f0:	e795      	b.n	c0d0261e <u2f_transport_received+0x24e>
c0d026f2:	46c0      	nop			; (mov r8, r8)
c0d026f4:	20001ab0 	.word	0x20001ab0
c0d026f8:	0000ffff 	.word	0x0000ffff
c0d026fc:	00001d5c 	.word	0x00001d5c
c0d02700:	00001d4c 	.word	0x00001d4c
c0d02704:	00001cea 	.word	0x00001cea

c0d02708 <u2f_is_channel_broadcast>:
    }
error:
    return;
}

bool u2f_is_channel_broadcast(uint8_t *channel) {
c0d02708:	b580      	push	{r7, lr}
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
c0d0270a:	4906      	ldr	r1, [pc, #24]	; (c0d02724 <u2f_is_channel_broadcast+0x1c>)
c0d0270c:	4479      	add	r1, pc
c0d0270e:	2204      	movs	r2, #4
c0d02710:	f7fe fccc 	bl	c0d010ac <os_memcmp>
c0d02714:	4601      	mov	r1, r0
c0d02716:	2001      	movs	r0, #1
c0d02718:	2200      	movs	r2, #0
c0d0271a:	2900      	cmp	r1, #0
c0d0271c:	d000      	beq.n	c0d02720 <u2f_is_channel_broadcast+0x18>
c0d0271e:	4610      	mov	r0, r2
c0d02720:	bd80      	pop	{r7, pc}
c0d02722:	46c0      	nop			; (mov r8, r8)
c0d02724:	00001c0c 	.word	0x00001c0c

c0d02728 <u2f_message_reply>:

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
}

void u2f_message_reply(u2f_service_t *service, uint8_t cmd, uint8_t *buffer, uint16_t len) {
c0d02728:	b510      	push	{r4, lr}
    service->transportState = U2F_SENDING_RESPONSE;
c0d0272a:	2403      	movs	r4, #3
c0d0272c:	7704      	strb	r4, [r0, #28]
c0d0272e:	2400      	movs	r4, #0
    service->transportPacketIndex = 0;
c0d02730:	7584      	strb	r4, [r0, #22]
    service->transportBuffer = buffer;
c0d02732:	6182      	str	r2, [r0, #24]
    service->transportOffset = 0;
c0d02734:	8244      	strh	r4, [r0, #18]
    service->transportLength = len;
c0d02736:	8283      	strh	r3, [r0, #20]
    service->sendCmd = cmd;
c0d02738:	2234      	movs	r2, #52	; 0x34
c0d0273a:	5481      	strb	r1, [r0, r2]
    // pump the first message
    u2f_transport_sent(service, service->transportMedia);
c0d0273c:	7f41      	ldrb	r1, [r0, #29]
c0d0273e:	f7ff fde5 	bl	c0d0230c <u2f_transport_sent>
}
c0d02742:	bd10      	pop	{r4, pc}

c0d02744 <io_seproxyhal_touch_approve>:
	}
	return NULL;
}

/** processes the transaction approval. the UI is only displayed when all of the TX has been sent over for signing. */
const bagl_element_t*io_seproxyhal_touch_approve(const bagl_element_t *e) {
c0d02744:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02746:	b0a7      	sub	sp, #156	; 0x9c
	unsigned int tx = 0;

	if (G_io_apdu_buffer[2] == P1_LAST) {
c0d02748:	4e39      	ldr	r6, [pc, #228]	; (c0d02830 <io_seproxyhal_touch_approve+0xec>)
c0d0274a:	78b0      	ldrb	r0, [r6, #2]
c0d0274c:	2500      	movs	r5, #0
		raw_tx_ix = 0;
		raw_tx_len = 0;

		// add hash to the response, so we can see where the bug is.
		G_io_apdu_buffer[tx++] = 0xFF;
		G_io_apdu_buffer[tx++] = 0xFF;
c0d0274e:	2780      	movs	r7, #128	; 0x80

/** processes the transaction approval. the UI is only displayed when all of the TX has been sent over for signing. */
const bagl_element_t*io_seproxyhal_touch_approve(const bagl_element_t *e) {
	unsigned int tx = 0;

	if (G_io_apdu_buffer[2] == P1_LAST) {
c0d02750:	2880      	cmp	r0, #128	; 0x80
c0d02752:	462c      	mov	r4, r5
c0d02754:	d15e      	bne.n	c0d02814 <io_seproxyhal_touch_approve+0xd0>
c0d02756:	9706      	str	r7, [sp, #24]
c0d02758:	9507      	str	r5, [sp, #28]
		unsigned int raw_tx_len_except_bip44 = raw_tx_len - BIP44_BYTE_LENGTH;
c0d0275a:	4836      	ldr	r0, [pc, #216]	; (c0d02834 <io_seproxyhal_touch_approve+0xf0>)
c0d0275c:	6804      	ldr	r4, [r0, #0]
c0d0275e:	2600      	movs	r6, #0
		// Update and sign the hash
		cx_hash(&hash.header, 0, raw_tx, raw_tx_len_except_bip44, NULL);
c0d02760:	4668      	mov	r0, sp
c0d02762:	6006      	str	r6, [r0, #0]
/** processes the transaction approval. the UI is only displayed when all of the TX has been sent over for signing. */
const bagl_element_t*io_seproxyhal_touch_approve(const bagl_element_t *e) {
	unsigned int tx = 0;

	if (G_io_apdu_buffer[2] == P1_LAST) {
		unsigned int raw_tx_len_except_bip44 = raw_tx_len - BIP44_BYTE_LENGTH;
c0d02764:	3c14      	subs	r4, #20
		// Update and sign the hash
		cx_hash(&hash.header, 0, raw_tx, raw_tx_len_except_bip44, NULL);
c0d02766:	4834      	ldr	r0, [pc, #208]	; (c0d02838 <io_seproxyhal_touch_approve+0xf4>)
c0d02768:	4d34      	ldr	r5, [pc, #208]	; (c0d0283c <io_seproxyhal_touch_approve+0xf8>)
c0d0276a:	4631      	mov	r1, r6
c0d0276c:	462a      	mov	r2, r5
c0d0276e:	4623      	mov	r3, r4
c0d02770:	f7fd fca8 	bl	c0d000c4 <cx_hash_X>
		unsigned char * bip44_in = raw_tx + raw_tx_len_except_bip44;

		/** BIP44 path, used to derive the private key from the mnemonic by calling os_perso_derive_node_bip32. */
		unsigned int bip44_path[BIP44_PATH_LEN];
		uint32_t i;
		for (i = 0; i < BIP44_PATH_LEN; i++) {
c0d02774:	1928      	adds	r0, r5, r4
			bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
c0d02776:	00b1      	lsls	r1, r6, #2
c0d02778:	5c42      	ldrb	r2, [r0, r1]
c0d0277a:	0612      	lsls	r2, r2, #24
c0d0277c:	1843      	adds	r3, r0, r1
c0d0277e:	785c      	ldrb	r4, [r3, #1]
c0d02780:	0424      	lsls	r4, r4, #16
c0d02782:	4314      	orrs	r4, r2
c0d02784:	789a      	ldrb	r2, [r3, #2]
c0d02786:	0212      	lsls	r2, r2, #8
c0d02788:	4322      	orrs	r2, r4
c0d0278a:	78db      	ldrb	r3, [r3, #3]
c0d0278c:	4313      	orrs	r3, r2
c0d0278e:	aa22      	add	r2, sp, #136	; 0x88
c0d02790:	5053      	str	r3, [r2, r1]
		unsigned char * bip44_in = raw_tx + raw_tx_len_except_bip44;

		/** BIP44 path, used to derive the private key from the mnemonic by calling os_perso_derive_node_bip32. */
		unsigned int bip44_path[BIP44_PATH_LEN];
		uint32_t i;
		for (i = 0; i < BIP44_PATH_LEN; i++) {
c0d02792:	1c76      	adds	r6, r6, #1
c0d02794:	2e05      	cmp	r6, #5
c0d02796:	d1ee      	bne.n	c0d02776 <io_seproxyhal_touch_approve+0x32>
c0d02798:	2600      	movs	r6, #0
			bip44_path[i] = (bip44_in[0] << 24) | (bip44_in[1] << 16) | (bip44_in[2] << 8) | (bip44_in[3]);
			bip44_in += 4;
		}

		unsigned char privateKeyData[32];
		os_perso_derive_node_bip32(CX_CURVE_256R1, bip44_path, BIP44_PATH_LEN, privateKeyData, NULL);
c0d0279a:	4668      	mov	r0, sp
c0d0279c:	6006      	str	r6, [r0, #0]
c0d0279e:	2522      	movs	r5, #34	; 0x22
c0d027a0:	a922      	add	r1, sp, #136	; 0x88
c0d027a2:	2205      	movs	r2, #5
c0d027a4:	af1a      	add	r7, sp, #104	; 0x68
c0d027a6:	4628      	mov	r0, r5
c0d027a8:	463b      	mov	r3, r7
c0d027aa:	f7ff fbd7 	bl	c0d01f5c <os_perso_derive_node_bip32>

		cx_ecfp_private_key_t privateKey;
		cx_ecdsa_init_private_key(CX_CURVE_256R1, privateKeyData, 32, &privateKey);
c0d027ae:	2420      	movs	r4, #32
c0d027b0:	ab10      	add	r3, sp, #64	; 0x40
c0d027b2:	9304      	str	r3, [sp, #16]
c0d027b4:	4628      	mov	r0, r5
c0d027b6:	4639      	mov	r1, r7
c0d027b8:	4622      	mov	r2, r4
c0d027ba:	9405      	str	r4, [sp, #20]
c0d027bc:	f7ff fb7e 	bl	c0d01ebc <cx_ecfp_init_private_key>
c0d027c0:	ad08      	add	r5, sp, #32

		// Hash is finalized, send back the signature
		unsigned char result[32];

		cx_hash(&hash.header, CX_LAST, G_io_apdu_buffer, 0, result);
c0d027c2:	4668      	mov	r0, sp
c0d027c4:	6005      	str	r5, [r0, #0]
c0d027c6:	481c      	ldr	r0, [pc, #112]	; (c0d02838 <io_seproxyhal_touch_approve+0xf4>)
c0d027c8:	2701      	movs	r7, #1
c0d027ca:	4639      	mov	r1, r7
c0d027cc:	4a18      	ldr	r2, [pc, #96]	; (c0d02830 <io_seproxyhal_touch_approve+0xec>)
c0d027ce:	4633      	mov	r3, r6
c0d027d0:	f7fd fc78 	bl	c0d000c4 <cx_hash_X>
#if CX_APILEVEL >= 8		
		tx = cx_ecdsa_sign((void*) &privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, result, sizeof(result), G_io_apdu_buffer, NULL);
c0d027d4:	4668      	mov	r0, sp
c0d027d6:	6004      	str	r4, [r0, #0]
c0d027d8:	4915      	ldr	r1, [pc, #84]	; (c0d02830 <io_seproxyhal_touch_approve+0xec>)
c0d027da:	6041      	str	r1, [r0, #4]
c0d027dc:	6086      	str	r6, [r0, #8]
c0d027de:	4918      	ldr	r1, [pc, #96]	; (c0d02840 <io_seproxyhal_touch_approve+0xfc>)
c0d027e0:	2203      	movs	r2, #3
c0d027e2:	9804      	ldr	r0, [sp, #16]
c0d027e4:	462b      	mov	r3, r5
c0d027e6:	f7fd fcd2 	bl	c0d0018e <cx_ecdsa_sign_X>
c0d027ea:	4604      	mov	r4, r0
#else		
		tx = cx_ecdsa_sign((void*) &privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, result, sizeof(result), G_io_apdu_buffer);
#endif		
		// G_io_apdu_buffer[0] &= 0xF0; // discard the parity information
		hashTainted = 1;
c0d027ec:	4815      	ldr	r0, [pc, #84]	; (c0d02844 <io_seproxyhal_touch_approve+0x100>)
c0d027ee:	7007      	strb	r7, [r0, #0]
		raw_tx_ix = 0;
c0d027f0:	4815      	ldr	r0, [pc, #84]	; (c0d02848 <io_seproxyhal_touch_approve+0x104>)
c0d027f2:	6006      	str	r6, [r0, #0]
		raw_tx_len = 0;
c0d027f4:	480f      	ldr	r0, [pc, #60]	; (c0d02834 <io_seproxyhal_touch_approve+0xf0>)
c0d027f6:	6006      	str	r6, [r0, #0]
c0d027f8:	4e0d      	ldr	r6, [pc, #52]	; (c0d02830 <io_seproxyhal_touch_approve+0xec>)
c0d027fa:	9f06      	ldr	r7, [sp, #24]

		// add hash to the response, so we can see where the bug is.
		G_io_apdu_buffer[tx++] = 0xFF;
c0d027fc:	4638      	mov	r0, r7
c0d027fe:	307f      	adds	r0, #127	; 0x7f
c0d02800:	5530      	strb	r0, [r6, r4]
		cx_ecdsa_init_private_key(CX_CURVE_256R1, privateKeyData, 32, &privateKey);

		// Hash is finalized, send back the signature
		unsigned char result[32];

		cx_hash(&hash.header, CX_LAST, G_io_apdu_buffer, 0, result);
c0d02802:	1931      	adds	r1, r6, r4
		raw_tx_ix = 0;
		raw_tx_len = 0;

		// add hash to the response, so we can see where the bug is.
		G_io_apdu_buffer[tx++] = 0xFF;
		G_io_apdu_buffer[tx++] = 0xFF;
c0d02804:	7048      	strb	r0, [r1, #1]
		for (int ix = 0; ix < 32; ix++) {
c0d02806:	1c88      	adds	r0, r1, #2
			G_io_apdu_buffer[tx++] = result[ix];
c0d02808:	4629      	mov	r1, r5
c0d0280a:	9a05      	ldr	r2, [sp, #20]
c0d0280c:	f001 fc76 	bl	c0d040fc <__aeabi_memcpy>
		raw_tx_len = 0;

		// add hash to the response, so we can see where the bug is.
		G_io_apdu_buffer[tx++] = 0xFF;
		G_io_apdu_buffer[tx++] = 0xFF;
		for (int ix = 0; ix < 32; ix++) {
c0d02810:	3422      	adds	r4, #34	; 0x22
c0d02812:	9d07      	ldr	r5, [sp, #28]
			G_io_apdu_buffer[tx++] = result[ix];
		}
	}
	G_io_apdu_buffer[tx++] = 0x90;
c0d02814:	3710      	adds	r7, #16
c0d02816:	5537      	strb	r7, [r6, r4]
c0d02818:	1930      	adds	r0, r6, r4
	G_io_apdu_buffer[tx++] = 0x00;
c0d0281a:	7045      	strb	r5, [r0, #1]
c0d0281c:	1ca0      	adds	r0, r4, #2
	// Send back the response, do not restart the event loop
	io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, tx);
c0d0281e:	b281      	uxth	r1, r0
c0d02820:	2020      	movs	r0, #32
c0d02822:	f7fe ff7d 	bl	c0d01720 <io_exchange>
	// Display back the original UX
	ui_idle();
c0d02826:	f000 f811 	bl	c0d0284c <ui_idle>
	return 0; // do not redraw the widget
c0d0282a:	4628      	mov	r0, r5
c0d0282c:	b027      	add	sp, #156	; 0x9c
c0d0282e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02830:	200018f8 	.word	0x200018f8
c0d02834:	20001af0 	.word	0x20001af0
c0d02838:	20001af4 	.word	0x20001af4
c0d0283c:	20001b60 	.word	0x20001b60
c0d02840:	00000601 	.word	0x00000601
c0d02844:	20001f60 	.word	0x20001f60
c0d02848:	20001f64 	.word	0x20001f64

c0d0284c <ui_idle>:
		UX_DISPLAY(bagl_ui_public_key_nanos_2, NULL);
	}
}

/** show the idle screen. */
void ui_idle(void) {
c0d0284c:	b5b0      	push	{r4, r5, r7, lr}
	uiState = UI_IDLE;
c0d0284e:	4845      	ldr	r0, [pc, #276]	; (c0d02964 <ui_idle+0x118>)
c0d02850:	2101      	movs	r1, #1
c0d02852:	7001      	strb	r1, [r0, #0]
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d02854:	020c      	lsls	r4, r1, #8
c0d02856:	f7ff fbc5 	bl	c0d01fe4 <os_seph_features>
c0d0285a:	4220      	tst	r0, r4
c0d0285c:	d140      	bne.n	c0d028e0 <ui_idle+0x94>
		UX_DISPLAY(bagl_ui_idle_blue, NULL);
	} else {
		UX_DISPLAY(bagl_ui_idle_nanos, NULL);
c0d0285e:	4c42      	ldr	r4, [pc, #264]	; (c0d02968 <ui_idle+0x11c>)
c0d02860:	4845      	ldr	r0, [pc, #276]	; (c0d02978 <ui_idle+0x12c>)
c0d02862:	4478      	add	r0, pc
c0d02864:	6020      	str	r0, [r4, #0]
c0d02866:	2004      	movs	r0, #4
c0d02868:	6060      	str	r0, [r4, #4]
c0d0286a:	4844      	ldr	r0, [pc, #272]	; (c0d0297c <ui_idle+0x130>)
c0d0286c:	4478      	add	r0, pc
c0d0286e:	6120      	str	r0, [r4, #16]
c0d02870:	2500      	movs	r5, #0
c0d02872:	60e5      	str	r5, [r4, #12]
c0d02874:	2003      	movs	r0, #3
c0d02876:	7620      	strb	r0, [r4, #24]
c0d02878:	61e5      	str	r5, [r4, #28]
c0d0287a:	4620      	mov	r0, r4
c0d0287c:	3018      	adds	r0, #24
c0d0287e:	f7ff fb9b 	bl	c0d01fb8 <os_ux>
c0d02882:	61e0      	str	r0, [r4, #28]
c0d02884:	f7ff f848 	bl	c0d01918 <ux_check_status_default>
c0d02888:	f7fe fd88 	bl	c0d0139c <io_seproxyhal_init_ux>
c0d0288c:	60a5      	str	r5, [r4, #8]
c0d0288e:	6820      	ldr	r0, [r4, #0]
c0d02890:	2800      	cmp	r0, #0
c0d02892:	d065      	beq.n	c0d02960 <ui_idle+0x114>
c0d02894:	69e0      	ldr	r0, [r4, #28]
c0d02896:	4935      	ldr	r1, [pc, #212]	; (c0d0296c <ui_idle+0x120>)
c0d02898:	4288      	cmp	r0, r1
c0d0289a:	d11e      	bne.n	c0d028da <ui_idle+0x8e>
c0d0289c:	e060      	b.n	c0d02960 <ui_idle+0x114>
c0d0289e:	6860      	ldr	r0, [r4, #4]
c0d028a0:	4285      	cmp	r5, r0
c0d028a2:	d25d      	bcs.n	c0d02960 <ui_idle+0x114>
c0d028a4:	f7ff fbca 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d028a8:	2800      	cmp	r0, #0
c0d028aa:	d159      	bne.n	c0d02960 <ui_idle+0x114>
c0d028ac:	68a0      	ldr	r0, [r4, #8]
c0d028ae:	68e1      	ldr	r1, [r4, #12]
c0d028b0:	2538      	movs	r5, #56	; 0x38
c0d028b2:	4368      	muls	r0, r5
c0d028b4:	6822      	ldr	r2, [r4, #0]
c0d028b6:	1810      	adds	r0, r2, r0
c0d028b8:	2900      	cmp	r1, #0
c0d028ba:	d002      	beq.n	c0d028c2 <ui_idle+0x76>
c0d028bc:	4788      	blx	r1
c0d028be:	2800      	cmp	r0, #0
c0d028c0:	d007      	beq.n	c0d028d2 <ui_idle+0x86>
c0d028c2:	2801      	cmp	r0, #1
c0d028c4:	d103      	bne.n	c0d028ce <ui_idle+0x82>
c0d028c6:	68a0      	ldr	r0, [r4, #8]
c0d028c8:	4345      	muls	r5, r0
c0d028ca:	6820      	ldr	r0, [r4, #0]
c0d028cc:	1940      	adds	r0, r0, r5
c0d028ce:	f7fd fca1 	bl	c0d00214 <io_seproxyhal_display>
c0d028d2:	68a0      	ldr	r0, [r4, #8]
c0d028d4:	1c45      	adds	r5, r0, #1
c0d028d6:	60a5      	str	r5, [r4, #8]
c0d028d8:	6820      	ldr	r0, [r4, #0]
c0d028da:	2800      	cmp	r0, #0
c0d028dc:	d1df      	bne.n	c0d0289e <ui_idle+0x52>
c0d028de:	e03f      	b.n	c0d02960 <ui_idle+0x114>

/** show the idle screen. */
void ui_idle(void) {
	uiState = UI_IDLE;
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
		UX_DISPLAY(bagl_ui_idle_blue, NULL);
c0d028e0:	4c21      	ldr	r4, [pc, #132]	; (c0d02968 <ui_idle+0x11c>)
c0d028e2:	4823      	ldr	r0, [pc, #140]	; (c0d02970 <ui_idle+0x124>)
c0d028e4:	4478      	add	r0, pc
c0d028e6:	6020      	str	r0, [r4, #0]
c0d028e8:	2005      	movs	r0, #5
c0d028ea:	6060      	str	r0, [r4, #4]
c0d028ec:	4821      	ldr	r0, [pc, #132]	; (c0d02974 <ui_idle+0x128>)
c0d028ee:	4478      	add	r0, pc
c0d028f0:	6120      	str	r0, [r4, #16]
c0d028f2:	2500      	movs	r5, #0
c0d028f4:	60e5      	str	r5, [r4, #12]
c0d028f6:	2003      	movs	r0, #3
c0d028f8:	7620      	strb	r0, [r4, #24]
c0d028fa:	61e5      	str	r5, [r4, #28]
c0d028fc:	4620      	mov	r0, r4
c0d028fe:	3018      	adds	r0, #24
c0d02900:	f7ff fb5a 	bl	c0d01fb8 <os_ux>
c0d02904:	61e0      	str	r0, [r4, #28]
c0d02906:	f7ff f807 	bl	c0d01918 <ux_check_status_default>
c0d0290a:	f7fe fd47 	bl	c0d0139c <io_seproxyhal_init_ux>
c0d0290e:	60a5      	str	r5, [r4, #8]
c0d02910:	6820      	ldr	r0, [r4, #0]
c0d02912:	2800      	cmp	r0, #0
c0d02914:	d024      	beq.n	c0d02960 <ui_idle+0x114>
c0d02916:	69e0      	ldr	r0, [r4, #28]
c0d02918:	4914      	ldr	r1, [pc, #80]	; (c0d0296c <ui_idle+0x120>)
c0d0291a:	4288      	cmp	r0, r1
c0d0291c:	d11e      	bne.n	c0d0295c <ui_idle+0x110>
c0d0291e:	e01f      	b.n	c0d02960 <ui_idle+0x114>
c0d02920:	6860      	ldr	r0, [r4, #4]
c0d02922:	4285      	cmp	r5, r0
c0d02924:	d21c      	bcs.n	c0d02960 <ui_idle+0x114>
c0d02926:	f7ff fb89 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d0292a:	2800      	cmp	r0, #0
c0d0292c:	d118      	bne.n	c0d02960 <ui_idle+0x114>
c0d0292e:	68a0      	ldr	r0, [r4, #8]
c0d02930:	68e1      	ldr	r1, [r4, #12]
c0d02932:	2538      	movs	r5, #56	; 0x38
c0d02934:	4368      	muls	r0, r5
c0d02936:	6822      	ldr	r2, [r4, #0]
c0d02938:	1810      	adds	r0, r2, r0
c0d0293a:	2900      	cmp	r1, #0
c0d0293c:	d002      	beq.n	c0d02944 <ui_idle+0xf8>
c0d0293e:	4788      	blx	r1
c0d02940:	2800      	cmp	r0, #0
c0d02942:	d007      	beq.n	c0d02954 <ui_idle+0x108>
c0d02944:	2801      	cmp	r0, #1
c0d02946:	d103      	bne.n	c0d02950 <ui_idle+0x104>
c0d02948:	68a0      	ldr	r0, [r4, #8]
c0d0294a:	4345      	muls	r5, r0
c0d0294c:	6820      	ldr	r0, [r4, #0]
c0d0294e:	1940      	adds	r0, r0, r5
c0d02950:	f7fd fc60 	bl	c0d00214 <io_seproxyhal_display>
c0d02954:	68a0      	ldr	r0, [r4, #8]
c0d02956:	1c45      	adds	r5, r0, #1
c0d02958:	60a5      	str	r5, [r4, #8]
c0d0295a:	6820      	ldr	r0, [r4, #0]
c0d0295c:	2800      	cmp	r0, #0
c0d0295e:	d1df      	bne.n	c0d02920 <ui_idle+0xd4>
	} else {
		UX_DISPLAY(bagl_ui_idle_nanos, NULL);
	}
}
c0d02960:	bdb0      	pop	{r4, r5, r7, pc}
c0d02962:	46c0      	nop			; (mov r8, r8)
c0d02964:	20001f68 	.word	0x20001f68
c0d02968:	20001f6c 	.word	0x20001f6c
c0d0296c:	b0105044 	.word	0xb0105044
c0d02970:	00001a80 	.word	0x00001a80
c0d02974:	0000008f 	.word	0x0000008f
c0d02978:	00001c1a 	.word	0x00001c1a
c0d0297c:	00000115 	.word	0x00000115

c0d02980 <bagl_ui_idle_blue_button>:
	ui_idle();
	return 0; // do not redraw the widget
}

static unsigned int bagl_ui_idle_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
	return 0;
c0d02980:	2000      	movs	r0, #0
c0d02982:	4770      	bx	lr

c0d02984 <bagl_ui_idle_nanos_button>:
/**
 * buttons for the idle screen
 *
 * exit on Left button, or on Both buttons. Do nothing on Right button only.
 */
static unsigned int bagl_ui_idle_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d02984:	b580      	push	{r7, lr}
	switch (button_mask) {
c0d02986:	4907      	ldr	r1, [pc, #28]	; (c0d029a4 <bagl_ui_idle_nanos_button+0x20>)
c0d02988:	4288      	cmp	r0, r1
c0d0298a:	d005      	beq.n	c0d02998 <bagl_ui_idle_nanos_button+0x14>
c0d0298c:	4906      	ldr	r1, [pc, #24]	; (c0d029a8 <bagl_ui_idle_nanos_button+0x24>)
c0d0298e:	4288      	cmp	r0, r1
c0d02990:	d105      	bne.n	c0d0299e <bagl_ui_idle_nanos_button+0x1a>
	case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
		ui_public_key_1();
c0d02992:	f000 f8d1 	bl	c0d02b38 <ui_public_key_1>
c0d02996:	e002      	b.n	c0d0299e <bagl_ui_idle_nanos_button+0x1a>
}

/** if the user wants to exit go back to the app dashboard. */
static const bagl_element_t *io_seproxyhal_touch_exit(const bagl_element_t *e) {
	// Go back to the dashboard
	os_sched_exit(0);
c0d02998:	2000      	movs	r0, #0
c0d0299a:	f7ff faf7 	bl	c0d01f8c <os_sched_exit>
	case BUTTON_EVT_RELEASED | BUTTON_LEFT:
		io_seproxyhal_touch_exit(NULL);
		break;
	}

	return 0;
c0d0299e:	2000      	movs	r0, #0
c0d029a0:	bd80      	pop	{r7, pc}
c0d029a2:	46c0      	nop			; (mov r8, r8)
c0d029a4:	80000001 	.word	0x80000001
c0d029a8:	80000002 	.word	0x80000002

c0d029ac <ui_top_sign>:
		UX_DISPLAY(bagl_ui_sign_nanos, NULL);
	}
}

/** show the top "Sign Transaction" screen. */
void ui_top_sign(void) {
c0d029ac:	b5b0      	push	{r4, r5, r7, lr}
	uiState = UI_TOP_SIGN;
c0d029ae:	4845      	ldr	r0, [pc, #276]	; (c0d02ac4 <ui_top_sign+0x118>)
c0d029b0:	2102      	movs	r1, #2
c0d029b2:	7001      	strb	r1, [r0, #0]
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d029b4:	2001      	movs	r0, #1
c0d029b6:	0204      	lsls	r4, r0, #8
c0d029b8:	f7ff fb14 	bl	c0d01fe4 <os_seph_features>
c0d029bc:	4220      	tst	r0, r4
c0d029be:	d140      	bne.n	c0d02a42 <ui_top_sign+0x96>
		UX_DISPLAY(bagl_ui_top_sign_blue, NULL);
	} else {
		UX_DISPLAY(bagl_ui_top_sign_nanos, NULL);
c0d029c0:	4c41      	ldr	r4, [pc, #260]	; (c0d02ac8 <ui_top_sign+0x11c>)
c0d029c2:	4845      	ldr	r0, [pc, #276]	; (c0d02ad8 <ui_top_sign+0x12c>)
c0d029c4:	4478      	add	r0, pc
c0d029c6:	6020      	str	r0, [r4, #0]
c0d029c8:	2006      	movs	r0, #6
c0d029ca:	6060      	str	r0, [r4, #4]
c0d029cc:	4843      	ldr	r0, [pc, #268]	; (c0d02adc <ui_top_sign+0x130>)
c0d029ce:	4478      	add	r0, pc
c0d029d0:	6120      	str	r0, [r4, #16]
c0d029d2:	2500      	movs	r5, #0
c0d029d4:	60e5      	str	r5, [r4, #12]
c0d029d6:	2003      	movs	r0, #3
c0d029d8:	7620      	strb	r0, [r4, #24]
c0d029da:	61e5      	str	r5, [r4, #28]
c0d029dc:	4620      	mov	r0, r4
c0d029de:	3018      	adds	r0, #24
c0d029e0:	f7ff faea 	bl	c0d01fb8 <os_ux>
c0d029e4:	61e0      	str	r0, [r4, #28]
c0d029e6:	f7fe ff97 	bl	c0d01918 <ux_check_status_default>
c0d029ea:	f7fe fcd7 	bl	c0d0139c <io_seproxyhal_init_ux>
c0d029ee:	60a5      	str	r5, [r4, #8]
c0d029f0:	6820      	ldr	r0, [r4, #0]
c0d029f2:	2800      	cmp	r0, #0
c0d029f4:	d065      	beq.n	c0d02ac2 <ui_top_sign+0x116>
c0d029f6:	69e0      	ldr	r0, [r4, #28]
c0d029f8:	4934      	ldr	r1, [pc, #208]	; (c0d02acc <ui_top_sign+0x120>)
c0d029fa:	4288      	cmp	r0, r1
c0d029fc:	d11e      	bne.n	c0d02a3c <ui_top_sign+0x90>
c0d029fe:	e060      	b.n	c0d02ac2 <ui_top_sign+0x116>
c0d02a00:	6860      	ldr	r0, [r4, #4]
c0d02a02:	4285      	cmp	r5, r0
c0d02a04:	d25d      	bcs.n	c0d02ac2 <ui_top_sign+0x116>
c0d02a06:	f7ff fb19 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d02a0a:	2800      	cmp	r0, #0
c0d02a0c:	d159      	bne.n	c0d02ac2 <ui_top_sign+0x116>
c0d02a0e:	68a0      	ldr	r0, [r4, #8]
c0d02a10:	68e1      	ldr	r1, [r4, #12]
c0d02a12:	2538      	movs	r5, #56	; 0x38
c0d02a14:	4368      	muls	r0, r5
c0d02a16:	6822      	ldr	r2, [r4, #0]
c0d02a18:	1810      	adds	r0, r2, r0
c0d02a1a:	2900      	cmp	r1, #0
c0d02a1c:	d002      	beq.n	c0d02a24 <ui_top_sign+0x78>
c0d02a1e:	4788      	blx	r1
c0d02a20:	2800      	cmp	r0, #0
c0d02a22:	d007      	beq.n	c0d02a34 <ui_top_sign+0x88>
c0d02a24:	2801      	cmp	r0, #1
c0d02a26:	d103      	bne.n	c0d02a30 <ui_top_sign+0x84>
c0d02a28:	68a0      	ldr	r0, [r4, #8]
c0d02a2a:	4345      	muls	r5, r0
c0d02a2c:	6820      	ldr	r0, [r4, #0]
c0d02a2e:	1940      	adds	r0, r0, r5
c0d02a30:	f7fd fbf0 	bl	c0d00214 <io_seproxyhal_display>
c0d02a34:	68a0      	ldr	r0, [r4, #8]
c0d02a36:	1c45      	adds	r5, r0, #1
c0d02a38:	60a5      	str	r5, [r4, #8]
c0d02a3a:	6820      	ldr	r0, [r4, #0]
c0d02a3c:	2800      	cmp	r0, #0
c0d02a3e:	d1df      	bne.n	c0d02a00 <ui_top_sign+0x54>
c0d02a40:	e03f      	b.n	c0d02ac2 <ui_top_sign+0x116>

/** show the top "Sign Transaction" screen. */
void ui_top_sign(void) {
	uiState = UI_TOP_SIGN;
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
		UX_DISPLAY(bagl_ui_top_sign_blue, NULL);
c0d02a42:	4c21      	ldr	r4, [pc, #132]	; (c0d02ac8 <ui_top_sign+0x11c>)
c0d02a44:	4822      	ldr	r0, [pc, #136]	; (c0d02ad0 <ui_top_sign+0x124>)
c0d02a46:	4478      	add	r0, pc
c0d02a48:	6020      	str	r0, [r4, #0]
c0d02a4a:	2007      	movs	r0, #7
c0d02a4c:	6060      	str	r0, [r4, #4]
c0d02a4e:	4821      	ldr	r0, [pc, #132]	; (c0d02ad4 <ui_top_sign+0x128>)
c0d02a50:	4478      	add	r0, pc
c0d02a52:	6120      	str	r0, [r4, #16]
c0d02a54:	2500      	movs	r5, #0
c0d02a56:	60e5      	str	r5, [r4, #12]
c0d02a58:	2003      	movs	r0, #3
c0d02a5a:	7620      	strb	r0, [r4, #24]
c0d02a5c:	61e5      	str	r5, [r4, #28]
c0d02a5e:	4620      	mov	r0, r4
c0d02a60:	3018      	adds	r0, #24
c0d02a62:	f7ff faa9 	bl	c0d01fb8 <os_ux>
c0d02a66:	61e0      	str	r0, [r4, #28]
c0d02a68:	f7fe ff56 	bl	c0d01918 <ux_check_status_default>
c0d02a6c:	f7fe fc96 	bl	c0d0139c <io_seproxyhal_init_ux>
c0d02a70:	60a5      	str	r5, [r4, #8]
c0d02a72:	6820      	ldr	r0, [r4, #0]
c0d02a74:	2800      	cmp	r0, #0
c0d02a76:	d024      	beq.n	c0d02ac2 <ui_top_sign+0x116>
c0d02a78:	69e0      	ldr	r0, [r4, #28]
c0d02a7a:	4914      	ldr	r1, [pc, #80]	; (c0d02acc <ui_top_sign+0x120>)
c0d02a7c:	4288      	cmp	r0, r1
c0d02a7e:	d11e      	bne.n	c0d02abe <ui_top_sign+0x112>
c0d02a80:	e01f      	b.n	c0d02ac2 <ui_top_sign+0x116>
c0d02a82:	6860      	ldr	r0, [r4, #4]
c0d02a84:	4285      	cmp	r5, r0
c0d02a86:	d21c      	bcs.n	c0d02ac2 <ui_top_sign+0x116>
c0d02a88:	f7ff fad8 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d02a8c:	2800      	cmp	r0, #0
c0d02a8e:	d118      	bne.n	c0d02ac2 <ui_top_sign+0x116>
c0d02a90:	68a0      	ldr	r0, [r4, #8]
c0d02a92:	68e1      	ldr	r1, [r4, #12]
c0d02a94:	2538      	movs	r5, #56	; 0x38
c0d02a96:	4368      	muls	r0, r5
c0d02a98:	6822      	ldr	r2, [r4, #0]
c0d02a9a:	1810      	adds	r0, r2, r0
c0d02a9c:	2900      	cmp	r1, #0
c0d02a9e:	d002      	beq.n	c0d02aa6 <ui_top_sign+0xfa>
c0d02aa0:	4788      	blx	r1
c0d02aa2:	2800      	cmp	r0, #0
c0d02aa4:	d007      	beq.n	c0d02ab6 <ui_top_sign+0x10a>
c0d02aa6:	2801      	cmp	r0, #1
c0d02aa8:	d103      	bne.n	c0d02ab2 <ui_top_sign+0x106>
c0d02aaa:	68a0      	ldr	r0, [r4, #8]
c0d02aac:	4345      	muls	r5, r0
c0d02aae:	6820      	ldr	r0, [r4, #0]
c0d02ab0:	1940      	adds	r0, r0, r5
c0d02ab2:	f7fd fbaf 	bl	c0d00214 <io_seproxyhal_display>
c0d02ab6:	68a0      	ldr	r0, [r4, #8]
c0d02ab8:	1c45      	adds	r5, r0, #1
c0d02aba:	60a5      	str	r5, [r4, #8]
c0d02abc:	6820      	ldr	r0, [r4, #0]
c0d02abe:	2800      	cmp	r0, #0
c0d02ac0:	d1df      	bne.n	c0d02a82 <ui_top_sign+0xd6>
	} else {
		UX_DISPLAY(bagl_ui_top_sign_nanos, NULL);
	}
}
c0d02ac2:	bdb0      	pop	{r4, r5, r7, pc}
c0d02ac4:	20001f68 	.word	0x20001f68
c0d02ac8:	20001f6c 	.word	0x20001f6c
c0d02acc:	b0105044 	.word	0xb0105044
c0d02ad0:	00001d46 	.word	0x00001d46
c0d02ad4:	0000008d 	.word	0x0000008d
c0d02ad8:	000024c8 	.word	0x000024c8
c0d02adc:	00000113 	.word	0x00000113

c0d02ae0 <bagl_ui_top_sign_blue_button>:
static unsigned int bagl_ui_sign_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
	return 0;
}

static unsigned int bagl_ui_top_sign_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
	return 0;
c0d02ae0:	2000      	movs	r0, #0
c0d02ae2:	4770      	bx	lr

c0d02ae4 <bagl_ui_top_sign_nanos_button>:
/**
 * buttons for the top "Sign Transaction" screen
 *
 * up on Left button, down on right button, sign on both buttons.
 */
static unsigned int bagl_ui_top_sign_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d02ae4:	b580      	push	{r7, lr}
	switch (button_mask) {
c0d02ae6:	490a      	ldr	r1, [pc, #40]	; (c0d02b10 <bagl_ui_top_sign_nanos_button+0x2c>)
c0d02ae8:	4288      	cmp	r0, r1
c0d02aea:	d008      	beq.n	c0d02afe <bagl_ui_top_sign_nanos_button+0x1a>
c0d02aec:	4909      	ldr	r1, [pc, #36]	; (c0d02b14 <bagl_ui_top_sign_nanos_button+0x30>)
c0d02aee:	4288      	cmp	r0, r1
c0d02af0:	d009      	beq.n	c0d02b06 <bagl_ui_top_sign_nanos_button+0x22>
c0d02af2:	4909      	ldr	r1, [pc, #36]	; (c0d02b18 <bagl_ui_top_sign_nanos_button+0x34>)
c0d02af4:	4288      	cmp	r0, r1
c0d02af6:	d109      	bne.n	c0d02b0c <bagl_ui_top_sign_nanos_button+0x28>
	case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT:
		io_seproxyhal_touch_approve(NULL);
c0d02af8:	f7ff fe24 	bl	c0d02744 <io_seproxyhal_touch_approve>
c0d02afc:	e006      	b.n	c0d02b0c <bagl_ui_top_sign_nanos_button+0x28>
	case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
		tx_desc_dn(NULL);
		break;

	case BUTTON_EVT_RELEASED | BUTTON_LEFT:
		tx_desc_up(NULL);
c0d02afe:	2000      	movs	r0, #0
c0d02b00:	f000 f954 	bl	c0d02dac <tx_desc_up>
c0d02b04:	e002      	b.n	c0d02b0c <bagl_ui_top_sign_nanos_button+0x28>
	case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT:
		io_seproxyhal_touch_approve(NULL);
		break;

	case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
		tx_desc_dn(NULL);
c0d02b06:	2000      	movs	r0, #0
c0d02b08:	f000 f9fe 	bl	c0d02f08 <tx_desc_dn>

	case BUTTON_EVT_RELEASED | BUTTON_LEFT:
		tx_desc_up(NULL);
		break;
	}
	return 0;
c0d02b0c:	2000      	movs	r0, #0
c0d02b0e:	bd80      	pop	{r7, pc}
c0d02b10:	80000001 	.word	0x80000001
c0d02b14:	80000002 	.word	0x80000002
c0d02b18:	80000003 	.word	0x80000003

c0d02b1c <get_apdu_buffer_length>:
	}
}

/** returns the length of the transaction in the buffer. */
unsigned int get_apdu_buffer_length() {
	unsigned int len0 = G_io_apdu_buffer[APDU_BODY_LENGTH_OFFSET];
c0d02b1c:	4801      	ldr	r0, [pc, #4]	; (c0d02b24 <get_apdu_buffer_length+0x8>)
c0d02b1e:	7900      	ldrb	r0, [r0, #4]
	return len0;
c0d02b20:	4770      	bx	lr
c0d02b22:	46c0      	nop			; (mov r8, r8)
c0d02b24:	200018f8 	.word	0x200018f8

c0d02b28 <io_seproxyhal_touch_exit>:
	}
	return 0;
}

/** if the user wants to exit go back to the app dashboard. */
static const bagl_element_t *io_seproxyhal_touch_exit(const bagl_element_t *e) {
c0d02b28:	b510      	push	{r4, lr}
c0d02b2a:	2400      	movs	r4, #0
	// Go back to the dashboard
	os_sched_exit(0);
c0d02b2c:	4620      	mov	r0, r4
c0d02b2e:	f7ff fa2d 	bl	c0d01f8c <os_sched_exit>
	return NULL; // do not redraw the widget
c0d02b32:	4620      	mov	r0, r4
c0d02b34:	bd10      	pop	{r4, pc}
	...

c0d02b38 <ui_public_key_1>:
static unsigned int bagl_ui_deny_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
	return 0;
}

/** show the public key screen */
void ui_public_key_1(void) {
c0d02b38:	b570      	push	{r4, r5, r6, lr}
	uiState = UI_PUBLIC_KEY_1;
c0d02b3a:	483a      	ldr	r0, [pc, #232]	; (c0d02c24 <ui_public_key_1+0xec>)
c0d02b3c:	2107      	movs	r1, #7
c0d02b3e:	7001      	strb	r1, [r0, #0]
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d02b40:	f7ff fa50 	bl	c0d01fe4 <os_seph_features>
c0d02b44:	4604      	mov	r4, r0
c0d02b46:	4d38      	ldr	r5, [pc, #224]	; (c0d02c28 <ui_public_key_1+0xf0>)
c0d02b48:	4839      	ldr	r0, [pc, #228]	; (c0d02c30 <ui_public_key_1+0xf8>)
c0d02b4a:	4478      	add	r0, pc
c0d02b4c:	6028      	str	r0, [r5, #0]
c0d02b4e:	2005      	movs	r0, #5
c0d02b50:	6068      	str	r0, [r5, #4]
c0d02b52:	4838      	ldr	r0, [pc, #224]	; (c0d02c34 <ui_public_key_1+0xfc>)
c0d02b54:	4478      	add	r0, pc
c0d02b56:	6128      	str	r0, [r5, #16]
c0d02b58:	2600      	movs	r6, #0
c0d02b5a:	60ee      	str	r6, [r5, #12]
c0d02b5c:	2003      	movs	r0, #3
c0d02b5e:	7628      	strb	r0, [r5, #24]
c0d02b60:	61ee      	str	r6, [r5, #28]
c0d02b62:	4628      	mov	r0, r5
c0d02b64:	3018      	adds	r0, #24
		// TODO: add screen for the blue.
		UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
c0d02b66:	f7ff fa27 	bl	c0d01fb8 <os_ux>
c0d02b6a:	61e8      	str	r0, [r5, #28]
c0d02b6c:	f7fe fed4 	bl	c0d01918 <ux_check_status_default>
c0d02b70:	f7fe fc14 	bl	c0d0139c <io_seproxyhal_init_ux>
c0d02b74:	60ae      	str	r6, [r5, #8]
c0d02b76:	6829      	ldr	r1, [r5, #0]
c0d02b78:	69e8      	ldr	r0, [r5, #28]
}

/** show the public key screen */
void ui_public_key_1(void) {
	uiState = UI_PUBLIC_KEY_1;
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d02b7a:	2201      	movs	r2, #1
c0d02b7c:	0212      	lsls	r2, r2, #8
c0d02b7e:	4214      	tst	r4, r2
c0d02b80:	d128      	bne.n	c0d02bd4 <ui_public_key_1+0x9c>
		// TODO: add screen for the blue.
		UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
	} else {
		UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
c0d02b82:	2900      	cmp	r1, #0
c0d02b84:	d04c      	beq.n	c0d02c20 <ui_public_key_1+0xe8>
c0d02b86:	4929      	ldr	r1, [pc, #164]	; (c0d02c2c <ui_public_key_1+0xf4>)
c0d02b88:	4288      	cmp	r0, r1
c0d02b8a:	d049      	beq.n	c0d02c20 <ui_public_key_1+0xe8>
c0d02b8c:	2800      	cmp	r0, #0
c0d02b8e:	d047      	beq.n	c0d02c20 <ui_public_key_1+0xe8>
c0d02b90:	2000      	movs	r0, #0
c0d02b92:	6869      	ldr	r1, [r5, #4]
c0d02b94:	4288      	cmp	r0, r1
c0d02b96:	d243      	bcs.n	c0d02c20 <ui_public_key_1+0xe8>
c0d02b98:	f7ff fa50 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d02b9c:	2800      	cmp	r0, #0
c0d02b9e:	d13f      	bne.n	c0d02c20 <ui_public_key_1+0xe8>
c0d02ba0:	68a8      	ldr	r0, [r5, #8]
c0d02ba2:	68e9      	ldr	r1, [r5, #12]
c0d02ba4:	2438      	movs	r4, #56	; 0x38
c0d02ba6:	4360      	muls	r0, r4
c0d02ba8:	682a      	ldr	r2, [r5, #0]
c0d02baa:	1810      	adds	r0, r2, r0
c0d02bac:	2900      	cmp	r1, #0
c0d02bae:	d002      	beq.n	c0d02bb6 <ui_public_key_1+0x7e>
c0d02bb0:	4788      	blx	r1
c0d02bb2:	2800      	cmp	r0, #0
c0d02bb4:	d007      	beq.n	c0d02bc6 <ui_public_key_1+0x8e>
c0d02bb6:	2801      	cmp	r0, #1
c0d02bb8:	d103      	bne.n	c0d02bc2 <ui_public_key_1+0x8a>
c0d02bba:	68a8      	ldr	r0, [r5, #8]
c0d02bbc:	4344      	muls	r4, r0
c0d02bbe:	6828      	ldr	r0, [r5, #0]
c0d02bc0:	1900      	adds	r0, r0, r4
c0d02bc2:	f7fd fb27 	bl	c0d00214 <io_seproxyhal_display>
c0d02bc6:	68a8      	ldr	r0, [r5, #8]
c0d02bc8:	1c40      	adds	r0, r0, #1
c0d02bca:	60a8      	str	r0, [r5, #8]
c0d02bcc:	6829      	ldr	r1, [r5, #0]
c0d02bce:	2900      	cmp	r1, #0
c0d02bd0:	d1df      	bne.n	c0d02b92 <ui_public_key_1+0x5a>
c0d02bd2:	e025      	b.n	c0d02c20 <ui_public_key_1+0xe8>
/** show the public key screen */
void ui_public_key_1(void) {
	uiState = UI_PUBLIC_KEY_1;
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
		// TODO: add screen for the blue.
		UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
c0d02bd4:	2900      	cmp	r1, #0
c0d02bd6:	d023      	beq.n	c0d02c20 <ui_public_key_1+0xe8>
c0d02bd8:	4914      	ldr	r1, [pc, #80]	; (c0d02c2c <ui_public_key_1+0xf4>)
c0d02bda:	4288      	cmp	r0, r1
c0d02bdc:	d11e      	bne.n	c0d02c1c <ui_public_key_1+0xe4>
c0d02bde:	e01f      	b.n	c0d02c20 <ui_public_key_1+0xe8>
c0d02be0:	6868      	ldr	r0, [r5, #4]
c0d02be2:	4286      	cmp	r6, r0
c0d02be4:	d21c      	bcs.n	c0d02c20 <ui_public_key_1+0xe8>
c0d02be6:	f7ff fa29 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d02bea:	2800      	cmp	r0, #0
c0d02bec:	d118      	bne.n	c0d02c20 <ui_public_key_1+0xe8>
c0d02bee:	68a8      	ldr	r0, [r5, #8]
c0d02bf0:	68e9      	ldr	r1, [r5, #12]
c0d02bf2:	2438      	movs	r4, #56	; 0x38
c0d02bf4:	4360      	muls	r0, r4
c0d02bf6:	682a      	ldr	r2, [r5, #0]
c0d02bf8:	1810      	adds	r0, r2, r0
c0d02bfa:	2900      	cmp	r1, #0
c0d02bfc:	d002      	beq.n	c0d02c04 <ui_public_key_1+0xcc>
c0d02bfe:	4788      	blx	r1
c0d02c00:	2800      	cmp	r0, #0
c0d02c02:	d007      	beq.n	c0d02c14 <ui_public_key_1+0xdc>
c0d02c04:	2801      	cmp	r0, #1
c0d02c06:	d103      	bne.n	c0d02c10 <ui_public_key_1+0xd8>
c0d02c08:	68a8      	ldr	r0, [r5, #8]
c0d02c0a:	4344      	muls	r4, r0
c0d02c0c:	6828      	ldr	r0, [r5, #0]
c0d02c0e:	1900      	adds	r0, r0, r4
c0d02c10:	f7fd fb00 	bl	c0d00214 <io_seproxyhal_display>
c0d02c14:	68a8      	ldr	r0, [r5, #8]
c0d02c16:	1c46      	adds	r6, r0, #1
c0d02c18:	60ae      	str	r6, [r5, #8]
c0d02c1a:	6828      	ldr	r0, [r5, #0]
c0d02c1c:	2800      	cmp	r0, #0
c0d02c1e:	d1df      	bne.n	c0d02be0 <ui_public_key_1+0xa8>
	} else {
		UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
	}
}
c0d02c20:	bd70      	pop	{r4, r5, r6, pc}
c0d02c22:	46c0      	nop			; (mov r8, r8)
c0d02c24:	20001f68 	.word	0x20001f68
c0d02c28:	20001f6c 	.word	0x20001f6c
c0d02c2c:	b0105044 	.word	0xb0105044
c0d02c30:	00001a12 	.word	0x00001a12
c0d02c34:	000000e1 	.word	0x000000e1

c0d02c38 <bagl_ui_public_key_nanos_1_button>:
/**
 * buttons for the idle screen
 *
 * exit on Left button, or on Both buttons. Do nothing on Right button only.
 */
static unsigned int bagl_ui_public_key_nanos_1_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d02c38:	b5b0      	push	{r4, r5, r7, lr}
	switch (button_mask) {
c0d02c3a:	494a      	ldr	r1, [pc, #296]	; (c0d02d64 <bagl_ui_public_key_nanos_1_button+0x12c>)
c0d02c3c:	4288      	cmp	r0, r1
c0d02c3e:	d006      	beq.n	c0d02c4e <bagl_ui_public_key_nanos_1_button+0x16>
c0d02c40:	4949      	ldr	r1, [pc, #292]	; (c0d02d68 <bagl_ui_public_key_nanos_1_button+0x130>)
c0d02c42:	4288      	cmp	r0, r1
c0d02c44:	d101      	bne.n	c0d02c4a <bagl_ui_public_key_nanos_1_button+0x12>
	case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
		ui_idle();
c0d02c46:	f7ff fe01 	bl	c0d0284c <ui_idle>
		ui_public_key_2();
		break;
	}


	return 0;
c0d02c4a:	2000      	movs	r0, #0
c0d02c4c:	bdb0      	pop	{r4, r5, r7, pc}
	}
}

/** show the public key screen */
void ui_public_key_2(void) {
	uiState = UI_PUBLIC_KEY_2;
c0d02c4e:	4847      	ldr	r0, [pc, #284]	; (c0d02d6c <bagl_ui_public_key_nanos_1_button+0x134>)
c0d02c50:	2108      	movs	r1, #8
c0d02c52:	7001      	strb	r1, [r0, #0]
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d02c54:	2001      	movs	r0, #1
c0d02c56:	0204      	lsls	r4, r0, #8
c0d02c58:	f7ff f9c4 	bl	c0d01fe4 <os_seph_features>
c0d02c5c:	4220      	tst	r0, r4
c0d02c5e:	d140      	bne.n	c0d02ce2 <bagl_ui_public_key_nanos_1_button+0xaa>
		// TODO: add screen for the blue.
		UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
	} else {
		UX_DISPLAY(bagl_ui_public_key_nanos_2, NULL);
c0d02c60:	4c43      	ldr	r4, [pc, #268]	; (c0d02d70 <bagl_ui_public_key_nanos_1_button+0x138>)
c0d02c62:	4847      	ldr	r0, [pc, #284]	; (c0d02d80 <bagl_ui_public_key_nanos_1_button+0x148>)
c0d02c64:	4478      	add	r0, pc
c0d02c66:	6020      	str	r0, [r4, #0]
c0d02c68:	2005      	movs	r0, #5
c0d02c6a:	6060      	str	r0, [r4, #4]
c0d02c6c:	4845      	ldr	r0, [pc, #276]	; (c0d02d84 <bagl_ui_public_key_nanos_1_button+0x14c>)
c0d02c6e:	4478      	add	r0, pc
c0d02c70:	6120      	str	r0, [r4, #16]
c0d02c72:	2500      	movs	r5, #0
c0d02c74:	60e5      	str	r5, [r4, #12]
c0d02c76:	2003      	movs	r0, #3
c0d02c78:	7620      	strb	r0, [r4, #24]
c0d02c7a:	61e5      	str	r5, [r4, #28]
c0d02c7c:	4620      	mov	r0, r4
c0d02c7e:	3018      	adds	r0, #24
c0d02c80:	f7ff f99a 	bl	c0d01fb8 <os_ux>
c0d02c84:	61e0      	str	r0, [r4, #28]
c0d02c86:	f7fe fe47 	bl	c0d01918 <ux_check_status_default>
c0d02c8a:	f7fe fb87 	bl	c0d0139c <io_seproxyhal_init_ux>
c0d02c8e:	60a5      	str	r5, [r4, #8]
c0d02c90:	6820      	ldr	r0, [r4, #0]
c0d02c92:	2800      	cmp	r0, #0
c0d02c94:	d0d9      	beq.n	c0d02c4a <bagl_ui_public_key_nanos_1_button+0x12>
c0d02c96:	69e0      	ldr	r0, [r4, #28]
c0d02c98:	4936      	ldr	r1, [pc, #216]	; (c0d02d74 <bagl_ui_public_key_nanos_1_button+0x13c>)
c0d02c9a:	4288      	cmp	r0, r1
c0d02c9c:	d11e      	bne.n	c0d02cdc <bagl_ui_public_key_nanos_1_button+0xa4>
c0d02c9e:	e7d4      	b.n	c0d02c4a <bagl_ui_public_key_nanos_1_button+0x12>
c0d02ca0:	6860      	ldr	r0, [r4, #4]
c0d02ca2:	4285      	cmp	r5, r0
c0d02ca4:	d2d1      	bcs.n	c0d02c4a <bagl_ui_public_key_nanos_1_button+0x12>
c0d02ca6:	f7ff f9c9 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d02caa:	2800      	cmp	r0, #0
c0d02cac:	d1cd      	bne.n	c0d02c4a <bagl_ui_public_key_nanos_1_button+0x12>
c0d02cae:	68a0      	ldr	r0, [r4, #8]
c0d02cb0:	68e1      	ldr	r1, [r4, #12]
c0d02cb2:	2538      	movs	r5, #56	; 0x38
c0d02cb4:	4368      	muls	r0, r5
c0d02cb6:	6822      	ldr	r2, [r4, #0]
c0d02cb8:	1810      	adds	r0, r2, r0
c0d02cba:	2900      	cmp	r1, #0
c0d02cbc:	d002      	beq.n	c0d02cc4 <bagl_ui_public_key_nanos_1_button+0x8c>
c0d02cbe:	4788      	blx	r1
c0d02cc0:	2800      	cmp	r0, #0
c0d02cc2:	d007      	beq.n	c0d02cd4 <bagl_ui_public_key_nanos_1_button+0x9c>
c0d02cc4:	2801      	cmp	r0, #1
c0d02cc6:	d103      	bne.n	c0d02cd0 <bagl_ui_public_key_nanos_1_button+0x98>
c0d02cc8:	68a0      	ldr	r0, [r4, #8]
c0d02cca:	4345      	muls	r5, r0
c0d02ccc:	6820      	ldr	r0, [r4, #0]
c0d02cce:	1940      	adds	r0, r0, r5
c0d02cd0:	f7fd faa0 	bl	c0d00214 <io_seproxyhal_display>
c0d02cd4:	68a0      	ldr	r0, [r4, #8]
c0d02cd6:	1c45      	adds	r5, r0, #1
c0d02cd8:	60a5      	str	r5, [r4, #8]
c0d02cda:	6820      	ldr	r0, [r4, #0]
c0d02cdc:	2800      	cmp	r0, #0
c0d02cde:	d1df      	bne.n	c0d02ca0 <bagl_ui_public_key_nanos_1_button+0x68>
c0d02ce0:	e7b3      	b.n	c0d02c4a <bagl_ui_public_key_nanos_1_button+0x12>
/** show the public key screen */
void ui_public_key_2(void) {
	uiState = UI_PUBLIC_KEY_2;
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
		// TODO: add screen for the blue.
		UX_DISPLAY(bagl_ui_public_key_nanos_1, NULL);
c0d02ce2:	4c23      	ldr	r4, [pc, #140]	; (c0d02d70 <bagl_ui_public_key_nanos_1_button+0x138>)
c0d02ce4:	4824      	ldr	r0, [pc, #144]	; (c0d02d78 <bagl_ui_public_key_nanos_1_button+0x140>)
c0d02ce6:	4478      	add	r0, pc
c0d02ce8:	6020      	str	r0, [r4, #0]
c0d02cea:	2005      	movs	r0, #5
c0d02cec:	6060      	str	r0, [r4, #4]
c0d02cee:	4823      	ldr	r0, [pc, #140]	; (c0d02d7c <bagl_ui_public_key_nanos_1_button+0x144>)
c0d02cf0:	4478      	add	r0, pc
c0d02cf2:	6120      	str	r0, [r4, #16]
c0d02cf4:	2500      	movs	r5, #0
c0d02cf6:	60e5      	str	r5, [r4, #12]
c0d02cf8:	2003      	movs	r0, #3
c0d02cfa:	7620      	strb	r0, [r4, #24]
c0d02cfc:	61e5      	str	r5, [r4, #28]
c0d02cfe:	4620      	mov	r0, r4
c0d02d00:	3018      	adds	r0, #24
c0d02d02:	f7ff f959 	bl	c0d01fb8 <os_ux>
c0d02d06:	61e0      	str	r0, [r4, #28]
c0d02d08:	f7fe fe06 	bl	c0d01918 <ux_check_status_default>
c0d02d0c:	f7fe fb46 	bl	c0d0139c <io_seproxyhal_init_ux>
c0d02d10:	60a5      	str	r5, [r4, #8]
c0d02d12:	6820      	ldr	r0, [r4, #0]
c0d02d14:	2800      	cmp	r0, #0
c0d02d16:	d098      	beq.n	c0d02c4a <bagl_ui_public_key_nanos_1_button+0x12>
c0d02d18:	69e0      	ldr	r0, [r4, #28]
c0d02d1a:	4916      	ldr	r1, [pc, #88]	; (c0d02d74 <bagl_ui_public_key_nanos_1_button+0x13c>)
c0d02d1c:	4288      	cmp	r0, r1
c0d02d1e:	d11e      	bne.n	c0d02d5e <bagl_ui_public_key_nanos_1_button+0x126>
c0d02d20:	e793      	b.n	c0d02c4a <bagl_ui_public_key_nanos_1_button+0x12>
c0d02d22:	6860      	ldr	r0, [r4, #4]
c0d02d24:	4285      	cmp	r5, r0
c0d02d26:	d290      	bcs.n	c0d02c4a <bagl_ui_public_key_nanos_1_button+0x12>
c0d02d28:	f7ff f988 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d02d2c:	2800      	cmp	r0, #0
c0d02d2e:	d18c      	bne.n	c0d02c4a <bagl_ui_public_key_nanos_1_button+0x12>
c0d02d30:	68a0      	ldr	r0, [r4, #8]
c0d02d32:	68e1      	ldr	r1, [r4, #12]
c0d02d34:	2538      	movs	r5, #56	; 0x38
c0d02d36:	4368      	muls	r0, r5
c0d02d38:	6822      	ldr	r2, [r4, #0]
c0d02d3a:	1810      	adds	r0, r2, r0
c0d02d3c:	2900      	cmp	r1, #0
c0d02d3e:	d002      	beq.n	c0d02d46 <bagl_ui_public_key_nanos_1_button+0x10e>
c0d02d40:	4788      	blx	r1
c0d02d42:	2800      	cmp	r0, #0
c0d02d44:	d007      	beq.n	c0d02d56 <bagl_ui_public_key_nanos_1_button+0x11e>
c0d02d46:	2801      	cmp	r0, #1
c0d02d48:	d103      	bne.n	c0d02d52 <bagl_ui_public_key_nanos_1_button+0x11a>
c0d02d4a:	68a0      	ldr	r0, [r4, #8]
c0d02d4c:	4345      	muls	r5, r0
c0d02d4e:	6820      	ldr	r0, [r4, #0]
c0d02d50:	1940      	adds	r0, r0, r5
c0d02d52:	f7fd fa5f 	bl	c0d00214 <io_seproxyhal_display>
c0d02d56:	68a0      	ldr	r0, [r4, #8]
c0d02d58:	1c45      	adds	r5, r0, #1
c0d02d5a:	60a5      	str	r5, [r4, #8]
c0d02d5c:	6820      	ldr	r0, [r4, #0]
c0d02d5e:	2800      	cmp	r0, #0
c0d02d60:	d1df      	bne.n	c0d02d22 <bagl_ui_public_key_nanos_1_button+0xea>
c0d02d62:	e772      	b.n	c0d02c4a <bagl_ui_public_key_nanos_1_button+0x12>
c0d02d64:	80000001 	.word	0x80000001
c0d02d68:	80000002 	.word	0x80000002
c0d02d6c:	20001f68 	.word	0x20001f68
c0d02d70:	20001f6c 	.word	0x20001f6c
c0d02d74:	b0105044 	.word	0xb0105044
c0d02d78:	00001876 	.word	0x00001876
c0d02d7c:	ffffff45 	.word	0xffffff45
c0d02d80:	00001a10 	.word	0x00001a10
c0d02d84:	00000117 	.word	0x00000117

c0d02d88 <bagl_ui_public_key_nanos_2_button>:
/**
 * buttons for the idle screen
 *
 * exit on Left button, or on Both buttons. Do nothing on Right button only.
 */
static unsigned int bagl_ui_public_key_nanos_2_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d02d88:	b580      	push	{r7, lr}
	switch (button_mask) {
c0d02d8a:	4906      	ldr	r1, [pc, #24]	; (c0d02da4 <bagl_ui_public_key_nanos_2_button+0x1c>)
c0d02d8c:	4288      	cmp	r0, r1
c0d02d8e:	d005      	beq.n	c0d02d9c <bagl_ui_public_key_nanos_2_button+0x14>
c0d02d90:	4905      	ldr	r1, [pc, #20]	; (c0d02da8 <bagl_ui_public_key_nanos_2_button+0x20>)
c0d02d92:	4288      	cmp	r0, r1
c0d02d94:	d104      	bne.n	c0d02da0 <bagl_ui_public_key_nanos_2_button+0x18>
	case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
		ui_idle();
c0d02d96:	f7ff fd59 	bl	c0d0284c <ui_idle>
c0d02d9a:	e001      	b.n	c0d02da0 <bagl_ui_public_key_nanos_2_button+0x18>
		break;
	case BUTTON_EVT_RELEASED | BUTTON_LEFT:
		ui_public_key_1();
c0d02d9c:	f7ff fecc 	bl	c0d02b38 <ui_public_key_1>
		break;
	}
	return 0;
c0d02da0:	2000      	movs	r0, #0
c0d02da2:	bd80      	pop	{r7, pc}
c0d02da4:	80000001 	.word	0x80000001
c0d02da8:	80000002 	.word	0x80000002

c0d02dac <tx_desc_up>:
	curr_tx_desc[1][MAX_TX_TEXT_WIDTH - 1] = '\0';
	curr_tx_desc[2][MAX_TX_TEXT_WIDTH - 1] = '\0';
}

/** processes the Up button */
static const bagl_element_t * tx_desc_up(const bagl_element_t *e) {
c0d02dac:	b5b0      	push	{r4, r5, r7, lr}
	switch (uiState) {
c0d02dae:	484d      	ldr	r0, [pc, #308]	; (c0d02ee4 <tx_desc_up+0x138>)
c0d02db0:	7801      	ldrb	r1, [r0, #0]
c0d02db2:	2906      	cmp	r1, #6
c0d02db4:	d006      	beq.n	c0d02dc4 <tx_desc_up+0x18>
c0d02db6:	2902      	cmp	r1, #2
c0d02db8:	d000      	beq.n	c0d02dbc <tx_desc_up+0x10>
c0d02dba:	e08c      	b.n	c0d02ed6 <tx_desc_up+0x12a>
	case UI_TOP_SIGN:
		ui_deny();
c0d02dbc:	f000 f8c0 	bl	c0d02f40 <ui_deny>
	default:
		hashTainted = 1;
		THROW(0x6D02);
		break;
	}
	return NULL;
c0d02dc0:	2000      	movs	r0, #0
c0d02dc2:	bdb0      	pop	{r4, r5, r7, pc}
	}
}

/** show the bottom "Sign Transaction" screen. */
static void ui_sign(void) {
	uiState = UI_SIGN;
c0d02dc4:	2505      	movs	r5, #5
c0d02dc6:	7005      	strb	r5, [r0, #0]
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d02dc8:	2001      	movs	r0, #1
c0d02dca:	0204      	lsls	r4, r0, #8
c0d02dcc:	f7ff f90a 	bl	c0d01fe4 <os_seph_features>
c0d02dd0:	4220      	tst	r0, r4
c0d02dd2:	d13f      	bne.n	c0d02e54 <tx_desc_up+0xa8>
		UX_DISPLAY(bagl_ui_sign_blue, NULL);
	} else {
		UX_DISPLAY(bagl_ui_sign_nanos, NULL);
c0d02dd4:	4c44      	ldr	r4, [pc, #272]	; (c0d02ee8 <tx_desc_up+0x13c>)
c0d02dd6:	484a      	ldr	r0, [pc, #296]	; (c0d02f00 <tx_desc_up+0x154>)
c0d02dd8:	4478      	add	r0, pc
c0d02dda:	c421      	stmia	r4!, {r0, r5}
c0d02ddc:	4849      	ldr	r0, [pc, #292]	; (c0d02f04 <tx_desc_up+0x158>)
c0d02dde:	4478      	add	r0, pc
c0d02de0:	60a0      	str	r0, [r4, #8]
c0d02de2:	2500      	movs	r5, #0
c0d02de4:	6065      	str	r5, [r4, #4]
c0d02de6:	2003      	movs	r0, #3
c0d02de8:	7420      	strb	r0, [r4, #16]
c0d02dea:	6165      	str	r5, [r4, #20]
c0d02dec:	3c08      	subs	r4, #8
c0d02dee:	4620      	mov	r0, r4
c0d02df0:	3018      	adds	r0, #24
c0d02df2:	f7ff f8e1 	bl	c0d01fb8 <os_ux>
c0d02df6:	61e0      	str	r0, [r4, #28]
c0d02df8:	f7fe fd8e 	bl	c0d01918 <ux_check_status_default>
c0d02dfc:	f7fe face 	bl	c0d0139c <io_seproxyhal_init_ux>
c0d02e00:	60a5      	str	r5, [r4, #8]
c0d02e02:	6820      	ldr	r0, [r4, #0]
c0d02e04:	2800      	cmp	r0, #0
c0d02e06:	d0db      	beq.n	c0d02dc0 <tx_desc_up+0x14>
c0d02e08:	69e0      	ldr	r0, [r4, #28]
c0d02e0a:	4938      	ldr	r1, [pc, #224]	; (c0d02eec <tx_desc_up+0x140>)
c0d02e0c:	4288      	cmp	r0, r1
c0d02e0e:	d11e      	bne.n	c0d02e4e <tx_desc_up+0xa2>
c0d02e10:	e7d6      	b.n	c0d02dc0 <tx_desc_up+0x14>
c0d02e12:	6860      	ldr	r0, [r4, #4]
c0d02e14:	4285      	cmp	r5, r0
c0d02e16:	d2d3      	bcs.n	c0d02dc0 <tx_desc_up+0x14>
c0d02e18:	f7ff f910 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d02e1c:	2800      	cmp	r0, #0
c0d02e1e:	d1cf      	bne.n	c0d02dc0 <tx_desc_up+0x14>
c0d02e20:	68a0      	ldr	r0, [r4, #8]
c0d02e22:	68e1      	ldr	r1, [r4, #12]
c0d02e24:	2538      	movs	r5, #56	; 0x38
c0d02e26:	4368      	muls	r0, r5
c0d02e28:	6822      	ldr	r2, [r4, #0]
c0d02e2a:	1810      	adds	r0, r2, r0
c0d02e2c:	2900      	cmp	r1, #0
c0d02e2e:	d002      	beq.n	c0d02e36 <tx_desc_up+0x8a>
c0d02e30:	4788      	blx	r1
c0d02e32:	2800      	cmp	r0, #0
c0d02e34:	d007      	beq.n	c0d02e46 <tx_desc_up+0x9a>
c0d02e36:	2801      	cmp	r0, #1
c0d02e38:	d103      	bne.n	c0d02e42 <tx_desc_up+0x96>
c0d02e3a:	68a0      	ldr	r0, [r4, #8]
c0d02e3c:	4345      	muls	r5, r0
c0d02e3e:	6820      	ldr	r0, [r4, #0]
c0d02e40:	1940      	adds	r0, r0, r5
c0d02e42:	f7fd f9e7 	bl	c0d00214 <io_seproxyhal_display>
c0d02e46:	68a0      	ldr	r0, [r4, #8]
c0d02e48:	1c45      	adds	r5, r0, #1
c0d02e4a:	60a5      	str	r5, [r4, #8]
c0d02e4c:	6820      	ldr	r0, [r4, #0]
c0d02e4e:	2800      	cmp	r0, #0
c0d02e50:	d1df      	bne.n	c0d02e12 <tx_desc_up+0x66>
c0d02e52:	e7b5      	b.n	c0d02dc0 <tx_desc_up+0x14>

/** show the bottom "Sign Transaction" screen. */
static void ui_sign(void) {
	uiState = UI_SIGN;
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
		UX_DISPLAY(bagl_ui_sign_blue, NULL);
c0d02e54:	4c24      	ldr	r4, [pc, #144]	; (c0d02ee8 <tx_desc_up+0x13c>)
c0d02e56:	4828      	ldr	r0, [pc, #160]	; (c0d02ef8 <tx_desc_up+0x14c>)
c0d02e58:	4478      	add	r0, pc
c0d02e5a:	6020      	str	r0, [r4, #0]
c0d02e5c:	2007      	movs	r0, #7
c0d02e5e:	6060      	str	r0, [r4, #4]
c0d02e60:	4826      	ldr	r0, [pc, #152]	; (c0d02efc <tx_desc_up+0x150>)
c0d02e62:	4478      	add	r0, pc
c0d02e64:	6120      	str	r0, [r4, #16]
c0d02e66:	2500      	movs	r5, #0
c0d02e68:	60e5      	str	r5, [r4, #12]
c0d02e6a:	2003      	movs	r0, #3
c0d02e6c:	7620      	strb	r0, [r4, #24]
c0d02e6e:	61e5      	str	r5, [r4, #28]
c0d02e70:	4620      	mov	r0, r4
c0d02e72:	3018      	adds	r0, #24
c0d02e74:	f7ff f8a0 	bl	c0d01fb8 <os_ux>
c0d02e78:	61e0      	str	r0, [r4, #28]
c0d02e7a:	f7fe fd4d 	bl	c0d01918 <ux_check_status_default>
c0d02e7e:	f7fe fa8d 	bl	c0d0139c <io_seproxyhal_init_ux>
c0d02e82:	60a5      	str	r5, [r4, #8]
c0d02e84:	6820      	ldr	r0, [r4, #0]
c0d02e86:	2800      	cmp	r0, #0
c0d02e88:	d09a      	beq.n	c0d02dc0 <tx_desc_up+0x14>
c0d02e8a:	69e0      	ldr	r0, [r4, #28]
c0d02e8c:	4917      	ldr	r1, [pc, #92]	; (c0d02eec <tx_desc_up+0x140>)
c0d02e8e:	4288      	cmp	r0, r1
c0d02e90:	d11e      	bne.n	c0d02ed0 <tx_desc_up+0x124>
c0d02e92:	e795      	b.n	c0d02dc0 <tx_desc_up+0x14>
c0d02e94:	6860      	ldr	r0, [r4, #4]
c0d02e96:	4285      	cmp	r5, r0
c0d02e98:	d292      	bcs.n	c0d02dc0 <tx_desc_up+0x14>
c0d02e9a:	f7ff f8cf 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d02e9e:	2800      	cmp	r0, #0
c0d02ea0:	d18e      	bne.n	c0d02dc0 <tx_desc_up+0x14>
c0d02ea2:	68a0      	ldr	r0, [r4, #8]
c0d02ea4:	68e1      	ldr	r1, [r4, #12]
c0d02ea6:	2538      	movs	r5, #56	; 0x38
c0d02ea8:	4368      	muls	r0, r5
c0d02eaa:	6822      	ldr	r2, [r4, #0]
c0d02eac:	1810      	adds	r0, r2, r0
c0d02eae:	2900      	cmp	r1, #0
c0d02eb0:	d002      	beq.n	c0d02eb8 <tx_desc_up+0x10c>
c0d02eb2:	4788      	blx	r1
c0d02eb4:	2800      	cmp	r0, #0
c0d02eb6:	d007      	beq.n	c0d02ec8 <tx_desc_up+0x11c>
c0d02eb8:	2801      	cmp	r0, #1
c0d02eba:	d103      	bne.n	c0d02ec4 <tx_desc_up+0x118>
c0d02ebc:	68a0      	ldr	r0, [r4, #8]
c0d02ebe:	4345      	muls	r5, r0
c0d02ec0:	6820      	ldr	r0, [r4, #0]
c0d02ec2:	1940      	adds	r0, r0, r5
c0d02ec4:	f7fd f9a6 	bl	c0d00214 <io_seproxyhal_display>
c0d02ec8:	68a0      	ldr	r0, [r4, #8]
c0d02eca:	1c45      	adds	r5, r0, #1
c0d02ecc:	60a5      	str	r5, [r4, #8]
c0d02ece:	6820      	ldr	r0, [r4, #0]
c0d02ed0:	2800      	cmp	r0, #0
c0d02ed2:	d1df      	bne.n	c0d02e94 <tx_desc_up+0xe8>
c0d02ed4:	e774      	b.n	c0d02dc0 <tx_desc_up+0x14>
	case UI_DENY:
		ui_sign();
		break;

	default:
		hashTainted = 1;
c0d02ed6:	4806      	ldr	r0, [pc, #24]	; (c0d02ef0 <tx_desc_up+0x144>)
c0d02ed8:	2101      	movs	r1, #1
c0d02eda:	7001      	strb	r1, [r0, #0]
		THROW(0x6D02);
c0d02edc:	4805      	ldr	r0, [pc, #20]	; (c0d02ef4 <tx_desc_up+0x148>)
c0d02ede:	f7fe f8fc 	bl	c0d010da <os_longjmp>
c0d02ee2:	46c0      	nop			; (mov r8, r8)
c0d02ee4:	20001f68 	.word	0x20001f68
c0d02ee8:	20001f6c 	.word	0x20001f6c
c0d02eec:	b0105044 	.word	0xb0105044
c0d02ef0:	20001f60 	.word	0x20001f60
c0d02ef4:	00006d02 	.word	0x00006d02
c0d02ef8:	00001d94 	.word	0x00001d94
c0d02efc:	000002bb 	.word	0x000002bb
c0d02f00:	00001f9c 	.word	0x00001f9c
c0d02f04:	00000343 	.word	0x00000343

c0d02f08 <tx_desc_dn>:
	}
	return NULL;
}

/** processes the Down button */
static const bagl_element_t * tx_desc_dn(const bagl_element_t *e) {
c0d02f08:	b580      	push	{r7, lr}
	switch (uiState) {
c0d02f0a:	480a      	ldr	r0, [pc, #40]	; (c0d02f34 <tx_desc_dn+0x2c>)
c0d02f0c:	7800      	ldrb	r0, [r0, #0]
c0d02f0e:	2806      	cmp	r0, #6
c0d02f10:	d006      	beq.n	c0d02f20 <tx_desc_dn+0x18>
c0d02f12:	2805      	cmp	r0, #5
c0d02f14:	d001      	beq.n	c0d02f1a <tx_desc_dn+0x12>
c0d02f16:	2802      	cmp	r0, #2
c0d02f18:	d106      	bne.n	c0d02f28 <tx_desc_dn+0x20>
c0d02f1a:	f000 f811 	bl	c0d02f40 <ui_deny>
c0d02f1e:	e001      	b.n	c0d02f24 <tx_desc_dn+0x1c>
	case UI_SIGN:
		ui_deny();
		break;

	case UI_DENY:
		ui_top_sign();
c0d02f20:	f7ff fd44 	bl	c0d029ac <ui_top_sign>
	default:
		hashTainted = 1;
		THROW(0x6D01);
		break;
	}
	return NULL;
c0d02f24:	2000      	movs	r0, #0
c0d02f26:	bd80      	pop	{r7, pc}
	case UI_DENY:
		ui_top_sign();
		break;

	default:
		hashTainted = 1;
c0d02f28:	4803      	ldr	r0, [pc, #12]	; (c0d02f38 <tx_desc_dn+0x30>)
c0d02f2a:	2101      	movs	r1, #1
c0d02f2c:	7001      	strb	r1, [r0, #0]
		THROW(0x6D01);
c0d02f2e:	4803      	ldr	r0, [pc, #12]	; (c0d02f3c <tx_desc_dn+0x34>)
c0d02f30:	f7fe f8d3 	bl	c0d010da <os_longjmp>
c0d02f34:	20001f68 	.word	0x20001f68
c0d02f38:	20001f60 	.word	0x20001f60
c0d02f3c:	00006d01 	.word	0x00006d01

c0d02f40 <ui_deny>:
		UX_DISPLAY(bagl_ui_top_sign_nanos, NULL);
	}
}

/** show the "deny" screen */
static void ui_deny(void) {
c0d02f40:	b5b0      	push	{r4, r5, r7, lr}
	uiState = UI_DENY;
c0d02f42:	4845      	ldr	r0, [pc, #276]	; (c0d03058 <ui_deny+0x118>)
c0d02f44:	2506      	movs	r5, #6
c0d02f46:	7005      	strb	r5, [r0, #0]
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
c0d02f48:	2001      	movs	r0, #1
c0d02f4a:	0204      	lsls	r4, r0, #8
c0d02f4c:	f7ff f84a 	bl	c0d01fe4 <os_seph_features>
c0d02f50:	4220      	tst	r0, r4
c0d02f52:	d13f      	bne.n	c0d02fd4 <ui_deny+0x94>
		UX_DISPLAY(bagl_ui_deny_blue, NULL);
	} else {
		UX_DISPLAY(bagl_ui_deny_nanos, NULL);
c0d02f54:	4c41      	ldr	r4, [pc, #260]	; (c0d0305c <ui_deny+0x11c>)
c0d02f56:	4845      	ldr	r0, [pc, #276]	; (c0d0306c <ui_deny+0x12c>)
c0d02f58:	4478      	add	r0, pc
c0d02f5a:	c421      	stmia	r4!, {r0, r5}
c0d02f5c:	4844      	ldr	r0, [pc, #272]	; (c0d03070 <ui_deny+0x130>)
c0d02f5e:	4478      	add	r0, pc
c0d02f60:	60a0      	str	r0, [r4, #8]
c0d02f62:	2500      	movs	r5, #0
c0d02f64:	6065      	str	r5, [r4, #4]
c0d02f66:	2003      	movs	r0, #3
c0d02f68:	7420      	strb	r0, [r4, #16]
c0d02f6a:	6165      	str	r5, [r4, #20]
c0d02f6c:	3c08      	subs	r4, #8
c0d02f6e:	4620      	mov	r0, r4
c0d02f70:	3018      	adds	r0, #24
c0d02f72:	f7ff f821 	bl	c0d01fb8 <os_ux>
c0d02f76:	61e0      	str	r0, [r4, #28]
c0d02f78:	f7fe fcce 	bl	c0d01918 <ux_check_status_default>
c0d02f7c:	f7fe fa0e 	bl	c0d0139c <io_seproxyhal_init_ux>
c0d02f80:	60a5      	str	r5, [r4, #8]
c0d02f82:	6820      	ldr	r0, [r4, #0]
c0d02f84:	2800      	cmp	r0, #0
c0d02f86:	d065      	beq.n	c0d03054 <ui_deny+0x114>
c0d02f88:	69e0      	ldr	r0, [r4, #28]
c0d02f8a:	4935      	ldr	r1, [pc, #212]	; (c0d03060 <ui_deny+0x120>)
c0d02f8c:	4288      	cmp	r0, r1
c0d02f8e:	d11e      	bne.n	c0d02fce <ui_deny+0x8e>
c0d02f90:	e060      	b.n	c0d03054 <ui_deny+0x114>
c0d02f92:	6860      	ldr	r0, [r4, #4]
c0d02f94:	4285      	cmp	r5, r0
c0d02f96:	d25d      	bcs.n	c0d03054 <ui_deny+0x114>
c0d02f98:	f7ff f850 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d02f9c:	2800      	cmp	r0, #0
c0d02f9e:	d159      	bne.n	c0d03054 <ui_deny+0x114>
c0d02fa0:	68a0      	ldr	r0, [r4, #8]
c0d02fa2:	68e1      	ldr	r1, [r4, #12]
c0d02fa4:	2538      	movs	r5, #56	; 0x38
c0d02fa6:	4368      	muls	r0, r5
c0d02fa8:	6822      	ldr	r2, [r4, #0]
c0d02faa:	1810      	adds	r0, r2, r0
c0d02fac:	2900      	cmp	r1, #0
c0d02fae:	d002      	beq.n	c0d02fb6 <ui_deny+0x76>
c0d02fb0:	4788      	blx	r1
c0d02fb2:	2800      	cmp	r0, #0
c0d02fb4:	d007      	beq.n	c0d02fc6 <ui_deny+0x86>
c0d02fb6:	2801      	cmp	r0, #1
c0d02fb8:	d103      	bne.n	c0d02fc2 <ui_deny+0x82>
c0d02fba:	68a0      	ldr	r0, [r4, #8]
c0d02fbc:	4345      	muls	r5, r0
c0d02fbe:	6820      	ldr	r0, [r4, #0]
c0d02fc0:	1940      	adds	r0, r0, r5
c0d02fc2:	f7fd f927 	bl	c0d00214 <io_seproxyhal_display>
c0d02fc6:	68a0      	ldr	r0, [r4, #8]
c0d02fc8:	1c45      	adds	r5, r0, #1
c0d02fca:	60a5      	str	r5, [r4, #8]
c0d02fcc:	6820      	ldr	r0, [r4, #0]
c0d02fce:	2800      	cmp	r0, #0
c0d02fd0:	d1df      	bne.n	c0d02f92 <ui_deny+0x52>
c0d02fd2:	e03f      	b.n	c0d03054 <ui_deny+0x114>

/** show the "deny" screen */
static void ui_deny(void) {
	uiState = UI_DENY;
	if (os_seph_features() & SEPROXYHAL_TAG_SESSION_START_EVENT_FEATURE_SCREEN_BIG) {
		UX_DISPLAY(bagl_ui_deny_blue, NULL);
c0d02fd4:	4c21      	ldr	r4, [pc, #132]	; (c0d0305c <ui_deny+0x11c>)
c0d02fd6:	4823      	ldr	r0, [pc, #140]	; (c0d03064 <ui_deny+0x124>)
c0d02fd8:	4478      	add	r0, pc
c0d02fda:	6020      	str	r0, [r4, #0]
c0d02fdc:	2007      	movs	r0, #7
c0d02fde:	6060      	str	r0, [r4, #4]
c0d02fe0:	4821      	ldr	r0, [pc, #132]	; (c0d03068 <ui_deny+0x128>)
c0d02fe2:	4478      	add	r0, pc
c0d02fe4:	6120      	str	r0, [r4, #16]
c0d02fe6:	2500      	movs	r5, #0
c0d02fe8:	60e5      	str	r5, [r4, #12]
c0d02fea:	2003      	movs	r0, #3
c0d02fec:	7620      	strb	r0, [r4, #24]
c0d02fee:	61e5      	str	r5, [r4, #28]
c0d02ff0:	4620      	mov	r0, r4
c0d02ff2:	3018      	adds	r0, #24
c0d02ff4:	f7fe ffe0 	bl	c0d01fb8 <os_ux>
c0d02ff8:	61e0      	str	r0, [r4, #28]
c0d02ffa:	f7fe fc8d 	bl	c0d01918 <ux_check_status_default>
c0d02ffe:	f7fe f9cd 	bl	c0d0139c <io_seproxyhal_init_ux>
c0d03002:	60a5      	str	r5, [r4, #8]
c0d03004:	6820      	ldr	r0, [r4, #0]
c0d03006:	2800      	cmp	r0, #0
c0d03008:	d024      	beq.n	c0d03054 <ui_deny+0x114>
c0d0300a:	69e0      	ldr	r0, [r4, #28]
c0d0300c:	4914      	ldr	r1, [pc, #80]	; (c0d03060 <ui_deny+0x120>)
c0d0300e:	4288      	cmp	r0, r1
c0d03010:	d11e      	bne.n	c0d03050 <ui_deny+0x110>
c0d03012:	e01f      	b.n	c0d03054 <ui_deny+0x114>
c0d03014:	6860      	ldr	r0, [r4, #4]
c0d03016:	4285      	cmp	r5, r0
c0d03018:	d21c      	bcs.n	c0d03054 <ui_deny+0x114>
c0d0301a:	f7ff f80f 	bl	c0d0203c <io_seproxyhal_spi_is_status_sent>
c0d0301e:	2800      	cmp	r0, #0
c0d03020:	d118      	bne.n	c0d03054 <ui_deny+0x114>
c0d03022:	68a0      	ldr	r0, [r4, #8]
c0d03024:	68e1      	ldr	r1, [r4, #12]
c0d03026:	2538      	movs	r5, #56	; 0x38
c0d03028:	4368      	muls	r0, r5
c0d0302a:	6822      	ldr	r2, [r4, #0]
c0d0302c:	1810      	adds	r0, r2, r0
c0d0302e:	2900      	cmp	r1, #0
c0d03030:	d002      	beq.n	c0d03038 <ui_deny+0xf8>
c0d03032:	4788      	blx	r1
c0d03034:	2800      	cmp	r0, #0
c0d03036:	d007      	beq.n	c0d03048 <ui_deny+0x108>
c0d03038:	2801      	cmp	r0, #1
c0d0303a:	d103      	bne.n	c0d03044 <ui_deny+0x104>
c0d0303c:	68a0      	ldr	r0, [r4, #8]
c0d0303e:	4345      	muls	r5, r0
c0d03040:	6820      	ldr	r0, [r4, #0]
c0d03042:	1940      	adds	r0, r0, r5
c0d03044:	f7fd f8e6 	bl	c0d00214 <io_seproxyhal_display>
c0d03048:	68a0      	ldr	r0, [r4, #8]
c0d0304a:	1c45      	adds	r5, r0, #1
c0d0304c:	60a5      	str	r5, [r4, #8]
c0d0304e:	6820      	ldr	r0, [r4, #0]
c0d03050:	2800      	cmp	r0, #0
c0d03052:	d1df      	bne.n	c0d03014 <ui_deny+0xd4>
	} else {
		UX_DISPLAY(bagl_ui_deny_nanos, NULL);
	}
}
c0d03054:	bdb0      	pop	{r4, r5, r7, pc}
c0d03056:	46c0      	nop			; (mov r8, r8)
c0d03058:	20001f68 	.word	0x20001f68
c0d0305c:	20001f6c 	.word	0x20001f6c
c0d03060:	b0105044 	.word	0xb0105044
c0d03064:	0000193c 	.word	0x0000193c
c0d03068:	0000008f 	.word	0x0000008f
c0d0306c:	00001b44 	.word	0x00001b44
c0d03070:	00000117 	.word	0x00000117

c0d03074 <bagl_ui_deny_blue_button>:
static unsigned int bagl_ui_top_sign_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
	return 0;
}

static unsigned int bagl_ui_deny_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
	return 0;
c0d03074:	2000      	movs	r0, #0
c0d03076:	4770      	bx	lr

c0d03078 <bagl_ui_deny_nanos_button>:
/**
 * buttons for the bottom "Deny Transaction" screen
 *
 * up on Left button, down on right button, deny on both buttons.
 */
static unsigned int bagl_ui_deny_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d03078:	b580      	push	{r7, lr}
	switch (button_mask) {
c0d0307a:	4913      	ldr	r1, [pc, #76]	; (c0d030c8 <bagl_ui_deny_nanos_button+0x50>)
c0d0307c:	4288      	cmp	r0, r1
c0d0307e:	d019      	beq.n	c0d030b4 <bagl_ui_deny_nanos_button+0x3c>
c0d03080:	4912      	ldr	r1, [pc, #72]	; (c0d030cc <bagl_ui_deny_nanos_button+0x54>)
c0d03082:	4288      	cmp	r0, r1
c0d03084:	d01a      	beq.n	c0d030bc <bagl_ui_deny_nanos_button+0x44>
c0d03086:	4912      	ldr	r1, [pc, #72]	; (c0d030d0 <bagl_ui_deny_nanos_button+0x58>)
c0d03088:	4288      	cmp	r0, r1
c0d0308a:	d11a      	bne.n	c0d030c2 <bagl_ui_deny_nanos_button+0x4a>
	return 0; // do not redraw the widget
}

/** deny signing. */
static const bagl_element_t *io_seproxyhal_touch_deny(const bagl_element_t *e) {
	hashTainted = 1;
c0d0308c:	4811      	ldr	r0, [pc, #68]	; (c0d030d4 <bagl_ui_deny_nanos_button+0x5c>)
c0d0308e:	2101      	movs	r1, #1
c0d03090:	7001      	strb	r1, [r0, #0]
	raw_tx_ix = 0;
c0d03092:	4811      	ldr	r0, [pc, #68]	; (c0d030d8 <bagl_ui_deny_nanos_button+0x60>)
c0d03094:	2100      	movs	r1, #0
c0d03096:	6001      	str	r1, [r0, #0]
	raw_tx_len = 0;
c0d03098:	4810      	ldr	r0, [pc, #64]	; (c0d030dc <bagl_ui_deny_nanos_button+0x64>)
c0d0309a:	6001      	str	r1, [r0, #0]
	G_io_apdu_buffer[0] = 0x69;
c0d0309c:	4810      	ldr	r0, [pc, #64]	; (c0d030e0 <bagl_ui_deny_nanos_button+0x68>)
c0d0309e:	2169      	movs	r1, #105	; 0x69
c0d030a0:	7001      	strb	r1, [r0, #0]
	G_io_apdu_buffer[1] = 0x85;
c0d030a2:	2185      	movs	r1, #133	; 0x85
c0d030a4:	7041      	strb	r1, [r0, #1]
	// Send back the response, do not restart the event loop
	io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
c0d030a6:	2020      	movs	r0, #32
c0d030a8:	2102      	movs	r1, #2
c0d030aa:	f7fe fb39 	bl	c0d01720 <io_exchange>
	// Display back the original UX
	ui_idle();
c0d030ae:	f7ff fbcd 	bl	c0d0284c <ui_idle>
c0d030b2:	e006      	b.n	c0d030c2 <bagl_ui_deny_nanos_button+0x4a>
	case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
		tx_desc_dn(NULL);
		break;

	case BUTTON_EVT_RELEASED | BUTTON_LEFT:
		tx_desc_up(NULL);
c0d030b4:	2000      	movs	r0, #0
c0d030b6:	f7ff fe79 	bl	c0d02dac <tx_desc_up>
c0d030ba:	e002      	b.n	c0d030c2 <bagl_ui_deny_nanos_button+0x4a>
	case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT:
		io_seproxyhal_touch_deny(NULL);
		break;

	case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
		tx_desc_dn(NULL);
c0d030bc:	2000      	movs	r0, #0
c0d030be:	f7ff ff23 	bl	c0d02f08 <tx_desc_dn>

	case BUTTON_EVT_RELEASED | BUTTON_LEFT:
		tx_desc_up(NULL);
		break;
	}
	return 0;
c0d030c2:	2000      	movs	r0, #0
c0d030c4:	bd80      	pop	{r7, pc}
c0d030c6:	46c0      	nop			; (mov r8, r8)
c0d030c8:	80000001 	.word	0x80000001
c0d030cc:	80000002 	.word	0x80000002
c0d030d0:	80000003 	.word	0x80000003
c0d030d4:	20001f60 	.word	0x20001f60
c0d030d8:	20001f64 	.word	0x20001f64
c0d030dc:	20001af0 	.word	0x20001af0
c0d030e0:	200018f8 	.word	0x200018f8

c0d030e4 <io_seproxyhal_touch_deny>:
	ui_idle();
	return 0; // do not redraw the widget
}

/** deny signing. */
static const bagl_element_t *io_seproxyhal_touch_deny(const bagl_element_t *e) {
c0d030e4:	b510      	push	{r4, lr}
	hashTainted = 1;
c0d030e6:	480a      	ldr	r0, [pc, #40]	; (c0d03110 <io_seproxyhal_touch_deny+0x2c>)
c0d030e8:	2101      	movs	r1, #1
c0d030ea:	7001      	strb	r1, [r0, #0]
	raw_tx_ix = 0;
c0d030ec:	4809      	ldr	r0, [pc, #36]	; (c0d03114 <io_seproxyhal_touch_deny+0x30>)
c0d030ee:	2400      	movs	r4, #0
c0d030f0:	6004      	str	r4, [r0, #0]
	raw_tx_len = 0;
c0d030f2:	4809      	ldr	r0, [pc, #36]	; (c0d03118 <io_seproxyhal_touch_deny+0x34>)
c0d030f4:	6004      	str	r4, [r0, #0]
	G_io_apdu_buffer[0] = 0x69;
c0d030f6:	4809      	ldr	r0, [pc, #36]	; (c0d0311c <io_seproxyhal_touch_deny+0x38>)
c0d030f8:	2169      	movs	r1, #105	; 0x69
c0d030fa:	7001      	strb	r1, [r0, #0]
	G_io_apdu_buffer[1] = 0x85;
c0d030fc:	2185      	movs	r1, #133	; 0x85
c0d030fe:	7041      	strb	r1, [r0, #1]
	// Send back the response, do not restart the event loop
	io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
c0d03100:	2020      	movs	r0, #32
c0d03102:	2102      	movs	r1, #2
c0d03104:	f7fe fb0c 	bl	c0d01720 <io_exchange>
	// Display back the original UX
	ui_idle();
c0d03108:	f7ff fba0 	bl	c0d0284c <ui_idle>
	return 0; // do not redraw the widget
c0d0310c:	4620      	mov	r0, r4
c0d0310e:	bd10      	pop	{r4, pc}
c0d03110:	20001f60 	.word	0x20001f60
c0d03114:	20001f64 	.word	0x20001f64
c0d03118:	20001af0 	.word	0x20001af0
c0d0311c:	200018f8 	.word	0x200018f8

c0d03120 <bagl_ui_sign_blue_button>:
static unsigned int bagl_ui_tx_desc_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
	return 0;
}

static unsigned int bagl_ui_sign_blue_button(unsigned int button_mask, unsigned int button_mask_counter) {
	return 0;
c0d03120:	2000      	movs	r0, #0
c0d03122:	4770      	bx	lr

c0d03124 <bagl_ui_sign_nanos_button>:
/**
 * buttons for the bottom "Sign Transaction" screen
 *
 * up on Left button, down on right button, sign on both buttons.
 */
static unsigned int bagl_ui_sign_nanos_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d03124:	b580      	push	{r7, lr}
	switch (button_mask) {
c0d03126:	490a      	ldr	r1, [pc, #40]	; (c0d03150 <bagl_ui_sign_nanos_button+0x2c>)
c0d03128:	4288      	cmp	r0, r1
c0d0312a:	d008      	beq.n	c0d0313e <bagl_ui_sign_nanos_button+0x1a>
c0d0312c:	4909      	ldr	r1, [pc, #36]	; (c0d03154 <bagl_ui_sign_nanos_button+0x30>)
c0d0312e:	4288      	cmp	r0, r1
c0d03130:	d009      	beq.n	c0d03146 <bagl_ui_sign_nanos_button+0x22>
c0d03132:	4909      	ldr	r1, [pc, #36]	; (c0d03158 <bagl_ui_sign_nanos_button+0x34>)
c0d03134:	4288      	cmp	r0, r1
c0d03136:	d109      	bne.n	c0d0314c <bagl_ui_sign_nanos_button+0x28>
	case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT:
		io_seproxyhal_touch_approve(NULL);
c0d03138:	f7ff fb04 	bl	c0d02744 <io_seproxyhal_touch_approve>
c0d0313c:	e006      	b.n	c0d0314c <bagl_ui_sign_nanos_button+0x28>
	case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
		tx_desc_dn(NULL);
		break;

	case BUTTON_EVT_RELEASED | BUTTON_LEFT:
		tx_desc_up(NULL);
c0d0313e:	2000      	movs	r0, #0
c0d03140:	f7ff fe34 	bl	c0d02dac <tx_desc_up>
c0d03144:	e002      	b.n	c0d0314c <bagl_ui_sign_nanos_button+0x28>
	case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT:
		io_seproxyhal_touch_approve(NULL);
		break;

	case BUTTON_EVT_RELEASED | BUTTON_RIGHT:
		tx_desc_dn(NULL);
c0d03146:	2000      	movs	r0, #0
c0d03148:	f7ff fede 	bl	c0d02f08 <tx_desc_dn>

	case BUTTON_EVT_RELEASED | BUTTON_LEFT:
		tx_desc_up(NULL);
		break;
	}
	return 0;
c0d0314c:	2000      	movs	r0, #0
c0d0314e:	bd80      	pop	{r7, pc}
c0d03150:	80000001 	.word	0x80000001
c0d03154:	80000002 	.word	0x80000002
c0d03158:	80000003 	.word	0x80000003

c0d0315c <USBD_LL_Init>:
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Init (USBD_HandleTypeDef *pdev)
{ 
  UNUSED(pdev);
  ep_in_stall = 0;
c0d0315c:	4902      	ldr	r1, [pc, #8]	; (c0d03168 <USBD_LL_Init+0xc>)
c0d0315e:	2000      	movs	r0, #0
c0d03160:	6008      	str	r0, [r1, #0]
  ep_out_stall = 0;
c0d03162:	4902      	ldr	r1, [pc, #8]	; (c0d0316c <USBD_LL_Init+0x10>)
c0d03164:	6008      	str	r0, [r1, #0]
  return USBD_OK;
c0d03166:	4770      	bx	lr
c0d03168:	20002068 	.word	0x20002068
c0d0316c:	2000206c 	.word	0x2000206c

c0d03170 <USBD_LL_DeInit>:
  * @brief  De-Initializes the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_DeInit (USBD_HandleTypeDef *pdev)
{
c0d03170:	b510      	push	{r4, lr}
  UNUSED(pdev);
  // usb off
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03172:	4807      	ldr	r0, [pc, #28]	; (c0d03190 <USBD_LL_DeInit+0x20>)
c0d03174:	214f      	movs	r1, #79	; 0x4f
c0d03176:	7001      	strb	r1, [r0, #0]
c0d03178:	2400      	movs	r4, #0
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d0317a:	7044      	strb	r4, [r0, #1]
c0d0317c:	2101      	movs	r1, #1
  G_io_seproxyhal_spi_buffer[2] = 1;
c0d0317e:	7081      	strb	r1, [r0, #2]
c0d03180:	2102      	movs	r1, #2
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d03182:	70c1      	strb	r1, [r0, #3]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 4);
c0d03184:	2104      	movs	r1, #4
c0d03186:	f7fe ff43 	bl	c0d02010 <io_seproxyhal_spi_send>

  return USBD_OK; 
c0d0318a:	4620      	mov	r0, r4
c0d0318c:	bd10      	pop	{r4, pc}
c0d0318e:	46c0      	nop			; (mov r8, r8)
c0d03190:	20001800 	.word	0x20001800

c0d03194 <USBD_LL_Start>:
  * @brief  Starts the Low Level portion of the Device driver. 
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Start(USBD_HandleTypeDef *pdev)
{
c0d03194:	b570      	push	{r4, r5, r6, lr}
c0d03196:	b082      	sub	sp, #8
c0d03198:	466d      	mov	r5, sp
  uint8_t buffer[5];
  UNUSED(pdev);

  // reset address
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d0319a:	264f      	movs	r6, #79	; 0x4f
c0d0319c:	702e      	strb	r6, [r5, #0]
c0d0319e:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d031a0:	706c      	strb	r4, [r5, #1]
c0d031a2:	2002      	movs	r0, #2
  buffer[2] = 2;
c0d031a4:	70a8      	strb	r0, [r5, #2]
c0d031a6:	2003      	movs	r0, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d031a8:	70e8      	strb	r0, [r5, #3]
  buffer[4] = 0;
c0d031aa:	712c      	strb	r4, [r5, #4]
  io_seproxyhal_spi_send(buffer, 5);
c0d031ac:	2105      	movs	r1, #5
c0d031ae:	4628      	mov	r0, r5
c0d031b0:	f7fe ff2e 	bl	c0d02010 <io_seproxyhal_spi_send>
  
  // start usb operation
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d031b4:	702e      	strb	r6, [r5, #0]
  buffer[1] = 0;
c0d031b6:	706c      	strb	r4, [r5, #1]
c0d031b8:	2001      	movs	r0, #1
  buffer[2] = 1;
c0d031ba:	70a8      	strb	r0, [r5, #2]
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_CONNECT;
c0d031bc:	70e8      	strb	r0, [r5, #3]
c0d031be:	2104      	movs	r1, #4
  io_seproxyhal_spi_send(buffer, 4);
c0d031c0:	4628      	mov	r0, r5
c0d031c2:	f7fe ff25 	bl	c0d02010 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d031c6:	4620      	mov	r0, r4
c0d031c8:	b002      	add	sp, #8
c0d031ca:	bd70      	pop	{r4, r5, r6, pc}

c0d031cc <USBD_LL_Stop>:
  * @brief  Stops the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Stop (USBD_HandleTypeDef *pdev)
{
c0d031cc:	b510      	push	{r4, lr}
c0d031ce:	b082      	sub	sp, #8
c0d031d0:	a801      	add	r0, sp, #4
  UNUSED(pdev);
  uint8_t buffer[4];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d031d2:	214f      	movs	r1, #79	; 0x4f
c0d031d4:	7001      	strb	r1, [r0, #0]
c0d031d6:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d031d8:	7044      	strb	r4, [r0, #1]
c0d031da:	2101      	movs	r1, #1
  buffer[2] = 1;
c0d031dc:	7081      	strb	r1, [r0, #2]
c0d031de:	2102      	movs	r1, #2
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d031e0:	70c1      	strb	r1, [r0, #3]
  io_seproxyhal_spi_send(buffer, 4);
c0d031e2:	2104      	movs	r1, #4
c0d031e4:	f7fe ff14 	bl	c0d02010 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d031e8:	4620      	mov	r0, r4
c0d031ea:	b002      	add	sp, #8
c0d031ec:	bd10      	pop	{r4, pc}
	...

c0d031f0 <USBD_LL_OpenEP>:
  */
USBD_StatusTypeDef  USBD_LL_OpenEP  (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  ep_type,
                                      uint16_t ep_mps)
{
c0d031f0:	b5b0      	push	{r4, r5, r7, lr}
c0d031f2:	b082      	sub	sp, #8
  uint8_t buffer[8];
  UNUSED(pdev);

  ep_in_stall = 0;
c0d031f4:	480e      	ldr	r0, [pc, #56]	; (c0d03230 <USBD_LL_OpenEP+0x40>)
c0d031f6:	2400      	movs	r4, #0
c0d031f8:	6004      	str	r4, [r0, #0]
  ep_out_stall = 0;
c0d031fa:	480e      	ldr	r0, [pc, #56]	; (c0d03234 <USBD_LL_OpenEP+0x44>)
c0d031fc:	6004      	str	r4, [r0, #0]
c0d031fe:	4668      	mov	r0, sp

  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03200:	254f      	movs	r5, #79	; 0x4f
c0d03202:	7005      	strb	r5, [r0, #0]
  buffer[1] = 0;
c0d03204:	7044      	strb	r4, [r0, #1]
c0d03206:	2505      	movs	r5, #5
  buffer[2] = 5;
c0d03208:	7085      	strb	r5, [r0, #2]
c0d0320a:	2504      	movs	r5, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d0320c:	70c5      	strb	r5, [r0, #3]
c0d0320e:	2501      	movs	r5, #1
  buffer[4] = 1;
c0d03210:	7105      	strb	r5, [r0, #4]
  buffer[5] = ep_addr;
c0d03212:	7141      	strb	r1, [r0, #5]
  buffer[6] = 0;
  switch(ep_type) {
c0d03214:	2a03      	cmp	r2, #3
c0d03216:	d802      	bhi.n	c0d0321e <USBD_LL_OpenEP+0x2e>
c0d03218:	00d0      	lsls	r0, r2, #3
c0d0321a:	4c07      	ldr	r4, [pc, #28]	; (c0d03238 <USBD_LL_OpenEP+0x48>)
c0d0321c:	40c4      	lsrs	r4, r0
c0d0321e:	4668      	mov	r0, sp
  buffer[1] = 0;
  buffer[2] = 5;
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
  buffer[4] = 1;
  buffer[5] = ep_addr;
  buffer[6] = 0;
c0d03220:	7184      	strb	r4, [r0, #6]
      break;
    case USBD_EP_TYPE_INTR:
      buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_INTERRUPT;
      break;
  }
  buffer[7] = ep_mps;
c0d03222:	71c3      	strb	r3, [r0, #7]
  io_seproxyhal_spi_send(buffer, 8);
c0d03224:	2108      	movs	r1, #8
c0d03226:	f7fe fef3 	bl	c0d02010 <io_seproxyhal_spi_send>
c0d0322a:	2000      	movs	r0, #0
  return USBD_OK; 
c0d0322c:	b002      	add	sp, #8
c0d0322e:	bdb0      	pop	{r4, r5, r7, pc}
c0d03230:	20002068 	.word	0x20002068
c0d03234:	2000206c 	.word	0x2000206c
c0d03238:	02030401 	.word	0x02030401

c0d0323c <USBD_LL_CloseEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_CloseEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d0323c:	b510      	push	{r4, lr}
c0d0323e:	b082      	sub	sp, #8
c0d03240:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[8];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03242:	224f      	movs	r2, #79	; 0x4f
c0d03244:	7002      	strb	r2, [r0, #0]
c0d03246:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03248:	7044      	strb	r4, [r0, #1]
c0d0324a:	2205      	movs	r2, #5
  buffer[2] = 5;
c0d0324c:	7082      	strb	r2, [r0, #2]
c0d0324e:	2204      	movs	r2, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d03250:	70c2      	strb	r2, [r0, #3]
c0d03252:	2201      	movs	r2, #1
  buffer[4] = 1;
c0d03254:	7102      	strb	r2, [r0, #4]
  buffer[5] = ep_addr;
c0d03256:	7141      	strb	r1, [r0, #5]
  buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_DISABLED;
c0d03258:	7184      	strb	r4, [r0, #6]
  buffer[7] = 0;
c0d0325a:	71c4      	strb	r4, [r0, #7]
  io_seproxyhal_spi_send(buffer, 8);
c0d0325c:	2108      	movs	r1, #8
c0d0325e:	f7fe fed7 	bl	c0d02010 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d03262:	4620      	mov	r0, r4
c0d03264:	b002      	add	sp, #8
c0d03266:	bd10      	pop	{r4, pc}

c0d03268 <USBD_LL_StallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_StallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{ 
c0d03268:	b5b0      	push	{r4, r5, r7, lr}
c0d0326a:	b082      	sub	sp, #8
c0d0326c:	460d      	mov	r5, r1
c0d0326e:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d03270:	2150      	movs	r1, #80	; 0x50
c0d03272:	7001      	strb	r1, [r0, #0]
c0d03274:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03276:	7044      	strb	r4, [r0, #1]
c0d03278:	2103      	movs	r1, #3
  buffer[2] = 3;
c0d0327a:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d0327c:	70c5      	strb	r5, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_STALL;
c0d0327e:	2140      	movs	r1, #64	; 0x40
c0d03280:	7101      	strb	r1, [r0, #4]
  buffer[5] = 0;
c0d03282:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03284:	2106      	movs	r1, #6
c0d03286:	f7fe fec3 	bl	c0d02010 <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d0328a:	2080      	movs	r0, #128	; 0x80
c0d0328c:	4205      	tst	r5, r0
c0d0328e:	d101      	bne.n	c0d03294 <USBD_LL_StallEP+0x2c>
c0d03290:	4807      	ldr	r0, [pc, #28]	; (c0d032b0 <USBD_LL_StallEP+0x48>)
c0d03292:	e000      	b.n	c0d03296 <USBD_LL_StallEP+0x2e>
c0d03294:	4805      	ldr	r0, [pc, #20]	; (c0d032ac <USBD_LL_StallEP+0x44>)
c0d03296:	6801      	ldr	r1, [r0, #0]
c0d03298:	227f      	movs	r2, #127	; 0x7f
c0d0329a:	4015      	ands	r5, r2
c0d0329c:	2201      	movs	r2, #1
c0d0329e:	40aa      	lsls	r2, r5
c0d032a0:	430a      	orrs	r2, r1
c0d032a2:	6002      	str	r2, [r0, #0]
    ep_in_stall |= (1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall |= (1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d032a4:	4620      	mov	r0, r4
c0d032a6:	b002      	add	sp, #8
c0d032a8:	bdb0      	pop	{r4, r5, r7, pc}
c0d032aa:	46c0      	nop			; (mov r8, r8)
c0d032ac:	20002068 	.word	0x20002068
c0d032b0:	2000206c 	.word	0x2000206c

c0d032b4 <USBD_LL_ClearStallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_ClearStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d032b4:	b570      	push	{r4, r5, r6, lr}
c0d032b6:	b082      	sub	sp, #8
c0d032b8:	460d      	mov	r5, r1
c0d032ba:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d032bc:	2150      	movs	r1, #80	; 0x50
c0d032be:	7001      	strb	r1, [r0, #0]
c0d032c0:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d032c2:	7044      	strb	r4, [r0, #1]
c0d032c4:	2103      	movs	r1, #3
  buffer[2] = 3;
c0d032c6:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d032c8:	70c5      	strb	r5, [r0, #3]
c0d032ca:	2680      	movs	r6, #128	; 0x80
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_UNSTALL;
c0d032cc:	7106      	strb	r6, [r0, #4]
  buffer[5] = 0;
c0d032ce:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d032d0:	2106      	movs	r1, #6
c0d032d2:	f7fe fe9d 	bl	c0d02010 <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d032d6:	4235      	tst	r5, r6
c0d032d8:	d101      	bne.n	c0d032de <USBD_LL_ClearStallEP+0x2a>
c0d032da:	4807      	ldr	r0, [pc, #28]	; (c0d032f8 <USBD_LL_ClearStallEP+0x44>)
c0d032dc:	e000      	b.n	c0d032e0 <USBD_LL_ClearStallEP+0x2c>
c0d032de:	4805      	ldr	r0, [pc, #20]	; (c0d032f4 <USBD_LL_ClearStallEP+0x40>)
c0d032e0:	6801      	ldr	r1, [r0, #0]
c0d032e2:	227f      	movs	r2, #127	; 0x7f
c0d032e4:	4015      	ands	r5, r2
c0d032e6:	2201      	movs	r2, #1
c0d032e8:	40aa      	lsls	r2, r5
c0d032ea:	4391      	bics	r1, r2
c0d032ec:	6001      	str	r1, [r0, #0]
    ep_in_stall &= ~(1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall &= ~(1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d032ee:	4620      	mov	r0, r4
c0d032f0:	b002      	add	sp, #8
c0d032f2:	bd70      	pop	{r4, r5, r6, pc}
c0d032f4:	20002068 	.word	0x20002068
c0d032f8:	2000206c 	.word	0x2000206c

c0d032fc <USBD_LL_IsStallEP>:
  * @retval Stall (1: Yes, 0: No)
  */
uint8_t USBD_LL_IsStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  UNUSED(pdev);
  if((ep_addr & 0x80) == 0x80)
c0d032fc:	2080      	movs	r0, #128	; 0x80
c0d032fe:	4201      	tst	r1, r0
c0d03300:	d001      	beq.n	c0d03306 <USBD_LL_IsStallEP+0xa>
c0d03302:	4806      	ldr	r0, [pc, #24]	; (c0d0331c <USBD_LL_IsStallEP+0x20>)
c0d03304:	e000      	b.n	c0d03308 <USBD_LL_IsStallEP+0xc>
c0d03306:	4804      	ldr	r0, [pc, #16]	; (c0d03318 <USBD_LL_IsStallEP+0x1c>)
c0d03308:	6800      	ldr	r0, [r0, #0]
c0d0330a:	227f      	movs	r2, #127	; 0x7f
c0d0330c:	4011      	ands	r1, r2
c0d0330e:	2201      	movs	r2, #1
c0d03310:	408a      	lsls	r2, r1
c0d03312:	4002      	ands	r2, r0
  }
  else
  {
    return ep_out_stall & (1<<(ep_addr&0x7F));
  }
}
c0d03314:	b2d0      	uxtb	r0, r2
c0d03316:	4770      	bx	lr
c0d03318:	2000206c 	.word	0x2000206c
c0d0331c:	20002068 	.word	0x20002068

c0d03320 <USBD_LL_SetUSBAddress>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_SetUSBAddress (USBD_HandleTypeDef *pdev, uint8_t dev_addr)   
{
c0d03320:	b510      	push	{r4, lr}
c0d03322:	b082      	sub	sp, #8
c0d03324:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[5];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03326:	224f      	movs	r2, #79	; 0x4f
c0d03328:	7002      	strb	r2, [r0, #0]
c0d0332a:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d0332c:	7044      	strb	r4, [r0, #1]
c0d0332e:	2202      	movs	r2, #2
  buffer[2] = 2;
c0d03330:	7082      	strb	r2, [r0, #2]
c0d03332:	2203      	movs	r2, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d03334:	70c2      	strb	r2, [r0, #3]
  buffer[4] = dev_addr;
c0d03336:	7101      	strb	r1, [r0, #4]
  io_seproxyhal_spi_send(buffer, 5);
c0d03338:	2105      	movs	r1, #5
c0d0333a:	f7fe fe69 	bl	c0d02010 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d0333e:	4620      	mov	r0, r4
c0d03340:	b002      	add	sp, #8
c0d03342:	bd10      	pop	{r4, pc}

c0d03344 <USBD_LL_Transmit>:
  */
USBD_StatusTypeDef  USBD_LL_Transmit (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  *pbuf,
                                      uint16_t  size)
{
c0d03344:	b5b0      	push	{r4, r5, r7, lr}
c0d03346:	b082      	sub	sp, #8
c0d03348:	461c      	mov	r4, r3
c0d0334a:	4615      	mov	r5, r2
c0d0334c:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d0334e:	2250      	movs	r2, #80	; 0x50
c0d03350:	7002      	strb	r2, [r0, #0]
  buffer[1] = (3+size)>>8;
c0d03352:	1ce2      	adds	r2, r4, #3
c0d03354:	0a13      	lsrs	r3, r2, #8
c0d03356:	7043      	strb	r3, [r0, #1]
  buffer[2] = (3+size);
c0d03358:	7082      	strb	r2, [r0, #2]
  buffer[3] = ep_addr;
c0d0335a:	70c1      	strb	r1, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d0335c:	2120      	movs	r1, #32
c0d0335e:	7101      	strb	r1, [r0, #4]
  buffer[5] = size;
c0d03360:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03362:	2106      	movs	r1, #6
c0d03364:	f7fe fe54 	bl	c0d02010 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(pbuf, size);
c0d03368:	4628      	mov	r0, r5
c0d0336a:	4621      	mov	r1, r4
c0d0336c:	f7fe fe50 	bl	c0d02010 <io_seproxyhal_spi_send>
c0d03370:	2000      	movs	r0, #0
  return USBD_OK;   
c0d03372:	b002      	add	sp, #8
c0d03374:	bdb0      	pop	{r4, r5, r7, pc}

c0d03376 <USBD_LL_PrepareReceive>:
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_PrepareReceive(USBD_HandleTypeDef *pdev, 
                                           uint8_t  ep_addr,
                                           uint16_t  size)
{
c0d03376:	b510      	push	{r4, lr}
c0d03378:	b082      	sub	sp, #8
c0d0337a:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d0337c:	2350      	movs	r3, #80	; 0x50
c0d0337e:	7003      	strb	r3, [r0, #0]
c0d03380:	2400      	movs	r4, #0
  buffer[1] = (3/*+size*/)>>8;
c0d03382:	7044      	strb	r4, [r0, #1]
c0d03384:	2303      	movs	r3, #3
  buffer[2] = (3/*+size*/);
c0d03386:	7083      	strb	r3, [r0, #2]
  buffer[3] = ep_addr;
c0d03388:	70c1      	strb	r1, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_OUT;
c0d0338a:	2130      	movs	r1, #48	; 0x30
c0d0338c:	7101      	strb	r1, [r0, #4]
  buffer[5] = size; // expected size, not transmitted here !
c0d0338e:	7142      	strb	r2, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03390:	2106      	movs	r1, #6
c0d03392:	f7fe fe3d 	bl	c0d02010 <io_seproxyhal_spi_send>
  return USBD_OK;   
c0d03396:	4620      	mov	r0, r4
c0d03398:	b002      	add	sp, #8
c0d0339a:	bd10      	pop	{r4, pc}

c0d0339c <USBD_Init>:
* @param  pdesc: Descriptor structure address
* @param  id: Low level core index
* @retval None
*/
USBD_StatusTypeDef USBD_Init(USBD_HandleTypeDef *pdev, USBD_DescriptorsTypeDef *pdesc, uint8_t id)
{
c0d0339c:	b570      	push	{r4, r5, r6, lr}
c0d0339e:	4615      	mov	r5, r2
c0d033a0:	460e      	mov	r6, r1
c0d033a2:	4604      	mov	r4, r0
c0d033a4:	2002      	movs	r0, #2
  /* Check whether the USB Host handle is valid */
  if(pdev == NULL)
c0d033a6:	2c00      	cmp	r4, #0
c0d033a8:	d011      	beq.n	c0d033ce <USBD_Init+0x32>
  {
    USBD_ErrLog("Invalid Device handle");
    return USBD_FAIL; 
  }

  memset(pdev, 0, sizeof(USBD_HandleTypeDef));
c0d033aa:	204d      	movs	r0, #77	; 0x4d
c0d033ac:	0081      	lsls	r1, r0, #2
c0d033ae:	4620      	mov	r0, r4
c0d033b0:	f000 fe9e 	bl	c0d040f0 <__aeabi_memclr>
  
  /* Assign USBD Descriptors */
  if(pdesc != NULL)
c0d033b4:	2e00      	cmp	r6, #0
c0d033b6:	d002      	beq.n	c0d033be <USBD_Init+0x22>
  {
    pdev->pDesc = pdesc;
c0d033b8:	2011      	movs	r0, #17
c0d033ba:	0100      	lsls	r0, r0, #4
c0d033bc:	5026      	str	r6, [r4, r0]
  }
  
  /* Set Device initial State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d033be:	20fc      	movs	r0, #252	; 0xfc
c0d033c0:	2101      	movs	r1, #1
c0d033c2:	5421      	strb	r1, [r4, r0]
  pdev->id = id;
c0d033c4:	7025      	strb	r5, [r4, #0]
  /* Initialize low level driver */
  USBD_LL_Init(pdev);
c0d033c6:	4620      	mov	r0, r4
c0d033c8:	f7ff fec8 	bl	c0d0315c <USBD_LL_Init>
c0d033cc:	2000      	movs	r0, #0
  
  return USBD_OK; 
}
c0d033ce:	b2c0      	uxtb	r0, r0
c0d033d0:	bd70      	pop	{r4, r5, r6, pc}

c0d033d2 <USBD_DeInit>:
*         Re-Initialize th device library
* @param  pdev: device instance
* @retval status: status
*/
USBD_StatusTypeDef USBD_DeInit(USBD_HandleTypeDef *pdev)
{
c0d033d2:	b570      	push	{r4, r5, r6, lr}
c0d033d4:	4604      	mov	r4, r0
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d033d6:	20fc      	movs	r0, #252	; 0xfc
c0d033d8:	2101      	movs	r1, #1
c0d033da:	5421      	strb	r1, [r4, r0]
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d033dc:	2045      	movs	r0, #69	; 0x45
c0d033de:	0080      	lsls	r0, r0, #2
c0d033e0:	1825      	adds	r5, r4, r0
c0d033e2:	2600      	movs	r6, #0
    if(pdev->interfacesClass[intf].pClass != NULL) {
c0d033e4:	00f0      	lsls	r0, r6, #3
c0d033e6:	5828      	ldr	r0, [r5, r0]
c0d033e8:	2800      	cmp	r0, #0
c0d033ea:	d006      	beq.n	c0d033fa <USBD_DeInit+0x28>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
c0d033ec:	6840      	ldr	r0, [r0, #4]
c0d033ee:	f7fe fcab 	bl	c0d01d48 <pic>
c0d033f2:	4602      	mov	r2, r0
c0d033f4:	7921      	ldrb	r1, [r4, #4]
c0d033f6:	4620      	mov	r0, r4
c0d033f8:	4790      	blx	r2
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d033fa:	1c76      	adds	r6, r6, #1
c0d033fc:	2e03      	cmp	r6, #3
c0d033fe:	d1f1      	bne.n	c0d033e4 <USBD_DeInit+0x12>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
    }
  }
  
    /* Stop the low level driver  */
  USBD_LL_Stop(pdev); 
c0d03400:	4620      	mov	r0, r4
c0d03402:	f7ff fee3 	bl	c0d031cc <USBD_LL_Stop>
  
  /* Initialize low level driver */
  USBD_LL_DeInit(pdev);
c0d03406:	4620      	mov	r0, r4
c0d03408:	f7ff feb2 	bl	c0d03170 <USBD_LL_DeInit>
  
  return USBD_OK;
c0d0340c:	2000      	movs	r0, #0
c0d0340e:	bd70      	pop	{r4, r5, r6, pc}

c0d03410 <USBD_RegisterClassForInterface>:
  * @param  pDevice : Device Handle
  * @param  pclass: Class handle
  * @retval USBD Status
  */
USBD_StatusTypeDef USBD_RegisterClassForInterface(uint8_t interfaceidx, USBD_HandleTypeDef *pdev, USBD_ClassTypeDef *pclass)
{
c0d03410:	2302      	movs	r3, #2
  USBD_StatusTypeDef   status = USBD_OK;
  if(pclass != 0)
c0d03412:	2a00      	cmp	r2, #0
c0d03414:	d007      	beq.n	c0d03426 <USBD_RegisterClassForInterface+0x16>
c0d03416:	2300      	movs	r3, #0
  {
    if (interfaceidx < USBD_MAX_NUM_INTERFACES) {
c0d03418:	2802      	cmp	r0, #2
c0d0341a:	d804      	bhi.n	c0d03426 <USBD_RegisterClassForInterface+0x16>
      /* link the class to the USB Device handle */
      pdev->interfacesClass[interfaceidx].pClass = pclass;
c0d0341c:	00c0      	lsls	r0, r0, #3
c0d0341e:	1808      	adds	r0, r1, r0
c0d03420:	2145      	movs	r1, #69	; 0x45
c0d03422:	0089      	lsls	r1, r1, #2
c0d03424:	5042      	str	r2, [r0, r1]
  {
    USBD_ErrLog("Invalid Class handle");
    status = USBD_FAIL; 
  }
  
  return status;
c0d03426:	b2d8      	uxtb	r0, r3
c0d03428:	4770      	bx	lr

c0d0342a <USBD_Start>:
  *         Start the USB Device Core.
  * @param  pdev: Device Handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_Start  (USBD_HandleTypeDef *pdev)
{
c0d0342a:	b580      	push	{r7, lr}
  
  /* Start the low level driver  */
  USBD_LL_Start(pdev); 
c0d0342c:	f7ff feb2 	bl	c0d03194 <USBD_LL_Start>
  
  return USBD_OK;  
c0d03430:	2000      	movs	r0, #0
c0d03432:	bd80      	pop	{r7, pc}

c0d03434 <USBD_SetClassConfig>:
* @param  cfgidx: configuration index
* @retval status
*/

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d03434:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03436:	b081      	sub	sp, #4
c0d03438:	460c      	mov	r4, r1
c0d0343a:	4605      	mov	r5, r0
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0343c:	2045      	movs	r0, #69	; 0x45
c0d0343e:	0080      	lsls	r0, r0, #2
c0d03440:	182f      	adds	r7, r5, r0
c0d03442:	2600      	movs	r6, #0
    if(usbd_is_valid_intf(pdev, intf)) {
c0d03444:	4628      	mov	r0, r5
c0d03446:	4631      	mov	r1, r6
c0d03448:	f000 f97c 	bl	c0d03744 <usbd_is_valid_intf>
c0d0344c:	2800      	cmp	r0, #0
c0d0344e:	d008      	beq.n	c0d03462 <USBD_SetClassConfig+0x2e>
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
c0d03450:	00f0      	lsls	r0, r6, #3
c0d03452:	5838      	ldr	r0, [r7, r0]
c0d03454:	6800      	ldr	r0, [r0, #0]
c0d03456:	f7fe fc77 	bl	c0d01d48 <pic>
c0d0345a:	4602      	mov	r2, r0
c0d0345c:	4628      	mov	r0, r5
c0d0345e:	4621      	mov	r1, r4
c0d03460:	4790      	blx	r2

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03462:	1c76      	adds	r6, r6, #1
c0d03464:	2e03      	cmp	r6, #3
c0d03466:	d1ed      	bne.n	c0d03444 <USBD_SetClassConfig+0x10>
    if(usbd_is_valid_intf(pdev, intf)) {
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
    }
  }

  return USBD_OK; 
c0d03468:	2000      	movs	r0, #0
c0d0346a:	b001      	add	sp, #4
c0d0346c:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d0346e <USBD_ClrClassConfig>:
* @param  pdev: device instance
* @param  cfgidx: configuration index
* @retval status: USBD_StatusTypeDef
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d0346e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03470:	b081      	sub	sp, #4
c0d03472:	460c      	mov	r4, r1
c0d03474:	4605      	mov	r5, r0
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03476:	2045      	movs	r0, #69	; 0x45
c0d03478:	0080      	lsls	r0, r0, #2
c0d0347a:	182f      	adds	r7, r5, r0
c0d0347c:	2600      	movs	r6, #0
    if(usbd_is_valid_intf(pdev, intf)) {
c0d0347e:	4628      	mov	r0, r5
c0d03480:	4631      	mov	r1, r6
c0d03482:	f000 f95f 	bl	c0d03744 <usbd_is_valid_intf>
c0d03486:	2800      	cmp	r0, #0
c0d03488:	d008      	beq.n	c0d0349c <USBD_ClrClassConfig+0x2e>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
c0d0348a:	00f0      	lsls	r0, r6, #3
c0d0348c:	5838      	ldr	r0, [r7, r0]
c0d0348e:	6840      	ldr	r0, [r0, #4]
c0d03490:	f7fe fc5a 	bl	c0d01d48 <pic>
c0d03494:	4602      	mov	r2, r0
c0d03496:	4628      	mov	r0, r5
c0d03498:	4621      	mov	r1, r4
c0d0349a:	4790      	blx	r2
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0349c:	1c76      	adds	r6, r6, #1
c0d0349e:	2e03      	cmp	r6, #3
c0d034a0:	d1ed      	bne.n	c0d0347e <USBD_ClrClassConfig+0x10>
    if(usbd_is_valid_intf(pdev, intf)) {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
    }
  }
  return USBD_OK;
c0d034a2:	2000      	movs	r0, #0
c0d034a4:	b001      	add	sp, #4
c0d034a6:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d034a8 <USBD_LL_SetupStage>:
*         Handle the setup stage
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetupStage(USBD_HandleTypeDef *pdev, uint8_t *psetup)
{
c0d034a8:	b570      	push	{r4, r5, r6, lr}
c0d034aa:	4604      	mov	r4, r0
c0d034ac:	2021      	movs	r0, #33	; 0x21
c0d034ae:	00c6      	lsls	r6, r0, #3
  USBD_ParseSetupRequest(&pdev->request, psetup);
c0d034b0:	19a5      	adds	r5, r4, r6
c0d034b2:	4628      	mov	r0, r5
c0d034b4:	f000 fba7 	bl	c0d03c06 <USBD_ParseSetupRequest>
  
  pdev->ep0_state = USBD_EP0_SETUP;
c0d034b8:	20f4      	movs	r0, #244	; 0xf4
c0d034ba:	2101      	movs	r1, #1
c0d034bc:	5021      	str	r1, [r4, r0]
  pdev->ep0_data_len = pdev->request.wLength;
c0d034be:	2087      	movs	r0, #135	; 0x87
c0d034c0:	0040      	lsls	r0, r0, #1
c0d034c2:	5a20      	ldrh	r0, [r4, r0]
c0d034c4:	21f8      	movs	r1, #248	; 0xf8
c0d034c6:	5060      	str	r0, [r4, r1]
  
  switch (pdev->request.bmRequest & 0x1F) 
c0d034c8:	5da1      	ldrb	r1, [r4, r6]
c0d034ca:	201f      	movs	r0, #31
c0d034cc:	4008      	ands	r0, r1
c0d034ce:	2802      	cmp	r0, #2
c0d034d0:	d008      	beq.n	c0d034e4 <USBD_LL_SetupStage+0x3c>
c0d034d2:	2801      	cmp	r0, #1
c0d034d4:	d00b      	beq.n	c0d034ee <USBD_LL_SetupStage+0x46>
c0d034d6:	2800      	cmp	r0, #0
c0d034d8:	d10e      	bne.n	c0d034f8 <USBD_LL_SetupStage+0x50>
  {
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
c0d034da:	4620      	mov	r0, r4
c0d034dc:	4629      	mov	r1, r5
c0d034de:	f000 f93f 	bl	c0d03760 <USBD_StdDevReq>
c0d034e2:	e00e      	b.n	c0d03502 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
c0d034e4:	4620      	mov	r0, r4
c0d034e6:	4629      	mov	r1, r5
c0d034e8:	f000 fb02 	bl	c0d03af0 <USBD_StdEPReq>
c0d034ec:	e009      	b.n	c0d03502 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
c0d034ee:	4620      	mov	r0, r4
c0d034f0:	4629      	mov	r1, r5
c0d034f2:	f000 fad8 	bl	c0d03aa6 <USBD_StdItfReq>
c0d034f6:	e004      	b.n	c0d03502 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
    break;
    
  default:           
    USBD_LL_StallEP(pdev , pdev->request.bmRequest & 0x80);
c0d034f8:	2080      	movs	r0, #128	; 0x80
c0d034fa:	4001      	ands	r1, r0
c0d034fc:	4620      	mov	r0, r4
c0d034fe:	f7ff feb3 	bl	c0d03268 <USBD_LL_StallEP>
    break;
  }  
  return USBD_OK;  
c0d03502:	2000      	movs	r0, #0
c0d03504:	bd70      	pop	{r4, r5, r6, pc}

c0d03506 <USBD_LL_DataOutStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataOutStage(USBD_HandleTypeDef *pdev , uint8_t epnum, uint8_t *pdata)
{
c0d03506:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03508:	b083      	sub	sp, #12
c0d0350a:	9202      	str	r2, [sp, #8]
c0d0350c:	4604      	mov	r4, r0
c0d0350e:	9101      	str	r1, [sp, #4]
  USBD_EndpointTypeDef    *pep;
  
  if(epnum == 0) 
c0d03510:	2900      	cmp	r1, #0
c0d03512:	d01e      	beq.n	c0d03552 <USBD_LL_DataOutStage+0x4c>
    }
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03514:	2045      	movs	r0, #69	; 0x45
c0d03516:	0080      	lsls	r0, r0, #2
c0d03518:	1825      	adds	r5, r4, r0
c0d0351a:	4626      	mov	r6, r4
c0d0351c:	36fc      	adds	r6, #252	; 0xfc
c0d0351e:	2700      	movs	r7, #0
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d03520:	4620      	mov	r0, r4
c0d03522:	4639      	mov	r1, r7
c0d03524:	f000 f90e 	bl	c0d03744 <usbd_is_valid_intf>
c0d03528:	2800      	cmp	r0, #0
c0d0352a:	d00e      	beq.n	c0d0354a <USBD_LL_DataOutStage+0x44>
c0d0352c:	00f8      	lsls	r0, r7, #3
c0d0352e:	5828      	ldr	r0, [r5, r0]
c0d03530:	6980      	ldr	r0, [r0, #24]
c0d03532:	2800      	cmp	r0, #0
c0d03534:	d009      	beq.n	c0d0354a <USBD_LL_DataOutStage+0x44>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d03536:	7831      	ldrb	r1, [r6, #0]
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d03538:	2903      	cmp	r1, #3
c0d0353a:	d106      	bne.n	c0d0354a <USBD_LL_DataOutStage+0x44>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
c0d0353c:	f7fe fc04 	bl	c0d01d48 <pic>
c0d03540:	4603      	mov	r3, r0
c0d03542:	4620      	mov	r0, r4
c0d03544:	9901      	ldr	r1, [sp, #4]
c0d03546:	9a02      	ldr	r2, [sp, #8]
c0d03548:	4798      	blx	r3
    }
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0354a:	1c7f      	adds	r7, r7, #1
c0d0354c:	2f03      	cmp	r7, #3
c0d0354e:	d1e7      	bne.n	c0d03520 <USBD_LL_DataOutStage+0x1a>
c0d03550:	e035      	b.n	c0d035be <USBD_LL_DataOutStage+0xb8>
  
  if(epnum == 0) 
  {
    pep = &pdev->ep_out[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_OUT)
c0d03552:	20f4      	movs	r0, #244	; 0xf4
c0d03554:	5820      	ldr	r0, [r4, r0]
c0d03556:	2803      	cmp	r0, #3
c0d03558:	d131      	bne.n	c0d035be <USBD_LL_DataOutStage+0xb8>
    {
      if(pep->rem_length > pep->maxpacket)
c0d0355a:	2090      	movs	r0, #144	; 0x90
c0d0355c:	5820      	ldr	r0, [r4, r0]
c0d0355e:	218c      	movs	r1, #140	; 0x8c
c0d03560:	5861      	ldr	r1, [r4, r1]
c0d03562:	4622      	mov	r2, r4
c0d03564:	328c      	adds	r2, #140	; 0x8c
c0d03566:	4281      	cmp	r1, r0
c0d03568:	d90a      	bls.n	c0d03580 <USBD_LL_DataOutStage+0x7a>
      {
        pep->rem_length -=  pep->maxpacket;
c0d0356a:	1a09      	subs	r1, r1, r0
c0d0356c:	6011      	str	r1, [r2, #0]
c0d0356e:	4281      	cmp	r1, r0
c0d03570:	d300      	bcc.n	c0d03574 <USBD_LL_DataOutStage+0x6e>
c0d03572:	4601      	mov	r1, r0
       
        USBD_CtlContinueRx (pdev, 
c0d03574:	b28a      	uxth	r2, r1
c0d03576:	4620      	mov	r0, r4
c0d03578:	9902      	ldr	r1, [sp, #8]
c0d0357a:	f000 fd0f 	bl	c0d03f9c <USBD_CtlContinueRx>
c0d0357e:	e01e      	b.n	c0d035be <USBD_LL_DataOutStage+0xb8>
                            MIN(pep->rem_length ,pep->maxpacket));
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03580:	2045      	movs	r0, #69	; 0x45
c0d03582:	0080      	lsls	r0, r0, #2
c0d03584:	1826      	adds	r6, r4, r0
c0d03586:	4627      	mov	r7, r4
c0d03588:	37fc      	adds	r7, #252	; 0xfc
c0d0358a:	2500      	movs	r5, #0
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d0358c:	4620      	mov	r0, r4
c0d0358e:	4629      	mov	r1, r5
c0d03590:	f000 f8d8 	bl	c0d03744 <usbd_is_valid_intf>
c0d03594:	2800      	cmp	r0, #0
c0d03596:	d00c      	beq.n	c0d035b2 <USBD_LL_DataOutStage+0xac>
c0d03598:	00e8      	lsls	r0, r5, #3
c0d0359a:	5830      	ldr	r0, [r6, r0]
c0d0359c:	6900      	ldr	r0, [r0, #16]
c0d0359e:	2800      	cmp	r0, #0
c0d035a0:	d007      	beq.n	c0d035b2 <USBD_LL_DataOutStage+0xac>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d035a2:	7839      	ldrb	r1, [r7, #0]
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d035a4:	2903      	cmp	r1, #3
c0d035a6:	d104      	bne.n	c0d035b2 <USBD_LL_DataOutStage+0xac>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
c0d035a8:	f7fe fbce 	bl	c0d01d48 <pic>
c0d035ac:	4601      	mov	r1, r0
c0d035ae:	4620      	mov	r0, r4
c0d035b0:	4788      	blx	r1
                            MIN(pep->rem_length ,pep->maxpacket));
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d035b2:	1c6d      	adds	r5, r5, #1
c0d035b4:	2d03      	cmp	r5, #3
c0d035b6:	d1e9      	bne.n	c0d0358c <USBD_LL_DataOutStage+0x86>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
          }
        }
        USBD_CtlSendStatus(pdev);
c0d035b8:	4620      	mov	r0, r4
c0d035ba:	f000 fcf6 	bl	c0d03faa <USBD_CtlSendStatus>
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
      }
    }
  }  
  return USBD_OK;
c0d035be:	2000      	movs	r0, #0
c0d035c0:	b003      	add	sp, #12
c0d035c2:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d035c4 <USBD_LL_DataInStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataInStage(USBD_HandleTypeDef *pdev ,uint8_t epnum, uint8_t *pdata)
{
c0d035c4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d035c6:	b081      	sub	sp, #4
c0d035c8:	4604      	mov	r4, r0
c0d035ca:	9100      	str	r1, [sp, #0]
  USBD_EndpointTypeDef    *pep;
  UNUSED(pdata);
    
  if(epnum == 0) 
c0d035cc:	2900      	cmp	r1, #0
c0d035ce:	d01d      	beq.n	c0d0360c <USBD_LL_DataInStage+0x48>
      pdev->dev_test_mode = 0;
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d035d0:	2045      	movs	r0, #69	; 0x45
c0d035d2:	0080      	lsls	r0, r0, #2
c0d035d4:	1827      	adds	r7, r4, r0
c0d035d6:	4625      	mov	r5, r4
c0d035d8:	35fc      	adds	r5, #252	; 0xfc
c0d035da:	2600      	movs	r6, #0
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d035dc:	4620      	mov	r0, r4
c0d035de:	4631      	mov	r1, r6
c0d035e0:	f000 f8b0 	bl	c0d03744 <usbd_is_valid_intf>
c0d035e4:	2800      	cmp	r0, #0
c0d035e6:	d00d      	beq.n	c0d03604 <USBD_LL_DataInStage+0x40>
c0d035e8:	00f0      	lsls	r0, r6, #3
c0d035ea:	5838      	ldr	r0, [r7, r0]
c0d035ec:	6940      	ldr	r0, [r0, #20]
c0d035ee:	2800      	cmp	r0, #0
c0d035f0:	d008      	beq.n	c0d03604 <USBD_LL_DataInStage+0x40>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d035f2:	7829      	ldrb	r1, [r5, #0]
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d035f4:	2903      	cmp	r1, #3
c0d035f6:	d105      	bne.n	c0d03604 <USBD_LL_DataInStage+0x40>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
c0d035f8:	f7fe fba6 	bl	c0d01d48 <pic>
c0d035fc:	4602      	mov	r2, r0
c0d035fe:	4620      	mov	r0, r4
c0d03600:	9900      	ldr	r1, [sp, #0]
c0d03602:	4790      	blx	r2
      pdev->dev_test_mode = 0;
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03604:	1c76      	adds	r6, r6, #1
c0d03606:	2e03      	cmp	r6, #3
c0d03608:	d1e8      	bne.n	c0d035dc <USBD_LL_DataInStage+0x18>
c0d0360a:	e051      	b.n	c0d036b0 <USBD_LL_DataInStage+0xec>
    
  if(epnum == 0) 
  {
    pep = &pdev->ep_in[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_IN)
c0d0360c:	20f4      	movs	r0, #244	; 0xf4
c0d0360e:	5820      	ldr	r0, [r4, r0]
c0d03610:	2802      	cmp	r0, #2
c0d03612:	d145      	bne.n	c0d036a0 <USBD_LL_DataInStage+0xdc>
    {
      if(pep->rem_length > pep->maxpacket)
c0d03614:	69e0      	ldr	r0, [r4, #28]
c0d03616:	6a25      	ldr	r5, [r4, #32]
c0d03618:	42a8      	cmp	r0, r5
c0d0361a:	d90b      	bls.n	c0d03634 <USBD_LL_DataInStage+0x70>
      {
        pep->rem_length -=  pep->maxpacket;
c0d0361c:	1b40      	subs	r0, r0, r5
c0d0361e:	61e0      	str	r0, [r4, #28]
        pdev->pData += pep->maxpacket;
c0d03620:	2113      	movs	r1, #19
c0d03622:	010a      	lsls	r2, r1, #4
c0d03624:	58a1      	ldr	r1, [r4, r2]
c0d03626:	1949      	adds	r1, r1, r5
c0d03628:	50a1      	str	r1, [r4, r2]
        USBD_LL_PrepareReceive (pdev,
                                0,
                                0);  
        */
        
        USBD_CtlContinueSendData (pdev, 
c0d0362a:	b282      	uxth	r2, r0
c0d0362c:	4620      	mov	r0, r4
c0d0362e:	f000 fca7 	bl	c0d03f80 <USBD_CtlContinueSendData>
c0d03632:	e035      	b.n	c0d036a0 <USBD_LL_DataInStage+0xdc>
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d03634:	69a6      	ldr	r6, [r4, #24]
c0d03636:	4630      	mov	r0, r6
c0d03638:	4629      	mov	r1, r5
c0d0363a:	f000 fd53 	bl	c0d040e4 <__aeabi_uidivmod>
c0d0363e:	42ae      	cmp	r6, r5
c0d03640:	d30f      	bcc.n	c0d03662 <USBD_LL_DataInStage+0x9e>
c0d03642:	2900      	cmp	r1, #0
c0d03644:	d10d      	bne.n	c0d03662 <USBD_LL_DataInStage+0x9e>
           (pep->total_length >= pep->maxpacket) &&
             (pep->total_length < pdev->ep0_data_len ))
c0d03646:	20f8      	movs	r0, #248	; 0xf8
c0d03648:	5820      	ldr	r0, [r4, r0]
c0d0364a:	4627      	mov	r7, r4
c0d0364c:	37f8      	adds	r7, #248	; 0xf8
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d0364e:	4286      	cmp	r6, r0
c0d03650:	d207      	bcs.n	c0d03662 <USBD_LL_DataInStage+0x9e>
c0d03652:	2500      	movs	r5, #0
          USBD_LL_PrepareReceive (pdev,
                                  0,
                                  0);
          */

          USBD_CtlContinueSendData(pdev , NULL, 0);
c0d03654:	4620      	mov	r0, r4
c0d03656:	4629      	mov	r1, r5
c0d03658:	462a      	mov	r2, r5
c0d0365a:	f000 fc91 	bl	c0d03f80 <USBD_CtlContinueSendData>
          pdev->ep0_data_len = 0;
c0d0365e:	603d      	str	r5, [r7, #0]
c0d03660:	e01e      	b.n	c0d036a0 <USBD_LL_DataInStage+0xdc>
          
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03662:	2045      	movs	r0, #69	; 0x45
c0d03664:	0080      	lsls	r0, r0, #2
c0d03666:	1826      	adds	r6, r4, r0
c0d03668:	4627      	mov	r7, r4
c0d0366a:	37fc      	adds	r7, #252	; 0xfc
c0d0366c:	2500      	movs	r5, #0
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d0366e:	4620      	mov	r0, r4
c0d03670:	4629      	mov	r1, r5
c0d03672:	f000 f867 	bl	c0d03744 <usbd_is_valid_intf>
c0d03676:	2800      	cmp	r0, #0
c0d03678:	d00c      	beq.n	c0d03694 <USBD_LL_DataInStage+0xd0>
c0d0367a:	00e8      	lsls	r0, r5, #3
c0d0367c:	5830      	ldr	r0, [r6, r0]
c0d0367e:	68c0      	ldr	r0, [r0, #12]
c0d03680:	2800      	cmp	r0, #0
c0d03682:	d007      	beq.n	c0d03694 <USBD_LL_DataInStage+0xd0>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d03684:	7839      	ldrb	r1, [r7, #0]
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d03686:	2903      	cmp	r1, #3
c0d03688:	d104      	bne.n	c0d03694 <USBD_LL_DataInStage+0xd0>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
c0d0368a:	f7fe fb5d 	bl	c0d01d48 <pic>
c0d0368e:	4601      	mov	r1, r0
c0d03690:	4620      	mov	r0, r4
c0d03692:	4788      	blx	r1
          
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03694:	1c6d      	adds	r5, r5, #1
c0d03696:	2d03      	cmp	r5, #3
c0d03698:	d1e9      	bne.n	c0d0366e <USBD_LL_DataInStage+0xaa>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
            }
          }
          USBD_CtlReceiveStatus(pdev);
c0d0369a:	4620      	mov	r0, r4
c0d0369c:	f000 fc91 	bl	c0d03fc2 <USBD_CtlReceiveStatus>
        }
      }
    }
    if (pdev->dev_test_mode == 1)
c0d036a0:	2001      	movs	r0, #1
c0d036a2:	0201      	lsls	r1, r0, #8
c0d036a4:	1860      	adds	r0, r4, r1
c0d036a6:	5c61      	ldrb	r1, [r4, r1]
c0d036a8:	2901      	cmp	r1, #1
c0d036aa:	d101      	bne.n	c0d036b0 <USBD_LL_DataInStage+0xec>
    {
      USBD_RunTestMode(pdev); 
      pdev->dev_test_mode = 0;
c0d036ac:	2100      	movs	r1, #0
c0d036ae:	7001      	strb	r1, [r0, #0]
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
      }
    }
  }
  return USBD_OK;
c0d036b0:	2000      	movs	r0, #0
c0d036b2:	b001      	add	sp, #4
c0d036b4:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d036b6 <USBD_LL_Reset>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_Reset(USBD_HandleTypeDef  *pdev)
{
c0d036b6:	b570      	push	{r4, r5, r6, lr}
c0d036b8:	4604      	mov	r4, r0
  pdev->ep_out[0].maxpacket = USB_MAX_EP0_SIZE;
c0d036ba:	2090      	movs	r0, #144	; 0x90
c0d036bc:	2140      	movs	r1, #64	; 0x40
c0d036be:	5021      	str	r1, [r4, r0]
  

  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
c0d036c0:	6221      	str	r1, [r4, #32]
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
c0d036c2:	20fc      	movs	r0, #252	; 0xfc
c0d036c4:	2101      	movs	r1, #1
c0d036c6:	5421      	strb	r1, [r4, r0]
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d036c8:	2045      	movs	r0, #69	; 0x45
c0d036ca:	0080      	lsls	r0, r0, #2
c0d036cc:	1826      	adds	r6, r4, r0
c0d036ce:	2500      	movs	r5, #0
    if( usbd_is_valid_intf(pdev, intf))
c0d036d0:	4620      	mov	r0, r4
c0d036d2:	4629      	mov	r1, r5
c0d036d4:	f000 f836 	bl	c0d03744 <usbd_is_valid_intf>
c0d036d8:	2800      	cmp	r0, #0
c0d036da:	d008      	beq.n	c0d036ee <USBD_LL_Reset+0x38>
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
c0d036dc:	00e8      	lsls	r0, r5, #3
c0d036de:	5830      	ldr	r0, [r6, r0]
c0d036e0:	6840      	ldr	r0, [r0, #4]
c0d036e2:	f7fe fb31 	bl	c0d01d48 <pic>
c0d036e6:	4602      	mov	r2, r0
c0d036e8:	7921      	ldrb	r1, [r4, #4]
c0d036ea:	4620      	mov	r0, r4
c0d036ec:	4790      	blx	r2
  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d036ee:	1c6d      	adds	r5, r5, #1
c0d036f0:	2d03      	cmp	r5, #3
c0d036f2:	d1ed      	bne.n	c0d036d0 <USBD_LL_Reset+0x1a>
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
    }
  }
  
  return USBD_OK;
c0d036f4:	2000      	movs	r0, #0
c0d036f6:	bd70      	pop	{r4, r5, r6, pc}

c0d036f8 <USBD_LL_SetSpeed>:
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetSpeed(USBD_HandleTypeDef  *pdev, USBD_SpeedTypeDef speed)
{
  pdev->dev_speed = speed;
c0d036f8:	7401      	strb	r1, [r0, #16]
c0d036fa:	2000      	movs	r0, #0
  return USBD_OK;
c0d036fc:	4770      	bx	lr

c0d036fe <USBD_LL_Suspend>:
{
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_old_state =  pdev->dev_state;
  //pdev->dev_state  = USBD_STATE_SUSPENDED;
  return USBD_OK;
c0d036fe:	2000      	movs	r0, #0
c0d03700:	4770      	bx	lr

c0d03702 <USBD_LL_Resume>:
USBD_StatusTypeDef USBD_LL_Resume(USBD_HandleTypeDef  *pdev)
{
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_state = pdev->dev_old_state;  
  return USBD_OK;
c0d03702:	2000      	movs	r0, #0
c0d03704:	4770      	bx	lr

c0d03706 <USBD_LL_SOF>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
c0d03706:	b570      	push	{r4, r5, r6, lr}
c0d03708:	4604      	mov	r4, r0
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
c0d0370a:	20fc      	movs	r0, #252	; 0xfc
c0d0370c:	5c20      	ldrb	r0, [r4, r0]
c0d0370e:	2803      	cmp	r0, #3
c0d03710:	d116      	bne.n	c0d03740 <USBD_LL_SOF+0x3a>
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && pdev->interfacesClass[intf].pClass->SOF != NULL)
c0d03712:	2045      	movs	r0, #69	; 0x45
c0d03714:	0080      	lsls	r0, r0, #2
c0d03716:	1826      	adds	r6, r4, r0
c0d03718:	2500      	movs	r5, #0
c0d0371a:	4620      	mov	r0, r4
c0d0371c:	4629      	mov	r1, r5
c0d0371e:	f000 f811 	bl	c0d03744 <usbd_is_valid_intf>
c0d03722:	2800      	cmp	r0, #0
c0d03724:	d009      	beq.n	c0d0373a <USBD_LL_SOF+0x34>
c0d03726:	00e8      	lsls	r0, r5, #3
c0d03728:	5830      	ldr	r0, [r6, r0]
c0d0372a:	69c0      	ldr	r0, [r0, #28]
c0d0372c:	2800      	cmp	r0, #0
c0d0372e:	d004      	beq.n	c0d0373a <USBD_LL_SOF+0x34>
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
c0d03730:	f7fe fb0a 	bl	c0d01d48 <pic>
c0d03734:	4601      	mov	r1, r0
c0d03736:	4620      	mov	r0, r4
c0d03738:	4788      	blx	r1
USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0373a:	1c6d      	adds	r5, r5, #1
c0d0373c:	2d03      	cmp	r5, #3
c0d0373e:	d1ec      	bne.n	c0d0371a <USBD_LL_SOF+0x14>
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
      }
    }
  }
  return USBD_OK;
c0d03740:	2000      	movs	r0, #0
c0d03742:	bd70      	pop	{r4, r5, r6, pc}

c0d03744 <usbd_is_valid_intf>:

/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
c0d03744:	4602      	mov	r2, r0
c0d03746:	2000      	movs	r0, #0
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03748:	2902      	cmp	r1, #2
c0d0374a:	d808      	bhi.n	c0d0375e <usbd_is_valid_intf+0x1a>
c0d0374c:	00c8      	lsls	r0, r1, #3
c0d0374e:	1810      	adds	r0, r2, r0
c0d03750:	2145      	movs	r1, #69	; 0x45
c0d03752:	0089      	lsls	r1, r1, #2
c0d03754:	5841      	ldr	r1, [r0, r1]
c0d03756:	2001      	movs	r0, #1
c0d03758:	2900      	cmp	r1, #0
c0d0375a:	d100      	bne.n	c0d0375e <usbd_is_valid_intf+0x1a>
c0d0375c:	4608      	mov	r0, r1
c0d0375e:	4770      	bx	lr

c0d03760 <USBD_StdDevReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdDevReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d03760:	b580      	push	{r7, lr}
c0d03762:	784a      	ldrb	r2, [r1, #1]
  USBD_StatusTypeDef ret = USBD_OK;  
  
  switch (req->bRequest) 
c0d03764:	2a04      	cmp	r2, #4
c0d03766:	dd08      	ble.n	c0d0377a <USBD_StdDevReq+0x1a>
c0d03768:	2a07      	cmp	r2, #7
c0d0376a:	dc0f      	bgt.n	c0d0378c <USBD_StdDevReq+0x2c>
c0d0376c:	2a05      	cmp	r2, #5
c0d0376e:	d014      	beq.n	c0d0379a <USBD_StdDevReq+0x3a>
c0d03770:	2a06      	cmp	r2, #6
c0d03772:	d11b      	bne.n	c0d037ac <USBD_StdDevReq+0x4c>
  {
  case USB_REQ_GET_DESCRIPTOR: 
    
    USBD_GetDescriptor (pdev, req) ;
c0d03774:	f000 f821 	bl	c0d037ba <USBD_GetDescriptor>
c0d03778:	e01d      	b.n	c0d037b6 <USBD_StdDevReq+0x56>
c0d0377a:	2a00      	cmp	r2, #0
c0d0377c:	d010      	beq.n	c0d037a0 <USBD_StdDevReq+0x40>
c0d0377e:	2a01      	cmp	r2, #1
c0d03780:	d017      	beq.n	c0d037b2 <USBD_StdDevReq+0x52>
c0d03782:	2a03      	cmp	r2, #3
c0d03784:	d112      	bne.n	c0d037ac <USBD_StdDevReq+0x4c>
    USBD_GetStatus (pdev , req);
    break;
    
    
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
c0d03786:	f000 f93b 	bl	c0d03a00 <USBD_SetFeature>
c0d0378a:	e014      	b.n	c0d037b6 <USBD_StdDevReq+0x56>
c0d0378c:	2a08      	cmp	r2, #8
c0d0378e:	d00a      	beq.n	c0d037a6 <USBD_StdDevReq+0x46>
c0d03790:	2a09      	cmp	r2, #9
c0d03792:	d10b      	bne.n	c0d037ac <USBD_StdDevReq+0x4c>
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
    break;
    
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
c0d03794:	f000 f8c3 	bl	c0d0391e <USBD_SetConfig>
c0d03798:	e00d      	b.n	c0d037b6 <USBD_StdDevReq+0x56>
    
    USBD_GetDescriptor (pdev, req) ;
    break;
    
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
c0d0379a:	f000 f89b 	bl	c0d038d4 <USBD_SetAddress>
c0d0379e:	e00a      	b.n	c0d037b6 <USBD_StdDevReq+0x56>
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_STATUS:                                  
    USBD_GetStatus (pdev , req);
c0d037a0:	f000 f90b 	bl	c0d039ba <USBD_GetStatus>
c0d037a4:	e007      	b.n	c0d037b6 <USBD_StdDevReq+0x56>
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
c0d037a6:	f000 f8f1 	bl	c0d0398c <USBD_GetConfig>
c0d037aa:	e004      	b.n	c0d037b6 <USBD_StdDevReq+0x56>
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
    break;
    
  default:  
    USBD_CtlError(pdev , req);
c0d037ac:	f000 f971 	bl	c0d03a92 <USBD_CtlError>
c0d037b0:	e001      	b.n	c0d037b6 <USBD_StdDevReq+0x56>
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
    break;
    
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
c0d037b2:	f000 f944 	bl	c0d03a3e <USBD_ClrFeature>
  default:  
    USBD_CtlError(pdev , req);
    break;
  }
  
  return ret;
c0d037b6:	2000      	movs	r0, #0
c0d037b8:	bd80      	pop	{r7, pc}

c0d037ba <USBD_GetDescriptor>:
* @param  req: usb request
* @retval status
*/
void USBD_GetDescriptor(USBD_HandleTypeDef *pdev , 
                               USBD_SetupReqTypedef *req)
{
c0d037ba:	b5b0      	push	{r4, r5, r7, lr}
c0d037bc:	b082      	sub	sp, #8
c0d037be:	460d      	mov	r5, r1
c0d037c0:	4604      	mov	r4, r0
  uint16_t len;
  uint8_t *pbuf;
  
    
  switch (req->wValue >> 8)
c0d037c2:	8869      	ldrh	r1, [r5, #2]
c0d037c4:	0a08      	lsrs	r0, r1, #8
c0d037c6:	2805      	cmp	r0, #5
c0d037c8:	dc13      	bgt.n	c0d037f2 <USBD_GetDescriptor+0x38>
c0d037ca:	2801      	cmp	r0, #1
c0d037cc:	d01c      	beq.n	c0d03808 <USBD_GetDescriptor+0x4e>
c0d037ce:	2802      	cmp	r0, #2
c0d037d0:	d025      	beq.n	c0d0381e <USBD_GetDescriptor+0x64>
c0d037d2:	2803      	cmp	r0, #3
c0d037d4:	d13a      	bne.n	c0d0384c <USBD_GetDescriptor+0x92>
c0d037d6:	b2c8      	uxtb	r0, r1
      }
    }
    break;
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
c0d037d8:	2802      	cmp	r0, #2
c0d037da:	dc3c      	bgt.n	c0d03856 <USBD_GetDescriptor+0x9c>
c0d037dc:	2800      	cmp	r0, #0
c0d037de:	d065      	beq.n	c0d038ac <USBD_GetDescriptor+0xf2>
c0d037e0:	2801      	cmp	r0, #1
c0d037e2:	d06d      	beq.n	c0d038c0 <USBD_GetDescriptor+0x106>
c0d037e4:	2802      	cmp	r0, #2
c0d037e6:	d131      	bne.n	c0d0384c <USBD_GetDescriptor+0x92>
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
c0d037e8:	2011      	movs	r0, #17
c0d037ea:	0100      	lsls	r0, r0, #4
c0d037ec:	5820      	ldr	r0, [r4, r0]
c0d037ee:	68c0      	ldr	r0, [r0, #12]
c0d037f0:	e00e      	b.n	c0d03810 <USBD_GetDescriptor+0x56>
c0d037f2:	2806      	cmp	r0, #6
c0d037f4:	d01d      	beq.n	c0d03832 <USBD_GetDescriptor+0x78>
c0d037f6:	2807      	cmp	r0, #7
c0d037f8:	d025      	beq.n	c0d03846 <USBD_GetDescriptor+0x8c>
c0d037fa:	280f      	cmp	r0, #15
c0d037fc:	d126      	bne.n	c0d0384c <USBD_GetDescriptor+0x92>
    
  switch (req->wValue >> 8)
  { 
#if (USBD_LPM_ENABLED == 1)
  case USB_DESC_TYPE_BOS:
    pbuf = ((GetBOSDescriptor_t)PIC(pdev->pDesc->GetBOSDescriptor))(pdev->dev_speed, &len);
c0d037fe:	2011      	movs	r0, #17
c0d03800:	0100      	lsls	r0, r0, #4
c0d03802:	5820      	ldr	r0, [r4, r0]
c0d03804:	69c0      	ldr	r0, [r0, #28]
c0d03806:	e003      	b.n	c0d03810 <USBD_GetDescriptor+0x56>
    break;
#endif    
  case USB_DESC_TYPE_DEVICE:
    pbuf = ((GetDeviceDescriptor_t)PIC(pdev->pDesc->GetDeviceDescriptor))(pdev->dev_speed, &len);
c0d03808:	2011      	movs	r0, #17
c0d0380a:	0100      	lsls	r0, r0, #4
c0d0380c:	5820      	ldr	r0, [r4, r0]
c0d0380e:	6800      	ldr	r0, [r0, #0]
c0d03810:	f7fe fa9a 	bl	c0d01d48 <pic>
c0d03814:	4602      	mov	r2, r0
c0d03816:	7c20      	ldrb	r0, [r4, #16]
c0d03818:	a901      	add	r1, sp, #4
c0d0381a:	4790      	blx	r2
c0d0381c:	e034      	b.n	c0d03888 <USBD_GetDescriptor+0xce>
    break;
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
c0d0381e:	2045      	movs	r0, #69	; 0x45
c0d03820:	0080      	lsls	r0, r0, #2
c0d03822:	5820      	ldr	r0, [r4, r0]
c0d03824:	2800      	cmp	r0, #0
c0d03826:	d021      	beq.n	c0d0386c <USBD_GetDescriptor+0xb2>
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
c0d03828:	7c21      	ldrb	r1, [r4, #16]
c0d0382a:	2900      	cmp	r1, #0
c0d0382c:	d026      	beq.n	c0d0387c <USBD_GetDescriptor+0xc2>
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
        //pbuf[1] = USB_DESC_TYPE_CONFIGURATION; CONST BUFFER KTHX
      }
      else
      {
        pbuf   = (uint8_t *)((GetFSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetFSConfigDescriptor))(&len);
c0d0382e:	6ac0      	ldr	r0, [r0, #44]	; 0x2c
c0d03830:	e025      	b.n	c0d0387e <USBD_GetDescriptor+0xc4>
#endif   
    }
    break;
  case USB_DESC_TYPE_DEVICE_QUALIFIER:                   

    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL )   
c0d03832:	7c20      	ldrb	r0, [r4, #16]
c0d03834:	2800      	cmp	r0, #0
c0d03836:	d109      	bne.n	c0d0384c <USBD_GetDescriptor+0x92>
c0d03838:	2045      	movs	r0, #69	; 0x45
c0d0383a:	0080      	lsls	r0, r0, #2
c0d0383c:	5820      	ldr	r0, [r4, r0]
c0d0383e:	2800      	cmp	r0, #0
c0d03840:	d004      	beq.n	c0d0384c <USBD_GetDescriptor+0x92>
    {
      pbuf   = (uint8_t *)((GetDeviceQualifierDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetDeviceQualifierDescriptor))(&len);
c0d03842:	6b40      	ldr	r0, [r0, #52]	; 0x34
c0d03844:	e01b      	b.n	c0d0387e <USBD_GetDescriptor+0xc4>
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d03846:	7c20      	ldrb	r0, [r4, #16]
c0d03848:	2800      	cmp	r0, #0
c0d0384a:	d010      	beq.n	c0d0386e <USBD_GetDescriptor+0xb4>
c0d0384c:	4620      	mov	r0, r4
c0d0384e:	4629      	mov	r1, r5
c0d03850:	f000 f91f 	bl	c0d03a92 <USBD_CtlError>
c0d03854:	e028      	b.n	c0d038a8 <USBD_GetDescriptor+0xee>
c0d03856:	2803      	cmp	r0, #3
c0d03858:	d02d      	beq.n	c0d038b6 <USBD_GetDescriptor+0xfc>
c0d0385a:	2804      	cmp	r0, #4
c0d0385c:	d035      	beq.n	c0d038ca <USBD_GetDescriptor+0x110>
c0d0385e:	2805      	cmp	r0, #5
c0d03860:	d1f4      	bne.n	c0d0384c <USBD_GetDescriptor+0x92>
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_INTERFACE_STR:
      pbuf = ((GetInterfaceStrDescriptor_t)PIC(pdev->pDesc->GetInterfaceStrDescriptor))(pdev->dev_speed, &len);
c0d03862:	2011      	movs	r0, #17
c0d03864:	0100      	lsls	r0, r0, #4
c0d03866:	5820      	ldr	r0, [r4, r0]
c0d03868:	6980      	ldr	r0, [r0, #24]
c0d0386a:	e7d1      	b.n	c0d03810 <USBD_GetDescriptor+0x56>
c0d0386c:	e00d      	b.n	c0d0388a <USBD_GetDescriptor+0xd0>
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d0386e:	2045      	movs	r0, #69	; 0x45
c0d03870:	0080      	lsls	r0, r0, #2
c0d03872:	5820      	ldr	r0, [r4, r0]
c0d03874:	2800      	cmp	r0, #0
c0d03876:	d0e9      	beq.n	c0d0384c <USBD_GetDescriptor+0x92>
    {
      pbuf   = (uint8_t *)((GetOtherSpeedConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetOtherSpeedConfigDescriptor))(&len);
c0d03878:	6b00      	ldr	r0, [r0, #48]	; 0x30
c0d0387a:	e000      	b.n	c0d0387e <USBD_GetDescriptor+0xc4>
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
      {
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
c0d0387c:	6a80      	ldr	r0, [r0, #40]	; 0x28
c0d0387e:	f7fe fa63 	bl	c0d01d48 <pic>
c0d03882:	4601      	mov	r1, r0
c0d03884:	a801      	add	r0, sp, #4
c0d03886:	4788      	blx	r1
c0d03888:	4601      	mov	r1, r0
c0d0388a:	a801      	add	r0, sp, #4
  default: 
     USBD_CtlError(pdev , req);
    return;
  }
  
  if((len != 0)&& (req->wLength != 0))
c0d0388c:	8802      	ldrh	r2, [r0, #0]
c0d0388e:	2a00      	cmp	r2, #0
c0d03890:	d00a      	beq.n	c0d038a8 <USBD_GetDescriptor+0xee>
c0d03892:	88e8      	ldrh	r0, [r5, #6]
c0d03894:	2800      	cmp	r0, #0
c0d03896:	d007      	beq.n	c0d038a8 <USBD_GetDescriptor+0xee>
  {
    
    len = MIN(len , req->wLength);
c0d03898:	4282      	cmp	r2, r0
c0d0389a:	d300      	bcc.n	c0d0389e <USBD_GetDescriptor+0xe4>
c0d0389c:	4602      	mov	r2, r0
c0d0389e:	a801      	add	r0, sp, #4
c0d038a0:	8002      	strh	r2, [r0, #0]
    
    // prepare abort if host does not read the whole data
    //USBD_CtlReceiveStatus(pdev);

    // start transfer
    USBD_CtlSendData (pdev, 
c0d038a2:	4620      	mov	r0, r4
c0d038a4:	f000 fb56 	bl	c0d03f54 <USBD_CtlSendData>
                      pbuf,
                      len);
  }
  
}
c0d038a8:	b002      	add	sp, #8
c0d038aa:	bdb0      	pop	{r4, r5, r7, pc}
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
    {
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
c0d038ac:	2011      	movs	r0, #17
c0d038ae:	0100      	lsls	r0, r0, #4
c0d038b0:	5820      	ldr	r0, [r4, r0]
c0d038b2:	6840      	ldr	r0, [r0, #4]
c0d038b4:	e7ac      	b.n	c0d03810 <USBD_GetDescriptor+0x56>
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
c0d038b6:	2011      	movs	r0, #17
c0d038b8:	0100      	lsls	r0, r0, #4
c0d038ba:	5820      	ldr	r0, [r4, r0]
c0d038bc:	6900      	ldr	r0, [r0, #16]
c0d038be:	e7a7      	b.n	c0d03810 <USBD_GetDescriptor+0x56>
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
      break;
      
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
c0d038c0:	2011      	movs	r0, #17
c0d038c2:	0100      	lsls	r0, r0, #4
c0d038c4:	5820      	ldr	r0, [r4, r0]
c0d038c6:	6880      	ldr	r0, [r0, #8]
c0d038c8:	e7a2      	b.n	c0d03810 <USBD_GetDescriptor+0x56>
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
c0d038ca:	2011      	movs	r0, #17
c0d038cc:	0100      	lsls	r0, r0, #4
c0d038ce:	5820      	ldr	r0, [r4, r0]
c0d038d0:	6940      	ldr	r0, [r0, #20]
c0d038d2:	e79d      	b.n	c0d03810 <USBD_GetDescriptor+0x56>

c0d038d4 <USBD_SetAddress>:
* @param  req: usb request
* @retval status
*/
void USBD_SetAddress(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d038d4:	b570      	push	{r4, r5, r6, lr}
c0d038d6:	4604      	mov	r4, r0
  uint8_t  dev_addr; 
  
  if ((req->wIndex == 0) && (req->wLength == 0)) 
c0d038d8:	8888      	ldrh	r0, [r1, #4]
c0d038da:	2800      	cmp	r0, #0
c0d038dc:	d10b      	bne.n	c0d038f6 <USBD_SetAddress+0x22>
c0d038de:	88c8      	ldrh	r0, [r1, #6]
c0d038e0:	2800      	cmp	r0, #0
c0d038e2:	d108      	bne.n	c0d038f6 <USBD_SetAddress+0x22>
  {
    dev_addr = (uint8_t)(req->wValue) & 0x7F;     
c0d038e4:	8848      	ldrh	r0, [r1, #2]
c0d038e6:	267f      	movs	r6, #127	; 0x7f
c0d038e8:	4006      	ands	r6, r0
    
    if (pdev->dev_state == USBD_STATE_CONFIGURED) 
c0d038ea:	20fc      	movs	r0, #252	; 0xfc
c0d038ec:	5c20      	ldrb	r0, [r4, r0]
c0d038ee:	4625      	mov	r5, r4
c0d038f0:	35fc      	adds	r5, #252	; 0xfc
c0d038f2:	2803      	cmp	r0, #3
c0d038f4:	d103      	bne.n	c0d038fe <USBD_SetAddress+0x2a>
c0d038f6:	4620      	mov	r0, r4
c0d038f8:	f000 f8cb 	bl	c0d03a92 <USBD_CtlError>
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d038fc:	bd70      	pop	{r4, r5, r6, pc}
    {
      USBD_CtlError(pdev , req);
    } 
    else 
    {
      pdev->dev_address = dev_addr;
c0d038fe:	20fe      	movs	r0, #254	; 0xfe
c0d03900:	5426      	strb	r6, [r4, r0]
      USBD_LL_SetUSBAddress(pdev, dev_addr);               
c0d03902:	b2f1      	uxtb	r1, r6
c0d03904:	4620      	mov	r0, r4
c0d03906:	f7ff fd0b 	bl	c0d03320 <USBD_LL_SetUSBAddress>
      USBD_CtlSendStatus(pdev);                         
c0d0390a:	4620      	mov	r0, r4
c0d0390c:	f000 fb4d 	bl	c0d03faa <USBD_CtlSendStatus>
      
      if (dev_addr != 0) 
c0d03910:	2002      	movs	r0, #2
c0d03912:	2101      	movs	r1, #1
c0d03914:	2e00      	cmp	r6, #0
c0d03916:	d100      	bne.n	c0d0391a <USBD_SetAddress+0x46>
c0d03918:	4608      	mov	r0, r1
c0d0391a:	7028      	strb	r0, [r5, #0]
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d0391c:	bd70      	pop	{r4, r5, r6, pc}

c0d0391e <USBD_SetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_SetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d0391e:	b570      	push	{r4, r5, r6, lr}
c0d03920:	460d      	mov	r5, r1
c0d03922:	4604      	mov	r4, r0
  
  uint8_t  cfgidx;
  
  cfgidx = (uint8_t)(req->wValue);                 
c0d03924:	78ae      	ldrb	r6, [r5, #2]
  
  if (cfgidx > USBD_MAX_NUM_CONFIGURATION ) 
c0d03926:	2e02      	cmp	r6, #2
c0d03928:	d21d      	bcs.n	c0d03966 <USBD_SetConfig+0x48>
  {            
     USBD_CtlError(pdev , req);                              
  } 
  else 
  {
    switch (pdev->dev_state) 
c0d0392a:	20fc      	movs	r0, #252	; 0xfc
c0d0392c:	5c21      	ldrb	r1, [r4, r0]
c0d0392e:	4620      	mov	r0, r4
c0d03930:	30fc      	adds	r0, #252	; 0xfc
c0d03932:	2903      	cmp	r1, #3
c0d03934:	d007      	beq.n	c0d03946 <USBD_SetConfig+0x28>
c0d03936:	2902      	cmp	r1, #2
c0d03938:	d115      	bne.n	c0d03966 <USBD_SetConfig+0x48>
    {
    case USBD_STATE_ADDRESSED:
      if (cfgidx) 
c0d0393a:	2e00      	cmp	r6, #0
c0d0393c:	d022      	beq.n	c0d03984 <USBD_SetConfig+0x66>
      {                                			   							   							   				
        pdev->dev_config = cfgidx;
c0d0393e:	6066      	str	r6, [r4, #4]
        pdev->dev_state = USBD_STATE_CONFIGURED;
c0d03940:	2103      	movs	r1, #3
c0d03942:	7001      	strb	r1, [r0, #0]
c0d03944:	e009      	b.n	c0d0395a <USBD_SetConfig+0x3c>
      }
      USBD_CtlSendStatus(pdev);
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
c0d03946:	2e00      	cmp	r6, #0
c0d03948:	d012      	beq.n	c0d03970 <USBD_SetConfig+0x52>
        pdev->dev_state = USBD_STATE_ADDRESSED;
        pdev->dev_config = cfgidx;          
        USBD_ClrClassConfig(pdev , cfgidx);
        USBD_CtlSendStatus(pdev);
      } 
      else  if (cfgidx != pdev->dev_config) 
c0d0394a:	6860      	ldr	r0, [r4, #4]
c0d0394c:	4286      	cmp	r6, r0
c0d0394e:	d019      	beq.n	c0d03984 <USBD_SetConfig+0x66>
      {
        /* Clear old configuration */
        USBD_ClrClassConfig(pdev , pdev->dev_config);
c0d03950:	b2c1      	uxtb	r1, r0
c0d03952:	4620      	mov	r0, r4
c0d03954:	f7ff fd8b 	bl	c0d0346e <USBD_ClrClassConfig>
        
        /* set new configuration */
        pdev->dev_config = cfgidx;
c0d03958:	6066      	str	r6, [r4, #4]
c0d0395a:	4620      	mov	r0, r4
c0d0395c:	4631      	mov	r1, r6
c0d0395e:	f7ff fd69 	bl	c0d03434 <USBD_SetClassConfig>
c0d03962:	2802      	cmp	r0, #2
c0d03964:	d10e      	bne.n	c0d03984 <USBD_SetConfig+0x66>
c0d03966:	4620      	mov	r0, r4
c0d03968:	4629      	mov	r1, r5
c0d0396a:	f000 f892 	bl	c0d03a92 <USBD_CtlError>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d0396e:	bd70      	pop	{r4, r5, r6, pc}
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
      {                           
        pdev->dev_state = USBD_STATE_ADDRESSED;
c0d03970:	2102      	movs	r1, #2
c0d03972:	7001      	strb	r1, [r0, #0]
        pdev->dev_config = cfgidx;          
c0d03974:	6066      	str	r6, [r4, #4]
        USBD_ClrClassConfig(pdev , cfgidx);
c0d03976:	4620      	mov	r0, r4
c0d03978:	4631      	mov	r1, r6
c0d0397a:	f7ff fd78 	bl	c0d0346e <USBD_ClrClassConfig>
        USBD_CtlSendStatus(pdev);
c0d0397e:	4620      	mov	r0, r4
c0d03980:	f000 fb13 	bl	c0d03faa <USBD_CtlSendStatus>
c0d03984:	4620      	mov	r0, r4
c0d03986:	f000 fb10 	bl	c0d03faa <USBD_CtlSendStatus>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d0398a:	bd70      	pop	{r4, r5, r6, pc}

c0d0398c <USBD_GetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_GetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d0398c:	b580      	push	{r7, lr}

  if (req->wLength != 1) 
c0d0398e:	88ca      	ldrh	r2, [r1, #6]
c0d03990:	2a01      	cmp	r2, #1
c0d03992:	d10a      	bne.n	c0d039aa <USBD_GetConfig+0x1e>
  {                   
     USBD_CtlError(pdev , req);
  }
  else 
  {
    switch (pdev->dev_state )  
c0d03994:	22fc      	movs	r2, #252	; 0xfc
c0d03996:	5c82      	ldrb	r2, [r0, r2]
c0d03998:	2a03      	cmp	r2, #3
c0d0399a:	d009      	beq.n	c0d039b0 <USBD_GetConfig+0x24>
c0d0399c:	2a02      	cmp	r2, #2
c0d0399e:	d104      	bne.n	c0d039aa <USBD_GetConfig+0x1e>
    {
    case USBD_STATE_ADDRESSED:                     
      pdev->dev_default_config = 0;
c0d039a0:	2100      	movs	r1, #0
c0d039a2:	6081      	str	r1, [r0, #8]
c0d039a4:	4601      	mov	r1, r0
c0d039a6:	3108      	adds	r1, #8
c0d039a8:	e003      	b.n	c0d039b2 <USBD_GetConfig+0x26>
c0d039aa:	f000 f872 	bl	c0d03a92 <USBD_CtlError>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d039ae:	bd80      	pop	{r7, pc}
                        1);
      break;
      
    case USBD_STATE_CONFIGURED:   
      USBD_CtlSendData (pdev, 
                        (uint8_t *)&pdev->dev_config,
c0d039b0:	1d01      	adds	r1, r0, #4
c0d039b2:	2201      	movs	r2, #1
c0d039b4:	f000 face 	bl	c0d03f54 <USBD_CtlSendData>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d039b8:	bd80      	pop	{r7, pc}

c0d039ba <USBD_GetStatus>:
* @param  req: usb request
* @retval status
*/
void USBD_GetStatus(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d039ba:	b5b0      	push	{r4, r5, r7, lr}
c0d039bc:	4604      	mov	r4, r0
  
    
  switch (pdev->dev_state) 
c0d039be:	20fc      	movs	r0, #252	; 0xfc
c0d039c0:	5c20      	ldrb	r0, [r4, r0]
c0d039c2:	22fe      	movs	r2, #254	; 0xfe
c0d039c4:	4002      	ands	r2, r0
c0d039c6:	2a02      	cmp	r2, #2
c0d039c8:	d116      	bne.n	c0d039f8 <USBD_GetStatus+0x3e>
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d039ca:	2001      	movs	r0, #1
c0d039cc:	60e0      	str	r0, [r4, #12]
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d039ce:	2041      	movs	r0, #65	; 0x41
c0d039d0:	0080      	lsls	r0, r0, #2
c0d039d2:	5821      	ldr	r1, [r4, r0]
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d039d4:	4625      	mov	r5, r4
c0d039d6:	350c      	adds	r5, #12
c0d039d8:	2003      	movs	r0, #3
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d039da:	2900      	cmp	r1, #0
c0d039dc:	d005      	beq.n	c0d039ea <USBD_GetStatus+0x30>
c0d039de:	4620      	mov	r0, r4
c0d039e0:	f000 faef 	bl	c0d03fc2 <USBD_CtlReceiveStatus>
c0d039e4:	68e1      	ldr	r1, [r4, #12]
c0d039e6:	2002      	movs	r0, #2
c0d039e8:	4308      	orrs	r0, r1
    {
       pdev->dev_config_status |= USB_CONFIG_REMOTE_WAKEUP;                                
c0d039ea:	60e0      	str	r0, [r4, #12]
    }
    
    USBD_CtlSendData (pdev, 
c0d039ec:	2202      	movs	r2, #2
c0d039ee:	4620      	mov	r0, r4
c0d039f0:	4629      	mov	r1, r5
c0d039f2:	f000 faaf 	bl	c0d03f54 <USBD_CtlSendData>
    
  default :
    USBD_CtlError(pdev , req);                        
    break;
  }
}
c0d039f6:	bdb0      	pop	{r4, r5, r7, pc}
                      (uint8_t *)& pdev->dev_config_status,
                      2);
    break;
    
  default :
    USBD_CtlError(pdev , req);                        
c0d039f8:	4620      	mov	r0, r4
c0d039fa:	f000 f84a 	bl	c0d03a92 <USBD_CtlError>
    break;
  }
}
c0d039fe:	bdb0      	pop	{r4, r5, r7, pc}

c0d03a00 <USBD_SetFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_SetFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d03a00:	b5b0      	push	{r4, r5, r7, lr}
c0d03a02:	460d      	mov	r5, r1
c0d03a04:	4604      	mov	r4, r0

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
c0d03a06:	8868      	ldrh	r0, [r5, #2]
c0d03a08:	2801      	cmp	r0, #1
c0d03a0a:	d117      	bne.n	c0d03a3c <USBD_SetFeature+0x3c>
  {
    pdev->dev_remote_wakeup = 1;  
c0d03a0c:	2041      	movs	r0, #65	; 0x41
c0d03a0e:	0080      	lsls	r0, r0, #2
c0d03a10:	2101      	movs	r1, #1
c0d03a12:	5021      	str	r1, [r4, r0]
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03a14:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03a16:	2802      	cmp	r0, #2
c0d03a18:	d80d      	bhi.n	c0d03a36 <USBD_SetFeature+0x36>
c0d03a1a:	00c0      	lsls	r0, r0, #3
c0d03a1c:	1820      	adds	r0, r4, r0
c0d03a1e:	2145      	movs	r1, #69	; 0x45
c0d03a20:	0089      	lsls	r1, r1, #2
c0d03a22:	5840      	ldr	r0, [r0, r1]
{

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
  {
    pdev->dev_remote_wakeup = 1;  
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03a24:	2800      	cmp	r0, #0
c0d03a26:	d006      	beq.n	c0d03a36 <USBD_SetFeature+0x36>
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d03a28:	6880      	ldr	r0, [r0, #8]
c0d03a2a:	f7fe f98d 	bl	c0d01d48 <pic>
c0d03a2e:	4602      	mov	r2, r0
c0d03a30:	4620      	mov	r0, r4
c0d03a32:	4629      	mov	r1, r5
c0d03a34:	4790      	blx	r2
    }
    USBD_CtlSendStatus(pdev);
c0d03a36:	4620      	mov	r0, r4
c0d03a38:	f000 fab7 	bl	c0d03faa <USBD_CtlSendStatus>
  }

}
c0d03a3c:	bdb0      	pop	{r4, r5, r7, pc}

c0d03a3e <USBD_ClrFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_ClrFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d03a3e:	b5b0      	push	{r4, r5, r7, lr}
c0d03a40:	460d      	mov	r5, r1
c0d03a42:	4604      	mov	r4, r0
  switch (pdev->dev_state)
c0d03a44:	20fc      	movs	r0, #252	; 0xfc
c0d03a46:	5c20      	ldrb	r0, [r4, r0]
c0d03a48:	21fe      	movs	r1, #254	; 0xfe
c0d03a4a:	4001      	ands	r1, r0
c0d03a4c:	2902      	cmp	r1, #2
c0d03a4e:	d11b      	bne.n	c0d03a88 <USBD_ClrFeature+0x4a>
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
c0d03a50:	8868      	ldrh	r0, [r5, #2]
c0d03a52:	2801      	cmp	r0, #1
c0d03a54:	d11c      	bne.n	c0d03a90 <USBD_ClrFeature+0x52>
    {
      pdev->dev_remote_wakeup = 0; 
c0d03a56:	2041      	movs	r0, #65	; 0x41
c0d03a58:	0080      	lsls	r0, r0, #2
c0d03a5a:	2100      	movs	r1, #0
c0d03a5c:	5021      	str	r1, [r4, r0]
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03a5e:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03a60:	2802      	cmp	r0, #2
c0d03a62:	d80d      	bhi.n	c0d03a80 <USBD_ClrFeature+0x42>
c0d03a64:	00c0      	lsls	r0, r0, #3
c0d03a66:	1820      	adds	r0, r4, r0
c0d03a68:	2145      	movs	r1, #69	; 0x45
c0d03a6a:	0089      	lsls	r1, r1, #2
c0d03a6c:	5840      	ldr	r0, [r0, r1]
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
    {
      pdev->dev_remote_wakeup = 0; 
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03a6e:	2800      	cmp	r0, #0
c0d03a70:	d006      	beq.n	c0d03a80 <USBD_ClrFeature+0x42>
        ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d03a72:	6880      	ldr	r0, [r0, #8]
c0d03a74:	f7fe f968 	bl	c0d01d48 <pic>
c0d03a78:	4602      	mov	r2, r0
c0d03a7a:	4620      	mov	r0, r4
c0d03a7c:	4629      	mov	r1, r5
c0d03a7e:	4790      	blx	r2
      }
      USBD_CtlSendStatus(pdev);
c0d03a80:	4620      	mov	r0, r4
c0d03a82:	f000 fa92 	bl	c0d03faa <USBD_CtlSendStatus>
    
  default :
     USBD_CtlError(pdev , req);
    break;
  }
}
c0d03a86:	bdb0      	pop	{r4, r5, r7, pc}
      USBD_CtlSendStatus(pdev);
    }
    break;
    
  default :
     USBD_CtlError(pdev , req);
c0d03a88:	4620      	mov	r0, r4
c0d03a8a:	4629      	mov	r1, r5
c0d03a8c:	f000 f801 	bl	c0d03a92 <USBD_CtlError>
    break;
  }
}
c0d03a90:	bdb0      	pop	{r4, r5, r7, pc}

c0d03a92 <USBD_CtlError>:
  USBD_LL_StallEP(pdev , 0);
}

__weak void USBD_CtlError( USBD_HandleTypeDef *pdev ,
                            USBD_SetupReqTypedef *req)
{
c0d03a92:	b510      	push	{r4, lr}
c0d03a94:	4604      	mov	r4, r0
* @param  req: usb request
* @retval None
*/
void USBD_CtlStall( USBD_HandleTypeDef *pdev)
{
  USBD_LL_StallEP(pdev , 0x80);
c0d03a96:	2180      	movs	r1, #128	; 0x80
c0d03a98:	f7ff fbe6 	bl	c0d03268 <USBD_LL_StallEP>
  USBD_LL_StallEP(pdev , 0);
c0d03a9c:	2100      	movs	r1, #0
c0d03a9e:	4620      	mov	r0, r4
c0d03aa0:	f7ff fbe2 	bl	c0d03268 <USBD_LL_StallEP>

__weak void USBD_CtlError( USBD_HandleTypeDef *pdev ,
                            USBD_SetupReqTypedef *req)
{
  USBD_CtlStall(pdev);
}
c0d03aa4:	bd10      	pop	{r4, pc}

c0d03aa6 <USBD_StdItfReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdItfReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d03aa6:	b5b0      	push	{r4, r5, r7, lr}
c0d03aa8:	460d      	mov	r5, r1
c0d03aaa:	4604      	mov	r4, r0
  USBD_StatusTypeDef ret = USBD_OK; 
  
  switch (pdev->dev_state) 
c0d03aac:	20fc      	movs	r0, #252	; 0xfc
c0d03aae:	5c20      	ldrb	r0, [r4, r0]
c0d03ab0:	2803      	cmp	r0, #3
c0d03ab2:	d117      	bne.n	c0d03ae4 <USBD_StdItfReq+0x3e>
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d03ab4:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03ab6:	2802      	cmp	r0, #2
c0d03ab8:	d814      	bhi.n	c0d03ae4 <USBD_StdItfReq+0x3e>
c0d03aba:	00c0      	lsls	r0, r0, #3
c0d03abc:	1820      	adds	r0, r4, r0
c0d03abe:	2145      	movs	r1, #69	; 0x45
c0d03ac0:	0089      	lsls	r1, r1, #2
c0d03ac2:	5840      	ldr	r0, [r0, r1]
  
  switch (pdev->dev_state) 
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d03ac4:	2800      	cmp	r0, #0
c0d03ac6:	d00d      	beq.n	c0d03ae4 <USBD_StdItfReq+0x3e>
    {
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d03ac8:	6880      	ldr	r0, [r0, #8]
c0d03aca:	f7fe f93d 	bl	c0d01d48 <pic>
c0d03ace:	4602      	mov	r2, r0
c0d03ad0:	4620      	mov	r0, r4
c0d03ad2:	4629      	mov	r1, r5
c0d03ad4:	4790      	blx	r2
      
      if((req->wLength == 0)&& (ret == USBD_OK))
c0d03ad6:	88e8      	ldrh	r0, [r5, #6]
c0d03ad8:	2800      	cmp	r0, #0
c0d03ada:	d107      	bne.n	c0d03aec <USBD_StdItfReq+0x46>
      {
         USBD_CtlSendStatus(pdev);
c0d03adc:	4620      	mov	r0, r4
c0d03ade:	f000 fa64 	bl	c0d03faa <USBD_CtlSendStatus>
c0d03ae2:	e003      	b.n	c0d03aec <USBD_StdItfReq+0x46>
c0d03ae4:	4620      	mov	r0, r4
c0d03ae6:	4629      	mov	r1, r5
c0d03ae8:	f7ff ffd3 	bl	c0d03a92 <USBD_CtlError>
    
  default:
     USBD_CtlError(pdev , req);
    break;
  }
  return USBD_OK;
c0d03aec:	2000      	movs	r0, #0
c0d03aee:	bdb0      	pop	{r4, r5, r7, pc}

c0d03af0 <USBD_StdEPReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdEPReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d03af0:	b570      	push	{r4, r5, r6, lr}
c0d03af2:	460d      	mov	r5, r1
c0d03af4:	4604      	mov	r4, r0
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d03af6:	7828      	ldrb	r0, [r5, #0]
c0d03af8:	2160      	movs	r1, #96	; 0x60
c0d03afa:	4001      	ands	r1, r0
{
  
  uint8_t   ep_addr;
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
c0d03afc:	792e      	ldrb	r6, [r5, #4]
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d03afe:	2920      	cmp	r1, #32
c0d03b00:	d110      	bne.n	c0d03b24 <USBD_StdEPReq+0x34>
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03b02:	2e02      	cmp	r6, #2
c0d03b04:	d80e      	bhi.n	c0d03b24 <USBD_StdEPReq+0x34>
c0d03b06:	00f0      	lsls	r0, r6, #3
c0d03b08:	1820      	adds	r0, r4, r0
c0d03b0a:	2145      	movs	r1, #69	; 0x45
c0d03b0c:	0089      	lsls	r1, r1, #2
c0d03b0e:	5840      	ldr	r0, [r0, r1]
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d03b10:	2800      	cmp	r0, #0
c0d03b12:	d007      	beq.n	c0d03b24 <USBD_StdEPReq+0x34>
  {
    ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d03b14:	6880      	ldr	r0, [r0, #8]
c0d03b16:	f7fe f917 	bl	c0d01d48 <pic>
c0d03b1a:	4602      	mov	r2, r0
c0d03b1c:	4620      	mov	r0, r4
c0d03b1e:	4629      	mov	r1, r5
c0d03b20:	4790      	blx	r2
c0d03b22:	e06e      	b.n	c0d03c02 <USBD_StdEPReq+0x112>
    
    return USBD_OK;
  }
  
  switch (req->bRequest) 
c0d03b24:	7868      	ldrb	r0, [r5, #1]
c0d03b26:	2800      	cmp	r0, #0
c0d03b28:	d017      	beq.n	c0d03b5a <USBD_StdEPReq+0x6a>
c0d03b2a:	2801      	cmp	r0, #1
c0d03b2c:	d01e      	beq.n	c0d03b6c <USBD_StdEPReq+0x7c>
c0d03b2e:	2803      	cmp	r0, #3
c0d03b30:	d167      	bne.n	c0d03c02 <USBD_StdEPReq+0x112>
  {
    
  case USB_REQ_SET_FEATURE :
    
    switch (pdev->dev_state) 
c0d03b32:	20fc      	movs	r0, #252	; 0xfc
c0d03b34:	5c20      	ldrb	r0, [r4, r0]
c0d03b36:	2803      	cmp	r0, #3
c0d03b38:	d11c      	bne.n	c0d03b74 <USBD_StdEPReq+0x84>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d03b3a:	8868      	ldrh	r0, [r5, #2]
c0d03b3c:	2800      	cmp	r0, #0
c0d03b3e:	d108      	bne.n	c0d03b52 <USBD_StdEPReq+0x62>
      {
        if ((ep_addr != 0x00) && (ep_addr != 0x80)) 
c0d03b40:	2080      	movs	r0, #128	; 0x80
c0d03b42:	4330      	orrs	r0, r6
c0d03b44:	2880      	cmp	r0, #128	; 0x80
c0d03b46:	d004      	beq.n	c0d03b52 <USBD_StdEPReq+0x62>
        { 
          USBD_LL_StallEP(pdev , ep_addr);
c0d03b48:	4620      	mov	r0, r4
c0d03b4a:	4631      	mov	r1, r6
c0d03b4c:	f7ff fb8c 	bl	c0d03268 <USBD_LL_StallEP>
          
        }
c0d03b50:	792e      	ldrb	r6, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03b52:	2e02      	cmp	r6, #2
c0d03b54:	d852      	bhi.n	c0d03bfc <USBD_StdEPReq+0x10c>
c0d03b56:	00f0      	lsls	r0, r6, #3
c0d03b58:	e043      	b.n	c0d03be2 <USBD_StdEPReq+0xf2>
      break;    
    }
    break;
    
  case USB_REQ_GET_STATUS:                  
    switch (pdev->dev_state) 
c0d03b5a:	20fc      	movs	r0, #252	; 0xfc
c0d03b5c:	5c20      	ldrb	r0, [r4, r0]
c0d03b5e:	2803      	cmp	r0, #3
c0d03b60:	d018      	beq.n	c0d03b94 <USBD_StdEPReq+0xa4>
c0d03b62:	2802      	cmp	r0, #2
c0d03b64:	d111      	bne.n	c0d03b8a <USBD_StdEPReq+0x9a>
    {
    case USBD_STATE_ADDRESSED:          
      if ((ep_addr & 0x7F) != 0x00) 
c0d03b66:	0670      	lsls	r0, r6, #25
c0d03b68:	d10a      	bne.n	c0d03b80 <USBD_StdEPReq+0x90>
c0d03b6a:	e04a      	b.n	c0d03c02 <USBD_StdEPReq+0x112>
    }
    break;
    
  case USB_REQ_CLEAR_FEATURE :
    
    switch (pdev->dev_state) 
c0d03b6c:	20fc      	movs	r0, #252	; 0xfc
c0d03b6e:	5c20      	ldrb	r0, [r4, r0]
c0d03b70:	2803      	cmp	r0, #3
c0d03b72:	d029      	beq.n	c0d03bc8 <USBD_StdEPReq+0xd8>
c0d03b74:	2802      	cmp	r0, #2
c0d03b76:	d108      	bne.n	c0d03b8a <USBD_StdEPReq+0x9a>
c0d03b78:	2080      	movs	r0, #128	; 0x80
c0d03b7a:	4330      	orrs	r0, r6
c0d03b7c:	2880      	cmp	r0, #128	; 0x80
c0d03b7e:	d040      	beq.n	c0d03c02 <USBD_StdEPReq+0x112>
c0d03b80:	4620      	mov	r0, r4
c0d03b82:	4631      	mov	r1, r6
c0d03b84:	f7ff fb70 	bl	c0d03268 <USBD_LL_StallEP>
c0d03b88:	e03b      	b.n	c0d03c02 <USBD_StdEPReq+0x112>
c0d03b8a:	4620      	mov	r0, r4
c0d03b8c:	4629      	mov	r1, r5
c0d03b8e:	f7ff ff80 	bl	c0d03a92 <USBD_CtlError>
c0d03b92:	e036      	b.n	c0d03c02 <USBD_StdEPReq+0x112>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d03b94:	4625      	mov	r5, r4
c0d03b96:	3514      	adds	r5, #20
                                         &pdev->ep_out[ep_addr & 0x7F];
c0d03b98:	4620      	mov	r0, r4
c0d03b9a:	3084      	adds	r0, #132	; 0x84
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d03b9c:	2180      	movs	r1, #128	; 0x80
c0d03b9e:	420e      	tst	r6, r1
c0d03ba0:	d100      	bne.n	c0d03ba4 <USBD_StdEPReq+0xb4>
c0d03ba2:	4605      	mov	r5, r0
                                         &pdev->ep_out[ep_addr & 0x7F];
      if(USBD_LL_IsStallEP(pdev, ep_addr))
c0d03ba4:	4620      	mov	r0, r4
c0d03ba6:	4631      	mov	r1, r6
c0d03ba8:	f7ff fba8 	bl	c0d032fc <USBD_LL_IsStallEP>
c0d03bac:	2101      	movs	r1, #1
c0d03bae:	2800      	cmp	r0, #0
c0d03bb0:	d100      	bne.n	c0d03bb4 <USBD_StdEPReq+0xc4>
c0d03bb2:	4601      	mov	r1, r0
c0d03bb4:	207f      	movs	r0, #127	; 0x7f
c0d03bb6:	4006      	ands	r6, r0
c0d03bb8:	0130      	lsls	r0, r6, #4
c0d03bba:	5029      	str	r1, [r5, r0]
c0d03bbc:	1829      	adds	r1, r5, r0
      else
      {
        pep->status = 0x0000;  
      }
      
      USBD_CtlSendData (pdev,
c0d03bbe:	2202      	movs	r2, #2
c0d03bc0:	4620      	mov	r0, r4
c0d03bc2:	f000 f9c7 	bl	c0d03f54 <USBD_CtlSendData>
c0d03bc6:	e01c      	b.n	c0d03c02 <USBD_StdEPReq+0x112>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d03bc8:	8868      	ldrh	r0, [r5, #2]
c0d03bca:	2800      	cmp	r0, #0
c0d03bcc:	d119      	bne.n	c0d03c02 <USBD_StdEPReq+0x112>
      {
        if ((ep_addr & 0x7F) != 0x00) 
c0d03bce:	0670      	lsls	r0, r6, #25
c0d03bd0:	d014      	beq.n	c0d03bfc <USBD_StdEPReq+0x10c>
        {        
          USBD_LL_ClearStallEP(pdev , ep_addr);
c0d03bd2:	4620      	mov	r0, r4
c0d03bd4:	4631      	mov	r1, r6
c0d03bd6:	f7ff fb6d 	bl	c0d032b4 <USBD_LL_ClearStallEP>
          if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d03bda:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d03bdc:	2802      	cmp	r0, #2
c0d03bde:	d80d      	bhi.n	c0d03bfc <USBD_StdEPReq+0x10c>
c0d03be0:	00c0      	lsls	r0, r0, #3
c0d03be2:	1820      	adds	r0, r4, r0
c0d03be4:	2145      	movs	r1, #69	; 0x45
c0d03be6:	0089      	lsls	r1, r1, #2
c0d03be8:	5840      	ldr	r0, [r0, r1]
c0d03bea:	2800      	cmp	r0, #0
c0d03bec:	d006      	beq.n	c0d03bfc <USBD_StdEPReq+0x10c>
c0d03bee:	6880      	ldr	r0, [r0, #8]
c0d03bf0:	f7fe f8aa 	bl	c0d01d48 <pic>
c0d03bf4:	4602      	mov	r2, r0
c0d03bf6:	4620      	mov	r0, r4
c0d03bf8:	4629      	mov	r1, r5
c0d03bfa:	4790      	blx	r2
c0d03bfc:	4620      	mov	r0, r4
c0d03bfe:	f000 f9d4 	bl	c0d03faa <USBD_CtlSendStatus>
    
  default:
    break;
  }
  return ret;
}
c0d03c02:	2000      	movs	r0, #0
c0d03c04:	bd70      	pop	{r4, r5, r6, pc}

c0d03c06 <USBD_ParseSetupRequest>:
* @retval None
*/

void USBD_ParseSetupRequest(USBD_SetupReqTypedef *req, uint8_t *pdata)
{
  req->bmRequest     = *(uint8_t *)  (pdata);
c0d03c06:	780a      	ldrb	r2, [r1, #0]
c0d03c08:	7002      	strb	r2, [r0, #0]
  req->bRequest      = *(uint8_t *)  (pdata +  1);
c0d03c0a:	784a      	ldrb	r2, [r1, #1]
c0d03c0c:	7042      	strb	r2, [r0, #1]
  req->wValue        = SWAPBYTE      (pdata +  2);
c0d03c0e:	788a      	ldrb	r2, [r1, #2]
c0d03c10:	78cb      	ldrb	r3, [r1, #3]
c0d03c12:	021b      	lsls	r3, r3, #8
c0d03c14:	4313      	orrs	r3, r2
c0d03c16:	8043      	strh	r3, [r0, #2]
  req->wIndex        = SWAPBYTE      (pdata +  4);
c0d03c18:	790a      	ldrb	r2, [r1, #4]
c0d03c1a:	794b      	ldrb	r3, [r1, #5]
c0d03c1c:	021b      	lsls	r3, r3, #8
c0d03c1e:	4313      	orrs	r3, r2
c0d03c20:	8083      	strh	r3, [r0, #4]
  req->wLength       = SWAPBYTE      (pdata +  6);
c0d03c22:	798a      	ldrb	r2, [r1, #6]
c0d03c24:	79c9      	ldrb	r1, [r1, #7]
c0d03c26:	0209      	lsls	r1, r1, #8
c0d03c28:	4311      	orrs	r1, r2
c0d03c2a:	80c1      	strh	r1, [r0, #6]

}
c0d03c2c:	4770      	bx	lr

c0d03c2e <USBD_HID_Setup>:
  * @param  req: usb requests
  * @retval status
  */
uint8_t  USBD_HID_Setup (USBD_HandleTypeDef *pdev, 
                                USBD_SetupReqTypedef *req)
{
c0d03c2e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03c30:	b083      	sub	sp, #12
c0d03c32:	460d      	mov	r5, r1
c0d03c34:	4604      	mov	r4, r0
c0d03c36:	a802      	add	r0, sp, #8
c0d03c38:	2700      	movs	r7, #0
  uint16_t len = 0;
c0d03c3a:	8007      	strh	r7, [r0, #0]
c0d03c3c:	a801      	add	r0, sp, #4
  uint8_t  *pbuf = NULL;

  uint8_t val = 0;
c0d03c3e:	7007      	strb	r7, [r0, #0]

  switch (req->bmRequest & USB_REQ_TYPE_MASK)
c0d03c40:	7829      	ldrb	r1, [r5, #0]
c0d03c42:	2060      	movs	r0, #96	; 0x60
c0d03c44:	4008      	ands	r0, r1
c0d03c46:	2800      	cmp	r0, #0
c0d03c48:	d010      	beq.n	c0d03c6c <USBD_HID_Setup+0x3e>
c0d03c4a:	2820      	cmp	r0, #32
c0d03c4c:	d138      	bne.n	c0d03cc0 <USBD_HID_Setup+0x92>
c0d03c4e:	7868      	ldrb	r0, [r5, #1]
  {
  case USB_REQ_TYPE_CLASS :  
    switch (req->bRequest)
c0d03c50:	4601      	mov	r1, r0
c0d03c52:	390a      	subs	r1, #10
c0d03c54:	2902      	cmp	r1, #2
c0d03c56:	d333      	bcc.n	c0d03cc0 <USBD_HID_Setup+0x92>
c0d03c58:	2802      	cmp	r0, #2
c0d03c5a:	d01c      	beq.n	c0d03c96 <USBD_HID_Setup+0x68>
c0d03c5c:	2803      	cmp	r0, #3
c0d03c5e:	d01a      	beq.n	c0d03c96 <USBD_HID_Setup+0x68>
                        (uint8_t *)&val,
                        1);      
      break;      
      
    default:
      USBD_CtlError (pdev, req);
c0d03c60:	4620      	mov	r0, r4
c0d03c62:	4629      	mov	r1, r5
c0d03c64:	f7ff ff15 	bl	c0d03a92 <USBD_CtlError>
c0d03c68:	2702      	movs	r7, #2
c0d03c6a:	e029      	b.n	c0d03cc0 <USBD_HID_Setup+0x92>
      return USBD_FAIL; 
    }
    break;
    
  case USB_REQ_TYPE_STANDARD:
    switch (req->bRequest)
c0d03c6c:	7868      	ldrb	r0, [r5, #1]
c0d03c6e:	280b      	cmp	r0, #11
c0d03c70:	d014      	beq.n	c0d03c9c <USBD_HID_Setup+0x6e>
c0d03c72:	280a      	cmp	r0, #10
c0d03c74:	d00f      	beq.n	c0d03c96 <USBD_HID_Setup+0x68>
c0d03c76:	2806      	cmp	r0, #6
c0d03c78:	d122      	bne.n	c0d03cc0 <USBD_HID_Setup+0x92>
    {
    case USB_REQ_GET_DESCRIPTOR: 
      // 0x22
      if( req->wValue >> 8 == HID_REPORT_DESC)
c0d03c7a:	8868      	ldrh	r0, [r5, #2]
c0d03c7c:	0a00      	lsrs	r0, r0, #8
c0d03c7e:	2700      	movs	r7, #0
c0d03c80:	2821      	cmp	r0, #33	; 0x21
c0d03c82:	d00f      	beq.n	c0d03ca4 <USBD_HID_Setup+0x76>
c0d03c84:	2822      	cmp	r0, #34	; 0x22
      
      //USBD_CtlReceiveStatus(pdev);
      
      USBD_CtlSendData (pdev, 
                        pbuf,
                        len);
c0d03c86:	463a      	mov	r2, r7
c0d03c88:	4639      	mov	r1, r7
c0d03c8a:	d116      	bne.n	c0d03cba <USBD_HID_Setup+0x8c>
c0d03c8c:	ae02      	add	r6, sp, #8
    {
    case USB_REQ_GET_DESCRIPTOR: 
      // 0x22
      if( req->wValue >> 8 == HID_REPORT_DESC)
      {
        pbuf =  USBD_HID_GetReportDescriptor_impl(&len);
c0d03c8e:	4630      	mov	r0, r6
c0d03c90:	f000 f858 	bl	c0d03d44 <USBD_HID_GetReportDescriptor_impl>
c0d03c94:	e00a      	b.n	c0d03cac <USBD_HID_Setup+0x7e>
c0d03c96:	a901      	add	r1, sp, #4
c0d03c98:	2201      	movs	r2, #1
c0d03c9a:	e00e      	b.n	c0d03cba <USBD_HID_Setup+0x8c>
                        len);
      break;

    case USB_REQ_SET_INTERFACE :
      //hhid->AltSetting = (uint8_t)(req->wValue);
      USBD_CtlSendStatus(pdev);
c0d03c9c:	4620      	mov	r0, r4
c0d03c9e:	f000 f984 	bl	c0d03faa <USBD_CtlSendStatus>
c0d03ca2:	e00d      	b.n	c0d03cc0 <USBD_HID_Setup+0x92>
c0d03ca4:	ae02      	add	r6, sp, #8
        len = MIN(len , req->wLength);
      }
      // 0x21
      else if( req->wValue >> 8 == HID_DESCRIPTOR_TYPE)
      {
        pbuf = USBD_HID_GetHidDescriptor_impl(&len);
c0d03ca6:	4630      	mov	r0, r6
c0d03ca8:	f000 f832 	bl	c0d03d10 <USBD_HID_GetHidDescriptor_impl>
c0d03cac:	4601      	mov	r1, r0
c0d03cae:	8832      	ldrh	r2, [r6, #0]
c0d03cb0:	88e8      	ldrh	r0, [r5, #6]
c0d03cb2:	4282      	cmp	r2, r0
c0d03cb4:	d300      	bcc.n	c0d03cb8 <USBD_HID_Setup+0x8a>
c0d03cb6:	4602      	mov	r2, r0
c0d03cb8:	8032      	strh	r2, [r6, #0]
c0d03cba:	4620      	mov	r0, r4
c0d03cbc:	f000 f94a 	bl	c0d03f54 <USBD_CtlSendData>
      
    }
  }

  return USBD_OK;
}
c0d03cc0:	b2f8      	uxtb	r0, r7
c0d03cc2:	b003      	add	sp, #12
c0d03cc4:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d03cc6 <USBD_HID_Init>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_Init (USBD_HandleTypeDef *pdev, 
                               uint8_t cfgidx)
{
c0d03cc6:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03cc8:	b081      	sub	sp, #4
c0d03cca:	4604      	mov	r4, r0
  UNUSED(cfgidx);

  /* Open EP IN */
  USBD_LL_OpenEP(pdev,
c0d03ccc:	2182      	movs	r1, #130	; 0x82
c0d03cce:	2603      	movs	r6, #3
c0d03cd0:	2540      	movs	r5, #64	; 0x40
c0d03cd2:	4632      	mov	r2, r6
c0d03cd4:	462b      	mov	r3, r5
c0d03cd6:	f7ff fa8b 	bl	c0d031f0 <USBD_LL_OpenEP>
c0d03cda:	2702      	movs	r7, #2
                 HID_EPIN_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPIN_SIZE);
  
  /* Open EP OUT */
  USBD_LL_OpenEP(pdev,
c0d03cdc:	4620      	mov	r0, r4
c0d03cde:	4639      	mov	r1, r7
c0d03ce0:	4632      	mov	r2, r6
c0d03ce2:	462b      	mov	r3, r5
c0d03ce4:	f7ff fa84 	bl	c0d031f0 <USBD_LL_OpenEP>
                 HID_EPOUT_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPOUT_SIZE);

        /* Prepare Out endpoint to receive 1st packet */ 
  USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR, HID_EPOUT_SIZE);
c0d03ce8:	4620      	mov	r0, r4
c0d03cea:	4639      	mov	r1, r7
c0d03cec:	462a      	mov	r2, r5
c0d03cee:	f7ff fb42 	bl	c0d03376 <USBD_LL_PrepareReceive>
  USBD_LL_Transmit (pdev, 
                    HID_EPIN_ADDR,                                      
                    NULL,
                    0);
  */
  return USBD_OK;
c0d03cf2:	2000      	movs	r0, #0
c0d03cf4:	b001      	add	sp, #4
c0d03cf6:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d03cf8 <USBD_HID_DeInit>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_DeInit (USBD_HandleTypeDef *pdev, 
                                 uint8_t cfgidx)
{
c0d03cf8:	b510      	push	{r4, lr}
c0d03cfa:	4604      	mov	r4, r0
  UNUSED(cfgidx);
  /* Close HID EP IN */
  USBD_LL_CloseEP(pdev,
c0d03cfc:	2182      	movs	r1, #130	; 0x82
c0d03cfe:	f7ff fa9d 	bl	c0d0323c <USBD_LL_CloseEP>
                  HID_EPIN_ADDR);
  
  /* Close HID EP OUT */
  USBD_LL_CloseEP(pdev,
c0d03d02:	2102      	movs	r1, #2
c0d03d04:	4620      	mov	r0, r4
c0d03d06:	f7ff fa99 	bl	c0d0323c <USBD_LL_CloseEP>
                  HID_EPOUT_ADDR);
  
  return USBD_OK;
c0d03d0a:	2000      	movs	r0, #0
c0d03d0c:	bd10      	pop	{r4, pc}
	...

c0d03d10 <USBD_HID_GetHidDescriptor_impl>:
  *length = sizeof (USBD_CfgDesc);
  return (uint8_t*)USBD_CfgDesc;
}

uint8_t* USBD_HID_GetHidDescriptor_impl(uint16_t* len) {
  switch (USBD_Device.request.wIndex&0xFF) {
c0d03d10:	2143      	movs	r1, #67	; 0x43
c0d03d12:	0089      	lsls	r1, r1, #2
c0d03d14:	4a08      	ldr	r2, [pc, #32]	; (c0d03d38 <USBD_HID_GetHidDescriptor_impl+0x28>)
c0d03d16:	5c51      	ldrb	r1, [r2, r1]
c0d03d18:	2209      	movs	r2, #9
c0d03d1a:	2900      	cmp	r1, #0
c0d03d1c:	d004      	beq.n	c0d03d28 <USBD_HID_GetHidDescriptor_impl+0x18>
c0d03d1e:	2901      	cmp	r1, #1
c0d03d20:	d105      	bne.n	c0d03d2e <USBD_HID_GetHidDescriptor_impl+0x1e>
c0d03d22:	4907      	ldr	r1, [pc, #28]	; (c0d03d40 <USBD_HID_GetHidDescriptor_impl+0x30>)
c0d03d24:	4479      	add	r1, pc
c0d03d26:	e004      	b.n	c0d03d32 <USBD_HID_GetHidDescriptor_impl+0x22>
c0d03d28:	4904      	ldr	r1, [pc, #16]	; (c0d03d3c <USBD_HID_GetHidDescriptor_impl+0x2c>)
c0d03d2a:	4479      	add	r1, pc
c0d03d2c:	e001      	b.n	c0d03d32 <USBD_HID_GetHidDescriptor_impl+0x22>
c0d03d2e:	2200      	movs	r2, #0
c0d03d30:	4611      	mov	r1, r2
c0d03d32:	8002      	strh	r2, [r0, #0]
      *len = sizeof(USBD_HID_Desc);
      return (uint8_t*)USBD_HID_Desc; 
  }
  *len = 0;
  return 0;
}
c0d03d34:	4608      	mov	r0, r1
c0d03d36:	4770      	bx	lr
c0d03d38:	20002070 	.word	0x20002070
c0d03d3c:	000012be 	.word	0x000012be
c0d03d40:	000012b8 	.word	0x000012b8

c0d03d44 <USBD_HID_GetReportDescriptor_impl>:

uint8_t* USBD_HID_GetReportDescriptor_impl(uint16_t* len) {
c0d03d44:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03d46:	b081      	sub	sp, #4
c0d03d48:	4602      	mov	r2, r0
  switch (USBD_Device.request.wIndex&0xFF) {
c0d03d4a:	2043      	movs	r0, #67	; 0x43
c0d03d4c:	0080      	lsls	r0, r0, #2
c0d03d4e:	4914      	ldr	r1, [pc, #80]	; (c0d03da0 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d03d50:	5c08      	ldrb	r0, [r1, r0]
c0d03d52:	2422      	movs	r4, #34	; 0x22
c0d03d54:	2800      	cmp	r0, #0
c0d03d56:	d01a      	beq.n	c0d03d8e <USBD_HID_GetReportDescriptor_impl+0x4a>
c0d03d58:	2801      	cmp	r0, #1
c0d03d5a:	d11b      	bne.n	c0d03d94 <USBD_HID_GetReportDescriptor_impl+0x50>
#ifdef HAVE_IO_U2F
  case U2F_INTF:

    // very dirty work due to lack of callback when USB_HID_Init is called
    USBD_LL_OpenEP(&USBD_Device,
c0d03d5c:	4810      	ldr	r0, [pc, #64]	; (c0d03da0 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d03d5e:	2181      	movs	r1, #129	; 0x81
c0d03d60:	2703      	movs	r7, #3
c0d03d62:	2640      	movs	r6, #64	; 0x40
c0d03d64:	9200      	str	r2, [sp, #0]
c0d03d66:	463a      	mov	r2, r7
c0d03d68:	4633      	mov	r3, r6
c0d03d6a:	f7ff fa41 	bl	c0d031f0 <USBD_LL_OpenEP>
c0d03d6e:	2501      	movs	r5, #1
                   U2F_EPIN_ADDR,
                   USBD_EP_TYPE_INTR,
                   U2F_EPIN_SIZE);
    
    USBD_LL_OpenEP(&USBD_Device,
c0d03d70:	480b      	ldr	r0, [pc, #44]	; (c0d03da0 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d03d72:	4629      	mov	r1, r5
c0d03d74:	463a      	mov	r2, r7
c0d03d76:	4633      	mov	r3, r6
c0d03d78:	f7ff fa3a 	bl	c0d031f0 <USBD_LL_OpenEP>
                   U2F_EPOUT_ADDR,
                   USBD_EP_TYPE_INTR,
                   U2F_EPOUT_SIZE);

    /* Prepare Out endpoint to receive 1st packet */ 
    USBD_LL_PrepareReceive(&USBD_Device, U2F_EPOUT_ADDR, U2F_EPOUT_SIZE);
c0d03d7c:	4808      	ldr	r0, [pc, #32]	; (c0d03da0 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d03d7e:	4629      	mov	r1, r5
c0d03d80:	4632      	mov	r2, r6
c0d03d82:	f7ff faf8 	bl	c0d03376 <USBD_LL_PrepareReceive>
c0d03d86:	9a00      	ldr	r2, [sp, #0]
c0d03d88:	4807      	ldr	r0, [pc, #28]	; (c0d03da8 <USBD_HID_GetReportDescriptor_impl+0x64>)
c0d03d8a:	4478      	add	r0, pc
c0d03d8c:	e004      	b.n	c0d03d98 <USBD_HID_GetReportDescriptor_impl+0x54>
c0d03d8e:	4805      	ldr	r0, [pc, #20]	; (c0d03da4 <USBD_HID_GetReportDescriptor_impl+0x60>)
c0d03d90:	4478      	add	r0, pc
c0d03d92:	e001      	b.n	c0d03d98 <USBD_HID_GetReportDescriptor_impl+0x54>
c0d03d94:	2400      	movs	r4, #0
c0d03d96:	4620      	mov	r0, r4
c0d03d98:	8014      	strh	r4, [r2, #0]
    *len = sizeof(HID_ReportDesc);
    return (uint8_t*)HID_ReportDesc;
  }
  *len = 0;
  return 0;
}
c0d03d9a:	b001      	add	sp, #4
c0d03d9c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03d9e:	46c0      	nop			; (mov r8, r8)
c0d03da0:	20002070 	.word	0x20002070
c0d03da4:	00001283 	.word	0x00001283
c0d03da8:	00001267 	.word	0x00001267

c0d03dac <USBD_U2F_DataIn_impl>:
extern volatile unsigned short G_io_apdu_length;

#ifdef HAVE_IO_U2F
uint8_t  USBD_U2F_DataIn_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum)
{
c0d03dac:	b580      	push	{r7, lr}
  UNUSED(pdev);
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d03dae:	2901      	cmp	r1, #1
c0d03db0:	d103      	bne.n	c0d03dba <USBD_U2F_DataIn_impl+0xe>
  // FIDO endpoint
  case (U2F_EPIN_ADDR&0x7F):
    // advance the u2f sending machine state
    u2f_transport_sent(&G_io_u2f, U2F_MEDIA_USB);
c0d03db2:	4803      	ldr	r0, [pc, #12]	; (c0d03dc0 <USBD_U2F_DataIn_impl+0x14>)
c0d03db4:	2101      	movs	r1, #1
c0d03db6:	f7fe faa9 	bl	c0d0230c <u2f_transport_sent>
    break;
  } 
  return USBD_OK;
c0d03dba:	2000      	movs	r0, #0
c0d03dbc:	bd80      	pop	{r7, pc}
c0d03dbe:	46c0      	nop			; (mov r8, r8)
c0d03dc0:	20001a78 	.word	0x20001a78

c0d03dc4 <USBD_U2F_DataOut_impl>:
}

uint8_t  USBD_U2F_DataOut_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d03dc4:	b5b0      	push	{r4, r5, r7, lr}
c0d03dc6:	4614      	mov	r4, r2
  switch (epnum) {
c0d03dc8:	2901      	cmp	r1, #1
c0d03dca:	d10d      	bne.n	c0d03de8 <USBD_U2F_DataOut_impl+0x24>
c0d03dcc:	2501      	movs	r5, #1
  // FIDO endpoint
  case (U2F_EPOUT_ADDR&0x7F):
      USBD_LL_PrepareReceive(pdev, U2F_EPOUT_ADDR , U2F_EPOUT_SIZE);
c0d03dce:	2240      	movs	r2, #64	; 0x40
c0d03dd0:	4629      	mov	r1, r5
c0d03dd2:	f7ff fad0 	bl	c0d03376 <USBD_LL_PrepareReceive>
      u2f_transport_received(&G_io_u2f, buffer, io_seproxyhal_get_ep_rx_size(U2F_EPOUT_ADDR), U2F_MEDIA_USB);
c0d03dd6:	4628      	mov	r0, r5
c0d03dd8:	f7fd f9ce 	bl	c0d01178 <io_seproxyhal_get_ep_rx_size>
c0d03ddc:	4602      	mov	r2, r0
c0d03dde:	4803      	ldr	r0, [pc, #12]	; (c0d03dec <USBD_U2F_DataOut_impl+0x28>)
c0d03de0:	4621      	mov	r1, r4
c0d03de2:	462b      	mov	r3, r5
c0d03de4:	f7fe faf4 	bl	c0d023d0 <u2f_transport_received>
    break;
  }

  return USBD_OK;
c0d03de8:	2000      	movs	r0, #0
c0d03dea:	bdb0      	pop	{r4, r5, r7, pc}
c0d03dec:	20001a78 	.word	0x20001a78

c0d03df0 <USBD_HID_DataOut_impl>:
}
#endif // HAVE_IO_U2F

uint8_t  USBD_HID_DataOut_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d03df0:	b5b0      	push	{r4, r5, r7, lr}
c0d03df2:	4614      	mov	r4, r2
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d03df4:	2902      	cmp	r1, #2
c0d03df6:	d11b      	bne.n	c0d03e30 <USBD_HID_DataOut_impl+0x40>

  // HID gen endpoint
  case (HID_EPOUT_ADDR&0x7F):
    // prepare receiving the next chunk (masked time)
    USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR , HID_EPOUT_SIZE);
c0d03df8:	2102      	movs	r1, #2
c0d03dfa:	2240      	movs	r2, #64	; 0x40
c0d03dfc:	f7ff fabb 	bl	c0d03376 <USBD_LL_PrepareReceive>

    // avoid troubles when an apdu has not been replied yet
    if (G_io_apdu_media == IO_APDU_MEDIA_NONE) {      
c0d03e00:	4d0c      	ldr	r5, [pc, #48]	; (c0d03e34 <USBD_HID_DataOut_impl+0x44>)
c0d03e02:	7828      	ldrb	r0, [r5, #0]
c0d03e04:	2800      	cmp	r0, #0
c0d03e06:	d113      	bne.n	c0d03e30 <USBD_HID_DataOut_impl+0x40>
      // add to the hid transport
      switch(io_usb_hid_receive(io_usb_send_apdu_data, buffer, io_seproxyhal_get_ep_rx_size(HID_EPOUT_ADDR))) {
c0d03e08:	2002      	movs	r0, #2
c0d03e0a:	f7fd f9b5 	bl	c0d01178 <io_seproxyhal_get_ep_rx_size>
c0d03e0e:	4602      	mov	r2, r0
c0d03e10:	480c      	ldr	r0, [pc, #48]	; (c0d03e44 <USBD_HID_DataOut_impl+0x54>)
c0d03e12:	4478      	add	r0, pc
c0d03e14:	4621      	mov	r1, r4
c0d03e16:	f7fc fffb 	bl	c0d00e10 <io_usb_hid_receive>
c0d03e1a:	2802      	cmp	r0, #2
c0d03e1c:	d108      	bne.n	c0d03e30 <USBD_HID_DataOut_impl+0x40>
        default:
          break;

        case IO_USB_APDU_RECEIVED:
          G_io_apdu_media = IO_APDU_MEDIA_USB_HID; // for application code
c0d03e1e:	2001      	movs	r0, #1
c0d03e20:	7028      	strb	r0, [r5, #0]
          G_io_apdu_state = APDU_USB_HID; // for next call to io_exchange
c0d03e22:	4805      	ldr	r0, [pc, #20]	; (c0d03e38 <USBD_HID_DataOut_impl+0x48>)
c0d03e24:	2107      	movs	r1, #7
c0d03e26:	7001      	strb	r1, [r0, #0]
          G_io_apdu_length = G_io_usb_hid_total_length;
c0d03e28:	4804      	ldr	r0, [pc, #16]	; (c0d03e3c <USBD_HID_DataOut_impl+0x4c>)
c0d03e2a:	6800      	ldr	r0, [r0, #0]
c0d03e2c:	4904      	ldr	r1, [pc, #16]	; (c0d03e40 <USBD_HID_DataOut_impl+0x50>)
c0d03e2e:	8008      	strh	r0, [r1, #0]
      }
    }
    break;
  }

  return USBD_OK;
c0d03e30:	2000      	movs	r0, #0
c0d03e32:	bdb0      	pop	{r4, r5, r7, pc}
c0d03e34:	20001a5c 	.word	0x20001a5c
c0d03e38:	20001a64 	.word	0x20001a64
c0d03e3c:	200018f0 	.word	0x200018f0
c0d03e40:	20001a66 	.word	0x20001a66
c0d03e44:	ffffd4db 	.word	0xffffd4db

c0d03e48 <USBD_DeviceDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_DeviceDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_DeviceDesc);
c0d03e48:	2012      	movs	r0, #18
c0d03e4a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_DeviceDesc;
c0d03e4c:	4801      	ldr	r0, [pc, #4]	; (c0d03e54 <USBD_DeviceDescriptor+0xc>)
c0d03e4e:	4478      	add	r0, pc
c0d03e50:	4770      	bx	lr
c0d03e52:	46c0      	nop			; (mov r8, r8)
c0d03e54:	0000127a 	.word	0x0000127a

c0d03e58 <USBD_LangIDStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_LangIDStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_LangIDDesc);  
c0d03e58:	2004      	movs	r0, #4
c0d03e5a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_LangIDDesc;
c0d03e5c:	4801      	ldr	r0, [pc, #4]	; (c0d03e64 <USBD_LangIDStrDescriptor+0xc>)
c0d03e5e:	4478      	add	r0, pc
c0d03e60:	4770      	bx	lr
c0d03e62:	46c0      	nop			; (mov r8, r8)
c0d03e64:	0000127c 	.word	0x0000127c

c0d03e68 <USBD_ManufacturerStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ManufacturerStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_MANUFACTURER_STRING);
c0d03e68:	200e      	movs	r0, #14
c0d03e6a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_MANUFACTURER_STRING;
c0d03e6c:	4801      	ldr	r0, [pc, #4]	; (c0d03e74 <USBD_ManufacturerStrDescriptor+0xc>)
c0d03e6e:	4478      	add	r0, pc
c0d03e70:	4770      	bx	lr
c0d03e72:	46c0      	nop			; (mov r8, r8)
c0d03e74:	00001270 	.word	0x00001270

c0d03e78 <USBD_ProductStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ProductStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_PRODUCT_FS_STRING);
c0d03e78:	200e      	movs	r0, #14
c0d03e7a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_PRODUCT_FS_STRING;
c0d03e7c:	4801      	ldr	r0, [pc, #4]	; (c0d03e84 <USBD_ProductStrDescriptor+0xc>)
c0d03e7e:	4478      	add	r0, pc
c0d03e80:	4770      	bx	lr
c0d03e82:	46c0      	nop			; (mov r8, r8)
c0d03e84:	0000126e 	.word	0x0000126e

c0d03e88 <USBD_SerialStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_SerialStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USB_SERIAL_STRING);
c0d03e88:	200a      	movs	r0, #10
c0d03e8a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USB_SERIAL_STRING;
c0d03e8c:	4801      	ldr	r0, [pc, #4]	; (c0d03e94 <USBD_SerialStrDescriptor+0xc>)
c0d03e8e:	4478      	add	r0, pc
c0d03e90:	4770      	bx	lr
c0d03e92:	46c0      	nop			; (mov r8, r8)
c0d03e94:	0000126c 	.word	0x0000126c

c0d03e98 <USBD_ConfigStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ConfigStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_CONFIGURATION_FS_STRING);
c0d03e98:	200e      	movs	r0, #14
c0d03e9a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_CONFIGURATION_FS_STRING;
c0d03e9c:	4801      	ldr	r0, [pc, #4]	; (c0d03ea4 <USBD_ConfigStrDescriptor+0xc>)
c0d03e9e:	4478      	add	r0, pc
c0d03ea0:	4770      	bx	lr
c0d03ea2:	46c0      	nop			; (mov r8, r8)
c0d03ea4:	0000124e 	.word	0x0000124e

c0d03ea8 <USBD_InterfaceStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_InterfaceStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_INTERFACE_FS_STRING);
c0d03ea8:	200e      	movs	r0, #14
c0d03eaa:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_INTERFACE_FS_STRING;
c0d03eac:	4801      	ldr	r0, [pc, #4]	; (c0d03eb4 <USBD_InterfaceStrDescriptor+0xc>)
c0d03eae:	4478      	add	r0, pc
c0d03eb0:	4770      	bx	lr
c0d03eb2:	46c0      	nop			; (mov r8, r8)
c0d03eb4:	0000123e 	.word	0x0000123e

c0d03eb8 <USB_power>:
  // nothing to do ?
  return 0;
}
#endif // HAVE_USB_CLASS_CCID

void USB_power(unsigned char enabled) {
c0d03eb8:	b570      	push	{r4, r5, r6, lr}
c0d03eba:	4604      	mov	r4, r0
c0d03ebc:	204d      	movs	r0, #77	; 0x4d
c0d03ebe:	0085      	lsls	r5, r0, #2
  os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d03ec0:	4816      	ldr	r0, [pc, #88]	; (c0d03f1c <USB_power+0x64>)
c0d03ec2:	2100      	movs	r1, #0
c0d03ec4:	462a      	mov	r2, r5
c0d03ec6:	f7fd f84b 	bl	c0d00f60 <os_memset>

  if (enabled) {
c0d03eca:	2c00      	cmp	r4, #0
c0d03ecc:	d022      	beq.n	c0d03f14 <USB_power+0x5c>
    os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d03ece:	4c13      	ldr	r4, [pc, #76]	; (c0d03f1c <USB_power+0x64>)
c0d03ed0:	2600      	movs	r6, #0
c0d03ed2:	4620      	mov	r0, r4
c0d03ed4:	4631      	mov	r1, r6
c0d03ed6:	462a      	mov	r2, r5
c0d03ed8:	f7fd f842 	bl	c0d00f60 <os_memset>
    /* Init Device Library */
    USBD_Init(&USBD_Device, (USBD_DescriptorsTypeDef*)&HID_Desc, 0);
c0d03edc:	4912      	ldr	r1, [pc, #72]	; (c0d03f28 <USB_power+0x70>)
c0d03ede:	4479      	add	r1, pc
c0d03ee0:	4620      	mov	r0, r4
c0d03ee2:	4632      	mov	r2, r6
c0d03ee4:	f7ff fa5a 	bl	c0d0339c <USBD_Init>
    
    /* Register the HID class */
    USBD_RegisterClassForInterface(HID_INTF,  &USBD_Device, (USBD_ClassTypeDef*)&USBD_HID);
c0d03ee8:	4a10      	ldr	r2, [pc, #64]	; (c0d03f2c <USB_power+0x74>)
c0d03eea:	447a      	add	r2, pc
c0d03eec:	4630      	mov	r0, r6
c0d03eee:	4621      	mov	r1, r4
c0d03ef0:	f7ff fa8e 	bl	c0d03410 <USBD_RegisterClassForInterface>
#ifdef HAVE_IO_U2F
    USBD_RegisterClassForInterface(U2F_INTF,  &USBD_Device, (USBD_ClassTypeDef*)&USBD_U2F);
c0d03ef4:	2001      	movs	r0, #1
c0d03ef6:	4a0e      	ldr	r2, [pc, #56]	; (c0d03f30 <USB_power+0x78>)
c0d03ef8:	447a      	add	r2, pc
c0d03efa:	4621      	mov	r1, r4
c0d03efc:	f7ff fa88 	bl	c0d03410 <USBD_RegisterClassForInterface>
    // initialize the U2F tunnel transport
    u2f_transport_init(&G_io_u2f, G_io_apdu_buffer, IO_APDU_BUFFER_SIZE);
c0d03f00:	22ff      	movs	r2, #255	; 0xff
c0d03f02:	3252      	adds	r2, #82	; 0x52
c0d03f04:	4806      	ldr	r0, [pc, #24]	; (c0d03f20 <USB_power+0x68>)
c0d03f06:	4907      	ldr	r1, [pc, #28]	; (c0d03f24 <USB_power+0x6c>)
c0d03f08:	f7fe f9f6 	bl	c0d022f8 <u2f_transport_init>
    USBD_RegisterClassForInterface(CCID_INTF, &USBD_Device, (USBD_ClassTypeDef*)&USBD_CCID);
#endif // HAVE_USB_CLASS_CCID


    /* Start Device Process */
    USBD_Start(&USBD_Device);
c0d03f0c:	4620      	mov	r0, r4
c0d03f0e:	f7ff fa8c 	bl	c0d0342a <USBD_Start>
  }
  else {
    USBD_DeInit(&USBD_Device);
  }
}
c0d03f12:	bd70      	pop	{r4, r5, r6, pc}

    /* Start Device Process */
    USBD_Start(&USBD_Device);
  }
  else {
    USBD_DeInit(&USBD_Device);
c0d03f14:	4801      	ldr	r0, [pc, #4]	; (c0d03f1c <USB_power+0x64>)
c0d03f16:	f7ff fa5c 	bl	c0d033d2 <USBD_DeInit>
  }
}
c0d03f1a:	bd70      	pop	{r4, r5, r6, pc}
c0d03f1c:	20002070 	.word	0x20002070
c0d03f20:	20001a78 	.word	0x20001a78
c0d03f24:	200018f8 	.word	0x200018f8
c0d03f28:	0000115a 	.word	0x0000115a
c0d03f2c:	0000116e 	.word	0x0000116e
c0d03f30:	00001198 	.word	0x00001198

c0d03f34 <USBD_GetCfgDesc_impl>:
  * @param  length : pointer data length
  * @retval pointer to descriptor buffer
  */
static uint8_t  *USBD_GetCfgDesc_impl (uint16_t *length)
{
  *length = sizeof (USBD_CfgDesc);
c0d03f34:	2149      	movs	r1, #73	; 0x49
c0d03f36:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_CfgDesc;
c0d03f38:	4801      	ldr	r0, [pc, #4]	; (c0d03f40 <USBD_GetCfgDesc_impl+0xc>)
c0d03f3a:	4478      	add	r0, pc
c0d03f3c:	4770      	bx	lr
c0d03f3e:	46c0      	nop			; (mov r8, r8)
c0d03f40:	000011ca 	.word	0x000011ca

c0d03f44 <USBD_GetDeviceQualifierDesc_impl>:
* @param  length : pointer data length
* @retval pointer to descriptor buffer
*/
static uint8_t  *USBD_GetDeviceQualifierDesc_impl (uint16_t *length)
{
  *length = sizeof (USBD_DeviceQualifierDesc);
c0d03f44:	210a      	movs	r1, #10
c0d03f46:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_DeviceQualifierDesc;
c0d03f48:	4801      	ldr	r0, [pc, #4]	; (c0d03f50 <USBD_GetDeviceQualifierDesc_impl+0xc>)
c0d03f4a:	4478      	add	r0, pc
c0d03f4c:	4770      	bx	lr
c0d03f4e:	46c0      	nop			; (mov r8, r8)
c0d03f50:	00001206 	.word	0x00001206

c0d03f54 <USBD_CtlSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendData (USBD_HandleTypeDef  *pdev, 
                               uint8_t *pbuf,
                               uint16_t len)
{
c0d03f54:	b5b0      	push	{r4, r5, r7, lr}
c0d03f56:	460c      	mov	r4, r1
  /* Set EP0 State */
  pdev->ep0_state          = USBD_EP0_DATA_IN;                                      
c0d03f58:	21f4      	movs	r1, #244	; 0xf4
c0d03f5a:	2302      	movs	r3, #2
c0d03f5c:	5043      	str	r3, [r0, r1]
  pdev->ep_in[0].total_length = len;
c0d03f5e:	6182      	str	r2, [r0, #24]
  pdev->ep_in[0].rem_length   = len;
c0d03f60:	61c2      	str	r2, [r0, #28]
  // store the continuation data if needed
  pdev->pData = pbuf;
c0d03f62:	2113      	movs	r1, #19
c0d03f64:	0109      	lsls	r1, r1, #4
c0d03f66:	5044      	str	r4, [r0, r1]
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));  
c0d03f68:	6a01      	ldr	r1, [r0, #32]
c0d03f6a:	428a      	cmp	r2, r1
c0d03f6c:	d300      	bcc.n	c0d03f70 <USBD_CtlSendData+0x1c>
c0d03f6e:	460a      	mov	r2, r1
c0d03f70:	b293      	uxth	r3, r2
c0d03f72:	2500      	movs	r5, #0
c0d03f74:	4629      	mov	r1, r5
c0d03f76:	4622      	mov	r2, r4
c0d03f78:	f7ff f9e4 	bl	c0d03344 <USBD_LL_Transmit>
  
  return USBD_OK;
c0d03f7c:	4628      	mov	r0, r5
c0d03f7e:	bdb0      	pop	{r4, r5, r7, pc}

c0d03f80 <USBD_CtlContinueSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueSendData (USBD_HandleTypeDef  *pdev, 
                                       uint8_t *pbuf,
                                       uint16_t len)
{
c0d03f80:	b5b0      	push	{r4, r5, r7, lr}
c0d03f82:	460c      	mov	r4, r1
 /* Start the next transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));   
c0d03f84:	6a01      	ldr	r1, [r0, #32]
c0d03f86:	428a      	cmp	r2, r1
c0d03f88:	d300      	bcc.n	c0d03f8c <USBD_CtlContinueSendData+0xc>
c0d03f8a:	460a      	mov	r2, r1
c0d03f8c:	b293      	uxth	r3, r2
c0d03f8e:	2500      	movs	r5, #0
c0d03f90:	4629      	mov	r1, r5
c0d03f92:	4622      	mov	r2, r4
c0d03f94:	f7ff f9d6 	bl	c0d03344 <USBD_LL_Transmit>
  return USBD_OK;
c0d03f98:	4628      	mov	r0, r5
c0d03f9a:	bdb0      	pop	{r4, r5, r7, pc}

c0d03f9c <USBD_CtlContinueRx>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueRx (USBD_HandleTypeDef  *pdev, 
                                          uint8_t *pbuf,                                          
                                          uint16_t len)
{
c0d03f9c:	b510      	push	{r4, lr}
c0d03f9e:	2400      	movs	r4, #0
  UNUSED(pbuf);
  USBD_LL_PrepareReceive (pdev,
c0d03fa0:	4621      	mov	r1, r4
c0d03fa2:	f7ff f9e8 	bl	c0d03376 <USBD_LL_PrepareReceive>
                          0,                                            
                          len);
  return USBD_OK;
c0d03fa6:	4620      	mov	r0, r4
c0d03fa8:	bd10      	pop	{r4, pc}

c0d03faa <USBD_CtlSendStatus>:
*         send zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendStatus (USBD_HandleTypeDef  *pdev)
{
c0d03faa:	b510      	push	{r4, lr}

  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_IN;
c0d03fac:	21f4      	movs	r1, #244	; 0xf4
c0d03fae:	2204      	movs	r2, #4
c0d03fb0:	5042      	str	r2, [r0, r1]
c0d03fb2:	2400      	movs	r4, #0
  
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, NULL, 0);   
c0d03fb4:	4621      	mov	r1, r4
c0d03fb6:	4622      	mov	r2, r4
c0d03fb8:	4623      	mov	r3, r4
c0d03fba:	f7ff f9c3 	bl	c0d03344 <USBD_LL_Transmit>
  
  return USBD_OK;
c0d03fbe:	4620      	mov	r0, r4
c0d03fc0:	bd10      	pop	{r4, pc}

c0d03fc2 <USBD_CtlReceiveStatus>:
*         receive zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlReceiveStatus (USBD_HandleTypeDef  *pdev)
{
c0d03fc2:	b510      	push	{r4, lr}
  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_OUT; 
c0d03fc4:	21f4      	movs	r1, #244	; 0xf4
c0d03fc6:	2205      	movs	r2, #5
c0d03fc8:	5042      	str	r2, [r0, r1]
c0d03fca:	2400      	movs	r4, #0
  
 /* Start the transfer */  
  USBD_LL_PrepareReceive ( pdev,
c0d03fcc:	4621      	mov	r1, r4
c0d03fce:	4622      	mov	r2, r4
c0d03fd0:	f7ff f9d1 	bl	c0d03376 <USBD_LL_PrepareReceive>
                    0,
                    0);  

  return USBD_OK;
c0d03fd4:	4620      	mov	r0, r4
c0d03fd6:	bd10      	pop	{r4, pc}

c0d03fd8 <__aeabi_uidiv>:
c0d03fd8:	2200      	movs	r2, #0
c0d03fda:	0843      	lsrs	r3, r0, #1
c0d03fdc:	428b      	cmp	r3, r1
c0d03fde:	d374      	bcc.n	c0d040ca <__aeabi_uidiv+0xf2>
c0d03fe0:	0903      	lsrs	r3, r0, #4
c0d03fe2:	428b      	cmp	r3, r1
c0d03fe4:	d35f      	bcc.n	c0d040a6 <__aeabi_uidiv+0xce>
c0d03fe6:	0a03      	lsrs	r3, r0, #8
c0d03fe8:	428b      	cmp	r3, r1
c0d03fea:	d344      	bcc.n	c0d04076 <__aeabi_uidiv+0x9e>
c0d03fec:	0b03      	lsrs	r3, r0, #12
c0d03fee:	428b      	cmp	r3, r1
c0d03ff0:	d328      	bcc.n	c0d04044 <__aeabi_uidiv+0x6c>
c0d03ff2:	0c03      	lsrs	r3, r0, #16
c0d03ff4:	428b      	cmp	r3, r1
c0d03ff6:	d30d      	bcc.n	c0d04014 <__aeabi_uidiv+0x3c>
c0d03ff8:	22ff      	movs	r2, #255	; 0xff
c0d03ffa:	0209      	lsls	r1, r1, #8
c0d03ffc:	ba12      	rev	r2, r2
c0d03ffe:	0c03      	lsrs	r3, r0, #16
c0d04000:	428b      	cmp	r3, r1
c0d04002:	d302      	bcc.n	c0d0400a <__aeabi_uidiv+0x32>
c0d04004:	1212      	asrs	r2, r2, #8
c0d04006:	0209      	lsls	r1, r1, #8
c0d04008:	d065      	beq.n	c0d040d6 <__aeabi_uidiv+0xfe>
c0d0400a:	0b03      	lsrs	r3, r0, #12
c0d0400c:	428b      	cmp	r3, r1
c0d0400e:	d319      	bcc.n	c0d04044 <__aeabi_uidiv+0x6c>
c0d04010:	e000      	b.n	c0d04014 <__aeabi_uidiv+0x3c>
c0d04012:	0a09      	lsrs	r1, r1, #8
c0d04014:	0bc3      	lsrs	r3, r0, #15
c0d04016:	428b      	cmp	r3, r1
c0d04018:	d301      	bcc.n	c0d0401e <__aeabi_uidiv+0x46>
c0d0401a:	03cb      	lsls	r3, r1, #15
c0d0401c:	1ac0      	subs	r0, r0, r3
c0d0401e:	4152      	adcs	r2, r2
c0d04020:	0b83      	lsrs	r3, r0, #14
c0d04022:	428b      	cmp	r3, r1
c0d04024:	d301      	bcc.n	c0d0402a <__aeabi_uidiv+0x52>
c0d04026:	038b      	lsls	r3, r1, #14
c0d04028:	1ac0      	subs	r0, r0, r3
c0d0402a:	4152      	adcs	r2, r2
c0d0402c:	0b43      	lsrs	r3, r0, #13
c0d0402e:	428b      	cmp	r3, r1
c0d04030:	d301      	bcc.n	c0d04036 <__aeabi_uidiv+0x5e>
c0d04032:	034b      	lsls	r3, r1, #13
c0d04034:	1ac0      	subs	r0, r0, r3
c0d04036:	4152      	adcs	r2, r2
c0d04038:	0b03      	lsrs	r3, r0, #12
c0d0403a:	428b      	cmp	r3, r1
c0d0403c:	d301      	bcc.n	c0d04042 <__aeabi_uidiv+0x6a>
c0d0403e:	030b      	lsls	r3, r1, #12
c0d04040:	1ac0      	subs	r0, r0, r3
c0d04042:	4152      	adcs	r2, r2
c0d04044:	0ac3      	lsrs	r3, r0, #11
c0d04046:	428b      	cmp	r3, r1
c0d04048:	d301      	bcc.n	c0d0404e <__aeabi_uidiv+0x76>
c0d0404a:	02cb      	lsls	r3, r1, #11
c0d0404c:	1ac0      	subs	r0, r0, r3
c0d0404e:	4152      	adcs	r2, r2
c0d04050:	0a83      	lsrs	r3, r0, #10
c0d04052:	428b      	cmp	r3, r1
c0d04054:	d301      	bcc.n	c0d0405a <__aeabi_uidiv+0x82>
c0d04056:	028b      	lsls	r3, r1, #10
c0d04058:	1ac0      	subs	r0, r0, r3
c0d0405a:	4152      	adcs	r2, r2
c0d0405c:	0a43      	lsrs	r3, r0, #9
c0d0405e:	428b      	cmp	r3, r1
c0d04060:	d301      	bcc.n	c0d04066 <__aeabi_uidiv+0x8e>
c0d04062:	024b      	lsls	r3, r1, #9
c0d04064:	1ac0      	subs	r0, r0, r3
c0d04066:	4152      	adcs	r2, r2
c0d04068:	0a03      	lsrs	r3, r0, #8
c0d0406a:	428b      	cmp	r3, r1
c0d0406c:	d301      	bcc.n	c0d04072 <__aeabi_uidiv+0x9a>
c0d0406e:	020b      	lsls	r3, r1, #8
c0d04070:	1ac0      	subs	r0, r0, r3
c0d04072:	4152      	adcs	r2, r2
c0d04074:	d2cd      	bcs.n	c0d04012 <__aeabi_uidiv+0x3a>
c0d04076:	09c3      	lsrs	r3, r0, #7
c0d04078:	428b      	cmp	r3, r1
c0d0407a:	d301      	bcc.n	c0d04080 <__aeabi_uidiv+0xa8>
c0d0407c:	01cb      	lsls	r3, r1, #7
c0d0407e:	1ac0      	subs	r0, r0, r3
c0d04080:	4152      	adcs	r2, r2
c0d04082:	0983      	lsrs	r3, r0, #6
c0d04084:	428b      	cmp	r3, r1
c0d04086:	d301      	bcc.n	c0d0408c <__aeabi_uidiv+0xb4>
c0d04088:	018b      	lsls	r3, r1, #6
c0d0408a:	1ac0      	subs	r0, r0, r3
c0d0408c:	4152      	adcs	r2, r2
c0d0408e:	0943      	lsrs	r3, r0, #5
c0d04090:	428b      	cmp	r3, r1
c0d04092:	d301      	bcc.n	c0d04098 <__aeabi_uidiv+0xc0>
c0d04094:	014b      	lsls	r3, r1, #5
c0d04096:	1ac0      	subs	r0, r0, r3
c0d04098:	4152      	adcs	r2, r2
c0d0409a:	0903      	lsrs	r3, r0, #4
c0d0409c:	428b      	cmp	r3, r1
c0d0409e:	d301      	bcc.n	c0d040a4 <__aeabi_uidiv+0xcc>
c0d040a0:	010b      	lsls	r3, r1, #4
c0d040a2:	1ac0      	subs	r0, r0, r3
c0d040a4:	4152      	adcs	r2, r2
c0d040a6:	08c3      	lsrs	r3, r0, #3
c0d040a8:	428b      	cmp	r3, r1
c0d040aa:	d301      	bcc.n	c0d040b0 <__aeabi_uidiv+0xd8>
c0d040ac:	00cb      	lsls	r3, r1, #3
c0d040ae:	1ac0      	subs	r0, r0, r3
c0d040b0:	4152      	adcs	r2, r2
c0d040b2:	0883      	lsrs	r3, r0, #2
c0d040b4:	428b      	cmp	r3, r1
c0d040b6:	d301      	bcc.n	c0d040bc <__aeabi_uidiv+0xe4>
c0d040b8:	008b      	lsls	r3, r1, #2
c0d040ba:	1ac0      	subs	r0, r0, r3
c0d040bc:	4152      	adcs	r2, r2
c0d040be:	0843      	lsrs	r3, r0, #1
c0d040c0:	428b      	cmp	r3, r1
c0d040c2:	d301      	bcc.n	c0d040c8 <__aeabi_uidiv+0xf0>
c0d040c4:	004b      	lsls	r3, r1, #1
c0d040c6:	1ac0      	subs	r0, r0, r3
c0d040c8:	4152      	adcs	r2, r2
c0d040ca:	1a41      	subs	r1, r0, r1
c0d040cc:	d200      	bcs.n	c0d040d0 <__aeabi_uidiv+0xf8>
c0d040ce:	4601      	mov	r1, r0
c0d040d0:	4152      	adcs	r2, r2
c0d040d2:	4610      	mov	r0, r2
c0d040d4:	4770      	bx	lr
c0d040d6:	e7ff      	b.n	c0d040d8 <__aeabi_uidiv+0x100>
c0d040d8:	b501      	push	{r0, lr}
c0d040da:	2000      	movs	r0, #0
c0d040dc:	f000 f806 	bl	c0d040ec <__aeabi_idiv0>
c0d040e0:	bd02      	pop	{r1, pc}
c0d040e2:	46c0      	nop			; (mov r8, r8)

c0d040e4 <__aeabi_uidivmod>:
c0d040e4:	2900      	cmp	r1, #0
c0d040e6:	d0f7      	beq.n	c0d040d8 <__aeabi_uidiv+0x100>
c0d040e8:	e776      	b.n	c0d03fd8 <__aeabi_uidiv>
c0d040ea:	4770      	bx	lr

c0d040ec <__aeabi_idiv0>:
c0d040ec:	4770      	bx	lr
c0d040ee:	46c0      	nop			; (mov r8, r8)

c0d040f0 <__aeabi_memclr>:
c0d040f0:	b510      	push	{r4, lr}
c0d040f2:	2200      	movs	r2, #0
c0d040f4:	f000 f806 	bl	c0d04104 <__aeabi_memset>
c0d040f8:	bd10      	pop	{r4, pc}
c0d040fa:	46c0      	nop			; (mov r8, r8)

c0d040fc <__aeabi_memcpy>:
c0d040fc:	b510      	push	{r4, lr}
c0d040fe:	f000 f809 	bl	c0d04114 <memcpy>
c0d04102:	bd10      	pop	{r4, pc}

c0d04104 <__aeabi_memset>:
c0d04104:	0013      	movs	r3, r2
c0d04106:	b510      	push	{r4, lr}
c0d04108:	000a      	movs	r2, r1
c0d0410a:	0019      	movs	r1, r3
c0d0410c:	f000 f840 	bl	c0d04190 <memset>
c0d04110:	bd10      	pop	{r4, pc}
c0d04112:	46c0      	nop			; (mov r8, r8)

c0d04114 <memcpy>:
c0d04114:	b570      	push	{r4, r5, r6, lr}
c0d04116:	2a0f      	cmp	r2, #15
c0d04118:	d932      	bls.n	c0d04180 <memcpy+0x6c>
c0d0411a:	000c      	movs	r4, r1
c0d0411c:	4304      	orrs	r4, r0
c0d0411e:	000b      	movs	r3, r1
c0d04120:	07a4      	lsls	r4, r4, #30
c0d04122:	d131      	bne.n	c0d04188 <memcpy+0x74>
c0d04124:	0015      	movs	r5, r2
c0d04126:	0004      	movs	r4, r0
c0d04128:	3d10      	subs	r5, #16
c0d0412a:	092d      	lsrs	r5, r5, #4
c0d0412c:	3501      	adds	r5, #1
c0d0412e:	012d      	lsls	r5, r5, #4
c0d04130:	1949      	adds	r1, r1, r5
c0d04132:	681e      	ldr	r6, [r3, #0]
c0d04134:	6026      	str	r6, [r4, #0]
c0d04136:	685e      	ldr	r6, [r3, #4]
c0d04138:	6066      	str	r6, [r4, #4]
c0d0413a:	689e      	ldr	r6, [r3, #8]
c0d0413c:	60a6      	str	r6, [r4, #8]
c0d0413e:	68de      	ldr	r6, [r3, #12]
c0d04140:	3310      	adds	r3, #16
c0d04142:	60e6      	str	r6, [r4, #12]
c0d04144:	3410      	adds	r4, #16
c0d04146:	4299      	cmp	r1, r3
c0d04148:	d1f3      	bne.n	c0d04132 <memcpy+0x1e>
c0d0414a:	230f      	movs	r3, #15
c0d0414c:	1945      	adds	r5, r0, r5
c0d0414e:	4013      	ands	r3, r2
c0d04150:	2b03      	cmp	r3, #3
c0d04152:	d91b      	bls.n	c0d0418c <memcpy+0x78>
c0d04154:	1f1c      	subs	r4, r3, #4
c0d04156:	2300      	movs	r3, #0
c0d04158:	08a4      	lsrs	r4, r4, #2
c0d0415a:	3401      	adds	r4, #1
c0d0415c:	00a4      	lsls	r4, r4, #2
c0d0415e:	58ce      	ldr	r6, [r1, r3]
c0d04160:	50ee      	str	r6, [r5, r3]
c0d04162:	3304      	adds	r3, #4
c0d04164:	429c      	cmp	r4, r3
c0d04166:	d1fa      	bne.n	c0d0415e <memcpy+0x4a>
c0d04168:	2303      	movs	r3, #3
c0d0416a:	192d      	adds	r5, r5, r4
c0d0416c:	1909      	adds	r1, r1, r4
c0d0416e:	401a      	ands	r2, r3
c0d04170:	d005      	beq.n	c0d0417e <memcpy+0x6a>
c0d04172:	2300      	movs	r3, #0
c0d04174:	5ccc      	ldrb	r4, [r1, r3]
c0d04176:	54ec      	strb	r4, [r5, r3]
c0d04178:	3301      	adds	r3, #1
c0d0417a:	429a      	cmp	r2, r3
c0d0417c:	d1fa      	bne.n	c0d04174 <memcpy+0x60>
c0d0417e:	bd70      	pop	{r4, r5, r6, pc}
c0d04180:	0005      	movs	r5, r0
c0d04182:	2a00      	cmp	r2, #0
c0d04184:	d1f5      	bne.n	c0d04172 <memcpy+0x5e>
c0d04186:	e7fa      	b.n	c0d0417e <memcpy+0x6a>
c0d04188:	0005      	movs	r5, r0
c0d0418a:	e7f2      	b.n	c0d04172 <memcpy+0x5e>
c0d0418c:	001a      	movs	r2, r3
c0d0418e:	e7f8      	b.n	c0d04182 <memcpy+0x6e>

c0d04190 <memset>:
c0d04190:	b570      	push	{r4, r5, r6, lr}
c0d04192:	0783      	lsls	r3, r0, #30
c0d04194:	d03f      	beq.n	c0d04216 <memset+0x86>
c0d04196:	1e54      	subs	r4, r2, #1
c0d04198:	2a00      	cmp	r2, #0
c0d0419a:	d03b      	beq.n	c0d04214 <memset+0x84>
c0d0419c:	b2ce      	uxtb	r6, r1
c0d0419e:	0003      	movs	r3, r0
c0d041a0:	2503      	movs	r5, #3
c0d041a2:	e003      	b.n	c0d041ac <memset+0x1c>
c0d041a4:	1e62      	subs	r2, r4, #1
c0d041a6:	2c00      	cmp	r4, #0
c0d041a8:	d034      	beq.n	c0d04214 <memset+0x84>
c0d041aa:	0014      	movs	r4, r2
c0d041ac:	3301      	adds	r3, #1
c0d041ae:	1e5a      	subs	r2, r3, #1
c0d041b0:	7016      	strb	r6, [r2, #0]
c0d041b2:	422b      	tst	r3, r5
c0d041b4:	d1f6      	bne.n	c0d041a4 <memset+0x14>
c0d041b6:	2c03      	cmp	r4, #3
c0d041b8:	d924      	bls.n	c0d04204 <memset+0x74>
c0d041ba:	25ff      	movs	r5, #255	; 0xff
c0d041bc:	400d      	ands	r5, r1
c0d041be:	022a      	lsls	r2, r5, #8
c0d041c0:	4315      	orrs	r5, r2
c0d041c2:	042a      	lsls	r2, r5, #16
c0d041c4:	4315      	orrs	r5, r2
c0d041c6:	2c0f      	cmp	r4, #15
c0d041c8:	d911      	bls.n	c0d041ee <memset+0x5e>
c0d041ca:	0026      	movs	r6, r4
c0d041cc:	3e10      	subs	r6, #16
c0d041ce:	0936      	lsrs	r6, r6, #4
c0d041d0:	3601      	adds	r6, #1
c0d041d2:	0136      	lsls	r6, r6, #4
c0d041d4:	001a      	movs	r2, r3
c0d041d6:	199b      	adds	r3, r3, r6
c0d041d8:	6015      	str	r5, [r2, #0]
c0d041da:	6055      	str	r5, [r2, #4]
c0d041dc:	6095      	str	r5, [r2, #8]
c0d041de:	60d5      	str	r5, [r2, #12]
c0d041e0:	3210      	adds	r2, #16
c0d041e2:	4293      	cmp	r3, r2
c0d041e4:	d1f8      	bne.n	c0d041d8 <memset+0x48>
c0d041e6:	220f      	movs	r2, #15
c0d041e8:	4014      	ands	r4, r2
c0d041ea:	2c03      	cmp	r4, #3
c0d041ec:	d90a      	bls.n	c0d04204 <memset+0x74>
c0d041ee:	1f26      	subs	r6, r4, #4
c0d041f0:	08b6      	lsrs	r6, r6, #2
c0d041f2:	3601      	adds	r6, #1
c0d041f4:	00b6      	lsls	r6, r6, #2
c0d041f6:	001a      	movs	r2, r3
c0d041f8:	199b      	adds	r3, r3, r6
c0d041fa:	c220      	stmia	r2!, {r5}
c0d041fc:	4293      	cmp	r3, r2
c0d041fe:	d1fc      	bne.n	c0d041fa <memset+0x6a>
c0d04200:	2203      	movs	r2, #3
c0d04202:	4014      	ands	r4, r2
c0d04204:	2c00      	cmp	r4, #0
c0d04206:	d005      	beq.n	c0d04214 <memset+0x84>
c0d04208:	b2c9      	uxtb	r1, r1
c0d0420a:	191c      	adds	r4, r3, r4
c0d0420c:	7019      	strb	r1, [r3, #0]
c0d0420e:	3301      	adds	r3, #1
c0d04210:	429c      	cmp	r4, r3
c0d04212:	d1fb      	bne.n	c0d0420c <memset+0x7c>
c0d04214:	bd70      	pop	{r4, r5, r6, pc}
c0d04216:	0014      	movs	r4, r2
c0d04218:	0003      	movs	r3, r0
c0d0421a:	e7cc      	b.n	c0d041b6 <memset+0x26>

c0d0421c <setjmp>:
c0d0421c:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0d0421e:	4641      	mov	r1, r8
c0d04220:	464a      	mov	r2, r9
c0d04222:	4653      	mov	r3, sl
c0d04224:	465c      	mov	r4, fp
c0d04226:	466d      	mov	r5, sp
c0d04228:	4676      	mov	r6, lr
c0d0422a:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0d0422c:	3828      	subs	r0, #40	; 0x28
c0d0422e:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d04230:	2000      	movs	r0, #0
c0d04232:	4770      	bx	lr

c0d04234 <longjmp>:
c0d04234:	3010      	adds	r0, #16
c0d04236:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0d04238:	4690      	mov	r8, r2
c0d0423a:	4699      	mov	r9, r3
c0d0423c:	46a2      	mov	sl, r4
c0d0423e:	46ab      	mov	fp, r5
c0d04240:	46b5      	mov	sp, r6
c0d04242:	c808      	ldmia	r0!, {r3}
c0d04244:	3828      	subs	r0, #40	; 0x28
c0d04246:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d04248:	1c08      	adds	r0, r1, #0
c0d0424a:	d100      	bne.n	c0d0424e <longjmp+0x1a>
c0d0424c:	2001      	movs	r0, #1
c0d0424e:	4718      	bx	r3

c0d04250 <strlen>:
c0d04250:	b510      	push	{r4, lr}
c0d04252:	0783      	lsls	r3, r0, #30
c0d04254:	d027      	beq.n	c0d042a6 <strlen+0x56>
c0d04256:	7803      	ldrb	r3, [r0, #0]
c0d04258:	2b00      	cmp	r3, #0
c0d0425a:	d026      	beq.n	c0d042aa <strlen+0x5a>
c0d0425c:	0003      	movs	r3, r0
c0d0425e:	2103      	movs	r1, #3
c0d04260:	e002      	b.n	c0d04268 <strlen+0x18>
c0d04262:	781a      	ldrb	r2, [r3, #0]
c0d04264:	2a00      	cmp	r2, #0
c0d04266:	d01c      	beq.n	c0d042a2 <strlen+0x52>
c0d04268:	3301      	adds	r3, #1
c0d0426a:	420b      	tst	r3, r1
c0d0426c:	d1f9      	bne.n	c0d04262 <strlen+0x12>
c0d0426e:	6819      	ldr	r1, [r3, #0]
c0d04270:	4a0f      	ldr	r2, [pc, #60]	; (c0d042b0 <strlen+0x60>)
c0d04272:	4c10      	ldr	r4, [pc, #64]	; (c0d042b4 <strlen+0x64>)
c0d04274:	188a      	adds	r2, r1, r2
c0d04276:	438a      	bics	r2, r1
c0d04278:	4222      	tst	r2, r4
c0d0427a:	d10f      	bne.n	c0d0429c <strlen+0x4c>
c0d0427c:	3304      	adds	r3, #4
c0d0427e:	6819      	ldr	r1, [r3, #0]
c0d04280:	4a0b      	ldr	r2, [pc, #44]	; (c0d042b0 <strlen+0x60>)
c0d04282:	188a      	adds	r2, r1, r2
c0d04284:	438a      	bics	r2, r1
c0d04286:	4222      	tst	r2, r4
c0d04288:	d108      	bne.n	c0d0429c <strlen+0x4c>
c0d0428a:	3304      	adds	r3, #4
c0d0428c:	6819      	ldr	r1, [r3, #0]
c0d0428e:	4a08      	ldr	r2, [pc, #32]	; (c0d042b0 <strlen+0x60>)
c0d04290:	188a      	adds	r2, r1, r2
c0d04292:	438a      	bics	r2, r1
c0d04294:	4222      	tst	r2, r4
c0d04296:	d0f1      	beq.n	c0d0427c <strlen+0x2c>
c0d04298:	e000      	b.n	c0d0429c <strlen+0x4c>
c0d0429a:	3301      	adds	r3, #1
c0d0429c:	781a      	ldrb	r2, [r3, #0]
c0d0429e:	2a00      	cmp	r2, #0
c0d042a0:	d1fb      	bne.n	c0d0429a <strlen+0x4a>
c0d042a2:	1a18      	subs	r0, r3, r0
c0d042a4:	bd10      	pop	{r4, pc}
c0d042a6:	0003      	movs	r3, r0
c0d042a8:	e7e1      	b.n	c0d0426e <strlen+0x1e>
c0d042aa:	2000      	movs	r0, #0
c0d042ac:	e7fa      	b.n	c0d042a4 <strlen+0x54>
c0d042ae:	46c0      	nop			; (mov r8, r8)
c0d042b0:	fefefeff 	.word	0xfefefeff
c0d042b4:	80808080 	.word	0x80808080

c0d042b8 <TXT_BLANK>:
c0d042b8:	20202020 20202020 20202020 20202020                     
c0d042c8:	32310020                                          .

c0d042ca <BASE_58_ALPHABET>:
c0d042ca:	34333231 38373635 43424139 47464544     123456789ABCDEFG
c0d042da:	4c4b4a48 51504e4d 55545352 59585756     HJKLMNPQRSTUVWXY
c0d042ea:	6362615a 67666564 6b6a6968 706f6e6d     Zabcdefghijkmnop
c0d042fa:	74737271 78777675 006f7a79                       qrstuvwxyz

c0d04304 <SW_INTERNAL>:
c0d04304:	0190006f                                         o.

c0d04306 <SW_BUSY>:
c0d04306:	00670190                                         ..

c0d04308 <SW_WRONG_LENGTH>:
c0d04308:	806a0067                                         g.

c0d0430a <SW_BAD_KEY_HANDLE>:
c0d0430a:	3255806a                                         j.

c0d0430c <U2F_VERSION>:
c0d0430c:	5f463255 00903256                       U2F_V2..

c0d04314 <INFO>:
c0d04314:	00900901                                ....

c0d04318 <SW_UNKNOWN_CLASS>:
c0d04318:	006d006e                                         n.

c0d0431a <SW_UNKNOWN_INSTRUCTION>:
c0d0431a:	ffff006d                                         m.

c0d0431c <BROADCAST_CHANNEL>:
c0d0431c:	ffffffff                                ....

c0d04320 <FORBIDDEN_CHANNEL>:
c0d04320:	00000000 656b6157 2c705520 544e4f20     ....Wake Up, ONT
c0d04330:	002e2e2e 54495845 67695300 7854206e     ....EXIT.Sign Tx
c0d04340:	776f4e20 00705500 6e676953 776f4400      Now.Up.Sign.Dow
c0d04350:	6544006e 5420796e 65440078 5300796e     n.Deny Tx.Deny.S
c0d04360:	206e6769 00007854                       ign Tx..

c0d04368 <bagl_ui_idle_blue>:
c0d04368:	00000003 0140003c 000001a4 00000001     ....<.@.........
	...
c0d043a0:	00000003 01400000 0000003c 00000001     ......@.<.......
c0d043b0:	00ffffff 00ffffff 00000000 00000000     ................
	...
c0d043d8:	00500002 00a00000 0000003c 00000001     ..P.....<.......
c0d043e8:	00000000 00ffffff 0000a004 c0d04324     ............$C..
	...
c0d04410:	006e0081 006400e1 06000028 00000001     ..n...d.(.......
c0d04420:	00ffffff 00000000 0000a004 c0d04334     ............4C..
c0d04430:	00000000 0037ae99 00f9f9f9 c0d02b29     ......7.....)+..
	...
c0d04448:	00000002 003c0000 0000003c 00000001     ......<.<.......
c0d04458:	00000000 00ffffff 0000a004 20002020     ............  . 
	...

c0d04480 <bagl_ui_idle_nanos>:
c0d04480:	00000003 00800000 00000020 00000001     ........ .......
c0d04490:	00000000 00ffffff 00000000 00000000     ................
	...
c0d044b8:	00000207 0080000c 0000000b 00000000     ................
c0d044c8:	00ffffff 00000000 00008008 c0d04324     ............$C..
	...
c0d044f0:	00030005 0007000c 00000007 00000000     ................
c0d04500:	00ffffff 00000000 00070000 00000000     ................
	...
c0d04528:	00750005 0007000b 00000007 00000000     ..u.............
c0d04538:	00ffffff 00000000 001b0000 00000000     ................
	...

c0d04560 <bagl_ui_public_key_nanos_1>:
c0d04560:	00000003 00800000 00000020 00000001     ........ .......
c0d04570:	00000000 00ffffff 00000000 00000000     ................
	...
c0d04598:	000a0207 006c000a 008a000b 00000000     ......l.........
c0d045a8:	00ffffff 00000000 0000800a 20002030     ............0 . 
	...
c0d045d0:	000a0207 006c0015 008a000b 00000000     ......l.........
c0d045e0:	00ffffff 00000000 0000800a 20002042     ............B . 
	...
c0d04608:	00710005 0007000c 00000007 00000000     ..q.............
c0d04618:	00ffffff 00000000 00070000 00000000     ................
	...
c0d04640:	00030005 0007000c 00000007 00000000     ................
c0d04650:	00ffffff 00000000 000c0000 00000000     ................
	...

c0d04678 <bagl_ui_public_key_nanos_2>:
c0d04678:	00000003 00800000 00000020 00000001     ........ .......
c0d04688:	00000000 00ffffff 00000000 00000000     ................
	...
c0d046b0:	000a0207 006c000a 008a000b 00000000     ......l.........
c0d046c0:	00ffffff 00000000 0000800a 20002042     ............B . 
	...
c0d046e8:	000a0207 006c0015 008a000b 00000000     ......l.........
c0d046f8:	00ffffff 00000000 0000800a 20002054     ............T . 
	...
c0d04720:	00710005 0007000c 00000007 00000000     ..q.............
c0d04730:	00ffffff 00000000 00070000 00000000     ................
	...
c0d04758:	00030005 0007000c 00000007 00000000     ................
c0d04768:	00ffffff 00000000 000b0000 00000000     ................
	...

c0d04790 <bagl_ui_top_sign_blue>:
c0d04790:	00000003 0140003c 000001a4 00000001     ....<.@.........
	...
c0d047c8:	00000003 01400000 0000003c 00000001     ......@.<.......
c0d047d8:	00ffffff 00ffffff 00000000 00000000     ................
	...
c0d04800:	00140002 01400000 0000003c 00000001     ......@.<.......
c0d04810:	00000000 00ffffff 0000a004 c0d04339     ............9C..
	...
c0d04838:	00000081 006400e1 06000028 00000001     ......d.(.......
c0d04848:	00ffffff 00000000 0000a004 c0d04345     ............EC..
c0d04858:	00000000 0037ae99 00f9f9f9 c0d02dad     ......7......-..
	...
c0d04870:	006e0081 006400e1 06000028 00000001     ..n...d.(.......
c0d04880:	00ffffff 00000000 0000a004 c0d04348     ............HC..
c0d04890:	00000000 0037ae99 00f9f9f9 c0d02745     ......7.....E'..
	...
c0d048a8:	00dc0081 006400e1 06000028 00000001     ......d.(.......
c0d048b8:	00ffffff 00000000 0000a004 c0d0434d     ............MC..
c0d048c8:	00000000 0037ae99 00f9f9f9 c0d02f09     ......7....../..
	...
c0d048e0:	00000002 003c0000 0000003c 00000001     ......<.<.......
c0d048f0:	00000000 00ffffff 0000a004 20002020     ............  . 
	...

c0d04918 <bagl_ui_deny_blue>:
c0d04918:	00000003 0140003c 000001a4 00000001     ....<.@.........
	...
c0d04950:	00000003 01400000 0000003c 00000001     ......@.<.......
c0d04960:	00ffffff 00ffffff 00000000 00000000     ................
	...
c0d04988:	00140002 01400000 0000003c 00000001     ......@.<.......
c0d04998:	00000000 00ffffff 0000a004 c0d04352     ............RC..
	...
c0d049c0:	00000081 006400e1 06000028 00000001     ......d.(.......
c0d049d0:	00ffffff 00000000 0000a004 c0d04345     ............EC..
c0d049e0:	00000000 0037ae99 00f9f9f9 c0d02dad     ......7......-..
	...
c0d049f8:	006e0081 006400e1 06000028 00000001     ..n...d.(.......
c0d04a08:	00ffffff 00000000 0000a004 c0d0435a     ............ZC..
c0d04a18:	00000000 0037ae99 00f9f9f9 c0d030e5     ......7......0..
	...
c0d04a30:	00dc0081 006400e1 06000028 00000001     ......d.(.......
c0d04a40:	00ffffff 00000000 0000a004 c0d0434d     ............MC..
c0d04a50:	00000000 0037ae99 00f9f9f9 c0d02f09     ......7....../..
	...
c0d04a68:	00000002 003c0000 0000003c 00000001     ......<.<.......
c0d04a78:	00000000 00ffffff 0000a004 20002020     ............  . 
	...

c0d04aa0 <bagl_ui_deny_nanos>:
c0d04aa0:	00000003 00800000 00000020 00000001     ........ .......
c0d04ab0:	00000000 00ffffff 00000000 00000000     ................
	...
c0d04ad8:	00030003 000c0001 00000002 00000001     ................
c0d04ae8:	00ffffff 00000000 00000000 00000000     ................
	...
c0d04b10:	00710003 000c0001 00000002 00000001     ..q.............
c0d04b20:	00ffffff 00000000 00000000 00000000     ................
	...
c0d04b48:	00000207 00800014 0000000b 00000000     ................
c0d04b58:	00ffffff 00000000 00008008 c0d04352     ............RC..
	...
c0d04b80:	00030005 0007000c 00000007 00000000     ................
c0d04b90:	00ffffff 00000000 000b0000 00000000     ................
	...
c0d04bb8:	00750005 0007000d 00000007 00000000     ..u.............
c0d04bc8:	00ffffff 00000000 000c0000 00000000     ................
	...

c0d04bf0 <bagl_ui_sign_blue>:
c0d04bf0:	00000003 0140003c 000001a4 00000001     ....<.@.........
	...
c0d04c28:	00000003 01400000 0000003c 00000001     ......@.<.......
c0d04c38:	00ffffff 00ffffff 00000000 00000000     ................
	...
c0d04c60:	00140002 01400000 0000003c 00000001     ......@.<.......
c0d04c70:	00000000 00ffffff 0000a004 c0d0435f     ............_C..
	...
c0d04c98:	00000081 006400e1 06000028 00000001     ......d.(.......
c0d04ca8:	00ffffff 00000000 0000a004 c0d04345     ............EC..
c0d04cb8:	00000000 0037ae99 00f9f9f9 c0d02dad     ......7......-..
	...
c0d04cd0:	006e0081 006400e1 06000028 00000001     ..n...d.(.......
c0d04ce0:	00ffffff 00000000 0000a004 c0d04348     ............HC..
c0d04cf0:	00000000 0037ae99 00f9f9f9 c0d02745     ......7.....E'..
	...
c0d04d08:	00dc0081 006400e1 06000028 00000001     ......d.(.......
c0d04d18:	00ffffff 00000000 0000a004 c0d0434d     ............MC..
c0d04d28:	00000000 0037ae99 00f9f9f9 c0d02f09     ......7....../..
	...
c0d04d40:	00000002 003c0000 0000003c 00000001     ......<.<.......
c0d04d50:	00000000 00ffffff 0000a004 20002020     ............  . 
	...

c0d04d78 <bagl_ui_sign_nanos>:
c0d04d78:	00000003 00800000 00000020 00000001     ........ .......
c0d04d88:	00000000 00ffffff 00000000 00000000     ................
	...
c0d04db0:	00030003 000c0001 00000002 00000001     ................
c0d04dc0:	00ffffff 00000000 00000000 00000000     ................
	...
c0d04de8:	00710003 000c0001 00000002 00000001     ..q.............
c0d04df8:	00ffffff 00000000 00000000 00000000     ................
	...
c0d04e20:	00030005 0007000c 00000007 00000000     ................
c0d04e30:	00ffffff 00000000 000b0000 00000000     ................
	...
c0d04e58:	00750005 0008000d 00000006 00000000     ..u.............
c0d04e68:	00ffffff 00000000 000c0000 00000000     ................
	...

c0d04e90 <bagl_ui_top_sign_nanos>:
c0d04e90:	00000003 00800000 00000020 00000001     ........ .......
c0d04ea0:	00000000 00ffffff 00000000 00000000     ................
	...
c0d04ec8:	00030003 000c0001 00000002 00000001     ................
c0d04ed8:	00ffffff 00000000 00000000 00000000     ................
	...
c0d04f00:	00710003 000c0001 00000002 00000001     ..q.............
c0d04f10:	00ffffff 00000000 00000000 00000000     ................
	...
c0d04f38:	00000207 00800014 0000000b 00000000     ................
c0d04f48:	00ffffff 00000000 00008008 c0d04339     ............9C..
	...
c0d04f70:	00030005 0007000c 00000007 00000000     ................
c0d04f80:	00ffffff 00000000 000b0000 00000000     ................
	...
c0d04fa8:	00750005 0008000d 00000006 00000000     ..u.............
c0d04fb8:	00ffffff 00000000 000c0000 00000000     ................
	...

c0d04fe0 <USBD_HID_Desc_fido>:
c0d04fe0:	01112109 22220121 00000000              .!..!.""....

c0d04fec <USBD_HID_Desc>:
c0d04fec:	01112109 22220100 f1d00600                       .!...."".

c0d04ff5 <HID_ReportDesc_fido>:
c0d04ff5:	09f1d006 0901a101 26001503 087500ff     ...........&..u.
c0d05005:	08814095 00150409 7500ff26 91409508     .@......&..u..@.
c0d05015:	a006c008                                         ..

c0d05017 <HID_ReportDesc>:
c0d05017:	09ffa006 0901a101 26001503 087500ff     ...........&..u.
c0d05027:	08814095 00150409 7500ff26 91409508     .@......&..u..@.
c0d05037:	0000c008 d03e4900                                .....

c0d0503c <HID_Desc>:
c0d0503c:	c0d03e49 c0d03e59 c0d03e69 c0d03e79     I>..Y>..i>..y>..
c0d0504c:	c0d03e89 c0d03e99 c0d03ea9 00000000     .>...>...>......

c0d0505c <USBD_HID>:
c0d0505c:	c0d03cc7 c0d03cf9 c0d03c2f 00000000     .<...<../<......
	...
c0d05074:	c0d03df1 00000000 00000000 00000000     .=..............
c0d05084:	c0d03f35 c0d03f35 c0d03f35 c0d03f45     5?..5?..5?..E?..

c0d05094 <USBD_U2F>:
c0d05094:	c0d03cc7 c0d03cf9 c0d03c2f 00000000     .<...<../<......
c0d050a4:	00000000 c0d03dad c0d03dc5 00000000     .....=...=......
	...
c0d050bc:	c0d03f35 c0d03f35 c0d03f35 c0d03f45     5?..5?..5?..E?..

c0d050cc <USBD_DeviceDesc>:
c0d050cc:	02000112 40000000 00012c97 02010200     .......@.,......
c0d050dc:	03040103                                         ..

c0d050de <USBD_LangIDDesc>:
c0d050de:	04090304                                ....

c0d050e2 <USBD_MANUFACTURER_STRING>:
c0d050e2:	004c030e 00640065 00650067 030e0072              ..L.e.d.g.e.r.

c0d050f0 <USBD_PRODUCT_FS_STRING>:
c0d050f0:	004e030e 006e0061 0020006f 030a0053              ..N.a.n.o. .S.

c0d050fe <USB_SERIAL_STRING>:
c0d050fe:	0030030a 00300030 02090031                       ..0.0.0.1.

c0d05108 <USBD_CfgDesc>:
c0d05108:	00490209 c0020102 00040932 00030200     ..I.....2.......
c0d05118:	21090200 01000111 07002222 40038205     ...!...."".....@
c0d05128:	05070100 00400302 01040901 01030200     ......@.........
c0d05138:	21090201 01210111 07002222 40038105     ...!..!."".....@
c0d05148:	05070100 00400301 00000001              ......@.....

c0d05154 <USBD_DeviceQualifierDesc>:
c0d05154:	0200060a 40000000 00000001              .......@....

c0d05160 <_etext>:
	...
