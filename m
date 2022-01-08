Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05191C433EF
	for <linux-sgx@archiver.kernel.org>; Sat,  8 Jan 2022 14:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiAHOYm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 8 Jan 2022 09:24:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49948 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiAHOYm (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 8 Jan 2022 09:24:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F95A60B11
        for <linux-sgx@vger.kernel.org>; Sat,  8 Jan 2022 14:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A77CC36AE3;
        Sat,  8 Jan 2022 14:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641651880;
        bh=xFdz/qxjhZFqo3n8Y2JG1cFBOpIZsJkszPbmmEgtBuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GPIo4W7/3BX2ghZTshWl7VRYkU6SrBxp1z0/ite09uaVtcUyoFSajVPrxf2DPTnth
         s5ej3Ma08Fkjc7kwLk1DtLV5/1WliI7jMVnrdVuVKe3BfJUMXsdNONZTHuvhOeTAl0
         QFPtK+0c/k0rtNODqBtBGBwRRB1NKdVrMZ7j5P1sx8V5VaFf/GEtcE0WTq34q1EzJ0
         W8Qmw47zDSHVZOnjLgQ+m0WV91KCE2e2pXgaBTwkbO4fXt7U1xnBW10zpz9ccqZvwD
         3kVmRZAfUuo54h2kXuVjbaYYIijbKNn3yxCCR/E1TtW5k6M1cVISBXXF5Gzyc0HQif
         /B5xDVdnRtiVA==
Date:   Sat, 8 Jan 2022 16:24:32 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kristen Carlson Accardi <kristen@linux.intel.com>,
        linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] x86/sgx: account backing pages
Message-ID: <YdmeoPO8TAjqkG5F@iki.fi>
References: <20211220174640.7542-1-kristen@linux.intel.com>
 <20211220174640.7542-3-kristen@linux.intel.com>
 <YcufxPNV8HleTPB4@iki.fi>
 <a2de9239-336c-c4db-3998-e90d6f150634@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2de9239-336c-c4db-3998-e90d6f150634@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 04, 2022 at 04:36:28PM -0800, Dave Hansen wrote:
> On 12/28/21 3:37 PM, Jarkko Sakkinen wrote:
> > On Mon, Dec 20, 2021 at 09:46:40AM -0800, Kristen Carlson Accardi wrote:
> >> +int sgx_encl_lookup_backing(struct sgx_encl *encl, unsigned long page_index,
> >> +			    struct sgx_backing *backing)
> >> +{
> >> +	return sgx_encl_get_backing(encl, page_index, backing);
> >> +}
> > Is this wrapping necessary?
> 
> Yes, I think so.
> 
> > Also, there is ambiguous terminology:
> > 
> > 1. Local function: "get_backing"
> > 2. Exported function: "lookup_backing"
> 
> I'm not sure what you're getting at.
> 
> There are three important things that you do with backing storage:
> 
> 1. Allocate it
> 2. Find it
> 3. De-allocate (free) it
> 
> Right now, the code has a pattern where it does:
> 
> 	get_backing();
> 	// do something
> 	put_backing();
> 
> That sure as heck looks like it is allocating and freeing it.  But, it's
> actually *maybe* doing an allocation.  The "find it" path also looks
> *EXACTLY* the same as the actual allocation path.  You might also recall
> that the original code didn't even *have* a (real) free path.
> 
> The "wrapping" is really just naming the two different operations that
> use the "get" function: lookup and allocate.  It's not just wrapping,
> it's clarify the logical behavior.

Why it makes sense to keep sgx_encl_get_backing(), if it has zero call
sites and not open-code its implementation to sgx_encl_lookup_backing().

I'm also wondering, why here the function is not named as
sgx_encl_charge_backing(), i.e. follow the naming convention? It would be
easier to remember the flow, when reading the code. Since we use "not as
common name", let's take advantage of it to make maintaining the code
easier later on.

The commit message says:

"Modify the existing flow for requesting backing pages to reduce the
available backing page counter and confirm that the limit has not been
exceeded. Backing page usage for loading EPC pages back out of the shared
memory do not incur a charge."

I would add, in order to make this less abstract:

"
In other words, replace call sites of sgx_encl_get_backing() with either:

* sgx_encl_lookup_backing() for ELDU, which does not cause sgx_charge_mem()
  to be invoked.
* sgx_encl_alloc_backing() for EWB, which does cause sgx_charge_mem()
  to be invoked.
"

It's currently way too abstract description of the code change.

/Jarkko
