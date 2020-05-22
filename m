Return-Path: <SRS0=O4vE=7E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B84C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 19:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3AEE20757
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 19:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbgEVT5K (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 May 2020 15:57:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:20572 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730893AbgEVT5K (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 May 2020 15:57:10 -0400
IronPort-SDR: tEGCON5OV2wKRVPc/fcO3DdAW43wemNTkjXCheGSGSYLk+EC4OOJhGIk4ir+Vr1CUY0002gxBo
 LVuobboztU6w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 12:57:10 -0700
IronPort-SDR: K723Xvg1R3YAg93y5ZDcdwgAuI7bmNZSJTwz3PgoR3DEDLmclGRhsJneZa4b/xPf6A1Va8kFf4
 +RvPgDSv9Vmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,422,1583222400"; 
   d="scan'208";a="300770364"
Received: from rpurrx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.58.10])
  by fmsmga002.fm.intel.com with ESMTP; 22 May 2020 12:57:05 -0700
Date:   Fri, 22 May 2020 22:57:05 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-mm@kvack.org, Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>
Subject: Re: [PATCH v30 12/20] x86/sgx: Add a page reclaimer
Message-ID: <20200522195705.GA121599@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-13-jarkko.sakkinen@linux.intel.com>
 <20200522065802.GC23459@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522065802.GC23459@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 21, 2020 at 11:58:02PM -0700, Sean Christopherson wrote:
> > +		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> > +
> > +		spin_lock(&sgx_active_page_list_lock);
> > +		list_add_tail(&epc_page->list, &sgx_active_page_list);
> > +		spin_unlock(&sgx_active_page_list_lock);
> 
> Ugh, this is wrong.  If the above kref_put() drops the last reference and
> releases the enclave, adding the page to the active page list will result
> in a use-after-free as the enclave will have been freed.  It also leaks the
> EPC page because sgx_encl_destroy() skips pages that are in the process of
> being reclaimed (as detected by list_empty()).
> 
> The "original" code did the put() after list_add_tail(), but was moved in
> v15 to fix a bug where the put() could drop a reference to the wrong enclave
> if the page was freed and reallocated by a different CPU between
> list_add_tail() and put().  But, that particular bug only occurred because
> the code at the time was:
> 
> 	sgx_encl_page_put(epc_page);
> 
> I.e. the backpointer in epc_page was consumed after dropping the spin lock.
> So long as epc_page->owner (well, epc_page in general) isn't dereferenced,
> I'm 99% certain this can be fixed simply by doing kref_put() after moving
> the page back to the active page list.

Yes. It is certainly a regression to not call it after
sgx_active_page_list. That was a good catch, thanks.

v31:
* Unset SGX_ENCL_IOCTL in the error path of checking encl->flags in order
  to prevent leaving it set and thus block any further ioctl calls.
* Added missing cleanup_srcu_struct() call to sgx_encl_release().
* Take encl->lock in sgx_encl_add_page() in order to prevent races with
  the page reclaimer.
* Fix a use-after-free bug from page reclaimer. Call kref_put() for the
  encl->refcount only after putting enclave page back to the active page
  list because it could be the last ref to the enclave.

I'm ready to send a new version of the patch set once there is a
conclusion with the sigstruct vendor field.

/Jarkko
