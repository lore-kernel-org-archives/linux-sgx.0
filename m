Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29E0C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 14:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BF2720874
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 14:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733251AbeLQON2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 09:13:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:11469 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732311AbeLQON1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 09:13:27 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 06:13:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,365,1539673200"; 
   d="scan'208";a="302842542"
Received: from zhangxi4-mobl5.ccr.corp.intel.com (HELO localhost) ([10.249.254.207])
  by fmsmga006.fm.intel.com with ESMTP; 17 Dec 2018 06:13:16 -0800
Date:   Mon, 17 Dec 2018 16:13:15 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Dr. Greg" <greg@enjellic.com>,
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
Message-ID: <20181217141315.GB4601@linux.intel.com>
References: <C11C9312-65BC-460A-8F9F-608E101AE5C1@amacapital.net>
 <20181128104941.GA23077@wind.enjellic.com>
 <20181128192228.GC9023@linux.intel.com>
 <20181210104908.GA23132@wind.enjellic.com>
 <20181212180036.GC6333@linux.intel.com>
 <20181214235917.GA14049@wind.enjellic.com>
 <20181215000627.GA5799@linux.intel.com>
 <20181217132859.GA31936@linux.intel.com>
 <20181217133928.GA32706@linux.intel.com>
 <20181217140811.GA4601@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181217140811.GA4601@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 04:08:11PM +0200, Jarkko Sakkinen wrote:
> On Mon, Dec 17, 2018 at 03:39:28PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Dec 17, 2018 at 03:28:59PM +0200, Jarkko Sakkinen wrote:
> > > On Fri, Dec 14, 2018 at 04:06:27PM -0800, Sean Christopherson wrote:
> > > > [  504.149548] ------------[ cut here ]------------
> > > > [  504.149550] kernel BUG at /home/sean/go/src/kernel.org/linux/mm/mmap.c:669!
> > > > [  504.150288] invalid opcode: 0000 [#1] SMP
> > > > [  504.150614] CPU: 2 PID: 237 Comm: kworker/u20:2 Not tainted 4.20.0-rc2+ #267
> > > > [  504.151165] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> > > > [  504.151818] Workqueue: sgx-encl-wq sgx_encl_release_worker
> > > > [  504.152267] RIP: 0010:__vma_adjust+0x64a/0x820
> > > > [  504.152626] Code: ff 48 89 50 18 e9 6f fc ff ff 4c 8b ab 88 00 00 00 45 31 e4 e9 61 fb ff ff 31 c0 48 83 c4 60 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 49 89 de 49 83 c6 20 0f 84 06 fe ff ff 49 8d 7e e0 e8 fe ee
> > > > [  504.154109] RSP: 0000:ffffc900004ebd60 EFLAGS: 00010206
> > > > [  504.154535] RAX: 00007fd92ef7e000 RBX: ffff888467af16c0 RCX: ffff888467af16e0
> > > > [  504.155104] RDX: ffff888458fd09e0 RSI: 00007fd954021000 RDI: ffff88846bf9e798
> > > > [  504.155673] RBP: ffff888467af1480 R08: ffff88845bea2000 R09: 0000000000000000
> > > > [  504.156242] R10: 0000000080000000 R11: fefefefefefefeff R12: 0000000000000000
> > > > [  504.156810] R13: ffff88846bf9e790 R14: ffff888467af1b70 R15: ffff888467af1b60
> > > > [  504.157378] FS:  0000000000000000(0000) GS:ffff88846f700000(0000) knlGS:0000000000000000
> > > > [  504.158021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [  504.158483] CR2: 00007f2c56e99000 CR3: 0000000005009001 CR4: 0000000000360ee0
> > > > [  504.159054] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > [  504.159623] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > [  504.160193] Call Trace:
> > > > [  504.160406]  __split_vma+0x16f/0x180
> > > > [  504.160706]  ? __switch_to_asm+0x40/0x70
> > > > [  504.161024]  __do_munmap+0xfb/0x450
> > > > [  504.161308]  sgx_encl_release_worker+0x44/0x70
> > > > [  504.161675]  process_one_work+0x200/0x3f0
> > > > [  504.162004]  worker_thread+0x2d/0x3d0
> > > > [  504.162301]  ? process_one_work+0x3f0/0x3f0
> > > > [  504.162645]  kthread+0x113/0x130
> > > > [  504.162912]  ? kthread_park+0x90/0x90
> > > > [  504.163209]  ret_from_fork+0x35/0x40
> > > > [  504.163503] Modules linked in: bridge stp llc
> > > > [  504.163866] ---[ end trace 83076139fc25e3e0 ]---
> > > 
> > > There was a race with release and swapping code that I thought I fixed,
> > > and this is looks like a race there. Have to recheck what I did not
> > > consider. Anyway, though to share this if you have time to look at it.
> > > That is the part where something is now unsync most probably.
> > 
> > I think I found it. I was careless to make sgx_encl_release() to use
> > sgx_invalidate(), which does not delete pages in the case when enclave
> > is already marked as dead. This was after I had fixed the race that I
> > had there in the first place. That is why I was puzzled why it suddenly
> > reappeared.
> > 
> > Would be nice to use sgx_invalidate() also in release for consistency in
> > semantics sake so maybe just delete this:
> > 
> > 	if (encl->flags & SGX_ENCL_DEAD)
> > 		return;
> 
> Updated master, not at this point next.

If I checked this right was that mmu_notifier_unregister() cause DEAD
to set, and thus when sgx_invalidate() is executed, it returns without
doing anything...

/Jarkko
