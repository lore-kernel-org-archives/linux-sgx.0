Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614FFC4332F
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Oct 2022 22:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJMWC5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiJMWC4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Oct 2022 18:02:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BBC189C08
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 15:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665698575; x=1697234575;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1yELgq6EsxYh7JGOJ92UjD3kJUVwAxC/G+rbtoDQpFQ=;
  b=TATgA83QXhSobGusBi8m/nWceV8ldNRjGLxjhDsxJ3j5ZyLo5nc7UbIG
   WUd8LoHRD5AiqUo6zbASDX1D3UzNuCG+t23NIH6sUR3KCbCCONDKd7ueJ
   YuowdlcTug/i3LMA6iqSc77fhOnUTsWYAfRYoqB690oo78VHyalBNzXsc
   nHtx4u4cVAoGvlsi6hmGsrxYlIjLDqCBUr2V+PLLg1XRJMHGGniKzKbIn
   g+Kf2KRYPa0MNJxykkYbTwjIG7dGSGlWeXd5oFpiwwquY5PrwpwWXKLG0
   uFdtf+JUYSpuZahkys0jcoqB0+9UYQh029r2sD/OsAk46ioH23pIRCUGw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="284942569"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="284942569"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 15:02:54 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="802408494"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="802408494"
Received: from mkucejko-mobl.ger.corp.intel.com (HELO [10.213.24.166]) ([10.213.24.166])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 15:02:49 -0700
Message-ID: <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
Date:   Thu, 13 Oct 2022 15:02:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
 <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
 <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
 <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
 <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
 <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
 <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/13/22 14:49, Huang, Kai wrote:
>> ... and what happens when *THIS* patch is in play?  What if there is a
>> machine check in SGX memory?
> With this patch, when #MC happens on one virtual EPC page, it will be send to
> the VM, and the behaviour inside a VM depends on guest's implementation.  But
> anyway based on Tony's reply, the enclave will be marked as "bad" by hardware
> and it will eventually be killed:
> 
> https://lore.kernel.org/linux-sgx/55ffd9475f5d46f68dd06c4323bec871@intel.com/
> https://lore.kernel.org/linux-sgx/5b6ad3e2af614caf9b41092797ffcd86@intel.com/
> 
> If the virtual EPC is shared by other VMs, the worst case is when other VMs use
> this bad EPC page (as we cannot take the bad EPC page out of VM for now), some
> SGX error (ENCLS/ENCLU error) or #MC could happen again.  But this doesn't make
> things worse, as when sharing virtual EPC page among VMs you are likely to break
> enclaves in VMs anyway (as mentioned above).

Guys, maybe I'm just not being specific enough.  But, Kai, you're off on
a tangent here that I didn't intend to ask about.  You're actually
adding confusion and delay here, not helping answer the question.

This was specifically a question about fork() plus VEPC plus machine
checks.  I'm still trying to get to the bottom of:

	What happens if a hypervisor *DOES* fork()?  What's the fallout?

Specifically, with this machine check SIGBUS implementation, one EPC
page can only have on host virtual address.  But, it's possible to
mmap() a single VEPC page in multiple processes at multiple host virtual
addresses.

So, the implementation only allows one host virtual address.  But, we
can imagine a scenario where there are *TWO* valid virtual addresses
where the VEPC is mapped.

What might happen in this case?  What's the fallout?
