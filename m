Return-Path: <SRS0=O4vE=7E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915A2C433E2
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 06:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D20D2065C
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 06:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgEVG6D (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 May 2020 02:58:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:42451 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgEVG6D (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 May 2020 02:58:03 -0400
IronPort-SDR: oCM9akwUFKwx6rIyt+qmXcQfF63CBXxz679A3q8tZWNPwE8ASRNL/Y73onzhPo4apWbSs2VZ3V
 0u+mBgqeg+xg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:58:02 -0700
IronPort-SDR: 8415cHuEaH0PHAeVc9B5qr4u66DcLGdB1irTEIoID0pcEQk2DOfsyVivI35zxTv/T88F9xFOII
 KmQT9wO/e2aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="301031849"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 21 May 2020 23:58:02 -0700
Date:   Thu, 21 May 2020 23:58:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Message-ID: <20200522065802.GC23459@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-13-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515004410.723949-13-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 15, 2020 at 03:44:02AM +0300, Jarkko Sakkinen wrote:
> +/**
> + * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
> + *
> + * Take a fixed number of pages from the head of the active page pool and
> + * reclaim them to the enclave's private shmem files. Skip the pages, which
> + * have been accessed since the last scan. Move those pages to the tail of
> + * active page pool so that the pages get scanned in LRU like fashion.
> + */
> +void sgx_reclaim_pages(void)
> +{
> +	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
> +	struct sgx_backing backing[SGX_NR_TO_SCAN];
> +	struct sgx_epc_section *section;
> +	struct sgx_encl_page *encl_page;
> +	struct sgx_epc_page *epc_page;
> +	int cnt = 0;
> +	int ret;
> +	int i;
> +
> +	spin_lock(&sgx_active_page_list_lock);
> +	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
> +		if (list_empty(&sgx_active_page_list))
> +			break;
> +
> +		epc_page = list_first_entry(&sgx_active_page_list,
> +					    struct sgx_epc_page, list);
> +		list_del_init(&epc_page->list);
> +		encl_page = epc_page->owner;
> +
> +		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0)
> +			chunk[cnt++] = epc_page;
> +		else
> +			/* The owner is freeing the page. No need to add the
> +			 * page back to the list of reclaimable pages.
> +			 */
> +			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
> +	}
> +	spin_unlock(&sgx_active_page_list_lock);
> +
> +	for (i = 0; i < cnt; i++) {
> +		epc_page = chunk[i];
> +		encl_page = epc_page->owner;
> +
> +		if (!sgx_reclaimer_age(epc_page))
> +			goto skip;
> +
> +		ret = sgx_encl_get_backing(encl_page->encl,
> +					   SGX_ENCL_PAGE_INDEX(encl_page),
> +					   &backing[i]);
> +		if (ret)
> +			goto skip;
> +
> +		mutex_lock(&encl_page->encl->lock);
> +		encl_page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> +		mutex_unlock(&encl_page->encl->lock);
> +		continue;
> +
> +skip:
> +		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> +
> +		spin_lock(&sgx_active_page_list_lock);
> +		list_add_tail(&epc_page->list, &sgx_active_page_list);
> +		spin_unlock(&sgx_active_page_list_lock);

Ugh, this is wrong.  If the above kref_put() drops the last reference and
releases the enclave, adding the page to the active page list will result
in a use-after-free as the enclave will have been freed.  It also leaks the
EPC page because sgx_encl_destroy() skips pages that are in the process of
being reclaimed (as detected by list_empty()).

The "original" code did the put() after list_add_tail(), but was moved in
v15 to fix a bug where the put() could drop a reference to the wrong enclave
if the page was freed and reallocated by a different CPU between
list_add_tail() and put().  But, that particular bug only occurred because
the code at the time was:

	sgx_encl_page_put(epc_page);

I.e. the backpointer in epc_page was consumed after dropping the spin lock.
So long as epc_page->owner (well, epc_page in general) isn't dereferenced,
I'm 99% certain this can be fixed simply by doing kref_put() after moving
the page back to the active page list.

> +
> +		chunk[i] = NULL;
> +	}
> +
> +	for (i = 0; i < cnt; i++) {
> +		epc_page = chunk[i];
> +		if (epc_page)
> +			sgx_reclaimer_block(epc_page);
> +	}
> +
> +	for (i = 0; i < cnt; i++) {
> +		epc_page = chunk[i];
> +		if (!epc_page)
> +			continue;
> +
> +		encl_page = epc_page->owner;
> +		sgx_reclaimer_write(epc_page, &backing[i]);
> +		sgx_encl_put_backing(&backing[i], true);
> +
> +		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> +		epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
> +
> +		section = sgx_epc_section(epc_page);
> +		spin_lock(&section->lock);
> +		list_add_tail(&epc_page->list, &section->page_list);
> +		section->free_cnt++;
> +		spin_unlock(&section->lock);
> +	}
> +}
