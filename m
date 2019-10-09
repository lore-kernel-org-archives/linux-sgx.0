Return-Path: <SRS0=7vij=YC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0CEC47404
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 14:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BAE7206BB
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 14:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbfJIOfd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:35:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:54212 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbfJIOfc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Oct 2019 10:35:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 07:35:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,276,1566889200"; 
   d="scan'208";a="206889973"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.125])
  by fmsmga001.fm.intel.com with ESMTP; 09 Oct 2019 07:35:30 -0700
Date:   Wed, 9 Oct 2019 17:35:29 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, shay.katz-zamir@intel.com,
        serge.ayoun@intel.com
Subject: Re: x86/sgx: v23-rc1
Message-ID: <20191009143529.GA19213@linux.intel.com>
References: <20191009140723.GA18318@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009140723.GA18318@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 09, 2019 at 05:07:23PM +0300, Jarkko Sakkinen wrote:
> Baseline before adding Sean's updates. This contains only my updates. I
> spent this day mostly fixing diff's. Especially these two were somewhat
> unclean:
> 
> 1. x86/sgx: Add a page reclaimer
> 2. x86/sgx: Linux Enclave Driver
> 
> Now they pile up nicely (I think). So I decided to do this tag since now
> commit's in the sense of form and shape are legit. And also because
> things, well, work.
> 
> I'll continue from this by integrating Sean's changes. You can see below
> what has been already changed.
> 
> /Jarkko
> 
> tag v23-rc1
> Tagger: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Date:   Wed Oct 9 16:59:10 2019 +0300
> 
> x86/sgx: v23-rc1 patch set
> 
> * Return -EIO instead of -ECANCELED when ptrace() fails to read a TCS page.
> * In the reclaimer, pin page before ENCLS[EBLOCK] because pinning can fail
>   (because of OOM) even in legit behaviour and after EBLOCK the reclaiming
>   flow can be only reverted by killing the whole enclave.
> * Fixed SGX_ATTR_RESERVED_MASK. Bit 7 was marked as reserved while in fact
>   it should have been bit 6 (Table 37-3 in the SDM).
> * Return -EPERM from SGX_IOC_ENCLAVE_INIT when ENCLS[EINIT] returns an SGX
>   error code.
> -----BEGIN PGP SIGNATURE-----
> 
> iJYEABYIAD4WIQRE6pSOnaBC00OEHEIaerohdGur0gUCXZ3nxCAcamFya2tvLnNh
> a2tpbmVuQGxpbnV4LmludGVsLmNvbQAKCRAaerohdGur0mKVAQDcmIGs2f8y8hDY
> b7zaQdNbaAMgsEkQ3ohMA88fbm2UQwD+P7y5AcAxzdccbgh++7RDy6XR2Ow2pluW
> vCGUvRAhgwY=
> =LCI3
> -----END PGP SIGNATURE-----
> 
> /Jarkko

Getting this with rc1 (after running selftest). Leaving from office.
No time to check this today but here are anyway logs.

