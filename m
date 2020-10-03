Return-Path: <SRS0=MzOG=DK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE0EC4363D
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 18:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59DD4206DD
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 18:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgJCSX7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Oct 2020 14:23:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:11038 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgJCSX6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Oct 2020 14:23:58 -0400
IronPort-SDR: VkCqjg/4By1L+vzBTr2os+YGJu8KlTYDMP08Ktx0/xyQ/ckG/ovVyEpIzv4fw5oKf4XqCOZ9qN
 s+KnothdcE3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9763"; a="160623443"
X-IronPort-AV: E=Sophos;i="5.77,332,1596524400"; 
   d="scan'208";a="160623443"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2020 11:23:55 -0700
IronPort-SDR: FfsyzhNh+/7e/AxDYDoptTIFJlBPeB66OS5zN2BiqovYPL7lFgqC138f+HpNiNzhY25zEDFRBx
 mpkyQE6xxRpA==
X-IronPort-AV: E=Sophos;i="5.77,332,1596524400"; 
   d="scan'208";a="515434696"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO mqcpg7oapc828.gar.corp.intel.com) ([10.255.33.59])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 03 Oct 2020 11:23:50 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Jethro Beekman" <jethro@fortanix.com>,
        "Jordan Hand" <jorhand@linux.microsoft.com>,
        "Nathaniel McCallum" <npmccallum@redhat.com>,
        "Chunyang Hui" <sanqian.hcy@antfin.com>,
        "Seth Moore" <sethmo@google.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com, willy@infradead.org
Subject: Re: [PATCH v39 16/24] x86/sgx: Add a page reclaimer
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-17-jarkko.sakkinen@linux.intel.com>
 <op.0rwbv916wjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20201003133245.GA6074@linux.intel.com>
Date:   Sat, 03 Oct 2020 13:23:49 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0rxb1z06wjvjmi@mqcpg7oapc828.gar.corp.intel.com>
In-Reply-To: <20201003133245.GA6074@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, 03 Oct 2020 08:32:45 -0500, Jarkko Sakkinen  
<jarkko.sakkinen@linux.intel.com> wrote:

> On Sat, Oct 03, 2020 at 12:22:47AM -0500, Haitao Huang wrote:
>> When I turn on CONFIG_PROVE_LOCKING, kernel reports following  
>> suspicious RCU
>> usages. Not sure if it is an issue. Just reporting here:
>
> I'm glad to hear that my tip helped you to get us the data.
>
> This does not look like an issue in the page reclaimer, which was not
> obvious for me before. That's a good thing. I was really worried about
> that because it has been very stable for a long period now. The last
> bug fix for the reclaimer was done in June in v31 version of the patch
> set and after that it has been unchanged (except possibly some renames
> requested by Boris).
>
> I wildly guess I have a bad usage pattern for xarray. I migrated to it
> in v36, and it is entirely possible that I've misused it. It was the
> first time that I ever used it. Before xarray we had radix_tree but
> based Matthew Wilcox feedback I did a migration to xarray.
>
> What I'd ask you to do next is to, if by any means possible, to try to
> run the same test with v35 so we can verify this. That one still has
> the radix tree.
>


v35 does not cause any such warning messages from kernel

