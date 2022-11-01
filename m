Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A026FFA3740
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Nov 2022 00:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiKAAxu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 31 Oct 2022 20:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKAAxt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 31 Oct 2022 20:53:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF19E3F
        for <linux-sgx@vger.kernel.org>; Mon, 31 Oct 2022 17:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED068614EC
        for <linux-sgx@vger.kernel.org>; Tue,  1 Nov 2022 00:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51B2C433D6;
        Tue,  1 Nov 2022 00:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667264027;
        bh=5nhiEn1NgmMqRPh15oTTVv+clUHPsBKpYuZSZGEaS9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MkZB42E8AD7YwjpOTqta+78mpstZ4FtHEvvfo7vvosKc8IRLNjqNPGJJCxcpoewS2
         6RbgP5qDKvjxkSzwxk/aAxfLsr+5s6KvhW5sLQJ/QKLeLOBkVPbA4VhG99G2umi20f
         nCbC2tlBf6LtKKlXrtH9zQpF5N0IFNZOdN3inqmf2XXNwwfeiCO/dP8+oWkcvrfCOd
         u2PcFwXiFpbew/wJ84l1fFl9no6fEI8YvSBUBxmzHF2Y+EUj+U0oHBpE+Tcnv+9ExP
         nuGVIyKQFGY1cP2ao/dag9PXRHyNHd8cU6RE+bBE68Eain/YAxtw4ahdjA+/nov6mI
         tR+AsN4QHNgAA==
Date:   Tue, 1 Nov 2022 02:53:43 +0200
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@suse.de" <bp@suse.de>, "Zhang, Cathy" <cathy.zhang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>, "Du, Fan" <fan.du@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Message-ID: <Y2BuF1juF0R0hhq0@kernel.org>
References: <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
 <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
 <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
 <4930999a-888f-88bc-a05c-86762504f059@intel.com>
 <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
 <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
 <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
 <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
 <Y1WmZgqIkl8GkR/i@kernel.org>
 <31afc45e67f303645b81d231e4a5cb6878b30016.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31afc45e67f303645b81d231e4a5cb6878b30016.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 24, 2022 at 10:23:10PM +0000, Huang, Kai wrote:
> On Sun, 2022-10-23 at 23:39 +0300, jarkko@kernel.org wrote:
> > On Wed, Oct 19, 2022 at 10:59:20AM +0000, Huang, Kai wrote:
> > > static int __sgx_vepc_fault(struct sgx_vepc *vepc,
> > >                             struct vm_area_struct *vma, unsigned long addr)
> > > {
> > > 	......
> > >         /* Calculate index of EPC page in virtual EPC's page_array */
> > >         index = vma->vm_pgoff + PFN_DOWN(addr - vma->vm_start);
> > > 
> > >         epc_page = xa_load(&vepc->page_array, index);
> > >         if (epc_page)
> > >                 return 0;
> > > 
> > > 	...
> > > }
> > > 
> > > As you can see if the EPC page has already been populated at a given index of
> > > one virtual EPC instance, the current fault handler just assumes the mapping is
> > > already there and returns success immediately.  This causes a bug when one
> > > virtual EPC instance is shared by multi processes via fork(): if the EPC page at
> > > one index is already populated by the parent process, when the child accesses
> > > the same page using different virtual address, the fault handler just returns
> > > success w/o actually setting up the mapping for the child, resulting in endless
> > > page fault.
> > > 
> > > This needs to be fixed in no matter what way.
> > 
> > I think you mean that vm_insert_pfn() does not happen for child because
> > of early return?
> > 
> 
> Yes exactly.  Sorry for not pointing out directly.

Np.

> 
> > I did not understand the part about "different virtual
> > addresses", as it is the same mapping.
> 
> The child can use mmap() to get a new mapping.  Whether the virtual address is
> different from the parent's doesn't matter actually.

Thanks for the response, I had one additional query responded to Zhiquan.

BR, Jarkko
