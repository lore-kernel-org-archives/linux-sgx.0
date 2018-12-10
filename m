Return-Path: <SRS0=QEGF=OT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EC0C04EB8
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 10:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02FD22084E
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 10:50:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02FD22084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbeLJKuF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Dec 2018 05:50:05 -0500
Received: from wind.enjellic.com ([76.10.64.91]:56534 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbeLJKuF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Dec 2018 05:50:05 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wBAAn9PE023524;
        Mon, 10 Dec 2018 04:49:09 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wBAAn84l023523;
        Mon, 10 Dec 2018 04:49:08 -0600
Date:   Mon, 10 Dec 2018 04:49:08 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181210104908.GA23132@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181124172114.GB32210@linux.intel.com> <20181125145329.GA5777@linux.intel.com> <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net> <20181126215145.GC868@linux.intel.com> <20181126230436.GA6737@linux.intel.com> <20181127085533.GA12247@wind.enjellic.com> <20181127164129.GB4170@linux.intel.com> <C11C9312-65BC-460A-8F9F-608E101AE5C1@amacapital.net> <20181128104941.GA23077@wind.enjellic.com> <20181128192228.GC9023@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128192228.GC9023@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Mon, 10 Dec 2018 04:49:09 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 28, 2018 at 11:22:28AM -0800, Jarkko Sakkinen wrote:

Good morning, I hope everyone had a pleasant weekend.

> On Wed, Nov 28, 2018 at 04:49:41AM -0600, Dr. Greg wrote:
> > We've been carrying a patch, that drops in on top of the proposed
> > kernel driver, that implements the needed policy management framework
> > for DAC fragile (FLC) platforms.  After a meeting yesterday with the
> > client that is funding the work, a decision was made to release the
> > enhancements when the SGX driver goes mainline.  That will at least
> > give developers the option of creating solutions on Linux that
> > implement the security guarantees that SGX was designed to deliver.

> We do not need yet another policy management framework to the *kernel*.
>
> The token based approach that Andy is proposing is proven and well
> established method to create a mechanism. You can then create a
> daemon to user space that decides who it wants to send tokes.

I guess there will be plenty of time to argue about all of that.

In the meantime, I wanted to confirm that your jarkko-sgx/master
branch contains the proposed driver that is headed upstream.  Before
adding the SFLC patches we thought it best to run the driver through
some testing in order to verify that any problems we generated where
attributable to our work and not the base driver.

At the current time jarkko-sgx/master appears to be having difficulty
initializing the unit test enclave for our trusted runtime API
librarary.  Enclave creation and loading appear to work fine, things
go south after the EINIT ioctl is called on the loaded image.

We specifically isolated the regressions to occur secondary to the
EINIT ioctl being called.  We modified our sgx-load test utility to
pause with the image loaded, but not initialized.  We generated a fair
amount of system activity while the process was holding the enclave
image open and there were no issues.  The process was then allowed to
unmap the virtual memory image without calling EINIT and the system
was fine after that as well.

Symptoms vary, but in all cases appear to be linked to corruption of
the virtual memory infrastructure.  In all cases, the kernel ends up
at a point where any attempt to start a new process hangs and becomes
uninterruptible.  The full kernel failure does not appear to be
synchronous with when EINIT is called, which would support the notion
that something is going wrong with the VM management that is being
workqueue deferred.

This is with your MPX patch applied that corrects issues with the
wrong memory management context being acted upon by that system.  In
any event, the kernel configuration being used for testing does not
have MPX support even enabled.  Given that the changelog for the patch
is indicating the new driver is attempting something unique with
workqueue deferred VM management, it would seem possible that the
driver is tickling bad and possibly untested behavior elsewhere in the
kernel as well.

The enclave in question is not terribly sophisticated by the standards
of our other enclaves, but it is a non-trivial test of SGX
functionality.  It weighs in at about 156K and is generated and signed
in debug mode with version 1.4 compliant metadata.  Obviously it
initializes and runs fine with the out-of-tree driver.

We managed to capture two separate sets of error logs/backtraces that
are included below.  As I'm sure you know, without module support,
working on all of this is a bit painful as it requires the classic
edit-compile-link-boot-whimper procedure.... :-)

Given that the self-test committed to the kernel sources is a trivial
one page enclave and the proposed driver ABI is incompatible with the
released Intel Linux PSW/SDK, this may be the most challenging test
the driver has been put through.  Unless your PSW/SDK team is testing
the new driver behind the scenes.

Obviously let us know if jarkko-master/sgx is not where the action is
at or if you would like us to move forward with alternative testing.

Regression traces follow:

