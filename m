Return-Path: <SRS0=OrTC=YP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C65CA9EA0
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 03:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E84B2086D
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 03:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387463AbfJVDgU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Oct 2019 23:36:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:45571 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387437AbfJVDgU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Oct 2019 23:36:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 20:36:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,326,1566889200"; 
   d="scan'208";a="209580374"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 21 Oct 2019 20:36:18 -0700
Date:   Mon, 21 Oct 2019 20:36:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 09/12] x86/sgx: Split second half of
 sgx_free_page() to a separate helper
Message-ID: <20191022033617.GD32147@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191016183745.8226-10-sean.j.christopherson@intel.com>
 <20191018100655.GC4835@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018100655.GC4835@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 18, 2019 at 01:06:55PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 16, 2019 at 11:37:42AM -0700, Sean Christopherson wrote:
> > Move the post-reclaim half of sgx_free_page() to a standalone helper so
> > that it can be used in flows where the page is known to be
> > non-reclaimable.
> 
> The call sites wher it is known to be reclaimable should handle the
> error instead of creating call site specific versions of the function.

What if we completely split the function(s)?  The existing callers of
sgx_free_page() stay as is, there is one and only one "free_page()", we
don't take sgx_active_page_list_lock in most flows, and the one case
where failure is acceptable gets to do its thing.  I think this'd make
both of us happy.  E.g.:

/**
 * sgx_unmark_page_reclaimable() - Unmark a page as reclaimable
 * @page:	EPC page
 *
 * Clear the reclaimable flag from the page and remove the page from the active
 * page list.
 *
 * Return:
 *   0 on success,
 *   -EBUSY if a reclaim is in progress
 */
int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
{
	/*
	 * Remove the page from the active list if necessary.  If the page
	 * is actively being reclaimed, i.e. RECLAIMABLE is set but the
	 * page isn't on the active list, return -EBUSY as we can't free
	 * the page at this time since it is "owned" by the reclaimer.
	 */
	spin_lock(&sgx_active_page_list_lock);
	if (page->desc & SGX_EPC_PAGE_RECLAIMABLE) {
		if (list_empty(&page->list)) {
			spin_unlock(&sgx_active_page_list_lock);
			return -EBUSY;
		}
		list_del(&page->list);
		page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
	}
	spin_unlock(&sgx_active_page_list_lock);

	return 0;
}

/**
 * sgx_free_page() - Free an EPC page
 * @page:	pointer a previously allocated EPC page
 *
 * EREMOVE an EPC page and insert it back to the list of free pages. The page
 * must not be reclaimable.
 */
void sgx_free_page(struct sgx_epc_page *page)
{
	struct sgx_epc_section *section;
	int ret;

	/*
	 * Don't take sgx_active_page_list_lock when asserting the page isn't
	 * reclaimable, missing a WARN in the very rare case is preferable to
	 * unnecessarily taking a global lock in the common case.
	 */
	WARN_ON_ONCE(page->desc & SGX_EPC_PAGE_RECLAIMABLE);

	ret = __eremove(sgx_epc_addr(page));
	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
		return;

	section = sgx_epc_section(page);

	spin_lock(&section->lock);
	list_add_tail(&page->list, &section->page_list);
	section->free_cnt++;
	spin_unlock(&section->lock);
}  

