Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5389DC433F5
	for <linux-sgx@archiver.kernel.org>; Mon,  2 May 2022 21:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241195AbiEBVgb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 2 May 2022 17:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239512AbiEBVgb (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 2 May 2022 17:36:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD3EE09E
        for <linux-sgx@vger.kernel.org>; Mon,  2 May 2022 14:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651527181; x=1683063181;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BthX0QyJp+Gdep3YUBgKTAeuQZSKiK7s8NWdtPgFE/M=;
  b=BJ29Uv5QLJN13oKKBXw9CsKyUNFSod7PF8iBKs67XAR77gkHE+PNV4gx
   T7+0EHDjTlEDe6j7wZLs+UZMBavgFpXK2JNnT9/v+XaFSaBb0ImGFyxk0
   Yo4P1nNoBCbfz60H1KNrGpk1q9/FiJi0gkoDJP4YXR/eKKRhSULflk9gx
   sq/SPnN0DTz3BNwJGRr3yXg8YNDOAww+IQg7Py3Le/s5U698Y2PK64iuH
   6k/nC6mnTeDyGkvDp1YfRlEGC6Rief2Fjt2ulGzwfHs7KXw7zpz4moCQ4
   isP2uWDvPZ3m8XqRhNrYzLLH05OzPjAcTfpzQzDN7ZvYDvbXEIB4/UqHZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="266920820"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="266920820"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 14:32:48 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="663706246"
Received: from gsteinke-mobl.amr.corp.intel.com (HELO [10.209.165.8]) ([10.209.165.8])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 14:32:47 -0700
Message-ID: <c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com>
Date:   Mon, 2 May 2022 14:33:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
 <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
 <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
 <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
 <d7a3929d-3b49-dc77-8f6c-0308fbcf3948@intel.com>
 <f6e64c4f-8539-b7e7-7890-a4b1acc073fe@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <f6e64c4f-8539-b7e7-7890-a4b1acc073fe@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/2/22 10:11, Reinette Chatre wrote:
> My goal was to prevent the page fault handler from doing a "is the PCMD
> page empty" if the reclaimer has a reference to it. Even if the PCMD page
> is empty when the page fault handler checks it the page is expected to
> get data right when reclaimer can get the mutex back since the reclaimer
> already has a reference to the page.

I think shmem_truncate_range() might be the wrong operation.  It
destroys data and, in the end, we don't want to destroy data.
Filesystems and the page cache already have nice ways to keep from
destroying data, we just need to use them.

First, I think set_page_dirty(pcmd_page) before the EWB is a good start.
 That's what filesystems do before important data that needs to be saved
goes into pages.

Second, I think we need behavior like POSIX_FADV_DONTNEED, not
FALLOC_FL_PUNCH_HOLE.  The DONTNEED operations end up in
mapping_evict_folio(), which has both page refcount *and* dirty page
checks.  That means that either elevating a refcount or set_page_dirty()
will thwart DONTNEED-like behavior.

There are two basic things we need to do:

1. Prevent page from being truncated around EWB time
2. Prevent unreferenced page with all zeros from staying in shmem
   forever or taking up swap space

On the EWB (write to PCMD side) I think something like this works:

	sgx_encl_get_backing()
		get_page(pcmd_page)

	...
	lock_page(pcmd_page);
	// check for truncation since sgx_encl_get_backing()
	if (pcmd_page->mapping != shmem)
		goto retry;
	 // double check this is OK under lock_page():
	set_page_dirty(pcmd_page);
	__sgx_encl_ewb();
	unlock_page(pcmd_page);

That's basically what filesystems do.  Get the page from the page cache,
lock it, then make sure it is consistent.  If not, retry.

On the "free" / read in (ELDU) side:

	// get pcmd_page ref
	lock_page(pcmd_page);
	// truncation is not a concern because that's only done
	// on the read-in side, here, where we hold encl->lock

	memset();
	if (!memchr_inv())
		// clear the way for DONTNEED:
		ClearPageDirty(pcmd_page);
	unlock_page(pcmd_page);
	// drop pcmd_page ref
	...
	POSIX_FADV_DONTNEED

There's one downside to this: it's _possible_ that an transient
get_page() would block POSIX_FADV_DONTNEED.  Then the zeroed page would
stick around forever, or at least until the next ELDU operation did
another memchr_inv().

I went looking around for some of those and could not find any that I
*know* apply to shmem.

This doesn't feel like a great solution; it's more complicated than I
would like.  Any other ideas?