> Thank you.
>
> /Jarkko
>
>>
>> [ +34.337095] =============================
>> [  +0.000001] WARNING: suspicious RCU usage
>> [  +0.000002] 5.9.0-rc6-lock-sgx39 #1 Not tainted
>> [  +0.000001] -----------------------------
>> [  +0.000001] ./include/linux/xarray.h:1165 suspicious
>> rcu_dereference_check() usage!
>> [  +0.000001]
>>               other info that might help us debug this:
>>
>> [  +0.000001]
>>               rcu_scheduler_active = 2, debug_locks = 1
>> [  +0.000001] 1 lock held by enclaveos-runne/4238:
>> [  +0.000001]  #0: ffff9cc6657e45e8 (&mm->mmap_lock#2){++++}-{3:3}, at:
>> vm_mmap_pgoff+0xa1/0x120
>> [  +0.000005]
>>               stack backtrace:
>> [  +0.000002] CPU: 1 PID: 4238 Comm: enclaveos-runne Not tainted
>> 5.9.0-rc6-lock-sgx39 #1
>> [  +0.000001] Hardware name: Microsoft Corporation Virtual  
>> Machine/Virtual
>> Machine, BIOS Hyper-V UEFI Release v4.1 04/02/2020
>> [  +0.000002] Call Trace:
>> [  +0.000003]  dump_stack+0x7d/0x9f
>> [  +0.000003]  lockdep_rcu_suspicious+0xce/0xf0
>> [  +0.000004]  xas_start+0x14c/0x1c0
>> [  +0.000003]  xas_load+0xf/0x50
>> [  +0.000002]  xas_find+0x25c/0x2c0
>> [  +0.000004]  sgx_encl_may_map+0x87/0x1c0
>> [  +0.000006]  sgx_mmap+0x29/0x70
>> [  +0.000003]  mmap_region+0x3ee/0x710
>> [  +0.000006]  do_mmap+0x3f1/0x5e0
>> [  +0.000004]  vm_mmap_pgoff+0xcd/0x120
>> [  +0.000007]  ksys_mmap_pgoff+0x1de/0x240
>> [  +0.000005]  __x64_sys_mmap+0x33/0x40
>> [  +0.000002]  do_syscall_64+0x37/0x80
>> [  +0.000003]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [  +0.000002] RIP: 0033:0x7fe34efe06ba
>> [  +0.000002] Code: 89 f5 41 54 49 89 fc 55 53 74 35 49 63 e8 48 63 da  
>> 4d 89
>> f9 49 89 e8 4d 63 d6 48 89 da 4c 89 ee 4c 89 e7 b8 09 00 00 00 0f 05  
>> <48> 3d
>> 00 f0 ff ff 77 56 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 1f 00
>> [  +0.000001] RSP: 002b:00007ffee83eac08 EFLAGS: 00000206 ORIG_RAX:
>> 0000000000000009
>> [  +0.000001] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
>> 00007fe34efe06ba
>> [  +0.000001] RDX: 0000000000000001 RSI: 0000000000001000 RDI:
>> 0000000007fff000
>> [  +0.000001] RBP: 0000000000000004 R08: 0000000000000004 R09:
>> 0000000000000000
>> [  +0.000001] R10: 0000000000000011 R11: 0000000000000206 R12:
>> 0000000007fff000
>> [  +0.000001] R13: 0000000000001000 R14: 0000000000000011 R15:
>> 0000000000000000
>>
>> [  +0.000010] =============================
>> [  +0.000001] WARNING: suspicious RCU usage
>> [  +0.000001] 5.9.0-rc6-lock-sgx39 #1 Not tainted
>> [  +0.000001] -----------------------------
>> [  +0.000001] ./include/linux/xarray.h:1181 suspicious
>> rcu_dereference_check() usage!
>> [  +0.000001]
>>               other info that might help us debug this:
>>
>> [  +0.000001]
>>               rcu_scheduler_active = 2, debug_locks = 1
>> [  +0.000001] 1 lock held by enclaveos-runne/4238:
>> [  +0.000001]  #0: ffff9cc6657e45e8 (&mm->mmap_lock#2){++++}-{3:3}, at:
>> vm_mmap_pgoff+0xa1/0x120
>> [  +0.000003]
>>               stack backtrace:
>> [  +0.000001] CPU: 1 PID: 4238 Comm: enclaveos-runne Not tainted
>> 5.9.0-rc6-lock-sgx39 #1
>> [  +0.000001] Hardware name: Microsoft Corporation Virtual  
>> Machine/Virtual
>> Machine, BIOS Hyper-V UEFI Release v4.1 04/02/2020
>> [  +0.000001] Call Trace:
>> [  +0.000001]  dump_stack+0x7d/0x9f
>> [  +0.000003]  lockdep_rcu_suspicious+0xce/0xf0
>> [  +0.000003]  xas_descend+0x116/0x120
>> [  +0.000004]  xas_load+0x42/0x50
>> [  +0.000002]  xas_find+0x25c/0x2c0
>> [  +0.000004]  sgx_encl_may_map+0x87/0x1c0
>> [  +0.000006]  sgx_mmap+0x29/0x70
>> [  +0.000002]  mmap_region+0x3ee/0x710
>> [  +0.000006]  do_mmap+0x3f1/0x5e0
>> [  +0.000004]  vm_mmap_pgoff+0xcd/0x120
>> [  +0.000007]  ksys_mmap_pgoff+0x1de/0x240
>> [  +0.000005]  __x64_sys_mmap+0x33/0x40
>> [  +0.000002]  do_syscall_64+0x37/0x80
>> [  +0.000002]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [  +0.000001] RIP: 0033:0x7fe34efe06ba
>> [  +0.000001] Code: 89 f5 41 54 49 89 fc 55 53 74 35 49 63 e8 48 63 da  
>> 4d 89
>> f9 49 89 e8 4d 63 d6 48 89 da 4c 89 ee 4c 89 e7 b8 09 00 00 00 0f 05  
>> <48> 3d
>> 00 f0 ff ff 77 56 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 1f 00
>> [  +0.000001] RSP: 002b:00007ffee83eac08 EFLAGS: 00000206 ORIG_RAX:
>> 0000000000000009
>> [  +0.000001] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
>> 00007fe34efe06ba
>> [  +0.000001] RDX: 0000000000000001 RSI: 0000000000001000 RDI:
>> 0000000007fff000
>> [  +0.000001] RBP: 0000000000000004 R08: 0000000000000004 R09:
>> 0000000000000000
>> [  +0.000001] R10: 0000000000000011 R11: 0000000000000206 R12:
>> 0000000007fff000
>> [  +0.000001] R13: 0000000000001000 R14: 0000000000000011 R15:
>> 0000000000000000
>>
>> [  +0.001117] =============================
>> [  +0.000001] WARNING: suspicious RCU usage
>> [  +0.000001] 5.9.0-rc6-lock-sgx39 #1 Not tainted
>> [  +0.000001] -----------------------------
>> [  +0.000001] ./include/linux/xarray.h:1181 suspicious
>> rcu_dereference_check() usage!
>> [  +0.000001]
>>               other info that might help us debug this:
>>
>> [  +0.000001]
>>               rcu_scheduler_active = 2, debug_locks = 1
>> [  +0.000001] 1 lock held by enclaveos-runne/4238:
>> [  +0.000001]  #0: ffff9cc6657e45e8 (&mm->mmap_lock#2){++++}-{3:3}, at:
>> vm_mmap_pgoff+0xa1/0x120
>> [  +0.000003]
>>               stack backtrace:
>> [  +0.000002] CPU: 1 PID: 4238 Comm: enclaveos-runne Not tainted
>> 5.9.0-rc6-lock-sgx39 #1
>> [  +0.000001] Hardware name: Microsoft Corporation Virtual  
>> Machine/Virtual
>> Machine, BIOS Hyper-V UEFI Release v4.1 04/02/2020
>> [  +0.000001] Call Trace:
>> [  +0.000002]  dump_stack+0x7d/0x9f
>> [  +0.000003]  lockdep_rcu_suspicious+0xce/0xf0
>> [  +0.000003]  sgx_encl_may_map+0x1b0/0x1c0
>> [  +0.000006]  sgx_mmap+0x29/0x70
>> [  +0.000002]  mmap_region+0x3ee/0x710
>> [  +0.000006]  do_mmap+0x3f1/0x5e0
>> [  +0.000005]  vm_mmap_pgoff+0xcd/0x120
>> [  +0.000006]  ksys_mmap_pgoff+0x1de/0x240
>> [  +0.000005]  __x64_sys_mmap+0x33/0x40
>> [  +0.000002]  do_syscall_64+0x37/0x80
>> [  +0.000002]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [  +0.000002] RIP: 0033:0x7fe34efe06ba
>> [  +0.000001] Code: 89 f5 41 54 49 89 fc 55 53 74 35 49 63 e8 48 63 da  
>> 4d 89
>> f9 49 89 e8 4d 63 d6 48 89 da 4c 89 ee 4c 89 e7 b8 09 00 00 00 0f 05  
>> <48> 3d
>> 00 f0 ff ff 77 56 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 1f 00
>> [  +0.000001] RSP: 002b:00007ffee83eac08 EFLAGS: 00000206 ORIG_RAX:
>> 0000000000000009
>> [  +0.000001] RAX: ffffffffffffffda RBX: 0000000000000003 RCX:
>> 00007fe34efe06ba
>> [  +0.000001] RDX: 0000000000000003 RSI: 0000000000010000 RDI:
>> 0000000007fee000
>> [  +0.000001] RBP: 0000000000000004 R08: 0000000000000004 R09:
>> 0000000000000000
>> [  +0.000001] R10: 0000000000000011 R11: 0000000000000206 R12:
>> 0000000007fee000
>> [  +0.000001] R13: 0000000000010000 R14: 0000000000000011 R15:
>> 0000000000000000
>>
>> [  +0.003197] =============================
>> [  +0.000001] WARNING: suspicious RCU usage
>> [  +0.000001] 5.9.0-rc6-lock-sgx39 #1 Not tainted
>> [  +0.000001] -----------------------------
>> [  +0.000001] ./include/linux/xarray.h:1198 suspicious
>> rcu_dereference_check() usage!
>> [  +0.000001]
>>               other info that might help us debug this:
>>
>> [  +0.000001]
>>               rcu_scheduler_active = 2, debug_locks = 1
>> [  +0.000001] 1 lock held by enclaveos-runne/4238:
>> [  +0.000001]  #0: ffff9cc6657e45e8 (&mm->mmap_lock#2){++++}-{3:3}, at:
>> vm_mmap_pgoff+0xa1/0x120
>> [  +0.000003]
>>               stack backtrace:
>> [  +0.000002] CPU: 1 PID: 4238 Comm: enclaveos-runne Not tainted
>> 5.9.0-rc6-lock-sgx39 #1
>> [  +0.000001] Hardware name: Microsoft Corporation Virtual  
>> Machine/Virtual
>> Machine, BIOS Hyper-V UEFI Release v4.1 04/02/2020
>> [  +0.000001] Call Trace:
>> [  +0.000002]  dump_stack+0x7d/0x9f
>> [  +0.000003]  lockdep_rcu_suspicious+0xce/0xf0
>> [  +0.000004]  xas_find+0x255/0x2c0
>> [  +0.000003]  sgx_encl_may_map+0xad/0x1c0
>> [  +0.000006]  sgx_mmap+0x29/0x70
>> [  +0.000003]  mmap_region+0x3ee/0x710
>> [  +0.000005]  do_mmap+0x3f1/0x5e0
>> [  +0.000005]  vm_mmap_pgoff+0xcd/0x120
>> [  +0.000007]  ksys_mmap_pgoff+0x1de/0x240
>> [  +0.000004]  __x64_sys_mmap+0x33/0x40
>> [  +0.000002]  do_syscall_64+0x37/0x80
>> [  +0.000002]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [  +0.000002] RIP: 0033:0x7fe34efe06ba
>> [  +0.000001] Code: 89 f5 41 54 49 89 fc 55 53 74 35 49 63 e8 48 63 da  
>> 4d 89
>> f9 49 89 e8 4d 63 d6 48 89 da 4c 89 ee 4c 89 e7 b8 09 00 00 00 0f 05  
>> <48> 3d
>> 00 f0 ff ff 77 56 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 1f 00
>> [  +0.000001] RSP: 002b:00007ffee83eac08 EFLAGS: 00000206 ORIG_RAX:
>> 0000000000000009
>> [  +0.000002] RAX: ffffffffffffffda RBX: 0000000000000003 RCX:
>> 00007fe34efe06ba
>> [  +0.000001] RDX: 0000000000000003 RSI: 0000000000010000 RDI:
>> 0000000007fba000
>> [  +0.000001] RBP: 0000000000000004 R08: 0000000000000004 R09:
>> 0000000000000000
>> [  +0.000001] R10: 0000000000000011 R11: 0000000000000206 R12:
>> 0000000007fba000
>> [  +0.000001] R13: 0000000000010000 R14: 0000000000000011 R15:
>> 0000000000000000
>>
>>
>> On Fri, 02 Oct 2020 23:50:51 -0500, Jarkko Sakkinen
>> <jarkko.sakkinen@linux.intel.com> wrote:
>>
>> > There is a limited amount of EPC available. Therefore, some of it  
>> must be
>> > copied to the regular memory, and only subset kept in the SGX reserved
>> > memory. While kernel cannot directly access enclave memory, SGX  
>> provides
>> > a
>> > set of ENCLS leaf functions to perform reclaiming.
>> >
>> > Implement a page reclaimer by using these leaf functions. It picks the
>> > victim pages in LRU fashion from all the enclaves running in the  
>> system.
>> > The thread ksgxswapd reclaims pages on the event when the number of  
>> free
>> > EPC pages goes below SGX_NR_LOW_PAGES up until it reaches
>> > SGX_NR_HIGH_PAGES.
>> >
>> > sgx_alloc_epc_page() can optionally directly reclaim pages with  
>> @reclaim
>> > set true. A caller must also supply owner for each page so that the
>> > reclaimer can access the associated enclaves. This is needed for  
>> locking,
>> > as most of the ENCLS leafs cannot be executed concurrently for an
>> > enclave.
>> > The owner is also needed for accessing SECS, which is required to be
>> > resident when its child pages are being reclaimed.
>> >
>> > Cc: linux-mm@kvack.org
>> > Acked-by: Jethro Beekman <jethro@fortanix.com>
>> > Tested-by: Jethro Beekman <jethro@fortanix.com>
>> > Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
>> > Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
>> > Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
>> > Tested-by: Seth Moore <sethmo@google.com>
>> > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> > ---
>> >  arch/x86/kernel/cpu/sgx/driver.c |   1 +
>> >  arch/x86/kernel/cpu/sgx/encl.c   | 344 +++++++++++++++++++++-
>> >  arch/x86/kernel/cpu/sgx/encl.h   |  41 +++
>> >  arch/x86/kernel/cpu/sgx/ioctl.c  |  78 ++++-
>> >  arch/x86/kernel/cpu/sgx/main.c   | 481  
>> +++++++++++++++++++++++++++++++
>> >  arch/x86/kernel/cpu/sgx/sgx.h    |   9 +
>> >  6 files changed, 947 insertions(+), 7 deletions(-)
>> >
>> > diff --git a/arch/x86/kernel/cpu/sgx/driver.c
>> > b/arch/x86/kernel/cpu/sgx/driver.c
>> > index d01b28f7ce4a..0446781cc7a2 100644
>> > --- a/arch/x86/kernel/cpu/sgx/driver.c
>> > +++ b/arch/x86/kernel/cpu/sgx/driver.c
>> > @@ -29,6 +29,7 @@ static int sgx_open(struct inode *inode, struct file
>> > *file)
>> >  	atomic_set(&encl->flags, 0);
>> >  	kref_init(&encl->refcount);
>> >  	xa_init(&encl->page_array);
>> > +	INIT_LIST_HEAD(&encl->va_pages);
>> >  	mutex_init(&encl->lock);
>> >  	INIT_LIST_HEAD(&encl->mm_list);
>> >  	spin_lock_init(&encl->mm_lock);
>> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c
>> > b/arch/x86/kernel/cpu/sgx/encl.c
>> > index c2c4a77af36b..54326efa6c2f 100644
>> > --- a/arch/x86/kernel/cpu/sgx/encl.c
>> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
>> > @@ -12,9 +12,88 @@
>> >  #include "encls.h"
>> >  #include "sgx.h"
>> > +/*
>> > + * ELDU: Load an EPC page as unblocked. For more info, see "OS
>> > Management of EPC
>> > + * Pages" in the SDM.
>> > + */
>> > +static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>> > +			   struct sgx_epc_page *epc_page,
>> > +			   struct sgx_epc_page *secs_page)
>> > +{
>> > +	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
>> > +	struct sgx_encl *encl = encl_page->encl;
>> > +	struct sgx_pageinfo pginfo;
>> > +	struct sgx_backing b;
>> > +	pgoff_t page_index;
>> > +	int ret;
>> > +
>> > +	if (secs_page)
>> > +		page_index = SGX_ENCL_PAGE_INDEX(encl_page);
>> > +	else
>> > +		page_index = PFN_DOWN(encl->size);
>> > +
>> > +	ret = sgx_encl_get_backing(encl, page_index, &b);
>> > +	if (ret)
>> > +		return ret;
>> > +
>> > +	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
>> > +	pginfo.contents = (unsigned long)kmap_atomic(b.contents);
>> > +	pginfo.metadata = (unsigned long)kmap_atomic(b.pcmd) +
>> > +			  b.pcmd_offset;
>> > +
>> > +	if (secs_page)
>> > +		pginfo.secs = (u64)sgx_get_epc_addr(secs_page);
>> > +	else
>> > +		pginfo.secs = 0;
>> > +
>> > +	ret = __eldu(&pginfo, sgx_get_epc_addr(epc_page),
>> > +		     sgx_get_epc_addr(encl_page->va_page->epc_page) +
>> > +				      va_offset);
>> > +	if (ret) {
>> > +		if (encls_failed(ret))
>> > +			ENCLS_WARN(ret, "ELDU");
>> > +
>> > +		ret = -EFAULT;
>> > +	}
>> > +
>> > +	kunmap_atomic((void *)(unsigned long)(pginfo.metadata -
>> > b.pcmd_offset));
>> > +	kunmap_atomic((void *)(unsigned long)pginfo.contents);
>> > +
>> > +	sgx_encl_put_backing(&b, false);
>> > +
>> > +	return ret;
>> > +}
>> > +
>> > +static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page
>> > *encl_page,
>> > +					  struct sgx_epc_page *secs_page)
>> > +{
>> > +	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
>> > +	struct sgx_encl *encl = encl_page->encl;
>> > +	struct sgx_epc_page *epc_page;
>> > +	int ret;
>> > +
>> > +	epc_page = sgx_alloc_epc_page(encl_page, false);
>> > +	if (IS_ERR(epc_page))
>> > +		return epc_page;
>> > +
>> > +	ret = __sgx_encl_eldu(encl_page, epc_page, secs_page);
>> > +	if (ret) {
>> > +		sgx_free_epc_page(epc_page);
>> > +		return ERR_PTR(ret);
>> > +	}
>> > +
>> > +	sgx_free_va_slot(encl_page->va_page, va_offset);
>> > +	list_move(&encl_page->va_page->list, &encl->va_pages);
>> > +	encl_page->desc &= ~SGX_ENCL_PAGE_VA_OFFSET_MASK;
>> > +	encl_page->epc_page = epc_page;
>> > +
>> > +	return epc_page;
>> > +}
>> > +
>> >  static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl  
>> *encl,
>> >  						unsigned long addr)
>> >  {
>> > +	struct sgx_epc_page *epc_page;
>> >  	struct sgx_encl_page *entry;
>> >  	unsigned int flags;
>> > @@ -33,10 +112,27 @@ static struct sgx_encl_page
>> > *sgx_encl_load_page(struct sgx_encl *encl,
>> >  		return ERR_PTR(-EFAULT);
>> > 	/* Page is already resident in the EPC. */
>> > -	if (entry->epc_page)
>> > +	if (entry->epc_page) {
>> > +		if (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)
>> > +			return ERR_PTR(-EBUSY);
>> > +
>> >  		return entry;
>> > +	}
>> > +
>> > +	if (!(encl->secs.epc_page)) {
>> > +		epc_page = sgx_encl_eldu(&encl->secs, NULL);
>> > +		if (IS_ERR(epc_page))
>> > +			return ERR_CAST(epc_page);
>> > +	}
>> > -	return ERR_PTR(-EFAULT);
>> > +	epc_page = sgx_encl_eldu(entry, encl->secs.epc_page);
>> > +	if (IS_ERR(epc_page))
>> > +		return ERR_CAST(epc_page);
>> > +
>> > +	encl->secs_child_cnt++;
>> > +	sgx_mark_page_reclaimable(entry->epc_page);
>> > +
>> > +	return entry;
>> >  }
>> > static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
>> > @@ -132,6 +228,9 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct
>> > mm_struct *mm)
>> > 	spin_lock(&encl->mm_lock);
>> >  	list_add_rcu(&encl_mm->list, &encl->mm_list);
>> > +	/* Pairs with smp_rmb() in sgx_reclaimer_block(). */
>> > +	smp_wmb();
>> > +	encl->mm_list_version++;
>> >  	spin_unlock(&encl->mm_lock);
>> > 	return 0;
>> > @@ -179,6 +278,8 @@ static unsigned int sgx_vma_fault(struct vm_fault
>> > *vmf)
>> >  		goto out;
>> >  	}
>> > +	sgx_encl_test_and_clear_young(vma->vm_mm, entry);
>> > +
>> >  out:
>> >  	mutex_unlock(&encl->lock);
>> >  	return ret;
>> > @@ -280,6 +381,7 @@ int sgx_encl_find(struct mm_struct *mm, unsigned
>> > long addr,
>> >   */
>> >  void sgx_encl_destroy(struct sgx_encl *encl)
>> >  {
>> > +	struct sgx_va_page *va_page;
>> >  	struct sgx_encl_page *entry;
>> >  	unsigned long index;
>> > @@ -287,6 +389,13 @@ void sgx_encl_destroy(struct sgx_encl *encl)
>> > 	xa_for_each(&encl->page_array, index, entry) {
>> >  		if (entry->epc_page) {
>> > +			/*
>> > +			 * The page and its radix tree entry cannot be freed
>> > +			 * if the page is being held by the reclaimer.
>> > +			 */
>> > +			if (sgx_unmark_page_reclaimable(entry->epc_page))
>> > +				continue;
>> > +
>> >  			sgx_free_epc_page(entry->epc_page);
>> >  			encl->secs_child_cnt--;
>> >  			entry->epc_page = NULL;
>> > @@ -301,6 +410,19 @@ void sgx_encl_destroy(struct sgx_encl *encl)
>> >  		sgx_free_epc_page(encl->secs.epc_page);
>> >  		encl->secs.epc_page = NULL;
>> >  	}
>> > +
>> > +	/*
>> > +	 * The reclaimer is responsible for checking SGX_ENCL_DEAD before  
>> doing
>> > +	 * EWB, thus it's safe to free VA pages even if the reclaimer holds  
>> a
>> > +	 * reference to the enclave.
>> > +	 */
>> > +	while (!list_empty(&encl->va_pages)) {
>> > +		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
>> > +					   list);
>> > +		list_del(&va_page->list);
>> > +		sgx_free_epc_page(va_page->epc_page);
>> > +		kfree(va_page);
>> > +	}
>> >  }
>> > /**
>> > @@ -329,3 +451,221 @@ void sgx_encl_release(struct kref *ref)
>> > 	kfree(encl);
>> >  }
>> > +
>> > +static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
>> > +					      pgoff_t index)
>> > +{
>> > +	struct inode *inode = encl->backing->f_path.dentry->d_inode;
>> > +	struct address_space *mapping = inode->i_mapping;
>> > +	gfp_t gfpmask = mapping_gfp_mask(mapping);
>> > +
>> > +	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
>> > +}
>> > +
>> > +/**
>> > + * sgx_encl_get_backing() - Pin the backing storage
>> > + * @encl:	an enclave pointer
>> > + * @page_index:	enclave page index
>> > + * @backing:	data for accessing backing storage for the page
>> > + *
>> > + * Pin the backing storage pages for storing the encrypted contents  
>> and
>> > Paging
>> > + * Crypto MetaData (PCMD) of an enclave page.
>> > + *
>> > + * Return:
>> > + *   0 on success,
>> > + *   -errno otherwise.
>> > + */
>> > +int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long
>> > page_index,
>> > +			 struct sgx_backing *backing)
>> > +{
>> > +	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
>> > +	struct page *contents;
>> > +	struct page *pcmd;
>> > +
>> > +	contents = sgx_encl_get_backing_page(encl, page_index);
>> > +	if (IS_ERR(contents))
>> > +		return PTR_ERR(contents);
>> > +
>> > +	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
>> > +	if (IS_ERR(pcmd)) {
>> > +		put_page(contents);
>> > +		return PTR_ERR(pcmd);
>> > +	}
>> > +
>> > +	backing->page_index = page_index;
>> > +	backing->contents = contents;
>> > +	backing->pcmd = pcmd;
>> > +	backing->pcmd_offset =
>> > +		(page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
>> > +		sizeof(struct sgx_pcmd);
>> > +
>> > +	return 0;
>> > +}
>> > +
>> > +/**
>> > + * sgx_encl_put_backing() - Unpin the backing storage
>> > + * @backing:	data for accessing backing storage for the page
>> > + * @do_write:	mark pages dirty
>> > + */
>> > +void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write)
>> > +{
>> > +	if (do_write) {
>> > +		set_page_dirty(backing->pcmd);
>> > +		set_page_dirty(backing->contents);
>> > +	}
>> > +
>> > +	put_page(backing->pcmd);
>> > +	put_page(backing->contents);
>> > +}
>> > +
>> > +static int sgx_encl_test_and_clear_young_cb(pte_t *ptep, unsigned  
>> long
>> > addr,
>> > +					    void *data)
>> > +{
>> > +	pte_t pte;
>> > +	int ret;
>> > +
>> > +	ret = pte_young(*ptep);
>> > +	if (ret) {
>> > +		pte = pte_mkold(*ptep);
>> > +		set_pte_at((struct mm_struct *)data, addr, ptep, pte);
>> > +	}
>> > +
>> > +	return ret;
>> > +}
>> > +
>> > +/**
>> > + * sgx_encl_test_and_clear_young() - Test and reset the accessed bit
>> > + * @mm:		mm_struct that is checked
>> > + * @page:	enclave page to be tested for recent access
>> > + *
>> > + * Checks the Access (A) bit from the PTE corresponding to the  
>> enclave
>> > page and
>> > + * clears it.
>> > + *
>> > + * Return: 1 if the page has been recently accessed and 0 if not.
>> > + */
>> > +int sgx_encl_test_and_clear_young(struct mm_struct *mm,
>> > +				  struct sgx_encl_page *page)
>> > +{
>> > +	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
>> > +	struct sgx_encl *encl = page->encl;
>> > +	struct vm_area_struct *vma;
>> > +	int ret;
>> > +
>> > +	ret = sgx_encl_find(mm, addr, &vma);
>> > +	if (ret)
>> > +		return 0;
>> > +
>> > +	if (encl != vma->vm_private_data)
>> > +		return 0;
>> > +
>> > +	ret = apply_to_page_range(vma->vm_mm, addr, PAGE_SIZE,
>> > +				  sgx_encl_test_and_clear_young_cb, vma->vm_mm);
>> > +	if (ret < 0)
>> > +		return 0;
>> > +
>> > +	return ret;
>> > +}
>> > +
>> > +/**
>> > + * sgx_encl_reserve_page() - Reserve an enclave page
>> > + * @encl:	an enclave pointer
>> > + * @addr:	a page address
>> > + *
>> > + * Load an enclave page and lock the enclave so that the page can be
>> > used by
>> > + * EDBG* and EMOD*.
>> > + *
>> > + * Return:
>> > + *   an enclave page on success
>> > + *   -EFAULT	if the load fails
>> > + */
>> > +struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
>> > +					    unsigned long addr)
>> > +{
>> > +	struct sgx_encl_page *entry;
>> > +
>> > +	for ( ; ; ) {
>> > +		mutex_lock(&encl->lock);
>> > +
>> > +		entry = sgx_encl_load_page(encl, addr);
>> > +		if (PTR_ERR(entry) != -EBUSY)
>> > +			break;
>> > +
>> > +		mutex_unlock(&encl->lock);
>> > +	}
>> > +
>> > +	if (IS_ERR(entry))
>> > +		mutex_unlock(&encl->lock);
>> > +
>> > +	return entry;
>> > +}
>> > +
>> > +/**
>> > + * sgx_alloc_va_page() - Allocate a Version Array (VA) page
>> > + *
>> > + * Allocate a free EPC page and convert it to a Version Array (VA)  
>> page.
>> > + *
>> > + * Return:
>> > + *   a VA page,
>> > + *   -errno otherwise
>> > + */
>> > +struct sgx_epc_page *sgx_alloc_va_page(void)
>> > +{
>> > +	struct sgx_epc_page *epc_page;
>> > +	int ret;
>> > +
>> > +	epc_page = sgx_alloc_epc_page(NULL, true);
>> > +	if (IS_ERR(epc_page))
>> > +		return ERR_CAST(epc_page);
>> > +
>> > +	ret = __epa(sgx_get_epc_addr(epc_page));
>> > +	if (ret) {
>> > +		WARN_ONCE(1, "EPA returned %d (0x%x)", ret, ret);
>> > +		sgx_free_epc_page(epc_page);
>> > +		return ERR_PTR(-EFAULT);
>> > +	}
>> > +
>> > +	return epc_page;
>> > +}
>> > +
>> > +/**
>> > + * sgx_alloc_va_slot - allocate a VA slot
>> > + * @va_page:	a &struct sgx_va_page instance
>> > + *
>> > + * Allocates a slot from a &struct sgx_va_page instance.
>> > + *
>> > + * Return: offset of the slot inside the VA page
>> > + */
>> > +unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page)
>> > +{
>> > +	int slot = find_first_zero_bit(va_page->slots, SGX_VA_SLOT_COUNT);
>> > +
>> > +	if (slot < SGX_VA_SLOT_COUNT)
>> > +		set_bit(slot, va_page->slots);
>> > +
>> > +	return slot << 3;
>> > +}
>> > +
>> > +/**
>> > + * sgx_free_va_slot - free a VA slot
>> > + * @va_page:	a &struct sgx_va_page instance
>> > + * @offset:	offset of the slot inside the VA page
>> > + *
>> > + * Frees a slot from a &struct sgx_va_page instance.
>> > + */
>> > +void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int  
>> offset)
>> > +{
>> > +	clear_bit(offset >> 3, va_page->slots);
>> > +}
>> > +
>> > +/**
>> > + * sgx_va_page_full - is the VA page full?
>> > + * @va_page:	a &struct sgx_va_page instance
>> > + *
>> > + * Return: true if all slots have been taken
>> > + */
>> > +bool sgx_va_page_full(struct sgx_va_page *va_page)
>> > +{
>> > +	int slot = find_first_zero_bit(va_page->slots, SGX_VA_SLOT_COUNT);
>> > +
>> > +	return slot == SGX_VA_SLOT_COUNT;
>> > +}
>> > diff --git a/arch/x86/kernel/cpu/sgx/encl.h
>> > b/arch/x86/kernel/cpu/sgx/encl.h
>> > index 0448d22d3010..e8eb9e9a834e 100644
>> > --- a/arch/x86/kernel/cpu/sgx/encl.h
>> > +++ b/arch/x86/kernel/cpu/sgx/encl.h
>> > @@ -19,6 +19,10 @@
>> > /**
>> >   * enum sgx_encl_page_desc - defines bits for an enclave page's
>> > descriptor
>> > + * %SGX_ENCL_PAGE_BEING_RECLAIMED:	The page is in the process of  
>> being
>> > + *					reclaimed.
>> > + * %SGX_ENCL_PAGE_VA_OFFSET_MASK:	Holds the offset in the Version  
>> Array
>> > + *					(VA) page for a swapped page.
>> >   * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
>> >   *
>> >   * The page address for SECS is zero and is used by the subsystem to
>> > recognize
>> > @@ -26,16 +30,23 @@
>> >   */
>> >  enum sgx_encl_page_desc {
>> >  	/* Bits 11:3 are available when the page is not swapped. */
>> > +	SGX_ENCL_PAGE_BEING_RECLAIMED		= BIT(3),
>> > +	SGX_ENCL_PAGE_VA_OFFSET_MASK	= GENMASK_ULL(11, 3),
>> >  	SGX_ENCL_PAGE_ADDR_MASK		= PAGE_MASK,
>> >  };
>> > #define SGX_ENCL_PAGE_ADDR(page) \
>> >  	((page)->desc & SGX_ENCL_PAGE_ADDR_MASK)
>> > +#define SGX_ENCL_PAGE_VA_OFFSET(page) \
>> > +	((page)->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK)
>> > +#define SGX_ENCL_PAGE_INDEX(page) \
>> > +	PFN_DOWN((page)->desc - (page)->encl->base)
>> > struct sgx_encl_page {
>> >  	unsigned long desc;
>> >  	unsigned long vm_max_prot_bits;
>> >  	struct sgx_epc_page *epc_page;
>> > +	struct sgx_va_page *va_page;
>> >  	struct sgx_encl *encl;
>> >  };
>> > @@ -61,6 +72,7 @@ struct sgx_encl {
>> >  	struct mutex lock;
>> >  	struct list_head mm_list;
>> >  	spinlock_t mm_lock;
>> > +	unsigned long mm_list_version;
>> >  	struct file *backing;
>> >  	struct kref refcount;
>> >  	struct srcu_struct srcu;
>> > @@ -68,12 +80,21 @@ struct sgx_encl {
>> >  	unsigned long size;
>> >  	unsigned long ssaframesize;
>> >  	struct xarray page_array;
>> > +	struct list_head va_pages;
>> >  	struct sgx_encl_page secs;
>> >  	cpumask_t cpumask;
>> >  	unsigned long attributes;
>> >  	unsigned long attributes_mask;
>> >  };
>> > +#define SGX_VA_SLOT_COUNT 512
>> > +
>> > +struct sgx_va_page {
>> > +	struct sgx_epc_page *epc_page;
>> > +	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
>> > +	struct list_head list;
>> > +};
>> > +
>> >  extern const struct vm_operations_struct sgx_vm_ops;
>> > int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
>> > @@ -84,4 +105,24 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct
>> > mm_struct *mm);
>> >  int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
>> >  		     unsigned long end, unsigned long vm_flags);
>> > +struct sgx_backing {
>> > +	pgoff_t page_index;
>> > +	struct page *contents;
>> > +	struct page *pcmd;
>> > +	unsigned long pcmd_offset;
>> > +};
>> > +
>> > +int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long
>> > page_index,
>> > +			 struct sgx_backing *backing);
>> > +void sgx_encl_put_backing(struct sgx_backing *backing, bool  
>> do_write);
>> > +int sgx_encl_test_and_clear_young(struct mm_struct *mm,
>> > +				  struct sgx_encl_page *page);
>> > +struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
>> > +					    unsigned long addr);
>> > +
>> > +struct sgx_epc_page *sgx_alloc_va_page(void);
>> > +unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
>> > +void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int  
>> offset);
>> > +bool sgx_va_page_full(struct sgx_va_page *va_page);
>> > +
>> >  #endif /* _X86_ENCL_H */
>> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c
>> > b/arch/x86/kernel/cpu/sgx/ioctl.c
>> > index 3c04798e83e5..613f6c03598e 100644
>> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
>> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
>> > @@ -16,6 +16,43 @@
>> >  #include "encl.h"
>> >  #include "encls.h"
>> > +static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
>> > +{
>> > +	struct sgx_va_page *va_page = NULL;
>> > +	void *err;
>> > +
>> > +	BUILD_BUG_ON(SGX_VA_SLOT_COUNT !=
>> > +		(SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
>> > +
>> > +	if (!(encl->page_cnt % SGX_VA_SLOT_COUNT)) {
>> > +		va_page = kzalloc(sizeof(*va_page), GFP_KERNEL);
>> > +		if (!va_page)
>> > +			return ERR_PTR(-ENOMEM);
>> > +
>> > +		va_page->epc_page = sgx_alloc_va_page();
>> > +		if (IS_ERR(va_page->epc_page)) {
>> > +			err = ERR_CAST(va_page->epc_page);
>> > +			kfree(va_page);
>> > +			return err;
>> > +		}
>> > +
>> > +		WARN_ON_ONCE(encl->page_cnt % SGX_VA_SLOT_COUNT);
>> > +	}
>> > +	encl->page_cnt++;
>> > +	return va_page;
>> > +}
>> > +
>> > +static void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page
>> > *va_page)
>> > +{
>> > +	encl->page_cnt--;
>> > +
>> > +	if (va_page) {
>> > +		sgx_free_epc_page(va_page->epc_page);
>> > +		list_del(&va_page->list);
>> > +		kfree(va_page);
>> > +	}
>> > +}
>> > +
>> >  static u32 sgx_calc_ssa_frame_size(u32 miscselect, u64 xfrm)
>> >  {
>> >  	u32 size_max = PAGE_SIZE;
>> > @@ -80,15 +117,24 @@ static int sgx_validate_secs(const struct  
>> sgx_secs
>> > *secs)
>> >  static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs  
>> *secs)
>> >  {
>> >  	struct sgx_epc_page *secs_epc;
>> > +	struct sgx_va_page *va_page;
>> >  	struct sgx_pageinfo pginfo;
>> >  	struct sgx_secinfo secinfo;
>> >  	unsigned long encl_size;
>> >  	struct file *backing;
>> >  	long ret;
>> > +	va_page = sgx_encl_grow(encl);
>> > +	if (IS_ERR(va_page))
>> > +		return PTR_ERR(va_page);
>> > +	else if (va_page)
>> > +		list_add(&va_page->list, &encl->va_pages);
>> > +	/* else the tail page of the VA page list had free slots. */
>> > +
>> >  	if (sgx_validate_secs(secs)) {
>> >  		pr_debug("invalid SECS\n");
>> > -		return -EINVAL;
>> > +		ret = -EINVAL;
>> > +		goto err_out_shrink;
>> >  	}
>> > 	/* The extra page goes to SECS. */
>> > @@ -96,12 +142,14 @@ static int sgx_encl_create(struct sgx_encl *encl,
>> > struct sgx_secs *secs)
>> > 	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >>  
>> 5),
>> >  				   VM_NORESERVE);
>> > -	if (IS_ERR(backing))
>> > -		return PTR_ERR(backing);
>> > +	if (IS_ERR(backing)) {
>> > +		ret = PTR_ERR(backing);
>> > +		goto err_out_shrink;
>> > +	}
>> > 	encl->backing = backing;
>> > -	secs_epc = __sgx_alloc_epc_page();
>> > +	secs_epc = sgx_alloc_epc_page(&encl->secs, true);
>> >  	if (IS_ERR(secs_epc)) {
>> >  		ret = PTR_ERR(secs_epc);
>> >  		goto err_out_backing;
>> > @@ -149,6 +197,9 @@ static int sgx_encl_create(struct sgx_encl *encl,
>> > struct sgx_secs *secs)
>> >  	fput(encl->backing);
>> >  	encl->backing = NULL;
>> > +err_out_shrink:
>> > +	sgx_encl_shrink(encl, va_page);
>> > +
>> >  	return ret;
>> >  }
>> > @@ -321,21 +372,35 @@ static int sgx_encl_add_page(struct sgx_encl
>> > *encl, unsigned long src,
>> >  {
>> >  	struct sgx_encl_page *encl_page;
>> >  	struct sgx_epc_page *epc_page;
>> > +	struct sgx_va_page *va_page;
>> >  	int ret;
>> > 	encl_page = sgx_encl_page_alloc(encl, offset, secinfo->flags);
>> >  	if (IS_ERR(encl_page))
>> >  		return PTR_ERR(encl_page);
>> > -	epc_page = __sgx_alloc_epc_page();
>> > +	epc_page = sgx_alloc_epc_page(encl_page, true);
>> >  	if (IS_ERR(epc_page)) {
>> >  		kfree(encl_page);
>> >  		return PTR_ERR(epc_page);
>> >  	}
>> > +	va_page = sgx_encl_grow(encl);
>> > +	if (IS_ERR(va_page)) {
>> > +		ret = PTR_ERR(va_page);
>> > +		goto err_out_free;
>> > +	}
>> > +
>> >  	mmap_read_lock(current->mm);
>> >  	mutex_lock(&encl->lock);
>> > +	/*
>> > +	 * Adding to encl->va_pages must be done under encl->lock.  Ditto  
>> for
>> > +	 * deleting (via sgx_encl_shrink()) in the error path.
>> > +	 */
>> > +	if (va_page)
>> > +		list_add(&va_page->list, &encl->va_pages);
>> > +
>> >  	/*
>> >  	 * Insert prior to EADD in case of OOM.  EADD modifies MRENCLAVE,  
>> i.e.
>> >  	 * can't be gracefully unwound, while failure on EADD/EXTEND is  
>> limited
>> > @@ -366,6 +431,7 @@ static int sgx_encl_add_page(struct sgx_encl  
>> *encl,
>> > unsigned long src,
>> >  			goto err_out;
>> >  	}
>> > +	sgx_mark_page_reclaimable(encl_page->epc_page);
>> >  	mutex_unlock(&encl->lock);
>> >  	mmap_read_unlock(current->mm);
>> >  	return ret;
>> > @@ -374,9 +440,11 @@ static int sgx_encl_add_page(struct sgx_encl  
>> *encl,
>> > unsigned long src,
>> >  	xa_erase(&encl->page_array, PFN_DOWN(encl_page->desc));
>> > err_out_unlock:
>> > +	sgx_encl_shrink(encl, va_page);
>> >  	mutex_unlock(&encl->lock);
>> >  	mmap_read_unlock(current->mm);
>> > +err_out_free:
>> >  	sgx_free_epc_page(epc_page);
>> >  	kfree(encl_page);
>> > diff --git a/arch/x86/kernel/cpu/sgx/main.c
>> > b/arch/x86/kernel/cpu/sgx/main.c
>> > index 4137254fb29e..3f9130501370 100644
>> > --- a/arch/x86/kernel/cpu/sgx/main.c
>> > +++ b/arch/x86/kernel/cpu/sgx/main.c
>> > @@ -16,6 +16,395 @@
>> >  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
>> >  static int sgx_nr_epc_sections;
>> >  static struct task_struct *ksgxswapd_tsk;
>> > +static DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
>> > +static LIST_HEAD(sgx_active_page_list);
>> > +static DEFINE_SPINLOCK(sgx_active_page_list_lock);
>> > +
>> > +/**
>> > + * sgx_mark_page_reclaimable() - Mark a page as reclaimable
>> > + * @page:	EPC page
>> > + *
>> > + * Mark a page as reclaimable and add it to the active page list.  
>> Pages
>> > + * are automatically removed from the active list when freed.
>> > + */
>> > +void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
>> > +{
>> > +	spin_lock(&sgx_active_page_list_lock);
>> > +	page->desc |= SGX_EPC_PAGE_RECLAIMABLE;
>> > +	list_add_tail(&page->list, &sgx_active_page_list);
>> > +	spin_unlock(&sgx_active_page_list_lock);
>> > +}
>> > +
>> > +/**
>> > + * sgx_unmark_page_reclaimable() - Remove a page from the reclaim  
>> list
>> > + * @page:	EPC page
>> > + *
>> > + * Clear the reclaimable flag and remove the page from the active  
>> page
>> > list.
>> > + *
>> > + * Return:
>> > + *   0 on success,
>> > + *   -EBUSY if the page is in the process of being reclaimed
>> > + */
>> > +int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
>> > +{
>> > +	/*
>> > +	 * Remove the page from the active list if necessary.  If the page
>> > +	 * is actively being reclaimed, i.e. RECLAIMABLE is set but the
>> > +	 * page isn't on the active list, return -EBUSY as we can't free
>> > +	 * the page at this time since it is "owned" by the reclaimer.
>> > +	 */
>> > +	spin_lock(&sgx_active_page_list_lock);
>> > +	if (page->desc & SGX_EPC_PAGE_RECLAIMABLE) {
>> > +		if (list_empty(&page->list)) {
>> > +			spin_unlock(&sgx_active_page_list_lock);
>> > +			return -EBUSY;
>> > +		}
>> > +		list_del(&page->list);
>> > +		page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
>> > +	}
>> > +	spin_unlock(&sgx_active_page_list_lock);
>> > +
>> > +	return 0;
>> > +}
>> > +
>> > +static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
>> > +{
>> > +	struct sgx_encl_page *page = epc_page->owner;
>> > +	struct sgx_encl *encl = page->encl;
>> > +	struct sgx_encl_mm *encl_mm;
>> > +	bool ret = true;
>> > +	int idx;
>> > +
>> > +	idx = srcu_read_lock(&encl->srcu);
>> > +
>> > +	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
>> > +		if (!mmget_not_zero(encl_mm->mm))
>> > +			continue;
>> > +
>> > +		mmap_read_lock(encl_mm->mm);
>> > +		ret = !sgx_encl_test_and_clear_young(encl_mm->mm, page);
>> > +		mmap_read_unlock(encl_mm->mm);
>> > +
>> > +		mmput_async(encl_mm->mm);
>> > +
>> > +		if (!ret || (atomic_read(&encl->flags) & SGX_ENCL_DEAD))
>> > +			break;
>> > +	}
>> > +
>> > +	srcu_read_unlock(&encl->srcu, idx);
>> > +
>> > +	if (!ret && !(atomic_read(&encl->flags) & SGX_ENCL_DEAD))
>> > +		return false;
>> > +
>> > +	return true;
>> > +}
>> > +
>> > +static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
>> > +{
>> > +	struct sgx_encl_page *page = epc_page->owner;
>> > +	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
>> > +	struct sgx_encl *encl = page->encl;
>> > +	unsigned long mm_list_version;
>> > +	struct sgx_encl_mm *encl_mm;
>> > +	struct vm_area_struct *vma;
>> > +	int idx, ret;
>> > +
>> > +	do {
>> > +		mm_list_version = encl->mm_list_version;
>> > +
>> > +		/* Pairs with smp_rmb() in sgx_encl_mm_add(). */
>> > +		smp_rmb();
>> > +
>> > +		idx = srcu_read_lock(&encl->srcu);
>> > +
>> > +		list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
>> > +			if (!mmget_not_zero(encl_mm->mm))
>> > +				continue;
>> > +
>> > +			mmap_read_lock(encl_mm->mm);
>> > +
>> > +			ret = sgx_encl_find(encl_mm->mm, addr, &vma);
>> > +			if (!ret && encl == vma->vm_private_data)
>> > +				zap_vma_ptes(vma, addr, PAGE_SIZE);
>> > +
>> > +			mmap_read_unlock(encl_mm->mm);
>> > +
>> > +			mmput_async(encl_mm->mm);
>> > +		}
>> > +
>> > +		srcu_read_unlock(&encl->srcu, idx);
>> > +	} while (unlikely(encl->mm_list_version != mm_list_version));
>> > +
>> > +	mutex_lock(&encl->lock);
>> > +
>> > +	if (!(atomic_read(&encl->flags) & SGX_ENCL_DEAD)) {
>> > +		ret = __eblock(sgx_get_epc_addr(epc_page));
>> > +		if (encls_failed(ret))
>> > +			ENCLS_WARN(ret, "EBLOCK");
>> > +	}
>> > +
>> > +	mutex_unlock(&encl->lock);
>> > +}
>> > +
>> > +static int __sgx_encl_ewb(struct sgx_epc_page *epc_page, void  
>> *va_slot,
>> > +			  struct sgx_backing *backing)
>> > +{
>> > +	struct sgx_pageinfo pginfo;
>> > +	int ret;
>> > +
>> > +	pginfo.addr = 0;
>> > +	pginfo.secs = 0;
>> > +
>> > +	pginfo.contents = (unsigned long)kmap_atomic(backing->contents);
>> > +	pginfo.metadata = (unsigned long)kmap_atomic(backing->pcmd) +
>> > +			  backing->pcmd_offset;
>> > +
>> > +	ret = __ewb(&pginfo, sgx_get_epc_addr(epc_page), va_slot);
>> > +
>> > +	kunmap_atomic((void *)(unsigned long)(pginfo.metadata -
>> > +					      backing->pcmd_offset));
>> > +	kunmap_atomic((void *)(unsigned long)pginfo.contents);
>> > +
>> > +	return ret;
>> > +}
>> > +
>> > +static void sgx_ipi_cb(void *info)
>> > +{
>> > +}
>> > +
>> > +static const cpumask_t *sgx_encl_ewb_cpumask(struct sgx_encl *encl)
>> > +{
>> > +	cpumask_t *cpumask = &encl->cpumask;
>> > +	struct sgx_encl_mm *encl_mm;
>> > +	int idx;
>> > +
>> > +	/*
>> > +	 * Can race with sgx_encl_mm_add(), but ETRACK has already been
>> > +	 * executed, which means that the CPUs running in the new mm will  
>> enter
>> > +	 * into the enclave with a fresh epoch.
>> > +	 */
>> > +	cpumask_clear(cpumask);
>> > +
>> > +	idx = srcu_read_lock(&encl->srcu);
>> > +
>> > +	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
>> > +		if (!mmget_not_zero(encl_mm->mm))
>> > +			continue;
>> > +
>> > +		cpumask_or(cpumask, cpumask, mm_cpumask(encl_mm->mm));
>> > +
>> > +		mmput_async(encl_mm->mm);
>> > +	}
>> > +
>> > +	srcu_read_unlock(&encl->srcu, idx);
>> > +
>> > +	return cpumask;
>> > +}
>> > +
>> > +/*
>> > + * Swap page to the regular memory transformed to the blocked state  
>> by
>> > using
>> > + * EBLOCK, which means that it can no loger be referenced (no new TLB
>> > entries).
>> > + *
>> > + * The first trial just tries to write the page assuming that some
>> > other thread
>> > + * has reset the count for threads inside the enlave by using ETRACK,
>> > and
>> > + * previous thread count has been zeroed out. The second trial calls
>> > ETRACK
>> > + * before EWB. If that fails we kick all the HW threads out, and then
>> > do EWB,
>> > + * which should be guaranteed the succeed.
>> > + */
>> > +static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
>> > +			 struct sgx_backing *backing)
>> > +{
>> > +	struct sgx_encl_page *encl_page = epc_page->owner;
>> > +	struct sgx_encl *encl = encl_page->encl;
>> > +	struct sgx_va_page *va_page;
>> > +	unsigned int va_offset;
>> > +	void *va_slot;
>> > +	int ret;
>> > +
>> > +	encl_page->desc &= ~SGX_ENCL_PAGE_BEING_RECLAIMED;
>> > +
>> > +	va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
>> > +				   list);
>> > +	va_offset = sgx_alloc_va_slot(va_page);
>> > +	va_slot = sgx_get_epc_addr(va_page->epc_page) + va_offset;
>> > +	if (sgx_va_page_full(va_page))
>> > +		list_move_tail(&va_page->list, &encl->va_pages);
>> > +
>> > +	ret = __sgx_encl_ewb(epc_page, va_slot, backing);
>> > +	if (ret == SGX_NOT_TRACKED) {
>> > +		ret = __etrack(sgx_get_epc_addr(encl->secs.epc_page));
>> > +		if (ret) {
>> > +			if (encls_failed(ret))
>> > +				ENCLS_WARN(ret, "ETRACK");
>> > +		}
>> > +
>> > +		ret = __sgx_encl_ewb(epc_page, va_slot, backing);
>> > +		if (ret == SGX_NOT_TRACKED) {
>> > +			/*
>> > +			 * Slow path, send IPIs to kick cpus out of the
>> > +			 * enclave.  Note, it's imperative that the cpu
>> > +			 * mask is generated *after* ETRACK, else we'll
>> > +			 * miss cpus that entered the enclave between
>> > +			 * generating the mask and incrementing epoch.
>> > +			 */
>> > +			on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
>> > +					 sgx_ipi_cb, NULL, 1);
>> > +			ret = __sgx_encl_ewb(epc_page, va_slot, backing);
>> > +		}
>> > +	}
>> > +
>> > +	if (ret) {
>> > +		if (encls_failed(ret))
>> > +			ENCLS_WARN(ret, "EWB");
>> > +
>> > +		sgx_free_va_slot(va_page, va_offset);
>> > +	} else {
>> > +		encl_page->desc |= va_offset;
>> > +		encl_page->va_page = va_page;
>> > +	}
>> > +}
>> > +
>> > +static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>> > +				struct sgx_backing *backing)
>> > +{
>> > +	struct sgx_encl_page *encl_page = epc_page->owner;
>> > +	struct sgx_encl *encl = encl_page->encl;
>> > +	struct sgx_backing secs_backing;
>> > +	int ret;
>> > +
>> > +	mutex_lock(&encl->lock);
>> > +
>> > +	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD) {
>> > +		ret = __eremove(sgx_get_epc_addr(epc_page));
>> > +		ENCLS_WARN(ret, "EREMOVE");
>> > +	} else {
>> > +		sgx_encl_ewb(epc_page, backing);
>> > +	}
>> > +
>> > +	encl_page->epc_page = NULL;
>> > +	encl->secs_child_cnt--;
>> > +
>> > +	if (!encl->secs_child_cnt) {
>> > +		if (atomic_read(&encl->flags) & SGX_ENCL_DEAD) {
>> > +			sgx_free_epc_page(encl->secs.epc_page);
>> > +			encl->secs.epc_page = NULL;
>> > +		} else if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) {
>> > +			ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
>> > +						   &secs_backing);
>> > +			if (ret)
>> > +				goto out;
>> > +
>> > +			sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
>> > +
>> > +			sgx_free_epc_page(encl->secs.epc_page);
>> > +			encl->secs.epc_page = NULL;
>> > +
>> > +			sgx_encl_put_backing(&secs_backing, true);
>> > +		}
>> > +	}
>> > +
>> > +out:
>> > +	mutex_unlock(&encl->lock);
>> > +}
>> > +
>> > +/*
>> > + * Take a fixed number of pages from the head of the active page pool
>> > and
>> > + * reclaim them to the enclave's private shmem files. Skip the pages,
>> > which have
>> > + * been accessed since the last scan. Move those pages to the tail of
>> > active
>> > + * page pool so that the pages get scanned in LRU like fashion.
>> > + *
>> > + * Batch process a chunk of pages (at the moment 16) in order to
>> > degrade amount
>> > + * of IPI's and ETRACK's potentially required. sgx_encl_ewb() does
>> > degrade a bit
>> > + * among the HW threads with three stage EWB pipeline (EWB, ETRACK +
>> > EWB and IPI
>> > + * + EWB) but not sufficiently. Reclaiming one page at a time would
>> > also be
>> > + * problematic as it would increase the lock contention too much,  
>> which
>> > would
>> > + * halt forward progress.
>> > + */
>> > +static void sgx_reclaim_pages(void)
>> > +{
>> > +	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
>> > +	struct sgx_backing backing[SGX_NR_TO_SCAN];
>> > +	struct sgx_epc_section *section;
>> > +	struct sgx_encl_page *encl_page;
>> > +	struct sgx_epc_page *epc_page;
>> > +	int cnt = 0;
>> > +	int ret;
>> > +	int i;
>> > +
>> > +	spin_lock(&sgx_active_page_list_lock);
>> > +	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
>> > +		if (list_empty(&sgx_active_page_list))
>> > +			break;
>> > +
>> > +		epc_page = list_first_entry(&sgx_active_page_list,
>> > +					    struct sgx_epc_page, list);
>> > +		list_del_init(&epc_page->list);
>> > +		encl_page = epc_page->owner;
>> > +
>> > +		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0)
>> > +			chunk[cnt++] = epc_page;
>> > +		else
>> > +			/* The owner is freeing the page. No need to add the
>> > +			 * page back to the list of reclaimable pages.
>> > +			 */
>> > +			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
>> > +	}
>> > +	spin_unlock(&sgx_active_page_list_lock);
>> > +
>> > +	for (i = 0; i < cnt; i++) {
>> > +		epc_page = chunk[i];
>> > +		encl_page = epc_page->owner;
>> > +
>> > +		if (!sgx_reclaimer_age(epc_page))
>> > +			goto skip;
>> > +
>> > +		ret = sgx_encl_get_backing(encl_page->encl,
>> > +					   SGX_ENCL_PAGE_INDEX(encl_page),
>> > +					   &backing[i]);
>> > +		if (ret)
>> > +			goto skip;
>> > +
>> > +		mutex_lock(&encl_page->encl->lock);
>> > +		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
>> > +		mutex_unlock(&encl_page->encl->lock);
>> > +		continue;
>> > +
>> > +skip:
>> > +		spin_lock(&sgx_active_page_list_lock);
>> > +		list_add_tail(&epc_page->list, &sgx_active_page_list);
>> > +		spin_unlock(&sgx_active_page_list_lock);
>> > +
>> > +		kref_put(&encl_page->encl->refcount, sgx_encl_release);
>> > +
>> > +		chunk[i] = NULL;
>> > +	}
>> > +
>> > +	for (i = 0; i < cnt; i++) {
>> > +		epc_page = chunk[i];
>> > +		if (epc_page)
>> > +			sgx_reclaimer_block(epc_page);
>> > +	}
>> > +
>> > +	for (i = 0; i < cnt; i++) {
>> > +		epc_page = chunk[i];
>> > +		if (!epc_page)
>> > +			continue;
>> > +
>> > +		encl_page = epc_page->owner;
>> > +		sgx_reclaimer_write(epc_page, &backing[i]);
>> > +		sgx_encl_put_backing(&backing[i], true);
>> > +
>> > +		kref_put(&encl_page->encl->refcount, sgx_encl_release);
>> > +		epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
>> > +
>> > +		section = sgx_get_epc_section(epc_page);
>> > +		spin_lock(&section->lock);
>> > +		list_add_tail(&epc_page->list, &section->page_list);
>> > +		section->free_cnt++;
>> > +		spin_unlock(&section->lock);
>> > +	}
>> > +}
>> > +
>> > static void sgx_sanitize_section(struct sgx_epc_section *section)
>> >  {
>> > @@ -44,6 +433,23 @@ static void sgx_sanitize_section(struct
>> > sgx_epc_section *section)
>> >  	}
>> >  }
>> > +static unsigned long sgx_nr_free_pages(void)
>> > +{
>> > +	unsigned long cnt = 0;
>> > +	int i;
>> > +
>> > +	for (i = 0; i < sgx_nr_epc_sections; i++)
>> > +		cnt += sgx_epc_sections[i].free_cnt;
>> > +
>> > +	return cnt;
>> > +}
>> > +
>> > +static bool sgx_should_reclaim(unsigned long watermark)
>> > +{
>> > +	return sgx_nr_free_pages() < watermark &&
>> > +	       !list_empty(&sgx_active_page_list);
>> > +}
>> > +
>> >  static int ksgxswapd(void *p)
>> >  {
>> >  	int i;
>> > @@ -69,6 +475,20 @@ static int ksgxswapd(void *p)
>> >  			WARN(1, "EPC section %d has unsanitized pages.\n", i);
>> >  	}
>> > +	while (!kthread_should_stop()) {
>> > +		if (try_to_freeze())
>> > +			continue;
>> > +
>> > +		wait_event_freezable(ksgxswapd_waitq,
>> > +				     kthread_should_stop() ||
>> > +				     sgx_should_reclaim(SGX_NR_HIGH_PAGES));
>> > +
>> > +		if (sgx_should_reclaim(SGX_NR_HIGH_PAGES))
>> > +			sgx_reclaim_pages();
>> > +
>> > +		cond_resched();
>> > +	}
>> > +
>> >  	return 0;
>> >  }
>> > @@ -94,6 +514,7 @@ static struct sgx_epc_page
>> > *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
>> > 	page = list_first_entry(&section->page_list, struct sgx_epc_page,  
>> list);
>> >  	list_del_init(&page->list);
>> > +	section->free_cnt--;
>> > 	return page;
>> >  }
>> > @@ -127,6 +548,57 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
>> >  	return ERR_PTR(-ENOMEM);
>> >  }
>> > +/**
>> > + * sgx_alloc_epc_page() - Allocate an EPC page
>> > + * @owner:	the owner of the EPC page
>> > + * @reclaim:	reclaim pages if necessary
>> > + *
>> > + * Iterate through EPC sections and borrow a free EPC page to the
>> > caller. When a
>> > + * page is no longer needed it must be released with
>> > sgx_free_epc_page(). If
>> > + * @reclaim is set to true, directly reclaim pages when we are out of
>> > pages. No
>> > + * mm's can be locked when @reclaim is set to true.
>> > + *
>> > + * Finally, wake up ksgxswapd when the number of pages goes below the
>> > watermark
>> > + * before returning back to the caller.
>> > + *
>> > + * Return:
>> > + *   an EPC page,
>> > + *   -errno on error
>> > + */
>> > +struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
>> > +{
>> > +	struct sgx_epc_page *entry;
>> > +
>> > +	for ( ; ; ) {
>> > +		entry = __sgx_alloc_epc_page();
>> > +		if (!IS_ERR(entry)) {
>> > +			entry->owner = owner;
>> > +			break;
>> > +		}
>> > +
>> > +		if (list_empty(&sgx_active_page_list))
>> > +			return ERR_PTR(-ENOMEM);
>> > +
>> > +		if (!reclaim) {
>> > +			entry = ERR_PTR(-EBUSY);
>> > +			break;
>> > +		}
>> > +
>> > +		if (signal_pending(current)) {
>> > +			entry = ERR_PTR(-ERESTARTSYS);
>> > +			break;
>> > +		}
>> > +
>> > +		sgx_reclaim_pages();
>> > +		schedule();
>> > +	}
>> > +
>> > +	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
>> > +		wake_up(&ksgxswapd_waitq);
>> > +
>> > +	return entry;
>> > +}
>> > +
>> >  /**
>> >   * sgx_free_epc_page() - Free an EPC page
>> >   * @page:	an EPC page
>> > @@ -138,12 +610,20 @@ void sgx_free_epc_page(struct sgx_epc_page  
>> *page)
>> >  	struct sgx_epc_section *section = sgx_get_epc_section(page);
>> >  	int ret;
>> > +	/*
>> > +	 * Don't take sgx_active_page_list_lock when asserting the page  
>> isn't
>> > +	 * reclaimable, missing a WARN in the very rare case is preferable  
>> to
>> > +	 * unnecessarily taking a global lock in the common case.
>> > +	 */
>> > +	WARN_ON_ONCE(page->desc & SGX_EPC_PAGE_RECLAIMABLE);
>> > +
>> >  	ret = __eremove(sgx_get_epc_addr(page));
>> >  	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
>> >  		return;
>> > 	spin_lock(&section->lock);
>> >  	list_add_tail(&page->list, &section->page_list);
>> > +	section->free_cnt++;
>> >  	spin_unlock(&section->lock);
>> >  }
>> > @@ -194,6 +674,7 @@ static bool __init sgx_setup_epc_section(u64 addr,
>> > u64 size,
>> >  		list_add_tail(&page->list, &section->unsanitized_page_list);
>> >  	}
>> > +	section->free_cnt = nr_pages;
>> >  	return true;
>> > err_out:
>> > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h
>> > b/arch/x86/kernel/cpu/sgx/sgx.h
>> > index 8d126070db1e..ec4f7b338dbe 100644
>> > --- a/arch/x86/kernel/cpu/sgx/sgx.h
>> > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
>> > @@ -15,6 +15,7 @@
>> > struct sgx_epc_page {
>> >  	unsigned long desc;
>> > +	struct sgx_encl_page *owner;
>> >  	struct list_head list;
>> >  };
>> > @@ -27,6 +28,7 @@ struct sgx_epc_page {
>> >  struct sgx_epc_section {
>> >  	unsigned long pa;
>> >  	void *va;
>> > +	unsigned long free_cnt;
>> >  	struct list_head page_list;
>> >  	struct list_head unsanitized_page_list;
>> >  	spinlock_t lock;
>> > @@ -35,6 +37,10 @@ struct sgx_epc_section {
>> >  #define SGX_EPC_SECTION_MASK		GENMASK(7, 0)
>> >  #define SGX_MAX_EPC_SECTIONS		(SGX_EPC_SECTION_MASK + 1)
>> >  #define SGX_MAX_ADD_PAGES_LENGTH	0x100000
>> > +#define SGX_EPC_PAGE_RECLAIMABLE	BIT(8)
>> > +#define SGX_NR_TO_SCAN			16
>> > +#define SGX_NR_LOW_PAGES		32
>> > +#define SGX_NR_HIGH_PAGES		64
>> > extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
>> > @@ -50,7 +56,10 @@ static inline void *sgx_get_epc_addr(struct
>> > sgx_epc_page *page)
>> >  	return section->va + (page->desc & PAGE_MASK) - section->pa;
>> >  }
>> > +void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
>> > +int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
>> >  struct sgx_epc_page *__sgx_alloc_epc_page(void);
>> > +struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
>> >  void sgx_free_epc_page(struct sgx_epc_page *page);
>> > #endif /* _X86_SGX_H */
>>
>>
>> --
