Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822EBC3A5A1
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 01:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E7B723402
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 01:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbfHWB2k (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:28:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:14720 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbfHWB2j (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 21:28:39 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 18:28:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="354469235"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 22 Aug 2019 18:28:39 -0700
Date:   Thu, 22 Aug 2019 18:28:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v22 v2 8/8] x86/sgx: Pass userspace source address
 directly to EADD
Message-ID: <20190823012839.GI25467@linux.intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
 <20190813011252.4121-9-sean.j.christopherson@intel.com>
 <74a9dbbed67ef131bf2179821ce74696120b35e1.camel@linux.intel.com>
 <20190822145049.GD25467@linux.intel.com>
 <5156a9c133e757dfcf8a8d003d39992aed6ade9a.camel@linux.intel.com>
 <20190823012516.cogaoq63kceol37u@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823012516.cogaoq63kceol37u@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 23, 2019 at 04:25:16AM +0300, Jarkko Sakkinen wrote:
> On Thu, Aug 22, 2019 at 08:00:15PM +0300, Jarkko Sakkinen wrote:
> > On Thu, 2019-08-22 at 07:50 -0700, Sean Christopherson wrote:
> > > On Thu, Aug 22, 2019 at 05:37:18PM +0300, Jarkko Sakkinen wrote:
> > > > On Mon, 2019-08-12 at 18:12 -0700, Sean Christopherson wrote:
> > > > > Invoke EADD with the userspace source address instead of first copying
> > > > > the data to a kernel page to avoid the overhead of alloc_page() and
> > > > > copy_from_user().
> > > > > 
> > > > > Suggested-by: Andy Lutomirski <luto@kernel.org>
> > > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > 
> > > > NAK because takes away TCS validation and the commit message
> > > > does not give any reasoning for doing that.
> > > 
> > > Doh, I have a thorough explanation, but apparently it never made it from
> > > my head to the changelog.  I'll send v2 as a standalone patch.
> > 
> > Yeah, w/o explanation I won't just take away functionality :-)
> 
> I came to realize that also from security perspective it might be
> helpful to EADD, not from a copy of the source, but from the
> actual source.
> 
> So yes, I'm for not supporting copy approach at all. I think this
> viewpoint is important to note in addition to the performance
> perspective.

Side topic, I'm getting ELDU MAC failures on master.  Are there any known
regressions, or should I start debugging?

[   18.005880] ------------[ cut here ]------------
[   18.005884] sgx: ELDU returned 9 (0x9)
[   18.005906] WARNING: CPU: 4 PID: 1142 at /home/sean/go/src/kernel.org/linux/arch/x86/kernel/cpu/sgx/encl.c:50 sgx_encl_eldu+0x363/0x390
[   18.005907] Modules linked in:
[   18.005913] CPU: 4 PID: 1142 Comm: lsdt Tainted: G        W         5.3.0-rc3+ #725
[   18.005914] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[   18.005916] RIP: 0010:sgx_encl_eldu+0x363/0x390
[   18.005917] Code: 75 11 f7 c3 00 00 00 40 ba f2 ff ff ff 0f 85 d4 fe ff ff 89 d9 89 da 48 c7 c6 4e af db 81 48 c7 c7 53 af db 81 e8 8d 1f 03 00 <0f> 0b ba f2 ff ff ff e9 b1 fe ff ff 31 c0 48 c7 c7 40 10 53 82 e9
[   18.005917] RSP: 0000:ffffc90000703d00 EFLAGS: 00010286
[   18.005918] RAX: 0000000000000000 RBX: 0000000000000009 RCX: 0000000000000006
[   18.005918] RDX: 0000000000000007 RSI: 0000000000000082 RDI: ffff88846f816560
[   18.005919] RBP: ffffc90000703d90 R08: 00000000000002da R09: 0000000000000004
[   18.005919] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88846d08a100
[   18.005920] R13: ffffea00118daa40 R14: ffff888467d3e740 R15: ffffea001189c680
[   18.005920] FS:  00007fa90afff700(0000) GS:ffff88846f800000(0000) knlGS:0000000000000000
[   18.005922] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   18.005923] CR2: 00007fa8e3001000 CR3: 0000000466389002 CR4: 0000000000360ee0
[   18.005923] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   18.005923] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   18.005924] Call Trace:
[   18.005934]  ? sgx_encl_load_page.part.15+0x56/0x90
[   18.005935]  sgx_encl_load_page.part.15+0x56/0x90
[   18.005936]  sgx_vma_fault+0x84/0xf0
[   18.005941]  __do_fault+0x4f/0x87
[   18.005943]  __handle_mm_fault+0xa65/0x1020
[   18.005945]  handle_mm_fault+0xb0/0x1f0
[   18.005946]  __do_page_fault+0x231/0x4d0
[   18.005951]  async_page_fault+0x2f/0x40
[   18.005955] RIP: 0033:0x7ffe7bd62a39
[   18.005955] Code: 74 05 c1 e8 0c 89 06 31 c0 5d c3 90 90 90 90 90 90 55 48 89 e5 83 f8 02 72 67 83 f8 03 77 62 48 8b 5d 10 48 8d 0d 00 00 00 00 <0f> 01 d7 31 db 48 8b 4d 18 e3 10 89 01 73 0c 66 89 79 04 66 89 71
[   18.005956] RSP: 002b:00007fa90affd8c0 EFLAGS: 00000202
[   18.005956] RAX: 0000000000000003 RBX: 00007fa8e3a10000 RCX: 00007ffe7bd62a39
[   18.005957] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   18.005957] RBP: 00007fa90affd8c0 R08: 0000000000000000 R09: 0000000000000000
[   18.005957] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   18.005958] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   18.005959] ---[ end trace c120e55e5ad35ff0 ]---
