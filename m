Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0E0C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 14:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A088E64F18
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 14:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhCSOuW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Mar 2021 10:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229942AbhCSOt7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Mar 2021 10:49:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3C0B64F18;
        Fri, 19 Mar 2021 14:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616165399;
        bh=UoynskV7fDPrJijSCnZ2qxW/urS45B41pOpEfEeHJ2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YUQ7CFLEYMfkn27VZ45tPrHUQH2JbOeIqaPGoqX9NNS/gdQiwtMxEBJKUigeeXjF/
         huq92IXhri3bpfMUDUgmQsfl8X+ORxF3wGqIETnLtnj3WzFGb6eEHHyUp7fSJz03Dk
         MQw1iDn1lej2OqLna8Tz+UbnRP6QWPPu3mLUy0TdoLlypMp/OyB5e2nWwutW2Nabhl
         4N1bwnpqODB3BlrIoStIY5DOZFa/z0EuCClSRQbqJCohG/mA/q1ynoasNUqVXHi4PJ
         wVK3Hy2RoXsa+ZQNtavPuYiLY9PWMgRiPrEb5h1JjrM0aw9MaJ6Scq69uWRQZiVh89
         2MulgGfAzRK9g==
Date:   Fri, 19 Mar 2021 16:49:32 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Avoid returning NULL in __sgx_alloc_epc_page()
Message-ID: <YFS5/Mt0C4tEimru@kernel.org>
References: <20210319040602.178558-1-kai.huang@intel.com>
 <20210319084523.GA6251@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319084523.GA6251@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 19, 2021 at 09:45:23AM +0100, Borislav Petkov wrote:
> On Fri, Mar 19, 2021 at 05:06:02PM +1300, Kai Huang wrote:
> > Below kernel bug happened when running simple SGX application when EPC
> > is under pressure.  The root cause is with commit 5b8719504e3a
> > ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()"),
> > __sgx_alloc_epc_page() returns NULL when there's no free EPC page can be
> > allocated, while old behavior was it always returned ERR_PTR(-ENOMEM) in
> > such case.
> > 
> > Fix by directly returning the page if __sgx_alloc_epc_page_from_node()
> > allocates a valid page in fallback to non-local allocation, and always
> > returning ERR_PTR(-ENOMEM) if no EPC page can be allocated.
> > 
> > [  253.474764] BUG: kernel NULL pointer dereference, address: 0000000000000008
> > [  253.500101] #PF: supervisor write access in kernel mode
> > [  253.525462] #PF: error_code(0x0002) - not-present page
> > ...
> > [  254.102041] Call Trace:
> > [  254.126699]  sgx_ioc_enclave_add_pages+0x241/0x770
> > [  254.151305]  sgx_ioctl+0x194/0x4b0
> > [  254.174976]  ? handle_mm_fault+0xd0/0x260
> > [  254.198470]  ? do_user_addr_fault+0x1ef/0x570
> > [  254.221827]  __x64_sys_ioctl+0x91/0xc0
> > [  254.244546]  do_syscall_64+0x38/0x90
> > [  254.266728]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [  254.289232] RIP: 0033:0x7fdc4cf4031b
> > ...
> > [  254.711480] CR2: 0000000000000008
> > [  254.735494] ---[ end trace 970dce6d4cdf7f64 ]---
> > [  254.759915] RIP: 0010:sgx_alloc_epc_page+0x46/0x152
> > ...
> > 
> > Fixes: 5b8719504e3a("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> I was on the verge whether to merge that into the original patch since
> it is the top patch on the branch or create a new one but opted for
> former because this way it won't break bisection and people won't have
> to pay attention whether there's a fix patch to the NUMA patch too, in
> case they wanna backport and whatnot.
> 
> Here's the new version:
> 
> Thx.
> 

Yeah, I'd also prefer to keep Dave's and Kai's patches as separate entitied.

Just in case, this was the Dave's fix:

https://patchwork.kernel.org/project/intel-sgx/patch/20210318214933.29341-1-dave.hansen@intel.com/

/Jarkko
