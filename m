Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4C5C433E0
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Mar 2021 19:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C991764F4C
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Mar 2021 19:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhCOTHG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Mar 2021 15:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232958AbhCOTGw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 15 Mar 2021 15:06:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E31E64E27;
        Mon, 15 Mar 2021 19:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615835211;
        bh=7MN+eRXVrzLlxy/tne7xpO8P2J6+PFdkmTcg1G3/3fI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ix+wqsv93DCnpjAg4Ub0EJsOkJvier8wnBjn4h+pwRZd75N3Hu474SbcK70q+rxmn
         iAZ4lkvvktKjZzVjxVyLCYH0JihF2dwEAP46QfrSkOhDd8H9qtYDR8bP/3ttJ8RmOI
         QicdYXZG2+M59aVU2F+MoUtU5rHLb+tVl7Kjvc0dHiwGCI5GpvBRf6qm9EhdM87sDq
         bizkl+nOqf0asI+x4VgRVsUGjbtarrZ9zpkiqLkq0N7Q/Ull1PyX9KZFqg2HkfKCvJ
         e76/GPZRXIEqoCG9oNdGccZ05N/9IrkXjB02df83wWaAlUNFWnbx/zVyZrBT/B0c8V
         ghSj5XkXjBkNg==
Date:   Mon, 15 Mar 2021 21:06:26 +0200
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
Message-ID: <YE+wMvw4YuDKu1xx@kernel.org>
References: <20210313160119.1318533-1-jarkko@kernel.org>
 <20210313160119.1318533-2-jarkko@kernel.org>
 <ab40db7a-234e-b28e-c235-0c720d2d6a5f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab40db7a-234e-b28e-c235-0c720d2d6a5f@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 15, 2021 at 08:32:13AM -0700, Dave Hansen wrote:
> On 3/13/21 8:01 AM, Jarkko Sakkinen wrote:
> > Replace the ad-hoc code with a sgx_free_epc_page(), in order to make sure
> > that all the relevant checks and book keeping is done, while freeing a
> > borrowed EPC page, and remove redundant code. EREMOVE inside
> > sgx_free_epc_page() does not change the semantics, as EREMOVE to an
> > uninitialize pages is a nop.
> 
>   ^ uninitialized
> 
> I know this is a short patch, but this changelog still falls a bit short
> for me.
> 
> Why is this patch a part of _this_ series?  What *problem* does it
> solve, related to this series?

I'm thinking of merging sgx_epc_section and sgx_numa_node. That's why I
kept it as part of the series. 

Also, in any case it's better to clean up duplicate functionality. The
code is essentially open coded implementation of sgx_free_epc_page()
without EREMOVE.

> It would also be nice to remind me why the EREMOVE is redundant.  Why
> didn't we need one before?  What put the page in the uninitialized
> state?  Is EREMOVE guaranteed to do nothing?  How expensive is it?

EREMOVE gets removed by KVM series from sgx_free_epc_page() anyway.

Maybe should re-send this patch, or series, after KVM series is merged.
Then there is no explaining with EREMOVE, as sgx_free_epc_page() won't
contain it.

/Jarkko
