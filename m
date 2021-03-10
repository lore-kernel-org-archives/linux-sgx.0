Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0E5C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 10:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2B8464FBA
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 10:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhCJKzp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Mar 2021 05:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhCJKzN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Mar 2021 05:55:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03BFC64FE2;
        Wed, 10 Mar 2021 10:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615373713;
        bh=3JcwKppKqflQsCLmhQtBLOMJnbUtTMfJr/Gl2SRKIAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sGvTDdwp9NnItsFNZyBCNIxGnhlad01+OgzeS0p/IF4xeuuPCKLbRVJIIda8R9GzM
         yRVNehDcnaVFdNB+d5ZjHZtDNnAE7GAaYcXoaDua4dfxNMG+KJeNPx/Gus5dE6kdxL
         5F5dyb5ZSGK1aweKtcuknAllppUiC2YclWuMAzKOeGESYwtXmxlMeMSu03sJ/J5ywx
         BdxhznGwsn3G0K4x59WkN5HuRs7HZaBGOIDgio8bqrcBCa9ycscfbIL55FDJiTmClH
         erAYQTOkJoriOkuRdQX0/x1Xckx1MHhK1SlVcWr1lblX8Z7V/hMztZ3mC+MM3UkfhV
         FVBKBPPMH1nag==
Date:   Wed, 10 Mar 2021 12:54:49 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] x86/sgx: Replace section->page_list with a global
 free page list
Message-ID: <YEilecZyT93xdtc1@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-5-jarkko@kernel.org>
 <49b4f4d9-3f49-efd0-ce44-c24d1ee3daa6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49b4f4d9-3f49-efd0-ce44-c24d1ee3daa6@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 03, 2021 at 03:48:46PM -0800, Dave Hansen wrote:
> On 3/3/21 7:03 AM, Jarkko Sakkinen wrote:
> > Background
> > ==========
> > 
> > EPC section is covered by one or more SRAT entries that are associated with
> > one and only one PXM (NUMA node). The current implementation overheats a
> 
> Overheats?
> 
> > single NUMA node, because sgx_alloc_epc_page() always starts looking for
> > pages from the same EPC section everytime.
> 
> "every time"
> 
> > Only within a section it does pick pages in FIFO fashion, i.e. the oldest
> > freed in that section is the EPC page given back to the caller.  That does
> > not do any good, as the pages in the same node are performance-wise equal.
> 
> I'm not sure why all of this is relevant and it doesn't really tell me
> anything about this patch's place in the *series*.
> 
> Why are we destroying all of the per-node structures just before adding
> NUMA support?

These are per-section structures, not per-node structures. Probably most
times, if not all times, they are equal, but conceptually I'm not
destroying per-node structures :-) I'm introducing them in 5/5.

/Jarkko