[   96.906523] ============================================
[   96.906600] WARNING: possible recursive locking detected
[   96.906679] 5.4.0-rc1-custom #66 Not tainted
[   96.906741] --------------------------------------------
[   96.906817] test_sgx/1297 is trying to acquire lock:
[   96.906889] ffff99032aebdb18 (&mm->mmap_sem#2){++++}, at: __do_page_fault+0x424/0x4f0
[   96.907009]
               but task is already holding lock:
[   96.907091] ffff99032aebdb18 (&mm->mmap_sem#2){++++}, at: sgx_ioc_enclave_add_page+0x1fc/0x620
[   96.907217]
               other info that might help us debug this:
[   96.907308]  Possible unsafe locking scenario:

[   96.907391]        CPU0
[   96.907428]        ----
[   96.907464]   lock(&mm->mmap_sem#2);
[   96.907516]   lock(&mm->mmap_sem#2);
[   96.907569]
                *** DEADLOCK ***

[   96.907650]  May be due to missing lock nesting notation

[   96.907745] 2 locks held by test_sgx/1297:
[   96.907804]  #0: ffff99032aebdb18 (&mm->mmap_sem#2){++++}, at: sgx_ioc_enclave_add_page+0x1fc/0x620
[   96.907935]  #1: ffff990322de0080 (&encl->lock){+.+.}, at: sgx_ioc_enclave_add_page+0x212/0x620
[   96.910109]
               stack backtrace:
[   96.914616] CPU: 0 PID: 1297 Comm: test_sgx Not tainted 5.4.0-rc1-custom #66
[   96.918182] Hardware name: Intel Corporation NUC7CJYH/NUC7JYB, BIOS JYGLKCPX.86A.0047.2018.1219.1246 12/19/2018
[   96.921795] Call Trace:
[   96.925209]  dump_stack+0x8e/0xd5
[   96.928462]  __lock_acquire+0xeab/0x1470
[   96.931648]  ? __do_fault+0x57/0x11d
[   96.934761]  lock_acquire+0xa3/0x180
[   96.937820]  ? __do_page_fault+0x424/0x4f0
[   96.940866]  down_read+0x30/0x150
[   96.943867]  ? __do_page_fault+0x424/0x4f0
[   96.946889]  __do_page_fault+0x424/0x4f0
[   96.949792]  do_page_fault+0x2c/0x1a0
[   96.952602]  page_fault+0x39/0x40
[   96.955400] RIP: 0010:sgx_ioc_enclave_add_page+0x3aa/0x620
[   96.958181] Code: 9d 10 ff ff ff 48 89 c8 48 81 e1 00 f0 ff ff 83 e0 0f 48 8d 14 40 48 8d 04 90 49 8d 04 c0 48 2b 08 48 03 48 08 b8 01 00 00 00 <0f> 01 cf 31 c0 0f 01 ca 85 c0 0f 85 0b 02 00 00 65 48 8b 04 25 c0
[   96.964133] RSP: 0018:ffffb46640df3c80 EFLAGS: 00050286
[   96.967141] RAX: 0000000000000001 RBX: ffffb46640df3cc0 RCX: ffffb4664ddfd000
[   96.970254] RDX: 0000000000000000 RSI: 00007f2d7a30f000 RDI: 0000000000000246
[   96.973440] RBP: ffffb46640df3db0 R08: ffffffffa8faf8a0 R09: 0000000000000000
[   96.976698] R10: 0000000000000000 R11: 0000000000000000 R12: ffff990322de0000
[   96.980048] R13: ffff99032ba198c0 R14: 0000000000000000 R15: ffff99033a10cfe0
[   96.983425]  ? avc_has_extended_perms+0x1f6/0x610
[   96.986830]  sgx_ioctl+0x87/0x470
[   96.990247]  ? sgx_ioctl+0x87/0x470
[   96.993696]  do_vfs_ioctl+0xa9/0x6d0
[   96.997151]  ? tomoyo_file_ioctl+0x19/0x20
[   97.000571]  ksys_ioctl+0x75/0x80
[   97.003983]  ? do_syscall_64+0x17/0x230
[   97.007285]  __x64_sys_ioctl+0x1a/0x20
[   97.010487]  do_syscall_64+0x5f/0x230
[   97.013612]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   97.016791] RIP: 0033:0x7f2d79e135d7
[   97.019897] Code: b3 66 90 48 8b 05 b1 48 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 81 48 2d 00 f7 d8 64 89 01 48
[   97.026332] RSP: 002b:00007ffd983721f8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[   97.029673] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2d79e135d7
[   97.033037] RDX: 00007ffd98372260 RSI: 000000004020a401 RDI: 0000000000000003
[   97.036426] RBP: 00007ffd98372330 R08: 0000000000000003 R09: 0000000000000000
[   97.039813] R10: 00007ffd98372350 R11: 0000000000000202 R12: 00005565ae6e89e0
[   97.043190] R13: 00007ffd98373c40 R14: 0000000000000000 R15: 0000000000000000
[  681.794211] kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

$ sudo cat /sys/kernel/debug/kmemleak
[sudo] password for jsakkine:
unreferenced object 0xffff990325b69eb0 (size 16):
  comm "kworker/u8:1", pid 31, jiffies 4294895395 (age 1718.288s)
  hex dump (first 16 bytes):
    6d 65 6d 73 74 69 63 6b 30 00 01 00 00 00 00 00  memstick0.......
  backtrace:
    [<0000000010512df5>] __kmalloc_track_caller+0x139/0x280
    [<00000000a5374cb0>] kstrdup+0x31/0x60
    [<00000000c59be911>] kstrdup_const+0x24/0x30
    [<00000000ff88e957>] kvasprintf_const+0x86/0xa0
    [<0000000050affb9a>] kobject_set_name_vargs+0x23/0x90
    [<00000000839b8dd7>] dev_set_name+0x4e/0x70
    [<0000000069897a8c>] memstick_check+0xdf/0x3a3 [memstick]
    [<00000000dffb0c9f>] process_one_work+0x281/0x5c0
    [<00000000090981e2>] worker_thread+0x34/0x400
    [<00000000bb117b3c>] kthread+0x121/0x140
    [<000000004d2f4c32>] ret_from_fork+0x24/0x50

/Jarkko
