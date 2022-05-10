Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA4DC433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 10 May 2022 21:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiEJVzU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 10 May 2022 17:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiEJVzS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 10 May 2022 17:55:18 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AFB297431
        for <linux-sgx@vger.kernel.org>; Tue, 10 May 2022 14:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652219718; x=1683755718;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4RKbYEeeaYQ0OcvM1o7FlPF1nvUh3trmlIOvzIBL+4I=;
  b=CftZ3pIPD3NhV2dY3vjCD9D9wf3KxU9nAKDhAXnWWthApU46s/fxxOsM
   KG/NSNRQyoxYF4hPGUnbnJSiG9j11HgEnuJ6UIAIeIB5jjgokbDSPnfTJ
   SygxooQUVA3iFNjE9Pb0ixrv6mBfl6F4gav31EfEEgAdNu9hBmpaODRgm
   X9r9HEQqa7hLFA8AjYRFXLdRmfbmLc2LuMt/SaimiTDbg5cyrssbHcALP
   3L+L3j5j1qIakFfrd7nHYAU6H3mkkhwuI3RvRfT2/zjWerlwSgn9f0KXv
   X3ODznw529iEoz782ZQQNSYzA6FnsXX6y5q/x6UmnCW/9Y/rzmIi7NbZ8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="251562016"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="251562016"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 14:55:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="542004159"
Received: from mnazari-mobl.amr.corp.intel.com (HELO [10.209.1.152]) ([10.209.1.152])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 14:55:17 -0700
Message-ID: <10f69ad5-4c19-341e-b8fd-92eca02fc66c@intel.com>
Date:   Tue, 10 May 2022 14:55:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH V2 4/5] x86/sgx: Fix race between reclaimer and page fault
 handler
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <d0ace4a1770ab8f4196bfeae06d0970ddb14ef01.1652131695.git.reinette.chatre@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <d0ace4a1770ab8f4196bfeae06d0970ddb14ef01.1652131695.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/9/22 14:48, Reinette Chatre wrote:
...
> +#define PCMDS_PER_PAGE (PAGE_SIZE / sizeof(struct sgx_pcmd))
> +/*
> + * 32 PCMD entries share a PCMD page. PCMD_FIRST_MASK is used to
> + * determine the page index associated with the first PCMD entry
> + * within a PCMD page.
> + */
> +#define PCMD_FIRST_MASK GENMASK(4, 0)
> +
> +/**
> + * pcmd_page_in_use() - Query if any enclave page associated with a PCMD
> + *                      page is in process of being reclaimed.

The name is a bit too generic for what it does.

> + * @encl:        Enclave to which PCMD page belongs
> + * @start_addr:  Address of enclave page using first entry within the PCMD page
> + *
> + * When an enclave page is reclaimed some Paging Crypto MetaData (PCMD) is
> + * stored. The PCMD data of a reclaimed enclave page contains enough
> + * information for the processor to verify the page at the time
> + * it is loaded back into the Enclave Page Cache (EPC).
> + *
> + * The backing storage to which enclave pages are reclaimed is laid out as
> + * follows:
> + * All enclave pages:SECS page:PCMD pages
> + *
> + * Each PCMD page contains the PCMD metadata of
> + * PAGE_SIZE/sizeof(struct sgx_pcmd) enclave pages.
> + *
> + * A PCMD page can only be truncated if it is (a) empty, and (b) no enclave
> + * page sharing the PCMD page is in the process of being reclaimed.

Let's also point out that (b) is _because_ the page is about to become
non-empty.

> + * The reclaimer sets the SGX_ENCL_PAGE_BEING_RECLAIMED flag when it
> + * intends to reclaim that enclave page - it means that the PCMD data
> + * associated with that enclave page is about to get some data and thus
> + * even if the PCMD page is empty, it should not be truncated.
> + *
> + * Return: 1 the PCMD page is in use, 0 if is not in use, -EFAULT on error
> + */
> +static int pcmd_page_in_use(struct sgx_encl *encl,
> +			    unsigned long start_addr)
> +{
> +	struct sgx_encl_page *entry;
> +	unsigned long addr;
> +	int reclaimed = 0;
> +	int i;

Can 'addr' and 'entry' be declared within the loop instead?

> +
> +	/*
> +	 * PCMD_FIRST_MASK is based on number of PCMD entries within
> +	 * PCMD page being 32.
> +	 */
> +	BUILD_BUG_ON(PCMDS_PER_PAGE != 32);
> +
> +	for (i = 0; i < PCMDS_PER_PAGE; i++) {
> +		addr = start_addr + i * PAGE_SIZE;
> +
> +		/*
> +		 * Stop when reaching the SECS page - it does not
> +		 * have a page_array entry and its reclaim is
> +		 * started and completed with enclave mutex held so
> +		 * it does not use the SGX_ENCL_PAGE_BEING_RECLAIMED
> +		 * flag.
> +		 */
> +		if (addr == encl->base + encl->size)
> +			break;
> +
> +		entry = xa_load(&encl->page_array, PFN_DOWN(addr));
> +		if (!entry)
> +			return -EFAULT;

Can xa_load() return NULL if it simply can't find an 'encl_page' at
'addr'?  In that case, there would never be a PCMD entry for the page
since it doesn't exist.  Returning -EFAULT would be a
pcmd_page_in_use()==true condition, which doesn't seem accurate.

> +		/*
> +		 * VA page slot ID uses same bit as the flag so it is important
> +		 * to ensure that the page is not already in backing store.
> +		 */

Probably a patch for another day, but isn't this a bit silly?  Are we
short of bits in ->desc or something?

> +		if (entry->epc_page &&
> +		    (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)) {
> +			reclaimed = 1;
> +			break;
> +		}
> +	}
> +
> +	return reclaimed;
> +}

Could we also please add a comment about encl->lock needing to be held
over this?  Without that, there would be all kinds of trouble.
