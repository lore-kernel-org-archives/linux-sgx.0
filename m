Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067B9C433FE
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Oct 2022 23:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiJJXUl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Oct 2022 19:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJJXUj (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 10 Oct 2022 19:20:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C2D7C1A8
        for <linux-sgx@vger.kernel.org>; Mon, 10 Oct 2022 16:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665444039; x=1696980039;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7TeD1p1oMsDGt2RbGFucpvkUN2vfGQ4dQVDjWnOuHG8=;
  b=XknmzuAzCA659+oOyTkXW6wk2RakbxJXFTp7oYDVS1X6EekmQnhQwHur
   czdO/6XeStBdbf8Uk0xVR65NWnFXew8Xd/3TN4iyCKHPkmgTDKJclMbhY
   q8nI2LEkZ1dQr0BtLQzGi0UMKJ1qBq4sUSWyw2C8rtmf7WNPYZ6ahSkYb
   WLi4i1lCnt2K38rQDVL/I2kR9rjozD21iN7U9MBoPnhZPYfKfgdUYQNmQ
   g69DkF0h5PhJP9yzckbYWmpWBQc8Yjy8WMqFD9kHosDNBJVTuQDGbXY+k
   r63ypJkwP7+bUp8HYOM0cvNEo8gleeitH1gmB1l4ouU0h41uHjEliii+b
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="284087924"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="284087924"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 16:20:39 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="603912883"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="603912883"
Received: from dfiori-mobl1.amr.corp.intel.com (HELO [10.212.252.24]) ([10.212.252.24])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 16:20:37 -0700
Message-ID: <befac658-a821-5ae3-94db-09bbf6fd4a54@intel.com>
Date:   Mon, 10 Oct 2022 16:20:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        kai.huang@intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220920063948.3556917-4-zhiquan1.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 9/19/22 23:39, Zhiquan Li wrote:
> +	if (flags & MF_ACTION_REQUIRED) {
> +		/*
> +		 * Provide extra info to the task so that it can make further
> +		 * decision but not simply kill it. This is quite useful for
> +		 * virtualization case.
> +		 */

"Quite useful to the virtualization case", eh?

This code can only even be *run* in the virtualization case.

> +		if (page->flags & SGX_EPC_PAGE_KVM_GUEST) {
> +			/*
> +			 * The 'encl_owner' field is repurposed, when allocating EPC
> +			 * page it was assigned to the virtual address of virtual EPC
> +			 * page.
> +			 */

That comment is talking about history, which is kinda silly.  Let's just
focus on what the code is doing today.

> +			vaddr = (void *)((unsigned long)page->vepc_vaddr & PAGE_MASK);

First, why even align this?  What does it matter?

Second, is there a reason not to use PTR_ALIGN() here?

> +			ret = force_sig_mceerr(BUS_MCEERR_AR, vaddr, PAGE_SHIFT);
> +			if (ret < 0)
> +				pr_err("Memory failure: Error sending signal to %s:%d: %d\n",
> +					current->comm, current->pid, ret);
> +		} else
> +			force_sig(SIGBUS);
> +	}

