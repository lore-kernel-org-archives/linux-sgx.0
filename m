Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB52EC433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Oct 2022 23:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiJJXMc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Oct 2022 19:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiJJXML (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 10 Oct 2022 19:12:11 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E45D814F1
        for <linux-sgx@vger.kernel.org>; Mon, 10 Oct 2022 16:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665443472; x=1696979472;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AlqfQcW3mKIBeyddgt0QE0ACp0oLbwi9TN4fpIJuEm8=;
  b=NQ48IVItSkDBrFzcw8yrRIVhaniR+QaaP4ewAzsiE9W3yv7QUOHtRRbm
   wRWnbRf7q0CuS1hpylQsoaOo02YZipPpncYCniywQe+d/kMiSl/rESqwq
   Im1Z4aVcHnHepqjGKe1AYXOqIyftdG0/+fOSFAIDMuTkCi+kJaaxIfgZz
   HB70qSF17tJ2yykUhNrjSGwc7g3etI3+0yCqLIZ11fTE+rHyZ2F19Qo7N
   RDiwfRt2RmdH6fANJeAs36J82E6JTLlz1Zh4he1WSssbcFm6VHK+mQ/0S
   4/FSBlKgOXvHXHUz8IFb7dpooPaLLT0roYjUBnEKpPYP54pOdf3lXzwGi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="330829540"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="330829540"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 16:10:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="626144533"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="626144533"
Received: from dfiori-mobl1.amr.corp.intel.com (HELO [10.212.252.24]) ([10.212.252.24])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 16:10:03 -0700
Message-ID: <f6180914-2b63-29dd-8dc3-de48c4197769@intel.com>
Date:   Mon, 10 Oct 2022 16:10:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 2/3] x86/sgx: Introduce union with vepc_vaddr field for
 virtualization case
Content-Language: en-US
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        kai.huang@intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-3-zhiquan1.li@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220920063948.3556917-3-zhiquan1.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 9/19/22 23:39, Zhiquan Li wrote:
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -46,10 +46,12 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>  	if (epc_page)
>  		return 0;
>  
> -	epc_page = sgx_alloc_epc_page(vepc, false);
> +	epc_page = sgx_alloc_epc_page((void *)addr, false);
>  	if (IS_ERR(epc_page))
>  		return PTR_ERR(epc_page);

One thing not clear from the changelog: This actually changes the value
getting passed into sgx_alloc_epc_page() and set in the page->owner field.

What effect does this have?  If I apply these and run the tree at this
commit, what happens?  What behavior changes?

Was this 'vepc' value simply not used before?