Event 1: -------------------------------------------------------------------
Dec  9 07:35:15 nuc2 kernel: general protection fault: 0000 [#1] SMP PTI
Dec  9 07:35:15 nuc2 kernel: CPU: 1 PID: 1594 Comm: less Not tainted 4.20.0-rc2-sgx-nuc2+ #11
Dec  9 07:35:15 nuc2 kernel: Hardware name: Intel Corporation NUC7CJYH/NUC7JYB, BIOS JYGLKCPX.86A.0046.2018.1103.1316 11/03/2018
Dec  9 07:35:15 nuc2 kernel: RIP: 0010:unmap_vmas+0x3c/0x83
Dec  9 07:35:15 nuc2 kernel: Code: 49 89 cc 53 48 89 f3 4c 8b 6e 40 49 83 bd a0 03 00 00 00 74 32 b9 01 00 00 00 4c 89 e2 4c 89 f6 4c 89 ef e8 db be 01 00 eb 1d <4c> 39 23 73 1d 48 89 de 45 31 c0 4c 89 e1 4c 89 f2 4c 89 ff e8 cb
Dec  9 07:35:15 nuc2 kernel: RSP: 0018:ffff9fd7404c7d90 EFLAGS: 00010282
Dec  9 07:35:15 nuc2 kernel: RAX: 000000000007755e RBX: ffff0f66fad412e0 RCX: 0000000000000000
Dec  9 07:35:15 nuc2 kernel: RDX: ffff8b66f9e42ee0 RSI: ffff8b66f9e42c00 RDI: ffff9fd7404c7dc8
Dec  9 07:35:15 nuc2 kernel: RBP: ffff9fd7404c7db8 R08: 0000000000000014 R09: 000000000007755e
Dec  9 07:35:15 nuc2 kernel: R10: ffff9fd7404c7cc0 R11: 0000000000000000 R12: ffffffffffffffff
Dec  9 07:35:15 nuc2 kernel: R13: ffff8b66f9e42c00 R14: 0000000000000000 R15: ffff9fd7404c7dc8
Dec  9 07:35:15 nuc2 kernel: FS:  0000000000000000(0000) GS:ffff8b66fbe80000(0000) knlGS:0000000000000000
Dec  9 07:35:15 nuc2 kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Dec  9 07:35:15 nuc2 kernel: CR2: 00000000f7e5cce8 CR3: 000000012ec0a000 CR4: 0000000000340ee0
Dec  9 07:35:15 nuc2 kernel: Call Trace:
Dec  9 07:35:15 nuc2 kernel:  exit_mmap+0xab/0x146
Dec  9 07:35:15 nuc2 kernel:  ? __handle_mm_fault+0x6f8/0xb0e
Dec  9 07:35:15 nuc2 kernel:  mmput+0x20/0xa9
Dec  9 07:35:15 nuc2 kernel:  do_exit+0x39d/0x8ad
Dec  9 07:35:15 nuc2 kernel:  ? handle_mm_fault+0x172/0x1c4
Dec  9 07:35:15 nuc2 kernel:  do_group_exit+0x3f/0x96
Dec  9 07:35:15 nuc2 kernel:  __ia32_sys_exit_group+0x12/0x12
Dec  9 07:35:15 nuc2 kernel:  do_fast_syscall_32+0xfd/0x1c1
Dec  9 07:35:15 nuc2 kernel:  entry_SYSENTER_compat+0x7c/0x8e
Dec  9 07:35:15 nuc2 kernel: RIP: 0023:0xf7f638d9
Dec  9 07:35:15 nuc2 kernel: Code: Bad RIP value.
Dec  9 07:35:15 nuc2 kernel: RSP: 002b:00000000ff93594c EFLAGS: 00000206 ORIG_RAX: 00000000000000fc
Dec  9 07:35:15 nuc2 kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000000000
Dec  9 07:35:15 nuc2 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000f7f05288
Dec  9 07:35:15 nuc2 kernel: RBP: 00000000ff935978 R08: 0000000000000000 R09: 0000000000000000
Dec  9 07:35:15 nuc2 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
Dec  9 07:35:15 nuc2 kernel: R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Dec  9 07:35:15 nuc2 kernel: Modules linked in:
Dec  9 07:35:15 nuc2 kernel: ---[ end trace 590ee48fe9cfd7a6 ]---
Dec  9 07:35:15 nuc2 kernel: RIP: 0010:unmap_vmas+0x3c/0x83
Dec  9 07:35:15 nuc2 kernel: Code: 49 89 cc 53 48 89 f3 4c 8b 6e 40 49 83 bd a0 03 00 00 00 74 32 b9 01 00 00 00 4c 89 e2 4c 89 f6 4c 89 ef e8 db be 01 00 eb 1d <4c> 39 23 73 1d 48 89 de 45 31 c0 4c 89 e1 4c 89 f2 4c 89 ff e8 cb
Dec  9 07:35:15 nuc2 kernel: RSP: 0018:ffff9fd7404c7d90 EFLAGS: 00010282
Dec  9 07:35:15 nuc2 kernel: RAX: 000000000007755e RBX: ffff0f66fad412e0 RCX: 0000000000000000
Dec  9 07:35:15 nuc2 kernel: RDX: ffff8b66f9e42ee0 RSI: ffff8b66f9e42c00 RDI: ffff9fd7404c7dc8
Dec  9 07:35:15 nuc2 kernel: RBP: ffff9fd7404c7db8 R08: 0000000000000014 R09: 000000000007755e
Dec  9 07:35:15 nuc2 kernel: R10: ffff9fd7404c7cc0 R11: 0000000000000000 R12: ffffffffffffffff
Dec  9 07:35:15 nuc2 kernel: R13: ffff8b66f9e42c00 R14: 0000000000000000 R15: ffff9fd7404c7dc8
Dec  9 07:35:15 nuc2 kernel: FS:  0000000000000000(0000) GS:ffff8b66fbe80000(0000) knlGS:0000000000000000
Dec  9 07:35:15 nuc2 kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Dec  9 07:35:15 nuc2 kernel: CR2: 00000000f7f638af CR3: 000000012ec0a000 CR4: 0000000000340ee0
Dec  9 07:35:15 nuc2 kernel: Fixing recursive fault but reboot is needed!
---------------------------------------------------------------------------

Test 2: --------------------------------------------------------------------
Dec  9 07:55:51 nuc2 kernel: BUG: Bad rss-counter state mm:0000000004eb5fd2 idx:0 val:226
Dec  9 07:55:51 nuc2 kernel: BUG: Bad rss-counter state mm:0000000004eb5fd2 idx:1 val:46
Dec  9 07:55:51 nuc2 kernel: BUG: non-zero pgtables_bytes on freeing mm: 12288
Dec  9 07:56:12 nuc2 kernel: sgx-load[1759]: segfault at 80 ip 0000000000402015 sp 00007ffe727f6a30 error 4 in sgx-load[400000+b000]
Dec  9 07:56:12 nuc2 kernel: Code: ff 41 b8 8c 02 00 00 b9 90 78 40 00 ba 55 77 40 00 be cc 74 40 00 48 89 ef 31 c0 e8 35 ef ff ff e9 1e ff ff ff 48 83 4b 50 01 <49> 8b 8c 24 80 00 00 00 48 89 8b a0 00 00 00 49 8b 8c 24 88 00 00
Dec  9 07:56:17 nuc2 kernel: BUG: Bad rss-counter state mm:00000000666f29a9 idx:0 val:1
Dec  9 07:56:17 nuc2 kernel: BUG: Bad rss-counter state mm:00000000666f29a9 idx:1 val:9
Dec  9 07:56:17 nuc2 kernel: BUG: non-zero pgtables_bytes on freeing mm: 4096
Dec  9 07:56:25 nuc2 kernel: BUG: Bad rss-counter state mm:00000000f23b96cf idx:1 val:4
Dec  9 07:57:17 nuc2 kernel: rcu: INFO: rcu_sched self-detected stall on CPU
Dec  9 07:57:17 nuc2 kernel: rcu: ^I0-....: (14999 ticks this GP) idle=55e/1/0x4000000000000002 softirq=3304/3304 fqs=7499 
Dec  9 07:57:17 nuc2 kernel: rcu: ^I (t=15000 jiffies g=5665 q=50)
Dec  9 07:57:17 nuc2 kernel: NMI backtrace for cpu 0
Dec  9 07:57:17 nuc2 kernel: CPU: 0 PID: 1761 Comm: less Not tainted 4.20.0-rc2-sgx-nuc2+ #11
Dec  9 07:57:17 nuc2 kernel: Hardware name: Intel Corporation NUC7CJYH/NUC7JYB, BIOS JYGLKCPX.86A.0046.2018.1103.1316 11/03/2018
Dec  9 07:57:17 nuc2 kernel: Call Trace:
Dec  9 07:57:17 nuc2 kernel:  <IRQ>
Dec  9 07:57:17 nuc2 kernel:  dump_stack+0x4d/0x63
Dec  9 07:57:17 nuc2 kernel:  nmi_cpu_backtrace+0x7a/0x8b
Dec  9 07:57:17 nuc2 kernel:  ? lapic_can_unplug_cpu+0x98/0x98
----------------------------------------------------------------------------

> /Jarkko

Best wishes for a productive week.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"(3)  With sufficient thrust, pigs fly just fine.  However, this is not
      necessarily a good idea.  It is hard to be sure where they are
      going to land, and it could be dangerous sitting under them as they
      fly overhead."
                                -- RFC 1925
                                   Fundamental Truths of Networking
