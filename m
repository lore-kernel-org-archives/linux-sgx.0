Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E216AC433DB
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Mar 2021 12:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1C5265057
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Mar 2021 12:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbhCPMu4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 16 Mar 2021 08:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233343AbhCPMu3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 16 Mar 2021 08:50:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9A8165040;
        Tue, 16 Mar 2021 12:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615899029;
        bh=KO/dG7XN2AjZk+eZJx7OeL4H10cvuiyRY0B8DPBHjpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hybklB11Uv8NkUXqIcHKuPzKs1AoKjKn3TtJKWzdtsU3/RrxSrP/4Eesr//Ov0Xup
         Q44YLtTFfzfozhbxIcb4H8MiZpyJuL1atBfXBa3zgbW5gILMaHHHjHq8MuuiGScE4l
         yLEN1MkVIsJ2qPlc2N1jqtp+CgtgXOBTdio25DfTQtiwEr69ZDLB38q7m1T5//TCCc
         LXxIvPI6GfIg0zP4vdPFNLSN4PMgEa7lj0R1cmoHYCIYSgBmgca67znE4gX3mA0x7u
         S7OV6348nhhpRtVCn4IAk4ILpI28ICU5/nfXLFNKzELroNe9G22ezy5dn8Ki9qCD2T
         X+K5ubDsi7MLw==
Date:   Tue, 16 Mar 2021 14:50:04 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] x86/sgx: Use sgx_free_epc_page() in
 sgx_reclaim_pages()
Message-ID: <YFCpfEaE8k3EzHbt@kernel.org>
References: <20210313160119.1318533-1-jarkko@kernel.org>
 <20210313160119.1318533-2-jarkko@kernel.org>
 <ab40db7a-234e-b28e-c235-0c720d2d6a5f@intel.com>
 <YE+wMvw4YuDKu1xx@kernel.org>
 <YE+1BPyK5SsizhEi@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE+1BPyK5SsizhEi@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 15, 2021 at 09:27:00PM +0200, Jarkko Sakkinen wrote:
> On Mon, Mar 15, 2021 at 09:06:29PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Mar 15, 2021 at 08:32:13AM -0700, Dave Hansen wrote:
> > > On 3/13/21 8:01 AM, Jarkko Sakkinen wrote:
> > > > Replace the ad-hoc code with a sgx_free_epc_page(), in order to make sure
> > > > that all the relevant checks and book keeping is done, while freeing a
> > > > borrowed EPC page, and remove redundant code. EREMOVE inside
> > > > sgx_free_epc_page() does not change the semantics, as EREMOVE to an
> > > > uninitialize pages is a nop.
> > > 
> > >   ^ uninitialized
> > > 
> > > I know this is a short patch, but this changelog still falls a bit short
> > > for me.
> > > 
> > > Why is this patch a part of _this_ series?  What *problem* does it
> > > solve, related to this series?
> > 
> > I'm thinking of merging sgx_epc_section and sgx_numa_node. That's why I
> > kept it as part of the series. 
> > 
> > Also, in any case it's better to clean up duplicate functionality. The
> > code is essentially open coded implementation of sgx_free_epc_page()
> > without EREMOVE.
> > 
> > > It would also be nice to remind me why the EREMOVE is redundant.  Why
> > > didn't we need one before?  What put the page in the uninitialized
> > > state?  Is EREMOVE guaranteed to do nothing?  How expensive is it?
> > 
> > EREMOVE gets removed by KVM series from sgx_free_epc_page() anyway.
> > 
> > Maybe should re-send this patch, or series, after KVM series is merged.
> > Then there is no explaining with EREMOVE, as sgx_free_epc_page() won't
> > contain it.
> 
> Anyway, forgot to put the end statement: I'm cool with dropping this but
> I'll also send this right after KVM SGX series has landed as separate
> patch, if I drop this now.

HOLD ON :-)

I recalled why I added this patch to this patch set. I had a reason for
it.

It's because of the NUMA patch. I have duplicate all the NUMA changes
here if I don't refactor this somewhat redundant code out.

So, if I add a note about this to the commit message? IMHO, this is good
enough reason to carry the patch.

/Jarkko
