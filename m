Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A454C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 16:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32CA82133F
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 16:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388034AbeLQQfQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 11:35:16 -0500
Received: from wind.enjellic.com ([76.10.64.91]:57410 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387995AbeLQQfP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 11:35:15 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wBHGYIQc005796;
        Mon, 17 Dec 2018 10:34:18 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wBHGYHvv005795;
        Mon, 17 Dec 2018 10:34:17 -0600
Date:   Mon, 17 Dec 2018 10:34:17 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, jethro@fortanix.com
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181217163417.GA5372@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181128104941.GA23077@wind.enjellic.com> <20181128192228.GC9023@linux.intel.com> <20181210104908.GA23132@wind.enjellic.com> <20181212180036.GC6333@linux.intel.com> <20181214235917.GA14049@wind.enjellic.com> <20181215000627.GA5799@linux.intel.com> <20181217132859.GA31936@linux.intel.com> <20181217133928.GA32706@linux.intel.com> <20181217140811.GA4601@linux.intel.com> <20181217141315.GB4601@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181217141315.GB4601@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Mon, 17 Dec 2018 10:34:18 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 04:13:15PM +0200, Jarkko Sakkinen wrote:

Good morning to everyone.

> On Mon, Dec 17, 2018 at 04:08:11PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Dec 17, 2018 at 03:39:28PM +0200, Jarkko Sakkinen wrote:
> > > On Mon, Dec 17, 2018 at 03:28:59PM +0200, Jarkko Sakkinen wrote:
> > > > On Fri, Dec 14, 2018 at 04:06:27PM -0800, Sean Christopherson wrote:
> > > > > [  504.149548] ------------[ cut here ]------------
> > > > > [  504.149550] kernel BUG at /home/sean/go/src/kernel.org/linux/mm/mmap.c:669!
> > > > > [  504.150288] invalid opcode: 0000 [#1] SMP
> > > > > [  504.150614] CPU: 2 PID: 237 Comm: kworker/u20:2 Not tainted 4.20.0-rc2+ #267
> > > > > [  504.151165] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> > > > > [  504.151818] Workqueue: sgx-encl-wq sgx_encl_release_worker
> > > > > [  504.152267] RIP: 0010:__vma_adjust+0x64a/0x820
> > > > > [  504.152626] Code: ff 48 89 50 18 e9 6f fc ff ff 4c 8b ab 88 00 00 00 45 31 e4 e9 61 fb ff ff 31 c0 48 83 c4 60 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 49 89 de 49 83 c6 20 0f 84 06 fe ff ff 49 8d 7e e0 e8 fe ee
> > > > > [  504.154109] RSP: 0000:ffffc900004ebd60 EFLAGS: 00010206
> > > > > [  504.154535] RAX: 00007fd92ef7e000 RBX: ffff888467af16c0 RCX: ffff888467af16e0
> > > > > [  504.155104] RDX: ffff888458fd09e0 RSI: 00007fd954021000 RDI: ffff88846bf9e798
> > > > > [  504.155673] RBP: ffff888467af1480 R08: ffff88845bea2000 R09: 0000000000000000
> > > > > [  504.156242] R10: 0000000080000000 R11: fefefefefefefeff R12: 0000000000000000
> > > > > [  504.156810] R13: ffff88846bf9e790 R14: ffff888467af1b70 R15: ffff888467af1b60
> > > > > [  504.157378] FS:  0000000000000000(0000) GS:ffff88846f700000(0000) knlGS:0000000000000000
> > > > > [  504.158021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > [  504.158483] CR2: 00007f2c56e99000 CR3: 0000000005009001 CR4: 0000000000360ee0
> > > > > [  504.159054] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > [  504.159623] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > > [  504.160193] Call Trace:
> > > > > [  504.160406]  __split_vma+0x16f/0x180
> > > > > [  504.160706]  ? __switch_to_asm+0x40/0x70
> > > > > [  504.161024]  __do_munmap+0xfb/0x450
> > > > > [  504.161308]  sgx_encl_release_worker+0x44/0x70
> > > > > [  504.161675]  process_one_work+0x200/0x3f0
> > > > > [  504.162004]  worker_thread+0x2d/0x3d0
> > > > > [  504.162301]  ? process_one_work+0x3f0/0x3f0
> > > > > [  504.162645]  kthread+0x113/0x130
> > > > > [  504.162912]  ? kthread_park+0x90/0x90
> > > > > [  504.163209]  ret_from_fork+0x35/0x40
> > > > > [  504.163503] Modules linked in: bridge stp llc
> > > > > [  504.163866] ---[ end trace 83076139fc25e3e0 ]---

> > > > There was a race with release and swapping code that I thought
> > > > I fixed, and this is looks like a race there. Have to recheck
> > > > what I did not consider. Anyway, though to share this if you
> > > > have time to look at it.  That is the part where something is
> > > > now unsync most probably.

> > > I think I found it. I was careless to make sgx_encl_release() to
> > > use sgx_invalidate(), which does not delete pages in the case
> > > when enclave is already marked as dead. This was after I had
> > > fixed the race that I had there in the first place. That is why
> > > I was puzzled why it suddenly reappeared.

> > > Would be nice to use sgx_invalidate() also in release for consistency in
> > > semantics sake so maybe just delete this:
> > > 
> > > 	if (encl->flags & SGX_ENCL_DEAD)
> > > 		return;
> > 
> > Updated master, not at this point next.

> If I checked this right was that mmu_notifier_unregister() cause
> DEAD to set, and thus when sgx_invalidate() is executed, it returns
> without doing anything...

On a pristine jarkko-sgx/next local branch we commented out the 'if
(encl->flags & SGX_ENCL_DEAD) return' clause in the following
file/function:

arch/x86/kernel/cpu/sgx/driver/encl.c:sgx_invalidate()

And tested the kernel.

This fix seems to prevent the memory manager from getting
catastrophically corrupted but the EINIT ioctl still fails.

On the first invocation after a fresh boot the EINIT ioctl returns -1.

On subsequent invocations of the loader it returns EBUSY.  Every 8-10
invocations we get the -1 (EPERM -?) from the EINIT call and then it
returns to issueing EBUSY.

Here is a representative call trace from the loader utility:

---------------------------------------------------------------------------
address: 7ff5cbe00000, create address: 7ff5cbe00000
Non-token initialization requested.
EINIT retn: -1 / No error information
[SGXenclave.c,init_enclave,652]: Error location.
[sgx-load.c,main,180]: Error location.

address: 7f4255200000, create address: 7f4255200000
Non-token initialization requested.
EINIT retn: 16 / Resource busy
[SGXenclave.c,init_enclave,652]: Error location.
[sgx-load.c,main,180]: Error location.
---------------------------------------------------------------------------

It looks like I spoke too soon about the patch completely hardening
the machine.  We just got a segmentation fault on EINIT and the
process is hung in 'D' state with the following WCHAN value:

__flush_work.isra.43

Any further attempts to run the loader causes those processes to hang
as well.

Here is everything we have been able to get out of the machine with respect to a stack trace after the initial fault:

---------------------------------------------------------------------------
Dec 17 10:03:00 nuc2 kernel: general protection fault: 0000 [#1] SMP PTI
Dec 17 10:03:00 nuc2 kernel: CPU: 1 PID: 1249 Comm: kworker/u8:3 Not tainted 4.20.0-rc2-sgx-nuc2+ #13
Dec 17 10:03:00 nuc2 kernel: Hardware name: Intel Corporation NUC7CJYH/NUC7JYB, BIOS JYGLKCPX.86A.0046.2018.1103.1316 11/03/2018
Dec 17 10:03:00 nuc2 kernel: Workqueue: sgx-encl-wq sgx_encl_release_worker
Dec 17 10:03:00 nuc2 kernel: RIP: 0010:__mmu_notifier_invalidate_range_start+0x38/0xc5
Dec 17 10:03:00 nuc2 kernel: Code: 54 49 89 fc 48 c7 c7 d0 6f c3 ad 53 31 db 48 83 ec 18 48 89 75 c8 48 89 55 c0 e8 67 97 f7 ff 89 45 d4 49 8b 84 24 a0 03 00 00 <4c> 8b 30 41 0f b6 c5 89 45 d0 4d 85 f6 74 5e 49 8b 46 10 48 8b 40
Dec 17 10:03:00 nuc2 kernel: RSP: 0018:ffffa51d4238bc98 EFLAGS: 00010246
Dec 17 10:03:00 nuc2 kernel: RAX: dead000000000100 RBX: 0000000000000000 RCX: 0000000000000000
Dec 17 10:03:00 nuc2 kernel: RDX: 000000000001b640 RSI: 00007f51607ee000 RDI: ffffffffadc36fd0
Dec 17 10:03:00 nuc2 kernel: RBP: ffffa51d4238bcd8 R08: 00007f5160a00000 R09: 0000000000000000
Dec 17 10:03:00 nuc2 kernel: R10: ffffa51d4238bce8 R11: fefefefefefefeff R12: ffffa17a3aa68c00
Dec 17 10:03:00 nuc2 kernel: R13: ffffa17a3aa68c01 R14: 00007f51607ee000 R15: ffffa51d4238bd28
Dec 17 10:03:00 nuc2 kernel: FS:  0000000000000000(0000) GS:ffffa17a3be80000(0000) knlGS:0000000000000000
Dec 17 10:03:00 nuc2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec 17 10:03:00 nuc2 kernel: CR2: 000000000878ed68 CR3: 000000017adc4000 CR4: 0000000000340ee0
Dec 17 10:03:00 nuc2 kernel: Call Trace:
Dec 17 10:03:00 nuc2 kernel:  unmap_vmas+0x3a/0x83
Dec 17 10:03:00 nuc2 kernel:  unmap_region+0xab/0xfc
Dec 17 10:03:00 nuc2 kernel:  ? __vma_rb_erase+0x189/0x1c4
Dec 17 10:03:00 nuc2 kernel:  __do_munmap+0x246/0x2d5
Dec 17 10:03:00 nuc2 kernel:  do_munmap+0xc/0xe
Dec 17 10:03:00 nuc2 kernel:  sgx_encl_release_worker+0x44/0x6e
Dec 17 10:03:00 nuc2 kernel:  process_one_work+0x183/0x271
Dec 17 10:03:00 nuc2 kernel:  worker_thread+0x1e5/0x2b4
Dec 17 10:03:00 nuc2 kernel:  ? cancel_delayed_work_sync+0x10/0x10
Dec 17 10:03:00 nuc2 kernel:  kthread+0x116/0x11e
Dec 17 10:03:00 nuc2 kernel:  ? kthread_park+0x7e/0x7e
Dec 17 10:03:00 nuc2 kernel:  ret_from_fork+0x1f/0x40
Dec 17 10:03:00 nuc2 kernel: Modules linked in:
Dec 17 10:03:00 nuc2 kernel: ---[ end trace 07fc74730017fedb ]---
Dec 17 10:03:00 nuc2 kernel: RIP: 0010:__mmu_notifier_invalidate_range_start+0x38/0xc5
Dec 17 10:03:00 nuc2 kernel: Code: 54 49 89 fc 48 c7 c7 d0 6f c3 ad 53 31 db 48 83 ec 18 48 89 75 c8 48 89 55 c0 e8 67 97 f7 ff 89 45 d4 49 8b 84 24 a0 03 00 00 <4c> 8b 30 41 0f b6 c5 89 45 d0 4d 85 f6 74 5e 49 8b 46 10 48 8b 40
Dec 17 10:03:00 nuc2 kernel: RSP: 0018:ffffa51d4238bc98 EFLAGS: 00010246
Dec 17 10:03:00 nuc2 kernel: RAX: dead000000000100 RBX: 0000000000000000 RCX: 0000000000000000
Dec 17 10:03:00 nuc2 kernel: RDX: 000000000001b640 RSI: 00007f51607ee000 RDI: ffffffffadc36fd0
Dec 17 10:03:00 nuc2 kernel: RBP: ffffa51d4238bcd8 R08: 00007f5160a00000 R09: 0000000000000000
Dec 17 10:03:00 nuc2 kernel: R10: ffffa51d4238bce8 R11: fefefefefefefeff R12: ffffa17a3aa68c00
Dec 17 10:03:00 nuc2 kernel: R13: ffffa17a3aa68c01 R14: 00007f51607ee000 R15: ffffa51d4238bd28
Dec 17 10:03:00 nuc2 kernel: FS:  0000000000000000(0000) GS:ffffa17a3be80000(0000) knlGS:0000000000000000
Dec 17 10:03:00 nuc2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec 17 10:03:00 nuc2 kernel: CR2: 000000000878ed68 CR3: 000000017adc4000 CR4: 0000000000340ee0
---------------------------------------------------------------------------

So far the box still appears to be largely intact except for every
invocation of the enclave loader hanging.

> /Jarkko

Let us know how we can help.

Have a good afternoon.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC
4206 N. 19th Ave.           Implementing measured information privacy
Fargo, ND  58102            and integrity architectures.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: gw@idfusion.org
------------------------------------------------------------------------------
"... remember that innovation is saying 'no' to 1000 things."
                                -- Moxie Marlinspike
