Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C0BC43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 17:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16C5120675
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 17:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733040AbeLQRbH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 12:31:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:36143 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbeLQRbH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 12:31:07 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 09:31:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,366,1539673200"; 
   d="scan'208,223";a="119029061"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga002.jf.intel.com with ESMTP; 17 Dec 2018 09:31:06 -0800
Date:   Mon, 17 Dec 2018 09:31:06 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Message-ID: <20181217173106.GB12491@linux.intel.com>
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
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20181217140811.GA4601@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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

This doesn't work as-is.  sgx_encl_release() needs to use sgx_free_page()
and not __sgx_free_page() so that we get a WARN() if the page can't be
freed.  sgx_invalidate() needs to use __sgx_free_page() as freeing a page
can fail due to running concurrently with reclaim.  I'll play around with
the code a bit, there's probably a fairly clean way to share code between
the two flows.

> 
> Updated master, not at this point next.

Still broken (as Greg's parallel email points out).

sgx_encl_release_worker() calls do_unmap() without checking the validity
of the page tables[1].  As is, the code doesn't even guarantee mm_struct
itself is valid.

The easiest fix I can think of is to add a SGX_ENCL_MM_RELEASED flag
that is set along with SGX_ENCL_DEAD in sgx_mmu_notifier_release(), and
only call do_unmap() if SGX_ENCL_MM_RELEASED is false.  Note that this
means we cant unregister the mmu_notifier until after do_unmap(), but
that's true no matter what since we're relying on the mmu_notifier to
hold a reference to mm_struct.  Patch attached.

[1] https://www.spinics.net/lists/dri-devel/msg186827.html

--IJpNTDwzlM2Ie8A6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-sgx-Do-not-attempt-to-unmap-enclave-VMAs-if-mm_s.patch"

From 7cfdf34ec5b70392216b24853d6b8cc5e3192a92 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Mon, 17 Dec 2018 09:21:14 -0800
Subject: [PATCH] x86/sgx: Do not attempt to unmap enclave VMAs if mm_struct is
 defunct

Add a flag, SGX_ENCL_MM_RELEASED, to explicitly track the lifecycle of
the enclave's associated mm_struct.  Simply ensuring the mm_struct
itself is valid is not sufficient as the VMAs and page tables can be
removed after sgx_mmu_notifier_release() is invoked[1].

Note that this means mmu_notifier can't be unregistered until after
do_unmap(), but that's true no matter what since the mmu_notifier
holds the enclave's reference to mm_struct, i.e. this also fixes a
potential use-after-free bug of the mm_struct.

[1] https://www.spinics.net/lists/dri-devel/msg186827.html

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/driver.h |  1 +
 arch/x86/kernel/cpu/sgx/driver/encl.c   | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
index 56f45cd433dd..d7c51284ef36 100644
--- a/arch/x86/kernel/cpu/sgx/driver/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -89,6 +89,7 @@ enum sgx_encl_flags {
 	SGX_ENCL_DEBUG		= BIT(1),
 	SGX_ENCL_SUSPEND	= BIT(2),
 	SGX_ENCL_DEAD		= BIT(3),
+	SGX_ENCL_MM_RELEASED	= BIT(4),
 };
 
 struct sgx_encl {
diff --git a/arch/x86/kernel/cpu/sgx/driver/encl.c b/arch/x86/kernel/cpu/sgx/driver/encl.c
index 923e31eb6552..77c5e65533fb 100644
--- a/arch/x86/kernel/cpu/sgx/driver/encl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/encl.c
@@ -311,7 +311,7 @@ static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
 		container_of(mn, struct sgx_encl, mmu_notifier);
 
 	mutex_lock(&encl->lock);
-	encl->flags |= SGX_ENCL_DEAD;
+	encl->flags |= SGX_ENCL_DEAD | SGX_ENCL_MM_RELEASED;
 	mutex_unlock(&encl->lock);
 }
 
@@ -967,10 +967,15 @@ static void sgx_encl_release_worker(struct work_struct *work)
 	struct sgx_encl *encl = container_of(work, struct sgx_encl, work);
 	unsigned long backing_size = encl->size + PAGE_SIZE;
 
-	down_write(&encl->mm->mmap_sem);
-	do_munmap(encl->mm, (unsigned long)encl->backing, backing_size +
-		  (backing_size >> 5), NULL);
-	up_write(&encl->mm->mmap_sem);
+	if (!(encl->flags & SGX_ENCL_MM_RELEASED)) {
+		down_write(&encl->mm->mmap_sem);
+		do_munmap(encl->mm, (unsigned long)encl->backing,
+			  backing_size + (backing_size >> 5), NULL);
+		up_write(&encl->mm->mmap_sem);
+	}
+
+	if (encl->mmu_notifier.ops)
+		mmu_notifier_unregister(&encl->mmu_notifier, encl->mm);
 
 	if (encl->tgid)
 		put_pid(encl->tgid);
@@ -990,9 +995,6 @@ void sgx_encl_release(struct kref *ref)
 {
 	struct sgx_encl *encl = container_of(ref, struct sgx_encl, refcount);
 
-	if (encl->mmu_notifier.ops)
-		mmu_notifier_unregister(&encl->mmu_notifier, encl->mm);
-
 	if (encl->pm_notifier.notifier_call)
 		unregister_pm_notifier(&encl->pm_notifier);
 
-- 
2.19.2


--IJpNTDwzlM2Ie8A6--
