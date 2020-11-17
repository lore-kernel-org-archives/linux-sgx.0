Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2ECC2D0E4
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Nov 2020 19:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3E5124248
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Nov 2020 19:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxSXaDVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgKQTPu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Nov 2020 14:15:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgKQTPu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Nov 2020 14:15:50 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E87A924248;
        Tue, 17 Nov 2020 19:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605640549;
        bh=qCbF58vgiefZ8VCYS9ofR3cSVoZzEVxnJQJ9R5/mjYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AxSXaDVSs9+X8EC5IoAogPm8KBYugk+hG0CvV5NERmDBD26HGnSiqO7qN855ik75o
         WBLZU7DBN62oQtX/RSvNs3Fuezj/58unPbE/8zZKVltEUQfnnFDJiNVbu6VAlr5GzU
         RvrxcCoF7GiJY6YRVot03n0h3aZwvOoFm8m/ECOM=
Date:   Tue, 17 Nov 2020 21:15:40 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@infradead.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v41 10/24] mm: Add 'mprotect' hook to struct
 vm_operations_struct
Message-ID: <20201117191540.GB10393@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
 <20201112220135.165028-11-jarkko@kernel.org>
 <20201115173208.GR17076@casper.infradead.org>
 <96318679-3320-8d7c-d178-7fa34ed11fdf@intel.com>
 <20201116100957.GM3371@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116100957.GM3371@techsingularity.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 16, 2020 at 10:09:57AM +0000, Mel Gorman wrote:
> On Sun, Nov 15, 2020 at 10:36:51AM -0800, Dave Hansen wrote:
> > On 11/15/20 9:32 AM, Matthew Wilcox wrote:
> > > On Fri, Nov 13, 2020 at 12:01:21AM +0200, Jarkko Sakkinen wrote:
> > >> +++ b/include/linux/mm.h
> > >> @@ -559,6 +559,13 @@ struct vm_operations_struct {
> > >>  	void (*close)(struct vm_area_struct * area);
> > >>  	int (*split)(struct vm_area_struct * area, unsigned long addr);
> > >>  	int (*mremap)(struct vm_area_struct * area);
> > >> +	/*
> > >> +	 * Called by mprotect() to make driver-specific permission
> > >> +	 * checks before mprotect() is finalised.   The VMA must not
> > >> +	 * be modified.  Returns 0 if eprotect() can proceed.
> > >> +	 */

Wonder if this should also document the negative case for the return
value, i.e. -EACCES is returned otherwise.

> > > 
> > > This is the wrong place for this documentation, and it's absurdly
> > > specific to your implementation.  It should be in
> > > Documentation/filesystems/locking.rst.
> > 
> > I'll let you and Mel duke that one out:
> > 
> 
> I suggested placing the comment there to make it clear what the expected
> semantics of the hook was to reduce the chances of abuse or surprises. The
> hook does not affect locking so Documentation/filesystems/locking.rst
> didn't appear appropriate other than maybe adding a note there
> that it doesn't affect locks. The hook also is not expecting any
> filesystems-specific action that I aware of but a note could be added to
> the effect that filesystems should not need to take special action for it.
> Protections on the filesystem level are for the inode, I can't imagine what
> a filesystem would do with a protection change on the page table level
> but maybe I'm not particularly imaginative today.

I try to decipher this in generic context.

In a permission check of a filesystem, truncated pages should be
encapsulated in to the permission decision. It's a just a query.

So maybe I'll add something like:

"This callback does only a permission query, and thus does never
return locked pages."

> -- 
> Mel Gorman
> SUSE Labs

/Jarkko
