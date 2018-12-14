Return-Path: <SRS0=cH1o=OY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7AFDC43387
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Dec 2018 00:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1241B20896
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Dec 2018 00:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbeLOAAO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Dec 2018 19:00:14 -0500
Received: from wind.enjellic.com ([76.10.64.91]:57208 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbeLOAAO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Dec 2018 19:00:14 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wBENxHRl014213;
        Fri, 14 Dec 2018 17:59:17 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wBENxHD2014212;
        Fri, 14 Dec 2018 17:59:17 -0600
Date:   Fri, 14 Dec 2018 17:59:17 -0600
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
        LKML <linux-kernel@vger.kernel.org>, jethro@fortanix.com
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181214235917.GA14049@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net> <20181126215145.GC868@linux.intel.com> <20181126230436.GA6737@linux.intel.com> <20181127085533.GA12247@wind.enjellic.com> <20181127164129.GB4170@linux.intel.com> <C11C9312-65BC-460A-8F9F-608E101AE5C1@amacapital.net> <20181128104941.GA23077@wind.enjellic.com> <20181128192228.GC9023@linux.intel.com> <20181210104908.GA23132@wind.enjellic.com> <20181212180036.GC6333@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181212180036.GC6333@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Fri, 14 Dec 2018 17:59:17 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 12, 2018 at 08:00:36PM +0200, Jarkko Sakkinen wrote:

Good evening, I hope the week has gone well for everyone.

> On Mon, Dec 10, 2018 at 04:49:08AM -0600, Dr. Greg wrote:
> > In the meantime, I wanted to confirm that your jarkko-sgx/master
> > branch contains the proposed driver that is headed upstream.
> > Before adding the SFLC patches we thought it best to run the
> > driver through some testing in order to verify that any problems
> > we generated where attributable to our work and not the base
> > driver.
>
> The master branch is by definition unstable at the moment i.e. it
> can sometimes (not often) contain unfinished changes. Use next for
> testing.  I update next when I consider the master contents "stable
> enough".

I noticed in the last day or so that you appeared to sync
jarkko-sgx/master with jarkko-sgx/next, so I checked out a local
branch against jarkko-sgx/next and ran it against our unit tests.
Based on what we are seeing the driver is still experiencing issues
with initialization of a non-trivial enclave.

On the first test boot of the new kernel, the EINIT ioctl consistently
returned EBUSY over multiple invocations of the unit test.  This did
not appear to generate any negative issues with the kernel at large.

We rebooted the box to run the test against a fresh kernel load.  This
time around we experienced issues similar to what we had previously
described.  The EINIT ioctl generates a segmentation fault which seems
to largely incapacitate the kernel.

Here are the logs and first backtrace from the test:

---------------------------------------------------------------------------
Dec 14 13:25:06 nuc2 kernel: PGD 4f001067 P4D 4f001067 PUD 0 
Dec 14 13:25:06 nuc2 kernel: BUG: unable to handle kernel paging request at ffff97bf3ae916fe
Dec 14 13:25:06 nuc2 kernel: Oops: 0002 [#1] SMP PTI
Dec 14 13:25:06 nuc2 kernel: CPU: 1 PID: 34 Comm: kworker/1:1 Not tainted 4.20.0-rc2-sgx-nuc2+ #12
Dec 14 13:25:06 nuc2 kernel: Hardware name: Intel Corporation NUC7CJYH/NUC7JYB, BIOS JYGLKCPX.86A.0046.2018.1103.1316 11/03/2018
Dec 14 13:25:06 nuc2 kernel: Workqueue: events cache_reap
Dec 14 13:25:06 nuc2 kernel: RIP: 0010:free_block+0xe3/0x182
Dec 14 13:25:06 nuc2 kernel: Code: 20 45 29 d4 41 d3 ec 0f b6 4f 1d 45 01 e2 41 d3 ea 41 8b 49 30 ff c9 49 83 79 20 00 41 89 49 30 75 04 4d 89 59 20 4d 8b 59 20 <45> 88 14 0b 49 8d 49 08 41 83 79 30 00 75 1a 4c 8b 50 28 49 89 4a
Dec 14 13:25:06 nuc2 kernel: RSP: 0018:ffffb90800123db0 EFLAGS: 00210046
Dec 14 13:25:06 nuc2 kernel: RAX: ffff97be3b419080 RBX: 000000000000000f RCX: 00000000ffffff7e
Dec 14 13:25:06 nuc2 kernel: RDX: 0000000000000018 RSI: ffffd907ffc82b70 RDI: ffff97be3b44c200
Dec 14 13:25:06 nuc2 kernel: RBP: ffffb90800123dd8 R08: ffffb90800123e10 R09: fffff9b345eba440
Dec 14 13:25:06 nuc2 kernel: R10: 000000000051f663 R11: ffff97be3ae91780 R12: 0000000011ede5c3
Dec 14 13:25:06 nuc2 kernel: R13: ffffffff80000000 R14: ffff97be3b419088 R15: ffff97be3b4190a8
Dec 14 13:25:06 nuc2 kernel: FS:  0000000000000000(0000) GS:ffff97be3be80000(0000) knlGS:0000000000000000
Dec 14 13:25:06 nuc2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec 14 13:25:06 nuc2 kernel: CR2: ffff97bf3ae916fe CR3: 000000004ec0a000 CR4: 0000000000340ee0
Dec 14 13:25:06 nuc2 kernel: Call Trace:
Dec 14 13:25:06 nuc2 kernel:  drain_array_locked+0x50/0x75
Dec 14 13:25:06 nuc2 kernel:  drain_array.constprop.67+0x57/0x72
Dec 14 13:25:06 nuc2 kernel:  cache_reap+0x58/0x101
Dec 14 13:25:06 nuc2 kernel:  process_one_work+0x183/0x271
Dec 14 13:25:06 nuc2 kernel:  worker_thread+0x1e5/0x2b4
Dec 14 13:25:06 nuc2 kernel:  ? cancel_delayed_work_sync+0x10/0x10
Dec 14 13:25:06 nuc2 kernel:  kthread+0x116/0x11e
Dec 14 13:25:06 nuc2 kernel:  ? kthread_park+0x7e/0x7e
Dec 14 13:25:06 nuc2 kernel:  ret_from_fork+0x1f/0x40
Dec 14 13:25:06 nuc2 kernel: Modules linked in:
Dec 14 13:25:06 nuc2 kernel: CR2: ffff97bf3ae916fe
Dec 14 13:25:06 nuc2 kernel: ---[ end trace 7f5dc24edc7285b3 ]---
Dec 14 13:25:06 nuc2 kernel: RIP: 0010:free_block+0xe3/0x182
Dec 14 13:25:06 nuc2 kernel: Code: 20 45 29 d4 41 d3 ec 0f b6 4f 1d 45 01 e2 41 d3 ea 41 8b 49 30 ff c9 49 83 79 20 00 41 89 49 30 75 04 4d 89 59 20 4d 8b 59 20 <45> 88 14 0b 49 8d 49 08 41 83 79 30 00 75 1a 4c 8b 50 28 49 89 4a
Dec 14 13:25:06 nuc2 kernel: RSP: 0018:ffffb90800123db0 EFLAGS: 00210046
Dec 14 13:25:06 nuc2 kernel: RAX: ffff97be3b419080 RBX: 000000000000000f RCX: 00000000ffffff7e
Dec 14 13:25:06 nuc2 kernel: RDX: 0000000000000018 RSI: ffffd907ffc82b70 RDI: ffff97be3b44c200
Dec 14 13:25:06 nuc2 kernel: RBP: ffffb90800123dd8 R08: ffffb90800123e10 R09: fffff9b345eba440
Dec 14 13:25:06 nuc2 kernel: R10: 000000000051f663 R11: ffff97be3ae91780 R12: 0000000011ede5c3
Dec 14 13:25:06 nuc2 kernel: R13: ffffffff80000000 R14: ffff97be3b419088 R15: ffff97be3b4190a8
Dec 14 13:25:06 nuc2 kernel: FS:  0000000000000000(0000) GS:ffff97be3be80000(0000) knlGS:0000000000000000
Dec 14 13:25:06 nuc2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec 14 13:25:06 nuc2 kernel: CR2: ffff97bf3ae916fe CR3: 000000004ec0a000 CR4: 0000000000340ee0
Dec 14 13:25:21 nuc2 kernel: sgx-load[1596]: segfault at 80 ip 0000000000402015 sp 00007ffdb267e2f0 error 4 in sgx-load[400000+b000]
Dec 14 13:25:21 nuc2 kernel: Code: ff 41 b8 8c 02 00 00 b9 90 78 40 00 ba 5d 77 40 00 be cc 74 40 00 48 89 ef 31 c0 e8 35 ef ff ff e9 1e ff ff ff 48 83 4b 50 01 <49> 8b 8c 24 80 00 00 00 48 89 8b a0 00 00 00 49 8b 8c 24 88 00 00
---------------------------------------------------------------------------

This is a post 'make distclean' compile from a fresh branch of
jarkko-sgx/next with no modifications.

For testing purposes we created a branch of our PSW and dropped the
EINITTOKEN pointer from the sgx_enclave_init structure in order to
make our runtime compatible with the new variant of
SGX_IOC_ENCLAVE_INIT.  As I noted in my previous e-mail, our runtime
doesn't appear to be having any issues with the creation and load of
the enclave.

We are assuming there is an intent for the new driver to be reasonably
compatible with the current Intel PSW/SDK.  Even if this isn't the
case it would seem to be problematic if it is possible for a badly
formed IOCTL call to tip the kernel over.

Jethro are you guys testing the driver against any non-trivial
enclaves?

> Thanks.
> 
> /Jarkko

Let us know if you would like us to experiment with anything in
particular.

Have a good weekend.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"You and Uncle Pete drank the whole thing?  That was a $250.00 bottle
 of whisky.

 Yeah, it was good."
                                -- Rick Engen
                                   Resurrection.
