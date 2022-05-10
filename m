Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFA8C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 10 May 2022 22:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiEJW3y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 10 May 2022 18:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiEJW3x (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 10 May 2022 18:29:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE28B532D6
        for <linux-sgx@vger.kernel.org>; Tue, 10 May 2022 15:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62AD8B82011
        for <linux-sgx@vger.kernel.org>; Tue, 10 May 2022 22:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E53C385CF;
        Tue, 10 May 2022 22:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652221790;
        bh=PXan+IhIFqoIaHarJRB2MPETOphN16lYiDg7CTcLJr0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AIikEBJV5XFtfXf5kLHTJ6PuTr6s9RzXFB8okvPKf3wvu1BSCi3ebbchDqVlxFQMQ
         EEjTpAWQA8jqTKeUjeD1gn1ha8IZy2zjGCwsEL4FCYGrD8Qr01zDGsZx/gdpzryLWo
         2V+gril4EqfMLNTp+qGVzB1lX/1fm8hPQ84UBmjTrOyxaI4+O2k2cXNvMDzfXX7+MX
         2dvmkkRr8wDe7Muwymd+GeRjKczDF/N7QkFOu0L0VaHSm0KPeybeyFTtOAu9OsgTqy
         eTl5yvIjNu/2VgR0tpXue6WSVn3LsLR9Eh7DHtpqPrBKU14jqVnX7qsZ+A56yQET0o
         uJqIi16PDwEYw==
Date:   Wed, 11 May 2022 01:28:20 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, haitao.huang@intel.com
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Message-ID: <YnrnBIavYD8yA3Jx@kernel.org>
References: <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
 <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
 <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
 <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
 <d7a3929d-3b49-dc77-8f6c-0308fbcf3948@intel.com>
 <f6e64c4f-8539-b7e7-7890-a4b1acc073fe@intel.com>
 <c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com>
 <Ynavabraw26HwnfW@kernel.org>
 <Ynaw2A0z6mBLU0m4@kernel.org>
 <c75f56b5-e071-fe37-835e-7cdd275852f5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c75f56b5-e071-fe37-835e-7cdd275852f5@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, May 09, 2022 at 10:09:24AM -0700, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 5/7/2022 10:48 AM, Jarkko Sakkinen wrote:
> > On Sat, May 07, 2022 at 08:46:50PM +0300, Jarkko Sakkinen wrote:
> >> On Mon, May 02, 2022 at 02:33:06PM -0700, Dave Hansen wrote:
> >>> On 5/2/22 10:11, Reinette Chatre wrote:
> >>>> My goal was to prevent the page fault handler from doing a "is the PCMD
> >>>> page empty" if the reclaimer has a reference to it. Even if the PCMD page
> >>>> is empty when the page fault handler checks it the page is expected to
> >>>> get data right when reclaimer can get the mutex back since the reclaimer
> >>>> already has a reference to the page.
> >>>
> >>> I think shmem_truncate_range() might be the wrong operation.  It
> >>> destroys data and, in the end, we don't want to destroy data.
> >>> Filesystems and the page cache already have nice ways to keep from
> >>> destroying data, we just need to use them.
> >>>
> >>> First, I think set_page_dirty(pcmd_page) before the EWB is a good start.
> >>>  That's what filesystems do before important data that needs to be saved
> >>> goes into pages.
> >>>
> >>> Second, I think we need behavior like POSIX_FADV_DONTNEED, not
> >>> FALLOC_FL_PUNCH_HOLE.  The DONTNEED operations end up in
> >>> mapping_evict_folio(), which has both page refcount *and* dirty page
> >>> checks.  That means that either elevating a refcount or set_page_dirty()
> >>> will thwart DONTNEED-like behavior.
> >>>
> >>> There are two basic things we need to do:
> >>>
> >>> 1. Prevent page from being truncated around EWB time
> >>> 2. Prevent unreferenced page with all zeros from staying in shmem
> >>>    forever or taking up swap space
> >>>
> >>> On the EWB (write to PCMD side) I think something like this works:
> >>>
> >>> 	sgx_encl_get_backing()
> >>> 		get_page(pcmd_page)
> >>>
> >>> 	...
> >>> 	lock_page(pcmd_page);
> >>> 	// check for truncation since sgx_encl_get_backing()
> >>> 	if (pcmd_page->mapping != shmem)
> >>> 		goto retry;
> >>> 	 // double check this is OK under lock_page():
> >>> 	set_page_dirty(pcmd_page);
> >>> 	__sgx_encl_ewb();
> >>> 	unlock_page(pcmd_page);
> >>>
> >>> That's basically what filesystems do.  Get the page from the page cache,
> >>> lock it, then make sure it is consistent.  If not, retry.
> >>>
> >>> On the "free" / read in (ELDU) side:
> >>>
> >>> 	// get pcmd_page ref
> >>> 	lock_page(pcmd_page);
> >>> 	// truncation is not a concern because that's only done
> >>> 	// on the read-in side, here, where we hold encl->lock
> >>>
> >>> 	memset();
> >>> 	if (!memchr_inv())
> >>> 		// clear the way for DONTNEED:
> >>> 		ClearPageDirty(pcmd_page);
> >>> 	unlock_page(pcmd_page);
> >>> 	// drop pcmd_page ref
> >>> 	...
> >>> 	POSIX_FADV_DONTNEED
> >>>
> >>> There's one downside to this: it's _possible_ that an transient
> >>> get_page() would block POSIX_FADV_DONTNEED.  Then the zeroed page would
> >>> stick around forever, or at least until the next ELDU operation did
> >>> another memchr_inv().
> >>>
> >>> I went looking around for some of those and could not find any that I
> >>> *know* apply to shmem.
> >>>
> >>> This doesn't feel like a great solution; it's more complicated than I
> >>> would like.  Any other ideas?
> >>
> >> If we could do both truncation and swapping in one side, i.e. in ksgxd,
> >> that would simplify this process a lot. Then the whole synchronization
> >> problem would not exist.
> >>
> >> E.g. perhaps #PF handler could just zero PCMD and collect zeroed pages
> >> indices to a list and ksgxd would truncate them.
> > 
> > I.e. instead of immediate response, go for lazy response that is taken 
> > care by ksgxd.
> 
> Could you please elaborate how you envision this solution? From what I understand
> there would be a per-enclave list that contains information about empty
> PCMD pages intended to be truncated. The page fault handler adds pages
> to this list and the reclaimer needs to remove pages from this list when
> it writes to those pages and then do the actual truncation - but it is not
> clear how the reclaimer will know when it can safely remove a page from the
> list since it obtains PCMD page references in batches.
> 
> Did you get a chance to consider the fix proposed in
> https://lore.kernel.org/linux-sgx/d4b52482-2dd0-d5f1-bda9-e1d97883298d@intel.com/ 
> 
> I understand that the email thread may have become hard to follow and I plan
> to submit a new series today.

Let's just say that I came a bit late to the series, and should have read
the whole thread before responding to anything. As long as enclave lock is
kept on both sides things should be fine.

I think for bugs like these it would make sense to put them out early as
possible, e.g. I would be fine getting them from kernel bugzilla. Now there
there was two week latency on finding the issue, and making it public.
Unless there is something confidential, it would be best to get early
alert. I'm always ready to change my priorities to help to fix such issues.

BR, Jarkko
