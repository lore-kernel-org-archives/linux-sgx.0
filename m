Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FFFC433DB
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Mar 2021 19:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5616E64F47
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Mar 2021 19:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhCOT1x (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Mar 2021 15:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233586AbhCOT11 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 15 Mar 2021 15:27:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B3DA64F46;
        Mon, 15 Mar 2021 19:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615836446;
        bh=B9Zaqp7qDgzuY3QfvLnC2i2wc3n6xAWHPD7JtCMCtj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hHw/oNSx5lpQRscPeZbxmP54g2oiEBaKJjSRZaNUIMR3jsHThLKkP3MRed2IlnaoY
         znAacKhWStJGkzO3naon/M4HioOSGqWIzXXddim4m5nz7iq92T/zSbdabD7ZLufVXI
         /RhAdYXJdDJ3892Arq8gMYE8SqJc8NH2scCgEm5+dlPL9kJrAC273KYznsf6xPQ0pc
         gsd2e8RpgZjuXbW2gNZqhh+zPXQZEafJv9k3kRAr++YzGgGLWFxeRAva96sDZQtlBF
         I3dO0w3wMtwssmyPusIOVgGsnXeYB5gpzpCO3VciARxPy5XlESYH4bmbNg4AD26L9L
         8wyDNEme0eLfQ==
Date:   Mon, 15 Mar 2021 21:27:00 +0200
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
Message-ID: <YE+1BPyK5SsizhEi@kernel.org>
References: <20210313160119.1318533-1-jarkko@kernel.org>
 <20210313160119.1318533-2-jarkko@kernel.org>
 <ab40db7a-234e-b28e-c235-0c720d2d6a5f@intel.com>
 <YE+wMvw4YuDKu1xx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE+wMvw4YuDKu1xx@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 15, 2021 at 09:06:29PM +0200, Jarkko Sakkinen wrote:
> On Mon, Mar 15, 2021 at 08:32:13AM -0700, Dave Hansen wrote:
> > On 3/13/21 8:01 AM, Jarkko Sakkinen wrote:
> > > Replace the ad-hoc code with a sgx_free_epc_page(), in order to make sure
> > > that all the relevant checks and book keeping is done, while freeing a
> > > borrowed EPC page, and remove redundant code. EREMOVE inside
> > > sgx_free_epc_page() does not change the semantics, as EREMOVE to an
> > > uninitialize pages is a nop.
> > 
> >   ^ uninitialized
> > 
> > I know this is a short patch, but this changelog still falls a bit short
> > for me.
> > 
> > Why is this patch a part of _this_ series?  What *problem* does it
> > solve, related to this series?
> 
> I'm thinking of merging sgx_epc_section and sgx_numa_node. That's why I
> kept it as part of the series. 
> 
> Also, in any case it's better to clean up duplicate functionality. The
> code is essentially open coded implementation of sgx_free_epc_page()
> without EREMOVE.
> 
> > It would also be nice to remind me why the EREMOVE is redundant.  Why
> > didn't we need one before?  What put the page in the uninitialized
> > state?  Is EREMOVE guaranteed to do nothing?  How expensive is it?
> 
> EREMOVE gets removed by KVM series from sgx_free_epc_page() anyway.
> 
> Maybe should re-send this patch, or series, after KVM series is merged.
> Then there is no explaining with EREMOVE, as sgx_free_epc_page() won't
> contain it.

Anyway, forgot to put the end statement: I'm cool with dropping this but
I'll also send this right after KVM SGX series has landed as separate
patch, if I drop this now.

/Jarkko
