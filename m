Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1338C2D0E4
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Nov 2020 18:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C572465E
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Nov 2020 18:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/JxMqz3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgKQSNG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Nov 2020 13:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbgKQSNF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Nov 2020 13:13:05 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 399592465E;
        Tue, 17 Nov 2020 18:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605636784;
        bh=j4n786X/dzDqCILY/BB0WGn53xdUqEaWzVDPSgU9zR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k/JxMqz3aFCVnlvIAukoACL+vLQYQHMsho54NcS//LAySqJJqBNk9KcTy12QASC/d
         9Jz2cHZKhRFTxQ1n/8vnoX12NR9cb7WjqYAnhSMnLGszdNAfoJ56013A28Vvus+LCi
         bEh8lWj0rnMe8PfhClWBMdAoYV1fhVL3JIQg05j0=
Date:   Tue, 17 Nov 2020 20:12:58 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Hillf Danton <hdanton@sina.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org
Subject: Re: [PATCH v41 06/24] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Message-ID: <20201117181258.GE8524@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
 <20201114090708.8684-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114090708.8684-1-hdanton@sina.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 14, 2020 at 05:07:08PM +0800, Hillf Danton wrote:
> On Fri, 13 Nov 2020 00:01:17 +0200 
> > 
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > The x86 architecture has a set of page fault error codes.  These indicate
> > things like whether the fault occurred from a write, or whether it
> > originated in userspace.
> > 
> > The SGX hardware architecture has its own per-page memory management
> > metadata (EPCM) [*] and hardware which is separate from the normal x86 MMU.
> > The architecture has a new page fault error code: PF_SGX.  This new error
> > code bit is set whenever a page fault occurs as the result of the SGX MMU.
> > 
> > These faults occur for a variety of reasons.  For instance, an access
> > attempt to enclave memory from outside the enclave causes a PF_SGX fault.
> > PF_SGX would also be set for permission conflicts, such as if a write to an
> > enclave page occurs and the page is marked read-write in the x86 page
> > tables but is read-only in the EPCM.
> > 
> > These faults do not always indicate errors, though.  SGX pages are
> > encrypted with a key that is destroyed at hardware reset, including
> > suspend. Throwing a SIGSEGV allows user space software to react and recover
> > when these events occur.
> > 
> > Include PF_SGX in the PF error codes list and throw SIGSEGV when it is
> > encountered.
> > 
> > [*] Intel SDM: 36.5.1 Enclave Page Cache Map (EPCM)
> > 
> > Acked-by: Jethro Beekman <jethro@fortanix.com> # v40
> > # Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >  arch/x86/include/asm/trap_pf.h |  1 +
> >  arch/x86/mm/fault.c            | 12 ++++++++++++
> >  2 files changed, 13 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
> > index 305bc1214aef..1794777b2a85 100644
> > --- a/arch/x86/include/asm/trap_pf.h
> > +++ b/arch/x86/include/asm/trap_pf.h
> > @@ -19,6 +19,7 @@ enum x86_pf_error_code {
> >  	X86_PF_RSVD	=		1 << 3,
> >  	X86_PF_INSTR	=		1 << 4,
> >  	X86_PF_PK	=		1 << 5,
> > +	X86_PF_SGX	=		1 << 15,
> >  };
> >  
> >  #endif /* _ASM_X86_TRAP_PF_H */
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 82bf37a5c9ec..9339fee83784 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -1101,6 +1101,18 @@ access_error(unsigned long error_code, struct vm_area_struct *vma)
> >  	if (error_code & X86_PF_PK)
> >  		return 1;
> >  
> > +	/*
> > +	 * SGX hardware blocked the access.  This usually happens
> > +	 * when the enclave memory contents have been destroyed, like
> > +	 * after a suspend/resume cycle. In any case, the kernel can't
> > +	 * fix the cause of the fault.  Handle the fault as an access
> > +	 * error even in cases where no actual access violation
> > +	 * occurred.  This allows userspace to rebuild the enclave in
> > +	 * response to the signal.
> > +	 */
> 
> Given SIGSEGV, it helps much understand PF_SGX to specify the rebuild
> in userspace a bit more.

I'm sorry but I'm not exactly sure what you are suggesting.

/Jarkko
